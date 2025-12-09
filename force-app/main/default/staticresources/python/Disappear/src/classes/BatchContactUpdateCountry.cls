global class BatchContactUpdateCountry extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {
    public String SOQL = 'select id, name, Location_Code__c, Country__c from Contact ';
    

    
    public BatchContactUpdateCountry() {
        super();
        
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
        } 
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchContactUpdateCountry';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<Contact> contacts){
        
        List<contact> updateContactList = new List<contact>();
        for(Contact c : contacts) {
            if ( c.Location_Code__c <> null && c.Location_Code__c.startsWith('US')) {
                c.Country__c = 'United States';
                updateContactList.add(c);
            }
        }
        
        update updateContactList;
        AppLogModel.flushLogs();
    } 

    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
        
        //release 2.1 - change as discussed with Sesha
        //invoke the BatchUpdateUsBasedAuthor in a chain.
        BatchUpdateUsBasedAuthor.runNow();
    }
    
    //BatchContactUpdateCountry.runNow();
    public static void runNow(){
        BatchContactUpdateCountry batch = new BatchContactUpdateCountry();
        Database.executeBatch(batch, 200);
    }

//////////////////////////////////////////  unit test /////////////////////////////////////
    @isTest
    private static void unitTest() {
        CreateData();
        
        BatchContactUpdateCountry.runNow();
    } 
    
    public static void CreateData() {

    }
}