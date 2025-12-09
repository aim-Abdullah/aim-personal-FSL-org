global class BatchAppLogArchiveTruncate extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {
   	public static String SOQL = 'select id from AppearLogArchive__c'; 
   	
	public BatchAppLogArchiveTruncate() {
		super();
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	} else {
    		SOQL = SOQL + ' limit 1000000';  //1M per batch max
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
	}
	
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchAppLogArchiveTruncate';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<AppearLogArchive__c> logs){
		delete logs;
    }
    
   
    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchAppLogArchiveTruncate.runNow();
	public static void runNow(){
    	BatchAppLogArchiveTruncate batch = new BatchAppLogArchiveTruncate();
        Database.executeBatch(batch, 2000);
	}	

//////////////////////////////////////////  unit test /////////////////////////////////////
	@isTest( seeAllData = true)
	private static void unitTest() {
		BatchAppLogArchiveTruncate.runNow();
	} 
}