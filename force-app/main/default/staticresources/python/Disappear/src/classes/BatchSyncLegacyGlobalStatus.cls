global class BatchSyncLegacyGlobalStatus extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {
   	public String SOQL = 'select id,name,Current_SubmissionCycle_Id_Formula__c,Current_FPRCycle_Id_Formula__c, Current_FPR_Cycle_Num__c from Publication__c  order by name desc';
	public BatchSyncLegacyGlobalStatus() {
		super();
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
	}
	
   	private static Set<id> createdByIdsToInclude{
   		get{	
			return RecordTypeModel.LegacyInProgressPubRecordIdSet;
   		}
   	}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchSyncLegacyGlobalStatus';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<publication__c> pubs){
		syncPubs(pubs);
    }

    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchSyncLegacyGlobalStatus.runNow();
	public static void runNow(){
    	BatchSyncLegacyGlobalStatus batch = new BatchSyncLegacyGlobalStatus();
        Database.executeBatch(batch, 10);
	}
	
	public static void syncPubs(List<publication__c> pubs) {
		List<PubStatus__c> newStatusList = new List<PubStatus__c>();
		
    	for(Publication__c pub : pubs) {
    		checkPubStatus(pub.id);
    	}    		
    		
		AppLogModel.flushLogs();		
	}
	
	public static void checkPubStatus(Id pubId) {
		AppearPubModel activePub = new AppearPubModel(pubid);
		if ( RecordTypeModel.LegacyPubRecordIdSet.contains(activePub.pubRecord.RecordTypeId)) {
			activePub.pubRecord.RecordTypeId = 	RecordTypeModel.PublicationSuggestionRecTypeId;
			//just get out of legacy Type
			update activePub.PubRecord;
		}
		
		List<PubStatus__c> newStatusForPub = new List<PubStatus__c>();
		
		//find all existing status	
		List<PubStatus__c> existingPubStatuses = [ 
				select Status__c, Status__r.id, Status__r.name, 
				Submission_Cycle__c, Submission_Cycle__r.Submission_Cycle_Num__c,Submission_Cycle_Num_Formula__c, 
				FPR_Cycle__c, FPR_Cycle__r.FPR_Cycle_Num__c, FPR_Cycle_Num_Formula__c
				from PubStatus__c
				where Publication_id__c = :pubId 
				and IsLogicallyDeleted__c = false
			];
		
		
		
		//sc1 - fc0
		SubmissionCycle__c firstSubmissionCycle = activePub.SubmissionCycle.getSubmissionCycleByNum(1);
		//create a set 
		Set<String> existingInitialGlobalStatus = new Set<String>();
		for(PubStatus__c ps : existingPubStatuses) {
			if ( ps.FPR_Cycle__c == null && ps.Submission_Cycle__c == firstSubmissionCycle.id ) {
				existingInitialGlobalStatus.add(ps.status__r.name);
			}
		}
		
		for(Status__c status : StatusModel.GlobalStatusList){
			if (status.displayOrder__c < StatusModel.InFpr.displayOrder__c &&  !existingInitialGlobalStatus.contains(status.name) ) {
				PubStatus__c newPubStatus = new PubStatus__c();
				newPubStatus.Publication_id__c = pubId;   
				newPubStatus.Status__c = status.id;
				newPubStatus.Submission_Cycle__c = firstSubmissionCycle.id;
				newPubStatus.Fpr_Cycle__c = null;
				newStatusForPub.add(newPubStatus);
			}
		}	
		
		insert newStatusForPub;

		//reset FPR_Cycle__c to Null - just in case Trigger copy the Current FPR cycle to the newly inserted PubStatus
		List<PubStatus__c> preFprPubStatus = [
			select Fpr_Cycle__c 
			from PubStatus__c 
			where Publication_id__c = :PubId
			and Submission_Cycle__c = :firstSubmissionCycle.id
			and Status__r.displayOrder__c < :StatusModel.InFpr.displayOrder__c
		];
		for(PubStatus__c ps : newStatusForPub) {
			ps.Fpr_Cycle__c = null;
		}
		update newStatusForPub;
		
		
		//reset for lastFC
		newStatusForPub =  new List<PubStatus__c>();
		
		
		//then last SC / last FC
		integer maxSC = 1;
		integer maxFC = 0;
		for(PubStatus__c ps : existingPubStatuses) {
			integer currSC = Integer.ValueOf(ps.Submission_Cycle__r.Submission_Cycle_Num__c);
			if ( currSC > maxSC) {
				maxSC = currSc;
			}
			if ( ps.FPR_Cycle__c  <> null) {
				if ( Integer.valueOf(ps.FPR_Cycle_Num_Formula__c)  > maxFC) {
					maxFC = Integer.valueOf(ps.FPR_Cycle_Num_Formula__c);
				}
			}
		}
		
		if ( maxFC > 0 ) {
			SubmissionCycle__c maxSubmissionCycle = activePub.SubmissionCycle.getSubmissionCycleByNum(maxSC);
			FPR_Cycle__c maxFprCycle = activePub.FprCycle.getFprCycleByNum(maxFC);
			
			//handle the Post Submit To FPR Status
			Set<String> existingPostSubmitGlobalStatus = new Set<String>();
			for(PubStatus__c ps : existingPubStatuses) {
				if ( ps.FPR_Cycle__c <> null && ( Integer.valueOf(ps.FPR_Cycle_Num_Formula__c) == maxFC && ps.Submission_Cycle_Num_Formula__c == maxSC)  ) {
					existingPostSubmitGlobalStatus.add(ps.status__r.name);
				}
			}
			for(Status__c status : StatusModel.GlobalStatusList){
				if (status.displayOrder__c >= StatusModel.InFpr.displayOrder__c &&  !existingPostSubmitGlobalStatus.contains(status.name) ) {
					PubStatus__c newPubStatus = new PubStatus__c();
					newPubStatus.Publication_id__c = pubId;   
					newPubStatus.Status__c = status.id;
					newPubStatus.Submission_Cycle__c = maxSubmissionCycle.id;
					newPubStatus.Fpr_Cycle__c = maxFprCycle.id;
					newStatusForPub.add(newPubStatus);
				}
			}	
			
		}	
		insert newStatusForPub;
		
		//reload
		activePub = new AppearPubModel(pubid);
		PublicationTriggerLogic.UpdateLatestPubStatus(activePub.pubRecord, true); 
	}
	
	/*
	BatchSyncLegacyGlobalStatus.syncOnePub('Pub-Id-079255');
	BatchSyncLegacyGlobalStatus.syncOnePub('Pub-Id-060989');
	*/
	public static void syncOnePub(string pubName){
		List<Publication__c> pubs = [
			select id,name, Current_SubmissionCycle_Id_Formula__c, Current_FPRCycle_Id_Formula__c
			from Publication__c 
			WHERE name = :pubName  
		];
		
		syncPubs(pubs);
		
	}
	
	

//////////////////////////////////////////  unit test /////////////////////////////////////
	@isTest
	private static void unitTest() {
		CreateData();
		
		BatchSyncLegacyGlobalStatus.runNow();
	} 
	
	public static void CreateData() {
		StatusModelData.createData();
		
		UnitTestData.PublicationNew('BatchSyncLegacyGlobalStatus');
	}
}