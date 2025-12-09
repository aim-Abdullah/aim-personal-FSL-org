public class PubStatusTriggerLogic {
	//discussed with Team on 2013/04/23
	//The bulkification logic required for this trigger to handle update with multiple publication
	//or multiple Submission cycle. FPR is too complex.
	//
	//Benjamin will code this as a single Publication trigger.
	//Impact analysis - 
	//the only way to update PubStatus for multiple Pub is for the data migration process 
	//Benjamin will write an Apex batch to single step all migrated records.
	
	///////////////////////////////////////////////////////////////////////////////
	
	public static boolean byPassForLegacyPubStatusType(List<PubStatus__c> PubStatusList) {
		
		return false;
		/*
		Set<id> LegacyPubStatusRecordIdSet = RecordTypeModel.LegacyPubStatusRecordIdSet;
		
		System.assertNotEquals(null, LegacyPubStatusRecordIdSet);
		System.assert(LegacyPubStatusRecordIdSet.size() > 0);
		
		if(PubStatusList == null || PubStatusList.size() == 0) {
			return false;
		}
		
		for(PubStatus__c pubStatus : pubStatusList) {
			if (LegacyPubStatusRecordIdSet.contains(pubStatus.recordTypeId) ) {
				return true;
			}
		}	 
		return false;
		*/
	}
	
	
	public static void PubStatusTriggerBeforeUpdate(Map<Id,PubStatus__c> newMap, Map<Id,PubStatus__c> oldMap) {
		for(PubStatus__c newPubStatus : newMap.values()) {
			PubStatus__c oldPubStatus = oldMap.get(newPubStatus.id);
			
			if ( newPubStatus.ActualDate__c <> null && (oldPubStatus == null || oldPubStatus.ActualDate__c == null)) {
								
				Status__c changedStatus = StatusModel.StatusMapById.get(newPubStatus.Status__c);
				
				if ( changedStatus <>  null) {					
					//CR 230 - P2 UAT: System should require a target when adding an actual date to the Submitted status (to planned pub)
					if ( changedStatus.id == StatusModel.SubmittedCompleted.id) {
						AppearPubModel submittedCompletedPubModel = new AppearPubModel(newPubStatus.Publication_id__c);
						if (submittedCompletedPubModel.pubRecord.isPlanning__c && submittedCompletedPubModel.CurrentTarget == '') {
							newPubStatus.ActualDate__c = null;
							newPubStatus.ActualDate__c.addError('Please enter a Target before inputting an Actual Date for Submitted/Completed status');
						}
					}
				}
			}
		}
	}
	  
	public static void PubStatusTriggerBeforeInsert(List<PubStatus__c> newPubStatus) {
		
		AppLogModel.LogDebug('PubStatusTriggerLogic::PubStatusTriggerBeforeInsert', 'Check if this pub NeedNewSubmissionCycle');
		//AppLogModel.flushLogs();
		
		//check if we need to increment the Submission Cycle 
		
		//If submission cycle's Submitted/completed has an actual date.
		//Increment by "1" one each time a publication gets ANY new or updated status
		//(except "Cancelled", "Withdrawan" or "On Hold")  
		//AFTER a "Rejection" status is recorded on the Publication.
		 
		//find the pub id of the new pubstatus
		if ( newPubStatus == null || newPubStatus.size() == 0){
			AppLogModel.LogError('PubStatusTriggerLogic::PubStatusTriggerBeforeInsert', 'Aborting - cannot find NewPubStatus');
			return;
		}
		//find all pubs involved in this trigger
		set<id> PubIds = findPubfromPubStatus(newPubStatus);
		if (PubIds.size() <> 1){
			string msg='Only support changing status for 1 publication at a time ['+PubIds+']';
			AppLogModel.LogError('PubStatusTriggerLogic::PubStatusTriggerBeforeInsert', msg);
			AppLogModel.flushLogs();
			return;
		} else {
			Id pubId = newPubStatus[0].publication_id__c;
			AppearPubModel activePub = new AppearPubModel(pubId);
			
			if (NeedNewSubmissionCycle(activePub, newPubStatus)) {
				AppLogModel.LogInfo('PubStatusTriggerLogic::PubStatusTriggerBeforeInsert', 'NeedNewSubmissionCycle confirmed. Creating new Submission Cycle now');
				SubmissionCycle__c subCycle = activePub.IncrSubmissionCycle();
				//fill in the current Submission Cycle Link		
				for(PubStatus__c pubStatus : newPubStatus){
					
					pubStatus.Submission_Cycle__c = subCycle.id;
					if ( activePub.CurrentFprCycleId <> null && pubStatus.FPR_Cycle__c == null)
						pubStatus.FPR_Cycle__c = activePub.CurrentFprCycleId;
				}				
			} else {
				AppLogModel.LogDebug('PubStatusTriggerLogic::PubStatusTriggerBeforeInsert',  'Continue to use current submission Cycle ');
				//fill in the current Submission Cycle Link		
				for(PubStatus__c pubStatus : newPubStatus){
					if ( activePub.CurrentSubmissionCycleId <> null && pubStatus.Submission_Cycle__c == null)
						pubStatus.Submission_Cycle__c = activePub.CurrentSubmissionCycleId;
					if ( activePub.CurrentFprCycleId <> null && pubStatus.FPR_Cycle__c == null)
						pubStatus.FPR_Cycle__c = activePub.CurrentFprCycleId;
				}
			}

		}		
		
		AppLogModel.flushLogs();
		return;
	}
	
	
	public static boolean NeedNewSubmissionCycle(AppearPubModel activePub, List<PubStatus__c> newPubStatus) {
		
		//find PubStatus for current SubmissionCycle
		SubmissionCycle__c currentSubmissionCycle = activePub.SubmissionCycle.FindCurrentSubmissionCycle();
		id currentSubmissionCycleId = currentSubmissionCycle.id;
		AppLogModel.LogDebug('PubStatusTriggerLogic::NeedNewSubmissionCycle',   
						' Current submissionCycle Num = '+currentSubmissionCycle.Submission_Cycle_Num__c);
		
		boolean CurrentSubmissionCycleRejected = false;
		for(PubStatus__c pubstatus : activePub.PubStatus.PubStatusList) { 
			if (pubStatus.Submission_Cycle__c == currentSubmissionCycleId ) {
				if (pubStatus.Status__c == StatusModel.Rejected.id && pubStatus.ActualDate__c <> Null) {
					CurrentSubmissionCycleRejected = true;
					AppLogModel.LogDebug('PubStatusTriggerLogic::NeedNewSubmissionCycle', 
						'found rejected status with actual date ');
				} else {
					//AppLogModel.LogDebug('PubStatusTriggerLogic::NeedNewSubmissionCycle', 'not rejected for  '+pubStatus.status__r.name);
				}
			}
		}
		
		AppLogModel.LogDebug('PubStatusTriggerLogic::NeedNewSubmissionCycle', 
			' Current submissionCycle been rejected = '+CurrentSubmissionCycleRejected);
		
		boolean result = false;
		if (CurrentSubmissionCycleRejected && !terminalStatus(newPubStatus) ) {
			result = true;  
		}
		
		AppLogModel.LogDebug('PubStatusTriggerLogic::NeedNewSubmissionCycle', result + ' for ' + newPubStatus );
		return result;
	}
	
	
		//(except "Cancelled", "Withdrawan" or "On Hold") 
		//AFTER a "Rejection" status is recorded on the Publication.
	public static boolean terminalStatus(List<PubStatus__c> newPubStatus) {
		Set<id> pubStatusIdSet = new Set<Id>();
		for(PubStatus__c pubstatus : newPubStatus){
			pubStatusIdSet.add(pubStatus.Status__c);
		}
		
		boolean result = false;
		if ( pubStatusIdSet.contains(StatusModel.Cancelled.id) ) result = true;
		if ( pubStatusIdSet.contains(StatusModel.OnHold.id) ) result =  true;
		if ( pubStatusIdSet.contains(StatusModel.WithDrawn.id) ) result =  true;
		
		AppLogModel.LogDebug('PubStatusTriggerLogic::terminalStatus  ?  ' , newPubStatus +' = '+ result);
		
		return result;
	}
	
	public static void PubStatusTriggerAfterInsert(Map<Id,PubStatus__c> newMap) {
		AppLogModel.LogInfo('PubStatusTriggerLogic::PubStatusTriggerAfterInsert', 'start execution');
		PubStatusTriggerAfterUpsert(newMap, new Map<Id, PubStatus__c>() );
	}
	public static void PubStatusTriggerAfterUpdate(Map<Id,PubStatus__c> newMap, Map<Id,PubStatus__c> oldMap) {
		if ( newMap == null || newMap.size() == 0){
			AppLogModel.LogError('PubStatusTriggerLogic::PubStatusTriggerAfterUpdate', 
				'Aborting due to ; ( newMap == null || newMap.size() == 0)');
			return;
		}
		string msg = 'newMap has '+newMap.size()+' records';
		AppLogModel.LogInfo('PubStatusTriggerLogic::PubStatusTriggerAfterUpdate', msg);
		PubStatusTriggerAfterUpsert(newMap, oldMap);
		AppLogModel.flushLogs();
	}
	
	public static Id getPubCurrentFprCycleId(Id PubId) {
		List<Publication__c> pubs = [
			select Current_FPRCycle_Id_Formula__c
			from publication__c
			where id = :pubId
		];
		
		if ( pubs.size() == 1) {
			return pubs[0].Current_FPRCycle_Id_Formula__c;
		}
		return null;
		
	}
	
	public static void PubStatusTriggerAfterUpsert(Map<Id,PubStatus__c> newMap, Map<Id,PubStatus__c> oldMap) {
		if ( newMap == null || newMap.size() == 0){
			return;
		}
		
		//find all pubs involved in this trigger
		set<id> PubIds = findPubfromPubStatusMap(newMap);
		
		for(Id pubId : PubIds) {
			//APPEAR ENHANCEMENT R3: Auto Populate PubStatus Actual Date : isAppearPortalPubAuthor check 
		    System.debug('@@@PubStatusTriggerLogic :: @@@PubStatusTriggerAfterUpsert'+ pubId);
		    System.debug('@@@PubStatusTriggerLogic :: @@@PubStatusTriggerAfterUpsert2 :: ' + ProfileModel.isAppearPortalPubAuthor );
		    
		    if(!ProfileModel.isAppearPortalPubAuthor){
		      PublicationTriggerLogic.UpdateLatestPubStatusById(pubId);	
		    }  
		}
		
		//now scan each upsert pubStatus and see if we need to send email.
		for(PubStatus__c newPubStatus : newMap.values()) {
			
			PubStatus__c oldPubStatus = oldMap.get(newPubStatus.id);
			
			if ( newPubStatus.ActualDate__c <> null && (oldPubStatus == null || oldPubStatus.ActualDate__c == null)) {
				
				Status__c changedStatus = StatusModel.StatusMapById.get(newPubStatus.Status__c);
				
				if ( changedStatus <>  null) {
					AppLogModel.LogInfo('PubStatusTriggerLogic::PubStatusTriggerAfterUpsert', 
						'Found new Actual Date for PubStatus = '+ changedStatus.name);
					
					/*
					Def #534 - fixed this problem - we will insert new Approved by All Authors for each new FC
					
					//Benjamin & Brandon found this bug during smoke test on 7/23/2013
					//we need to move 'Approved by all authors' to the current FPR Cycle if its actual date is being filled for the first time.
					if ( changedStatus.id == StatusModel.AuthorApprovals.id && oldPubStatus.ActualDate__c == null) {
						//temp patch for def #484 
						//the newPubStatus is readonly even for sysAdmin
						//temp diable for now.
						//newPubStatus.FPR_Cycle__c = getPubCurrentFprCycleId(newPubStatus.publication_id__c);
					}
					*/
					
					//R1.3 - Def #629 - award ME in PubME table when SubmittedCompleted get actual date
					if ( changedStatus.id == StatusModel.SubmittedCompleted.id) {
						AppearPubModel submittedCompletedPubModel = new AppearPubModel(newPubStatus.Publication_id__c);
						submittedCompletedPubModel.PubMe.AwardMeForSubmittedCompleted(submittedCompletedPubModel, newPubStatus);
					}   
					 
					//Release 1.3 - Non Material Change - Def #629
					//1.Status of "Non - Material Change" is not recorded unless it occurs after Publication is Submitted or Resent to a Target as per the Business Process
    				//2.There is no increment in FPR Cycle when this status is selected
    				//3.Non - Material Change status can occur at any point during the Publication lifecycle to record the information on need basis
    				//4.Ability to calculate ME+ after this Status is entered for the 1st Writing Coordinator for the same Submission Cycle
					if ( changedStatus.id == StatusModel.NonMaterialChange.id) {
						
						
						//AppearPubModel nonMaterialChangePubModel = new AppearPubModel(newPubStatus.Publication_id__c);
						//nonMaterialChangePubModel.PubMe.AwardMeForNonMaterialChange(nonMaterialChangePubModel); 
						
						//nothing to do here since ME will not be awarded until Resent
					}
				
					//2013-10-23 - discussed with Sesha - no need to send email for Terminate -  [ || changedStatus.id == StatusModel.TerminateFPRCycle.Id ]	
					if ( changedStatus.id == StatusModel.FprWithdrawn.id ) {					
						//def 332 - send email when Publication is WithDrawn from FPR
						
						List<Id> ToAddressIds = new List<Id>();
						List<Id> CcAddressIds = new List<Id>();
						
						AppearPubModel withdrawnPubModel = new AppearPubModel(newPubStatus.Publication_id__c);
						withdrawnPubModel.PubReviewTeam.showCurrentCycleReviewer = true;
						
						if (changedStatus.id == StatusModel.FprWithdrawn.id && withdrawnPubModel.pubRecord.isFPR__c) { //Change ownership to FprSubmitter__c's associated UserId.
							withdrawnPubModel.ChangeOwnershipToFprSubmitter(true);
							AppearPubModel.resetSharing(newPubStatus.Publication_id__c);
						}
						
						List<PubReviewTeam__c> allReviewTeam = PubReviewTeamModel.getReviewTeamMembersCurrentCycle(newPubStatus.Publication_id__c,withdrawnPubModel, false);
						
						for(PubReviewTeam__c pubReview : allReviewTeam ) {
							
							if (pubReview.Type__c == 'Primary' ){
								ToAddressIds.add(pubReview.Reviewer__c);
							} else {
								CcAddressIds.add(pubReview.Reviewer__c);
							}
							
							if ( pubReview.ProxyMember__c <> null) {
								PubReviewTeam__c proxyPubReviewTeam = PubReviewTeamNoSharingModel.loadPubReviewTeamRecord(pubReview.ProxyMember__c);
								if (proxyPubReviewTeam <> null) {
									ToAddressIds.add(proxyPubReviewTeam.reviewer__c);
								}
							}
						}								
						
						ToAddressIds.add(withdrawnPubModel.PubRecord.Fpr_Submitter__c);
						CcAddressIds.add(withdrawnPubModel.PubRecord.Assigned_FPRC__c);
						 
						Email_06_PubWithdrawn email = new Email_06_PubWithdrawn(ToAddressIds, CcAddressIds, withdrawnPubModel.pubRecord);
						email.sendEmail();
					}
						
					if ( changedStatus.id == StatusModel.FprWithHeld.id) {
						AppearPubModel withheldPubModel = new AppearPubModel( newPubStatus.Publication_id__c);
						
						//send email when Publication is Withheld from FPR							
						//for a trigger - more efficient to directly retrieve the pub record
		
						withheldPubModel.PubReviewTeam.showCurrentCycleReviewer = true;
						id withheldReviewerId = withheldPubModel.PubReviewTeam.LoggedInTeamMemberForCycle == null ? null : withheldPubModel.PubReviewTeam.LoggedInTeamMemberForCycle.Id;
						
						List<Id> ToAddressIds = new List<Id>();
						List<Id> CcAddressIds = new List<Id>();
						
						ToAddressIds.add(withheldPubModel.PubRecord.Fpr_Submitter__c);
						CcAddressIds.add(withheldPubModel.PubRecord.Assigned_FPRC__c);
						
						List<PubReviewTeam__c> allReviewTeamWithheld = PubReviewTeamModel.getReviewTeamMembersCurrentCycle(newPubStatus.Publication_id__c, withheldPubModel, false);
						for(PubReviewTeam__c pubReview : allReviewTeamWithheld ) {
							if (pubReview.Type__c == 'Primary' ){
								ToAddressIds.add(pubReview.Reviewer__c);
							} else {
								CcAddressIds.add(pubReview.Reviewer__c);
							}
							
							if ( pubReview.ProxyMember__c <> null) {
								PubReviewTeam__c proxyPubReviewTeam = PubReviewTeamNoSharingModel.loadPubReviewTeamRecord(pubReview.ProxyMember__c);
								if (proxyPubReviewTeam <> null) {
									ToAddressIds.add(proxyPubReviewTeam.Reviewer__c);
								} else {
									AppLogModel.LogInfo('Email_05_PubWithheld', 'could not find proxyPubReviewTeam '+pubReview.ProxyMember__c, 
										newPubStatus.Publication_id__c);
								}
							}
						}			
					
						
						
						Email_05_PubWithheld email = new Email_05_PubWithheld(ToAddressIds, CcAddressIds, withheldReviewerId, withheldPubModel.pubRecord);
						email.sendEmail();
						
						AppLogModel.LogInfo('PubStatusTriggerLogic::PubStatusTriggerAfterUpsert', 
								'send email to reviewer after FPR Withheld ', withheldPubModel.PubName);			
						withheldPubModel.ChangeOwnershipToFprSubmitter(true); // will cause update on pub
						
						withheldPubModel.resetSharing();
						//AppearPubModel.resetSharing(newPubStatus.Publication_id__c); //always reset apex sharing after ownership change
						
					}
					
					
					//Def #621 A - isPlanning
					if ( changedStatus.id == StatusModel.Concept.id ){
						AppearPubModel conceptPubModel = new AppearPubModel(newPubStatus.Publication_id__c);
						conceptPubModel.pubRecord.isPlanning__c = (!conceptPubModel.pubRecord.Is_Tracking_Only__c && !conceptPubModel.pubRecord.isISS__c);
						update conceptPubModel.pubRecord;
					}
					
					//Def #621 B - isExecution
					if ( changedStatus.id == StatusModel.ProposalComplete.id ||  changedStatus.id == StatusModel.Created.id ){
						AppearPubModel isExecutionPubModel = new AppearPubModel(newPubStatus.Publication_id__c);
						isExecutionPubModel.pubRecord.isExecution__c = true;
						update isExecutionPubModel.pubRecord;
					}
						
				}  else {
					AppLogModel.LogError('PubStatusTriggerLogic::PubStatusTriggerAfterUpsert', 
						'Found new Actual Date for PubStatus = '+ newPubStatus.Status__c);
				}
			}
		}
 
		AppLogModel.flushLogs();
	}

	//for a trigger - more efficient to directly retrieve the pub record	
	private static Publication__c getPubForEmail(id PubId) {
		List<Publication__c> activePubRecords = [
			Select CreatedById, Assigned_FPRC__c, FPR_Submitter__c 
			from Publication__c 
			WHERE Id = :PubId
		];
		
		if ( activePubRecords.size() == 1) {
			return activePubRecords[0];
		} else {
			return null;
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////

	
	private static set<Id> findPubfromPubStatusMap(Map<Id,PubStatus__c> pubStatusMap){
		set<id> PubIds = new set<id>();
		for (PubStatus__c pubStatus : pubStatusMap.values()){
			PubIds.add(pubStatus.Publication_id__c);
		}	
		
		string msg = 'found '+PubIds.size()+' publication record(s).';
		AppLogModel.LogInfo('PubStatusTriggerLogic::findPubfromPubStatusMap', msg);
		return PubIds;	
	}
	private static set<Id> findPubfromPubStatus(List<PubStatus__c> pubStatusList){
		set<id> PubIds = new set<id>();
		for (PubStatus__c pubStatus : pubStatusList){
			PubIds.add(pubStatus.Publication_id__c);
		}	
		
		string msg = 'found '+PubIds.size()+' publication record(s).';
		AppLogModel.LogInfo('PubStatusTriggerLogic::findPubfromPubStatus', msg);
		return PubIds;	
	}

	

}