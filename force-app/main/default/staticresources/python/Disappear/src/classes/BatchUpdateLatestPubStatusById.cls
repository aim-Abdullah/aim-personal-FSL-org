global class BatchUpdateLatestPubStatusById extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {
    public String SOQL = 'select id from Publication__c';
    
    public BatchUpdateLatestPubStatusById() {
        super();
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
        }
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchUpdateLatestPubStatusById';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<Publication__c> pubs){
        for(Publication__c pub : pubs) {
            PublicationTriggerLogic.UpdateLatestPubStatus(pub, true); 
        }
    }

    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
    }
    
    //BatchUpdateLatestPubStatusById.runNow();
    public static void runNow(){
        BatchUpdateLatestPubStatusById batch = new BatchUpdateLatestPubStatusById();
        Database.executeBatch(batch, 20);
    }
    
//////////////////////////////////////////  unit test /////////////////////////////////////
    @isTest()
    private static void unitTest() {
        CreateData();
        
        BatchUpdateLatestPubStatusById.runNow();
    } 
    
    public static void CreateData() {
        Publication__c pub = UnitTestData.PublicationNew('TestingPublication1');
        Publication__c pub1 = UnitTestData.newPublication('TestingPublication2');
        
    }
}