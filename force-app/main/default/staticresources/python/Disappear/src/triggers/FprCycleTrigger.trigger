trigger FprCycleTrigger on FPR_Cycle__c (before insert, before update) {

	if (( Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore) {
		
		Set<id> publicationIdSet = new Set<id>();
		for(FPR_Cycle__c fc : trigger.new){
			publicationIdSet.add(fc.Publication__c);
		}
		
		List<publication__c> pubs = [select name from Publication__c where id in :publicationIdSet ];
		
		Map<string, string> pubNameMap = new Map<string,string>();
		for(publication__c pub : pubs) {
			pubNameMap.put(pub.id, pub.name);
		}
			
		for(FPR_Cycle__c fc : trigger.new){
			if ( pubNameMap.containsKey(fc.Publication__c)) {
				fc.Name = pubNameMap.get(fc.Publication__c) + '-FprCycle-'+ fc.FPR_Cycle_Num__c;
				
				//This required to be reset based on the Defect 46 in APPEAR 4.0, otherwise Author will never be able to 
				//see the publication in the Review Queue Tab because it was approved in the previous FPR Cycle.
				AppearTriggerActivationModel.shouldSkipPubAuthorTrigger = true;
				PubAuthorModel.resetAuthorApprovalsForNextFPRCycle(fc.Publication__c);
				AppearTriggerActivationModel.shouldSkipPubAuthorTrigger = false;
			} else {
				AppLogModel.LogError('FprCycleTrigger', 'Cannot find reference for Publication__c ' + fc.Publication__c);	
			}
		}
		AppLogModel.flushLogs();
	}	
}