trigger PublicationTrigger on Publication__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

	if ( !AppearTriggerActivationModel.isPublicationTriggerActive) {
		return;
	}
	  

	if (Trigger.isInsert  && Trigger.isBefore) {
		//trigger to set default value for publication after insert or update
		PublicationTriggerLogic.PubBeforeUpsertTriggerLogic(trigger.new, null);		
	}	 
  
  	if (Trigger.isUpdate && Trigger.isBefore) {
		//trigger to set default value for publication after insert or update
		PublicationTriggerLogic.PubBeforeUpsertTriggerLogic(trigger.new, trigger.oldMap);		
	}
  
  
	if (Trigger.isInsert && Trigger.isAfter) {		 
		
		//After creation of a publicaiton record - insert the global status
		//auto-insert the initial status for 
		//1 - GPPL     -> StatusModel.ConceptStatus
		//2 - FPR Only -> StatusModel.FprOnlyStatus
		//3 - all else -> StatusModel.PendingSuggestionStatus	
		//set the record type
		PublicationTriggerLogic.PubAfterInsertTriggerLogic(trigger.new);
		/*Implemented as part of Release 1 Appear Enhancment*/
		//Adding the Cloned user, if External Writer profile , auto assign to Writer Role
		if(ProfileModel.isAppearExternalWriter){
        	PublicationTriggerLogic.addWritingRoleForExternalWriter(Trigger.new);
		}
	} 
	AppLogModel.flushLogs(); 

}