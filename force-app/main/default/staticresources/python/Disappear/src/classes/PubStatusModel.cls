global with sharing class PubStatusModel  extends AppearBaseModel {
    ////////  members ////////////////////////
    private id PubId;
    private AppearPubModel pubModel;
    private string ActiveTile;
    private string ActiveSubMenu;
    public String gppmessage {get;set;} //Appear Enhancement R2, for Add to GPP button.
    
    public void clearCache() {  
        pPubStatusList = null; 
        pPubStatusMap = null;
    }
    
    //returns a list of PubStatus and attributes for the current active publication  
    private  List<PubStatus__c> pPubStatusList = null;
    public List<PubStatus__c> PubStatusList {
        get { 
            if (pPubStatusList == null) {
                pPubStatusList = PubStatusForPub(this.PubId);    
            }
            return pPubStatusList;
        }  
    }

    public List<SelectOption> PubStatusOptions {
        get {
            List<SelectOption> result = new List<SelectOption>();
            for( PubStatus__c status : PubStatusList) {
                //As per the requirement, TOV is calculated or inputted only on Submitted/Completed; Published/Presented; Cancelled statuses 
                if(status.Status__r.Name == StatusModel.SubmittedCompletedStatus || status.Status__r.Name == StatusModel.PublishedPresentedStatus
                    || status.Status__r.Name == StatusModel.CancelledStatus) 
                {
                    result.add(new selectOption(status.id, status.Status__r.Name +' (# '+status.Submission_Cycle__r.Submission_Cycle_Num__c +')'));
                }
            }
            return result;
        }
    } 
    
    private Map<id, PubStatus__c> pPubStatusMap = null;
    public Map<id, PubStatus__c> PubStatusMap {
        get {
            if (pPubStatusMap==null) {
                pPubStatusMap =new  Map<id, PubStatus__c>();
                for (PubStatus__c ps : PubStatusList) {
                    pPubStatusMap.put(ps.id, ps);
                }
            }
            return pPubStatusMap;
        } 
    }
    
    public PubStatus__c CurrentPubStatus {
        get {
            Id CurrentPubStatusId = pubModel.pubRecord.PubStatus__c;
            return PubStatusMap.get(CurrentPubStatusId);
        }
    }
    
    public Status__c CurrentStatus {
        get {
            PubStatus__c pubStatus = CurrentPubStatus;
            if (pubStatus == null) {
                return null;
            } else {
                Id currentStatusId = PubStatus.Status__c;
                return StatusModel.StatusMapById.get(currentStatusId);
            }
        }
    }
    
    public PubStatus__c getPubStatus(Id pubStatusId) {
            return PubStatusMap.get(pubStatusId);
    }
    
    private final static boolean debug = false; 
    public PubStatusModel(Id PubId) {  //for unit test only   
        this(PubId,null,null,null);
        pubModel = new AppearPubModel(PubId);
    } 
     
    public PubStatusModel(Id PubId,  AppearPubModel pubModel, string tile, string subMenu) {
        this.PubId = PubId;
        this.PubModel = PubModel;
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;  
    }  
    
    //this is for update of list of PubStatus
    public PageReference save() {  
        AppLogModel.LogInfo('PubStatusModel::Save', 'invoking PubStatusModel::Save.  Start Precheck', pubId);
        
        //  Def #625 - remove validation check during "Accepted" Status needs to be removed.
        /*Commented out the validation check based on the Business Feedback (Email Dated: 8/19/2014 5:13 PM from Melissa Seal)
        boolean ApprovedByAllAuthorsHasActualDate = false;
        boolean AcceptedHasActualDate = false;
        for(PubStatus__c pubStatus : PubStatusList) {
            
            if ( pubStatus.status__c == StatusModel.AuthorApprovals.Id && pubStatus.ActualDate__c <> null && pubStatus.Submission_Cycle__c == pubModel.CurrentSubmissionCycleId  ) {
                ApprovedByAllAuthorsHasActualDate = true;
            }

            if ( pubStatus.status__c == StatusModel.Accepted.Id && pubStatus.ActualDate__c <> null && pubStatus.Submission_Cycle__c == pubModel.CurrentSubmissionCycleId ) {
                AcceptedHasActualDate = true;
            }           
        }
        
        boolean hasAuthorApprovedAttachment = false;
        for (PubAttachmentDetails__c attachmentDetail :  pubModel.PubAttachments.PubAttachmentList ) {
            if (( attachmentDetail.AttachmentType__c == PubAttachmentModel.AuthorApprovalsAttachmentType || attachmentDetail.AttachmentType__c == PubAttachmentModel.LegacyMWT_InteractionsAttachmentType ) 
                 && attachmentDetail.SubmissionCycle__c == pubModel.CurrentSubmissionCycleId ) {
                hasAuthorApprovedAttachment = true;
            }
        }
        
        if ( ApprovedByAllAuthorsHasActualDate && !hasAuthorApprovedAttachment) { 
            string errorMsg = 'Attachment Type of "Author Approval(s)" is required for "Approved by All Authors" status';
            AppLogModel.LogError('PubStatusModel::Save', errorMsg);
            
            AppearAddErrorMessage(errorMsg);
            return null;
        } 
        */
        
        //Appear R3 Enhancement check if all Authors have responded to the final Author Approval
        List<pubAuthor__c> authorList = PubAuthorModel.getPubAuthors(PubId); 
        for(pubAuthor__c authlist : authorList){
            if(authlist.Approval_Rejected_Date__c == null && authlist.ApprovalAcceptedDate__c == null){
                checkResponse = false;
                break;
            }
        }
        boolean materialChangeCongressJounralInCurrentFPRCycle = false;
        boolean submittedCompletedInCurrentFPRCycle = false;
        if(PubStatusList.size()>0){
            PubStatus__c pubstatrecord = PubStatusList[0];
            for(PubStatus__c pubStatus : PubStatusList){
                if(pubStatus.Status__r.Name == 'Material Changes for Congress/Journal' && pubStatus.ActualDate__c != null && pubStatus.FPR_Cycle__c == pubstatrecord.Publication_id__r.Current_FPRCycle_Id_Formula__c){
                    materialChangeCongressJounralInCurrentFPRCycle = true;
                }
                if(pubStatus.Status__r.Name == 'Submitted/Completed' && pubStatus.ActualDate__c != null && (pubStatus.FPR_Cycle__c == pubstatrecord.Publication_id__r.Current_FPRCycle_Id_Formula__c || pubstatrecord.Publication_id__r.Current_FPRCycle_Id_Formula__c == null)){
                    submittedCompletedInCurrentFPRCycle = true;
                }
            }
            // && pubstatrecord.Publication_id__r.isPlanning__c == true - removed as part of Appear Enhancment R1:2017
            if((!checkResponse) && pubstatrecord.Publication_id__r.GPP_Type__c == 'CSP' && submittedCompletedInCurrentFPRCycle == true && materialChangeCongressJounralInCurrentFPRCycle  == false){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                
                                    'The Submitted/Completed date cannot be populated before all Authors have responded to the request for Final Approval.');
                                ApexPages.addMessage(myMsg);
                                return null; 
            }
        }
        //Appear R3 Enhancement check if all Authors have responded to the final Author Approval
        
        //Defect 123 - check if all Latest Target SubmissionDate has a ReasonForChange
        //Defect 181 - clean validation messages for statuses actual date > today
        for(PubStatus__c pubStatus : PubStatusList) {
            if (pubStatus.status__c == StatusModel.SubmittedCompleted.Id && pubStatus.RevisedTargetDate__c <> null && 
                (pubStatus.Reason_For_Change__c == null || pubStatus.Reason_For_Change__c.trim().length() == 0)) {
    
                string errorMsg = 'Please enter a Reason For Change when modifying the latest Target Submission Date for Submitted/Completed status';
                AppLogModel.LogError('PubStatusModel::Save', errorMsg);
                    
                AppearAddErrorMessage(errorMsg);
                
                AppLogModel.flushLogs();
                return null; 
            } 
            
            if (pubStatus.ActualDate__c != null && pubStatus.ActualDate__c > DateTime.now()) {
                string errorMsg = 'Actual Date cannot be a Future Date for the Statuses';
                AppLogModel.LogError('PubStatusModel::Save', errorMsg);
                    
                AppearAddErrorMessage(errorMsg);
                
                AppLogModel.flushLogs();
                return null; 
            }
        }
        
        AppLogModel.LogInfo('PubStatusModel::Save', 'invoking PubStatusModel::Save.  Start Precheck passed. ' );
        AppLogModel.LogInfo('PubStatusModel::Save', 
            'Current SC =  '+PubModel.CurrentSubmissionCycleNum+
            ' FC = '+ PubModel.CurrentFprCycleNum +
            ' Current Status ='+PubModel.CurrentStatus);
        //clear the target before persisting
        for(PubStatus__c p : PubStatusList){
            p.Target__c = null;
            p.IsLogicallyDeleted__c = false;
        }
        try {
            database.update(PubStatusList, true);
        } catch (DmlException err) {
            
            pPubStatusList = null;  
            if(err.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                ApexPages.addMessages(err);
                return null;
            }
            else{
            ApexPages.addMessages(err);//Appear Enhancement R2: Historical Publication fix for Validation Rules, Else part updated
            return null;
            }// throw err;                 
        }
        
        
        AppLogModel.flushLogs();
        
        pPubStatusList = null;  
        
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)); 
    }
    
    
    public boolean currSubCycleHasOpenChange  {
        get {
            integer totalOpenChange = currCycleMaterialChangeWithActualDate + currCycleNonMaterialChangeWithActualDate;
            if ( totalOpenChange > currCycleResentWithActualDate ) {
                return true;
            } else {
                return false;
            }
        }
    }
    
    public integer currCycleMaterialChangeWithActualDate {
        get {
            integer mcCount = 0;
            for(PubStatus__c pubStatus : PubStatusList) {
                if (pubStatus.Status__c == StatusModel.MaterialChangesForCongressJournal.id && 
                    pubStatus.IsCurrentSubmissionCycleForPub__c && 
                    pubStatus.ActualDate__c <> null) {
                        mcCount++;
                }
            }
            return mcCount;
        }
    }
    
    public integer currCycleNonMaterialChangeWithActualDate {
        get {
            integer nmcCount = 0;
            for(PubStatus__c pubStatus : PubStatusList) {
                if (pubStatus.Status__c == StatusModel.NonMaterialChange.id && 
                    pubStatus.IsCurrentSubmissionCycleForPub__c && 
                    pubStatus.ActualDate__c <> null) {
                        nmcCount++;
                }
            }
            return nmcCount;
        }
    }
    
    public integer currCycleResentWithActualDate {
        get {
            integer resentCount = 0;
            for(PubStatus__c pubStatus : PubStatusList) {
                if (pubStatus.Status__c == StatusModel.Resent.id && 
                    pubStatus.IsCurrentSubmissionCycleForPub__c && 
                    pubStatus.ActualDate__c <> null) {
                        resentCount++;
                }
            }
            return resentCount;
        }
    }
    
    // CCB 258
    public integer rejectWithActualDate {
        get {
            integer rejectCount = 0;
            for(PubStatus__c pubStatus : PubStatusList) {
                if (pubStatus.Status__c == StatusModel.Rejected.id && 
                    pubStatus.IsCurrentSubmissionCycleForPub__c && 
                    pubStatus.ActualDate__c <> null) {
                        rejectCount++;
                }
            }
            return rejectCount;
        }
    }    
    
    //show the Resend button for ProfileModel.isAppearWriting || ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC  || ProfileModel.isSysAdmin
    //if Publication is in submit RecType
    //and the # of Material Change for Congress/Journal with actual date
    //is great than # of resent with actual date
    public boolean showResendButton {
        get {
            if ( ProfileModel.isAppearGPPL || ProfileModel.isAppearWriting || ProfileModel.isAppearExternalWriter || ProfileModel.isAppearBusinessAdmin || 
                ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC  || ProfileModel.isSysAdmin) {
                    
                //count Material Change for Congress/Journal with actual date in this cycle
                //count Resent with Actual date in this cycle
                // if greater - then return true
                
                AppLogModel.LogInfo('PubStatusModel::showResendButton', 
                    string.Format('# Material Change with Actual Date {0}  # Non Material Change with Actual Date {2} # Resent with Actual Date {1}',
                    new string[]{string.valueOf(currCycleMaterialChangeWithActualDate), string.valueOf(currCycleResentWithActualdate),string.valueOf(currCycleNonMaterialChangeWithActualDate)}),
                    pubId);
                                    
                if ( (currCycleMaterialChangeWithActualDate+currCycleNonMaterialChangeWithActualDate) > currCycleResentWithActualDate) {
                    return true;
                } else {
                    return false;
                }       
            } 
            return false;
        }
    }
    
    private PubStatus__c getLastMaterialChangeForCongressJournal() {
        List<PubStatus__c> psList = [
            select Fpr_cycle__c, Fpr_cycle__r.FPR_Cycle_Num__c, Submission_Cycle__c, Submission_Cycle__r.Submission_Cycle_Num__c
            from PubStatus__c
            where publication_id__c = :pubId
            and status__c = :StatusModel.MaterialChangesForCongressJournal.id
            order by Submission_Cycle__r.Submission_Cycle_Num__c desc, Fpr_Cycle__r.FPR_Cycle_Num__c desc
            limit 1
        ];
        
        if (psList.size() == 1){
            return psList[0];
        } else {
            return null;
        }
    }
    
    private PubStatus__c getLastNonMaterialChange() {
        List<PubStatus__c> psList = [
            select Fpr_cycle__c, Fpr_cycle__r.FPR_Cycle_Num__c, Submission_Cycle__c, Submission_Cycle__r.Submission_Cycle_Num__c
            from PubStatus__c
            where publication_id__c = :pubId
            and status__c = :StatusModel.NonMaterialChange.id
            order by Submission_Cycle__r.Submission_Cycle_Num__c desc, Fpr_Cycle__r.FPR_Cycle_Num__c desc
            limit 1
        ];
        
        if (psList.size() == 1){
            return psList[0];
        } else {
            return null;
        }
    }
    
    private PubStatus__c getLastMaterialChangeForNewTarget() {
        List<PubStatus__c> psList = [
            select Fpr_cycle__c, Fpr_cycle__r.FPR_Cycle_Num__c, Submission_Cycle__c, Submission_Cycle__r.Submission_Cycle_Num__c
            from PubStatus__c
            where publication_id__c = :pubId
            and status__c = :StatusModel.MaterialChangeforSubsequentSubmission.id
            order by Submission_Cycle__r.Submission_Cycle_Num__c desc, Fpr_Cycle__r.FPR_Cycle_Num__c desc
            limit 1
        ];
        
        if (psList.size() == 1){
            return psList[0];
        } else {
            return null;
        }
    }
    
    private PubStatus__c getLastNonMaterialChangeForNewTarget() {
        List<PubStatus__c> psList = [
            select Fpr_cycle__c, Fpr_cycle__r.FPR_Cycle_Num__c, Submission_Cycle__c, Submission_Cycle__r.Submission_Cycle_Num__c
            from PubStatus__c
            where publication_id__c = :pubId
            and status__c = :StatusModel.NonMaterialChangeforSubsequentSubmission.id
            order by Submission_Cycle__r.Submission_Cycle_Num__c desc, Fpr_Cycle__r.FPR_Cycle_Num__c desc
            limit 1
        ];
        
        if (psList.size() == 1){
            return psList[0];
        } else {
            return null;
        }
    }
    
    public id findSubmittedCompletedStatusId (Id CurrentSubmissionCycleId) {
        for(PubStatus__c pubStatus : PubStatusList) {
            if ( pubStatus.Submission_Cycle__c == CurrentSubmissionCycleId && 
                pubStatus.Status__c == StatusModel.SubmittedCompleted.id &&
                pubStatus.ActualDate__c <> null) {
                return pubStatus.id;
            }
            
        }
        return null;
    }
    
    //discussion with Cid
    //[6/15/13 10:14:22 PM] Cid Ruesga : Just put the button on the Status page and enable it when
    //[6/15/13 10:15:14 PM] Cid Ruesga : "Material Change for Journal/Congress" is added with an Actual Date
    //  we may have more than 1 Material Change for Journal/Congress
    //  show when Count of Material Change with Actual Date is > Count of Resend
    public PageReference ResentME() {
        
        if ( ProfileModel.isAppearWriting  || ProfileModel.isAppearExternalWriter || ProfileModel.isAppearGPPL || ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC  || ProfileModel.isSysAdmin) {
            AppLogModel.LogInfo('PubStatusModel::ME_Resend', 
                    'initiate a [ME_Resend] for PubId : '+pubid);   
                    
            //determine if the last is a Material Change or a Non Material Change
            
            PubStatus__c lastChange = null;
            for(PubStatus__c pubStatus : PubStatusList) {
                
                    if ( PubStatus.Status__c == StatusModel.MaterialChangesForCongressJournal.id || PubStatus.Status__c == StatusModel.NonMaterialChange.id) {
                        lastChange = pubStatus;
                    }               
                
            }
            
            if ( lastChange == null) {
                //no outstanding Non-Material chnage or Material change
                AppLogModel.LogError('PubStatusModel::ResentME', 'Cannot locate last Material Change or Non Material Change', pubId);
                AppLogModel.flushLogs();
                return null;
            }
            
            if (lastChange.Status__c == StatusModel.MaterialChangesForCongressJournal.id) {
                //Def #553 - Resend ME need to use last Materical change for Congress/Journal as reference for FPR Cycle
                PubStatus__c lastMaterialChange = getLastMaterialChangeForCongressJournal();
                    
                if (lastMaterialChange == null) {
                    //cannot find a material change for Congress journal
                    //cannot perform a resend
                    
                    AppLogModel.LogError('PubStatusModel::ResentME', 'cannot find a material change for Congress journal - cannot resend');
                    AppLogModel.flushLogs();
                    return null;
                }               
                ResentMeForMaterialChange(lastMaterialChange);
                
            } else if (lastChange.Status__c == StatusModel.NonMaterialChange.id) {
                ResentMeForNonMaterialChange();

            }   

        } else {
            string message = 'You login id is associated with ['+ProfileModel.CurrentProfileName +
                ' profile], you do not have access to initiate a [ME_Resend] for this Publication.';
            AppLogModel.LogError('PubStatusModel::ME_Resend', message);
            AppearAddErrorMessage(message);
            AppLogModel.flushLogs();  
            return null;
        }
        
        pubModel.resetCurrentStatus();
        
        AppLogModel.flushLogs();
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)); 
    }
    
    private void ResentMeForMaterialChange(PubStatus__c lastMaterialChange) {
        //copy all ME Roles from the last FPR cycles into this FPR Cycle's Writing Roles        
        integer lastFprCycleNum = integer.valueOf(lastMaterialChange.Fpr_cycle__r.FPR_Cycle_Num__c);
        integer thisFprCycleNum = lastFprCycleNum+1;
            

        AppLogModel.LogInfo('PubStatusModel::ResentME', 
            string.Format('this FPR Cycle # {0}  lastFPR Cycle # {1}',
            new string[]{string.valueOf(thisFprCycleNum), string.valueOf(lastFprCycleNum)}));   
                    
        if ( lastFprCycleNum >= 1) {
            //insert a resent status
            PubStatus__c newPubStatusRecord = new PubStatus__c();
            newPubStatusRecord.Publication_id__c = pubId;   
            newPubStatusRecord.ActualDate__c = DateTime.Now();
            newPubStatusRecord.Status__c = StatusModel.Resent.Id;
            newPubStatusRecord.Submission_Cycle__c = pubModel.CurrentSubmissionCycleId;
            newPubStatusRecord.FPR_Cycle__c = pubModel.FprCycle.getFprCycleByNum(thisFprCycleNum).Id;
            
            try {
                insert newPubStatusRecord;
            } catch (DmlException err) {
                if(err.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    ApexPages.addMessages(err);
                    return;
                } else {
                    throw err;
                }                   
            }
            
            //R1.3 - copyMEforMaterialChange will setup the PubStatus Record
            PubModel.PubMe.copyMEforMaterialChange(lastFprCycleNum, thisFprCycleNum, newPubStatusRecord.Id);
            PubModel.PubMe.clearPubMeList();
            clearCache();
            PubModel.PubMe.AwardMeForMaterialChangeCongressJournal(PubModel);
                
        } else {
            AppLogModel.LogError('PubStatusModel::ResentME', 'Aborting ResentME - cannot find valid FPR Cycle');
        }
    }
    
    private void ResentMeForNonMaterialChange() {
        AppearPubModel nonMaterialChangePubModel = new AppearPubModel(pubId);
        
        
        //insert a resent status
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = pubId;   
        newPubStatusRecord.ActualDate__c = DateTime.Now();
        newPubStatusRecord.Status__c = StatusModel.Resent.Id;
        newPubStatusRecord.Submission_Cycle__c = nonMaterialChangePubModel.CurrentSubmissionCycleId;
        newPubStatusRecord.FPR_Cycle__c = nonMaterialChangePubModel.CurrentFprCycleId;
            
        insert newPubStatusRecord;
        
        //look for max ME - and make a copy for all;
        List<pubMe__c> pubMeListForNmc = PubModel.PubMe.copyMEforNonMaterialChange(newPubStatusRecord.id);
        clearCache();
        NonMaterialChangePubModel.PubMe.AwardMeForNonMaterialChange(nonMaterialChangePubModel); 
    }
      
 
    public PageReference deleteSelected() {
        Boolean recordHasDates = false;
        Boolean sopStatusExistsInNewSC = false; 
        
        List<PubStatus__c> itemsToDelete = new List<PubStatus__c>();
        for(PubStatus__c p : pPubStatusList){
            if (p.IsLogicallyDeleted__c) {
                if (p.TargetDate__c == null && p.LastModifiedDate == null && p.ActualDate__c == null ) {  
                    p.IsLogicallyDeleted__c = true;
                    itemsToDelete.add(p);
                } else {
                    recordHasDates = true;
                    p.IsLogicallyDeleted__c = false;
                }
            }
        }
        
        if (recordHasDates) { 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                'Cannot delete a status that has a date value.  Please remove all dates on this status before deleting.');
            ApexPages.addMessage(myMsg);
            return null; 
        }
        
        //SESHA: When user tries to delete "Material Change for New Target" or "Non-Material Change for New Target" after the Publication has moved into
        //the new Submission Cycle with a new Target, this logic displays the validation. It would create unwanted consequences due to SC/FC/Display Order/etc.
        // -- START
        Set <Id> pubRejectStatuses = new Set<Id>();
        string msgPStatusName = '';
        
        for(PubStatus__c pS : pPubStatusList) {
            if(pS.Status__r.Name == StatusModel.RejectedStatus) {
                pubRejectStatuses.add(pS.Id);
            }
        }
      
        for(PubStatus__c pS : pPubStatusList) {
            if (pS.IsLogicallyDeleted__c) {
                if(((pS.Status__r.Name == StatusModel.MaterialChangeforSubsequentSubmissionStaus && 
                    getLastMaterialChangeForNewTarget().Submission_Cycle__r.Submission_Cycle_Num__c > pubRejectStatuses.size()) || 
                    (pS.Status__r.Name == StatusModel.NonMaterialChangeforSubsequentSubmissionStatus && 
                    getLastNonMaterialChangeForNewTarget().Submission_Cycle__r.Submission_Cycle_Num__c > pubRejectStatuses.size())) && 
                    pS.Submission_Cycle__r.TargetLabelFormula__c != null) {
                        msgPStatusName = pS.Status__r.Name;         
                        sopStatusExistsInNewSC = true;
                }
            }
        }
        
        if (sopStatusExistsInNewSC) { 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                'Cannot delete "'+ msgPStatusName +'" status as the Publication has moved into a new Submission Cycle. Please reach out to the Helpdesk, if this transaction was done in error.');
            ApexPages.addMessage(myMsg);
            return null; 
        }
        // -- END
        
        database.update(itemsToDelete, true);   
        pPubStatusList = null;   
  
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
     
