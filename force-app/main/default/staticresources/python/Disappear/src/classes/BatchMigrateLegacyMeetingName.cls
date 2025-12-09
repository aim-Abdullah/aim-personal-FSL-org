global class BatchMigrateLegacyMeetingName extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {

    public String SOQL = 'select MeetingName255__c, Meeting_name__c, Legacy_Meeting__c from Meeting__c';
    
    public BatchMigrateLegacyMeetingName() {
		super();
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchMigrateLegacyMeetingName';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    

    global void execute(Database.BatchableContext BC, List<Meeting__c> mtgs){
		for(Meeting__c mtg : mtgs) {
			if ( mtg.Meeting_Name__c == null && mtg.Legacy_Meeting__c <> null) {
        		mtg.Meeting_Name__c = mtg.Legacy_Meeting__c;
        	} else if ( mtg.Meeting_Name__c == null && mtg.Legacy_Meeting__c == null){
        		mtg.Meeting_Name__c = mtg.name;
        		mtg.Legacy_Meeting__c = mtg.name;
        	}
    		if ( mtg.Meeting_name__c <> null ) {
    			
    			if (  mtg.Meeting_name__c.length() < 255) {
    				mtg.MeetingName255__c = mtg.Meeting_name__c;
    			} else {
    				mtg.MeetingName255__c = mtg.Meeting_name__c.subString(0,254);
    			}
    		}
		}

		AppLogModel.flushLogs();
    }
    

    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchMigrateLegacyMeetingName.runNow();
	public static void runNow(){
    	BatchMigrateLegacyMeetingName batch = new BatchMigrateLegacyMeetingName();
        Database.executeBatch(batch, 1000);
	}

//////////////////////////////////////////  unit test /////////////////////////////////////
	
	private static testMethod void unitTest() {
		CreateData();
		
		BatchMigrateLegacyMeetingName.runNow();
	} 
	
	public static void CreateData() {
		MeetingModelData.createData();
	}
}