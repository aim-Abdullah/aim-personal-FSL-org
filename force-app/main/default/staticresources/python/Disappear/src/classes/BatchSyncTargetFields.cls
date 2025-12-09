global class BatchSyncTargetFields extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {
    public String SOQL = 'select id,name, Current_Target__c from Publication__c ' +
        ' order by name desc';
    public BatchSyncTargetFields() {
        super();
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
        }
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchSyncTargetFields';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<publication__c> pubs){
        syncPubs(pubs);
    }
    
    public static void syncPubs(List<Publication__c> pubs) {
        List<Publication__c> pubsToUpdate = new List<Publication__c>();
        for (Publication__c pub : pubs) {
            AppearPubModel pubModel = new AppearPubModel(pub.Id);
            //if (string.IsBlank( pub.Current_Target__c )) { //update all Current_Target
                string currentTarget = pubModel.CurrentTarget;
                if (string.IsBlank(currentTarget)) {
                    currentTarget = pubModel.pubRecord.Add_Meeting_Journal__c;
                }
                if ( currentTarget <> null && currentTarget.length() > 255) {
                    pub.Current_Target__c = currentTarget.substring(254);
                } else {
                    pub.Current_Target__c = currentTarget;
                }
                pubsToUpdate.add(pub);
            //}
        }   
        
        if (pubsToUpdate.size() > 0) {
            update pubsToUpdate;
        }
        AppLogModel.flushLogs();
    }
    
    //BatchSyncTargetFields.syncOnePub('PubId-000000');
    public static void syncOnePub(string pubName){
        List<Publication__c> pubs = [
            select id,name, Current_Target__c
            from Publication__c 
            WHERE name = :pubName  
        ];
        
        syncPubs(pubs);
    }
    
    //BatchSyncTargetFields.runNow();
    public static void runNow(){
        BatchSyncTargetFields batch = new BatchSyncTargetFields();
        Database.executeBatch(batch, 20);
    }
    
    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
    }

//////////////////////////////////////////  unit test /////////////////////////////////////
    @isTest
    private static void unitTest() {
        CreateData();
        
        BatchSyncTargetFields.runNow();
    } 
    
    public static void CreateData() {
        Publication__c pub = UnitTestData.PublicationNew('TestingPublication1');
        Publication__c pub1 = UnitTestData.newPublication('TestingPublication2');
        
    }
}