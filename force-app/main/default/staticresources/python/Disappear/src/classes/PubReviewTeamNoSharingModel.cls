public without sharing class PubReviewTeamNoSharingModel {

	public static PubReviewTeam__c loadPubReviewTeamRecord(Id pubReviewTeamId) {
		List<PubReviewTeam__c> results = [
			select PubIDLink__c, Reviewer__c, AssignedFPRCFF__c, publication__r.name, Reviewer__r.name, 
				TriageDelegatedBy__r.name, Triage_Justification__c, TriagedTo__r.Reviewer__r.name, SubType__c,
				DelegatedTo__r.Reviewer__r.name, Delegation_Justification__c, ProxyMember__c, DisplayName__c
			from PubReviewTeam__c   
			where id = :pubReviewTeamId
		];
		if ( results.size() == 1) {
			return results[0];
		} else {
			return null;
		}
	}

}