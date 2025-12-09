//BatchDef541- When Latest Target Submission Date [RevisedTargetDate__c] is NOT NULL on Submitted/Completed Status– create a reason forchange in 
//'Legacy Publication - Reason For Change not available".


global class BatchDef541 extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {
   	public String SOQL = 'select id, Reason_For_Change__c, RevisedTargetDate__c from PubStatus__c '+
		'where Status__r.name = \'Submitted/Completed\' '+
		'and RevisedTargetDate__c <> null ';
   	
	public BatchDef541() {
		super();
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
	}
	
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchDef541';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<PubStatus__c> pubs){
		ActionforPubs(pubs);
    }

    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchDef541.runNow();
	public static void runNow(){
    	BatchDef541 batch = new BatchDef541();
        Database.executeBatch(batch, 50);
	}
	
	public static void ActionforPubs(List<PubStatus__c> pubStatusList) {
		if ( pubStatusList == null) return;
		
		for (PubStatus__c pub :  pubStatusList) {
			Date RevisedTargetDate = Date.ValueOf(pub.RevisedTargetDate__c);
			pub.Reason_For_Change__c = 'Legacy Publication - Reason For Change not available. ['+ RevisedTargetDate.Format() +']';
		}
		
		AppLogModel.LogInfo('BatchDef541', 'updating reason for changes '+pubStatusList.size()+' pubStatus with latest Target_date = null');
		database.update(pubStatusList, true);
		
		AppLogModel.flushLogs();		
	}
	
	/*
	BatchDef541.ActionForOnePub('Pub-Id-037085');
	*/
	public static void ActionForOnePub(string pubName){
		List<PubStatus__c> pubStatusList = [
			select id, Reason_For_Change__c, RevisedTargetDate__c 
			from PubStatus__c 
			where Status__r.name = 'Submitted/Completed' 
			and RevisedTargetDate__c <> null 
			and publication_id__r.name = :pubName
		];
		
		ActionforPubs(pubStatusList);
		
	}
	
	
//////////////////////////////////////////  unit test /////////////////////////////////////
	@isTest
	private static void unitTest() {
		CreateData();
		
		BatchDef541.runNow();
	} 
	
	public static void CreateData() {
		Publication__c pub = UnitTestData.PublicationNew('TestBatchDef541');
		
		AppearPubModel activePub = new AppearPubModel(pub.id);
		System.assertNotEquals(null, activePub);
		
		List<PubStatus__c> pubStatusList = activePub.PubStatus.PubStatusList;
		for(PubStatus__c pubStatus : pubStatusList) {
			if ( pubStatus.Status__r.name == 'Submitted/Completed') {
				pubStatus.RevisedTargetDate__c = Date.Today();
				
				update pubStatus;
			}
		}
		
	}
}