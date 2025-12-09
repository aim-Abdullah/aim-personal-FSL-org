public with sharing class PubStudyTriggerLogic {
	
	public static void PubStudyTriggerInsertOrDeleteLogic(List<PubStudy__c> newList) {
		if ( newList == null || newList.size() == 0) {
			return;
		}
	
		//create a unique set of Publication Id from Input 
		set<Id> pubIdSet = new set<Id>();
		Map<id,boolean> pubPassValueMap = new Map<id,boolean>();
		for ( PubStudy__c pubStudy : newList){
			pubIdSet.add(pubStudy.Publication__c);
			pubPassValueMap.put(pubStudy.Publication__c, false);  //default all to false
		}
		
		//retrieve all pubStudies to check AuthorCountry
		List<PubStudy__c> pubStudies = [
			select id, Pass__c, Publication__c
			from PubStudy__c
			where Publication__c in :pubIdSet	
		];

		for(PubStudy__c pubStudy : pubStudies) {
			if ( pubStudy.PASS__c ) {
				pubPassValueMap.put(pubStudy.Publication__c, true);
			} 
		}
		
		//finally retrieve the set of pub to update
		List<publication__c> pubList = [
			Select id, Pass__c, name
			FROM Publication__c 
			WHERE id in :pubIdSet
		];
	
		for ( publication__c pub : pubList) {
			if (pubPassValueMap.get(pub.id)) {
				pub.Pass__c = true;
				AppLogModel.LogDebug('PubStudyTriggerLogic::PASS Sync', pub.name + ' has PASS__c = true', pub.Id);
			} else {
				pub.Pass__c = false;
				AppLogModel.LogDebug('PubStudyTriggerLogic::PASS Sync', pub.name + ' has PASS__c = false', pub.Id);
			}
		}
		
		update pubList;
		
		AppLogModel.flushLogs();
		
	}
}