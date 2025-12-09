global with sharing class AppearPubModel extends AppearBaseModel {   
    private string ActiveTile;   
    private string ActiveSubMenu;  
    private boolean isFprSubmitter;
    
    /////////  SubModels  ////////////
    private PubHeaderDTO pPubHeader = null;
    public PubHeaderDTO PubHeader {
        get {
            if (pPubHeader == null){
                pPubHeader = new PubHeaderDTO(this);
            }
            return pPubHeader;
        }
    } 
    
    public Boolean hasErrors { get { return ApexPages.hasMessages(); } }
    
    private PubStatusModel pPubStatus = null; 
    public PubStatusModel PubStatus{
        get {
            if ( pPubStatus == null){ 
                pPubStatus = new PubStatusModel(PubId, this, ActiveTile, ActiveSubMenu);            
            }
            return pPubStatus;
        }
    }
    
    private PubStudyModel pPubStudy = null;
    public PubStudyModel PubStudy{
        get {
            if ( pPubStudy == null){
                pPubStudy = new PubStudyModel(PubId, ActiveTile, ActiveSubMenu, isFprSubmitter, hasEditAccess); 
            }
            return pPubStudy; 
        }
    }

    private PubTOVModel pPubTOV = null;
    public PubTOVModel PubTOV{
        get {
            if ( pPubTOV == null){
                pPubTOV = new PubTOVModel(PubId, this, ActiveTile, ActiveSubMenu, hasEditAccess); 
            }
            return pPubTOV; 
        }
    }
     
    
    private PubTeamMemberModel pPubTeamMember = null;
    public PubTeamMemberModel PubTeamMember{
        get {
            if ( pPubTeamMember == null){
                pPubTeamMember = new PubTeamMemberModel(PubId, ActiveTile, ActiveSubMenu, isFprSubmitter, this);
            }
            return pPubTeamMember; 
        }
    } 
     
    private PubPreFprReviewerModel pPreFprReviewer = null;
    public PubPreFprReviewerModel PreFprReviewer{
        get {
            if ( pPreFprReviewer == null){
                pPreFprReviewer = new PubPreFprReviewerModel(PubId, ActiveTile, ActiveSubMenu, isFprSubmitter);
            }
            return pPreFprReviewer; 
        }
    }
     
    private PubScientificStatementModel pPubScientificStatement = null;
    public PubScientificStatementModel PubScientificStatement{
        get {
            if ( pPubScientificStatement == null){ 
                List<ProductIndication__c> PubProdIndList = PubProdIndication.ProdIndListForPub;
                List<ProdIndiObjective__c> AllPubObjectives = ProdIndiObjectiveModel.FindObjectivesByProductIndication(PubProdIndList);
                pPubScientificStatement = new PubScientificStatementModel(PubId, ActiveTile, ActiveSubMenu, AllPubObjectives);
            }
            return pPubScientificStatement; 
        }
    }

    private ExecutionNotesModel pExecutionNotes = null;
    public ExecutionNotesModel ExecutionNotes{
        get {
            if ( pExecutionNotes == null){ 
                pExecutionNotes = new ExecutionNotesModel(PubId, ActiveTile, ActiveSubMenu, this);
            }
            return pExecutionNotes; 
        } 
    }
    
    private PubReviewTeamModel pPubReviewTeam = null;
    public PubReviewTeamModel PubReviewTeam{
        get {
            if ( pPubReviewTeam == null){ 
                pPubReviewTeam = new PubReviewTeamModel(PubId, this, ActiveTile, ActiveSubMenu);
            }
            return pPubReviewTeam;
        }  
    }
 
    private RelatedPubModel pRelatedPub = null;
    public RelatedPubModel RelatedPub{ 
        get {
            if ( pRelatedPub == null){
                pRelatedPub = new RelatedPubModel(PubId, ActiveTile, ActiveSubMenu);
            } 
            return pRelatedPub;
        }
    }
    
    //return the current Submission Cycle
    private SubmissionCycleModel pSubmissionCycle = null;
    public SubmissionCycleModel SubmissionCycle {
        get {
            if (pSubmissionCycle == null) {     
                pSubmissionCycle = new SubmissionCycleModel(PubId, PubStatus.CurrentPubStatus);
            }
            return pSubmissionCycle;
        }
    }

    //return a list of FprCycles for the current Pub
    private FprCycleModel pFprCycle = null;
    public FprCycleModel FprCycle { 
        get {
            if (pFprCycle == null) {
                pFprCycle = new FprCycleModel(PubId, PubStatus.CurrentPubStatus); 
            }
            return pFprCycle;
        }
    }
    
    private SubGroupModel pSubGroup = null;
    public SubGroupModel SubGroup {
        get {
            if (pSubGroup == null) {
                pSubGroup = new SubGroupModel(PubRecord.SubGroup__c);
            }
            return pSubGroup;
        }  
    }
    
    private PubMeModel pPubMe = null;
    public PubMeModel PubMe {
        get {
            if ( pPubMe == null){
                pPubMe = new PubMeModel(PubId, ActiveTile, ActiveSubMenu, pubRecord, 
                    SubmissionCycle.CurrentSubmissionCycle, FprCycle.CurrentFprCycle, PubStatus );
            }
            return pPubMe; 
        } 
    }
    
    private PubAuthorModel pPubAuthor = null;
    public PubAuthorModel PubAuthor { 
        get {
            if ( pPubAuthor == null){
                pPubAuthor = new PubAuthorModel(PubId, ActiveTile, ActiveSubMenu, pubRecord, isFprSubmitter);
            }
            return pPubAuthor;
        }
    }
    
    // Release 4.0
    private PubAuthorModelNoSharing pPubAuthorNoSharing = null;
    public PubAuthorModelNoSharing PubAuthorNoSharing { 
        get {
            if ( pPubAuthorNoSharing == null){
                pPubAuthorNoSharing = new PubAuthorModelNoSharing(PubId, ActiveSubMenu);
            }
            return pPubAuthorNoSharing;
        }
    }
       
    private PubProdIndModel pPubProdIndication = null;
    public PubProdIndModel PubProdIndication{
        get {
            if (pPubProdIndication == null){
                pPubProdIndication = new PubProdIndModel(PubId, ActiveTile, ActiveSubMenu, isFprSubmitter);
            }
            return pPubProdIndication;
        }
    }    
       
    private PubAttachmentModel pPubAttachments = null;
    public PubAttachmentModel PubAttachments{
        get {
            if (pPubAttachments == null){
                boolean isFprOnlyPendingSubmission = false;
                if ( CurrentStatus == StatusModel.FprOnlyStatus) {    //'Pending FPR Submission'
                    isFprOnlyPendingSubmission = true;
                }
                
                pPubAttachments = new PubAttachmentModel(PubId, ActiveTile, ActiveSubMenu, 
                    CurrentSubmissionCycleId, CurrentFprCycleId, isFprOnlyPendingSubmission);
                
            }
            return pPubAttachments;
        }
    }  
    
    
    private List<string> pPubProdIndNameList = null;
    public List<string> PubProdIndNameList {
        get {
            if (pPubProdIndNameList == null){ 
                pPubProdIndNameList = new List<string>();
                for(ProductIndication__c pi : PubProdIndication.ProdIndListForPub) {
                    pPubProdIndNameList.add(pi.name);
                }
            }
            return pPubProdIndNameList; 
        }
    }
    


    /////////  public members ////////////
    
    
    //salesforce id of the publication record
    public Id PubId { get; private set;} 
    
    
    public boolean hasValidPub {get;private set;}
    public boolean hasReadAccess {get;private set;}
    public boolean hasEditAccess {get;private set;}
    
    //The User Friendly pub name [ AKA Pub Id in Siebel ]
    public string PubName {
        get{
            if ( pubRecord == null){
                return 'Invalid Publication - please contact Support';
            } else {
                return pubRecord.Name;
            }
        }
    }
    
    public String PubTitle { 
        get {
            if ( pubRecord == null) {
                return 'Invalid Publication - please contact Support';
            } else {
                return pubRecord.Publication_Title__c;
            }
        }
    }
    
    public String PubClassification { 
        get {
            if ( pubRecord == null) {
                return 'Invalid Publication - please contact Support';
            } else {
                return pubRecord.Pub_Classification__c;
            }
        }
    }
    
    public String PubProductIndicationNotFound { 
        get {
            if ( pubRecord == null) {
                return 'Invalid Publication - please contact Support';
            } else {
                return pubRecord.Product_Indication_Not_Found__c;
            }
        }
    }
    public String PubType{
        get {
            if ( pubRecord == null) {
                return 'Invalid Publication - please contact Support';
            } else {
                AppLogModel.LogDebug('AppearPubModel::PubType', 'PubType is '+pubRecord.PubType__r.Name, PubId);
                return pubRecord.PubType__r.Name;
            }           
        }
    }
    public Id PubTypeId{
        get {
            if ( pubRecord == null) {
                return null;
            } else {
                return pubRecord.PubType__c;
            }           
        }
    }
    
    public boolean isEnbrel {
        get {
            return PubRecord != null ? PubRecord.IsEnbrel__c : false; 
        }
    }
    
    //UAT issue discovered on 2014/01/07
    //If GPPL rejected a new FPR Request, then when any Pub Team Member
    //open the pub, disable the Target, Product Indication & Submit button
    //
    //this boolean from Apex will allow JavaScript to disable buttons in the frontend.
    public boolean isPubTeamMemberOnRejectedPub {
        get {
            boolean result = false;
            if ( (ProfileModel.isAppearPubTeam || ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC || ProfileModel.isAppearWriting || ProfileModel.isAppearExternalWriter) && 
                    pubRecord.pubStatus__r.status__c == StatusModel.SuggestionRejected.id) {
                result = true;
            } 
            return result;
        }
    }
    
    public string isPubTeamMemberOnRejectedPubDisabled {
        get {
            if ( isPubTeamMemberOnRejectedPub) {
                return 'true';
            } else {
                return 'false';
            }           
        }

    }
    
    //return the name of an sObject to use in list detail view
    private string pListDetailObject = null;
    public String ListDetailObject{
        get {
            return pListDetailObject;
        }
    }

    private Publication__c pPubRecord = null;
    public Publication__c pubRecord {  
        get {
            if ( pPubRecord == null) {
                //log error
                AppLogModel.LogError('AppearPubModel::pubRecord', 'pPubRecord == null - cannot load a publication');
                //AppLogModel.flushLogs();
                return null;
            }
            //AppLogModel.addLog('Info', 'AppearPubModel::constructor', 'Loading PubId:'+PubId , '');
            return pPubRecord;
        }
        set {
            pPubRecord = value;
        }
    }

    public String CurrentStatus { 
        get {
            if ( pubRecord == null) {
                return 'Invalid Publication - please contact Support';
            } else {
                return pubRecord.pubStatus__r.Status__r.Name; 
            }           
        }
    }
    
    
    
    public String PubStage {
        get {
            if ( pubRecord == null) {
                return 'Invalid Publication - please contact Support';
            } else {
                return pubRecord.pubStatus__r.Status__r.Stage__c;
            }
        }
    }

    public Id CurrentSubmissionCycleId {
        get {
            return pubRecord.Current_SubmissionCycle_Id_Formula__c;
        }
    }
    
    public integer CurrentSubmissionCycleNum {
        get {            
            return integer.valueOf(pubRecord.Current_Submission_Cycle_Num__c);
        }
    } 
    
    public Boolean IsCommentsOnly {
        get { 
            if ( pubRecord == null) {
                AppLogModel.LogError('AppearPubModel::IsCommentsOnly', 'Invalid Publication - please contact Support');
                return false;
            } else {
                return pubRecord.IsComments_Only__c;
            }
        }
        set {
            if ( pubRecord == null) {
                AppLogModel.LogError('AppearPubModel::IsCommentsOnly', 'Invalid Publication - please contact Support');
            } else {
                pubRecord.IsComments_Only__c = value;
            }
        }
    }
    
    
    
    //Each submission cycle may have a different target
    //Current target will look at the Current submissionCycle and return the associated target
    private string pCurrentTarget = null;
    public string CurrentTarget {
        get {
            return SubmissionCycle.TargetLabel;
        }
    } 

    public Id CurrentFprCycleId {
        get {
            if (pubRecord == null || pubRecord.Current_FPRCycle_Id_Formula__c == null){
                return null;
            } else {
                return pubRecord.Current_FPRCycle_Id_Formula__c;
            }
        }
    }
   
    public integer CurrentFprCycleNum {
        get {
            if (pubRecord == null || pubRecord.Current_FPRCycle_Id_Formula__c == null){
                return 0;
            } else {
                return Integer.ValueOf(pubRecord.Current_FPR_Cycle_Num__c);
            }
        }
    }
    
    public String RecordTypeName {
        get {
            if (pubRecord <> NULL) {
                //RecordType recType = RecordTypeModel.LookupRecordTypeById('Pub__c',pubRecord.RecordTypeId);
                
                //return recType.Name;
                //return pubRecord.RecordType.Name;
                return pubRecord.RecordTypeId+' to be translated after prototype'; 
            } else {
                return 'Invalid publication record.';
            }
        }
    }
    
    public String Authors {
        get {
            if (pubRecord == null ){
                return '';
            } else {
                return pubRecord.Authors__c;
            }           
        }
    }
    
    public boolean Persist() {
        if ( pubRecord <> null){
            try {
                update pubRecord;               
            } catch ( Exception e){
                System.Debug('Exception caught during persist of AppearPubModel : '+e.getMessage());
                
                return false;   
            }
            return true;

        } else {
            //invalid PubRecord
            return false;
        }
    }
    
    //TargetMode = Journal / Meetings
    public PageReference saveTarget() {
        
        string msg = 'TargetMode = '+targetMode+' newTargetId = '+newTargetId;
        System.Debug('*** '+msg);
        AppLogModel.LogDebug('AppearPubModel::saveTarget', msg, PubId);

        String prevTarget=pubRecord.Current_Target__c; // Storing the previous target for R2
        AppLogModel.flushLogs();
        if (targetMode == null){
            AppLogModel.LogError('AppearPubModel::saveTarget', 'targetmode == null', PubId);
            AppLogModel.flushLogs();
            return null;            
        }
        
        if ( pubRecord <> null) {
            if (targetMode.toUpperCase().contains('JOURNAL')) {
                Journal__c journal = JournalModel.JournalMap.get(pNewTargetId);
                
                if ( journal <> Null){
                    pubRecord.Target_Type__c = 'Journal';
                    pubRecord.Journal__c = newTargetId;
                    pubRecord.Meeting__c = null;
                    pubRecord.Current_Target__C = journal.JournalName255__c;
                } else {
                    //add error
                }
                
                
            } else if (targetMode.toUpperCase().contains('MEETING')) {
                Meeting__c meeting = MeetingModel.MeetingMap.get(pNewTargetId);
                
                if( meeting  <> Null){
                    pubRecord.Target_Type__c = 'Meeting';
                    pubRecord.Meeting__c = newTargetId;
                    pubRecord.Journal__c = null;
                    pubRecord.Current_Target__C = Meeting.MeetingName255__c;             
                } else {
                    //add error
                }

            } else {
                pubRecord.Target_Type__c = 'unknown';
                AppLogModel.LogError('AppearPubModel::SaveTarget', 'Unknown target type : ' + targetMode.toUpperCase(), pubid);
            }
            
            //Def 296
            Id pubCurrentStatusId = pubRecord.pubStatus__r.Status__c;
            
            boolean validationRule1 = false;
            boolean validationRule2 = false;
            boolean validationRule3 = false;
            boolean validationRule4 = false;
            boolean validationRule5 = false;
            boolean validationRule6 = false;
            boolean validationRule7 = false; // implemented for R2 Enhancement
                        
            //validation rule 1 ==> Publication Status IS NOT "Cancelled" or "On Hold" or "Withdrawn From Target" or "Published/Presented" with ACTUAL DATES
            if (  !StatusSet_Cancelled_OnHold_WithDrawn.contains(pubCurrentStatusId ) )  {
                validationRule1 = true;
                 AppLogModel.LogInfo('AppearPubModel::SaveTarget', 'validation rule 1 passed', pubRecord.Id);
            }  
            
            //validation rule 2  ==> Publication Status has "Submitted/Completed" with ACTUAL DATE in currentSubmissionCycle
            if ( CurrentSubmissionCycleHasSubmittedCompletedWithActualDate ) {
                validationRule2 = true;
                AppLogModel.LogInfo('AppearPubModel::SaveTarget', 'validation rule 2 passed', pubRecord.Id);
            }
            
            //validation rule 3  ==> Publication Status has "Rejected" with ACTUAL DATE in currentSubmissionCycle
            if ( CurrentSubmissionCycleHasRejectedWithActualDate ) {
                validationRule3 = true;
                AppLogModel.LogInfo('AppearPubModel::SaveTarget', 'validation rule 3 passed', pubRecord.Id);
            }
            
            //validation rule 4 Def #540 ==> do not create a new submission cycle for Abstract Publication
            if (PubTypeNotEqualAbstract) {
                validationRule4 = true;
                AppLogModel.LogInfo('AppearPubModel::SaveTarget', 'validation rule 4 passed', pubRecord.Id);
            }
            
            // Validation rule 5 - CCB 258 
            if (CurrentSubmissionCycleHasMaterialChangeforSubsequentSubmissionStatusWithActualDate && CurrentSubmissionCycleHasTargetValuePopulated ){
                validationRule5 = true;
                AppLogModel.LogInfo('AppearPubModel::SaveTarget', 'validation rule 5 passed', pubRecord.Id);
            }

            // Validation rule 6 - CCB 258 
            if (CurrentSubmissionCycleHasNonMaterialChangeforSubsequentSubmissionStatusWithActualDate){
                validationRule6 = true;
                AppLogModel.LogInfo('AppearPubModel::SaveTarget', 'validation rule 6 passed', pubRecord.Id);
            }
            
            //Validation rule 7 - Appear Enhancement R2. Restricting increment of FPR Cycle
            if(prevTarget==pubrecord.Current_Target__c){
                system.debug('******Validation Rule 7 passed');
                validationRule7 = true;
            }
           
            if(validationRule7){             
                 return null;
            }
            
            if ((validationRule1 && validationRule2 && validationRule3 && validationRule4) || 
                    (validationRule4 && validationRule5) || (validationRule4 && validationRule6) ) //CC 258:  Validation Required (SESHA)
            {
                //increase SC / FC
                
                integer nextSubmissionCycleNum = CurrentSubmissionCycleNum + 1; 
                if (validationRule5 || validationRule6) { //CCB 258:If any of these rules are true, please keep the nextSubmissionCycleNum as the same and don't increment because it has already been incremented (SESHA)
                     nextSubmissionCycleNum = CurrentSubmissionCycleNum; 
                }              
                SubmissionCycle__c nextSubCycle = SubmissionCycle.getSubmissionCycleByNum(nextSubmissionCycleNum);
                nextSubCycle.Target_Type__c =  pubRecord.Target_Type__c;
                nextSubCycle.Journal__c =  pubRecord.Journal__c;
                nextSubCycle.Meeting__c = pubRecord.Meeting__c;
                update  nextSubCycle;
                
                //Def 271 - increment FprCycleNum after Reject
                integer nextFprCycleNum = CurrentFprCycleNum + 1;
               // (SESHA) CCB 258:For a "Non-Material Change for New Target", FPR Cycle needs to be the SAME OLD value even in new Submission Cycle.
               // This IF logic is VERY VERY crucial and impacts lots of system areas/workflows:
               //       1. PubStatus
               //       2. PubME
               //       3. PubAttachments
               //       4. PubReviewTeam
                if (validationRule6) { //I FIXED ALL THE WORKFLOWS TO SUPPORT THIS FEATURE. JUST UNCOMMENT THIS IF CONDITION AND CCB 258 WILL WORK FINE - (SESHA) 
                  nextFprCycleNum = CurrentFprCycleNum;
                }
                FPR_Cycle__c nextFprCycle = FprCycle.getFprCycleByNum(nextFprCycleNum);
                
                if (validationRule6) { //CCB 258:For a "Non-Material Change for New Target", Draft Actual Date needs to NULL for the new Submission Cycle (SESHA)
                     PubStatus.InsertDraftWithActualDate(nextSubCycle.id, nextFprCycle.id, false); 
                } else {             
                     PubStatus.InsertDraftWithActualDate(nextSubCycle.id, nextFprCycle.id, true);
                }
                
                //Def#686.S1 - modified InsertGlobalStatusReviewSubmit to NOT create the Accepted / Submitted status
                PubStatus.InsertGlobalStatusReviewSubmit(nextSubCycle.id, nextFprCycle.id);
                //
                //PubStatus.InsertPublishedPresented(nextSubCycle.id, nextFprCycle.id);  
                //Def#686.1 - new code CreateOrMovePubStatus
                //def#805 - adhoc inserts and only/always move status to current sc, fc when either increments for the pub
                PubStatus.MovePubStatusToCurrentFCandSC(statusModel.ResetFprCycleStatusList, nextSubCycle.id, nextFprCycle.id, true);  
                
                //Always need a SubmittedCompleted since PubME links to it
                PubStatus.InsertSubmitCompleted(nextSubCycle.id, nextFprCycle.id);      
                PubStatus.InsertApprovedByAllAuthors(nextSubCycle.id, nextFprCycle.id); //SC-specific approved by all authors
                                
                //look for Submitted/Completed status for last Subcycle
                id lastSubcycleSubmittedCompletedStatusid = PubStatus.findSubmittedCompletedStatusId(nextSubCycle.Id);
                PubMe.copyMEforNewSubmissionCycle(nextSubCycle, nextFprCycle, lastSubcycleSubmittedCompletedStatusid);

            }  else if(validationRule3 && !validationRule4) {
                //Do Nothing if the Publication has a Rejected Status with Actual Date and it is an Abstract
            } else {
                //if we are not creating a new SC 
                //then the target update applies to the current SC 
                update pubRecord;  
             
                //update current submission cycle target now.
                submissionCycle.CurrentSubmissionCycle.Target_Type__c =pubRecord.Target_Type__c;
                submissionCycle.CurrentSubmissionCycle.Journal__c =pubRecord.Journal__c;
                submissionCycle.CurrentSubmissionCycle.Meeting__c = pubRecord.Meeting__c;
                
                update submissionCycle.CurrentSubmissionCycle;
                submissionCycle.reloadCurrentSubmissionCycle();             
            }
            
            PublicationTriggerLogic.UpdateLatestPubStatusById(pubRecord.id, true);
            //pPubRecord = null;  //make sure nothing can use this stale PubRecord Ref - It could be updated in  PublicationTriggerLogic.UpdateLatestPubStatusById
 
        } else {
            AppLogModel.LogError('AppearPubModel::saveTarget', 'pubRecord == null ');
        }
        AppLogModel.flushLogs();
        
        return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    
    // def #540 - do not create new SC for Abstract
    private boolean PubTypeNotEqualAbstract {
        get {
            boolean result = false;
            if (pubRecord <> null && pubRecord.PubType__r.name <> 'Abstract')   {
                result = true;
            }
            return result;
        }
    }
    
    
    private boolean CurrentSubmissionCycleHasRejectedWithActualDate {
        get {
            boolean result = false;
            for(PubStatus__c pubStatusRec : PubStatus.PubStatusList) {
                if ( pubStatusRec.Submission_Cycle__c == CurrentSubmissionCycleId 
                    && pubStatusRec.Status__c == StatusModel.Rejected.id   ) {
                    result = true;
                }
            }
            
            return result;
        }
    }
    
    //CCB 258
    public boolean CurrentSubmissionCycleHasMaterialChangeforSubsequentSubmissionStatusWithActualDate {
        get {
            boolean result = false;
            boolean isRejectedStatusPresentForSameSC = false;
            boolean isMaterialChangeforSubsequentSubmissionPresentForSameSC = false;
             
            for(PubStatus__c pubStatusRec : PubStatus.PubStatusList) {
                if ( pubStatusRec.Submission_Cycle__c == CurrentSubmissionCycleId 
                    && pubStatusRec.Status__c == StatusModel.MaterialChangeforSubsequentSubmission.id  
                    && pubStatusRec.ActualDate__c <> null 
                    && pubStatusRec.IsLogicallyDeleted__c == false 
                    ) {
                    isMaterialChangeforSubsequentSubmissionPresentForSameSC = true;
                }
            }
            
            for(PubStatus__c pubStatusRec : PubStatus.PubStatusList) {
                if ( pubStatusRec.Submission_Cycle__c == CurrentSubmissionCycleId 
                    && pubStatusRec.Status__c == StatusModel.Rejected.id  
                    && pubStatusRec.ActualDate__c <> null 
                    && pubStatusRec.IsLogicallyDeleted__c == false ) {
                    isRejectedStatusPresentForSameSC = true;
                }
            }
            
            if(isMaterialChangeforSubsequentSubmissionPresentForSameSC && !isRejectedStatusPresentForSameSC) {
                result = true;
            }
            return result;
        }
    }  
    
    //Appear Enhancement R2: Added for restricting simultaneious target update
    public boolean CurrentSubmissionCycleHasTargetValuePopulated {
        get {
            boolean result = false;
            boolean isRejectedStatusPresentForSameSC = false;
            boolean isMaterialChangeforSubsequentSubmissionPresentForSameSC = false;
            System.debug('CurrentSubmissionCycleHasMaterialChangeforSubsequentSubmission()--->'); 
            for(PubStatus__c pubStatusRec : PubStatus.PubStatusList) {
                if ( pubStatusRec.Submission_Cycle__c == CurrentSubmissionCycleId 
                    && pubStatusRec.Status__c == StatusModel.MaterialChangeforSubsequentSubmission.id  
                    && pubStatusRec.ActualDate__c <> null 
                    && pubStatusRec.IsLogicallyDeleted__c == false 
                    && pubStatusRec.Submission_Cycle__r.TargetLabelFormula__c == null
                    ) {//Condition is for Restricting simultanious FPR Cycle Update ""
                    isMaterialChangeforSubsequentSubmissionPresentForSameSC = true;
                }
            }
            
            for(PubStatus__c pubStatusRec : PubStatus.PubStatusList) {
                if ( pubStatusRec.Submission_Cycle__c == CurrentSubmissionCycleId 
                    && pubStatusRec.Status__c == StatusModel.Rejected.id  
                    && pubStatusRec.ActualDate__c <> null 
                    && pubStatusRec.IsLogicallyDeleted__c == false ) {
                    isRejectedStatusPresentForSameSC = true;
                }
            }
            
            System.debug('isMaterialChangeforSubsequentSubmissionPresentForSameSC##--->'+isMaterialChangeforSubsequentSubmissionPresentForSameSC+'----'+isRejectedStatusPresentForSameSC); 
            
            if(isMaterialChangeforSubsequentSubmissionPresentForSameSC && !isRejectedStatusPresentForSameSC) {
                result = true;
            }
            return result;
        }
    }  

    //CCB 258
    public boolean CurrentSubmissionCycleHasNonMaterialChangeforSubsequentSubmissionStatusWithActualDate {
        get {
            boolean result = false;
            boolean isRejectedStatusPresentForSameSC = false;
            boolean isNonMaterialChangeforSubsequentSubmissionPresentForSameSC = false;
            
            for(PubStatus__c pubStatusRec : PubStatus.PubStatusList) {
                if ( pubStatusRec.Submission_Cycle__c == CurrentSubmissionCycleId 
                    && pubStatusRec.Status__c == StatusModel.NonMaterialChangeforSubsequentSubmission.id  
                    && pubStatusRec.ActualDate__c <> null 
                    && pubStatusRec.IsLogicallyDeleted__c == false ) {
                    isNonMaterialChangeforSubsequentSubmissionPresentForSameSC = true;
                }
            }            

            for(PubStatus__c pubStatusRec : PubStatus.PubStatusList) {
                if ( pubStatusRec.Submission_Cycle__c == CurrentSubmissionCycleId 
                    && pubStatusRec.Status__c == StatusModel.Rejected.id  
                    && pubStatusRec.ActualDate__c <> null 
                    && pubStatusRec.IsLogicallyDeleted__c == false ) {
                    isRejectedStatusPresentForSameSC = true;
                }
            }
            
            if(isNonMaterialChangeforSubsequentSubmissionPresentForSameSC && !isRejectedStatusPresentForSameSC) {
                result = true;
            }
            return result;
        }
    }    
        
    private boolean CurrentSubmissionCycleHasSubmittedCompletedWithActualDate {
        get {
            boolean result = false;
            for(PubStatus__c pubStatusRec : PubStatus.PubStatusList) {
                if ( pubStatusRec.Submission_Cycle__c == CurrentSubmissionCycleId 
                    && pubStatusRec.Status__c == StatusModel.SubmittedCompleted.id   ) {
                    result = true;
                }
            }
            
            return result;
        }
    }
    
    private Set<id> StatusSet_Cancelled_OnHold_WithDrawn {
        get {
            Set<id> result = new Set<id>();
            result.add(statusModel.Cancelled.id);
            result.add(statusModel.OnHold.id);
            result.add(statusModel.WithDrawn.id);
            result.add(statusModel.PublishedPresented.id);
            return result;
        }
    }
    
    
    private string pTargetMode = null;
    public String targetMode {
        get {
            if (pTargetMode == null && pubRecord <> null) {
                if ( pubRecord.Target_Type__c == 'Journal') {
                    pTargetMode = 'journal';
                } else if ( pubRecord.Target_Type__c == 'Meeting') {
                    pTargetMode = 'meeting';
                } 
            } 
            return pTargetMode;
        }
        set {
            pTargetMode = value;
        }
    }
    
    private Id pNewTargetId = null;
    public Id newTargetId {
        get {
            if (pNewTargetId == null && pubRecord <> null) {
                if ( targetMode == 'journal') {
                    pNewTargetId = PubRecord.journal__c;                
                } else if ( targetMode == 'meeting') {
                    pNewTargetId = PubRecord.meeting__c;        
                } 
            }  
            return pNewTargetId;
        }
        set {
            pNewTargetId = value;
        }
    }
    
    public boolean AllowReviewTeamEdit {
        get {
            return ProfileModel.AllowReviewTeamEdit;
        }
    }
    
    private transient List<Publication__c> pMyFPRCPubList = null;
    public List<Publication__c> MyFPRCPubList {
        get {
            if ( pMyFPRCPubList == null) {
                if (ProfileModel.showFPRCPubList) {
                    Id userId = UserInfo.getUserId();
                    pMyFPRCPubList = findMyFPRCPubList(userId);
                } else {
                    return new List<Publication__c>();
                }
            }
            return pMyFPRCPubList;
        }
    } 
    
    private transient List<Publication__c> pAllFPRCPubList = null;
    public List<Publication__c> AllFPRCPubList {
        get {
            if ( pAllFPRCPubList == null){
                if (ProfileModel.showFPRCPubList) {
                    pAllFPRCPubList = findAllFPRCPubList();
                } else {
                    return new List<Publication__c>();
                }
            }
            return pAllFPRCPubList;
        }
    }
    
    private string pFprDetailURL = null;
    public String FprDetailUrl {
        get {
            if ( pFprDetailURL == null){
                pFprDetailURL = AppearUrlModel.AppearFprMenuUrl(ActiveSubMenu, AppearConstants.FprDetailsTile, '');
            }
            return pFprDetailURL;
        }
    }
    
    private string pCurrentRoutePattern = null;
    public string CurrentRoutePattern {
        get {
            if ( pCurrentRoutePattern == null) {
                pCurrentRoutePattern = pubRecord.DataSourceFormulaField__c + ' : ' +
                    pubRecord.SubGroup__r.name + ' : ' + pubRecord.Product_Indication__c;
            }
            return pCurrentRoutePattern;
        }
    }

    public PageReference FPRCAssignToMe() {
        AppLogModel.LogDebug('AppearPubModel::FPRCAssignToMe', 
                'invoking FPRCAssignToMe by ' + UserInfo.getUserName(), PubId);    
        
        //Profile of BusinessAdmin / SystemAdmin & AppearFPRC can assign
        if (ProfileModel.ModifyFPRCPubList) {

            integer selectedCount = 0;
            for(Publication__c pub : AllFPRCPubList) {
                if ( pub.isSelected__c) {                                       
                    selectedCount++;              
                }
            } 
            
            if(selectedCount > 10 ) {  //each pub will create an email - make to make sure we dont exceed the email governor limit 
                string errorMsg = 'You can only select upto 10 Publications to assign at a time.  Please try again with less selection';
                AppLogModel.LogError('AppearPubModel::FPRCAssignToMe', errorMsg, PubId);
                AppearAddErrorMessage(errorMsg);
                return null;            
            }


            Set<id> AppearUserIds = AppearContactModel.findContactForAppearUser(UserInfo.getUserId());
            
            if (AppearUserIds.size() <> 1) {
                string errorMsg = 'FPRC Assign To Me operation Cancelled. Cannot locate link from Contact Record to User Record for '+UserInfo.getName();
                AppLogModel.LogError('AppearPubModel::FPRCAssignToMe', errorMsg, PubId);
                AppearAddErrorMessage(errorMsg);
                return null;
            }           
            
            List<id> AppearUserIdList = new List<id>();
            AppearUserIdList.addAll(AppearUserIds);
            id myContactId = AppearUserIdList[0];
        
            for(Publication__c pub : AllFPRCPubList) {
                if ( pub.isSelected__c) {                                       
                    PubStatusModel.insertAssignToFPRC(pub.id);                  
                }
            } 
            
            List<Publication__c> pubToUpdateList = new List<Publication__c>();
            for(Publication__c pub : AllFPRCPubList) {
                if ( pub.isSelected__c) {
                    AppearPubModel fprcPub = New AppearPubModel(pub.id);
                    
                    fprcPub.pubrecord.Assigned_FPRC__c = myContactId;
                    fprcPub.pubrecord.IsSelected__c = false; 
                    
                    //Def 16, 17 - change owner of pub to GPPL - or the person accepting this pub record
                    fprcPub.pubrecord.OwnerId = UserInfo.getUserId();
                    pubToUpdateList.add(fprcPub.pubRecord);
                }
            }   
            update pubToUpdateList;  //bulkify update
            
            for(Publication__c updatedPub : pubToUpdateList) {
                //send an email for each pub assigned.
                Email_01_FprcConfirmationForSubmitter email = new Email_01_FprcConfirmationForSubmitter(updatedPub);
                email.sendEmail();
            }
            
            AppLogModel.LogDebug('AppearPubModel::FPRCAssignToMe', 
                'updating  FPRCAssign for the following pub(s) :  ' + pubToUpdateList, PubId); 
            pAllFPRCPubList = null;
            pMyFPRCPubList = null;
        } else {
            AppLogModel.LogError('AppearPubModel::FPRCAssignToMe', 
                'Current User is not allowed to modify FPRC Publication list ' + UserInfo.getUserName(), PubId);
        }
    
        AppLogModel.flushLogs();
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));        
    }
    
    private transient Publication__c pNewFprOnlyPublication;
    public Publication__c NewFprOnlyPublication {
        get {
            if (pNewFprOnlyPublication == null) {
                pNewFprOnlyPublication = new Publication__c();
                //pNewFprOnlyPublication.isFPR__c = true; //do not set isFPR__c until they have pressed submit to fpr button       
                pNewFprOnlyPublication.HasFPROnlyStatus__c = true;
                pNewFprOnlyPublication.ScopeOfWork__c = MEScopeOfWorkModel.NotAvailScope;
            }
            
            return pNewFprOnlyPublication;
        }
    }
    
    public PageReference SaveNewFprOnlyPublication() {
        AppLogModel.LogDebug('AppearPubModel::SaveNewFprOnlyPublication', 'Start', PubId);
        // Appear Enhancement R1:2017 :: starts
        if (AppearPubViewModel.isMTA == 'Yes' ){
            pNewFprOnlyPublication.is_MTA__c = true;
        } 
        if(AppearPubViewModel.isSPFull =='Yes'){
            pNewFprOnlyPublication.SP_Full__c = true;
        }
        if(AppearPubViewModel.isISS == 'Yes'){
            pNewFprOnlyPublication.isISS__c = true;
        }
        if(AppearPubViewModel.courtesyReview == 'Yes' ){
            pNewFprOnlyPublication.IsComments_Only__c = true;
        }
        if(AppearPubViewModel.sopException == 'Yes'){
            pNewFprOnlyPublication.SOP_Exception__c = true;
        }
        if(AppearPubViewModel.noProdPolicy == 'Yes'){
            pNewFprOnlyPublication.Not_Product_Policy__c = true;
        }
        // Appear Enhancement R1:2017 :: ends
        if (pNewFprOnlyPublication.Publication_Title__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Publication Title is a required field'));
            return null;
        }
        pNewFprOnlyPublication.GPP_Type__c = 'FPR Only'; //Appear Enhancement R1:2017 - FPR only Publication classification will be defaulted to FPR only
        try {
            insert pNewFprOnlyPublication;
        } catch(DMLException ex){
            ApexPages.addMessages(ex);
            return null;
        }
        
        //Def 281 - for FPR Only Publication - insert the Submitter as a member of the PreFPR Review Team
        PubPreFprReviewerModel.InsertFprSubmitter(pNewFprOnlyPublication.Id, UserInfo.getUserId());
        
        // Appear Enhancement R1:2017 :: starts
        System.debug('Check the parameter value :: Answer Record Id' + ansRecIdVal  + pNewFprOnlyPublication.Id);
        updateAnsPubRelate(pNewFprOnlyPublication.Id);
        // Appear Enhancement R1:2017 :: ends
        
        AppLogModel.flushLogs(); 
        return new PageReference(AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, AppearConstants.FprDetailsTile, pNewFprOnlyPublication.Id));
    }
     
    // Appear Enhancement R1:2017 :: starts
    public static Id ansRecIdVal{get; set;}
    public void updateAnsPubRelate(Id pubId){
        FPR_Only_Answers__c ansObjList = [SELECT Id,ansPublication__c FROM FPR_Only_Answers__c WHERE id=:ansRecIdVal];
        System.debug('List 2 update'+ansObjList);
        ansObjList.ansPublication__c = pubId;
        try{
            update ansObjList;
        }
            
        catch(Exception ex){
            ApexPages.addMessages(ex);            
        }
        
    }

    public PageReference closeQuestionModal(){
        
        System.debug('closeQuestionModal' + ActiveSubMenu + AppearConstants.FprDetailsTile + PubId);
        return new PageReference(ProfileModel.isAppearFprOnlySubmitter ? '/PortalFprSubmitterLanding' : AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, AppearConstants.FprMyRequests, PubId)) ;
     }
    
    
   // Appear Enhancement R1:2017 :: ends
    
    public PageReference FprOnlySubmitPub() { 
        AppLogModel.LogDebug('AppearPubModel::FprOnlySubmitPub','Started', PubId);
        
        AppearPubViewModel.SubmitForFPR(PubId);
        
        AppLogModel.flushLogs();
        return new PageReference(AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, AppearConstants.FprDetailsTile, pNewFprOnlyPublication.Id));
    }
    
    

    
    /////////  constructor  /////////////////
    public AppearPubModel(Id PubId){
        this(PubId,null,null);
    }  

    public AppearPubModel ( Id PubId, string tile, string subMenu) {    
        this(PubId,tile,subMenu, false);  
    }

 
    //isFprSubmitter - AppearFprSubmitController will set FprSubmitter 
    public AppearPubModel ( Id PubId, string tile, string subMenu, boolean isFprSubmitter) {
        super();
        hasValidPub = false;
        this.PubId = PubId; 
 
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;
        this.isFprSubmitter = isFprSubmitter;
                 
        //Check for read / write access to pub
        //DID NOT Use Lazy load intentionally
        hasReadAccess = CheckUserAccessModel.CheckReadAccess(PubId);
        hasEditAccess = CheckUserAccessModel.CheckEditAccess(PubId);
        //Defect 662 - Added Data source and subgroup for publication data selection (2nd line)
        //Defect 701 - Added isTracking, Country, PresentationType, RAE  (3rd line)
        //CC 148 - Added Sponsored Date
        List<Publication__c> pubs = [ 
            Select p.Target_Type__c, p.Target_Submission_Date__c, p.SystemModstamp,p.isPlanning__c,
            p.Data_Source__c,p.SubGroup_pick__c, p.HasUSAuthors__c,
            p.Is_Tracking_Only__c, p.Country_Pick__c, p.Presentation_Type__c, p.RAE__c,
            p.Search_Identifier__c, p.RecordTypeId, p.isExecution__c, p.Primary__c,
            p.SponsoringDept__c, p.SponsoringDept__r.name,p.SponsoringOrg__c, p.SponsoringOrg__r.name,
            p.Region_FormulaField__c,  p.Current_Target__c,
            p.Publication_Type__c, p.Publication_Title__c,  p.Priority__c, 
            p.PST_Approval_Submission_Date__c, p.OwnerId, p.Organization__c, p.NoGlobalStatus__c, p.Name, 
            p.Meeting__c, p.MTA__c, p.Link_to_Final_Publication__c, p.LastModifiedDate, p.LastModifiedById, 
            p.Journal__c, p.IsDeleted, p.Id, p.FPR_Due_Date__c, p.Department__c, 
            p.CreatedDate, p.CreatedById, p.Category__c, p.Authors__c, 
            p.Authors_Not_Found__c, p.PlannedME__c,
            p.PubStatus__c, p.PubStatus__r.name,p.PubStatus__r.actualDate__c,p.PubStatus__r.target__c, 
            p.PubStatus__r.Status__c, p.PubStatus__r.Status__r.Name, p.PubStatus__r.Status__r.displayOrder__c,
            p.PubStatus__r.Status__r.stage__c, p.Route_Pattern__c,p.Sponsored_Date__c,
            p.Pub_Classification__c,p.Product_Indication_Not_Found__c,p.FPR_Submitter__r.name,
            p.Product_Indication__c, p.isFPR__c, p.isFPROnly__c, p.hasFPROnlyStatus__c, p.FPR_Submitter__c, p.IsEnbrel__c,
            p.PubType__c, p.PubType__r.name,  p.PubType__r.DefaultTargetType__c, SubGroup__c,
            p.ScopeOfWork__c, p.ScopeOfWork__r.name, p.ScopeOfWork__r.Scaling_Factor__c,
            p.Assigned_FPRC__c,p.Add_Meeting_Journal__c,p.IsBiosimilars__c,p.Partner__c,p.Comments_For_Coordinator__c,
            p.DataSourceFormulaField__c,p.IsComments_Only__c,p.isISStext__c,p.Comments_For_Approvers__c,p.isISS__c, 
            p.Country__c,p.Country__r.Name,p.Subgroup__r.Name,p.Assigned_FPRC__r.Name,
            p.Current_Status_FormulaField__c, Current_Status_Date_FormulaField__c, Current_Status_Id_FormulaField__c,
            p.Current_Submission_Cycle_Num__c, Current_SubmissionCycle_Id_Formula__c,
            p.Current_FPR_Cycle_Num__c, p.Current_FPR_Cycle_Sort_Num__c, Current_FPRCycle_Id_Formula__c, SiebelRowId__c,
            p.Legacy_Authors__c, p.TA__c, p.Execution_Notes__c, p.Execution_Notes_Last_Mod__c, p.PreFPRReviewers_Not_Found__c,p.Project_Ids__c,
            p.CommentsByAuthors__c, p.CommentsForAllAuthors__c, SponsorOrg_Pick__c, SponsorDept_Pick__c,p.is_MTA__c, //Appear Enhancement R2
            p.GPP_Type__c, // Appear Enhancement R3
            p.SP_Full__c,p.SOP_Exception__c,Not_Product_Policy__c //Appear Enhancement R1:2017
            From Publication__c p
            where Id = :PubId 
        ];
            
        if (pubs.size() == 0) {
            // you dont have access to this Pub
            PubId = null;
            hasValidPub = false;
            // log this event
            string msg = 'AppearPubModel::constructor - cannot load PubId = '+PubId+' please check if user has access';
            System.Debug(msg);
            AppLogModel.LogInfo('AppearPubModel::constructor', msg, pubId);
        } else {
            // At this point, we have 1 and only 1 Pub__c record
            // setup member & submodels
            pPubRecord = pubs[0];
            
            string targetMode = pubRecord.PubType__r.DefaultTargetType__c;
            
            
            if ( targetMode == null){
                this.targetMode = 'meeting';
            } else {
                this.targetMode = targetMode.toLowerCase();
            }
            
            //Data quality check
            
            //A pub must have a Current PubStatus
            if ( CurrentStatus == null ) {
                AppLogModel.LogError('AppearPubModel::Data Quality Check', 'MissingCurrent Status. '+ PubName + ' : '+ PubTitle, pubId);
            }
            
            //A pub must have a Submission Cycle
            if ( CurrentSubmissionCycleId == null ) {
                AppLogModel.LogError('AppearPubModel::Data Quality Check', 'Does not have a Submission Cycle'+ PubName + ' : '+ PubTitle, pubId);
            }
                        
            //If a pub is Assigned to FPRC - then it must have a FPR Cycle
            if ( CurrentSubmissionCycleNum > 1 && CurrentFprCycleId == null ) {
                AppLogModel.LogError('AppearPubModel::Data Quality Check', 'Missing a valid FPR Cycle. '+ PubName + ' : '+ PubTitle, pubId);
            }
            if ( (CurrentSubmissionCycleNum == 0)  && (pubRecord.PubStatus__r.status__r.displayOrder__c >= StatusModel.InFpr.displayOrder__c)  && ( CurrentFprCycleId == null)  ) {
                AppLogModel.LogError('AppearPubModel::Data Quality Check', 'Past IN FPR but missing a valid FPR Cycle. '+ PubName + ' : '+ PubTitle, pubId);
            }            
            
            hasValidPub = true;
            
        }
    }
    
    public boolean isSystemAdmin{
        get {
            return ProfileModel.isSysAdmin;
        }
    }
    
    public FPR_Cycle__c IncrFprCycle() {
        FPR_Cycle__c newFprCycle = null;
        if ( CurrentFprCycleNum == 0) {
            newFprCycle = FprCycle.getFprCycleByNum(1);
        } else {
            newFprCycle = FprCycle.getFprCycleByNum(CurrentFprCycleNum+1);
        }
        
        return newFprCycle;
    }
    

    public SubmissionCycle__c IncrSubmissionCycle() {
        SubmissionCycle__c newSubmissionCycle = null;
        if ( pubRecord.pubstatus__c == null) {
            newSubmissionCycle = SubmissionCycle.getSubmissionCycleByNum(1);
        } else {
            newSubmissionCycle = SubmissionCycle.getSubmissionCycleByNum(CurrentSubmissionCycleNum+1);
        }
        
        return newSubmissionCycle;
    }
    

    
    /////////  private functions ////////////
    
    private void debug() {
        System.Debug('\r\n\r\n************');
        System.Debug('for PubId '+PubId+ ' title = '+ PubTitle);
        System.Debug('\r\n\r\n************');
    }
     
    
    /////////  static functions /////////////
    
    public static List<Publication__c> findAllFPRCPubList() {
        
        Set<id> InFprcStatusIdSet = StatusModel.InFprcStatusIdSet; 
        Id AssignedToFprcId = StatusModel.AssignedToFPRC.Id; 
        //CC 148 Added Sponsored Date and Submitter
        List<Publication__c> FprcPubList = [
            select id, name, Publication_Title__c, PubStatus__r.Status__r.name, 
                Assigned_FPRC__c, Assigned_FPRC__r.name, isSelected__c, 
                FPR_Due_Date__c, Current_status_formulaField__c, Fpr_Submitter__c, 
                FPR_Submitter__r.name, Sponsored_Date__c,GPP_Type__c // Added GPP Type - Appear Enhancment R1:2017
            from Publication__c
            where pubStatus__r.status__c in :InFprcStatusIdSet
            order by FPR_Due_Date__c, Assigned_FPRC__c, PubStatus__r.Status__r.displayOrder__c
        ]; 
        
        //Defect #359
        //show Assign To = blank first
        //then sort the rest of list by displayOrder
        List<Publication__c> FprcPubList359SortOrder = new List<Publication__c> ();
        List<Publication__c> AssignedToNull = new List<Publication__c> ();
        List<Publication__c> FprDueDateNull = new List<Publication__c> ();
        List<Publication__c> leftOver = new List<Publication__c> ();
        List<Publication__c> leftOver2 = new List<Publication__c> ();

        //pick all AssignedTo == blank
        for (Publication__c pub : FprcPubList ) {
            if (pub.Assigned_FPRC__c == null) {
                AssignedToNull.add(pub);
            } else {
                leftOver.add(pub);
            }
        }  
        
        //pick all FPR Due Date == blank - should not happen - but just in case
        for (Publication__c pub : leftOver ) {
            if (pub.FPR_Due_Date__c == null) {
                FprDueDateNull.add(pub);
            } else {
                leftOver2.add(pub);
            }
        }
        
        //add in the rest based on sorting order    
        FprcPubList359SortOrder.addAll(AssignedToNull);
        FprcPubList359SortOrder.addAll(leftOver2);
        FprcPubList359SortOrder.addAll(FprDueDateNull);
        
        return FprcPubList359SortOrder;
    }
        
    public static List<Publication__c> findMyFPRCPubList(Id userId) {       
        Set<id> AppearUserIdSet = AppearContactModel.findContactForAppearUser(userId);
         
        List<Publication__c> FprcPubList = null;
        if (AppearUserIdSet.size() == 0){
            FprcPubList = new List<Publication__c>();
        } else {
            set<id> statusesToInclude = new set<id>();
            statusesToInclude.add(StatusModel.AssignedToFPRC.Id);
            statusesToInclude.add(StatusModel.Routed.Id);
            //As per Change Request #179, removed FPR Withheld/Withheld from the My Assigned Publications
            //statusesToInclude.add(StatusModel.Withheld.Id);
            //statusesToInclude.add(StatusModel.FprWithHeld.Id);
            //CC 148 Added Sponsored Date and name of FPR Submitter    
            FprcPubList = [
                select id, name, Publication_Title__c,  Assigned_FPRC__c, Assigned_FPRC__r.name, isSelected__c, FPR_Due_Date__c, Current_status_formulaField__c, Fpr_Submitter__c, Sponsored_Date__c, FPR_Submitter__r.name
                ,GPP_Type__c // Added GPP Type - Appear Enhancment R1:2017
                from Publication__c
                where Assigned_FPRC__c IN :AppearUserIdSet
                and pubStatus__r.status__c IN :statusesToInclude
            ]; 
        }
        AppLogModel.flushLogs();
        return FprcPubList;
    }
        
    
    //return null if no duplicates
    public static CreatePubResult checkForDup(string PubTitle, Id PubTypeId){
        boolean foundError = false;
        string errorMsg = '';
        if ( pubTitle == null){
            errorMsg += 'Cannot Create Pub without a Title.\r\n';   
            foundError = true;
        }
        if ( PubTypeId == null){
            errorMsg += 'Cannot Create Pub without a Publication Type.\r\n';    
            foundError = true;
        }           
        
        if (foundError){
            AppLogModel.LogError('AppearPubModel::checkForDup', 'Create Publication Aborted', errorMsg, userinfo.getUserId());
            AppLogModel.flushLogs('AppearPubModel::checkForDup');
            return new CreatePubResult(errorMsg);
        } else {
            
            //Todo - SOQL to check DB
              
            return null;  
        }       
        
    }
  
    public List<Publication__c> routedPublicationsForReviewer{
        get {
            return findPublicationsForReviewer(userInfo.getUserId(), true, false);
        }
    }
  
    public List<Publication__c> routedPublicationsForReviewerMainNav{
        get {
            return findPublicationsForReviewer(userInfo.getUserId(), true, true);
        }
    }
  
    public List<Publication__c> publicationsForReviewer{
        get {
            return findPublicationsForReviewer();  
        }
    }
 
    public static List<Publication__c> findPublicationsForReviewer() {
        return findPublicationsForReviewer(userInfo.getUserId(), false, false);
    }

    public static List<Publication__c> findPublicationsForReviewer(Id reviewerId, Boolean onlyRouted, Boolean mainNav){
        AppLogModel.LogDebug('AppearPubModel::findPublicationsForReviewer', 
            'Invoking findPublicationsForReviewer for '+reviewerId+
            ' current user is '+UserInfo.getUserName(),  UserInfo.getUserId());
        if (reviewerId == null){
            return new List<Publication__c>();
        }
        
        //find the contact record for the reviewer
        Set<id> appearUserContactSet = AppearContactModel.findContactForAppearUser(reviewerId);
        AppLogModel.LogDebug('AppearPubModel::findPublicationsForReviewer', 
            'appearUserContactSet for '+reviewerId+' contains : '+appearUserContactSet);        
        
        set<string> statusesToInclude = new set<string>();

        if (findSelectedFprSubmitterMyRequestOption() == 'open' || findSelectedFprSubmitterMyRequestOption() == 'notify') {
            statusesToInclude.add(StatusModel.FprOnlyStatus);
            statusesToInclude.add(StatusModel.RoutedStatus);
            if (!onlyRouted) {
                statusesToInclude.add(StatusModel.InFprStatus);
                statusesToInclude.add(StatusModel.AssignedToFPRCStatus);
            }
            statusesToInclude.add(PubReviewTeamTriggerLogic.DiscussionRequired);
        } else {
            if (onlyRouted) {
                statusesToInclude.add(StatusModel.RoutedStatus);
            }
            statusesToInclude.add(StatusModel.FPRCompletedStatus);
            statusesToInclude.add(StatusModel.FprCompletedWithCommentStatus);
            statusesToInclude.add(StatusModel.FprWithHeldStatus);
            statusesToInclude.add(StatusModel.FprWithdrawnStatus);
            statusesToInclude.add(StatusModel.FprCourtesyCompletedStatus);
            statusesToInclude.add(StatusModel.FprCourtesyCompletedWithCommentStatus);
        }

                
        //find a list of publication Review team with this set of user Id
        List<PubReviewTeam__c> pubReviewTeamMemberList;
        if (onlyRouted && mainNav) {
            pubReviewTeamMemberList  =  [
                select Publication__c, Publication__r.publication_Title__c, Type__c, Publication__r.Current_Status_FormulaField__c, HasVoted__c
                from PubReviewTeam__c
                where (Reviewer__c in :appearUserContactSet)
                and IsLogicallyDeleted__c = false
                and HasVoted__c = false
                and IsCurrentFPRCycleForPub__c = true
            ];
        } else if (onlyRouted && (findSelectedFprSubmitterMyRequestOption() == 'open')) {
            pubReviewTeamMemberList  =  [
                select Publication__c, Publication__r.publication_Title__c, Type__c, Publication__r.Current_Status_FormulaField__c, HasVoted__c
                from PubReviewTeam__c
                where (Reviewer__c in :appearUserContactSet)
                and IsLogicallyDeleted__c = false
                and Type__c = 'Primary'
                and HasVoted__c = false
                and IsCurrentFPRCycleForPub__c = true
            ];
        } else if (findSelectedFprSubmitterMyRequestOption() == 'notify') {
            pubReviewTeamMemberList = [
                select Publication__c, Publication__r.publication_Title__c, Type__c, Publication__r.Current_Status_FormulaField__c, HasVoted__c
                from PubReviewTeam__c
                where (Reviewer__c in :appearUserContactSet)
                and Type__c = 'Notify'
                and IsLogicallyDeleted__c = false
                and IsCurrentFPRCycleForPub__c = true
            ];
        } else {
            pubReviewTeamMemberList = [
                select Publication__c, Publication__r.publication_Title__c, Type__c, Publication__r.Current_Status_FormulaField__c, HasVoted__c
                from PubReviewTeam__c
                where (Reviewer__c in :appearUserContactSet)
                and IsLogicallyDeleted__c = false
            ];
        } 
       
        
        Set<id> pubIdSet = new Set<id>();
        String pubTitleList = '';
        for(PubReviewTeam__c prt : pubReviewTeamMemberList) {
            if (onlyRouted && findSelectedFprSubmitterMyRequestOption() == 'closed' && prt.Publication__r.Current_Status_FormulaField__c == StatusModel.RoutedStatus && !prt.HasVoted__c) {
                continue;
            }
            //if (!onlyRouted)
            pubIdSet.add(prt.Publication__c);
            pubTitleList += prt.Publication__r.publication_Title__c + '  ';
        }
        
        if (!onlyRouted && findSelectedFprSubmitterMyRequestOption() != 'notify') {
            List<Publication__c> ownedPubs =  [SELECT id, publication_Title__c, Current_Status_Id_FormulaField__c from Publication__c
                WHERE (OwnerId = :userInfo.getUserId() OR CreatedById = :userInfo.getUserId() OR Fpr_Submitter__r.UserId__c = :userInfo.getUserId() OR Fpr_Submitter__c IN :appearUserContactSet) AND Current_Status_FormulaField__c IN :statusesToInclude ];
            for(Publication__c ownedPub :ownedPubs) {
                if ((findSelectedFprSubmitterMyRequestOption() == 'closed') && ownedPub.Current_Status_Id_FormulaField__c == StatusModel.Routed.Id) {
                    continue;
                }
                pubIdSet.add(ownedPub.id);
                pubTitleList += ownedPub.publication_Title__c + '  ';
            }
        }
        
        AppLogModel.LogDebug('AppearPubModel::findPublicationsForReviewer', 
            'reviewer '+reviewerId+' is on the PubReviewTeam for the following publicatoins : '
            + pubTitleList);   
        Set<Id> filteredPubIdSet = onlyRouted ? PubStatusModel.GetPubsRoutedCurrentFPRCycle(pubIdSet) : pubIdSet;
            
        List<Publication__c> pubs = [
            select name, Publication_Title__c, Publication_Type__c, 
            Current_Submission_Cycle_Num__c,
            Current_FPRCycle_Id_Formula__c, 
            Current_FPR_Cycle_Num__c,
            Current_Status_FormulaField__c,
            Assigned_FPRC__c, Assigned_FPRC__r.name,
            Date_Expected_By__c, FPR_Due_Date__c,
            OwnerId, CreatedById, Fpr_Submitter__c
            from publication__c
            where id in :filteredPubIdSet            
            and (Current_Status_FormulaField__c in :statusesToInclude)
        ];
        
        List<Publication__c> pubsResult = new List<Publication__c>();
        
        if (!onlyRouted) {
            Id contactId = null;
            for(Id innerId : appearUserContactSet) {
                contactId = innerId;
                break;
            }
            for (Publication__c pubToCheck : pubs) {
                if (pubtocheck.OwnerId == userInfo.getUserId()
                 || pubtocheck.CreatedById == userInfo.getUserId()
                 || (contactId != null && pubtocheck.Fpr_Submitter__c == contactId)  ) {
                    pubsResult.add(pubToCheck);
                }
            }
        } else {
            pubsResult = pubs;
        }
        
        AppLogModel.flushLogs();
        return pubsResult;
        
    }
    
    public List<SelectOption> getFprSubmitterMyRequestOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('open','Open Requests'));
        options.add(new SelectOption('closed','Completed Requests'));
        return options;
    }
    
    
    public List<SelectOption> getReviewerMyRequestOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('open','Open Requests'));
        options.add(new SelectOption('closed','Completed Requests'));
        options.add(new SelectOption('notify','Notification Requests'));
        return options;
    }
    
    private static string pSelectedFprSubmitterMyRequestOption;
    public string SelectedFprSubmitterMyRequestOption{
        get{        
            return findSelectedFprSubmitterMyRequestOption();
        }
        set{
            pSelectedFprSubmitterMyRequestOption = value;
        }
    }
    
    private static string findSelectedFprSubmitterMyRequestOption() {       
            if (pSelectedFprSubmitterMyRequestOption == null) {
                pSelectedFprSubmitterMyRequestOption = 'open';
            }           
            return pSelectedFprSubmitterMyRequestOption;
    }

    
   
    
    public void UpdateProjectstudy(Id PubId,string Projectstudystring){
        if ( pubRecord <> null) {
            pubRecord.Project_Ids__c = Projectstudystring;
            update pubRecord;
            AppLogModel.LogInfo('AppearPubModel::UpdateProjectstudy', 
                'updated Project_Ids__c ['+Projectstudystring+']', pubRecord.id);
        } else {
            AppLogModel.LogError('AppearPubModel::UpdateProjectstudy', 
                'cannot locate pub to update Project_Ids__c',pubRecord.id);
        }
        AppLogModel.flushLogs();
    }
    
    public static void UpdateProductIndicationForPub(Id PubId, string ProdIndString, boolean IsEnbrelPub, Id TAid){ 
        
        if ( ProdIndString == null){
            ProdIndString = '';
        } else if ( ProdIndString.length() >= 255){
            ProdIndString = ProdIndString.substring(0,254);
        }
        
        List<Publication__c> pubs = [
            select product_indication__c, IsEnbrel__c, TA__c, IsBiosimilars__c
            from Publication__c
            where id = :PubId
        ];
        
        if (pubs.size() ==1 ){
            pubs[0].product_indication__c = ProdIndString;
            pubs[0].IsEnbrel__c = IsEnbrelPub;
            pubs[0].TA__c = TAid;
                        
            if ( ProdIndString.ToUpperCase().contains('BIOSIMILAR')) {
                pubs[0].IsBiosimilars__c = true;
            } else {
                //pubs[0].IsBiosimilars__c = false; //need to manually reset to false
            }   
            update pubs[0];
            AppLogModel.LogInfo('AppearPubModel::UpdateProductIndicationForPub', 
                'updated productIndication/isEnbrel/Biosimilar ['+ProdIndString+':'+IsEnbrelPub+':'+pubs[0].IsBiosimilars__c+']', pubId);
        } else {
            AppLogModel.LogError('AppearPubModel::UpdateProductIndicationForPub', 
                'cannot locate pub to update productIndication/isEnbrek/Biosimilar',pubid);
        }
        AppLogModel.flushLogs();
    }
    
    
    public PageReference resetCurrentStatus() {
        PublicationTriggerLogic.UpdateLatestPubStatusById(pubId);
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }

    public PageReference CountVote() {
        PubReviewTeamTriggerLogic.ReCountVoteByPubId(pubId);
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
     
    
    ///////////  sharing ////////////////
    public boolean isDisplaySharing { get;set;}
    public PageReference showSharingDetails() {
        isDisplaySharing = true;
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    public PageReference hideSharingDetails() {
        isDisplaySharing = false;
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    
    public PageReference resetSharing() {
        return resetSharingWithStatus(PubStatus.CurrentStatus);
    }

    /*Code Written as part of Appear Release 1 Enhancement */
    public PageReference resetSharingPubMe() {
     return resetSharingWithStatus(PubStatus.CurrentStatus);
    }
    
    public PageReference resetSharingWithStatus(Status__c currentStatus) {
        AppLogModel.LogDebug('AppearPubModel::resetSharing', 'start', PubId);
        PubTeamMember.flushCache();
        string currentPrimaryProductIndicatorId = PubProdIndication.KeyProdIndStr;        
    
        List<Id> EditIdList = new List<Id>();
        List<Id> ReadIdList = new List<Id>();
        List<Id> EditIdListWriter = new List<Id>();
        List<Id> EditIdListIWriter= new List<id>();//Appear Enhancement R2: Code used to provision International External Writer
        
        AppearPubModelShare pubShare = new AppearPubModelShare(PubId, PubRecord.Recordtypeid, PubRecord.isEnbrel__c);
        
        //query before access is temp. removed
        for(Publication__c createdPub : [select CreatedById, FPR_Submitter__r.UserId__c from Publication__c where id = :PubId]) {
            AppLogModel.LogInfo('AppearPubModel::resetSharing','Adding CreatedById ('+createdPub.CreatedById+') to readonly list ', PubId);
            ReadIdList.add(createdPub.CreatedById); // always maintain read access for createdBy
            if (createdPub.FPR_Submitter__c != null && createdPub.FPR_Submitter__r.UserId__c != null) {
                AppLogModel.LogInfo('AppearPubModel::resetSharing','Adding FPR Submitter ('+createdPub.FPR_Submitter__r.UserId__c+') to readonly list ', PubId);
                ReadIdList.add(createdPub.FPR_Submitter__r.UserId__c); // always maintain read access for FPR Submitter
            }
            break;  
        }
        
        pubShare.resetAllApexSharing();
        
        for(PublicationTeamMember__c ptm : PubTeamMember.PubActiveTeamMemberList) {
            
            //Primary  & adhoc get Edit
            if (ptm.fromKeyProdInd__c || ptm.Product_Indication__c == null) {
                EditIdList.add(ptm.member__r.UserId__c);
            } else {
                //Non Primary add get Read Only
                ReadIdList.add(ptm.member__r.UserId__c);
            }
        }
        
        //pub team 
        if (ReadIdList.size() > 0 ) {
            pubShare.pubTeamShareRead(ReadIdList);
        } else {
            AppLogModel.LogDebug('AppearPubModel::resetSharing', 'skip pubShare.pubTeamShareRead', PubId);
        }
        if (EditIdList.size() > 0 ) {
            AppearPubModelShare.pubTeamShareEdit(PubId, EditIdList, currentStatus); 
        } else {
            AppLogModel.LogDebug('AppearPubModel::resetSharing', 'skip pubShare.pubTeamShareEdit', PubId);
        }
        /*Appear Enhancement R1: code Implement for Enabling External Writer*/
        system.debug('*****&&&&&&&'+PubId);
        //Publication__c publication= [Select Id,isEnbrel__c from Publication__c where Id= :PubId];//Appear Enhancement R2://R2 checking
        //system.debug('&&&&&&&******'+publication);
        for(PubMe__c pbm :  [Select Id,Publication__c,Publication__r.isEnbrel__c,WritingRoleMember__c,WritingRoleMember__r.UserId__c,WritingRoleMember__r.Role__c from PubMe__c where Publication__c =:PubId]) {            
             if(pbm.WritingRoleMember__r.Role__c=='External Writer')
                EditIdListWriter.add(pbm.WritingRoleMember__r.UserId__c);  
             //Appear Enhancement R2: Code used to provision International External Writer
             else if(pbm.WritingRoleMember__r.Role__c=='IExternal Writer' && !pbm.Publication__r.isEnbrel__c)
                EditIdListIWriter.add(pbm.WritingRoleMember__r.UserId__c);    
         } 
        //Appear Enhancement R2: Code used to provision International External Writer
        if(EditIdListIWriter.size()>0 ){//R2 checking
             system.debug('Populated the share for International EW profile User');
             AppearPubModelShare.pubMeShareEdit(PubId, EditIdListIWriter, currentStatus);
        }
        if (EditIdListWriter.size() > 0 ) {
        AppearPubModelShare.pubMeShareEdit(PubId, EditIdListWriter, currentStatus); 
        } else {
            AppLogModel.LogDebug('AppearPubModel::resetSharing', 'skip pubShare.pubMeShareEdit', PubId);
        }
        
        //Pub Review Team - edit for all
        pubShare.pubReviewTeamShareEdit(PubReviewTeam.PubActiveAllCyclesReviewteamMemberUserIds);
        
        isDisplaySharing = true;
        AppLogModel.flushLogs();
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    public string sharingDetails{
        get {
            AppearPubModelShare pubShare = null;
            if ( pubRecord <> null) {
                pubShare = new AppearPubModelShare(PubId, PubRecord.RecordTypeId, PubRecord.isEnbrel__c);
            } else {
                pubShare = new AppearPubModelShare(PubId, null, null);
            }
            
            if ( pubShare <>null) {
                return pubShare.sharingDetails;
            } else {
                return 'User does not have access to this publication'+'<br/><br/><br/>';
            }
        }
    }
    
    
    
    /*
    public void ChangeOwnershipToCurrentUser() {
    }
    */
    public void ChangeOwnershipToCurrentUser(boolean updatePubRecord) {
        //Def 16, 17 - change owner of pub to GPPL - or the person accepting this pub record
        pubRecord.OwnerId = UserInfo.getUserId();
        
        if (updatePubRecord ) {
            update pubRecord;
        }
        AppLogModel.LogInfo('AppearPubModel::ChangeOwnershipToCurrentUser', 
            'Changed ownership for Pub['+PubTitle +'] to user ' + UserInfo.getName(), PubId);      
        
    }
    
    public void ChangeOwnershipToTemporaryPoolUser(boolean updatePubRecord) { //used to remove edit access to a submitted suggestion or in fpr from creator. Sharing criteria will grant redundantly where appropriate
        withoutSharingUtil.ChangeOwnershipToTemporaryPoolUser(pubRecord, updatePubRecord);
    }
    
    public void ChangeOwnershipToFprSubmitter(boolean updatePubRecord) { //used to remove edit access to a submitted suggestion or in fpr from creator. Sharing criteria will grant redundantly where appropriate
        withoutSharingUtil.ChangeOwnershipToFprSubmitter(pubRecord, updatePubRecord);
    }
     
    //static call to batch reset sharing for all publications.
    public static boolean resetSharing(string pubId) {
        
        AppLogModel.LogDebug('AppearPubModel::resetSharing', 'start for PubId='+pubId, PubId);
        
        List<Publication__c> pubs = [select id from Publication__c where Id = :pubId];
        
        if (pubs.size() <> 1){
            AppLogModel.LogError('AppearPubModel::resetSharing', 'Abort cannot find PubId='+pubId);
            AppLogModel.flushLogs();
            return false;
        } 
         
        AppearPubModel activePub = new AppearPubModel(pubs[0].id);
        activePub.resetSharing();
        return true;
    }
    
    //static call to sync product indication fields on a pub in batch
    public static void SyncPubIndicationFields(List<Publication__c> pubsToSync) {
        for(Publication__c pub : pubsToSync) {
            boolean isEnbrelSelected = false;
            string prodIndString = '';
            string keyIndString = '';
            id KeyProdIndTAid = null;
            
            for(Pub_Prod_Ind__c pubProdInd : PubProdIndModel.getPubProductIndication(pub.Id)) {
                
                if (pubProdInd.isEnbrel__c) {
                    isEnbrelSelected = true;
                }
                
                if ( pubProdInd.isKey__c == false) {
                    prodIndString += '; '+ ProductIndicationModel.ProductIndicationMap.get(pubProdInd.product_indication__c).name;
                } else {
                    keyIndString = ProductIndicationModel.ProductIndicationMap.get(pubProdInd.product_indication__c).name;
                    KeyProdIndTAid = ProductIndicationModel.ProductIndicationMap.get(pubProdInd.product_indication__c).Therapeutic_Area__c;
                }
            }
            string combinedIndications = keyIndString + prodIndString;
            
            if ( combinedIndications.length() >= 255){
                combinedIndications = combinedIndications.substring(0,254);
            } 
            
            pub.IsEnbrel__c = isEnbrelSelected;
            pub.product_indication__c = combinedIndications;
            pub.TA__c = KeyProdIndTAid;
            
            if ( combinedIndications.ToUpperCase().contains('BIOSIMILAR')) {
                pub.IsBiosimilars__c = true;
            }
        }
        
        update pubsToSync;
    }
    
    ////// Delete a pub Action - clear UserPref - return to Publication tab
    public PageReference DeleteThisPub() {
        
        if (DeletePub(pubId) ) {
            UserPrefModel.clearMyPubIdPref();
            return new PageReference(AppearUrlModel.AppearPubListUrl());    
            //return null;
        }
        return new PageReference(AppearUrlModel.AppearPubListUrl());    
        //return null;
    }
    
    ////// Delete a Pub - static function - maybe invoked by batch
    public static boolean DeletePub(Id PubId) {
        AppearPubModel activePub = new AppearPubModel(PubId);
        
        if (!activePub.hasValidPub) {
            string msg = 'Aborting Delete Pub - Not a valid pub - cannot load '+PubId;
            AppLogModel.LogError('AppearPubModel::DeletePub', msg, PubId);
            AppLogModel.flushLogs();
            return false;
        }
        
        if (!activePub.hasEditAccess) {
            string msg = 'User : ' + UserInfo.getUserName()+ ' does not have EDIT access to '+activePub.PubTitle+'.  aborting now';
            AppLogModel.LogError('AppearPubModel::DeletePub', msg, PubId);
            AppLogModel.flushLogs();
            return false;
        }       
        
        //delete the childrens first
        List<sObject> delSObjectList = new List<sObject>();
        List<sObject> records = null;
        
        //Pub Attachment
        records = [select id from PubAttachmentDetails__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        records = [select id from Pub_Prod_Ind__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //FeedItems
        records = [select id from FeedItem where ParentId = :PubId];
        delSObjectList.addAll(records);
        
        //Pub Team Member
        records = [select id from PublicationTeamMember__c where publication__c = :PubId and isDeleted=false ];
        delSObjectList.addAll(records);
        
        //Pre FPR Reviewer
        records = [select id from PublicationPreFprReviewer__c where publication__c = :PubId and isDeleted=false ];
        delSObjectList.addAll(records);
        
        //Pub Review Team Member
        records = [select id from PubReviewTeam__c where publication__c = :PubId];
        delSObjectList.addAll(records);
                
        //Pub ME
        records = [select id from PubME__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        

        
        //FPR Cycle
        records = [select id from FPR_Cycle__c where publication__c = :PubId];
        delSObjectList.addAll(records);

        //Submission Cycle
        records = [select id from SubmissionCycle__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //Pub Related
        records = [select id from PubRelated__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        records = [select id from PubRelated__c where RelatedPub__c = :PubId];
        delSObjectList.addAll(records);
        
        
        //PubNotes
        records = [select id from PubNote__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //PubStudy
        records = [select id from PubStudy__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //PubScientific Statement
        records = [select id from PubScientificStatement__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //PubAuthors
        records = [select id from pubAuthor__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //Delete delSObjectList;
        List<Database.Deleteresult> drList = Database.delete(delSObjectList, true);
        
        boolean hasError = false;
        for(Database.Deleteresult dr : drList) {
            if(dr.isSuccess()){
                // Indicates success
                //return true;
            } else {
                hasError = true;
                // Get first save result error.
                Database.Error err = dr.getErrors()[0];
                string msg = err.getStatusCode() + ' '+ err.getMessage();
                AppLogModel.LogError('AppearPubModel::DeletePub', msg, PubId);

                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.FATAL, msg);
                ApexPages.addMessage(errMsg);
            }
        }
        if ( hasError) {
            AppLogModel.flushLogs();
            return false;
        }
        
        if ( delSObjectList.size() > 0) {
            Database.emptyRecycleBin(delSObjectList);
        }
        
        AppLogModel.LogInfo('AppearPubModel::DeletePub', UserInfo.getUserName() + ' invoked deletePub for Pub - '+activePub.PubId+
            '.    removed '+delSObjectList.size()+' records', pubId);
        
        delSObjectList.clear();
        
        activePub.pubRecord.PubStatus__c = null;
        update activePub.pubRecord;
        
        
        //Pub Prod Ind
        records = [select id from Pub_Prod_Ind__c where publication__c = :PubId  and isDeleted=false ];
        delSObjectList.addAll(records);
                
        //PubStatus
        records = [select id from PubStatus__c where Publication_id__c = :PubId];
        delSObjectList.addAll(records);     
                
        //The pub record
        delSObjectList.add(activePub.PubRecord);
        
        delete delSObjectList;
        if ( delSObjectList.size() > 0) {
            Database.emptyRecycleBin(delSObjectList);
        }
        
        AppLogModel.flushLogs();
        return true; 
    }

    //static function to find a pub name for Submission Cycle & FPR Cycle triggers - light and fast
    public static Publication__c findPubName(Id PubId) {
        list<Publication__c> pubs = [select name from Publication__c where id = :PubId];
        if ( pubs.size() == 1) {
            return pubs[0];
        } else {
            return null;
        }
    }
    
    //Invoke by AppearPubViewModel - Ajax call 
    public static List<Publication__c> findPubsByNameA( string startWith) {
        string pubStartWith = '%'+startWith+'%';
        List<Publication__c> pubNameResult = [
            select name, Publication_Title__c
            from Publication__c
            where Name like :pubStartWith
            limit 50
        ];          
            
        List<Publication__c> pubTitleResult = [
            select name, Publication_Title__c
            from Publication__c
            where Publication_Title__c like :pubStartWith
            limit 50
        ];
        
        pubTitleResult.addAll(pubNameResult);
        return pubTitleResult;  
    }
    
    public static void resetPubStatus() {
        List<Publication__c> pubs = [
            select id 
            from publication__c 
            order by createdDate desc
            limit 50
        ];
        for(Publication__c pub : pubs) {
            PublicationTriggerLogic.UpdateLatestPubStatusById(pub.id);
        }
    }
    
}