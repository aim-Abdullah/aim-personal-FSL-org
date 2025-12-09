global class BatchDef542Action2 extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {
    public String SOQL = 'select id, FPR_Cycle__c,Submission_Cycle__c, Publication_id__c from PubStatus__c '+
        'where Status__r.name in (\'Accepted\', \'Published/Presented\') '+
        'and ( TargetDate__c <> null or ActualDate__c <> null ) ' +
        'and FPR_Cycle__c = null ' +
        'and Submission_Cycle__c = null';
    
    public BatchDef542Action2() {
        super();
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
        }
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchDef542Action2';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<PubStatus__c> pubs){
        ActionTwoforPubs(pubs);
    }

    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
    }
    
    //BatchDef542Action1.runNow();
    public static void runNow(){
        BatchDef542Action2 batch = new BatchDef542Action2();
        Database.executeBatch(batch, 10);
    }
    
    public static void ActionTwoforPubs(List<PubStatus__c> pubStatusList) {
        if ( pubStatusList == null) return;
        
        for(PubStatus__c ps : pubStatusList) {
            AppearPubModel activePub = new AppearPubModel(ps.Publication_id__c);
            if ( activePub <> null && activePub.hasValidPub && activePub.hasEditAccess) {
                ps.FPR_Cycle__c = activePub.FprCycle.getFprCycleByNum(1).id;
                ps.Submission_Cycle__c = activePub.SubmissionCycle.getSubmissionCycleByNum(1).id;
            }
        }
        update pubStatusList;
        AppLogModel.flushLogs();        
    }
    
    /*
    BatchDef542Action2.ActionTwoForOnePub('Pub-Id-079255');
    */
    public static void ActionTwoForOnePub(string pubName){
        List<PubStatus__c> pubStatusList = [
            select id, FPR_Cycle__c,Submission_Cycle__c, Publication_id__c 
            from PubStatus__c
            where Status__r.name in ('Accepted', 'Published/Presented')
            and ( TargetDate__c <> null or ActualDate__c <> null ) 
            and FPR_Cycle__c = null 
            and Submission_Cycle__c = null
            and publication_id__r.name = :pubName
        ];
        
        ActionTwoforPubs(pubStatusList);
        
    }
    
    

//////////////////////////////////////////  unit test /////////////////////////////////////
    @isTest(seeAllData=true)
    private static void unitTest() {
        CreateData();
        Publication__c  newPub = UnitTestData.PublicationNew('Fpr Controller Pub');
        list<PubStatus__c> PubSt = new List<PubStatus__c>();
        
        
        BatchDef542Action2.runNow();
        BatchDef542Action2.ActionTwoForOnePub(newPub.Name);
        BatchDef542Action2.ActionTwoForPubs(pubst);
    } 
    
    public static void CreateData() {
        
    }
}