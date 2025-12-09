global class StatusModel {
	//recordType - Department_Status, Global_Status
	global static final string GlobalStatus = 'Global_Status';
	global static final string DeptStatus = 'Department_Status';
	global static final string AutoInsertStatus = 'AutoInsert';
	global static final string LegacyInsertStatus = 'Legacy Status';
	
	global static final string InFprStatus = 'In FPR';
	global static final string AssignedToFprcStatus = 'Assigned to FPRC';
	global static final string SubmittedCompletedStatus = 'Submitted/Completed';
	global static final string CancelledStatus = 'Cancelled';
	global static final string WithDrawnStatus = 'Withdrawn from Target';
	global static final string OnHoldStatus = 'On Hold';
	global static final string RejectedStatus = 'Rejected';
	global static final string FprOnlyStatus = 'Pending FPR Submission';
	
	//global static final string ResendStatus = 'Resend'; Commented by Anu since Status not being used
	
	
	global static final string CreatedStatus = 'Created';
	global static final string ConceptStatus = 'Concept';
	global static final string RoutedStatus = 'Routed';
	global static final string PendingSuggestionStatus = 'Pending Suggestion';
	global static final string SuggestedStatus = 'Suggested';
	global static final string AuthorApprovalsStatus = 'Approved by all Authors';
	global static final string AuthorNotApprovedStatus = 'Not Approved by all Authors';	
	global static final string TerminateFPRCycleStatus = 'Terminate FPR Cycle';
	global static final string DraftStatus = 'Draft';
	global static final string AcceptedStatus = 'Accepted';
	
	global static final string FprWithHeldStatus = 'FPR Withheld';
	global static final string FprWithdrawnStatus = 'FPR Withdrawn';
	global static final string DiscussionRequiredStatus = 'Discussion Required';
	global static final string FprCompletedWithCommentStatus = 'FPR Completed with Comments';
	global static final string FprCompletedStatus = 'FPR Completed';
	global static final string FprCourtesyCompletedWithCommentStatus = 'Courtesy FPR Completed with Comments';
	global static final string FprCourtesyCompletedStatus = 'Courtesy FPR Completed';
	global static final string MaterialChangesForCongressJournalStatus = 'Material Changes for Congress/Journal';
	global static final string ResentStatus = 'Resent';
	global static final string PublishedPresentedStatus = 'Published/Presented';
	
	//Following Statuses were added by Anu
	global static final string UnknownStatus = 'Unknown';
	global static final string SuggestionRejectedStatus = 'Suggestion Rejected';
	global static final string ProposalCompleteStatus = 'Proposal Complete';
	global static final string StartedStatus = 'Started';
	global static final string DataAnalysisAvailableStatus = 'Data Analysis Available';
	global static final string AuthorAgreementsSentStatus = 'Author Agreements Sent';
	global static final string KickOffMeetingMinutesMemoStatus = 'Kick-Off Meeting Minutes / Memo';
	global static final string OutlineStatus = 'Outline';
	global static final string DraftCirculatedStatus = '1st Draft Circulated';
	global static final string DraftReviewedStatus = '1st Draft Reviewed';
	global static final string WithheldStatus = 'Withheld';
	global static final string ApprovedStatus = 'Approved';
	global static final string MaterialChangesforAuthorsStatus = 'Material Changes for Authors';
	global static final string NonMaterialChangeStatus = 'Non-Material Change';
	global static final string OnlineEarlyReleaseStatus = 'Online Early Release';
	
	// CCB 258
	global static final string MaterialChangeforSubsequentSubmissionStaus = 'Material Changes for New Target'; 
	global static final string NonMaterialChangeforSubsequentSubmissionStatus = 'Non-Material Changes for New Target'; 
		
	// Author collaboration status Publication Author / AuthorStatus
	global static final string AuthorPendingInviteDelivery = 'Pending Invite Delivery';
	global static final string AuthorPendingInviteAcceptance = 'Pending Invite Acceptance';
	global static final string AuthorPublicationReviewbyAuthors = 'Publication Review by Authors';
	global static final string AuthorPendingAuthorApproval = 'Pending Author Approval';
	global static final string AuthorCompletedAuthorApproval = 'Completed Author Approval';
	global static final string AuthorInviteCancelled = 'Invite Cancelled';
	global static final string AuthorApprovalRejected = 'Approval Rejected';

					
	
	private static Set<id> pInFprcStatusIdSet = null;
	public static Set<id> InFprcStatusIdSet {
		get {
			if ( pInFprcStatusIdSet == null) {
				set<string> InFprStatusNameSet = new set<string>();
				InFprStatusNameSet.add(InFprStatus);
				InFprStatusNameSet.add(AssignedToFprcStatus);
				
				List<Status__c> inFprStatusList = [
					select id
					from Status__c
					where name in :InFprStatusNameSet];
					
				pInFprcStatusIdSet = new Set<Id>();
				for(status__c status : inFprStatusList) {
					pInFprcStatusIdSet.add(status.id);
				}
			}
			return pInFprcStatusIdSet;
		}
	}
	
	private static Set<id> pSubmittedStatusIdSet = null;
	public static Set<id> SubmittedStatusIdSet {
		get {
			if (pSubmittedStatusIdSet == null) {
				pSubmittedStatusIdSet = new set<id> ();
				for ( Status__c status : StatusList) {
					if ( status.stage__c == 'Submit') {
						pSubmittedStatusIdSet.add(status.id);		
						//AppLogModel.LogDebug('StatusModel::SubmittedStatusSet', 'SubmittedStatusSet adding '+ status.name +' stage = '+status.stage__c);
					}
				}
				//pSubmittedStatusIdSet.add(LookUpStatus(SubmittedCompletedStatus).id);
			}

			return pSubmittedStatusIdSet;
		}
	}
		
	//Following Code was added by Anu for the new statuses
	private static Status__c pUnknown = null;
	public static Status__c Unknown{  
		get {
			if ( pUnknown == null) {
				pUnknown = LookUpStatus(UnknownStatus);
			}
			return pUnknown;
		}
	}

	private static Status__c pSuggested = null;
	public static Status__c Suggested{
		get {
			if ( pSuggested == null) {
				pSuggested = LookUpStatus(SuggestedStatus);
			}
			return pSuggested;
		}
	}

	
	private static Status__c pSuggestionRejected = null;
	public static Status__c SuggestionRejected{
		get {
			if ( pSuggestionRejected == null) {
				pSuggestionRejected = LookUpStatus(SuggestionRejectedStatus);
			}
			return pSuggestionRejected;
		}
	}

	private static Status__c pProposalComplete = null;
	public static Status__c ProposalComplete{
		get {
			if ( pProposalComplete == null) {
				pProposalComplete = LookUpStatus(ProposalCompleteStatus);
			}
			return pProposalComplete;
		}
	}

	private static Status__c pStarted = null;
	public static Status__c Started{
		get {
			if ( pStarted == null) {
				pStarted = LookUpStatus(StartedStatus);
			}
			return pStarted;
		}
	}		
	
	private static Status__c pDataAnalysisAvailable = null;
	public static Status__c DataAnalysisAvailable{
		get {
			if ( pDataAnalysisAvailable == null) {
				pDataAnalysisAvailable = LookUpStatus(DataAnalysisAvailableStatus);
			}
			return pDataAnalysisAvailable;
		}
	}

	private static Status__c pAuthorAgreementsSent = null;
	public static Status__c AuthorAgreementsSent{
		get {
			if ( pAuthorAgreementsSent == null) {
				pAuthorAgreementsSent = LookUpStatus(AuthorAgreementsSentStatus);
			}
			return pAuthorAgreementsSent;
		}
	}

	private static Status__c pKickOffMeetingMinutesMemo = null;
	public static Status__c KickOffMeetingMinutesMemo{
		get {
			if ( pKickOffMeetingMinutesMemo == null) {
				pKickOffMeetingMinutesMemo = LookUpStatus(KickOffMeetingMinutesMemoStatus);
			}
			return pKickOffMeetingMinutesMemo;
		}
	}

	private static Status__c pOutline = null;
	public static Status__c Outline{
		get {
			if ( pOutline == null) {
				pOutline = LookUpStatus(OutlineStatus);
			}
			return pOutline;
		}
	}

	private static Status__c pDraftCirculated = null;
	public static Status__c DraftCirculated{
		get {
			if ( pDraftCirculated == null) {
				pDraftCirculated = LookUpStatus(DraftCirculatedStatus);
			}
			return pDraftCirculated;
		}
	}

	private static Status__c pDraftReviewed = null;
	public static Status__c DraftReviewed{
		get {
			if ( pDraftReviewed == null) {
				pDraftReviewed = LookUpStatus(DraftReviewedStatus);
			}
			return pDraftReviewed;
		}
	}

	private static Status__c pWithheld = null;
	public static Status__c Withheld{
		get {
			if ( pWithheld == null) {
				pWithheld = LookUpStatus(WithheldStatus);
			}
			return pWithheld;
		}
	}


	private static Status__c pApproved= null;
	public static Status__c Approved{
		get {
			if ( pApproved == null) {
				pApproved = LookUpStatus(ApprovedStatus);
			}
			return pApproved;
		}
	}

	private static Status__c pMaterialChangesforAuthors= null;
	public static Status__c MaterialChangesforAuthors{
		get {
			if ( pMaterialChangesforAuthors == null) {
				pMaterialChangesforAuthors = LookUpStatus(MaterialChangesforAuthorsStatus);
			}
			return pMaterialChangesforAuthors;
		}
	}

	private static Status__c pNonMaterialChange= null;
	public static Status__c NonMaterialChange{
		get {
			if ( pNonMaterialChange == null) {
				pNonMaterialChange = LookUpStatus(NonMaterialChangeStatus);
			}
			return pNonMaterialChange;
		}
	}

	private static Status__c pOnlineEarlyRelease= null;
	public static Status__c OnlineEarlyRelease{
		get {
			if ( pOnlineEarlyRelease == null) {
				pOnlineEarlyRelease = LookUpStatus(OnlineEarlyReleaseStatus);
			}
			return pOnlineEarlyRelease;
		}
	}
	// New Status change completed
		
	private static Status__c pPublishedPresented = null;
	public static Status__c PublishedPresented{
		get {
			if ( pPublishedPresented == null) {
				pPublishedPresented = LookUpStatus(PublishedPresentedStatus);
			}
			return pPublishedPresented;
		}
	}
	
	
	private static Status__c pRouted = null;
	public static Status__c Routed{
		get {
			if ( pRouted == null) {
				pRouted = LookUpStatus(RoutedStatus);
			}
			return pRouted;
		}
	}
	
	
	
	private static Status__c pCreated = null;
	public static Status__c Created{
		get {
			if ( pCreated == null) {
				pCreated = LookUpStatus(CreatedStatus);
			}
			return pCreated;
		}
	}
	
	private static Status__c pFprWithdrawn = null;
	public static Status__c FprWithdrawn{
		get {
			if ( pFprWithdrawn == null) {
				pFprWithdrawn = LookUpStatus(FprWithdrawnStatus);
			}
			return pFprWithdrawn;
		}
	}
	
	private static Status__c pAccepted = null;
	public static Status__c Accepted{
		get {
			if ( pAccepted == null) {
				pAccepted = LookUpStatus(AcceptedStatus);
			}
			return pAccepted;
		}
	}
		
	private static Status__c pAuthorApprovals = null;
	public static Status__c AuthorApprovals{
		get {
			if ( pAuthorApprovals == null) {
				pAuthorApprovals = LookUpStatus(AuthorApprovalsStatus);
			}
			return pAuthorApprovals;
		}
	}
	
	private static Status__c pAuthorNotApproved = null;
	public static Status__c AuthorNotApproved{
		get {
			if ( pAuthorNotApproved == null) {
				pAuthorNotApproved = LookUpStatus(AuthorNotApprovedStatus);
			}
			return pAuthorNotApproved;
		}
	}
	
	
	private static Status__c pTerminateFPRCycle = null;
	public static Status__c TerminateFPRCycle{
		get {
			if ( pTerminateFPRCycle == null) {
				pTerminateFPRCycle = LookUpStatus(TerminateFPRCycleStatus);
			}
			return pTerminateFPRCycle;
		}
	}
	
	private static Status__c pConcept = null;
	public static Status__c Concept{
		get {
			if ( pConcept == null) {
				pConcept = LookUpStatus(ConceptStatus);
			}
			return pConcept;
		}
	}
	
	
	private static Status__c pDraft = null;
	public static Status__c Draft{
		get {
			if ( pDraft == null) {
				pDraft = LookUpStatus(DraftStatus);
			}
			return pDraft;
		}
	}
	private static Status__c pPendingSuggestion = null;
	public static Status__c PendingSuggestion{
		get {
			if ( pPendingSuggestion == null) {
				pPendingSuggestion = LookUpStatus(PendingSuggestionStatus);
			}
			return pPendingSuggestion;
		}
	}
	private static Status__c pAssignedToFPRC = null;
	public static Status__c AssignedToFPRC{
		get {
			if ( pAssignedToFPRC == null) {
				pAssignedToFPRC = LookUpStatus(AssignedToFprcStatus);
			}
			return pAssignedToFPRC;
		}
	}
	
	private static Status__c pFPROnly = null;
	public static Status__c FPROnly{
		get {
			if ( pFPROnly == null) {
				pFPROnly = LookUpStatus(FprOnlyStatus);
			}
			return pFPROnly;
		}
	}
	
	
	private static Status__c pCancelled = null;
	public static Status__c Cancelled{
		get {
			if ( pCancelled == null) {
				pCancelled = LookUpStatus(CancelledStatus);
			}
			return pCancelled;
		}
	}
	
	private static Status__c pSubmittedCompleted = null;
	public static Status__c SubmittedCompleted{
		get {
			if ( pSubmittedCompleted == null) {
				pSubmittedCompleted = LookUpStatus(SubmittedCompletedStatus);
			}
			return pSubmittedCompleted;
		}
	}
	
	

	private static Status__c pInFpr = null;
	public static Status__c InFpr{
		get {
			if ( pInFpr == null) {
				pInFpr = LookUpStatus(InFprStatus);
			}
			return pInFpr;
		}
	}
	
	private static Status__c pMaterialChangesForCongressJournal = null;
	public static Status__c MaterialChangesForCongressJournal{
		get {
			if ( pMaterialChangesForCongressJournal == null) {
				pMaterialChangesForCongressJournal = LookUpStatus(MaterialChangesForCongressJournalStatus);
			}
			return pMaterialChangesForCongressJournal;
		}
	}
	
	
	private static Status__c pResent = null;
	public static Status__c Resent{
		get {
			if ( pResent == null) {
				pResent = LookUpStatus(ResentStatus);
			}
			return pResent;
		}
	}
			
	private static Status__c pRejected = null;
	public static Status__c Rejected{
		get {
			if ( pRejected == null) {
				pRejected = LookUpStatus(RejectedStatus);
			}
			return pRejected;
		}
	}
	
	private static Status__c pOnHold = null;
	public static Status__c OnHold{
		get {
			if ( pOnHold == null) {
				pOnHold = LookUpStatus(OnHoldStatus);
			}
			return pOnHold;
		}
	}

	private static Status__c pWithDrawn = null;
	public static Status__c WithDrawn{
		get {
			if ( pWithDrawn == null) {
				pWithDrawn = LookUpStatus(WithDrawnStatus);
			}
			return pWithDrawn;
		}
	}	
	
	
	public static Id FprCompletedId {
		get {
			if ( FprCompleted <> null) {
				return FprCompleted.id;
			} else {
				return null;
			}
		}
	}
	
	private static Status__c pFprCompleted = null;
	public static Status__c FprCompleted{
		get {
			if ( pFprCompleted == null) {
				pFprCompleted = LookUpStatus(FprCompletedStatus);
			}
			return pFprCompleted;
		}
	}
	
	private static Status__c pFprCourtesyCompleted = null;
	public static Status__c FprCourtesyCompleted{
		get {
			if ( pFprCourtesyCompleted == null) {
				pFprCourtesyCompleted = LookUpStatus(FprCourtesyCompletedStatus);
			}
			return pFprCourtesyCompleted;
		}
	}
	
	private static Status__c pFprCourtesyCompletedWithComment = null;
	public static Status__c FprCourtesyCompletedWithComment{
		get {
			if ( pFprCourtesyCompletedWithComment == null) {
				pFprCourtesyCompletedWithComment = LookUpStatus(FprCourtesyCompletedWithCommentStatus);
			}
			return pFprCourtesyCompletedWithComment;
		}
	}
	
	private static Status__c pFprWithHeld = null;
	public static Status__c FprWithHeld{
		get {
			if ( pFprWithHeld == null) {
				pFprWithHeld = LookUpStatus(FprWithHeldStatus);
			}
			return pFprWithHeld;
		}
	}	

	private static Status__c pDiscussionRequired = null;
	public static Status__c DiscussionRequired{
		get {
			if ( pDiscussionRequired == null) {
				pDiscussionRequired = LookUpStatus(DiscussionRequiredStatus);
			}
			return pDiscussionRequired;
		}
	}
	
	private static Status__c pFprCompletedWithComment = null;
	public static Status__c FprCompletedWithComment{
		get {
			if ( pFprCompletedWithComment == null) {
				pFprCompletedWithComment = LookUpStatus(FprCompletedWithCommentStatus);
			}
			return pFprCompletedWithComment;
		}
	}

	// CCB 258 
	private static Status__c pMaterialChangeforSubsequentSubmission = null;
	public static Status__c MaterialChangeforSubsequentSubmission{
		get {
			if ( pMaterialChangeforSubsequentSubmission == null) {
				pMaterialChangeforSubsequentSubmission = LookUpStatus(MaterialChangeforSubsequentSubmissionStaus);
			}
			return pMaterialChangeforSubsequentSubmission;
		}
	}
	
	private static Status__c pNonMaterialChangeforSubsequentSubmission = null;
	public static Status__c NonMaterialChangeforSubsequentSubmission{
		get {
			if ( pNonMaterialChangeforSubsequentSubmission == null) {
				pNonMaterialChangeforSubsequentSubmission = LookUpStatus(NonMaterialChangeforSubsequentSubmissionStatus);
			}
			return pNonMaterialChangeforSubsequentSubmission;
		}
	}
		
	
	public static Status__c LookUpStatus(string status){
		if ( StatusMap.containsKey(status)){
			return statusMap.get(status);
		} else {
			return null;
		}
	}
	
	private static Map<Id,Status__c> pStatusMapById = null;
	public static Map<Id,Status__c> StatusMapById {
		get {
			if ( pStatusMapById == null) {
				pStatusMapById = new Map<Id,Status__c>();
				for(Status__c status : StatusList ) {
					pStatusMapById.put(status.Id, status);
				}
			}
			return pStatusMapById;
		}
	}

	
	private static Map<string,Status__c> pStatusMap = null;
	public static Map<string,Status__c> StatusMap {
		get {
			if ( pStatusMap == null) {
				pStatusMap = new Map<string,Status__c>();
				for(Status__c status : StatusList ) {
					pStatusMap.put(status.name, status);
				}
			}
			return pStatusMap;
		}
	}

	private static List<Status__c> pGlobalStatusList = null;
	public static List<Status__c> GlobalStatusList {
		get {
			if ( pGlobalStatusList == null) {
				pGlobalStatusList = getStatusByRecordType(GlobalStatus);
			}
			return pGlobalStatusList;
		}
	}
	
	private static List<Status__c> pReTargetSingletonStatusList = null;
	public static List<Status__c> ReTargetSingletonStatusList {
		get {
			if ( pReTargetSingletonStatusList == null) {
				pReTargetSingletonStatusList = new List<Status__c>();
				pReTargetSingletonStatusList.add(StatusModel.Accepted);
				pReTargetSingletonStatusList.add(StatusModel.PublishedPresented);
			}
			return pReTargetSingletonStatusList;
		}
	}

	private static List<Status__c> pResetFprCycleStatusList = null;
	public static List<Status__c> ResetFprCycleStatusList {
		get {
			if ( pResetFprCycleStatusList == null) {
				pResetFprCycleStatusList = new List<Status__c>();
				pResetFprCycleStatusList.add(StatusModel.Accepted);
				pResetFprCycleStatusList.add(StatusModel.SubmittedCompleted);
				pResetFprCycleStatusList.add(StatusModel.PublishedPresented);
				pResetFprCycleStatusList.add(StatusModel.AuthorApprovals);
			}
			return pResetFprCycleStatusList;
		}
	}
	
	
	private static List<Status__c> pNewStatusAfterTerminateFPRCycleList = null;
	public static List<Status__c> NewStatusAfterTerminateFPRCycleList {
		get {
			if ( pNewStatusAfterTerminateFPRCycleList == null) {
				pNewStatusAfterTerminateFPRCycleList = new List<Status__c>();
				for(Status__c status : StatusList) {
					if ( status.New_Status_After_Terminate_FPR__c) {
						pNewStatusAfterTerminateFPRCycleList.add(status);
					}
				}
			}
			return pNewStatusAfterTerminateFPRCycleList;
		}
	}

	
	private static List<Status__c> pDepartmentStatusList = null;
	public static List<Status__c> DepartmentStatusList {
		get {
			if ( pDepartmentStatusList == null) {
				pDepartmentStatusList = getStatusByRecordType(DeptStatus);
			}
			return pDepartmentStatusList;
		}
	}

	private static List<Status__c> pAutoInsertStatusList = null;
	public static List<Status__c> AutoInsertStatusList {
		get {
			if ( pAutoInsertStatusList == null) {
				pAutoInsertStatusList = getStatusByRecordType(AutoInsertStatus);
			}
			return pAutoInsertStatusList;
		}
	}


	private static List<Status__c> pStatusList = null;
	public static List<Status__c> StatusList {
		get {
			if ( pStatusList == null) {
				pStatusList = getAllStatus();
			}
			return pStatusList;
		}
	}
	
	public static List<Status__c> getStatusByRecordType(string recordTypeName) {
		RecordType recType = RecordTypeModel.LookupRecordType('Status__c', recordTypeName);
		if(recType == null){
			return new List<Status__c>();
		}
		
		List<Status__c> statusByRecordTypeList = new List<Status__c>();
		for(Status__c status : StatusList) {
			if ( status.RecordTypeId == recType.id) {
				statusByRecordTypeList.add(status);
			}
		}
		return statusByRecordTypeList;
	}
	
	public static List<Status__c> getAllStatus() {
		List<Status__c> status = [
			Select s.displayOrder__c, s.RecordTypeId, s.RecordType.Name, s.Name, s.stage__c, 
				s.PubRecordType__c, s.New_Status_After_Terminate_FPR__c
			From Status__c s
			order by s.displayOrder__c
		];
		return status;
	}
	

	///////////////  JS Remote support //////////////////
	@remoteAction
	global static List<Status__c> findStatusByTypeName(string recordTypeName, string startWith){
		
		string startWithParam = startWith + '%';
		
		List<Status__c> status = [
			select id, name 
			From Status__c 
			where Name like :startWithParam
			and RecordType.DeveloperName = :recordTypeName
			order by Name
		];
		return status;		
	}


}