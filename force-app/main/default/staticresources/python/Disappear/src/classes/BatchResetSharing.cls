global class BatchResetSharing extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {

    public String SOQL = 'select id,name from Publication__c ' +
    	' order by name desc';
    
    public BatchResetSharing() {
		super();
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchResetSharing';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    

    global void execute(Database.BatchableContext BC, List<publication__c> pubs){
		for(publication__c pub : pubs) {
			AppearPubModel.resetSharing(pub.id);
		}

		AppLogModel.flushLogs();
    }
    

    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchResetSharing.runNow();
	public static void runNow(){
    	BatchResetSharing batch = new BatchResetSharing();
        Database.executeBatch(batch, 15);
	}

//////////////////////////////////////////  unit test /////////////////////////////////////
	
	private static testMethod void unitTest() {
		CreateData();
		
		BatchResetSharing.runNow();
	} 
	
	public static void CreateData() {
		
	}
}