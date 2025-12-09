trigger PubStatusTrigger on PubStatus__c (before insert,  after insert, before update, after update) {

	if ( !AppearTriggerActivationModel.isPubStatusTriggerActive) {
		return;
	}

	if (Trigger.isInsert  && Trigger.isBefore) {
		PubStatusTriggerLogic.PubStatusTriggerBeforeInsert(trigger.new);
	}  
	 
	if (Trigger.isInsert && Trigger.isAfter) {
		PubStatusTriggerLogic.PubStatusTriggerAfterInsert(trigger.newMap);
	}

	if (Trigger.isUpdate && Trigger.isBefore) {
		PubStatusTriggerLogic.PubStatusTriggerBeforeUpdate(trigger.newMap, trigger.oldMap);  
	}

	if (Trigger.isUpdate && Trigger.isAfter) {
		AppLogModel.LogInfo('PubStatusTrigger', 'After Update firing');
		PubStatusTriggerLogic.PubStatusTriggerAfterUpdate(trigger.newMap, trigger.oldMap);
	}
 
	AppLogModel.flushLogs();
}