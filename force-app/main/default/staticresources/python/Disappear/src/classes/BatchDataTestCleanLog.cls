global class BatchDataTestCleanLog extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {

	public String SOQL = 'select id ' +
			'from AppLog__c ' +
			'where MessageType__c like \'AppearDataTest::%\' ';

   	public BatchDataTestCleanLog() { //find pubs routed or discussion required status with fpr date due today or 2 days ago
		super();
		
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
        
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchDataTestCleanLog';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> recs){
    	delete recs;
    }
    
    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchDataTestCleanLog.runNow();
	public static void runNow(){
    	BatchDataTestCleanLog batch = new BatchDataTestCleanLog();
        Database.executeBatch(batch, 2000);
	}
   	  
    @IsTest
    public static void UnitTest() {
    	AppLogModel.LogInfo('AppearDataTest::', 'a log');
    	AppLogModel.flushLogs();
    	
    	BatchDataTestCleanLog.runNow(); 
    	

    }  
    

   	  
}