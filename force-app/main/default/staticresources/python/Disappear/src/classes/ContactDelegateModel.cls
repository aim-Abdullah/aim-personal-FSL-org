public class ContactDelegateModel {
	//trump order - Delegate > Proxy > Assigned contact

	private static map<Id, ContactDelegate__c> contactIdtoDelegateMap;
	
	public static ContactDelegate__c pubfindPubReviewDelegate(Contact ReviewTeamMember, Date delegationDate) {
		return pubfindPubReviewDelegate(reviewTeamMember.id, delegationDate);
	}
	
	public static ContactDelegate__c pubfindPubReviewDelegate(Id contactId, Date delegationDate) {
		if (contactIdtoDelegateMap == null) {
			List<ContactDelegate__c> allDelegates = [
				select Contact__c, Contact__r.name, Delegate__c, Delegate__r.name,
				start_Date__c, end_Date__c, Comment__c, isActive__c
				from ContactDelegate__c
				where start_Date__c <= :DelegationDate
				and end_Date__c >= :DelegationDate
				and isActive__c = true
			];
			
			contactIdtoDelegateMap = new map<Id, ContactDelegate__c>();
			for(ContactDelegate__c delegate : allDelegates) {
				if (!contactIdtoDelegateMap.containsKey(delegate.contact__c)) { //avoid potential de-duplication errors
					contactIdtoDelegateMap.put(delegate.contact__c, delegate);
				}
			}
		}
		
		if (!contactIdtoDelegateMap.containsKey(contactId)) {
			return null;
		} else {
			return contactIdtoDelegateMap.get(contactId);
		}
	}	
}