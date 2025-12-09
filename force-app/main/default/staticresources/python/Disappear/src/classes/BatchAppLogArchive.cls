global class BatchAppLogArchive extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {
   	public static String SOQL = 'select CreatedTime__c, Description__c, ' +
   		'logSubjectId__c, LogType__c, Message__c, MessageType__c, PubId__c,  ' +
   		'Publication__c, RecordName__c, RecordURL__c '+
   		'from AppLog__c where CreatedTime__c <> LAST_N_DAYS:14'; 
   		
   	//changed archival limit to 2 weeks on 12/6/2013 with confirmation from Swapnil and Sesha
   	
	public BatchAppLogArchive() {
		super();
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	} else {
    		SOQL = SOQL + ' limit 10000';  //10k per batch max
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
	}
	
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchAppLogArchive';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<AppLog__c> logs){
		archiveAppLog(logs);
    }
    
    private static void archiveAppLog(List<AppLog__c> logs) {
    	
    	List<AppearLogArchive__c> logArchives = new List<AppearLogArchive__c>();
    	for (AppLog__c log : logs) {
    		logArchives.add(log2LogArchive(log));
    	}
    	
		Database.insert (logArchives, false);
    	Database.delete (logs, false);    	
    }
   
   
	public static  AppearLogArchive__c log2LogArchive ( AppLog__c log) {
		AppearLogArchive__c logArchive = new AppearLogArchive__c();
		logArchive.CreatedTime__c = log.CreatedTime__c;
		logArchive.Description__c = log.Description__c;
		logArchive.logSubjectId__c = log.logSubjectId__c;
		logArchive.LogType__c = log.LogType__c;
		logArchive.Message__c = log.Message__c;
		logArchive.MessageType__c = log.MessageType__c;
		logArchive.PubId__c = log.PubId__c;
		logArchive.Publication__c = log.Publication__c;
		logArchive.RecordName__c = log.RecordName__c;
		logArchive.RecordURL__c = log.RecordURL__c;
		
		return logArchive;
	}
   

    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchAppLogArchive.runNow();
	public static void runNow(){
    	BatchAppLogArchive batch = new BatchAppLogArchive();
        Database.executeBatch(batch, 1000);
	}	

//////////////////////////////////////////  unit test /////////////////////////////////////
	@isTest( seeAllData = true)
	private static void unitTest() {
		BatchAppLogArchive.runNow();
	} 
}