trigger PubStudyTrigger on PubStudy__c (after delete, after insert) {
	if ( !AppearTriggerActivationModel.isPubStudyTriggerActive) {
		return;
	}
	
	if (Trigger.isInsert && Trigger.isAfter) {
		PubStudyTriggerLogic.PubStudyTriggerInsertOrDeleteLogic(trigger.new);
	}

	if (Trigger.isDelete && Trigger.isAfter) {
		PubStudyTriggerLogic.PubStudyTriggerInsertOrDeleteLogic(trigger.old);  
	}
}