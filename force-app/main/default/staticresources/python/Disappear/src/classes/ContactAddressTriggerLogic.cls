/*******************************************************************************************************
 * $Id$ : ContactAddressTriggerLogic
 * $Created Date$ : 2014/06/13
 * $Author$ : Sesha Kurmana
 * $Description$ : This class is used to incorporate logic for handling updates on Contact_Address__c.
 *******************************************************************************************************/
public with sharing class ContactAddressTriggerLogic {
	
	public static List<Contact_Address__c> findPrimaryContactAddresses(List<Contact_Address__c> contactAddrLst) {
		List<Contact_Address__c> allAddresses = null;
			
		for(Contact_Address__c contAddr : contactAddrLst){
			allAddresses = [
				select Id, Name, City__c, Contact_Name__c, Contact_Name__r.Name, Country__c, isLogicallyDeleted__c,
							Primary_Address__c, State_Province__c, Street_Address__c, Zip_Postal_Code__c
				from Contact_Address__c
				where Contact_Name__c =: contAddr.Contact_Name__c
				and Primary_Address__c = true
			];
		}
	
		if (allAddresses.size() == 0) {
			return null;
		}
	
		return allAddresses;		
	}
}