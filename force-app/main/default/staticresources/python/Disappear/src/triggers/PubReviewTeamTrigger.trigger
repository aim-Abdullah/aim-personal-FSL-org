trigger PubReviewTeamTrigger on PubReviewTeam__c (before update, after update, before insert, after insert) {

	if ( Trigger.isUpdate && Trigger.isBefore ) {
		
		if ( !AppearTriggerActivationModel.isPubReviewTeamTriggerActive) {
			return;
		}
		
		//check if hasVoted == true but ReturnDate == null then set ReturnDate to now
		for(PubReviewTeam__c prt : Trigger.new) {
			if ( prt.HasVoted__c && prt.Returned__c == null && prt.Reviewer_Status__c != null && prt.Reviewer_Status__c !='' && prt.Reviewer_Status__c != 'Vote Not Available') {
				prt.Returned__c = Date.today();
			}
		}
		
		if (Trigger.new.size() == 1) {			
			
			PubReviewTeam__c newPubReviewTeam = Trigger.new[0];
			PubReviewTeam__c oldPubReviewTeam = Trigger.OldMap.get(newPubReviewTeam.id);
			
			PubReviewTeamTriggerLogic.PubReviewTeamBeforeUpdateTrigger(newPubReviewTeam, oldPubReviewTeam);
		} else {
			
			AppearPubModel activePub = new AppearPubModel(Trigger.new[0].publication__c);
			for(PubReviewTeam__c teamMember : Trigger.new) {
				PubReviewTeamTriggerLogic.CheckReviewTypeChanges(activePub, teamMember, Trigger.OldMap.get(teamMember.id));
			}
		}
	}
	if (Trigger.isUpdate && Trigger.isAfter) {
			
			PubReviewTeam__c newPubReviewTeam = Trigger.new[0];
			PubReviewTeam__c oldPubReviewTeam = Trigger.OldMap.get(newPubReviewTeam.id);
		
		if ( !AppearTriggerActivationModel.isPubReviewTeamTriggerActive) {
			return;
		}
		PubReviewTeamTriggerLogic.PubReviewTeamAfterUpdateTrigger(newPubReviewTeam, oldPubReviewTeam);
	}

	
	if (Trigger.isInsert) {	
		if ( !AppearTriggerActivationModel.isPubReviewTeamTriggerActive) {
			return;
		}
		if (ProxyDelegateUtility.ProxyDelegateCounter > 0) { //only apply for the first reviewer in the chain and ignore for the rest in the line of execution
			return;
		}
	}
	
	if (Trigger.isInsert && Trigger.isBefore) {		
		for(PubReviewTeam__c teamMember : Trigger.new) {			
			ProxyDelegateUtility.ProxyOrDelegatePrimary(teamMember);	
			if (Trigger.new.size() > 1) {
				ProxyDelegateUtility.ProxyDelegateCounter = 0; //reset counter for multiple top-level reviewer inserted due to cloning between FPR cycles
			}			
		}
	}
	
	if (Trigger.isInsert && Trigger.isAfter & !PubReviewTeamModel.isDuplicatingAdhoc) {	
		AppLogModel.LogInfo('PubReviewTeamTrigger:AfterInsert','************');

		Set<id> contactIds = new Set<id>();
		for(PubReviewTeam__c teamMember : Trigger.new) {
			contactIds.add(teamMember.Reviewer__c);
		}
		
		//TODO: Find way to prevent redundant future call for 'reviewer profile insert' while avoiding soql query per reviewer insert to check user's profileId for that reveiwer.		
		List<Contact> contacts = [Select UserId__c FROM Contact WHERE id in : contactIds
							and UserId__r.ProfileId != :ProfileModel.AppearReviewersProfile.id
							and UserId__r.ProfileId != :ProfileModel.AppearPortalFprOnlySubmitterProfile.id];
							
		if (contacts != null && contacts.size() > 0) {
			PubReviewTeamTriggerLogic.AfterReviewTeamInsertFuture(contactIds);
		}
	}
	
	AppLogModel.flushLogs();
  
}