/*
    public void InsertSubmitSuggestion() {
        InsertSubmitSuggestion(DateTime.Now());
                            
    }
*/
    //Appear Enhancement R3 
    public boolean checkResponse = true; //boolean variable check for Approval Response
    //Start- Aggrement Sent Actual Date population method
    public void insertAgreementSent(){
   
      List<PubStatus__c> UpdatePubStat = new List<PubStatus__c>();
      List<PubStatus__c> qPubStatList = [
            select id, Status__c, ActualDate__c,Status__r.Name
            from PubStatus__c 
            where Publication_id__c = :PubId
        ];
      
      for(PubStatus__c pS : qPubStatList){
        if( pS.Status__r.Name == StatusModel.AuthorAgreementsSentStatus && pS.ActualDate__c == null ) { 
          
          pS.ActualDate__c = DateTime.Now();
          UpdatePubStat.add(pS);
         try{
          Database.Update(UpdatePubStat,true);
           } catch (DmlException err) {
                if(err.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    ApexPages.addMessages(err);
                    return;
                } else {
                    throw err;
                }                   
            }
          }//if ends
        }//for ends
      }    
    //End- Aggrement Sent Actual Date population method
    
   //Start - 'Approved by all Authors' Actual Date population method
    public void insertfinalApprovalresponse(Id PubId){
  	  
  	  AppearPubModel appPubModel = new AppearPubModel(Pubid);
      Boolean check1 = false;
      Integer i = 0; 
      List<PubAuthor__c> pubAuth = PubAuthorModel.getPubAuthors(PubId);
      List<PubStatus__c> UpdatePubStat = new List<PubStatus__c>();
      List<PubStatus__c> qPubStatList = [
            select id, Status__c, ActualDate__c,Status__r.Name
            from PubStatus__c 
            where Publication_id__c = :PubId
        ];
  		
  	  for(PubAuthor__c pAuth : pubAuth){
  	  	if (pAuth.ApprovalAcceptedDate__c == null && pAuth.Approval_Rejected_Date__c == null){
  	  		check1 = true;
  	  	}
  	  	if (pAuth.Approval_Rejected_Date__c <> null){
  	  		i++ ;
  	  	}
  	  }	
      
      if(check1 == false && pubAuth.size() <> i ){      
      for(PubStatus__c pS : qPubStatList){
        if( pS.Status__r.Name == StatusModel.AuthorApprovalsStatus && (pS.ActualDate__c == null ) ) { 
          //pS.ActualDate__c = DateTime.Now();
          // Appear Enhamcement backlog R2 - Approved By All Author Status Date population based on actual approval date
            for(PubAuthor__c pa : pubAuth){
                if(pS.ActualDate__c < pa.ApprovalAcceptedDate__c || pS.ActualDate__c == null){
                    pS.ActualDate__c = pa.ApprovalAcceptedDate__c;
                }                 
            }
            pS.ActualDate__c = ps.ActualDate__c.addHours(7);
          UpdatePubStat.add(pS);
        }
      }
      try{
          Database.Update(UpdatePubStat,true); 
           } catch (DmlException err) {
                ApexPages.addMessages(err);
                AppLogModel.LogError('PubStatusModel::insertfinalApprovalresponse', 'Exception'+ err, PubId);                 
             } 
      if(ProfileModel.isAppearPortalPubAuthor){
          	 appPubModel.PubAuthorNoSharing.updatePubAfterApproval(PubId);
        }       
      } //if ends     
    }    
   //End - 'Approved by all Authors' Actual Date population method
   
    //Start - if draft Date is populated or not for 'Submit for FPR' validation
    public boolean isDraftDatePopulated(Id currentFprCycleId){
    		boolean retval=false;
    		for(PubStatus__c pubStatus : PubStatusList) {
    			if(pubStatus.Status__r.Name == 'Draft' && (pubStatus.FPR_Cycle__c == currentFprCycleId || pubStatus.FPR_Cycle__c == null) && pubStatus.ActualDate__c !=null){ // remove -&& pubStatus.FPR_Cycle__c == currentFprCycleId
    				retval=true;
    			}
    		}
    		return retval;
    	}    
    //End - if draft Date is populated or not for 'Submit for FPR' validation
    
    //Appear Enhancement R3
    
    public void InsertSubmitSuggestion(DateTime actualDate){
        
        AppLogModel.LogInfo('PubStatusModel::InsertSubmitSuggestion', 
            'Invoking  InsertSubmitSuggestion for pub ['+ pubModel.PubName + ' : ' +  pubModel.PubTitle+']');
            
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = pubId;   
        newPubStatusRecord.ActualDate__c = actualDate;
        newPubStatusRecord.Status__c = StatusModel.LookUpStatus(StatusModel.SuggestedStatus).Id;
        
        insert newPubStatusRecord;
        
        AppLogModel.LogInfo('PubStatusModel::InsertSubmitSuggestion', 
            'Inserted Suggested status for pub ['+ pubModel.PubName + ' : ' +  pubModel.PubTitle+']');
    }

    public void InsertSubmitCompleted(Id SubCycleid, Id FprCycleId){
        List<PubStatus__c> PubStatusList = [
            select id, Status__c, status__r.Name, publication_Id__c, Submission_Cycle__c, Fpr_Cycle__c, ActualDate__c, IsCurrentSubmissionCycleForPub__c, Submission_Cycle__r.TargetLabelFormula__c 
            from PubStatus__c
            where publication_id__c = :pubId
            and Submission_Cycle__c = :SubCycleid
        ];
        
        Set<Id> statusIdSet= new Set<Id>();
        for(PubStatus__c pubstat :PubStatusList )
         statusIdSet.add(pubstat.Status__c);
        
        if(!statusIdSet.contains(StatusModel.SubmittedCompleted.id)){
         AppLogModel.LogInfo('InsertSubmitCompleted::InsertSubmitCompleted', 
            'Invoking  InsertSubmitCompleted for pub ['+ pubModel.PubName + ' : ' +  pubModel.PubTitle+']');
            
         PubStatus__c newPubStatusRecord = new PubStatus__c();
         newPubStatusRecord.Publication_id__c = pubId;   
         newPubStatusRecord.ActualDate__c = null;
         newPubStatusRecord.Status__c = StatusModel.SubmittedCompleted.id;
         newPubStatusRecord.Submission_Cycle__c = SubCycleid;
         newPubStatusRecord.FPR_Cycle__c = FprCycleId;
         
         insert newPubStatusRecord;
         System.debug('Submitted completed status created'+newPubStatusRecord);
        }
        
    }

    public void InsertPublishedPresented(Id SubCycleid, Id FprCycleId){
        
        AppLogModel.LogInfo('InsertSubmitCompleted::InsertPublishedPresented', 
            'Invoking  InsertPublishedPresented for pub ['+ pubModel.PubName + ' : ' +  pubModel.PubTitle+']');
            
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = pubId;   
        newPubStatusRecord.ActualDate__c = null;
        newPubStatusRecord.Status__c = StatusModel.PublishedPresented.id;
        newPubStatusRecord.Submission_Cycle__c = SubCycleid;
        newPubStatusRecord.FPR_Cycle__c = FprCycleId;
        
        insert newPubStatusRecord;
    }

    public void InsertAccepted(Id SubCycleid, Id FprCycleId){        
        AppLogModel.LogInfo('InsertSubmitCompleted::InsertAccepted', 
            'Invoking  InsertAccepted for pub ['+ pubModel.PubName + ' : ' +  pubModel.PubTitle+']');
            
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = pubId;   
        newPubStatusRecord.ActualDate__c = null;
        newPubStatusRecord.Status__c = StatusModel.Accepted.id;
        newPubStatusRecord.Submission_Cycle__c = SubCycleid;
        newPubStatusRecord.FPR_Cycle__c = FprCycleId;
        
        insert newPubStatusRecord;
    }
    
    public void InsertRoutePubStatus() {
        InsertRoutePubStatus(DateTime.Now());
                            
    }
    
    //Pending FPR Submission
    public static PubStatus__c InsertFPROnlyPubStatus(id relatedPub){
        
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = relatedPub;  
        newPubStatusRecord.ActualDate__c = DateTime.Now();
        newPubStatusRecord.Status__c = StatusModel.FPROnly.Id; 
        
        insert newPubStatusRecord;
        
        AppLogModel.LogInfo('PubStatusModel::InsertFPROnlyPubStatus', 'Inserting new Pending FPR Submission status for '+ relatedPub);
        return newPubStatusRecord;
    }
    
    //Draft is a global status - it should be updated with Actual Time instead of inserting a new one.
    //UpdateDraftPubStatusActualTime will pick the last draft status and update actual time
    public static PubStatus__c UpdateDraftPubStatusActualTime(id relatedPub, DateTime draftDateTime){
        
        List<PubStatus__c> pubStatusList = [
            select ActualDate__c 
            from PubStatus__c 
            where Status__c = :StatusModel.Draft.id
            order by Name desc 
            limit 1
        ];
        
        if ( pubStatusList.size() == 1) {
            PubStatus__c draftPubStatus = pubStatusList[0];
            draftPubStatus.ActualDate__c = draftDateTime;
            
            try {
                update draftPubStatus;
            } catch (DmlException err) {
                if(err.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    ApexPages.addMessages(err);
                    return null;
                }
                else throw err;                 
            }
            
            AppLogModel.LogInfo('PubStatusModel::UpdateDraftPubStatusActualTime', 
                'Updated last Draft status with Actual Date for '+ relatedPub);
            return draftPubStatus;          
        } else {
            return null;
        }
    }
  
    //special function only for cloning - set status to created
    //This function is OBSOLETE as Business decided that CLONED Publication should always start from Concept
    //Related to CR #202
    public static PubStatus__c InsertCreatedPubStatusForClonedPubs(id relatedPub){
        
        List<PubStatus__c> pubstatusList = [
            select id, ActualDate__c 
            from PubStatus__c 
            where Publication_id__c = :relatedPub
        ];
        
        for(PubStatus__c ps : pubstatusList){
            ps.ActualDate__c = null;
        }
        update pubstatusList;
        
        AppearPubModel pub = new AppearPubModel(relatedPub);
        
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = relatedPub;  
        newPubStatusRecord.ActualDate__c = DateTime.Now();
        newPubStatusRecord.Status__c = StatusModel.Created.Id; 
        newPubStatusRecord.Submission_Cycle__c = pub.SubmissionCycle.getSubmissionCycleByNum(1).Id;
        newPubStatusRecord.FPR_Cycle__c = null;
        
        insert newPubStatusRecord;  
        
        AppLogModel.LogInfo('PubStatusModel::InsertCreatedPubStatus', 'Inserting created status for '+ relatedPub);
        return newPubStatusRecord;
    }
    
        
    //special function only for cloning - set status to Concept
    //This function is new as Business decided that CLONED Publication should always start from Concept
    //Related to CR #202
    public static void InsertConceptPubStatusForClonedPubs(id relatedPub){
        integer chkConceptCount = 0;
        
        List<PubStatus__c> pubstatusUpdList = new List<PubStatus__c>();
        
        List<PubStatus__c> pubstatusList = [
            select id, Status__c, ActualDate__c 
            from PubStatus__c 
            where Publication_id__c = :relatedPub
        ];
        
        for(PubStatus__c ps : pubstatusList){
            if (ps.Status__c == StatusModel.Concept.id) {
                chkConceptCount++;
                continue;
            }
            
            ps.ActualDate__c = null;
        }
        
        update pubstatusList;
        
        //This depends on InsertProfileDependentInitialStatus(). 
        //If there is no Concept Status, then you need Insert. Otherwise it is not required.
        if(chkConceptCount == 0)   
        {
            AppearPubModel pub = new AppearPubModel(relatedPub);
            
            PubStatus__c newPubStatusRecord = new PubStatus__c();
            newPubStatusRecord.Publication_id__c = relatedPub;  
            newPubStatusRecord.ActualDate__c = DateTime.Now();
            newPubStatusRecord.Status__c = StatusModel.Concept.Id; 
            newPubStatusRecord.Submission_Cycle__c = pub.SubmissionCycle.getSubmissionCycleByNum(1).Id;
            newPubStatusRecord.FPR_Cycle__c = null;
            
            insert newPubStatusRecord;  
        }
        
        AppLogModel.LogDebug('PubStatusModel::InsertConceptPubStatusForClonedPubs', 'Inserting created status for '+ relatedPub);
    }
    
    //2013-07-31 refactor for Legacy Status Mapping as well as add PublishedPresentedStatus to initial pub creation
    public boolean isGlobalStatusInitial (Status__c status) {
        if ( status.Stage__c <> 'Review' && status.Stage__c <> 'Submit') {
            return true;
        } else if ( status.id == StatusModel.AuthorApprovals.id || status.id == StatusModel.PublishedPresented.id ||
                    status.id == StatusModel.SubmittedCompleted.Id || status.id == StatusModel.Accepted.Id) { 
            return true;
        } else {
            return false;
        }
    }
    
    public boolean isGlobalStatusFPR(Status__c status) {
        //Def #686.S1 - Only 1 SubmittedCompleted or Accepted per publication
        //Def 805 - excluding submiscomplete, accepted, publishedpresented
        if ( status.id == StatusModel.SubmittedCompleted.id || status.id == StatusModel.Accepted.id || status.id == StatusModel.PublishedPresented.Id ) {
            return false;
        } else {
            return !isGlobalStatusInitial(status);
        }
    }

    //insert global status at the creation of a publication
    //before Review & Submit Stage
    
    public List<PubStatus__c> InsertGlobalStatus(SubmissionCycle__c firstSubmissionCycle ) {
        List<PubStatus__c> newStatusList = new List<PubStatus__c>();
            
         
        for(Status__c status : StatusModel.GlobalStatusList){
            //#def 345 -Insert Approve by All Authors during Pub Creation
            if (isGlobalStatusInitial(status)) {
                PubStatus__c newPubStatus = new PubStatus__c();
                newPubStatus.Publication_id__c = pubId;   
                newPubStatus.Status__c = status.id;
                newPubStatus.Submission_Cycle__c = firstSubmissionCycle.id;
                
                newStatusList.add(newPubStatus);
            }
        }   
        
        if ( newStatusList.size() > 0){ 
            insert newStatusList;
        }

        Integer SubmitFprCycleNum = 1;
        if ( pubModel.CurrentFprCycleNum == 0) {
            SubmitFprCycleNum = 1;
        } else {
            SubmitFprCycleNum = pubModel.CurrentFprCycleNum + 1;
        }           
        FPR_Cycle__c newFprCycle = pubModel.FprCycle.getFprCycleByNum(SubmitFprCycleNum);
        
        /* as of def 805, this is no longer needed. Created upon pub create, moved to current on any FC/SC increment where ActualDate == null 
        if ( statusList.size() == 0) {
            //newFprCycle

            PubStatus__c newPubStatus = new PubStatus__c();
            newPubStatus.Publication_id__c = pubId;   
            newPubStatus.Status__c = statusModel.SubmittedCompleted.id;
            newPubStatus.Submission_Cycle__c = firstSubmissionCycle.id;
            newPubStatus.FPR_Cycle__c = newFprCycle.id;
            insert newPubStatus;    
            
            newStatusList.add(newPubStatus);
        }*/
        
        Set<id> ApprovedPublishedIdSet = new Set<Id>();
        ApprovedPublishedIdSet.add(StatusModel.AuthorApprovals.Id);
        ApprovedPublishedIdSet.add(StatusModel.PublishedPresented.Id);
        ApprovedPublishedIdSet.add(StatusModel.SubmittedCompleted.Id);
        ApprovedPublishedIdSet.add(StatusModel.Accepted.Id);
        
        List<PubStatus__c> ApprovedPublishedStatusList = [
            select id 
            from PubStatus__c
            where Submission_Cycle__c = :firstSubmissionCycle.id
            and publication_id__c = :pubId
            and Status__c in :ApprovedPublishedIdSet
        ];
        for(PubStatus__c ps : ApprovedPublishedStatusList) {
            ps.FPR_Cycle__c = newFprCycle.id;
        }
        update ApprovedPublishedStatusList;
        
        return newStatusList;
    }
    
    //Def #805 - move Status to the specified SubmissionCycle / FprCycle which have a null EndDate
    public void MovePubStatusToCurrentFCandSC(List<Status__c> statusList, Id submissionCycleId, id fprCycleId, boolean moveFCforSOPStatuses) {

        //Create a set to filter the status we are interested in
        Set<Id> statusIdSet = new Set<Id>();
        for(Status__c status : statusList) {
            statusIdSet.add(status.id);
        }
        
        List<PubStatus__c> PubStatusList = [
            select id, Status__c, status__r.Name, publication_Id__c, Submission_Cycle__c, Fpr_Cycle__c, ActualDate__c, IsCurrentSubmissionCycleForPub__c, Submission_Cycle__r.TargetLabelFormula__c 
            from PubStatus__c
            where publication_id__c = :pubId
            and IsLogicallyDeleted__c = false
        ];
                            
        //Create a map of all status for the Pub
        Map<id, PubStatus__c> statusMap = new Map<Id, PubStatus__c>();
        for(PubStatus__c pubStatus : PubStatusList) {
            if ( statusIdSet.contains(pubStatus.Status__c) && pubStatus.ActualDate__c == null ) {               
                statusMap.put(pubStatus.Status__c, pubStatus);              
            }  else if ( pubStatus.status__c == StatusModel.MaterialChangeforSubsequentSubmission.Id || 
                                pubStatus.status__c == StatusModel.NonMaterialChangeforSubsequentSubmission.Id) {  
                //CCB 258: If moveFCforSOPStatuses==TRUE, these new SOP statuses will be made part of the 'move' to a new FC. Otherwise, these are ignored for the following workflows: 
                //          >> Material Changes for Congress/Journal
                //          >> SubmitForFPR
                if(pubStatus.IsCurrentSubmissionCycleForPub__c && moveFCforSOPStatuses) 
                {
                    statusMap.put(pubStatus.Status__c, pubStatus);
                    
                    if(pubModel.CurrentSubmissionCycleHasMaterialChangeforSubsequentSubmissionStatusWithActualDate) {
                            statusList.add(StatusModel.MaterialChangeforSubsequentSubmission);
                    } else if (pubModel.CurrentSubmissionCycleHasNonMaterialChangeforSubsequentSubmissionStatusWithActualDate) {
                            statusList.add(StatusModel.NonMaterialChangeforSubsequentSubmission);
                    }
                }
            }
        }
        
        //now process each of the status we need to create or move
        List<PubStatus__c> movePubStatusList = new List<PubStatus__c>();
        for(Status__c status : statusList) {
            if ( statusMap.containsKey(status.id)) {
                PubStatus__c movePubStatus = statusMap.get(status.id); //it exists! - just move it
        
                if (status.id != StatusModel.AuthorApprovals.Id) {
                    movePubStatus.Submission_Cycle__c = submissionCycleId;
                    movePubStatus.FPR_Cycle__c = fprCycleId;
                    movePubStatusList.add(movePubStatus);
                } else if (movePubStatus.IsCurrentSubmissionCycleForPub__c) {
                    movePubStatus.FPR_Cycle__c = fprCycleId;
                    movePubStatusList.add(movePubStatus);
                }
            }
        }
        
        if(movePubStatusList.size() > 0) {
            update movePubStatusList;
        }
      
    }
    
    //Def #686 - create or move Status to the specified SubmissionCycle / FprCycle
    public void CreateOrMovePubStatus(List<Status__c> statusList, Id submissionCycleId, Id fprCycleId) {
        
        //Create a set to filter the status we are interested in
        Set<Id> statusIdSet = new Set<Id>();
        for(Status__c status : statusList) {
            statusIdSet.add(status.id);
        }
        
        List<PubStatus__c> PubStatusList = [
            select id, status__c, publication_Id__c, Submission_Cycle__c, Fpr_Cycle__c, ActualDate__c    
            from PubStatus__c
            where publication_id__c = :pubId
            and IsLogicallyDeleted__c = false
        ];
        
        //Create a map of all status for the Pub
        Map<id, PubStatus__c> statusMap = new Map<Id, PubStatus__c>();
        for(PubStatus__c pubStatus : PubStatusList) {
            if ( statusIdSet.contains(pubStatus.Status__c) ) {
                
                //Def# 805 - 2013-12-16 - Sesha found problem with moving Submitted/Completed Status with Actual Date
                //benjamin added code to Not add Submitted/Completed to map 
                //if ( !( PubStatus.Status__c == StatusModel.SubmittedCompleted.id && PubStatus.ActualDate__c == null) ) {      
                //  statusMap.put(pubStatus.Status__c, pubStatus);
                //}
                /* This change has not been migrated to systest20 or full due to code freeze */
                
                statusMap.put(pubStatus.Status__c, pubStatus);
                
            }
        }
        
        //now process each of the status we need to create or move
        List<PubStatus__c> createMovePubStatusList = new List<PubStatus__c>();
        for(Status__c status : statusList) {
            if ( statusMap.containsKey(status.id)) {
                //it exists ! - just move it
                PubStatus__c movePubStatus = statusMap.get(status.id);
                movePubStatus.Submission_Cycle__c = submissionCycleId;
                movePubStatus.FPR_Cycle__c = fprCycleId;
                createMovePubStatusList.add(movePubStatus);
            } else {
                //it does not exist - create it
                
                PubStatus__c newPubStatus = new PubStatus__c();
                newPubStatus.Publication_id__c = pubId;   
                newPubStatus.Status__c = status.id;
                newPubStatus.Submission_Cycle__c = submissionCycleid;
                newPubStatus.Fpr_Cycle__c = fprCycleid;
                createMovePubStatusList.add(newPubStatus);
            }
        }
        
        if(createMovePubStatusList.size() > 0) {
            upsert createMovePubStatusList;
        }
      
    }

    //#def 345 -Insert Approve by All Authors during Pub Creation
    public List<PubStatus__c> InsertGlobalStatusReviewSubmit(Id submissionCycleId, Id fprCycleId) {
        AppLogModel.LogInfo('PubStatusModel::InsertGlobalStatusReviewSubmit', 'start');
        
        List<PubStatus__c> newStatusList = new List<PubStatus__c>();
            
        for(Status__c status : StatusModel.GlobalStatusList){
            if (isGlobalStatusFPR(status)) {
                
                AppLogModel.LogDebug('InsertGlobalStatusReviewSubmit', 'insert '+ status.Name);
                
                PubStatus__c newPubStatus = new PubStatus__c();
                newPubStatus.Publication_id__c = pubId;   
                newPubStatus.Status__c = status.id;
                newPubStatus.Submission_Cycle__c = submissionCycleid;
                newPubStatus.Fpr_Cycle__c = fprCycleid;
                newStatusList.add(newPubStatus);
            }
        }   
        if ( newStatusList.size() > 0){ 
            insert newStatusList;
        }
        
        AppLogModel.flushLogs();
        return newStatusList;
    }
    
    public void InsertProfileDependentInitialStatus(SubmissionCycle__c firstSubmissionCycle){
        //if GPPL - insert the concept status 
       
        Id initStatusId = StatusModel.PendingSuggestion.id;         // default choice all profiles

        if ( pubModel.pubRecord.hasFPROnlyStatus__c) {
            initStatusId =  StatusModel.FPROnly.id;                 // If pub is FPR Only - set as such 
        } else if (ProfileModel.isAppearIntFPRC || ProfileModel.isAppearExternalWriter || ProfileModel.isAppearFPRC || ProfileModel.isAppearWriting) {  
            
            if ( PubTypeModel.PubTypeInitialStatusSuggested.contains(pubModel.pubRecord.PubType__c) ) {
                initStatusId =  StatusModel.Suggested.id;               // def #469
            } else {
                initStatusId =  StatusModel.Created.id;                 // def #355
            }
            
        } else if ( ProfileModel.isAppearGPPL ) {
            initStatusId =  StatusModel.Concept.id;                 // GPPL Profile  go straight to Concept stage   
        } else if ( ProfileModel.isAppearFprOnlySubmitter  || ProfileModel.isAppear626 ) {
            if (!pubModel.pubRecord.hasFPROnlyStatus__c) {
                pubModel.pubRecord.hasFPROnlyStatus__c = true;
                update pubModel.pubRecord;
            }
            initStatusId =  StatusModel.FPROnly.id;                 // FPR Only submitter or 626 - has to prepare and submit to FPR
        } 
        
        PubStatus__c newInitStatus = new PubStatus__c();  
        newInitStatus.Publication_id__c = pubId;   
        newInitStatus.Status__c = initStatusId;
        newInitStatus.Submission_Cycle__c = firstSubmissionCycle.Id;
        newInitStatus.ActualDate__c = DateTime.Now();        
       
        AppLogModel.LogDebug('PubStatusModel::InsertProfileDependentInitialStatus', 
            'Pub is '+pubId+ 
            '\n  Pub initial Status - '+ newInitStatus.Status__c +
            '\n  Pub initial Status Date - '+newInitStatus.ActualDate__c);
       
        insert newInitStatus;
    }
    
    //insert Draft after Reject
    public void InsertDraftWithActualDate(Id SubmissionCycleId, Id FprCycleId, boolean insertDraft){
        if(insertDraft) { //CCB 258 (SESHA): Avoid auto inserting a Draft status with Actual Date if there is a new SOP Status = "Non-Material Change for New Target"
            PubStatus__c newStatus = new PubStatus__c();
            newStatus.Publication_id__c = pubId;   
            newStatus.Status__c = StatusModel.Draft.Id;
            newStatus.Submission_Cycle__c = SubmissionCycleId;
            newStatus.FPR_Cycle__c = FprCycleId;
            newStatus.ActualDate__c = DateTime.Now();
            insert newStatus;
        }
    }


    public void InsertFprWithHeldWithActualDate(Id SubmissionCycleId, Id FprCycleId){
        
        PubStatus__c newStatus = new PubStatus__c();
        newStatus.Publication_id__c = pubId;   
        newStatus.Status__c = StatusModel.FprWithHeld.Id;
        newStatus.Submission_Cycle__c = SubmissionCycleId;
        newStatus.FPR_Cycle__c = FprCycleId;
        newStatus.ActualDate__c = DateTime.Now();    
        insert newStatus;
    }




    // Insert a Terminate FPR Cycle status for current FPR Cycle
    // Insert new statuf for the next FPR Cycle as configured in the status Object
    // Set Actual date for In FPR status for the next FPR Cycle.
    public List<PubStatus__c> InsertTerminateFPRCycleStatus(){
        AppLogModel.LogInfo('PubStatusModel::InsertTerminateFPRCycleStatus', 
            'Invoking Termianted FPR Cycle for Pub -  '+PubId+ 
            '  Pub.PubStatus__c - '+pubmodel.pubRecord.PubStatus__c +
            '  Pub.Current_FPR_Cycle_sort_num__c = '+pubModel.pubRecord.Current_FPR_Cycle_sort_num__c);
    
        List<PubStatus__c> newStatusList = new List<PubStatus__c>();
                    
        PubStatus__c TerminateFPRCyclePubStatus = new PubStatus__c();
        TerminateFPRCyclePubStatus.Publication_id__c = PubId;   
        TerminateFPRCyclePubStatus.ActualDate__c = DateTime.Now();
        TerminateFPRCyclePubStatus.Status__c = StatusModel.TerminateFPRCycle.id;
        TerminateFPRCyclePubStatus.FPR_Cycle__c = PubModel.pubRecord.Current_FPRCycle_Id_Formula__c;
        newStatusList.add(TerminateFPRCyclePubStatus);
    
    
        insert newStatusList;

        AppLogModel.LogInfo('PubStatusModel::InsertTerminateFPRCycleStatus', 'Termianted FPR Cycle for Pub -  '+PubId);
        return newStatusList;
    }
    
    
    public PubStatus__c InsertRejectedAfterSubmissionStatus() {
        PubStatus__c newPubStatus = new PubStatus__c();
        newPubStatus.Publication_id__c = pubId;   
        newPubStatus.Status__c = StatusModel.Rejected.id;
        newPubStatus.ActualDate__c = DateTime.now();
        newPubStatus.Submission_Cycle__c = pubModel.CurrentSubmissionCycleId;
        newPubStatus.FPR_Cycle__c = pubModel.CurrentFprCycleId; 
        
        insert  newPubStatus;
        
        return newPubStatus;
    }
    
    public List<PubStatus__c> InsertNextSubmissionCycleGlobalStatus() {
        integer nextSubmissionCycleNum = pubModel.CurrentSubmissionCycleNum + 1;
        SubmissionCycle__c nextSubCycle = pubModel.SubmissionCycle.getSubmissionCycleByNum(nextSubmissionCycleNum);
        
        if ( nextSubCycle == null) {
            AppLogModel.LogError('PubStatusModel::InsertNextSubmissionCycleGlobalStatus', 'Abort - invalid SubmissionCycle');
            return new List<PubStatus__c>();
        }
        
        Id FprCycleId = pubModel.CurrentFprCycleId;
        
        //use the same list as Terminate for now - we can define a new list if required
        List<PubStatus__c> newStatusList = new List<PubStatus__c>();
        for(Status__c status : StatusModel.NewStatusAfterTerminateFPRCycleList){
            PubStatus__c newPubStatus = new PubStatus__c();
            newPubStatus.Publication_id__c = pubId;   
            newPubStatus.Status__c = status.id;
            newPubStatus.Submission_Cycle__c = nextSubCycle.Id;
            newPubStatus.FPR_Cycle__c = FprCycleId;
                            
            newStatusList.add(newPubStatus);
        }    
        if ( newStatusList.size() > 0){ 
            insert newStatusList;
        }
    
        AppLogModel.LogInfo('PubStatusModel::InsertTerminateFPRCycleStatus', 'Inserted global status for next Submission Cycle for Pub -  '+PubId);
        return newStatusList;
    }
    
    public List<PubStatus__c> InsertMaterialChangeForCongressJournalStatus(){
        AppLogModel.LogInfo('PubStatusModel::InsertMaterialChangeForCongressJournalStatus', 
            'Invoking Termianted FPR Cycle for Pub -  '+PubId+ 
            '  Pub.PubStatus__c - '+pubmodel.pubRecord.PubStatus__c +
            '  Pub.Current_FPR_Cycle_sort_num__c = '+pubModel.pubRecord.Current_FPR_Cycle_sort_num__c);
        

    
        integer thisFprCycleNum = integer.valueOf(pubModel.pubRecord.Current_FPR_Cycle_sort_num__c);
        integer nextFprCycleNum = thisFprCycleNum+1;
        FPR_Cycle__c currFprCycle = pubModel.FprCycle.getFprCycleByNum(thisFprCycleNum);
        FPR_Cycle__c nextFprCycle = pubModel.FprCycle.getFprCycleByNum(nextFprCycleNum);
        
        AppLogModel.LogInfo('PubStatusModel::InsertMaterialChangeForCongressJournalStatus', 
            'NextFprCycle num = '+ nextFprCycle.FPR_Cycle_Num__c);
        
        id SubmissionCycleId = pubModel.SubmissionCycle.CurrentSubmissionCycle.id;
        
        List<PubStatus__c> newStatusList = new List<PubStatus__c>();
        
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = PubId;   
        newPubStatusRecord.ActualDate__c = DateTime.Now();
        newPubStatusRecord.Status__c = StatusModel.MaterialChangesForCongressJournal.id;
        newPubStatusRecord.Submission_Cycle__c = SubmissionCycleId;
        newPubStatusRecord.FPR_Cycle__c = PubModel.pubRecord.Current_FPRCycle_Id_Formula__c;
        
        newStatusList.add(newPubStatusRecord);
        
        
        //always insert a draft, 
        PubStatus__c newPubStatus = new PubStatus__c();
        newPubStatus.Publication_id__c = pubId;   
        newPubStatus.Status__c = StatusModel.Draft.id;
        newPubStatus.Submission_Cycle__c = SubmissionCycleId;
        newPubStatus.FPR_Cycle__c = nextFprCycle.Id;
        
        newStatusList.add(newPubStatus);

        //always insert an Approved by all Authors 
        PubStatus__c newApprovedByAllAuthorsStatus = new PubStatus__c();
        newApprovedByAllAuthorsStatus.Publication_id__c = pubId;   
        newApprovedByAllAuthorsStatus.Status__c = StatusModel.AuthorApprovals.id;
        newApprovedByAllAuthorsStatus.Submission_Cycle__c = SubmissionCycleId;
        newApprovedByAllAuthorsStatus.FPR_Cycle__c = nextFprCycle.Id;

        newStatusList.add(newApprovedByAllAuthorsStatus);

        insert newStatusList;
        
        //def 805, always copy when incrementing FC or SC
        MovePubStatusToCurrentFCandSC(statusModel.ResetFprCycleStatusList, SubmissionCycleId, nextFprCycle.id, false);  

        /*
        //change accepted, published/presented status from old FC to new FC
        List<pubStatus__c> updatePubStatusList = new List<pubStatus__c>();
        for(PubStatus__c pubStatus : PubStatusList) {
            if (pubStatus.Submission_Cycle__c == SubmissionCycleId) {
                if ( pubStatus.status__c == statusModel.Accepted.id || pubStatus.status__c == StatusModel.PublishedPresented.id) {
                    pubStatus.FPR_Cycle__c = nextFprCycle.Id;
                    updatePubStatusList.add(pubStatus);
                } 
            }   
        }
        update updatePubStatusList;
            */
        pubModel.PubReviewTeam.CopyPubReviewTeamBetweenCycles(thisFprCycleNum, nextFprCycleNum);
    
        AppLogModel.LogInfo('PubStatusModel::InsertMaterialChangeForCongressJournalStatus', 
            'MaterialChangeForCongressJournalStatus inserted for Pub -  '+PubId);
        return newStatusList;
    }
    
    public static FPR_Cycle__c getNextFPRCycle(PubStatus__c pubStatus) {
        AppLogModel.LogDebug('PubStatusModel::getNextFPRCycle', 'pubStatus.FPR_Cycle_sort_num__c = ' + pubStatus.FPR_Cycle_sort_num__c);
        integer nextFprCycleNum = 1;
        if (pubStatus.FPR_Cycle__c <> null) {
            nextFprCycleNum = integer.valueOf(pubStatus.FPR_Cycle_sort_num__c) + 1;
        }
        FPR_Cycle__c nextFprCycle = FprCycleModel.getFprCycleByNum(pubStatus.Publication_id__c, nextFprCycleNum);
        AppLogModel.LogInfo('PubStatusModel::getNextFPRCycle', 'nextFprCycle = ' + nextFprCycle);
        return nextFprCycle;
    } 

    
    public PubStatus__c InsertRoutePubStatus(DateTime routeDateTime){
        
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = PubId;   
        newPubStatusRecord.ActualDate__c = routeDateTime;
        newPubStatusRecord.Status__c = StatusModel.StatusMap.get('Routed').Id;
        
        insert newPubStatusRecord;
        pPubStatusList = null;
        
        //mark all status with display order greater than Router to the same FPR Cycle
        List<PubStatus__c> pubStatus = [
            select FPR_Cycle__c, Status__r.displayOrder__c
            from PubStatus__c
            where Publication_id__c = :PubId
            and FPR_Cycle__c = null
            and status__r.displayOrder__c >= :StatusModel.StatusMap.get('Routed').displayOrder__c
        ];
        for(PubStatus__c pubStat : pubStatus){
            pubStat.FPR_Cycle__c = pubModel.CurrentFprCycleId;
        }
        update pubStatus;
        
        AppLogModel.LogInfo('PubStatusModel::InsertRoutePubStatus', 'Inserting new Route Auto Insert status for '+PubId);
        return newPubStatusRecord;
    }
    

    
    public static Set<Id> GetPubsRoutedCurrentFPRCycle(Set<Id> pubsToFilter) {
        Set<id> filteredPubs = new Set<Id>();
        
        List<PubStatus__c> pubStatus = [
            select FPR_Cycle__c, Status__r.displayOrder__c, Publication_id__c, Status__r.name
            from PubStatus__c
            where Publication_id__c IN :pubsToFilter
            and IsCurrentFPRCycleForPub__c = TRUE
            and status__r.displayOrder__c >= :StatusModel.StatusMap.get('Routed').displayOrder__c
            and ActualDate__c != null
        ];
        
        for(PubStatus__c pub :pubStatus) {
            filteredPubs.add(pub.Publication_id__c);
        }
        
        return filteredPubs;
    }
    
    public boolean IsPubRoutedCurrentFPRCycle() {
        List<PubStatus__c> pubStatus = [
            select FPR_Cycle__c, Status__r.displayOrder__c
            from PubStatus__c
            where Publication_id__c = :PubId
            and FPR_Cycle__c = :pubModel.CurrentFprCycleId
            and status__r.displayOrder__c >= :StatusModel.StatusMap.get('Routed').displayOrder__c
            and ActualDate__c != null
        ];
        
        return pubStatus.size() > 0;
    }
    
    public static PubStatus__c insertAssignToFPRC(Id PubId) {
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = PubId;   
        newPubStatusRecord.ActualDate__c = DateTime.Now();
        newPubStatusRecord.Status__c = StatusModel.AssignedToFPRC.Id;
        
        insert newPubStatusRecord;

        
        AppLogModel.LogInfo('PubStatusModel::insertAssignToFPRC', 'Assign to FPRC for '+ PubId);
           
        return newPubStatusRecord;
    }
    
    //Submit for FPR Button
    public PubStatus__c InsertInFprPubStatus(Id FprCycleId){
        
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = PubId;   
        newPubStatusRecord.ActualDate__c = DateTime.Now();
        newPubStatusRecord.Status__c = StatusModel.StatusMap.get('In FPR').Id;
        newPubStatusRecord.FPR_Cycle__c = FprCycleId;
        insert newPubStatusRecord;
        
        clearCache();
        AppLogModel.LogInfo('PubStatusModel::InsertInFprPubStatus', 'Inserting new In FPR  AutoInsert status for '+PubId);
          
        return newPubStatusRecord;
    }

     
     public PubStatus__c InsertApprovedByAllAuthors(Id SubmissionCycleId, Id FprCycleId){
        
        List<PubStatus__c> PubStatusList = [
            select id, Status__c, status__r.Name, publication_Id__c, Submission_Cycle__c, Fpr_Cycle__c, ActualDate__c, IsCurrentSubmissionCycleForPub__c, Submission_Cycle__r.TargetLabelFormula__c 
            from PubStatus__c
            where publication_id__c = :pubId
            and Submission_Cycle__c = :SubmissionCycleId
        ];
        Set<Id> statusIdSet= new Set<Id>();
        for(PubStatus__c pubstat :PubStatusList )
        statusIdSet.add(pubstat.Status__c);
        
        if(!statusIdSet.contains(StatusModel.AuthorApprovals.Id)){
         PubStatus__c newStatus = new PubStatus__c();
         newStatus.Publication_id__c = pubId;   
         newStatus.Status__c = StatusModel.AuthorApprovals.Id;
         newStatus.Submission_Cycle__c = SubmissionCycleId;
         newStatus.FPR_Cycle__c = FprCycleId;
  
         insert newStatus;
         System.debug('Approved by all author added'+newStatus);
         clearCache();
         AppLogModel.LogInfo('PubStatusModel::InsertByApprovedByAllAuthors', 'Inserting ApprovedByAllAuthors global status for '+PubId);
        }        
       
        return newPubStatusRecord;
    }


     
    //Accept Pub Button
    public void InsertConceptPubStatus() {
        InsertConceptPubStatus(PubId, DateTime.Now());      
        pPubStatusList = null;              
    } 
    
    //Accept Pub Button
    public static PubStatus__c InsertConceptPubStatus(Id PubId, DateTime routeDateTime){
        
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = PubId;   
        newPubStatusRecord.ActualDate__c = routeDateTime;
        newPubStatusRecord.Status__c = StatusModel.StatusMap.get('Concept').Id;
        
        //trigger will fill in submission / fpr cycle
        
        insert newPubStatusRecord;
        AppLogModel.LogInfo('PubStatusModel::InsertConceptPubStatus', 'Inserting new Concept  AutoInsert status for '+PubId);
        
        return newPubStatusRecord;
    }
    
    //Reject Pub Button
    public void InsertSuggestionRejectedPubStatus() {
        InsertSuggestionRejectedPubStatus(DateTime.Now());                      
    } 
    
    //Reject Pub Button
    public string InsertSuggestionRejectedPubStatus(DateTime routeDateTime){
        
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = PubId;   
        newPubStatusRecord.ActualDate__c = routeDateTime;
        newPubStatusRecord.Status__c = StatusModel.StatusMap.get('Suggestion Rejected').Id;
        
        //trigger will fill in submission / fpr cycle
        
        insert newPubStatusRecord;
        pPubStatusList = null;
        
        AppLogModel.LogInfo('PubStatusModel::InsertSuggestionRejectedPubStatus', 'Inserting new Concept  AutoInsert status for '+PubId);
        
        return '';
    }
    
    
    //invoke by Publication Trigger - PubUpsertTriggerLogic
    @future
    public static void UpdateLatestSubmittedCompletedStatusTargetDate(id PubId, Date targetDate){
        List<PubStatus__c> pubstatus = [
            select TargetDate__c, status__c, status__r.name, RevisedTargetDate__c 
            from PubStatus__c
            where Publication_id__c = :pubId
            and Status__c = :StatusModel.SubmittedCompleted.id
            order by Createddate desc
            limit 1
        ];
        
        if ( pubstatus.size() == 1) {
            //if ( pubstatus[0].TargetDate__c == null) {
            pubstatus[0].TargetDate__c = targetDate;
            pubstatus[0].RevisedTargetDate__c = targetDate; //Whenever the PST Approved Submission Date is saved, the same date value needs to populated on the Revised Target Date as well.
            pubstatus[0].Reason_For_Change__c = 'No Data Available'; //The default value is set to "No Data Available"
            //} else {
            //    pubstatus[0].RevisedTargetDate__c = targetDate;
            //}
            try {
                update pubstatus;
            } catch (DmlException err) {
                if(err.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    //ApexPages.addMessages(err);
                    pubstatus[0].targetDate__c.addError(err);
                }
                else throw err;                 
            }
        }
    }
    
    public static void SetFprCompletedStatus(Id pubId, Status__c fprCompletionStatus, Id submissionCycleId, Id fprCycleId, integer fprCycleNum, DateTime CompletionDateTime) 
    {
        AppLogModel.LogInfo('PubStatusModel::SetFprCompletedStatus', 
                'Updating Status to ' + fprCompletionStatus.name + ' for Pub ' + pubId +' FPRCycle# = '+fprCycleNum, 'Publication : '+ pubId);
                
        List<PubStatus__c> pubStatus = [
            select ActualDate__c    
            from PubStatus__c
            where Publication_id__c = :pubId
            and Status__c = :fprCompletionStatus.id
            and FPR_Cycle__c = :fprCycleId
            and IsLogicallyDeleted__c = false
            order by Createddate desc
            limit 1
        ];
        
        if (pubStatus.size() == 1){
            pubStatus[0].ActualDate__c = CompletionDateTime;
            update PubStatus[0];
        } else {
            PubStatus__c newPubStatusRecord = new PubStatus__c();
            newPubStatusRecord.Publication_id__c = PubId;   
            newPubStatusRecord.ActualDate__c =  DateTime.Now(); 
            newPubStatusRecord.Status__c = fprCompletionStatus.Id;
            newPubStatusRecord.FPR_Cycle__c = fprCycleId;
            newPubStatusRecord.Submission_Cycle__c = submissionCycleId;
            insert newPubStatusRecord;
        }
    }

    public void updatePubStatusFprCycle( PubStatus__c latestPubStatus, id CurrentFprCycleId, Fpr_Cycle__c ToFprCycle){
        Status__c status = StatusModel.StatusMapById.get(latestPubStatus.Status__c);
        if ( status == null) {
            AppLogModel.LogInfo('PubStatusModel::updatePubStatusFprCycle', 
                'Aborting due to unknown status ' + latestPubStatus.Status__c);
            return;
        }
        Integer currentDisplayOrder = Integer.ValueOf(status.displayOrder__c);
    
        AppLogModel.LogInfo('PubStatusModel::updatePubStatusFprCycle', 
            'latestPubStatus = '+latestPubStatus);
    
        AppLogModel.LogInfo('PubStatusModel::updatePubStatusFprCycle', 
            'CurrentFprCycleId = '+CurrentFprCycleId +
            ' CurrentDisplayOrder = '+currentDisplayOrder);
        
        List<PubStatus__c> pubStatusList = [
            select Fpr_Cycle__c
            from PubStatus__c
            where Publication_id__c = :latestPubStatus.Publication_id__c
            //and Submission_Cycle__c = :currentSubmissionCycle   <-- should be independent of submission Cycle
            and Fpr_Cycle__c = :CurrentFprCycleId
            and Status__r.displayOrder__c >= :currentDisplayOrder
        ];
        
        AppLogModel.LogInfo('PubStatusModel::updatePubStatusFprCycle', 
            'Updating The following PubStatus '+pubStatusList +
            ' CurrentDisplayOrder = '+currentDisplayOrder);
        
        for ( PubStatus__c ps : pubStatusList){
            if ( ToFprCycle <> null) {
                ps.FPR_Cycle__c = ToFprCycle.Id;  
            }
        }
        update pubStatusList;
    }
    


    //
    public void ChangePubStatusToSubmitted(){
        List<PubStatus__c> pubstatus = [
            select ActualDate__c, status__c, status__r.name
            from PubStatus__c
            where Publication_id__c = :pubId
            and Submission_Cycle__c = :pubModel.CurrentSubmissionCycleId
            and FPR_Cycle__c = :pubModel.CurrentFprCycleId
            and Status__c = :StatusModel.SubmittedCompleted.id
            order by Createddate desc
            limit 1
        ];
        
        if ( pubstatus.size() == 1) {
            pubstatus[0].ActualDate__c = DateTime.now();
            update pubstatus;
            
            //update pubStatus will invoke trigger to setup pubStatus to status with latest date.
        }
    }   
    
    //////////////////////////////////////////////////////////////////////////////
    //PubNewDeptStatusItems returns a context sensitive list on new Department   
    //status items for the pub
    // 
    // Benjamin will need help from Cid on restricting this list of new status
    private List<SelectOption>  pPubNewDepStatusItems = null; 
    public List<SelectOption> PubNewDepStatusItems {
        get {
            if ( pPubNewDepStatusItems == null){
                //R1.3 - do not allow nested NMC or MC
                boolean hasOpenChange = currSubCycleHasOpenChange;
            
                pPubNewDepStatusItems = new List<SelectOption>();
                
                for ( Status__c status : StatusModel.DepartmentStatusList) {
                    AppLogModel.LogDebug('PubStatusModel::PubNewDepStatusItems', '\n SESHA::Status Id/Name = ' + status.id + ' / '  + status.name +
                            '\n hasOpenChange = ' + hasOpenChange +
                            '\n ProfileModel.CurrentProfileName = ' + ProfileModel.CurrentProfileName +
                            '\n rejectWithActualDate = ' + rejectWithActualDate);
                    
                    //CR #200; Permission Matrix {GPPL/WC/SA/BA are the only users allowed to choose - OnHold, Cancelled} 
                    //{FPRC/IFPRC/SA/BA are the only users allowed to choose - FPR Withdrawn}
                    if ((ProfileModel.isAppearGPPL || ProfileModel.isAppearExternalWriter || ProfileModel.isAppearWriting ) && (status.id == StatusModel.FprWithdrawn.id)) {
                        continue;
                    } else if ((ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC) && (status.id == StatusModel.OnHold.id || status.id == StatusModel.Cancelled.id)) {
                        continue;
                    } else if (hasOpenChange && status.id == StatusModel.NonMaterialChange.id) {
                        continue;
                    } else if ((status.id == StatusModel.MaterialChangeforSubsequentSubmission.id || status.id == StatusModel.NonMaterialChangeforSubsequentSubmission.id) ){
                        // CCB 258: Allow these statuses to be selectable for SA/BA/GPPL/WC alone 
                        if((rejectWithActualDate == 0) ||  
                                !(ProfileModel.isAppearGPPL || ProfileModel.isAppearBusinessAdmin ||  ProfileModel.isAppearWriting  || ProfileModel.isAppearExternalWriter || ProfileModel.isSysAdmin)
                          ) continue; 
                    }
                    // add item if none of filter matches 
                    pPubNewDepStatusItems.add(new SelectOption(status.id,status.name));

                }
            }
            return pPubNewDepStatusItems;
        }
    }
         
    //////////////////////////////////////////////////////////////////////////////
    private transient PubStatus__c newPubStatusRecord = null;
    public PubStatus__c NewPub { //insert from model
        get {
            if (newPubStatusRecord == null) {               
                newPubStatusRecord = new PubStatus__c();
                newPubStatusRecord.Publication_id__c = PubId;               
            }
            return newPubStatusRecord;
        }
        set {
            newPubStatusRecord = value;
        }
    }
    
    public string newStatusId {get;set;}
    public PageReference saveNewPubStatus() { 
        
        
        AppLogModel.LogInfo('PubStatusModel::saveNewPubStatus', 'Invoking saveNewPubStatus  SC = '+pubModel.CurrentSubmissionCycleNum +
            ' FC = '+pubModel.CurrentFprCycleNum +' current status = '+pubModel.CurrentStatus);
        if ( newStatusId == null){
            //error do not save
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                'Cannot create New Publication Status record without a Status');
            ApexPages.addMessage(myMsg);
            return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
        }
        
        if (newPubStatusRecord.ActualDate__c > DateTime.Now()){
            //error do not save
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                'Actual date field cannot be a future time.');
            ApexPages.addMessage(myMsg);
            return null;        
        }
        //Appear Enhancement R3: Start - Creation of New Pub Status for historical publication records if publication is an GPP pub
        if(pubModel.PubRecord.isPlanning__c && (pubModel.PubRecord.SponsorDept_Pick__c == null || pubModel.PubRecord.SponsorOrg_Pick__c == null 
        	|| pubModel.PubRecord.Country_pick__c == null || pubModel.PubRecord.RAE__c == null)){ //GPP Type validation removed R1:2017
	        	String message='The following field(s) are required for a GPP publication:';
	        	if(pubModel.PubRecord.SponsorDept_Pick__c == null)
	                  message = message + ' Sponsoring Amgen Department,';
	            if(pubModel.PubRecord.SponsorOrg_Pick__c == null)
	                  message = message + ' Sponsoring Organization,';
	            if(pubModel.PubRecord.RAE__c == null)
	                  message = message + ' Responsible Amgen Employee (RAE),';
	            if(pubModel.PubRecord.Country_pick__c == null)
	                  message = message + ' Country,';
	            //Commented below as part of Appear Enhancment R1:2017
                /*if(pubModel.PubRecord.GPP_Type__c == null)
	              	  message = message + ' Publication Classification,'; */             	  
	            message = message.removeEnd(',');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,message);
            ApexPages.addMessage(myMsg);   
        	return null;        	
        }
        //Appear Enhancement R3: End - Creation of New Pub Status for historical publication records if publication is an GPP pub
        newPubStatusRecord.Status__c = newStatusId;
        Status__c newStatus = StatusModel.StatusMapById.get(newStatusId);
        AppLogModel.LogInfo('PubStatusModel::saveNewPubStatus', 'Saving new Status = ' + newStatus.name);
        AppLogModel.flushLogs();
        
        
        insert newPubStatusRecord;              
        
        //Def #534
        if ( newPubStatusRecord.Status__c == StatusModel.FprWithdrawn.id) {
            //Copy the adhoc reviewer -- the ones wth isFromSubGroupDataSource = false          
            pubModel.PubReviewTeam.DuplicateAdHocReviewer();
             
            //Now we have a new Product Indication - should flush PubTeamMember cache
            //get the latest pubteam in cache before SubmitForFPR
            pubModel.PubTeamMember.flushCache();
            pubModel.PubReviewTeam.flushCache();
        }
        
        AppLogModel.flushLogs();
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    public PageReference cancelNewPubStatusCreation() {
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    //////////////////////////////////////////////////////////////////////////////

    public List<PubStatus__c> PubStatusForPub(Id PubId) {
        if ( PubId == null) {
            return null;
        }
        
        List<PubStatus__c> pubStatusList = [ 
            select ActualDate__c, Comments__c, RevisedTargetDate__c,
                Publication_id__c, Status__r.Name, Status__r.DisplayOrder__c,
                Status__r.RecordType.Name, TargetDate__c,Target__c, Reason_For_Change__c, 
                Journal__r.Name, Meeting__r.Name, IsLogicallyDeleted__c,IsActualDateEditable__c,
                Submission_Cycle__c, Submission_Cycle__r.Submission_Cycle_Num__c,Submission_Cycle__r.TargetLabelFormula__c,
                FPR_Cycle__c, FPR_Cycle__r.FPR_Cycle_Num__c,IsCurrentFPRCycleForPub__c,IsCurrentSubmissionCycleForPub__c,Publication_id__r.GPP_Type__c, Publication_id__r.isPlanning__c, Publication_id__r.Current_FPRCycle_Id_Formula__c //Appear Enhancement R3 Submitted/Completed actual date population GPP type and isPlanning added and Publication_id__r.Current_FPRCycle_Id_Formula__c,
            from PubStatus__c
            where Publication_id__c = :PubId 
            and IsLogicallyDeleted__c = false
            order by 
                Submission_Cycle__r.Submission_Cycle_Num__c, 
                FPR_Cycle__r.FPR_Cycle_Num__c, 
                Status__r.DisplayOrder__c, 
                ActualDate__c 
        ];
        
        
        for(PubStatus__c p : pubStatusList){
            if ( p.Journal__c == null  && p.Meeting__r != null) {
                p.Target__c = p.Meeting__r.Name;
            } else if ( p.Journal__c != null  && p.Meeting__r == null) {
                p.Target__c = p.Journal__r.Name;
            }
            
            
            if (CheckEditActualDate(p)) {
                p.IsActualDateEditable__c = true;
            } else {
                p.IsActualDateEditable__c = false;
            }
        }
        
        
        string msg = 'PubStatusModel retrieved ' + pubStatusList.size()+' records for PubId = '+PubId;
        System.Debug(msg);
        
        return pubStatusList;
    }
    
    private boolean pShowRemoveFromGPPButton;
    public boolean ShowRemoveFromGPPButton {
        get{
            if (pShowRemoveFromGPPButton == null && PubModel != null) {
                if ( ProfileModel.isAppearGPPL || ProfileModel.isAppearBusinessAdmin || ProfileModel.isSysAdmin || Test.isRunningTest()) {
                    //Remove From GPP Button needs to be hidden during ISS = TRUE, Tracking = TRUE, Status = Pending FPR Submission, Status = Suggested
                    if (PubModel.pubRecord.Is_Tracking_Only__c || PubModel.pubRecord.isISS__c || 
                            CurrentPubStatus.Status__r.Id == StatusModel.FPROnly.Id ||
                            CurrentPubStatus.Status__r.Id == StatusModel.Suggested.Id || 
                            CurrentPubStatus.Status__r.Id == StatusModel.PendingSuggestion.Id) { //CR #227/229
                        pShowRemoveFromGPPButton = false;
                    } else {
                        pShowRemoveFromGPPButton = PubModel.PubRecord.isPlanning__c;
                    }
                } else {
                    pShowRemoveFromGPPButton = false;
                }           
            } 
            return pShowRemoveFromGPPButton;
        }
    }
    
    private boolean pShowMoveToGPPButton;
    public boolean showMoveToGPPButton {
        get{
            if (pShowMoveToGPPButton == null && PubModel != null) {
                if ( ProfileModel.isAppearGPPL || ProfileModel.isAppearBusinessAdmin || ProfileModel.isSysAdmin || Test.isRunningTest()) {
                    //Add to GPP Button needs to be hidden during ISS = TRUE, Tracking = TRUE, Status = Pending FPR Submission, Status = Suggested
                    if (PubModel.pubRecord.Is_Tracking_Only__c || PubModel.pubRecord.isISS__c || 
                            CurrentPubStatus.Status__r.Id == StatusModel.FPROnly.Id ||
                            CurrentPubStatus.Status__r.Id == StatusModel.Suggested.Id || 
                            CurrentPubStatus.Status__r.Id == StatusModel.PendingSuggestion.Id) { //CR #227/229
                        pShowMoveToGPPButton = false;
                    } else {
                        pShowMoveToGPPButton = !PubModel.PubRecord.isPlanning__c;
                    }
                } else {
                    pShowMoveToGPPButton = false;
                }           
            } 
            return pShowMoveToGPPButton;
        }
    }
    
    private boolean pShowPubRejectedInit = false;
    private boolean pShowPubRejectedButton;
    public boolean showPubRejectedButton {
        get{
            if (!pShowPubRejectedInit) {
                //Defect 702 CC 134 Reject Button should only be visible for SA, BA, and GPPL profiles
                //if ( ProfileModel.isAppearWriting || ProfileModel.isAppearGPPL || ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC || ProfileModel.isSysAdmin || Test.isRunningTest()) {
                if ( ProfileModel.isAppearGPPL || ProfileModel.isAppearBusinessAdmin || ProfileModel.isSysAdmin || Test.isRunningTest()) {                
                    pShowPubRejectedButton = PubModel.PubRecord.RecordTypeId == RecordTypeModel.PublicationSubmitRecTypeId;
                } else {
                    pShowPubRejectedButton = false;
                }
                pShowPubRejectedInit = true;                
            } 
            return pShowPubRejectedButton;
        }
    }
    
    private boolean pShowTerminateFprInit = false;
    private boolean pShowTerminateFprButton;
    public boolean showTerminateFprButton {
        get{
            if (!pShowTerminateFprInit) {
            //Defect 326 CC 19 The TerminateFPRCycle button should not appear for any record types outside of InFPR and AssignedtoFPRC
                //if (PubModel.PubRecord.RecordTypeId == RecordTypeModel.PublicationReviewRecTypeId ) {
                //    pShowTerminateFprButton = ProfileModel.isAppearBusinessAdmin || 
                //                                ProfileModel.isAppearFPRC ||                            
                //                                ProfileModel.isAppearIntFPRC || 
                //                                ProfileModel.isSysAdmin || 
                //                                Test.isRunningTest();
                //} else 
                if (PubModel.PubRecord.RecordTypeId == RecordTypeModel.PublicationInFPRCTypeId || PubModel.PubRecord.RecordTypeId == RecordTypeModel.PublicationAssignedToFPRCTypeId) {
                    pShowTerminateFprButton = ProfileModel.isAppearBusinessAdmin || 
                                                ProfileModel.isAppearFPRC || 
                                                ProfileModel.isAppearIntFPRC || 
                                                ProfileModel.isSysAdmin || 
                                                Test.isRunningTest();
                } else {
                    pShowTerminateFprButton = false;
                }           
            } 
            return pShowTerminateFprButton;
        }
    }
    
    private boolean pShowMaterialInit = false;
    private boolean pShowMaterialChangeButton;
    public boolean showMaterialChangeButton {
        get{
            if (!pShowMaterialInit) {
                if ( ProfileModel.isAppearWriting || ProfileModel.isAppearExternalWriter || ProfileModel.isAppearGPPL || ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC  || ProfileModel.isSysAdmin || Test.isRunningTest()) {
                    if (PubModel.PubRecord.RecordTypeId == RecordTypeModel.PublicationSubmitRecTypeId) {
                        
                        //R1.3 - check if there is no OPEN Material Change or NonMaterialChange in this Submission Cycle
                        if ( currSubCycleHasOpenChange ) {
                            pShowMaterialChangeButton = false;
                        } else {
                            pShowMaterialChangeButton = true;
                        }
                    }
                } else {
                    pShowMaterialChangeButton = false;
                }
                
                pShowMaterialInit = true;               
            } 
            return pShowMaterialChangeButton;
        }
    }
    
    public PageReference PubRejectedClick() {
        string errorMsg = AppearPubViewModel.RejectPublication(PubId);
        if (errorMsg != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, errorMsg));
            return null;
        }
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Publication has been successfully rejected. Please change/confirm new target for re-purposing the current publication.PLEASE NOTE: When re-purposing an "Abstract" after Rejection, user should always create a new publication record instead of using the same publication record.'));
        
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    public PageReference TerminateFprClick() {
        string errorMsg = AppearPubViewModel.TerminateFPRCycle(PubId);
        if (errorMsg != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, errorMsg));
            return null;
        }
        
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    public PageReference MaterialChangeClick() {
        string errorMsg = AppearPubViewModel.MaterialChangeForCongressJournal(PubId);
        if (errorMsg != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, errorMsg));
            return null;
        }
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    

    
    public PageReference MoveToGPPClick() {
          
        //Appear Enhancement R1:2017 - below if logic to check if pub classification is FPR Only, system should through error message to update pub classification.
        if(pubModel.pubRecord.GPP_Type__c == 'FPR Only'){
        	gppmessage = 'Please update the Publication Classification prior to adding the publication to the GPP.';
        	return null;
        }        
     gppmessage ='The following field(s) are required for a GPP Publication :';// Error Message changed as per Defect No-5 Appear Enhancement R2
        if(PubModel.PubRecord.SponsorDept_Pick__c== null){
            gppmessage= gppmessage + ' Sponsoring Amgen Department,';
        }
        if(PubModel.PubRecord.SponsorOrg_Pick__c == null){
            gppmessage= gppmessage + ' Sponsoring Organization,';
        }
        if(pubModel.pubRecord.RAE__c == null){
            gppmessage = gppmessage + ' Responsible Amgen Employee (RAE),' ;
        }
        if(PubModel.pubRecord.Country_pick__c == null){
            gppmessage = gppmessage + ' Country,';
        }
        //Appear Enhancement R3: GPP Type field validation Added Add to GPP button.
        //Commented below as part of Appear Enhancment R1:2017
        /*if(PubModel.pubRecord.GPP_Type__c == null){
        	gppmessage = gppmessage + ' Publication Classification,';
        }*/
        gppmessage = gppmessage.removeEnd(',');
                     
     if(PubModel.PubRecord.SponsorDept_Pick__c== null || PubModel.PubRecord.SponsorOrg_Pick__c == null || pubModel.pubRecord.RAE__c == null || 
        PubModel.pubRecord.Country_pick__c == null){ //Appear Enhancement R3: GPP Type field validation Added Add to GPP button. - GPP Type validation removed R1:2017
        return null;
     }else{
      withoutSharingUtil.MoveToGpp(PubModel.PubRecord);
     }
     
     return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }    
    
    public PageReference RemoveFromGPPClick() {
        withoutSharingUtil.RemoveFromGPP(PubModel.PubRecord);
        
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }   
    
    public static boolean CheckEditActualDate(PubStatus__c p ) {
        
        //from release 1.0 - user can edit the actual date of the Department Status & Global Status
        if ( p.Status__r.RecordType.Name != 'AutoInsert' ) {
            return true;
        }
        //from release 1.0
        if ( p.ActualDate__c == null) {
            return true;
        }
        
        //Def #538
        if ( p.Status__c ==  StatusModel.Rejected.id) { //'Rejected' 
            return true;
        }
        
        //Def #539
        if ( p.Status__c == StatusModel.MaterialChangesForCongressJournal.id ) { //'Material Changes for Congress/Journal'
            return true;
        }
        
        //Def #538
        if ( p.Status__c == StatusModel.Resent.id  ) {   //'Resent'
            return true;
        }
        
        return false;
    }
  

    
    public static String ToString(PubStatus__c pubStatus){
        string result = 'PubStatus[id='+pubStatus.id+' status='+pubStatus.Status__r.Name+
            ' SubCycle='+pubStatus.Submission_Cycle__r.Submission_Cycle_Num__c+
            ' FprCycle='+pubStatus.fpr_Cycle__r.FPR_Cycle_Num__c +
            ' ActualDate='+pubStatus.ActualDate__c+' ]';
        return result;
    }
    
    public List<SelectOption> statusList {
        get {
            List<SelectOption> result = new List<SelectOption>();
            for( Status__c status : StatusModel.StatusList) {
                result.add(new selectOption(status.id, status.name));
            }
            return result;
        }
    } 
        
    public string newAdminStatusId {get;set;}
    public integer newSubmissionCycleNum { get;set;}
    public integer newFprCycleNum { get; set;}
    

    // js remote functions defined in PubStatusNewViewModel

    //////////////////////////////////////////////////////////////////////////////

}