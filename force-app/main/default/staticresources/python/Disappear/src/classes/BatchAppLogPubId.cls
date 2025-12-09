global class BatchAppLogPubId extends BatchBase
	implements Database.Batchable<SObject>,Database.Stateful {
   	public static String SOQL = 'select logSubjectId__c, pubId__c ' +
   		'from AppLog__c  ';
   	
	public BatchAppLogPubId() {
		super();
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	} else {
    		//BL made change during rel 2.0 rollout to avoid scanning 8M rows of AppLog
    		SOQL = SOQL + ' where pubId__c = null order by createdDate desc ' 
    			+ 'limit 1000000';  //100k max per batch max
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
	}
	
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchAppLogPubId';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<AppLog__c> logs){
		updatelog(logs);
    }  
    
    private static void updateLog(List<AppLog__c> logs) {
    	set<id> pubIds = new set<id>();
    	for (AppLog__c log : logs){
    		pubIds.add(log.logSubjectId__c);
    	}
		List<publication__c> pubs = [select id, Name from Publication__c where id in :pubIds];
		
		Map<id,string> pubIdMap = new Map<id,string>();
		for(publication__c pub : pubs) {
			pubIdMap.put(pub.id, pub.name);
		}
		
		for (AppLog__c log : logs){
    		if (pubIdMap.containsKey(log.logSubjectId__c) ) {
    			log.pubId__c = pubIdMap.get(log.logSubjectId__c);
    		} else {
    			log.pubId__c = 'N/A';
    		}
    	}
    	database.update(logs, false);    	
    }
    
    //BatchAppLogPubId.updatePubIdNow();    
    global static void updatePubIdNow() {
    	String onDemandSOQL = SOQL + ' limit 10000 ';
		List<AppLog__c> logs = Database.query(onDemandSOQL); 
		updateLog(logs);	
    }

    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
		BatchAppLogArchive.runNow();
	}
	
	//BatchAppLogPubId.runNow();
	public static void runNow(){
    	BatchAppLogPubId batch = new BatchAppLogPubId();
        Database.executeBatch(batch, 1000);
	}	

//////////////////////////////////////////  unit test /////////////////////////////////////
	@isTest( seeAllData = true)
	private static void unitTest() {
		BatchAppLogPubId.updatePubIdNow();
		BatchAppLogPubId.runNow();
	} 
}