public class PubAttachmentModel extends AppearBaseModel {
    
    public final static string AuthorApprovalsAttachmentType = 'Author Approvals';
    public final static string LegacyMWT_InteractionsAttachmentType = 'MWT Author Interactions';
    public final static string DraftSentForFPRAttachmentType = 'Draft Sent for FPR';
    public final static string SentForFPAAttachmentType = 'Sent for FPA Approval';
    public final static string FinalAttachmentForAuthorApprovalsType = 'Final Attachment for Author Approval';
    public final static string authorLimitJustification = 'Author Limit Justification'; //Appear Enhancement R1:2017
    public string attachmentPubId{get;set;}//Appear Enhancement 2017 Backlog R3 Release.
    
    public id PubId { get ; set; }
    private string ActiveTile;
    private string ActiveSubMenu; 
    private id SubmissionCycleId; 
    private id FprCycleId;
    private boolean IsFprTab;
    private boolean IsFprOnlyTab;
    private AppearPubModel pubModel;
    public boolean IsFPROnlyPublication{get;set;}
	
    public boolean HasVotedForCurrentCycle {
        get {
            if ( pubModel.pubReviewTeam.LoggedInTeamMemberForCycle == null) {
                return false;
            } else {
                return pubModel.pubReviewTeam.LoggedInTeamMemberForCycle.hasVoted__c;
            }
        }
    }
    
    //Def 306 Reviewers should not be able to delete attachments after they've voted
    // - in other words - reviewer should only be able to delete their own attachment before they Vote
    //
    //The VF page will use the following logic at the row level to implement this.
    //Keeping public sharing model of junction
    // in VF, foreach row in attachments tile - show delete checkbox if (AttachmentModel.AllowAllDelete) || (OwnerId == currentUser && !HasVoted__c)
    //
    //always allow SysAdmin to delete
    public boolean AllowAllDelete {
        get {
            //Def #659 - give BA / FPRC / IFPRC ability to delete any attachment
            if ( ProfileModel.isSysAdmin || ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC) {
                
                return true;
            }
            return false;
        }
    }

    
    public boolean canViewAttachments { //if able to see tile, PubTeam has further restrictions on can view attachments
        get {
            if (ProfileModel.isAppearPubTeam) 
            {               
                Set<id> contactIds = AppearContactModel.findContactForAppearUser(userinfo.getUserId());
                if (contactIds.size() == 0) {
                    return false;
                }
                if( contactids.contains( pubModel.pubRecord.Fpr_Submitter__c) || pubModel.pubRecord.createdById == userinfo.getUserId() ) {
                    return true;
                }else if( pubModel.PubTeamMember.LoggedInTeamMember == null) { //pubteam member must be member of the pub team to view attachments
                    return false;
                }
            }
            
            return true; //no one else has this restriction
        }
    }

    public boolean canAddDelAttachments {
        get{
            return CheckUserAccessModel.CheckEditAccess(PubId);
        }
    }

    
    //Reviewers should not be able to upload attachments after they've voted
    //Show add button only if (AttachmentModel.AllowAddAttachments)
    public boolean AllowAddAttachments {
        get {
            
            boolean result = false;
            
            //Def #666
            //Step A: BusAdmin should be able to add/delete attachments anytime (any Pub Status)
            if ( ProfileModel.isSysAdmin || ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearGPPL || ProfileModel.isAppearExternalWriter || ProfileModel.isAppearWriting || 
                ProfileModel.isAppearIntFPRC || ProfileModel.isAppear626 || ProfileModel.isAppearHyperCare ) {
                result = true;
                
            } else if ( ProfileModel.isAppearFPRC ) {
            
                //Def #666
                //Step B: FPRC/IFPRC should be able to add/delete attachments during 
                //"In FPR", "Assigned to FPR", "Routed", "FPR Completed", "FPR Completed with Comments", 
                //"FPR Withheld", "Courtesy FPR Completed", "Courtesy FPR Completed with Comments", "FPR Withdrawn" statuses
                    
                if ( AllowFprcIntFprcAddDelAttachment (pubModel.pubRecord.pubStatus__r.Status__c) ) {
                    result = true;
                } else {
                    result = false;
                }
                
            } else if ( pubModel.pubRecord.isFPROnly__c && pubModel.pubRecord.CreatedById == UserInfo.getUserId()) { 
                
                //FPR_Submitter__C will not be set until submitted to FPR
                //Def #669 Submitter --> AllowAddAttachment :: Status in ('Pending FPR Submission')
                if (pubModel.pubRecord.pubStatus__r.Status__c == StatusModel.FPROnly.Id ||
                    pubModel.pubRecord.pubStatus__r.Status__c == StatusModel.FprWithHeld.Id ||
                    pubModel.pubRecord.pubStatus__r.Status__c == StatusModel.FprWithdrawn.Id)
                {
                    result = true;
                } else {
                    result = false;
                }
                
            } else if ( pubModel.PubReviewTeam.LoggedInTeamMemberForCycle <> null) {   
                //Def #669 reviewers can add if Status in ('Routed') && has not voted yet
                
                boolean hasVoted = pubModel.PubReviewTeam.LoggedInTeamMemberForCycle.hasVoted__c;
                if ( pubModel.pubRecord.pubStatus__r.Status__c == StatusModel.Routed.id && !hasVoted ) {
                    result = true;
                } else {
                    result = false;
                }
            } else if ( pubModel.hasEditAccess) {
                result = true;
            } else if ( ProfileModel.isAppearPortalPubAuthor ) { 
                result = true; 
            } else {  //member 
                //not a prilivaged user or a member of the review team and no edit
                //should not be able to add attachment
                result = false; 
            }
            
            AppLogModel.flushLogs();
            return result;
        }
    }
    
    public boolean AllowAnyDelete {
        get{
            //Def #666
            //Step A: BusAdmin should be able to add/delete attachments anytime (any Pub Status)
            if ( ProfileModel.isSysAdmin || ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearGPPL || ProfileModel.isAppearWriting || ProfileModel.isAppearExternalWriter || ProfileModel.isAppearIntFPRC) {
                return true;
            }
            
            if ( ProfileModel.isAppearFPRC ) {
                if ( AllowFprcIntFprcAddDelAttachment (pubModel.pubRecord.pubStatus__r.Status__c) ) {
                    return true;
                }
            }
            
            //Fixed R3.0 - Defect 55. Will display the Delete button for the Reviewer until he/she has Voted on the Publication
            if(ProfileModel.isAppearReviewers && !pubModel.PubAttachments.HasVotedForCurrentCycle){
                return true;
            }
            
            return canAddDelAttachments;
        }
    }
    
