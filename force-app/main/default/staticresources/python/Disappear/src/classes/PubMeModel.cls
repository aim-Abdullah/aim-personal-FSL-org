public with sharing class PubMeModel extends AppearBaseModel {
    //storyboard 2.0 pg 199

    private id PubId;
    private string ActiveTile;
    private string ActiveSubMenu;
    private boolean isCurrentSubmissionCycleValid = false;
    private id PubTypeId;
    private id OrigMeScopeOfWorkId;
    private DateTime CurrentActualStatusDate = DateTime.Now();
    private PubStatusModel pubStatusModel;
    private AppearPubModel pubModel;
    
    public Publication__c pubRecord{get;set;} //to update MeScopeOfWork for the publication by the Writing Coordinator  
    
    public SubmissionCycle__c CurrentSubmissionCycle{ get;set;}
    public FPR_Cycle__c CurrentFprCycle{get;set;}
    public Id CurrentStatusId{get;set;}
    
    //Constructor added by Sudha..
    public PubMeModel(){
    }
    //Constructor added as part for  Release 1 Appear Enhancement
    public PubMeModel(Id PubId){
    }
    
    public string RecalculateHelpText {
        get {
            return '"Recalculate" button is used for planning purpose and displays the potential Actual ME value in Actual ME GUI column. The values are not SAVED permanently. Please click "Save" button to store the value(s) permanently.';
        }
    }
    public boolean ShowRecalcButton {
        get {
            if ( ProfileModel.isSysAdmin) {
                return true;
            } else {
                return false;
            }
        }
    }
    
    private boolean pShowOverrideColumn = false;  //initialize in constructor
    public boolean ShowOverrideColumn {
        get {
            return pShowOverrideColumn;
        }  
        set {
            pShowOverrideColumn = value;
        }
    }
    
    public boolean debugFlag {  //show created / last modified
        get {
            string debugFlag = KeyValueSettingsModel.GetKey('PubMeDebugFlag', 'false').value__c;
            return boolean.valueOf(debugFlag);
        }
    }  
    
    private boolean pShowGUIvsDBinit = false;
    private boolean pShowGUIvsDB = false;
    public boolean ShowGUIvsDB {
        get {
            /* if (!pShowGUIvsDBinit ) {
                pShowGUIvsDBinit = true;
                pShowGUIvsDB = false;
            }*/
            return debugFlag;
        }
        set {
            pShowGUIvsDBinit = true;
            pShowGUIvsDB = value;           
        }
        
    }
    
    public void clearPubMeList() {
        AppLogModel.LogInfo('PubMeModel::PubMeList', 'ClearPubMeList');
        pPubMeList = null;
    }
    private List<PubME__c> pPubMeList = null;
    public List<PubME__c> PubMeList {
        get{
            if ( pPubMeList == null){ 
        
                if ( CurrentSubmissionCycle == null) {
                    //Error condition - pub must have a Current Submission Cycle
                    AppLogModel.LogError('PubMeModel::PubMeList', 'Cannot retrieve PubMeList - SubmissionCycle == null for pub id = '+ Pubid, pubId);
                    AppLogModel.flushLogs();
                    return new List<PubME__c> ();
                }
                
                pPubMeList =getPubMeAllSubmitCycles(PubId, CurrentSubmissionCycle.Id);
                AppLogModel.LogInfo('PubMeModel::PubMeList', 'Loading PubMeList from DB size -'+pPubMeList.size());
                
                resetIsSelected();  
                AppLogModel.LogInfo('PubMeModel::PubMeList', 'After resetIsSelected from DB size -'+pPubMeList.size());
                //calculateActualMeGUI();
                //calculateCummulativeME();
                AppLogModel.LogInfo('PubMeModel::PubMeList', 'calculatedActualMeGUI from DB size -'+pPubMeList.size());
            }
            
            AppLogModel.LogInfo('PubMeModel::PubMeList', 'returning '+pPubMeList.size(), PubId);
            AppLogModel.flushLogs();
            return pPubMeList;
        } 
    }

    public PubMeModel(Id PubId, string tile, string subMenu, 
        Publication__c pubRecord, SubmissionCycle__c CurrentSubCycle, FPR_Cycle__c CurrentFprCycle, PubStatusModel PubStatus) {
        
        this.PubId = PubId; 
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;
        this.CurrentSubmissionCycle = CurrentSubCycle;
        this.pubStatusModel = PubStatus;
        this.pubModel = new AppearPubModel(PubId);
        
        if (CurrentFprCycle == null) {
            this.CurrentFprCycle = FprCycleModel.getFprCycleByNum(pubId, 1);
            AppLogModel.LogError('PubME::constructor', 'CurrentFprCycle == null -> Setting to 1', pubId);
            AppLogModel.flushLogs();
        } else {
            this.CurrentFprCycle = CurrentFprCycle;
            AppLogModel.LogDebug('PubME::constructor', 'CurrentFprCycle <> null', pubId);
        }
                
        this.PubRecord = pubRecord;
        this.pubTypeId = pubRecord.PubType__c;
        this.CurrentStatusId = pubRecord.Current_Status_Id_FormulaField__c;
        this.CurrentActualStatusDate = pubRecord.Current_Status_Date_FormulaField__c;
                
        calcPlanningMe();
        calculateCummulativeME();

        if ( profileModel.isSysAdmin || profileModel.isAppearBusinessAdmin ){
            ShowOverrideColumn = true;
        } else {
            ShowOverrideColumn = false;
        }
        
        AppLogModel.flushLogs();
    }
    
    public void AwardMeForSubmittedCompleted(AppearPubModel activePub) {
        //to be deleted
    }

    public void AwardMeForSubmittedCompleted(AppearPubModel activePub, PubStatus__c SubmittedCompletedStatus) {
        for(PubMe__c pubME : PubMeList) {
            if (pubMe.PubStatus__c == null && pubMe.Submission_Cycle__c == SubmittedCompletedStatus.Submission_Cycle__c ) {
                pubMe.PubStatus__c = SubmittedCompletedStatus.Id;
                pubMe.FPR_Cycle__c = SubmittedCompletedStatus.FPR_Cycle__c;
                pubMe.isSubmissionCycleSubmitted__c = true;
            }
        }
        
        recalculateAndPersist();
        AppLogModel.flushLogs();    
    }
    
    public void AwardMeForNonMaterialChange(AppearPubModel activePub) {

        pPubMeList = null; //clear PubMeList - to retrieve the newly inserted PubStatus
        
        // ready to award ME at this point.
        recalculateAndPersist();
        AppLogModel.flushLogs();
    }

    public void AwardMeForMaterialChangeCongressJournal(AppearPubModel activePub) {
        AppLogModel.LogInfo('PubMeModel::AwardMeForMaterialChangeCongressJournal', 
            'Invoking award ME for MaterialChange for SC='+activePub.CurrentSubmissionCycleNum+' FC='+activePub.CurrentFprCycleNum, pubId);
        
        pPubMeList = null;  //clear PubMeList - to retrieve the newly inserted PubStatus
        
        //look for max ME - and process all PubME record with that ME
        recalculateAndPersist();
        AppLogModel.flushLogs();
    }

    //Calc Planning ME is for the entire pub
    private void calcPlanningMe() {
        OrigMeScopeOfWorkId =  MEScopeOfWorkModel.WritingScope;
        
        if ( pubRecord.ScopeOfWork__c <> null){
            OrigMeScopeOfWorkId = pubRecord.ScopeOfWork__c;
        }

        MEScopeOfWork__c scope = MEScopeOfWorkModel.MEScopeNameByIdMap.get(pubRecord.ScopeOfWork__c);
        Decimal rawPlannedME =  PubTypeModel.findPubTypeMe(PubTypeId);
        Decimal PlannedME = rawPlannedME * Scope.Scaling_Factor__c;
        
        //CR #203: Update the IF condition to include 0.00, so that system will save the changes to the SoW
        //Sometimes PlannedME will be same for all SoW's
        if ( PlannedME <> pubRecord.PlannedME__c || PlannedME == 0.00 || PlannedME != 0.00 ) {
            pubRecord.PlannedME__c = PlannedME;
            
            try {
                Update pubRecord;
            } catch (System.Dmlexception dmle) {
                if (!dmle.getMessage().contains('INSUFFICIENT_ACCESS_OR_READONLY')) {  //if the user only has Read Access - ignore the error
                    //throw dmle; //Appear Enhancement R2: Historical Publication fix for Validation Rules
                }
            }
        } 
    }
    
    public PageReference recalculateAndPersist() {
        List<sObject> updateObjList = new List<sObject>();
        Integer maxIntTotalMECycle = 0;
        
        calculateActualMeGUI();
        
        string pubStage = pubRecord.pubStatus__r.status__r.stage__c;
        
        for(PubME__c pubMeCycle :  PubMeList) {
            if(pubMeCycle.MeCycleNum__c > maxIntTotalMECycle){
                maxIntTotalMECycle = Integer.valueOf(pubMeCycle.MeCycleNum__c);
            }
        }
        
        for(PubME__c pubMe :  PubMeList) {
            if(pubMe.Submission_Cycle__c == CurrentSubmissionCycle.id && (pubStage == 'Submit' || pubStage == 'Review' || pubStage == 'Execute')) {
                pubMe.ActualME__c = pubMe.Actual_ME_GUI__c;
            }
            
            if(maxIntTotalMECycle == pubMe.MeCycleNum__c) {
                pubMe.Department__c = (pubMe.Department__c != null && pubMe.Department__r.isLogicallyDeleted__c == true) ? null : pubMe.Department__c;
                pubMe.Organization__c = (pubMe.Organization__c != null && pubMe.Organization__r.isLogicallyDeleted__c == true) ? null : pubMe.Organization__c;
            } else {
                continue;
            }
            /*
            AppLogModel.LogDebug('PubMeModel::recalculateAndPersist assigning GUI to pubMe', 
                '\n ME Cycle Num='+pubMe.MeCycleNum__c+
                '\n PubMe.Submission_Cycle__c='+pubMe.Submission_Cycle__c+
                '\n CurrentSubmissionCycle.id='+CurrentSubmissionCycle.id+
                '\n Publication Stage='+pubStage+'; '+pubRecord.pubStatus__r.status__r.name+
                '\n Actual ME='+pubMe.ActualME__c+
                '\n Pub Status of ME='+pubMe.PubStatus__r.Status__r.Name+
                '\n Actual_ME_GUI__c='+pubMe.Actual_ME_GUI__c);*/
            updateObjList.add(pubme);   
        }
        
        calculateCummulativeME();
        
        //Add the updated Cumulative ME value on the Publication Record
        updateObjList.add(pubRecord);
        
        AppLogModel.flushLogs();
        PubMeModelNoSharing.PersistPubMeList(updateObjList); 

        return null;
    }
    
    public PageReference calculateActualMeGUI() {
                
        ShowGUIvsDB = true;
        
        AppLogModel.LogDebug('PubMeModel::calculateActualMeGUI:start', 'started for '+pubRecord.Name+' pubMeList size = '+pubMeList.size(), pubId);
        decimal cumulativeME = 0.0;
        
        //Def 288 - DO NOT Calculate Actual ME if Status is Not Submitted / Completed
        string pubStage = pubRecord.pubStatus__r.status__r.stage__c;
        
        //decimal writingScopeFactor = pubRecord.ScopeOfWork__r.Scaling_Factor__c;
        MEScopeOfWork__c scope = MEScopeOfWorkModel.MEScopeNameByIdMap.get(pubRecord.ScopeOfWork__c);
        decimal writingScopeFactor = 1.0;
        AppLogModel.LogDebug('PubMeModel::calculateActualMeGUI', 'MEScopeOfWork__c b4 ='+scope, pubId);
        if ( scope <> null) {
            writingScopeFactor = scope.Scaling_Factor__c;
        } 
        
        AppLogModel.LogDebug('PubMeModel::calculateActualMeGUI', 'MEScopeOfWork__c after ='+writingScopeFactor, pubId);
        
        integer PubCurrentSubmissionCycleNum = Integer.ValueOf(CurrentSubmissionCycle.Submission_Cycle_Num__c);
        decimal pubTypeMe = PubTypeModel.findPubTypeMe(PubTypeId);
        decimal pubTypeMePlus = PubTypeModel.findPubTypeMePlus(PubTypeId);
        
        AppLogModel.LogDebug('PubMeModel::calculateActualMeGUI', 'PubTypeME = '+pubTypeMe +'  PubTypeME+ = '+pubTypeMePlus, pubId);
        
        integer currentSubmissionCycleNum = 1;
        Integer currentTotalCycle = 0;
        
        boolean MeAwarded = false;
        
        for(PubMe__c pubMe : PubMeList) {
            AppLogModel.LogDebug('PubMeModel::calculateActualMeGUI', 'checking ='+pubMe, pubId);
            
            Integer meCurrentSubmissionCycleNum = 1;
            if (pubMe.Submission_Cycle__c <> null) {
                meCurrentSubmissionCycleNum = Integer.valueOf(pubMe.Submission_Cycle__r.Submission_Cycle_Num__c);
            }
            
            Integer meCurrentFprCycleNum = 0;
            if ( pubMe.FPR_Cycle__c <> null  ) {
                meCurrentFprCycleNum = (pubMe.FPR_Cycle__r.FPR_Cycle_Num__c != null) ? Integer.valueOf(pubMe.FPR_Cycle__r.FPR_Cycle_Num__c) : 1;
            }
            
            Integer meCurrentMeCycleNum = 0;
            if ( pubMe.MeCycleNum__c <> null  ) {
                meCurrentMeCycleNum = Integer.valueOf(pubMe.MeCycleNum__c);
            }
           
            Integer meTotalCycle = meCurrentSubmissionCycleNum + meCurrentFprCycleNum + meCurrentMeCycleNum;  
            //meTotalCycle is used to defect when a change in SC or FC cycles happens
        
            //only calculate for writing coordinators [ first one only ] & first submission cycle
            boolean isWritingCoordinatorRole = AppearRoleModel.isWritingCoordinatorRole(pubMe.AppearRole__c);
            if ( currentTotalCycle <> meTotalCycle && isWritingCoordinatorRole ) {
                currentTotalCycle = meTotalCycle;
                
                //only award ME to the first Writing Coordinator - only once per pub life cycle
                if (!MeAwarded) {
                    MeAwarded = true; //pub level variable
                    AppLogModel.LogDebug('PubMeModel::calculateActualMeGUI', 'Calculated = PubType me for 1st sub cycle ', pubId);      
                    pubMe.CalculatedME__c = pubTypeMe * writingScopeFactor;       //only 1st sub cycle get Full ME 
                } else {
                    pubMe.CalculatedME__c = pubTypeMePlus * writingScopeFactor;   //rest get ME Plus
                    AppLogModel.LogDebug('PubMeModel::calculateActualMeGUI', 'Calculated = PubType me Plus '+pubMe.CalculatedME__c, pubId);     
                }
                
                //**SESHA: During Resent workflow, the PubStatus already exists due to a PubStatus transaction. 
                //During Submitted/Completed workflow, pubMe.PubStatus__c is assigned the PubStatus Id for a Submitted/Completed transaction in  AwardMeForSubmittedCompleted()
                //but it is kind of within the current logical flow hasn't been committed to the DB. Hence, pubMe.PubStatus__c will be NULL. We need to assign Submitted/Completed at this time.
                pubMe.ME_Status__c =  (pubMe.PubStatus__c != null ? pubStatusModel.getPubStatus(pubMe.PubStatus__c).Status__r.Name : pubMe.PubStatus__c );
                pubMe.IsResend__c = (pubMe.ME_Status__c == StatusModel.ResentStatus ? true : false); //Flag Typically Used for Adhoc Reporting
                 
                AppLogModel.LogDebug('PubMeModel::calculateActualMeGUI', 'pubMe.ME_Status__c = '+pubMe.ME_Status__c, pubId);                          
                                
                //Def #711.  Found while preparing for Release 1.3
                if ( pubMe.OverrideME__c == null || pubMe.OverrideME__c == 0.0){
                    pubMe.Actual_ME_GUI__c = pubMe.CalculatedME__c ;
                } else {
                    pubMe.Actual_ME_GUI__c = pubMe.OverrideME__c;
                }  
                
            } else {
                AppLogModel.LogDebug('PubMeModel::calculateActualMeGUI', 'Going to ELSE (line 347) '+currentTotalCycle+', '+meTotalCycle+', '+
                                        isWritingCoordinatorRole, pubId);
                //not a WC - just give them 0 ME
                //pubMe.ME_Status__c = '';
                pubMe.ME_Status__c =  (pubMe.PubStatus__c != null ? pubStatusModel.getPubStatus(pubMe.PubStatus__c).Status__r.Name : pubMe.PubStatus__c );
                pubMe.IsResend__c = (pubMe.ME_Status__c == StatusModel.ResentStatus ? true : false); //Flag Typically Used for Adhoc Reporting
                
                if ( pubMe.OverrideME__c <= 0.0) {
                    pubMe.CalculatedME__c = 0.0;
                    pubMe.Actual_ME_GUI__c = 0.0;
                } else {
                    pubMe.CalculatedME__c = 0.0;
                    pubMe.Actual_ME_GUI__c = pubMe.OverrideME__c;
                }
            }
            
            AppLogModel.LogDebug('PubMeModel::calculateActualMeGUI', 
                '\n\t\t Team Member = '+ PubMe.WritingRoleMember__r.name +
                '\n\t\t IsWritingCoordinatorRole = '+ isWritingCoordinatorRole +
                '\n\t\t ME_Status__c = ' + pubMe.ME_Status__c + 
                '\n\t\t ME Type = '+ pubMe.MeType__c + 
                '\n\t\t SubmissionCycleNum= ' + pubMe.Submission_Cycle__r.Submission_Cycle_Num__c + 
                '\n\t\t MECycleNum= ' + pubMe.MeCycleNum__c +
                '\n\t\t Cal/override/actual=' + pubMe.CalculatedME__c +'/'+ pubMe.OverrideME__c + '/'+ pubMe.ActualME__c, pubId);
        }
        
        //fill in the blank pubStatus
        //may need to a more complex one that find out if an SC/FC combo is SubmitCompleted or Resend
        string lastStatus = '';
        for(PubMe__c pubMe : PubMeList) {
            if (pubME.ME_Status__c == '') {
                pubME.ME_Status__c = lastStatus;
            } else {
                lastStatus = pubME.ME_Status__c;
            }
        }
        
        Id CurrentFprCycleId = null;
        if (CurrentFprCycle <> null ) {
            CurrentFprCycleId = CurrentFprCycle.Id;
        }       
        
        for(PubMe__c pubMe : PubMeList) {
            //after a reject - Writing Role Records will be added to the next submission cycle - make sure those are NOT Calculated as well
            if ( pubMe.Submission_Cycle__r.Submission_Cycle_Num__c > PubCurrentSubmissionCycleNum) {
                AppLogModel.LogInfo('PubMeModel::calculateActualMeGUI', 'ME SC Num > Pub SC Num -> Zero ME '+ 
                    pubMe.Submission_Cycle__r.Submission_Cycle_Num__c + ' : '+ PubCurrentSubmissionCycleNum, pubId);
                pubMe.CalculatedME__c = 0.0;    
                pubMe.Actual_ME_GUI__c = 0.0;   
                pubMe.ME_Status__c = '';                    
            }
        }
                
        calcPlanningMe();
        resetIsSelected();
        
        AppLogModel.flushLogs();
        
        return null;
    }
    
    public id findPubStatusId(PubMe__c pubMe) {
        for(PubStatus__c ps : pubStatusModel.PubStatusList){
            if ( ps.Submission_Cycle__c == pubMe.Submission_Cycle__c && ps.FPR_Cycle__c == pubMe.FPR_Cycle__c && ps.Status__r.name == pubMe.ME_Status__c) {
                return ps.id;
            } else {
                /*
                AppLogModel.LogDebug('PubMeModel::recalculate', 'does not match '+
                    ps.Status__r.name + ' : ' + ps.Submission_Cycle__c + ' : ' + ps.FPR_Cycle__c );
                */
            }
        }
        AppLogModel.LogError('PubMeModel::recalculate', 'cannot find matching PubStatus record for '+
            pubMe.ME_Status__c + ' : ' + pubMe.Submission_Cycle__c + ' : ' + pubMe.FPR_Cycle__c, pubId );
        return null;
    }
    
    boolean needsConfirmationToSaveWritingRoles = false;
    public PageReference save() {       
        string pubStage = pubRecord.pubStatus__r.status__r.stage__c;
        List<sObject> updateObjList = new List<sObject>();
        Integer maxIntTotalMECycle = 0;
        
        for(PubME__c pubMeCycle :  PubMeList) {
            if(pubMeCycle.MeCycleNum__c > maxIntTotalMECycle){
                maxIntTotalMECycle = Integer.valueOf(pubMeCycle.MeCycleNum__c);
            }
        }
        
        boolean confirmedExpiredValue = false;
        for(PubME__c pubME : pPubMeList){
            
            //fix data in case user type in blank or negative ME
            if (pubME.OverrideME__c == null || pubME.OverrideME__c < 0.0) {
                pubME.OverrideME__c = 0.0;
            }

            if (pubME.OverrideME__c > 0.0 && pubME.ReasonForMEChange__c == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                'Any Adjusted ME Requires a Reason for Change');
                ApexPages.addMessage(myMsg);    
                AppLogModel.LogError('PubMeModel::save', 'Any Adjusted ME Requires a Reason for Change', pubId);
                return null;
            } else if (pubME.OverrideME__c > 0.0 && pubME.ReasonForMEChange__c != null) {
                pubMe.Actual_ME_GUI__c = pubME.OverrideME__c;
                pubME.ActualME__c = pubME.OverrideME__c;
            }
            
             if(pubME.Submission_Cycle__c == CurrentSubmissionCycle.id && pubME.PubStatus__r.Status__r.Name == StatusModel.SubmittedCompletedStatus) {
                pubME.isSubmissionCycleSubmitted__c = true;
            }
            
            //Check for Expired Department and Company values: WARNING
            if((pubME.Department__c != null && DepartmentModel.getDepartmentById(pubME.Department__c).isLogicallyDeleted__c) || 
                (pubME.Organization__c != null && OrganizationModel.getOrganizationById(pubME.Organization__c).isLogicallyDeleted__c)){
                confirmedExpiredValue = true;
            }
            
            if(!needsConfirmationToSaveWritingRoles && confirmedExpiredValue)
            {
                ApexPages.Message myMsgOne = new ApexPages.Message(ApexPages.Severity.WARNING, 'There are Expired Departments or Companies as Writing Role Member record(s). If you wish to continue saving the data, please click the "Save" button again.');
                ApexPages.addMessage(myMsgOne);
                AppLogModel.flushLogs();
                needsConfirmationToSaveWritingRoles = true;
                return null;
            }
            
            /* TO BE USED DURING DEBUGGING ONLY - SESHA :)
            AppLogModel.LogDebug('PubMeModel::save()', 
                '\n ME Cycle Num='+pubME.MeCycleNum__c+
                '\n PubMe.Submission_Cycle__c='+pubME.Submission_Cycle__c+
                '\n CurrentSubmissionCycle.id='+CurrentSubmissionCycle.id+
                '\n Publication Stage='+pubStage+'; '+pubRecord.pubStatus__r.status__r.name+
                '\n Actual ME='+pubME.ActualME__c+
                '\n Pub Status of ME='+pubME.PubStatus__r.Status__r.Name+
                '\n ME Status on UI='+pubME.ME_Status__c+
                '\n Actual_ME_GUI__c='+pubME.Actual_ME_GUI__c);*/
            
            updateObjList.add(pubME);       
        }
        
        calculateActualMeGUI();
        
        calculateCummulativeME();
        
        updateObjList.add(pubRecord);  //Save the MeScopeOfWork, Planned ME / Cumulative ME
        
        database.update(updateObjList, true);
        pubModel.resetSharing();
        ShowGUIvsDB = false;
        return null;
    }
    
    public void calculateCummulativeME() {
        decimal cumulativeME = 0.0;
        for(PubMe__c pubMe : PubMeList) {
            if (pubME.ActualME__c <> null && pubME.ActualME__c <> 0.0) {
                cumulativeME =  cumulativeME + pubMe.ActualME__c;
            }

            AppLogModel.LogInfo('PubMeModel::calculateCummulativeME', 'cumulativeME for '+cumulativeME);
        }
        
        pubRecord.CumulativeME__c = cumulativeME;
    }
    
    public PageReference cancel() {
        //pNewPubWritingRoleMembers = null;
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    //Adding new team members from the UI
    private PubME__c pNewPubWritingRoleMembers = null;
    public PubME__c NewPubWritingRoleMembers { //insert from model
        get {
            if (pNewPubWritingRoleMembers == null) {                
                pNewPubWritingRoleMembers = new PubME__c();
                pNewPubWritingRoleMembers.Publication__c = PubId;
                pNewPubWritingRoleMembers.Submission_Cycle__c = CurrentSubmissionCycle.id;
                if ( CurrentFprCycle <> null) {
                    pNewPubWritingRoleMembers.FPR_Cycle__c = CurrentFprCycle.id;
                }
                pNewPubWritingRoleMembers.ActualME__c = 0.0;
                pNewPubWritingRoleMembers.Actual_ME_GUI__c = 0.0;
                pNewPubWritingRoleMembers.CalculatedME__c = 0.0;
                pNewPubWritingRoleMembers.LegacyPrior_ActualME__c = 0.0;
                pNewPubWritingRoleMembers.OverrideME__c = 0.0;
                pNewPubWritingRoleMembers.ReasonForMEChange__c = '';
            }
            return pNewPubWritingRoleMembers;
        }
        set {
            pNewPubWritingRoleMembers = value;
        }
    }
    
    public PageReference deleteSelected() {
        List<PubME__c> delMEs = new List<PubME__c>();
        for(PubME__c me : pPubMeList){
            if ( me.isSelected__c ){
                delMEs.add(me);
            }
        }
        delete delMEs;
        
        pPubMeList = null;
        AppLogModel.flushLogs();
        pubModel.resetSharingPubMe();/*Implemented as part of Release 1 Appear Enhancement*/
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }  
    
    private void resetIsSelected() {
        for(PubME__c me : pPubMeList) {
            me.IsSelected__c = false;
        }
    }
    
    /*Code Implemented as Part of Release 1 Appear Enhancement Start*/
     Public void addWriterDuringCloneandCreate(Id PubId,Id userId){
         System.debug('---Entered the add writing role method.');
         Set<id> appearUserSet = AppearContactModel.findContactForAppearUser(userId);
         List<id> AppearUserIdList = new List<id>();
         AppearUserIdList.addAll(appearUserSet);
         Id myContactId = AppearUserIdList[0];
         
         PubMe__c pubMe= New PubMe__c();
         pubMe.WritingRoleMember__c=myContactId;
         pubMe.Publication__c=PubId;
         Publication__c pubSubCycle=[Select Current_SubmissionCycle_Id_Formula__c from Publication__c where Id=:PubId];
         pubMe.Submission_Cycle__c=pubSubCycle.Current_SubmissionCycle_Id_Formula__c;
         //pubMe.ActualME__c = 0.0; //Appear Enhancement R2: Cloning Functionality
         Appear_Role__c role=[Select Id from Appear_Role__c where Name='Writer' and isWritingRole__c =true];
         pubMe.AppearRole__c=role.Id;
         Try{
            insert PubMe;
            system.debug('Writing Role member is successfully inserted');
         }catch(System.Dmlexception dmle){
            if (!dmle.getMessage().contains('INSUFFICIENT_ACCESS_OR_READONLY')) {  //if the user dont have access on pub - ignore the error
                    throw dmle;
                }
         }
         
     }
     
     Public Void saveWritingRoleDuringClone(Id origPubId, Id ClonePubId){
        system.debug('Cloned Pub Id inside method'+ clonePubId);
        system.debug('Original Pub Id inside method'+ OrigPubId);
        String str='Writing Coordinator';
        List<PubMe__c> pubMeMember= [Select AppearRole__c,WritingRoleMember__c from PubMe__c where Publication__c=:origPubId and IsCurrentSubmissionCycleForPub__c=true and AppearRole__r.Name=:str order by LastModifiedDate DESC limit 1];
        
        if(pubMeMember.size()>0){
            System.debug('++++'+pubMeMember[0].AppearRole__c);
            System.debug('++++'+pubMeMember[0].WritingRoleMember__c);
            PubMe__c pubMeEW= New PubMe__c();
            pubMeEW.AppearRole__c=pubMeMember[0].AppearRole__c;
            pubMeEW.WritingRoleMember__c =pubMeMember[0].WritingRoleMember__c ;
            Publication__c pubSubCycle=[Select Current_SubmissionCycle_Id_Formula__c from Publication__c where Id=:ClonePubId];
            pubMeEW.Submission_Cycle__c=pubSubCycle.Current_SubmissionCycle_Id_Formula__c;
            //pubMeEW.ActualME__c = 0.0; //Appear Enhancement R2: Cloning Functionality
            pubMeEW.Publication__c=ClonePubId;
            try{
                Database.insert(pubMeEW);
                system.debug('Hello successfully created '+pubMeEW);
                }catch(System.Dmlexception dmle){
                    if (!dmle.getMessage().contains('INSUFFICIENT_ACCESS_OR_READONLY')) {  //if the user dont have access on pub - ignore the error
                    throw dmle;
                 }
            }
        }
     }
     //End
    
    boolean needsConfirmToSaveWritingRole = false;
    public PageReference saveNewWritingRoleMember() {
        boolean confirmedExpiredValue = false;
        Department__c writingRoleDept = null;
        Organization__c writingRoleCompany = null;
        
        if(pNewPubWritingRoleMembers != null && pNewPubWritingRoleMembers.Department__c  != null) {
            writingRoleDept = DepartmentModel.getDepartmentById(pNewPubWritingRoleMembers.Department__c);
        }
            
        if(pNewPubWritingRoleMembers != null && pNewPubWritingRoleMembers.Organization__c  != null) {
            writingRoleCompany = OrganizationModel.getOrganizationById(pNewPubWritingRoleMembers.Organization__c);
        }
        
        if((writingRoleDept != null && writingRoleDept.isLogicallyDeleted__c) || (writingRoleCompany != null && writingRoleCompany.isLogicallyDeleted__c)){
            confirmedExpiredValue = true;
        }
        
        if(!needsConfirmToSaveWritingRole && confirmedExpiredValue)
        {
            ApexPages.Message myMsgOne = new ApexPages.Message(ApexPages.Severity.WARNING, 'You have selected an Expired Department or Company as a Writing Role Member record. If you wish to save the record, please click the "New" button once again and then click "Save".');
            ApexPages.addMessage(myMsgOne);
            AppLogModel.flushLogs();
            needsConfirmToSaveWritingRole = true;
            return null;
        }
        
        if ( CurrentFprCycle == null ) {
            string errorMsg = 'Need a valid FPR Cycle before saving Writing Role.  Please Submit for FPR before saving';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMsg);
            ApexPages.addMessage(myMsg);    
            AppLogModel.LogError('PubMeModel::save', errorMsg);
            AppLogModel.flushLogs();
            return null;
        }
        
        if ( pNewPubWritingRoleMembers.AppearRole__c == null){
            //error do not save
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                'Cannot create New Writing Role Member record. Please select a Writing Role for the Writing Role Record');
            ApexPages.addMessage(myMsg);    
            AppLogModel.LogError('PubMeModel::saveNewWritingRoleMember', 'Cannot create New Writing Role Member record. Please select a Writing Role for the Writing Role Record'); 
            AppLogModel.flushLogs();
            return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
        }
        
        //CR 108: If a Contact is chosen, system will fetch the Employee Type if it exists
        String contactEmpTypeStr = AppearContactModel.findContactEmployeeType(pNewPubWritingRoleMembers.WritingRoleMember__c);
        If (contactEmpTypeStr <> null) {
            pNewPubWritingRoleMembers.Emp_Type__c = contactEmpTypeStr;
        }
        
        //determine ME Cycle # - find current max ME Cycle #
        //Find Max ME
        integer MaxMeCycleNum = 0;
        integer tempVariableToCheck1 = 0; //Variable to used Only during Manual Addition of Writing Roles
        integer tempVariableToCheck2 = 0; //Variable to used Only during Manual Addition of Writing Roles
        Id tmpPubStatus;
        Map<id, PubStatus__c> tmpPubStatusMap = pubStatusModel.PubStatusMap;
        
        /**SESHA: Added functionality to find out if the Writing Role Record that is being added is infact after the Submitted/Completed or Resent Status update. 
        If the record is being created for the 1st time after a Submitted/Completed status update, then we loop through the PubStatusList Object to find
        the Submitted/Completed status with Actual Date <> null and assign it to the PubMe.PubStatus
        **/ 
        if(PubMeList.size() > 0) 
        {
            for(PubMe__c pubme : PubMeList) {
                tempVariableToCheck1 = 0;
                
                if (pubme.MeCycleNum__c > MaxMeCycleNum) {
                    MaxMeCycleNum = Integer.valueOf(pubme.MeCycleNum__c);
                }
                
                System.debug('@@@@Sub cycle'+Integer.valueOf(pubme.Submission_Cycle__r.Submission_Cycle_Num__c));
                System.debug('@@@@@FPR Cycle'+Integer.valueOf(pubme.FPR_Cycle__r.FPR_Cycle_Num__c));
                System.debug('@@@@@MEcycle'+MaxMeCycleNum);
                
                tempVariableToCheck1 = Integer.valueOf(pubme.Submission_Cycle__r.Submission_Cycle_Num__c) + Integer.valueOf((pubme.FPR_Cycle__r.FPR_Cycle_Num__c != null) ? pubme.FPR_Cycle__r.FPR_Cycle_Num__c : 1) + MaxMeCycleNum;
                
                tmpPubStatus = pubme.PubStatus__c; //Use the final PubStatus while insert the new Writing Role Record
            }
        } else {
            for (PubStatus__c pubStatusObj : pubStatusModel.PubStatusList) {
                if(pubStatusObj.Status__c == StatusModel.SubmittedCompleted.Id && pubStatusObj.ActualDate__c <> null) {
                    tmpPubStatus = pubStatusObj.Id; 
                }               
            }
        }
        
        tempVariableToCheck2 = Integer.valueOf(CurrentSubmissionCycle.Submission_Cycle_Num__c) + Integer.valueOf(CurrentFprCycle.FPR_Cycle_Num__c) + MaxMeCycleNum;
        
        AppLogModel.LogInfo('PubMeModel::saveNewWritingRoleMember', 'tempVariableToCheck1 = ' + tempVariableToCheck1 + ' and tempVariableToCheck2 = ' + tempVariableToCheck1);
        
        //Problem: When users delete all the Writing Roles from a Publication after a Publication Rejection and subsequent Submission Cycle (i.e. changing Target),
        //this problem happens. When user tries add new Writing Role Members, System makes the ME Cycle Num equals to the previous value.
        //Solution: This logic fixes the problem.   
        if (tempVariableToCheck1 != tempVariableToCheck2) {
            MaxMeCycleNum = MaxMeCycleNum + 1;
        }
                
        pNewPubWritingRoleMembers.MeCycleNum__c = MaxMeCycleNum;
        
        //Choose the latest PubStatus and Assign it to the new writing role record that is being created by the user to avoid problem with 
        //blank PubStatus Reference in the PubME
        pNewPubWritingRoleMembers.PubStatus__c = tmpPubStatus;
        
        if (tmpPubStatusMap.containsKey(tmpPubStatus)) {
            PubStatus__c oPubStatus = tmpPubStatusMap.get(tmpPubStatus);
            pNewPubWritingRoleMembers.ME_Status__c = oPubStatus.Status__r.Name;
            pNewPubWritingRoleMembers.isSubmissionCycleSubmitted__c = (oPubStatus.Status__r.Name == StatusModel.SubmittedCompletedStatus ? true : false );            
        }
        
        insert pNewPubWritingRoleMembers;   
        AppLogModel.LogInfo('PubMeModel::saveNewWritingRoleMember', 'Inserted new PubWritingRoleMembers(s) / PubME : ' + pNewPubWritingRoleMembers);
        AppLogModel.flushLogs(); 
        /*Code Implemented as Part of Appear Enhancement Release 1*/    
        pubModel.resetSharingPubMe(); 
        pPubMeList = null;
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    
    }
    
    public List<PubME__c> getPubMeSubmitCycles(id PubId, Id CurrentSubmissionCycleId){
        List<PubME__c> result = getPubMeAllSubmitCycles(pubId, CurrentSubmissionCycleId);
        
        List<PubMe__c> currentCycleResult = new List<PubME__c>();
        for(PubMe__c me : result){
            if (me.Submission_Cycle__c == CurrentSubmissionCycleId ) {
                currentCycleResult.add(me);
            }
        }

        return currentCycleResult;
    }
    
    
    private boolean pFirstFprCycleSet = false;
    private FPR_Cycle__c pFirstFprCycle = null;
    public FPR_Cycle__c FirstFprCycle {
        get {
            if ( !pFirstFprCycleSet ) {
                pFirstFprCycleSet = true;
                pFirstFprCycle = FprCycleModel.getFprCycleByNum(pubId, 1);
            }
            return pFirstFprCycle;
        }
    } 
    
    //getPubMeAllSubmitCycles will return Pub ME Writing Roles for all Submission Cycles
    //in addition, it will dynamically set the me.isSubmissionCycleSubmitted__c = true based on the current Submission Cycle
    public List<PubME__c> getPubMeAllSubmitCycles(id PubId, Id CurrentSubmissionCycleId){
        List<PubME__c> result = PubMeForPub(pubId);     
        List<PubMe__c> updateME = new List<PubME__c>();
        
        /* SESHA : OUTDATED CODE
        for(PubMe__c me : result) {
            if (me.FPR_Cycle__c == null) {
                me.FPR_Cycle__c = FirstFprCycle.id;
                updateME.add(me);
            }
        }
        
        if (updateME.size() > 0 ){
            database.update(updateME,false);    
            result = PubMeForPub(pubId);
        }
        
        //Dynamically update the isSubmissionCycleSubmitted__c
        result = updateMeIsSubmissionCycleSubmitted(result, CurrentSubmissionCycleId);
        
        //Debug
        for(PubME__c me : result) {
            string msg = 'SC='+me.Submission_Cycle__r.Submission_Cycle_Num__c +
                +' FC='+me.FPR_Cycle__r.FPR_Cycle_Num__c +
                +' Calculated=' + me.CalculatedME__c +
                +' Override=' + me.OverRideME__c + 
                +' Actual=' + me.ActualME__c +
                +' Role='+ me.AppearRole__r.name;
            AppLogModel.LogInfo('PubMeModel::getPubMeAllSubmitCycles', msg);
        }
        
        AppLogModel.LogInfo('PubMeModel::getPubMeAllSubmitCycles:total', 'Total PubMe Returned = ' + result.size() );
        
        AppLogModel.flushLogs();
        */
        
        return result;
    }
    
    private string pSelectedAssignToOption = 'contact';
    public string assignedTo{
        get{
            return pSelectedAssignToOption;
        }
        set{
            pSelectedAssignToOption = value;
        }
    }
    
    private List<SelectOption> pAssignToOptions;
    public List<SelectOption> getassignToOpt() {
        if (pAssignToOptions == null) {
            pAssignToOptions = new List<SelectOption>();
            
            pAssignToOptions.add(new SelectOption('contact', '1. Contact'));
            pAssignToOptions.add(new SelectOption('department', '2. Department'));
            pAssignToOptions.add(new SelectOption('organization', '3. Company'));
        }
        
        return pAssignToOptions;
    }
    
    private List<PubME__c> PubMeForPub(Id PubId) {
        List<PubME__c> result = [
            select id, name, 
            Submission_Cycle__c, Submission_Cycle__r.Submission_Cycle_Num__c,
            FPR_Cycle__c, FPR_Cycle__r.FPR_Cycle_Num__c,
            WritingRoleMember__r.name,WritingRoleMember__c,WritingRoleMember__r.UserId__c,/*WritingRoleMember__c,WritingRoleMember__r.UserId__c, fields as per Release 1 Appear enhancement*/
            Department__r.name,
            Department__r.isLogicallyDeleted__c,
            Organization__r.Name, //Updated for CR #108
            Organization__r.isLogicallyDeleted__c,
            Emp_Type__c, //Added for CR #108
            PubStatus__c, //Added for CR #108
            PubStatus__r.Status__r.Name, //Need this for validation
            AppearRole__c, AppearRole__r.name, Actual_ME_GUI__c, MeCycleNum__c,
            ReasonForMEChange__c, LegacyPrior_ActualME__c, MeType__c, ME_Status__c,Siebel_Actual__c,
            ActualME__c, CalculatedME__c, OverRideME__c, isSelected__c, isSubmissionCycleSubmitted__c,
            CreatedBy.name, CreatedDate, lastmodifiedBy.name, lastModifiedDate
            from PubME__c
            where Publication__c = :PubId
            // do not change name to desc order - the recalc algorithm depends on the right order
            //order by name since name is an auto number - will use this order to pick the first Writing Coordinator
            order by Submission_Cycle_Num_Formula__c, FPR_Cycle_sort_num__c, MeCycleNum__c, AppearRole__r.DisplayOrder__c, name
        ];
        return result;
    }
    
    public List<PubME__c> updateMeIsSubmissionCycleSubmitted(List<PubME__c> pubMeList, id CurrentSubmissionCycleId ) {
        if ( pubMeList == null || pubMeList.size() == 0 ) {
            AppLogModel.LogError('PubMeModel::updateMeIsSubmissionCycleSubmitted', 'Abort : PubMeList == Null');
            AppLogModel.flushLogs();
            return new List<PubME__c>();
        }
        
        if (CurrentStatusId == null ) {
            //without a currentStatus, appear cannot determin if the submissionCycle has been submited.
            
            AppLogModel.LogError('PubMeModel::updateMeIsSubmissionCycleSubmitted', 
                'without a currentStatus, appear cannot determine if the submissionCycle has been submited.',
                pubMeList[0].publication__c);
            AppLogModel.flushLogs();
            return pubMeList;
        }
        
        AppLogModel.LogDebug('PubMeModel::updateMeIsSubmissionCycleSubmitted','Current Status = '+StatusModel.StatusMapById.get(CurrentStatusId).name, pubId );
        boolean isCurrentSubCycleSubmitted = StatusModel.submittedStatusIdSet.contains(CurrentStatusId);
        AppLogModel.LogDebug('PubMeModel::updateMeIsSubmissionCycleSubmitted','Current Submission Cycle Submitted = ' + isCurrentSubCycleSubmitted, pubId);
        
        List<PubME__c> result = new List<PubME__c>();
        for(PubME__c me : pubMeList ) {
            if ( me.Submission_Cycle__c <> CurrentSubmissionCycleId)   {
                //always show for previous cycle
                me.isSubmissionCycleSubmitted__c = true;    
            }
            
            result.add(me);
            
            AppLogModel.LogDebug('PubMeModel::updateMeIsSubmissionCycleSubmitted','    PubMe.isSubmissionCycleSubmitted__c = '+me.isSubmissionCycleSubmitted__c );
        }
        
        return result;
    }

    public List<PubME__C> copyMEforNonMaterialChange(Id resentPubStatusId) {
        AppLogModel.LogInfo('PubMeModel::copyMEforNonMaterialChange', 'invoking copyMEforNonMaterialChange - PubMeList # of records = ' +
            PubMeList.size());
            
        return PubMeModelNoSharing.copyMEforNonMaterialChange(PubMeList, PubId, resentPubStatusId); 
    }
    
    //created for deployment - to be deleted
    public List<PubME__C> copyMEforResent(integer fromFprCycleNum, integer toFprCycleNum) {
        return null;
    }
    
    public List<PubME__C> copyMEforMaterialChange(integer fromFprCycleNum, integer toFprCycleNum, Id resentPubStatusId) {  //reviewer for the current submission cycle
        
        AppLogModel.LogInfo('PubMeModel::copyMEforResent', 'invoking copyMEforResent - PubMeList # of records = ' +
            PubMeList.size());
            
        FPR_Cycle__c fromFprCycle=FprCycleModel.getFprCycleByNum(PubId, fromFprCycleNum);
        FPR_Cycle__c toFprCycle=FprCycleModel.getFprCycleByNum(PubId, toFprCycleNum);
    
        return PubMeModelNoSharing.copyMEforMaterialChange(PubMeList, PubId, CurrentSubmissionCycle, fromFprCycle, CurrentSubmissionCycle, toFprCycle, resentPubStatusId);
    }   
    
    
    public List<PubME__C> copyMEforNewSubmissionCycle(SubmissionCycle__c nextSubCycle, FPR_Cycle__c nextFprCycle) { 
        return null;
    }

    public List<PubME__C> copyMEforNewSubmissionCycle(SubmissionCycle__c nextSubCycle, FPR_Cycle__c nextFprCycle, id PubStatusId) { 
        
        AppLogModel.LogInfo('PubMeModel::copyMEforNewSubmissionCycle', 'invoking copyMEforNewSubmissionCycle - PubMeList # of records = ' + PubMeList.size());
        /**CCB 258 (SESHA): During the addition of a new "Material Change for New Target" or "Non-Material Change for New Target" after a "Rejection", system will increment the SC thereby making the
        CurrentSubmissionCycle at the Publication Level to increase. If this happens, PubME during a new Submission Cycle change via change in the Target will not copy over the previous Writing Records.
        In order to make the ME logic to work for a New Submitted/Completed, we need to send in the previous Submission Cycle ONLY when there is a Change in Target after a 
        "Material Change for New Target" or "Non-Material Change for New Target" with an Actual Date
        */
        integer submissionCycleNum;
        if (pubModel.CurrentSubmissionCycleHasMaterialChangeforSubsequentSubmissionStatusWithActualDate || 
                    pubModel.CurrentSubmissionCycleHasNonMaterialChangeforSubsequentSubmissionStatusWithActualDate) {
            submissionCycleNum = Integer.ValueOf(nextSubCycle.Submission_Cycle_Num__c) - 1; 
            CurrentSubmissionCycle = pubModel.SubmissionCycle.getSubmissionCycleByNum(submissionCycleNum);
        }
        
        return PubMeModelNoSharing.copyMEforNewSubmissionCycle(PubMeList, PubId, CurrentSubmissionCycle, nextSubCycle, nextFprCycle, PubStatusId);
    }
}