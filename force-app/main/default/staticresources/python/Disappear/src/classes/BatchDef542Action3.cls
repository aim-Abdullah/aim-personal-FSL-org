global class BatchDef542Action3 extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {
    public String SOQL = 'select id, FPR_Cycle__c,Submission_Cycle__c, Submission_Cycle_Num_Formula__c, Publication_id__c from PubStatus__c '+
        'where Submission_Cycle_Num_Formula__c > 1.0 '+
        'and FPR_Cycle__c = null ';
    
    public BatchDef542Action3() {
        super();
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
        }
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchDef542Action3';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<PubStatus__c> pubs){
        ActionThreeforPubs(pubs);
    }

    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
    }
    
    //BatchDef542Action3.runNow();
    public static void runNow(){
        BatchDef542Action3 batch = new BatchDef542Action3();
        Database.executeBatch(batch, 20);
    }
    
    public static void ActionThreeforPubs(List<PubStatus__c> pubStatusList) {
        if ( pubStatusList == null) return;
        
        for(PubStatus__c ps : pubStatusList) {
            AppearPubModel activePub = new AppearPubModel(ps.Publication_id__c);
            if ( activePub <> null && activePub.hasValidPub && activePub.hasEditAccess) {   
                Integer ScCycleNum = Integer.valueOf(ps.Submission_Cycle_Num_Formula__c);
                ps.FPR_Cycle__c = activePub.FprCycle.getFprCycleByNum(ScCycleNum).id;
            }
        }
        update pubStatusList;
        AppLogModel.flushLogs();        
    }
    
    /*
    BatchDef542Action3.ActionThreeForOnePub('Pub-Id-079255');
    */
    public static void ActionThreeForOnePub(string pubName){
        List<PubStatus__c> pubStatusList = [
            select id, FPR_Cycle__c,Submission_Cycle__c, Submission_Cycle_Num_Formula__c, Publication_id__c 
            from PubStatus__c
            where Submission_Cycle_Num_Formula__c > 1.0
            and FPR_Cycle__c = null
            and publication_id__r.name = :pubName
        ];
        
        ActionThreeforPubs(pubStatusList);
        
    }
    
    

//////////////////////////////////////////  unit test /////////////////////////////////////
    @isTest(seeAllData=true)
    private static void unitTest() {
        CreateData();
        Publication__c  newPub = UnitTestData.PublicationNew('Fpr Controller Pub');
        list<PubStatus__c> PubSt = new List<PubStatus__c>();
        BatchDef542Action3.runNow();
        BatchDef542Action3.ActionThreeForOnePub(newPub.Name);
        BatchDef542Action3.ActionThreeForPubs(pubst);
    } 
    
    public static void CreateData() {
        
    }
}