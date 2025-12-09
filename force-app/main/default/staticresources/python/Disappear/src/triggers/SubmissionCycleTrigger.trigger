trigger SubmissionCycleTrigger on SubmissionCycle__c (before insert, before update) {

	if (( Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore) {
		
		Set<id> publicationIdSet = new Set<id>();
		for(SubmissionCycle__c sc : trigger.new){
			publicationIdSet.add(sc.Publication__c);
		}
		
		List<publication__c> pubs = [select name from Publication__c where id in :publicationIdSet ];
		
		Map<string, string> pubNameMap = new Map<string,string>();
		for(publication__c pub : pubs) {
			pubNameMap.put(pub.id, pub.name);
		}
		
		for(SubmissionCycle__c sc : trigger.new){
			if ( pubNameMap.containsKey(sc.Publication__c)) {
				sc.Name = pubNameMap.get(sc.Publication__c) + '-SubCycle-'+ sc.Submission_Cycle_Num__c;
			} else {
				AppLogModel.LogError('SubmissionCycleTrigger', 'Cannot find reference for Publication__c ' + sc.Publication__c);
			}
		}
		AppLogModel.flushLogs();
	}	
}