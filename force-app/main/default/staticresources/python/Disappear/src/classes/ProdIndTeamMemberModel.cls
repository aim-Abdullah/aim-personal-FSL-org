public with sharing class ProdIndTeamMemberModel {
	
	public static List<ProdIndTeamMember__c> getProductIndTeamMember(Id ProductIndicationId) {
		List<ProdIndTeamMember__c> result = [
			Select p.Product_Indication__c,
			p.Contact__c, p.Contact__r.name
			From ProdIndTeamMember__c p
			where Product_Indication__c = :ProductIndicationId
		];
		return result;
	}
	
	public static Map<Id,List<ProdIndTeamMember__c>> getProductIndTeamMember(Set<Id> ProductIndcationIds) {
		//bulkify retrival
		List<ProdIndTeamMember__c> pitms = [
			Select p.Product_Indication__c,
			p.Contact__c, p.Contact__r.name
			From ProdIndTeamMember__c p
			where Product_Indication__c in :ProductIndcationIds
		];
		
		Map<Id,List<ProdIndTeamMember__c>> result = new Map<Id,List<ProdIndTeamMember__c>>();
		for(Id prodIndId : ProductIndcationIds) {
			List<ProdIndTeamMember__c> contacts = new List<ProdIndTeamMember__c>();
			for(ProdIndTeamMember__c pitm :pitms ){
				if ( pitm.Product_Indication__c == prodIndId) {
					contacts.add(pitm);
				}
			}
			result.put(prodIndId, contacts);
		}
		
		return result;
	}
}