global class BatchSyncTargetPubStatusToSC extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {
   	public String SOQL = 'select id,name, Current_Target__c from Publication__c ' +
    	' order by name desc ';
	public BatchSyncTargetPubStatusToSC() {
		super();
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
	}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchSyncTargetPubStatusToSC';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<publication__c> pubs){
    	syncPubs(pubs);
    }
    
    public static void syncPubs(List<Publication__c> pubs) {
    	//collect id of all pub to grab pubStatus
    	Set<id> pubIdset = new Set<id>();
    	for(Publication__c pub : pubs) {
    		pubIdset.add(pub.id);
    	}
    	
    	List<PubStatus__c> pubStatusList = [
    		select Submission_Cycle__c, Journal__c, Meeting__c, publication_id__r.name
    		from PubStatus__c
    		where Publication_Id__c in :pubIdset  
    	];
    	
    	Map<Id,PubStatus__c> ScPubStatusMap = new Map<Id,PubStatus__c>();
    	Set<Id> ScIdSet = new Set<Id>();
    	for(PubStatus__c pubstatus : pubStatusList) {
    		if (pubStatus.Journal__c <> null || pubStatus.Meeting__c <> null) {
    			ScPubStatusMap.put(pubstatus.Submission_Cycle__c, pubstatus);
    			ScIdSet.add(pubstatus.Submission_Cycle__c);
    		} else {
    			AppLogModel.LogError('BatchSyncTargetPubStatusToSC', 
    				' pubstatus of '+pubstatus.publication_id__r.name+' has no reference to journal or meeting');
    		}
    	}
    	
    	//now get all the Submission Cycles
    	List<SubmissionCycle__c> ScList = [
    		select id,name,Target_Type__c, Journal__c, Meeting__c
    		from SubmissionCycle__c  
    		where id in :ScIdSet
    		order by Submission_Cycle_Num__c  
    	];
    	
    	for(SubmissionCycle__c sc : ScList){
    		if ( ScPubStatusMap.containsKey(sc.id)){
    			PubStatus__c ps = ScPubStatusMap.get(sc.id);
    			sc.Journal__c = ps.Journal__c;
    			sc.Meeting__c = ps.Meeting__c;
    			if ( ps.Meeting__c <> null) {
    				sc.Target_Type__c = 'meeting';
    			} else {
    				sc.Target_type__c = 'journal';
    			}
    		} else {
  				AppLogModel.LogError('BatchSyncTargetPubStatusToSC', 
    				' ScPubStatusMap does not containsKey(sc.id) for '+sc.name);  			
    		}
    	}
    	
    	update ScList;
    	
    	for(id pubId : pubIdset) {
    		PublicationTriggerLogic.UpdateLatestPubStatusById(pubId, true);  
    	}
    	
    	//finally get all the pubs to update Current Target
    	List<Publication__c> pubList2 = [
    		select name, Current_Target__c, PubStatus__c, country__c,SubGroup__c,
    		PubStatus__r.Submission_Cycle__c, PubStatus__r.Submission_Cycle__r.TargetLabelFormula__c
    		from Publication__c
    		where id in :pubIdset
    	];
    	

    	for (Publication__c pub : pubList2) {
    		if (pub.PubStatus__r.Submission_Cycle__c <> null ) {
    			if (pub.PubStatus__r.Submission_Cycle__r.TargetLabelFormula__c <> null) {
					pub.Current_Target__c = pub.PubStatus__r.Submission_Cycle__r.TargetLabelFormula__c;
    			} else {
    				AppLogModel.LogError('BatchSyncTargetPubStatusToSC', 
    					pub.name +' pub.PubStatus__r.Submission_Cycle__r.TargetLabelFormula__c == null');
    			}
    		} else {
 				AppLogModel.LogError('BatchSyncTargetPubStatusToSC', 
					pub.name +' pub.PubStatus__r.Submission_Cycle__c == null');   			
    		}
    		if ( pub.SubGroup__c == SubGroupModelData.DevelopmentIrdSubGroup.id && pub.country__c == null) {
    			pub.country__c = CountryModel.Unknown.id;
    		}
    	}	
		update pubList2;

		AppLogModel.flushLogs();
    }
	
	//BatchSyncTargetPubStatusToSC.syncOnePub('Pub-Id-081125');
	public static void syncOnePub(string pubName){
		List<Publication__c> pubs = [
			select id,name, Current_Target__c
			from Publication__c 
			WHERE name = :pubName  
		];
		
		syncPubs(pubs);
	}
	
	//BatchSyncTargetPubStatusToSC.runNow();
	public static void runNow(){
    	BatchSyncTargetPubStatusToSC batch = new BatchSyncTargetPubStatusToSC();
        Database.executeBatch(batch, 50);
	}
    
    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}

//////////////////////////////////////////  unit test /////////////////////////////////////
	@IsTest
	Public static void unitTest() {
		AppearPubModel activePub = CreateData();
		
		BatchSyncTargetPubStatusToSC.syncOnePub(activePub.pubId);
		BatchSyncTargetPubStatusToSC.runNow();
	} 
	
	public static AppearPubModel CreateData() {
		RegionModelData.createData();
		CountryModelData.createData();
		
		DataSourceModelData.createData();
		SubGroupModelData.createData();
		
		MeetingModelData.createData();
		
		System.assertNotEquals(null, CountryModel.Unknown.id);
		System.assertNotEquals(null, SubGroupModelData.DevelopmentIrdSubGroup.id);
		
		Publication__c pub = UnitTestData.PublicationNew('pubtest');
		AppearPubModel activePub = new AppearPubModel(pub.id);
		activePub.SubmissionCycle.CurrentSubmissionCycle.Target_Type__c = 'meeting';
		activePub.SubmissionCycle.CurrentSubmissionCycle.Meeting__c = MeetingModel.getAllMeetingList()[0].id;
		
		update activePub.SubmissionCycle.CurrentSubmissionCycle;
		
		return activePub;
	}
}