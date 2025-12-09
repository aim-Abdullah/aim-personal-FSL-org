trigger PubAuthorTrigger on pubAuthor__c (after delete, after insert, after update) {
	if ( !AppearTriggerActivationModel.isPubAuthorTriggerActive || AppearTriggerActivationModel.shouldSkipPubAuthorTrigger) {
		return;
	}
	
	if (Trigger.isInsert && Trigger.isAfter) {
		PubAuthorTriggerLogic.PubAuthorTriggerInsertOrDeleteLogic(trigger.new);	
    }
	
	if (Trigger.isUpdate && Trigger.isAfter) {
		List <pubAuthor__c> changedAuthorList = new List <pubAuthor__c>();
		
		for (pubAuthor__c newPubAuthor: trigger.new )
		{
			for (pubAuthor__c oldPubAuthor:  trigger.old)
			{
				if (newPubAuthor.id == oldPubAuthor.Id  )
				{
					//Consider the ONLY the final record i.e. only when the Author Status Value has changed.
					if (newPubAuthor.AuthorStatus__c != oldPubAuthor.AuthorStatus__c ){
						changedAuthorList.add(newPubAuthor);
					}					
				}
			}
			
			PubAuthorTriggerLogic.PubAuthorTriggerInsertOrDeleteLogic(changedAuthorList);						
		}
	}
	
	if (Trigger.isDelete && Trigger.isAfter) {
		PubAuthorTriggerLogic.PubAuthorTriggerInsertOrDeleteLogic(trigger.old);  
	}
}