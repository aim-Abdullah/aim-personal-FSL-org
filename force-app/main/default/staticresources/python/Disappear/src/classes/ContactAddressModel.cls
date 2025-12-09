/*******************************************************************************************************
 * $Id$ : ContactAddressModel
 * $Created Date$ : 2014/06/13
 * $Author$ : Sesha Kurmana
 * $Description$ : This class is used to incorporate utility logic for handling operations Contact_Address__c.
 *******************************************************************************************************/
public with sharing class ContactAddressModel {

	private static map<Id, Contact_Address__c> contactAddressMap;
	
	public static Contact_Address__c getAllContactAddresses(Contact authorTeamMember) {
		return getAllContactAddresses(authorTeamMember.id);
	}
	
	public static Contact_Address__c getAllContactAddresses(Id contactId) {
		if (contactAddressMap == null) {
			List<Contact_Address__c> allAddresses = [
																					select Id, Name, City__c, Contact_Name__c, Contact_Name__r.Name, Country__c, 
																								isLogicallyDeleted__c, Primary_Address__c, State_Province__c, 
																								Street_Address__c, Zip_Postal_Code__c
																					from Contact_Address__c
																					where Contact_Name__c =: contactId
																				];
			
			contactAddressMap = new map<Id, Contact_Address__c>();
			for(Contact_Address__c contactAddress : allAddresses) {
				if (!contactAddressMap.containsKey(contactAddress.Contact_Name__c)) { //avoid potential de-duplication errors
					contactAddressMap.put(contactAddress.Contact_Name__c, contactAddress);
				}
			}
		}
		
		if (!contactAddressMap.containsKey(contactId)) {
			return null;
		} else {
			return contactAddressMap.get(contactId);
		}
	}
	
	public static List<Contact_Address__c> getActiveContactAddresses(Contact authorContact) {
		
			List<Contact_Address__c> allContactAddresses = [
																					select Id, Name, City__c, Contact_Name__c, Contact_Name__r.Name, 
																								Country__c, isLogicallyDeleted__c,
																								Primary_Address__c, State_Province__c, Street_Address__c, 
																								Zip_Postal_Code__c
																					from Contact_Address__c
																					where Contact_Name__c =: authorContact.Id
																					and isLogicallyDeleted__c = false
																				];
			
		if (allContactAddresses.size() == 0) {
			return null;
		}
		
		return allContactAddresses;
	}
}