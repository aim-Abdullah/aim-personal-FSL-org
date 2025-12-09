public with sharing class MigratePubOwnershipUtil {
	
	//@future
	public static void migratePubAndJunctionOwnership(id fromUserId, id toUserId) {
		if (fromuserId == null || toUserId == null) {
			return;
		}
		
		//PubAuthor
		List<pubAuthor__c> ownedPubAuthors = [Select OwnerId, Id from pubAuthor__c where OwnerId =: fromUserId];
		if (ownedPubAuthors.size() > 0) {
			for(pubAuthor__c pubAuthor : ownedPubAuthors) {
				pubAuthor.OwnerId = toUserId;
			}
			update ownedPubAuthors;
		}
		
		//PublicationPreFprReviewer
		List<PublicationPreFprReviewer__c> ownedPreFprReviewers = [Select OwnerId, Id from PublicationPreFprReviewer__c where OwnerId =: fromUserId];
		if (ownedPreFprReviewers.size() > 0) {
			for(PublicationPreFprReviewer__c preFprReviewer : ownedPreFprReviewers) {
				preFprReviewer.OwnerId = toUserId;
			}
			update ownedPreFprReviewers;
		}
		
		//PublicationTeamMember
		List<PublicationTeamMember__c> ownedTeamMembers = [Select OwnerId, Id from PublicationTeamMember__c where OwnerId =: fromUserId];
		if (ownedTeamMembers.size() > 0) {
			for(PublicationTeamMember__c teamMember : ownedTeamMembers) {
				teamMember.OwnerId = toUserId;
			}
			update ownedTeamMembers;
		}
		
		//PubME
		List<PubME__c> ownedPubMEs = [Select OwnerId, Id from PubME__c where OwnerId =: fromUserId];
		if (ownedPubMEs.size() > 0) {
			for(PubME__c pubME : ownedPubMEs) {
				pubME.OwnerId = toUserId;
			}
			update ownedPubMEs;
		}		
		
		//PubRelated
		List<PubRelated__c> ownedPubRelateds = [Select OwnerId, Id from PubRelated__c where OwnerId =: fromUserId];
		if (ownedPubRelateds.size() > 0) {
			for(PubRelated__c pubRelated : ownedPubRelateds) {
				pubRelated.OwnerId = toUserId;
			}
			update ownedPubRelateds;
		}
		
		//PubReviewTeam
		List<PubReviewTeam__c> ownedPubReviewTeams = [Select OwnerId, Id from PubReviewTeam__c where OwnerId =: fromUserId];
		if (ownedPubReviewTeams.size() > 0) {
			for(PubReviewTeam__c pubReviewTeam : ownedPubReviewTeams) {
				pubReviewTeam.OwnerId = toUserId;
			}
			update ownedPubReviewTeams;
		}
		
		//PubScientificStatement
		List<PubScientificStatement__c> ownedPubSciStatements = [Select OwnerId, Id from PubScientificStatement__c where OwnerId =: fromUserId];
		if (ownedPubSciStatements.size() > 0) {
			for(PubScientificStatement__c pubScientificStatement : ownedPubSciStatements) {
				pubScientificStatement.OwnerId = toUserId;
			}
			update ownedPubSciStatements;
		}
		
		//PubStudy
		List<PubStudy__c> ownedPubStudies = [Select OwnerId, Id from PubStudy__c where OwnerId =: fromUserId];
		if (ownedPubStudies.size() > 0) {
			for(PubStudy__c pubStudy : ownedPubStudies) {
				pubStudy.OwnerId = toUserId;
			}
			update ownedPubStudies;
		}
		
		//Publication
		List<Publication__c> ownedPubs = [
			Select OwnerId, RecordTypeId, Id, isEnbrel__c 
			from Publication__c 
			where OwnerId =: fromUserId
		];
		
		if (ownedPubs.size() > 0) {
			for(Publication__c ownedPub : ownedPubs) {
				
				AppearPubModelShare pubShare = new AppearPubModelShare(ownedPub.Id, ownedPub.RecordTypeId, ownedPub.isEnbrel__c);
				pubShare.resetAllApexSharing();
				
				ownedPub.OwnerId = toUserId;
			}
			database.update(ownedPubs, false);

			//for FPR Submitter to merge with platform id
			//reset sharing one more than after owner changed.
			for(Publication__c ownedPub : ownedPubs) {
				AppearPubModel activePub = new AppearPubModel(ownedPub.Id);
				activePub.resetSharing();
			}

		}
	}

}