    //Def #666
    private boolean AllowFprcIntFprcAddDelAttachment( Id StatusId) {
        if ( StatusId == StatusModel.InFpr.id) {
            return true;
        } else if ( StatusId == StatusModel.AssignedToFPRC.id) {
            return true;
        } else if ( StatusId == StatusModel.Routed.id) {
            return true;
        } else if ( StatusId == StatusModel.FprCompleted.id) {
            return true;
        } else if ( StatusId == StatusModel.FprCompletedWithComment.id) {
            return true;
        } else if ( StatusId == StatusModel.FprWithHeld.id) {
            return true;
        } else if ( StatusId == StatusModel.FprCourtesyCompleted.id) {
            return true;
        } else if ( StatusId == StatusModel.FprCourtesyCompletedWithComment.id) {
            return true;
        } else if ( StatusId == StatusModel.FprWithdrawn.id) {
            return true;
        } else if ( StatusId == StatusModel.Created.id) {
            return true;
        } else if ( StatusId == StatusModel.PendingSuggestion.id) {
            return true;
        } else if ( StatusId == StatusModel.Suggested.Id) {
            return true;
        } else if ( StatusId == StatusModel.FPROnly.Id ) {
            return true;
        } 
        else {
            return false;
        }
    }
    
    
    private boolean RestrictDelAttachment() {
        
        List <PubStatus__c> pstatuLst = pubModel.PubStatus.PubStatusList;
        Boolean returnVal = false;
        
        for(PubStatus__c tmpPs : pstatuLst){
            if ((tmpPs.Status__c == StatusModel.FprCompleted.id || tmpPs.Status__c == StatusModel.FprCompletedWithComment.id || 
                tmpPs.Status__c == StatusModel.FprCourtesyCompleted.id || tmpPs.Status__c == StatusModel.FprCourtesyCompletedWithComment.id || 
                tmpPs.Status__c == StatusModel.FprWithdrawn.id || tmpPs.Status__c == StatusModel.FprWithHeld.id) && (tmpPs.ActualDate__c <> null)
                && (tmpPs.FPR_Cycle__c ==  FprCycleId)) { //Need to consider the current FPR cycle because the loop is going through the entire PubStatus list
                returnVal = true;
            }
        }
        
        return returnVal;
    }

    
    public boolean CanProfileConfigureAttachments { get;set; }
    
    public Boolean hasDraftSentForFPRAttachmentType{
        get {
            Boolean retVal = false; //This means that there no is "Draft Sent for FPR" attachment for the Publication
            
            for(PubAttachmentDetails__c attachmentDetail : PubAttachmentList) {
                if ( attachmentDetail.AttachmentType__c == DraftSentForFPRAttachmentType) {
                    if (attachmentDetail.FPR_Cycle__c != null 
                            &&  attachmentDetail.FPR_Cycle__c == getCorrectFPRCycleIdForFPRRelatedAttachments(attachmentDetail.AttachmentType__c).Id) {
                        retVal = true; //This means that there is "Draft Sent for FPR" attachment for this new FPR Cycle
                    } 
                }
            }
            
            return retVal; 
        }
    }
    
    private boolean pShowLegacyInfo = false;
    public boolean showLegacyInfo { 
        get {
            //init the PubAttachmentList
            System.Debug(PubAttachmentList.size());
            
            return pShowLegacyInfo;
        }
    }
   
    
    private transient List<PubAttachmentDetails__c> pPubAttachmentList= null;
    public List<PubAttachmentDetails__c> PubAttachmentList{
        get{
            if(pPubAttachmentList== null){
                pPubAttachmentList= getAllPubAttachmentList(PubId);
              
                pShowLegacyInfo = false;
                
                
                if (pPubAttachmentList.size() > 0 ) {
                    for(PubAttachmentDetails__c pad : pPubAttachmentList){
                        if ( pad.LegacyCreatedBy__c <> null ) {
                            pShowLegacyInfo = true;
                        }       
                    }
                } 
                            
                AppLogModel.flushLogs();
            }               
            return pPubAttachmentList;
        }
    }  
    
    private Map<Id, PubAttachmentDetails__c> pPubAttachmentMapById = null;
    public Map<Id, PubAttachmentDetails__c> PubAttachmentMapById{
        get {
            if (pPubAttachmentMapById == null){
                pPubAttachmentMapById = getPubAttachmentMapById();
            }
            return pPubAttachmentMapById;
        }
    }
   
    public Map<Id, PubAttachmentDetails__c> getPubAttachmentMapById() {
        Map<Id, PubAttachmentDetails__c> result = new Map<Id, PubAttachmentDetails__c>();
        for(PubAttachmentDetails__c pPubAttachment : PubAttachmentList){
            result.put(pPubAttachment.Id, pPubAttachment );
        }
        return result;
    }
    
    public PubAttachmentModel(Id PubId,  string tile, string subMenu, Id SubmissionCycleId, Id FprCycleId, boolean CanProfileConfigureAttachments, boolean isFprTab, boolean isFprOnlyTab) {
        this.PubId = PubId;    
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu; 
        this.SubmissionCycleId = SubmissionCycleId;
        this.FprCycleId = FprCycleId;
        this.CanProfileConfigureAttachments = CanProfileConfigureAttachments;
        this.IsFprTab = isFprTab;
        this.IsFprOnlyTab = isFprOnlyTab;
        this.pubModel = new AppearPubModel(PubId);
        this.IsFPROnlyPublication = pubModel.pubRecord.IsFprOnly__c;
        this.attachmentPubId=pubModel.pubRecord.name;//Appear Enhancement 2017 backlog R3- Fetching Publication Name Issue Id -102.
        
    }
   
    public PubAttachmentModel(Id PubId,  string tile, string subMenu, Id SubmissionCycleId, Id FprCycleId, boolean CanProfileConfigureAttachments) {
        this.PubId = PubId;    
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu; 
        this.SubmissionCycleId = SubmissionCycleId;
        this.FprCycleId = FprCycleId;
        this.CanProfileConfigureAttachments = CanProfileConfigureAttachments;
        this.pubModel = new AppearPubModel(PubId);
        this.IsFPROnlyPublication = pubModel.pubRecord.IsFprOnly__c;
        this.attachmentPubId=pubModel.pubRecord.name;//Appear Enhancement 2017 backlog R3- Fetching Publication Name Issue Id-102.
        
    }
    
