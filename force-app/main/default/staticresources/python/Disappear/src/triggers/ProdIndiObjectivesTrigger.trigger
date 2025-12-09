/*******************************************************************************************************
 * $Id$ : ProdIndiObjectivesTrigger
 * $Created Date$ : 2014/04/11
 * $Author$ : Sesha Kurmana
 * $Description$ : This class is used to incorporate logic for handling updates on ProdIndiObjective__c. 
 *******************************************************************************************************/
trigger ProdIndiObjectivesTrigger on ProdIndiObjective__c (after update) {
	if ( !AppearTriggerActivationModel.isProdIndiObjectivesTriggerActive) {
		return;
	}
	
	if (Trigger.isUpdate && Trigger.isAfter) {
		ProdIndiObjectivesTriggerLogic.handleAutomaticExpirationOfSS(trigger.new);
	}
}