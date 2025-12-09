global class BatchInflightPubStatusAdj1 extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {
   	public String SOQL = 'select Publication__c, Publication__r.name from InflightPubsAtGoLive__c where Publication__r.name <> \'Pub-Id-033625\'  '; 
   	
	public BatchInflightPubStatusAdj1() {
		super();
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 1';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
	}
	
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchInflightPubStatusAdj1';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<InflightPubsAtGoLive__c> pubs){
		InflightPubAdj1(pubs);
    }

    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchInflightPubStatusAdj1.runNow();
	public static void runNow(){
    	BatchInflightPubStatusAdj1 batch = new BatchInflightPubStatusAdj1();
        Database.executeBatch(batch, 2);
	}
	
	public static void InflightPubAdj1(List<InflightPubsAtGoLive__c> inflightPubList) {
		for(InflightPubsAtGoLive__c inflightPub : inflightPubList) {
			InflightPubAdj1OnePub(inflightPub.Publication__c);
		}
	}
	

	public static void InflightPubAdj1OnePub(Id pubId){
		AppearPubModel activePub = new AppearPubModel(pubId);
		
		if ( activePub.CurrentStatus == 'Assigned to FPRC') {
			List<PubReviewTeam__c> reviewers = activePub.PubReviewTeam.PubReviewTeamMembers;
			if ( reviewers.size() > 0) {
				AppLogModel.LogINfo('BatchInflightPubStatusAdj1', 'Inserting Routed Status for this Pub '+activePub.PubName);
				
				for(PubStatus__c pubstatus : activePub.PubStatus.PubStatusList) {
				
					if ( pubstatus.status__c == statusModel.InFpr.id) {
						DateTime routeDateTime = pubstatus.ActualDate__c;
						routeDateTime = routeDateTime.addSeconds(1);
						activePub.PubStatus.InsertRoutePubStatus(routeDateTime);
					}
				}
			}
		}
		
		AppLogModel.flushLogs();
	}
	
	 

//////////////////////////////////////////  unit test /////////////////////////////////////
	@isTest(seeAllData=true)
	private static void unitTest() {
		
		BatchInflightPubStatusAdj1.runNow();
	} 
	

}