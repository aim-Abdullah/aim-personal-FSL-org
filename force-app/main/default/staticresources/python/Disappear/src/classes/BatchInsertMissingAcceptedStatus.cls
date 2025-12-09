global class BatchInsertMissingAcceptedStatus{
	public static void test() {
		Map<id, Publication__c> pubMap = new Map<id, Publication__c>( [select id, Current_SubmissionCycle_Id_Formula__c from publication__c where id not in (select Publication_id__c from PubStatus__c where Status__r.Name = 'Accepted') AND id in (select Publication_id__c from PubStatus__c where Status__r.Name = 'Published/Presented')]);

		Map<id, id> pubIdFprCycleIdMap = new Map<id, id>();
		for(PubStatus__c publishedStatus : [select FPR_Cycle__c, Publication_id__c FROM PubStatus__c where Status__r.Name = 'Published/Presented' AND Publication_id__c in : pubMap.keySet()]) {
			pubIdFprCycleIdMap.put(publishedStatus.Publication_id__c,publishedStatus.FPR_Cycle__c);
		}
		
		List<PubStatus__c> statusesToInsert = new List<PubStatus__c>();
		for(Id pubId : pubMap.keyset()) {
		    if (pubIdFprCycleIdMap.containsKey(pubId)) {        
		        Id fprCycleId = pubIdFprCycleIdMap.get(pubId);
		        Id subCycleId = pubMap.get(pubId).Current_SubmissionCycle_Id_Formula__c;
		        
                PubStatus__c newAcceptedPubStatus = new PubStatus__c();
		        newAcceptedPubStatus.Publication_id__c = pubId;   
		        newAcceptedPubStatus.ActualDate__c = null;
		        newAcceptedPubStatus.Status__c = StatusModel.Accepted.id;
		        newAcceptedPubStatus.Submission_Cycle__c = subCycleId;
		        newAcceptedPubStatus.FPR_Cycle__c = fprCycleId;
		        
		        statusesToInsert.add(newAcceptedPubStatus);
		    }
		}
		
		if (statusesToInsert.size() > 0) {
			insert statusesToInsert;
		}
	}
}