    //save for updating Attachment Type / notes etc - not for saving new attachments
    public PageReference save() {
        
        database.update(PubAttachmentList, true);
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }   
     
    public PubAttachmentDetails__c getNewAttachment() {
        PubAttachmentDetails__c newAttach = new PubAttachmentDetails__c();
        System.assertNotEquals(null, PubId);
        newAttach.publication__c = PubId; 
        //Appear Enhancement 2017 backlog R3- Fetching Publication Name Issue Id-102: Starts
        //Date dateToday = Date.today();
        Datetime dateToday = System.now();
        String [] mon= new String[]{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
        String mm = mon[dateToday.month()-1];
        String sToday = String.valueof(dateToday.year()) +' '+ mon[dateToday.month()-1] +' '+ String.valueof(dateToday.day())+' '+'GMT';
        String currentPageName ='';
        if(!Test.isRunningTest()){
        	currentPageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');    
        }        
        if(currentPageName == 'AppearFprSubmitter'){
            newAttach.AttachmentName__c =attachmentPubId+' '+'Draft Sent for FPR'+' '+sToday;
        }else if(currentPageName == 'AppearFPR'){
            newAttach.AttachmentName__c =attachmentPubId+' '+'Added by FPR Reviewer'+' '+sToday;
        }else{
            newAttach.AttachmentName__c =attachmentPubId+' '+'Publication Proposal'+' '+sToday;
             }
        //Appear Enhancement 2017 backlog R3- Fetching Publication Name Issue Id-102 : Ends

        if (!CanProfileConfigureAttachments) {
            newAttach.AttachmentType__c = 'Publication Proposal';
        }
        
        PubReviewTeam__c loggedInReviewer = PubReviewTeamModel.getLoggedInTeamMemberForPubFprCycle(PubId, FprCycleId);
        if (loggedInReviewer != null) {
            newAttach.Publication_Review_Team_Member__c = loggedInReviewer.Id;  
        }
        return newAttach;
    }
    
    public PageReference InsertAttachment(PubAttachmentDetails__c newAttachmentToInsert){
        system.debug('InsertAttachmentCall');
        boolean hasError = false;
        
        newAttachmentToInsert.SubmissionCycle__c = SubmissionCycleId;
        newAttachmentToInsert.AttachmentDate__c = Date.Today();
        //newAttachmentToInsert.FPR_Cycle__c = FprCycleId; //Updating the FPR Cycle Num for the Attachment  
        newAttachmentToInsert.FPR_Cycle__c = getCorrectFPRCycleIdForFPRRelatedAttachments(newAttachmentToInsert.AttachmentType__c).Id;
                
        if ( newAttachmentToInsert.AttachmentName__c == null || newAttachmentToInsert.AttachmentName__c == '') {
            AppearAddErrorMessage(AppearErrorMessages.NeedAttachmentName);
            hasError = true;
        }
        
        if ( newAttachmentToInsert.AttachmentType__c == null || newAttachmentToInsert.AttachmentType__c == '') {
            AppearAddErrorMessage(AppearErrorMessages.NeedAttachmentType);
            hasError = true;
        }
        // Appear Enhancement R1:2017 - Author limit justification restriction for FPRC
        if(newAttachmentToInsert.AttachmentType__c =='Author Limit Justification' && ProfileModel.isAppearFPRC){
        	AppearAddErrorMessage(AppearErrorMessages.RestrictAuthorLimitJustificationAdd);
            hasError = true;
        }
        
        newAttachmentToInsert.Attachment_URL__c = AppearUrlModel.ChatterFeedIdToUrl(newAttachmentToInsert.what__c);
        
        ////////////////////////
        
        if ( hasError ){
            AppLogModel.flushLogs();
            
            //return to Modal page to display VF Error Message
            return null;
        }
        
        database.insert(newAttachmentToInsert, true);
		
        //Appear Enhancement R1:2017- Trigger automatic Monitoring and RAE attachment notification.
		if(newAttachmentToInsert.AttachmentType__c == 'RAE Attestation Sec A' || newAttachmentToInsert.AttachmentType__c == 'RAE Attestation Sec B' || newAttachmentToInsert.AttachmentType__c == 'RAE Attestation Sec C' ){
			system.debug('RAE Attachment Added');
			Email_21_MonitoringChecklist.Email_21_MonitoringChecklistBatchLimit(newAttachmentToInsert.Id);
		}
		else if (newAttachmentToInsert.AttachmentType__c == 'Monitoring Checklist Part 1' || newAttachmentToInsert.AttachmentType__c == 'Monitoring Checklist Part 2' || newAttachmentToInsert.AttachmentType__c == 'Monitoring Checklist Part 3'){
			system.debug('Monitoring Attachment Added');
			Email_20_RAEChecklist.Email_20_RAEChecklistBatch(newAttachmentToInsert.Id,PubId);
		}

        if (newAttachmentToInsert.what__c != null && (newAttachmentToInsert.AttachmentType__c == 'Draft - Share with Authors')){

            // for pub Author portal collaboration
            // ContentDocumentLink Has been added for Draft Share with Author issue : CR# CHG0050161 
            FeedItem aFeedItem = [select id, RelatedRecordId, ParentId from FeedItem  where id = :newAttachmentToInsert.what__c limit 1];
            ContentVersion aContentVersion = [select id, ContentDocumentId from ContentVersion where id = :aFeedItem.RelatedRecordId limit 1];       
            ContentDocument aContentDocument=[select Id,ownerId from ContentDocument where id=:aContentVersion.ContentDocumentId];     
            //ContentDocumentLink aContentDocLink = [select id, ContentDocumentId, ShareType from ContentDocumentLink where ContentDocumentId = :aContentVersion.ContentDocumentId limit 1];
            ContentDocumentLink aContentDocLink = [select id, ContentDocumentId, ShareType from ContentDocumentLink where ContentDocumentId = :aContentVersion.ContentDocumentId and LinkedEntityId <> :aContentDocument.ownerId]; 
            system.debug('crossAttachmentsCall ContentDocumentLink'+aContentDocLink);
            system.debug('crossAttachmentsCall ContentDocumentLink ShareType'+aContentDocLink.ShareType);
            aContentDocLink.ShareType = 'C';
            database.update(aContentDocLink, true);

            // email authors with update
            //Email_19_DraftShare.Email_19_DraftShareBatch(PubId); 
            // Commented as part of Appear Enhancement R3 to stop auto email trigger with Draft share with Authors attachment functionality.       
        }
        


        pPubAttachmentMapById = null;  
        pPubAttachmentList= null; 
        AppLogModel.flushLogs();

        return null;
    }
    
    public PageReference InsertFeedItem1() {  
        system.debug('crossAttachmentsCall'); 
        boolean hasError = false;           
        
        PubAttachmentDetails__c newAttachmentToInsert = NewAttachment1;
        
        if ( newAttachmentToInsert.AttachmentName__c == null || newAttachmentToInsert.AttachmentName__c == '') {
            AppearAddErrorMessage(AppearErrorMessages.NeedAttachmentName);
            hasError = true;
        } else if (NewFeedItem1 == null || newFeedItem1.ContentData == null) {
            AppearAddErrorMessage('Please select a file for this attachment');
            hasError = true;
        } else if ( newAttachmentToInsert.AttachmentType__c == null || newAttachmentToInsert.AttachmentType__c == '') {
            AppearAddErrorMessage(AppearErrorMessages.NeedAttachmentType);
            hasError = true;
        }else if(newAttachmentToInsert.AttachmentType__c == 'Author Limit Justification' && ProfileModel.isAppearFPRC){ // Appear Enhancement R1:2017 - Author limit justification restriction for FPRC
        	AppearAddErrorMessage(AppearErrorMessages.RestrictAuthorLimitJustificationAdd);
            hasError = true;
        }
        else if (  newAttachmentToInsert.AttachmentType__c == 'Kick Off Meeting Minutes/Memo' || newAttachmentToInsert.AttachmentType__c ==  'Draft - Share with Authors'  || newAttachmentToInsert.AttachmentType__c == 'Final Attachment for Author Approval') {
            // for author collaboration             
            pNewFeedItem1.ParentId = AuthorAttachmentGroupId;
            pNewFeedItem1.NetworkScope = PubAuthorNetworkId;            
        }

        insert NewFeedItem1;
        
        newAttachmentToInsert.SubmissionCycle__c = SubmissionCycleId;
        newAttachmentToInsert.What__c = NewFeedItem1.Id;
        newAttachmentToInsert.AttachmentDate__c = Date.Today(); 
        //newAttachmentToInsert.FPR_Cycle__c = FprCycleId; //Updating the FPR Cycle Num for the Attachment
        newAttachmentToInsert.FPR_Cycle__c = getCorrectFPRCycleIdForFPRRelatedAttachments(newAttachmentToInsert.AttachmentType__c).Id;
        
        newAttachmentToInsert.Attachment_URL__c = AppearUrlModel.ChatterFeedIdToUrl(newAttachmentToInsert.what__c);
        
        ////////////////////////
        
        if ( hasError ){
            
            AppLogModel.flushLogs();
            //return to Modal page to display VF Error Message
            pNewFeedItem1 = null;
            return null;
        }
        
        database.insert(newAttachmentToInsert, true);
		
        //Appear Enhancement R1:2017- Trigger automatic Monitoring and RAE attachment notification.
		if(newAttachmentToInsert.AttachmentType__c == 'RAE Attestation Sec A' || newAttachmentToInsert.AttachmentType__c == 'RAE Attestation Sec B' || newAttachmentToInsert.AttachmentType__c == 'RAE Attestation Sec C' ){
			system.debug('RAE Attachment Added');
			Email_21_MonitoringChecklist.Email_21_MonitoringChecklistBatchLimit(newAttachmentToInsert.Id);
		}
		else if (newAttachmentToInsert.AttachmentType__c == 'Monitoring Checklist Part 1' || newAttachmentToInsert.AttachmentType__c == 'Monitoring Checklist Part 2' || newAttachmentToInsert.AttachmentType__c == 'Monitoring Checklist Part 3'){
			system.debug('Monitoring Attachment Added');
			Email_20_RAEChecklist.Email_20_RAEChecklistBatch(newAttachmentToInsert.Id,PubId);
		}

        pPubAttachmentMapById = null;  
        pPubAttachmentList= null; 
        pNewFeedItem1 = null;
        AppLogModel.flushLogs();                

        if (newAttachmentToInsert.what__c != null && (newAttachmentToInsert.AttachmentType__c == 'Draft - Share with Authors' )){
            // for pub Author portal collaboration
            // ContentDocumentLink Has been added for Draft Share with Author issue : CR# CHG0050161 
            FeedItem aFeedItem = [select id, RelatedRecordId, ParentId from FeedItem  where id = :newAttachmentToInsert.what__c limit 1];
            ContentVersion aContentVersion = [select id, ContentDocumentId from ContentVersion where id = :aFeedItem.RelatedRecordId limit 1];       
            ContentDocument aContentDocument=[select Id,ownerId from ContentDocument where id=:aContentVersion.ContentDocumentId];
            //ContentDocumentLink aContentDocLink = [select id, ContentDocumentId, ShareType from ContentDocumentLink where ContentDocumentId = :aContentVersion.ContentDocumentId limit 1]; 
            ContentDocumentLink aContentDocLink = [select id, ContentDocumentId, ShareType from ContentDocumentLink where ContentDocumentId = :aContentVersion.ContentDocumentId and LinkedEntityId <> :aContentDocument.ownerId];
            system.debug('crossAttachmentsCall ContentDocumentLink'+aContentDocLink);
            system.debug('crossAttachmentsCall ContentDocumentLink ShareType'+aContentDocLink.ShareType);
            aContentDocLink.ShareType = 'C';
            database.update(aContentDocLink, true);          

            // email authors with update
           // Email_19_DraftShare.Email_19_DraftShareBatch(PubId);  
           // Commented as part of Appear Enhancement R3 to stop auto email trigger with Draft share with Authors attachment functionality.       
        
            return null; // in order to show pagemessage from email. 
        }
		//Start - Appear Enhancement 2017 Backlog R4 - Subsequent attachment addition wrong URL issue fix for IE component
        String baseURL = KeyValueSettingsModel.GetKey('ChatterFeedItem_BaseDomain').value__c;
        string str = baseURL+'/apex/AppearPub?sfdc.tabName=01ri00000004OaA&sfdc.override=1&submenu=Plan&tile=Attachments&Id='+newAttachmentToInsert.Publication__c;
        PageReference pageRef = new PageReference(str);
        //PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl()); // Commented as part of Appear enhancment 2017 R2 - URL issue for subsequent attachement addition in IE browser
        //End - Appear Enhancement 2017 Backlog R4 - Subsequent attachment addition wrong URL issue fix for IE component
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public FPR_Cycle__c getCorrectFPRCycleIdForFPRRelatedAttachments(String attachmentType){
        /*
        //Toughest problem is with "Draft Sent for FPR" attachment type because users can select this type before the Publication has reached the 
        //Draft status (status w/o Actual Date) or after Draft status (status w/ Actual Date). Entering the actual date on Draft status will increment 
        //the FPR cycle.
        **/
        boolean currentFprCycleBeenReset = pubModel.FprCycle.FprCycleHasBeenReset(FprCycleId);
        FPR_Cycle__c nextFprCycle;

        if(attachmentType == DraftSentForFPRAttachmentType){
            if ( pubModel.pubRecord.Current_FPRCycle_Id_Formula__c == null){
                nextFprCycle = pubModel.FprCycle.getFprCycleByNum(1);
            } else {
                // we do have a FPR Cycle - check if we need to increment it based on the pre-requisite statuses.
                if (currentFprCycleBeenReset){
                    nextFprCycle = pubModel.IncrFprCycle();    
                } else {
                    integer currFprCycleNum = pubModel.CurrentFprCycleNum;
                    nextFprCycle = pubModel.FprCycle.getFprCycleByNum(currFprCycleNum);
                }
            }
        } else {
            integer currFprCycleNum = (pubModel.CurrentFprCycleNum == 0) ? 1 : pubModel.CurrentFprCycleNum; //Modified to always start with FPR Cycle = 1 instead of 0
            nextFprCycle = pubModel.FprCycle.getFprCycleByNum(currFprCycleNum);
        }        
        
        return nextFprCycle;
    }
        
    private transient FeedItem pNewFeedItem1 = null;
    public FeedItem NewFeedItem1 {
        get {
            if (pNewFeedItem1 == null) {
                pNewFeedItem1 = new FeedItem();
                if (Test.IsRunningTest()) {
                    pNewFeedItem1.ParentId = PubId;
                } else {
                    pNewFeedItem1.ParentId = ChatterGroupId;
                    pNewFeedItem1.NetworkScope = ChatterNetworkId;
                }
                pNewFeedItem1.Body = 'Pub Attachment';
            }
            return pNewFeedItem1;
        }
        set; 
    }
    
    
    private transient PubAttachmentDetails__c pNewAttachment1 = null;
    public PubAttachmentDetails__c NewAttachment1 {
        get {
            if ( pNewAttachment1 == null) {
                pNewAttachment1 = getNewAttachment();
            }
            return pNewAttachment1;
        }
    }
    
    public Id ChatterGroupId {
        get{
            if (ChatterGroupId == null) {
                List<CollaborationGroup> groups = [SELECT Id FROM CollaborationGroup WHERE Name = 'Attachments'];
                if (groups.size() > 0) {
                    ChatterGroupId = groups[0].Id;
                }
            }
            return ChatterGroupId;
        }
        private set;
    }
    
    public Id ChatterNetworkId {
        get{
            if (ChatterNetworkId == null) {
                List<Network> networks = [SELECT Id FROM Network WHERE Name = 'FPR Submitter'];
                if (networks.size() > 0) {
                    ChatterNetworkId = networks[0].Id;
                }
            }
            return ChatterNetworkId;
        }
        private set;
    }
    
    public Id  AuthorAttachmentGroupId {
        get{
            if (AuthorAttachmentGroupId == null) {
                List<CollaborationGroup> groups = [SELECT Id FROM CollaborationGroup WHERE Name = 'Author Attachments'];
                if (groups.size() > 0) {
                    AuthorAttachmentGroupId = groups[0].Id;
                }
            }
            return AuthorAttachmentGroupId;
        }
        private set;
    }

  public Id PubAuthorNetworkId {
        get{
            if (PubAuthorNetworkId == null) {
                List<Network> networks = [SELECT Id FROM Network WHERE Name = 'Pub Author'];
                if (networks.size() > 0) {
                    PubAuthorNetworkId = networks[0].Id;
                }
            }
            return PubAuthorNetworkId;
        }
        private set;
    }
    
    
    
    
    public PageReference InsertAttachment1() {
        InsertAttachment(NewAttachment1);
        pNewAttachment1 = null;
        return null;
    }
    

    private transient PubAttachmentDetails__c pNewAttachment2 = null;
    public PubAttachmentDetails__c NewAttachment2 {
        get {
            if ( pNewAttachment2 == null) {
                pNewAttachment2 = getNewAttachment();
            }
            return pNewAttachment2;
        }
    }
    
    public PageReference InsertAttachment2() {
        InsertAttachment(NewAttachment2);
        pNewAttachment2 = null;
        return null;
    }
    
    private transient PubAttachmentDetails__c pNewAttachment3 = null;
    public PubAttachmentDetails__c NewAttachment3 {
        get {
            if ( pNewAttachment3 == null) {
                pNewAttachment3 = getNewAttachment();
            }
            return pNewAttachment3;
        }
    }
    
    public PageReference InsertAttachment3() {
        InsertAttachment(NewAttachment3);
        pNewAttachment3 = null;
        return null;
    }   
    
    public void clearCache() {
        pNewAttachment1 = null;
        pNewAttachment2 = null;
        pNewAttachment3 = null;
        pNewFeedItem1 = null;
    }
    
    
    //delete all attachment records selected & associated Feed Items
    //
    //only logically del
    public PageReference deleteSelected() {
        FPR_Cycle__c checkFprCycle = pubModel.FprCycle.CurrentFprCycle;
        Boolean recordHasDates = false;
        List<PubAttachmentDetails__c> itemsToDelete = new List<PubAttachmentDetails__c>(); 
        
         for(PubAttachmentDetails__c p : PubAttachmentList){
             //Appear Enahncement 2017R1 - Restrict Author Limit Justification Delete - below if logic added
            if(p.isSelected__c && p.AttachmentType__c == authorLimitJustification && !(ProfileModel.isAppearBusinessAdmin || ProfileModel.isSysAdmin)){
            	AppearAddErrorMessage('Attachment Type ["' + p.AttachmentType__c + '"] cannot be deleted. Please contact your Business Administrator.');
                return Null;
            }             
             //CR 237
            if(p.FPR_Cycle__c != Null && FprCycleId != null) { //When comparing these two values, both should not be NULL. Typically, when the Pub is new, FprCycleId will be NULL 
                if ( RestrictDelAttachment() &&  
                     p.isSelected__c && (p.AttachmentType__c == DraftSentForFPRAttachmentType || p.AttachmentType__c == SentForFPAAttachmentType) &&
                     p.FPR_Cycle__r.FPR_Cycle_Num__c == checkFprCycle.FPR_Cycle_Num__c && !ProfileModel.isSysAdmin){
                    AppearAddErrorMessage('Attachment Type ["' + p.AttachmentType__c + '"] cannot be deleted as current FPR process is complete.');
                    return Null;            
                }               
                
                if ( p.isSelected__c && (p.AttachmentType__c == DraftSentForFPRAttachmentType || p.AttachmentType__c == SentForFPAAttachmentType) &&
                     p.FPR_Cycle__r.FPR_Cycle_Num__c < checkFprCycle.FPR_Cycle_Num__c && !ProfileModel.isSysAdmin){
                    AppearAddErrorMessage('Attachment Type ["' + p.AttachmentType__c + '"] cannot be deleted as it belongs to the previously completed FPR process.');
                    return Null;            
                }               
            }
            
            if (p.isSelected__c) {
                p.isLogicallyDeleted__c = true;
                p.isSelected__c = false;
                itemsToDelete.add(p);
            }
        }

        Database.Update(itemsToDelete);
        
        pPubAttachmentMapById = null;  
        pPubAttachmentList= null; 
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    
     public boolean checkFinalAuthorApprovalAttachmentType() {
        FPR_Cycle__c checkAttachmentFprCycle = pubModel.FprCycle.CurrentFprCycle;
        
         for(PubAttachmentDetails__c p : PubAttachmentList)
         {
                if(((p.FPR_Cycle__c != Null && FprCycleId != null) && //When comparing these two values, both should not be NULL. Typically, when the Pub is new, FprCycleId will be NULL 
                    (p.AttachmentType__c == FinalAttachmentForAuthorApprovalsType) &&
                         (p.FPR_Cycle__r.FPR_Cycle_Num__c == checkAttachmentFprCycle.FPR_Cycle_Num__c)) ||
                    ((p.FPR_Cycle__c != Null && FprCycleId == null) &&      //If the CurrentFPRCycle is NULL i.e. it would be the 1st FC 
                        (p.AttachmentType__c == FinalAttachmentForAuthorApprovalsType) && 
                        (p.FPR_Cycle__r.FPR_Cycle_Num__c == 1)) 
                    ) 
                {  
                    return true;            
                }               
        }
        
        return false;
    }
    
    public List<sObject> findFeedItems(List<Id> blobsToDelete) {
        return New List<sObject>();
    }
    
    
  //==============
 	//Start - Appear Enhancement R1:2017
 //==============
    
  	//Check for the Author Limit Attachment for adding more than 10 Authors.
    public boolean checkAddAuthorLimitAttachment(){
    	AppearPubModel ActivePub = new AppearPubModel(PubId);
    	Boolean availableAuthorLimitAttachment = false;
    	for(PubAttachmentDetails__c pad : PubAttachmentList){
    		if(pad.AttachmentType__c == 'Author Limit Justification'){
    			availableAuthorLimitAttachment = true;
    			break;
    		}
    	}
    	return availableAuthorLimitAttachment;
    }
    
    public boolean checkSharedDraftAdditionalAttchmnt() {
        AppearPubModel ActivePub = new AppearPubModel(PubId);
        
        Boolean raeChecklistPart1Present = false;
        Boolean monitoringChecklistPart1Present = false;
        FPR_Cycle__c checkCurrentFPRCycle = pubModel.FprCycle.CurrentFprCycle;
        for(PubAttachmentDetails__c pubAttachment : PubAttachmentList){
        	if(((pubAttachment.FPR_Cycle__c != Null && FprCycleId != null) && (pubAttachment.AttachmentType__c == 'RAE Attestation Sec A') && (pubAttachment.FPR_Cycle__r.FPR_Cycle_Num__c == checkCurrentFPRCycle.FPR_Cycle_Num__c) && (ActivePub.pubRecord.GPP_Type__c == 'CSP')) ||
        		((pubAttachment.FPR_Cycle__c != Null && FprCycleId == null) &&(pubAttachment.AttachmentType__c == 'RAE Attestation Sec A') && (pubAttachment.FPR_Cycle__r.FPR_Cycle_Num__c == 1)&& (ActivePub.pubRecord.GPP_Type__c == 'CSP') ) ){
        		raeChecklistPart1Present = true;
        	}
        	if(((pubAttachment.FPR_Cycle__c != Null && FprCycleId != null) && (pubAttachment.AttachmentType__c == 'Monitoring Checklist Part 1') && (pubAttachment.FPR_Cycle__r.FPR_Cycle_Num__c == checkCurrentFPRCycle.FPR_Cycle_Num__c) && (ActivePub.pubRecord.GPP_Type__c == 'CSP')) ||
        		((pubAttachment.FPR_Cycle__c != Null && FprCycleId == null) &&(pubAttachment.AttachmentType__c == 'Monitoring Checklist Part 1') && (pubAttachment.FPR_Cycle__r.FPR_Cycle_Num__c == 1) && (ActivePub.pubRecord.GPP_Type__c == 'CSP') ) ){
        		monitoringChecklistPart1Present = true;
        	}
        }
        if(raeChecklistPart1Present && monitoringChecklistPart1Present){
        	system.debug('+++++++++++'+ActivePub.PubRecord.Current_FPR_Cycle_Num__c +'$$$$$$$$$$'+checkCurrentFPRCycle);
        	return true;
        }else{
        	system.debug('$$$$$$$$$$$$'+ActivePub.PubRecord.Current_FPR_Cycle_Num__c + '++++++++++'+checkCurrentFPRCycle);
        	return false;
        }
       
	}
    
     //Appear Enhancement R1:2017 - RAE checklist Part 2 attachment check.
    public boolean checkRAEAttachmentPart2Checklist(){
    	Boolean checkRAEAttachment = false;
    	for(PubAttachmentDetails__c pubAttachment : PubAttachmentList){
    		system.debug('$$$$$$$ RAE Attestation Sec B');
    		if(pubAttachment.AttachmentType__c == 'RAE Attestation Sec B'){
    			checkRAEAttachment = true;
    			system.debug('RAE Checklist Part 2 Present -- Method called return true');
    			break;
    		}
    	}
    	return checkRAEAttachment;
    }
    //Appear Enhancement R1:2017 - Monitoring checklist Part 2 attachment check.
    public boolean checkMonitoringAttachmentPart2Checklist(){
    	Boolean checkMonitorAttachment = false;
    	for(PubAttachmentDetails__c pubAttachment : PubAttachmentList){
    		system.debug('$$$$$$$ Monitoring checklist Part 2');
    		if(pubAttachment.AttachmentType__c == 'Monitoring Checklist Part 2'){
    			checkMonitorAttachment = true;
    			system.debug('Monitoring Checklist Part 2 Present -- Method called return true');
    			break;
    		}
    	}
    	return checkMonitorAttachment;
    }
    
    //Appear Enhancement R1:2017 - Author Disclouser attachment check.
    public boolean checkAuthorDisclouserAttachment(List<PubAuthor__c> authorsList){
    	Boolean authorDisclouserMissing = false;
    	set<Id> disclosureAuthorId = new set<id>();
    	for(PubAttachmentDetails__c pad : PubAttachmentList){
    		if(pad.AttachmentType__c == 'Author Disclosures'){
    			disclosureAuthorId.add(pad.Publication_Author__c);	
    		}
    	}
    	System.debug('$$$$$$'+disclosureAuthorId);
    	for(PubAuthor__c author : authorsList){
    		system.debug('****** '+author.Id);
    		if(!disclosureAuthorId.contains(author.Id)){
    			system.debug('***Test***');
    			authorDisclouserMissing = true;
    			break;
    		}
    	}
    	if(authorDisclouserMissing){
    		system.debug('False return');
    		return false;
    	}
    	return true;
    }

 //==============
 	//End - Appear Enhancement R1:2017
 //==============
    
 //=====================
 // Appear Enhancment R3
 // ===================== 
  public final static string DraftShareType = 'Draft - Share with Authors';
    
    // Start - Check if Draft-Share Attachment has been attached in the current FPR Cycle
    public boolean checkDraftShareAttachmentType() {
        FPR_Cycle__c checkAttachmentFprCycle = pubModel.FprCycle.CurrentFprCycle;
        for(PubAttachmentDetails__c p : PubAttachmentList)
        {
            if(((p.FPR_Cycle__c != Null && FprCycleId != null) && //When comparing these two values, both should not be NULL. Typically, when the Pub is new, FprCycleId will be NULL 
                (p.AttachmentType__c == DraftShareType) &&
                (p.FPR_Cycle__r.FPR_Cycle_Num__c == checkAttachmentFprCycle.FPR_Cycle_Num__c)) ||
               ((p.FPR_Cycle__c != Null && FprCycleId == null) &&      //If the CurrentFPRCycle is NULL i.e. it would be the 1st FC 
                (p.AttachmentType__c == DraftShareType) && 
                (p.FPR_Cycle__r.FPR_Cycle_Num__c == 1)) 
              ) 
            {  
                return true;            
            }               
        }
        
        return false;
    }
    //End - Check if Draft-Share Attachment has been attached in the current Fpr Cycle
	
    //Start - All authors have provided comment check method and RAE Checklist attachment Presence check method
	public boolean returnIfAllAuthorsdHaveProvidedComments(List<pubAuthor__c> authorList, Id currentFprCycleId){            
            Boolean retVal = false; //This means that all Authors have not provided comments
            Set<Id> authorsprovidingComments = new Set<Id>();
            DateTime recentAttachmentDate = null;            
            //ID recentAttachmentId = null; // Backlog R2 Req.29 - Appear Enhancement backlog R2 2017
        	set<id> recentAttachmentIdSet = new set<id>(); // Backlog R2 Req.29 - Appear Enhancement backlog R2 2017
                        
            if(PubAttachmentList!=null){           
                for(PubAttachmentDetails__c attachmentDetail : PubAttachmentList) {
                    if((recentAttachmentDate==null || attachmentDetail.CreatedDate>recentAttachmentDate) && attachmentDetail.AttachmentType__c =='Draft - Share with Authors' && (attachmentDetail.FPR_Cycle__c == currentFprCycleId || currentFprCycleId == null)){        
                        recentAttachmentDate=attachmentDetail.CreatedDate;
                        //recentAttachmentId=attachmentDetail.ID; // Backlog R2 Req.29 - Appear Enhancement backlog R2 2017
                        recentAttachmentIdSet.add(attachmentDetail.ID); // Backlog R2 Req.29 - Appear Enhancement backlog R2 2017
                    }               
                }
            }
            //List<FeedItem> authorFeed=[select id,Body,createdById from FeedItem where parentId=:recentAttachmentId];  // Backlog R2 Req.29 - Appear Enhancement backlog R2 2017 
            List<FeedItem> authorFeed=[select id,Body,createdById from FeedItem where parentId=:recentAttachmentIdSet];  // Backlog R2 Req.29 - Appear Enhancement backlog R2 2017
            for(FeedItem authorComments : authorFeed){
                for(pubAuthor__c authList : authorList){
                    if(authorComments.createdByID == authList.Author__r.UserId__c){
                        authorsprovidingComments.add(authList.Id);
                    }
                }
            }  
            if(authorsprovidingComments.size()==authorList.size()){
                retval=true;
            }
            return retVal; 
    }
    //Commented below as part of Appear Enhancment R1:2017
    /*public boolean checkAttachmentTypeOfRaeChecklist(){
        Boolean retVal = false; //No attachment of type RAE Checklist
        for(PubAttachmentDetails__c attachmentDetail : PubAttachmentList) {
            if(attachmentDetail.AttachmentType__c == 'RAE Attestation Checklist' && attachmentDetail.FPR_Cycle__r.FPR_Cycle_Num__c == 1){
                retVal=true;
                break;
            }
        }
        
        return retVal;
    }*/
    //End - All authors have provided comment check method and RAE Checklist attachment Presence check method

 //=====================
 // Appear Enhancment R3
 // =====================    
    
    ///////////////////////////   static /////////////////////////////////////////////////////     
    public static List<PubAttachmentDetails__c> getAllPubAttachmentList(Id PubId){
        List<PubAttachmentDetails__c> result = [
          select id, Name, IsSelected__c,
          AttachmentDate__c, AttachmentName__c,AttachmentType__c,  Attachment_URL__c, Comment__c,
          FPR_Cycle__c, FPR_Cycle__r.FPR_Cycle_Num__c, FPR_Cycle__r.name,
          InteractionDate__c, InteractionType__c, Notes__c,
          Publication__c, Publication__r.Name,isLogicallyDeleted__c,
          SiebelRowId__c, Size__c, SubmissionCycle__c, What__c, CreatedBy.Name, CreatedDate, OwnerId,
          LegacyCreatedBy__c, LegacyCreatedDate__c,
          LegacyLastModifiedBy__c, LegacyLastModifiedDate__c,
          Author_Name__c,Publication_Author__c // Appear Enhancement R3: Adding Author fields for Supporting attachment Details
          From PubAttachmentDetails__c
          where Publication__c = :PubId
          and isLogicallyDeleted__c = false
          order by Name  
        ];
        
        
        if ( ProfileModel.isAppearReviewers || ProfileModel.isAppearFprOnlySubmitter) {
            //Def #603 - for Appear Reviewer - only show 3 types of attachments. Phase 2 also adds requirement to fprOnly submitters
            List<PubAttachmentDetails__c>  reviewerList = new List<PubAttachmentDetails__c>();
            for (PubAttachmentDetails__c attachment :  result) {
                if ( reviewAttachmentType(attachment)) {
                    reviewerList.add(attachment);
                }
            }
        
            return reviewerList;
        } else {
            //other profiles can see all types of attachments
            return result;
        }
    }
    
    
    /**
    Created By: Sesha
    Created Date: 4/25/2014
    Description: This function takes Publication Review Team Member to fetch all the attachments of the proxies for and by if they exist.
    Returns: List<PubAttachmentDetails__c>
    */
    public static List<PubAttachmentDetails__c> getAttachmentDetailsForProxyChain(PubReviewTeam__c reviewTeamMember) {
        List<PubAttachmentDetails__c> attachmentDetailsList = new List<PubAttachmentDetails__c>();
        List<PubReviewTeam__c> currProxyReviewLst = ProxyDelegateUtility.GetProxiesForAndProxiedBy(reviewTeamMember);
        Set <Id> reviewerIds = new Set<Id>();
        reviewerIds.add(reviewTeamMember.id);
    
        for (PubReviewTeam__c chainMember : currProxyReviewLst) {
            reviewerIds.add(chainMember.id);
        }
    
        if(reviewerIds.size() > 0){
            Map<Id, PubAttachmentDetails__c> attachmentMap = getAllPubAttachmentList(reviewerIds);
    
            if(attachmentMap != null){ 
                for (PubAttachmentDetails__c attObj: attachmentMap.values()){
                    attachmentDetailsList.add(attObj);
                } 
            }
        }
    
        return  attachmentDetailsList;
    }
    
     /**
    Created By: Sesha
    Created Date: 4/25/2014
    Description: This function takes Set of Publication Review Team Members to fetch the attachments if they exist.
    Returns: Map<Id, PubAttachmentDetails__c>
    */
    public static Map<Id, PubAttachmentDetails__c> getAllPubAttachmentList(Set<Id> PrtId){
    
        string queryStr = 'select id, Name, IsSelected__c,'+
          'AttachmentDate__c, AttachmentName__c,AttachmentType__c,  Attachment_URL__c, Comment__c,'+
          'FPR_Cycle__c, FPR_Cycle__r.name,'+
          'InteractionDate__c, InteractionType__c, Notes__c,'+
          'Publication__c, Publication__r.Name,isLogicallyDeleted__c,'+
          'SiebelRowId__c, Size__c, SubmissionCycle__c, Publication_Review_Team_Member__c, What__c, CreatedBy.Name, CreatedDate, OwnerId,'+
          'LegacyCreatedBy__c, LegacyCreatedDate__c,'+
          'LegacyLastModifiedBy__c, LegacyLastModifiedDate__c '+
          'From PubAttachmentDetails__c '+
          'where Publication_Review_Team_Member__c in : PrtId ' +
          'and isLogicallyDeleted__c = false '+
          'order by Name';
        
        List<PubAttachmentDetails__c> attachmentList = Database.query(queryStr);
        
        Map<Id, PubAttachmentDetails__c> reviewerMap = new Map<Id, PubAttachmentDetails__c>();
        
        for (PubAttachmentDetails__c attachment :  attachmentList) {
            if ( reviewAttachmentType(attachment)) {
                reviewerMap.put(attachment.Publication_Review_Team_Member__c,attachment);
            }
        }
        
        return reviewerMap;
    }
        
    
    //Def #603  - for Appear Reviewer - only show 3 types of attachments
    public static boolean reviewAttachmentType(PubAttachmentDetails__c attachment ) {
        
        if ( attachment.AttachmentType__c == 'Draft Sent for FPR') {
            return true;
        }
        if ( attachment.AttachmentType__c == 'Added by FPR Reviewer') {
            return true;
        }
        if ( attachment.AttachmentType__c == 'Added by FPR Coordinator') {
            return true;
        }
        return false;
    }
    
    
    /////////// recoverStorageByDeletingAllAttachments 
    //PubAttachmentModel.recoverStorageByDeletingAllAttachments();
    public static void recoverStorageByDeletingAllAttachments() {
        List<PubAttachmentDetails__c> attachmentDetailsList = [
            select what__c 
            from PubAttachmentDetails__c
        ];
        
        List<string> feedItemIdList = new List<string>();
        for(PubAttachmentDetails__c pa : attachmentDetailsList) {
            feedItemIdList.add(pa.what__c);
        }
        
        List<FeedItem> feedItems = [ 
            select id, RelatedRecordId
            from FeedItem 
            where id in :feedItemIdList
        ];
        
        
        List<id> contentIds = new List<id>();
        for(FeedItem fi : feedItems) {
            contentIds.add(fi.RelatedRecordId);
        }
        
        List<ContentDocument> contentItems = [ 
            select id
            from ContentDocument 
            where id in :contentIds
        ];
        
        
        if ( contentItems.size() > 0){
            delete contentItems;
            Database.emptyRecycleBin(contentItems);
        }
        if ( feedItems.size() > 0){
            delete feedItems;
            Database.emptyRecycleBin(feedItems);
        }
    }
    
    public static void deleteAllContentsToRecoverStorage() {
        List<ContentDocument> contentItems = [ 
            select id
            from ContentDocument 
        ];
        if ( contentItems.size() > 0){
            delete contentItems;
            Database.emptyRecycleBin(contentItems);
        }   
        
        List<FeedItem> feedItems = [ 
            select id, RelatedRecordId
            from FeedItem 
        ];
        if ( feedItems.size() > 0){
            delete feedItems;
            Database.emptyRecycleBin(feedItems);
        }
    }
    
}