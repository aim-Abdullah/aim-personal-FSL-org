public class PubReviewTeamTriggerLogic {
	private static boolean countVoteAfterUpdate = false;
	private static boolean resetSharingAfterUpdate = false;
	private final static string voteNotAvailable = 'Vote Not Available';
	
	public static void CheckReviewTypeChanges(AppearPubModel activePub, PubReviewTeam__c reviewTeamMemberCycle, PubReviewTeam__c oldRec) {
		if (ProxyDelegateUtility.ProxyDelegateCounter > 0) { //Only act on single reviewer in proxy chain. Rest will be synced by util and then notifications sent to whole group afterwards
			return;
		}
		
		//check if any reviewer got updated to a primary 
		if ( reviewTeamMemberCycle.Type__c == 'Primary' && oldRec.Type__c <> 'Primary' && oldRec.Type__c <> null) { //the review has just been changed from a Notify to a primary			
			if (reviewTeamMemberCycle.SubType__c == 'Proxy' || reviewTeamMemberCycle.ProxyMember__c != null) { //Has existing chain. Update existing chain members to Primary and then email.
				ProxyDelegateUtility.ProxyDelegateCounter++; //avoid notify sync from re-entering function
				List<PubReviewTeam__c> proxyChain = ProxyDelegateUtility.GetProxiesForAndProxiedBy(reviewTeamMemberCycle);
				ProxyDelegateUtility.proxyContactIds = new List<Id>();
				if (proxyChain != null) {
					for(PubReviewTeam__c proxyChainMember : proxyChain) {
						proxyChainMember.Type__c = 'Primary';
						ProxyDelegateUtility.proxyContactIds.add(proxyChainMember.Reviewer__c);
					}
				}
				update proxyChain;
				if (reviewTeamMemberCycle.Delivered__c != null) { //manually invoke email since it will not be reusing the proxy insert framework for this update
					ProxyDelegateUtility.emailReviewer(reviewTeamMemberCycle);
				}			
			} else { //no existing chain. Check for proxies.
				ProxyDelegateUtility.ProxyOrDelegatePrimary(reviewTeamMemberCycle);	
			}
						
			resetSharingAfterUpdate = true;
		} else if ( reviewTeamMemberCycle.Type__c == 'Notify' && oldRec.Type__c <> 'Notify' && oldRec.Type__c <> null) { //check if reviewer was changed to Notify
			if (reviewTeamMemberCycle.ProxyMember__c != null || reviewTeamMemberCycle.SubType__c == 'Proxy') {
				ProxyDelegateUtility.ProxyDelegateCounter++; //avoid notify sync from re-entering function
				
				List<PubReviewTeam__c> proxyChain = ProxyDelegateUtility.GetProxiesForAndProxiedBy(reviewTeamMemberCycle);

				if (proxyChain != null) {
					for(PubReviewTeam__c proxyChainMember : proxyChain) {
						proxyChainMember.Type__c = 'Notify';
					}
				}
				update proxyChain;
			}			

			//CountVote(activePub, reviewTeamMemberCycle, false);
		} else if (reviewTeamMemberCycle.Type__c == 'Primary' && (reviewTeamMemberCycle.ProxyMember__c != null || reviewTeamMemberCycle.SubType__c == 'Proxy') &&
			(reviewTeamMemberCycle.HasVoted__c != oldRec.HasVoted__c || reviewTeamMemberCycle.Reviewer_Status__c != oldRec.Reviewer_Status__c || 
			reviewTeamMemberCycle.Comments__c != oldRec.Comments__c || reviewTeamMemberCycle.TriagedTo__c != oldRec.TriagedTo__c)) {
			ProxyDelegateUtility.SyncUpdateWithProxies(reviewTeamMemberCycle); //Will sync vote-related fields to entire proxy chain

			//CountVote(activePub, reviewTeamMemberCycle, false);
		}		
		
		countVoteAfterUpdate = true;
	}
	public static void PubReviewTeamBeforeUpdateTrigger(PubReviewTeam__c reviewTeamMemberCycle, PubReviewTeam__c oldRec) {
		if (ProxyDelegateUtility.ProxyDelegateCounter > 0) { //Only act on single reviewer in proxy chain. Rest will be synced by util and then notifications sent to whole group afterwards
			System.debug('***** Over max proxy count of '+ProxyDelegateUtility.ProxyDelegateCounter);
			return;
		}
		
		AppearPubModel activePub = new AppearPubModel(reviewTeamMemberCycle.publication__c);		
		
		CheckReviewTypeChanges(activePub, reviewTeamMemberCycle, oldRec);
		
		//if this reviewer voted for 'Withheld' then change the status of the entire pub to 'FPR Withheld'
		if ( reviewTeamMemberCycle.Reviewer_Status__c == 'Withheld' && oldRec.Reviewer_Status__c <> 'Withheld') {
			//the review has just been changed from a Notify to a primary
			AppLogModel.LogInfo('PubReviewTeamTriggerLogic::CountVote',  
				'Reviewer Voted for Withheld - changing entire Pub to FPR Withheld ');
				
			activePub.PubReviewTeam.DuplicateAdHocReviewer();
			activePub.PubStatus.InsertFprWithHeldWithActualDate(activePub.CurrentSubmissionCycleId, activePub.CurrentFprCycleId);
				
			AppLogModel.flushLogs();
			return;
		}
	
		countVoteAfterUpdate = true;
	}

	public static void PubReviewTeamAfterUpdateTrigger(PubReviewTeam__c reviewTeamMemberCycle, PubReviewTeam__c oldRec) {
		if (!countVoteAfterUpdate && !resetSharingAfterUpdate) {
			return;
		}
		
		AppearPubModel activePub = new AppearPubModel(reviewTeamMemberCycle.publication__c);	
		if (countVoteAfterUpdate) {
			CountVote(activePub, reviewTeamMemberCycle, false);
			countVoteAfterUpdate = false;
		}
		if (resetSharingAfterUpdate) {
			activePub.resetSharing();
			resetSharingAfterUpdate = false;
		}		
	}
	
	//To be invoked by admin on Execute Anonymous
	public static void ReCountVoteByPubId(id PubId) {
		AppearPubModel pubModel = new AppearPubModel(pubId);
		CountVote(pubModel, null, true);
	}
		
	public static void CountVote(AppearPubModel ActivePub,  PubReviewTeam__c reviewTeamMemberCycle, boolean isRecount) {
		Publication__c tempPub;
		Id submissionCycleId;
		Id fprCycleId;
		Id pubId;
		
		//Need to get the Publication for the non-sharing user i.e Reviewer. AppearPubModel will not work when Reviewer performs a Withheld operation
		if(reviewTeamMemberCycle != null) {
			tempPub = AppearPubModelShare.getPublicationSCandFC(reviewTeamMemberCycle.publication__c);
			submissionCycleId = tempPub.Current_SubmissionCycle_Id_Formula__c;
		} else {
			submissionCycleId = ActivePub.CurrentSubmissionCycleId;
		}

		fprCycleId = ActivePub.CurrentFprCycleId;
		pubId = ActivePub.pubId;
				
		//find all other review team members in this FPR Cycle
		List<PubReviewTeam__c> allMembers = [
			select Reviewer__r.name, HasVoted__c, Appear_Role__c, Type__c, Reviewer_Status__c, Returned__c, CreatedBy.name, LastModifiedDate
			from PubReviewTeam__c
			where publication__c = :ActivePub.PubId
			and FPR_Cycle__c = :fprCycleId
			and IsLogicallyDeleted__c = false 
			//and ProxyMember__c = null //now including proxies in count function for delegate scenarios
		];
	
		//System.debug('PubReviewTeamTriggerLogic::CountVote \n# of ReviewTeamMembers for this cycle = '+allMembers.size() );
		
		boolean allVoted = true;
		Integer numOfPrimary = 0;  //make sure that we dont count no one voted as all voted.
		
		for(PubReviewTeam__c rtm : allMembers) {
			if (rtm.Type__c == 'Primary') {
				numOfPrimary++;
				
				//Updated the check to make sure the Overall Pub Status is not changed for Publications that had 
				//Vote = "Vote Not Available" i.e. Many Legacy Publications (including GPP) have not been reviewed by the Reviewers
				//Such Publications have been manually updated to not showup in the Reviewer Queues via Data Update in R4.0  
				//if ( rtm.HasVoted__c == false || (ActivePub.IsCommentsOnly && rtm.Reviewer_Status__c == voteNotAvailable) ) {
				if ( rtm.HasVoted__c == false || rtm.Reviewer_Status__c == voteNotAvailable) {
					allVoted = false;
					break;
				}
			}
		}
		
		//System.debug('PubReviewTeamTriggerLogic::CountVote \nAll Voted  = '+allVoted);
		//System.debug('PubReviewTeamTriggerLogic::CountVote \nnumOfPrimary  = '+numOfPrimary);
			
			
		// removed else to resolve defect 663: System email is not getting generated when the last Primary Reviewer is casting the Vote
		if (reviewTeamMemberCycle <> null && reviewTeamMemberCycle.Reviewer_Status__c != 'Withheld') {						
			SendEmailToSubmitterAndFPRC(reviewTeamMemberCycle);
		} 	
			
		if (allVoted) {  
			if (numOfPrimary > 0) {
				//determine the pubstatus from votes
				//pick the one with the lowest display order
			
				DateTime VoteCompletionDateTime = DateTime.newInstance(1960,1,1);
				Set<string> ReviewerStatusSet = new Set<string>();
				for(PubReviewTeam__c rtm : allMembers){
					if (rtm.Type__c == 'Primary') {
						ReviewerStatusSet.add(rtm.Reviewer_Status__c);
					}
					if (rtm.Returned__c > VoteCompletionDateTime) {
						
						if ( rtm.createdBy.Name <> 'Amgen DataMigration') {
							VoteCompletionDateTime = rtm.LastModifiedDate;
						} else { // for migrated record - we cannot use the last modified date
							VoteCompletionDateTime = rtm.Returned__c;
							VoteCompletionDateTime = VoteCompletionDateTime.addHours(8);
						}
					}
				}
				
				// Defect #173 with trumping order on the Status based on different vote.	
				// Defect #373 for overall courtesy fpr completed		
				Status__c FprCompletionStatus = StatusModel.FprCompleted;
				if ( ReviewerStatusSet.contains(FprWithHeld)) {
					FprCompletionStatus = StatusModel.FprWithHeld;
				} else if ( ReviewerStatusSet.contains(DiscussionRequired)) {
					FprCompletionStatus = StatusModel.DiscussionRequired;   
				} else if ( ReviewerStatusSet.contains(FprCompletedWithComment)) {
					FprCompletionStatus = StatusModel.FprCompletedWithComment;
				//} else if ( ReviewerStatusSet.contains(ApprovedWithComment)) {     //recount vote for legacy needs this to work .
				//	FprCompletionStatus = StatusModel.FprCompletedWithComment;				
				} else if ( ReviewerStatusSet.contains(FprCourtesyComments)) {
					FprCompletionStatus = StatusModel.FprCourtesyCompletedWithComment;
				} else if ( ReviewerStatusSet.contains(FprCourtesyNoComments)) {
					FprCompletionStatus = StatusModel.FprCourtesyCompleted;
				} else {
					//default is FprCompleted if no other status trump it
					FprCompletionStatus = StatusModel.FprCompleted;
				} 				
				
				if ( !isRecount ) {
					VoteCompletionDateTime = DateTime.Now();
				}
				
				//System.debug('PubReviewTeamTriggerLogic::CountVote \n'+ ActivePub.PubName + ' FprCompletionStatus  = '+FprCompletionStatus.name + ' CurrentFPR Cycle = '+fprCycleId +' VoteCompletionDateTime = '+ VoteCompletionDateTime);
					

				//change status to FPRCompleted for pub
				//add actual date for FPRCompleted in pubStatus
				PubStatusModel.SetFprCompletedStatus(pubId, FprCompletionStatus, submissionCycleId, fprCycleId, ActivePub.CurrentFprCycleNum, VoteCompletionDateTime);
				
				//Invoke the Reset Current Status to update the Overall Publication Status, this is done ONLY via a Batch/Manually by SA
				if(reviewTeamMemberCycle == null) {
					ActivePub.resetCurrentStatus();
				}
				
				//PubStatus after Update will pick the correct status and set status Date
				ActivePub.resetSharingWithStatus(FprCompletionStatus); //reset sharing to include pubTeam or other edit exclusions during FPR
				
				//send email for all reviewers having reviewed publication
				if (reviewTeamMemberCycle <> null && !ReviewerStatusSet.contains(FprWithHeld)) {

					List<Id> ToAddressIds = new List<Id>();
					List<Id> CcAddressIds = new List<Id>();
					if (FprCompletionStatus == StatusModel.FprCourtesyCompletedWithComment || FprCompletionStatus == StatusModel.FprCourtesyCompleted) {
						//devTemplateName = 'Overall_Courtesy_FPR_Completed_Email';
						
						ToAddressIds.add(activePub.PubRecord.FPR_Submitter__c);
						ToAddressIds.add(activePub.PubRecord.Assigned_FPRC__c);
						
						Email_13_CourtesyFprReviewComplete email = new Email_13_CourtesyFprReviewComplete(ToAddressIds, CcAddressIds, reviewTeamMemberCycle.Id, activePub.PubRecord);
						email.sendEmail(); 
						
					} else if (FprCompletionStatus == StatusModel.FprCompletedWithComment) {						
						ToAddressIds.add(activePub.PubRecord.FPR_Submitter__c);
						CcAddressIds.add(activePub.PubRecord.Assigned_FPRC__c);
						
						Email_15_FullFprReviewWithCmtsComplete email = new Email_15_FullFprReviewWithCmtsComplete(ToAddressIds, CcAddressIds, reviewTeamMemberCycle.Id, activePub.PubRecord);
						email.sendEmail();
						
					} else {
						//devTemplateName = 'Full_FPR_publication_reviewed';
						
						ToAddressIds.add(activePub.PubRecord.FPR_Submitter__c);
						CcAddressIds.add(activePub.PubRecord.Assigned_FPRC__c);
						
						Email_10_FullFprReviewComplete email = new Email_10_FullFprReviewComplete(ToAddressIds, CcAddressIds, reviewTeamMemberCycle.Id, activePub.PubRecord);
						email.sendEmail();
					}
				}
				
			}
		}	
	}  
	
	public static void SendEmailToSubmitterAndFPRC(PubReviewTeam__c reviewTeamMemberCycle) {

			Publication__c activePubRecord  = getPubForEmail( reviewTeamMemberCycle.Publication__c);
			//for a trigger - more efficient to directly retrieve the pub record

			if (ActivePubRecord <> null) {
					
				Id submitterUserId = activePubRecord.FPR_Submitter__c;
				id fprcContactId = activePubRecord.Assigned_FPRC__c;
				
				List<Id> ToAddressIds = new List<Id>();
				List<Id> CcAddressIds = new List<Id>();
				
				if (reviewTeamMemberCycle.Reviewer_Status__c == FprCompletedWithComment) {
					
					ToAddressIds.add(submitterUserId);
					CcAddressIds.add(fprcContactId);
					
					Email_09_IndividualFprReviewerCommented email = new Email_09_IndividualFprReviewerCommented(ToAddressIds, CcAddressIds, reviewTeamMemberCycle.Id, activePubRecord);
					email.sendEmail();
				} else if (reviewTeamMemberCycle.Reviewer_Status__c == FprCompleted) {
					
					ToAddressIds.add(submitterUserId);
					CcAddressIds.add(fprcContactId);
					
					Email_08_IndividualFprReviewerReviewed email = new Email_08_IndividualFprReviewerReviewed(ToAddressIds, CcAddressIds, reviewTeamMemberCycle.Id, activePubRecord);
					email.sendEmail();
				} else if (reviewTeamMemberCycle.Reviewer_Status__c == DiscussionRequired) {
					
					ToAddressIds.add(submitterUserId);
					CcAddressIds.add(fprcContactId);
					
					Email_07_FprDiscussionRequired email = new Email_07_FprDiscussionRequired(ToAddressIds, CcAddressIds, reviewTeamMemberCycle.Id, activePubRecord);
					email.sendEmail();
				} else if (reviewTeamMemberCycle.Reviewer_Status__c == FprCourtesyComments) {
					
					ToAddressIds.add(submitterUserId);
					ToAddressIds.add(fprcContactId);
					
					Email_11_IndividCourtesyFprRevCommented email = new Email_11_IndividCourtesyFprRevCommented(ToAddressIds, CcAddressIds, reviewTeamMemberCycle.Id, activePubRecord);
					email.sendEmail();
				} else if (reviewTeamMemberCycle.Reviewer_Status__c == FprCourtesyNoComments) {
										
					ToAddressIds.add(submitterUserId);
					ToAddressIds.add(fprcContactId);
					
					Email_12_IndividCourtesyFprRevReviewed email = new Email_12_IndividCourtesyFprRevReviewed(ToAddressIds, CcAddressIds, reviewTeamMemberCycle.Id, activePubRecord);
					email.sendEmail();
				} 
				
			}
	}
	
	//for a trigger - more efficient to directly retrieve the pub record	
	public static Publication__c getPubForEmail(id PubId) {
		List<Publication__c> activePubRecords = [
			Select CreatedById, Assigned_FPRC__c, FPR_Submitter__c, Publication_Type__c, Name, 
				FPR_Due_Date__c, Current_Target__c, Publication_Title__c, Assigned_FPRC__r.name, Primary__c, FPR_Submitter__r.name, Product_Indication__c
			from Publication__c 
			WHERE Id = :PubId
		];
		
		if ( activePubRecords.size() == 1) {
			return activePubRecords[0];
		} else {
			return null;
		}
	}
	
	@future
	public static void AfterReviewTeamInsertFuture(Set<id> contactIds) {
		List<Contact> contacts = [Select UserId__c FROM Contact WHERE id in : contactIds
									and UserId__r.ProfileId != :ProfileModel.AppearReviewersProfile.id
									and UserId__r.ProfileId != :ProfileModel.AppearPortalFprOnlySubmitterProfile.id];
									
		PermissionSet fprGrant = [select id from PermissionSet where Name = 'Grant_Fpr_Review_Access'];
									
		List<PermissionSetAssignment> assignmentsToInsert = new List<PermissionSetAssignment>();
		for(Contact contactToCheck : contacts) {
			if (contactToCheck.UserId__c != null) {
				PermissionSetAssignment assignmentToAdd = new PermissionSetAssignment();
    			assignmentToAdd.AssigneeId = contactToCheck.UserId__c;
    			assignmentToAdd.PermissionSetId = fprGrant.Id;
    			assignmentsToInsert.add(assignmentToAdd);
			}
		}
		
		if (assignmentsToInsert.size() > 0) {
			database.insert(assignmentsToInsert, false);
		}
	}
	
	

	//ReviewStatus in trump order - WithHeld trump all 
	public final static string FprWithHeld = 'Withheld';
	public final static string DiscussionRequired = 'Discussion Required';
	public final static string FprCompletedWithComment = 'Reviewed With Comments';
	public final static string ApprovedWithComment = 'Approved With Comments';
	public final static string FprCompleted = 'Reviewed';
	public final static string FprApproved = 'Approved';
	public final static string FprCourtesyComments = 'Comments';
	public final static string FprCourtesyNoComments = 'No Comments';
}