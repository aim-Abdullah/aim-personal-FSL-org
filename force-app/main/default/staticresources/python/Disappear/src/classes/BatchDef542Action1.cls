global class BatchDef542Action1 extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {
    public String SOQL = 'select id from PubStatus__c '+
        'where Status__r.name in (\'Accepted\', \'Published/Presented\') '+
        'and FPR_Cycle__c = null '+
        'and Submission_Cycle__c = null '+
        'and TargetDate__c = null ' +
        'and ActualDate__c = null';
    
    public BatchDef542Action1() {
        super();
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
        }
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchDef542Action1';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<PubStatus__c> pubs){
        ActionOneforPubs(pubs);
    }

    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
    }
    
    //BatchDef542Action1.runNow();
    public static void runNow(){
        BatchDef542Action1 batch = new BatchDef542Action1();
        Database.executeBatch(batch, 100);
    }
    
    public static void ActionOneforPubs(List<PubStatus__c> pubStatusList) {
        if ( pubStatusList == null) return;
        
        AppLogModel.LogInfo('BatchDef542Action1', 'Deleting '+pubStatusList.size()+' pubStatus with SC/FC/Actual_date/Target_date = null');
        Delete pubStatusList;
        AppLogModel.flushLogs();        
    }
    
    /*
    BatchDef542Action1.ActionOneForOnePub('Pub-Id-045948');
    BatchDef542Action1.ActionOneForOnePub('Pub-Id-044317');
    */
    public static void ActionOneForOnePub(string pubName){
        List<PubStatus__c> pubStatusList = [
            select id from PubStatus__c
            where Status__r.name in ('Accepted', 'Published/Presented')
            and FPR_Cycle__c = null
            and Submission_Cycle__c = null
            and TargetDate__c = null
            and ActualDate__c = null
            and publication_id__r.name = :pubName
        ];
        
        ActionOneforPubs(pubStatusList);
        
    }
    
    

//////////////////////////////////////////  unit test /////////////////////////////////////
    @isTest(seeAllData=true)
    private static void unitTest() {
        CreateData();
        Publication__c  newPub = UnitTestData.PublicationNew('Fpr Controller Pub');
        list<PubStatus__c> PubSt = new List<PubStatus__c>();
        BatchDef542Action1.runNow();
        BatchDef542Action1.ActionOneForOnePub(newPub.Name);
        BatchDef542Action1.ActionOneForPubs(pubst);
    } 
    
    public static void CreateData() {
        
    }
}