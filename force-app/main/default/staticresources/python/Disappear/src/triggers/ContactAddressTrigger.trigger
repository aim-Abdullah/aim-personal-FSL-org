/*******************************************************************************************************
 * $Id$ : ContactAddressTrigger
 * $Created Date$ : 2014/06/13
 * $Author$ : Sesha Kurmana
 * $Description$ : This class is used to incorporate logic for handling trigger updates on Contact_Address__c. 
 *******************************************************************************************************/
trigger ContactAddressTrigger on Contact_Address__c (before insert, before update) {
	if ( !AppearTriggerActivationModel.isContactAddressesTriggerActive) {
		return;
	}
	
	if ( (Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore) {
		
		List<Contact_Address__c> contAddressList = ContactAddressTriggerLogic.findPrimaryContactAddresses(trigger.new);  
		
		boolean checkPrimaryAddressFlgDuringInsert = (trigger.old == null && trigger.new[0].Primary_Address__c) ? true : false;
		boolean checkPrimaryAddressFlgDuringUpdate = (trigger.old != null && !trigger.old[0].Primary_Address__c && trigger.new[0].Primary_Address__c) ? true : false;
		
		//Sesha 7/14/2014: Added Logic to default Primary Address flag if this is the first address 
		if(contAddressList == null && trigger.old == null &&  trigger.new != null && !trigger.new[0].Primary_Address__c) {
				trigger.new[0].Primary_Address__c = true;			
		}
		
		if( (contAddressList <> null && checkPrimaryAddressFlgDuringInsert && contAddressList.size() == 1) || 
			(contAddressList <> null && checkPrimaryAddressFlgDuringUpdate && contAddressList.size() == 1)) {
				string msg = 'Error : [' + contAddressList[0].Contact_Name__r.Name +'] already has a designated Primary Address';
				trigger.new[0].addError(msg);
		}
	}
}