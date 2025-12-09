public with sharing class PubReviewTeamModel {

    private id PubId;
    private AppearPubModel pubModel;
    private string ActiveTile;
    private string ActiveSubMenu;
    
    public final static string commentsVote = 'Comments';
    public final static string noCommentsVote = 'No Comments';
    public final static string voteNotAvailable = 'Vote Not Available'; 
    
    /**
    Created By: Sesha
    Created Date: 4/25/2014
    Description: This function takes Publication Review Team Member List to fetch all the attachments of the proxies for and by if they exist as a chain.
    Returns: Map<Id, List<PubAttachmentDetails__c>>
    */
    private transient Map<Id, List<PubAttachmentDetails__c>> pReviewAttachmentMap = null; 
    public Map<Id, List<PubAttachmentDetails__c>> getReviewAttachmentMap() {
        if (pReviewAttachmentMap == null) {
            pReviewAttachmentMap = new Map<Id, List<PubAttachmentDetails__c>>();
    
            for (PubReviewTeam__c reviewer : PubReviewTeamMembers) {
                if(reviewer.SubType__c == 'Proxy' || reviewer.ProxyMember__c != null) {
                    pReviewAttachmentMap.put(reviewer.id, PubAttachmentModel.getAttachmentDetailsForProxyChain(reviewer));
                }   else {
                    pReviewAttachmentMap.put(reviewer.id, reviewer.Attachment_Details__r);
                }
            }
        }
        
        //Sometimes, the MAP doesn't contain any attachments for the Reviewers
        //Need to return the Null MAP to avoid Error on the screen during showAllReviewers operation.
        for (PubReviewTeam__c reviewer : PubReviewTeamMembers) {
            if(!pReviewAttachmentMap.containsKey(reviewer.Id)){
                return null;
            }
        }
        
        return pReviewAttachmentMap;
    } 

    //Def#244
    //The button will be visible to the FPRC/IFPRC/BA/SA after the Publication is in "Assigned to FPRC" status with Actual Date
    public boolean showRegenerateReviewerButton {
        get {
            
    
            if ( ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC || ProfileModel.isAppearBusinessAdmin || ProfileModel.isSysAdmin) {
                if ( pubModel.CurrentStatus == StatusModel.AssignedToFprcStatus && pubModel.PubRecord.PubStatus__r.ActualDate__c <> null)  {
                    return true;
                }
            }   
            
            return false;   
        }
    }
    
    //#Def#244
    public PageReference regenerateReviewers() {
        AppLogModel.LogInfo('PubReviewTeamModel::regenerateReviewers', 'regenerateReviewers for '+pubModel.PubName + ' initiated by '+ UserInfo.getName(), PubId);
        
        if (pubModel.pubRecord.Route_Pattern__c == pubModel.CurrentRoutePattern ) {
            
            string warningMsg = 'Product Indication or Data Source or Sub Group combination needs to be modified before refreshing the Reviewer List';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, warningMsg);
            ApexPages.addMessage(myMsg);    
            
            string extendedWarningMsg = 'Current Route Pattern = '+pubModel.CurrentRoutePattern;
            AppLogModel.LogError('PubReviewTeamModel::regenerateReviewers', warningMsg+extendedWarningMsg, PubId); 
            
            AppLogModel.flushLogs();
            return null;
        }
        
        
        //delete all generated PubReviewers 
        boolean excludeHasProxy = false;
        List<PubReviewTeam__c> generatedPubReviewers = new List<PubReviewTeam__c>();
        
        for (PubReviewTeam__c prt : getReviewTeamMembersCurrentCycle(this.PubId, this.pubModel, excludeHasProxy)) {
            /* 
            //This is not required. There is no business need to retain adhoc Reviewers and Auto-Generated Reviewers that were 
            //added prior to the regeneration of current Reviewers based on new PI/DS/SG combination. 
            //Hence, this is being commented out [R3.0 - Defect 51]. - SESHA KURMANA (4/13/2014) 
            if (!prt.isFromDataSourceSubGroup__c) {
                continue;
            }*/
            prt.IsLogicallyDeleted__c = true;
            generatedPubReviewers.add(prt);
        }
        update generatedPubReviewers;
        
        
        CopyPubReviewTeamFromSubGroup(pubModel.FPRCycle.CurrentFprCycle);
    
        //Update Route Pattern
        pubModel.pubRecord.Route_Pattern__c = pubModel.CurrentRoutePattern;
        update pubModel.pubRecord;
        
        AppLogModel.flushLogs();
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    
    
    
    public void flushCache() {
        pshowCurrentCycleReviewer = true;       
    }
    
    private boolean pshowCurrentCycleReviewer;
    public boolean showCurrentCycleReviewer{
        get {
            if (pshowCurrentCycleReviewer == null) {
                pshowCurrentCycleReviewer = true;
            }
                    
            return pshowCurrentCycleReviewer;
        }
        set{
            pshowCurrentCycleReviewer = value;  
        }
    }
    
    public PageReference showAllReviewers() {
        showCurrentCycleReviewer = false;
        pPubReviewTeamMembers = null;
        PageReference pageRef = null;
        
        if(!Test.isRunningTest()) {//
        pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(false);
        
        }//
        return pageRef;
    }
    public PageReference showCurrentReviewersOnly() {
        showCurrentCycleReviewer = true;
        pPubReviewTeamMembers = null;
        PageReference pageRef = null;
        
        if (!Test.isRunningTest()) {//
        pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(false);
        
        }//
        return pageRef;
    }
    
    public boolean ShowRoutePattern {
        get {
            if (  PubReviewTeamMembers.size() > 0) {
                return true;
            } else {
                return false;
            }
        }
    }   
    
    public string RoutePatternUsedToGenerateReviewTeam {
        get {
            return pubModel.pubRecord.Route_Pattern__c;
        }
    }
    
    private List<SelectOption> pVoterOptions;
    public List<SelectOption> getVoterOptions() {
        if (pVoterOptions == null) {
            pVoterOptions = new List<SelectOption>();
            
            Schema.DescribeFieldResult fieldResult = PubReviewTeam__c.Reviewer_Status__c.getDescribe();
            List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
                
            for( Schema.PicklistEntry picklistEntry : entries)
            {
                if (picklistEntry.getLabel() == noCommentsVote || picklistEntry.getLabel() == commentsVote) {
                    if (!pubModel.IsCommentsOnly) {
                        continue;
                    }
                } else if (pubModel.IsCommentsOnly || picklistEntry.getLabel() == voteNotAvailable) {
                    continue;
                }
                
                pVoterOptions.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));                
            }
        }
        
        return pVoterOptions;
    }
    
    private transient List<PubReviewTeam__c> pPubReviewTeamMembers = null;
    public List<PubReviewTeam__c> PubReviewTeamMembers {  // depending on showCurrentCycleReviewer - return all cycles or just one
        get {
            if (pPubReviewTeamMembers == null) {
                //excludeHasProxy = true
                if ( showCurrentCycleReviewer) { 
                    pPubReviewTeamMembers = getReviewTeamMembersCurrentCycle(this.PubId, this.pubModel, true);
                } else {
                    pPubReviewTeamMembers = getReviewTeamMembers(this.PubId, true);
                }
            }
            return pPubReviewTeamMembers;  
        } 
    }
    
    
    
    private transient List<Id> pPubActiveAllCyclesReviewteamMemberUserIds = null;
    public List<Id> PubActiveAllCyclesReviewteamMemberUserIds {
        get {
            if ( pPubActiveAllCyclesReviewteamMemberUserIds == null) {
                
                pPubActiveAllCyclesReviewteamMemberUserIds = new List<id>();
                //exclude Proxy = false
                for(PubReviewTeam__c rtm : getReviewTeamMembers(this.PubId, false)) {
                    //if(!rtm.islogicallyDeleted__c) {
                        pPubActiveAllCyclesReviewteamMemberUserIds.add(rtm.Reviewer__r.UserId__c);
                    //}
                }
                string msg = 'pPubActiveAllCyclesReviewteamMemberUserIds found ' + 
                    pPubActiveAllCyclesReviewteamMemberUserIds.size()+' records for PubId = '+PubId;
                AppLogModel.LogInfo('PubReviewTeamModel::pPubActiveAllCyclesReviewteamMemberUserIds', msg, PubId);
            }
            return pPubActiveAllCyclesReviewteamMemberUserIds;
        }
    }


    //update the EmailToList & EmailCcList of  PubReviewTeamMember records of the current cycle/
    public void UpdateToCcListForCurrentCycleReviewer(string EmailToList, string EmailCcList) {
        List<PubReviewTeam__c> prtmCurrentCycle = getReviewTeamMembersCurrentCycle(this.PubId, this.pubModel, true);
        
        for(PubReviewTeam__c prtm : prtmCurrentCycle) {
            prtm.EmailToList__c = EmailToList;
            prtm.EmailCcList__c = EmailCcList;
        }
        update prtmCurrentCycle;
    }


    
    public PubReviewTeamModel(Id PubId, AppearpubModel pubModel, string tile, string subMenu) {
        this.PubId = PubId; 
        this.pubModel = pubModel;
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;
        this.showCurrentCycleReviewer = true;  // by default - only show current FPR Cycle
        this.selectedAddMethod = 'standard';
    }

    //to save it to database
    public PageReference save() {
        database.update(pPubReviewTeamMembers, true);
        
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    public string selectedAddMethod {get;set;}
    
    public List<SelectOption> getAddMethodItems() {
        List<SelectOption> options = new List<SelectOption>();
    
        options.add(new SelectOption('standard','Standard'));
        options.add(new SelectOption('triage','Triage'));
        options.add(new SelectOption('delegate','Delegate'));
        
        return options;
    }
    
        
    public string triagedById {get;set;}
    public string delegatedById {get;set;}
    
    public List<SelectOption> getAddedByItems() {
        List<SelectOption> options = new List<SelectOption>();      
        
        options.add(new SelectOption('', 'None'));
        for(PubReviewTeam__c teamMember : PubReviewTeamMembers) {
            
            if (teamMember.Type__c == 'Primary' && teamMember.FPR_Cycle__c == pubModel.pubRecord.Current_FPRCycle_Id_Formula__c) {
                options.add(new SelectOption(teamMember.Id, String.isBlank(teamMember.DisplayName__c )? teamMember.Reviewer__r.Name : teamMember.DisplayName__c));
            }
        }
        
        return options;
    }
    
    //Adding new team members from the UI
    private transient PubReviewTeam__c pNewPubReviewTeamMembers = null;
    public PubReviewTeam__c NewPubReviewTeamMembers { //insert from model
        get {
            if (pNewPubReviewTeamMembers == null) {             
                pNewPubReviewTeamMembers = new PubReviewTeam__c();
                pNewPubReviewTeamMembers.Publication__c = PubId;    
                pNewPubReviewTeamMembers.IsLogicallyDeleted__c = false; 
                pNewPubReviewTeamMembers.Type__c = 'Primary';
                pNewPubReviewTeamMembers.SubType__c = 'Standard';
                pNewPubReviewTeamMembers.FPR_Cycle__c = pubModel.pubRecord.Current_FPRCycle_Id_Formula__c;      
                    
            }
            return pNewPubReviewTeamMembers;
        }
        set {
            pNewPubReviewTeamMembers = value;
        }
    }
    
    //Defect #204
    public boolean pubStatusPastApprovedByAllAuthors() {        
        if ( pubModel.PubStatus.CurrentStatus.displayOrder__c >= StatusModel.AuthorApprovals.displayOrder__c) {
            return true;
        } else {
            return false;
        } 
    }
    
    public PageReference saveNewReviewTeamMember() {
        if ( pubModel.pubRecord.Current_FPRCycle_Id_Formula__c == null) {
            String msg = 'Cannot add a Review Team Member to this Publication since it is not in a FPR Cycle';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, msg);
            ApexPages.addMessage(myMsg);    
            AppLogModel.LogError('PubReviewTeamModel::saveNewReviewTeamMember', msg, PubId); 
            AppLogModel.flushLogs();
            
            return null;            
        }
        
        //Defect #204 - Do not allow Changes to Reviewer after Publication reaches Approved by All Authors
        if ( pubStatusPastApprovedByAllAuthors()) {
            String msg = 'Cannot add New Review Team Members to a publication once it has been Approved by All Authors.';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, msg);
            ApexPages.addMessage(myMsg);    
            AppLogModel.LogError('PubReviewTeamModel::saveNewReviewTeamMember', msg, PubId); 
            AppLogModel.flushLogs();
            
            return null;            
        }
        
        boolean saveResult = false;
        
        if ( selectedAddMethod == 'triage') {
            
            //code path for FPRC mocking triage
            if ( String.isBlank(triagedById) || String.isBlank(pNewPubReviewTeamMembers.Triage_Justification__c)) {
                String msg = 'To Triage, please define Triaged By and Justification';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, msg);
                ApexPages.addMessage(myMsg);
                
                return null;            
            }
            
            HierarchySettingsModel.updateOrgUrlCustomSetting();
            
            PubReviewTeam__c memberToUpdate;
            for(PubReviewTeam__c member : [Select Reviewer__c, SubType__c, ProxyMember__c from PubReviewTeam__c Where Id = :triagedById ]) {
                if (member.SubType__c == 'Proxy') {
                    List<PubReviewTeam__c> proxyChain = ProxyDelegateUtility.GetProxiesForAndProxiedBy(member); //Find bottom of proxy chain and set that as triageDelegatedBy
                    for(PubReviewTeam__c chainMember : proxyChain) {
                        if (chainMember.SubType__c != 'Proxy') {
                            pNewPubReviewTeamMembers.TriageDelegatedBy__c = chainMember.Reviewer__c;
                            break;
                        }
                    }
                } else {
                    pNewPubReviewTeamMembers.TriageDelegatedBy__c = member.Reviewer__c;
                }       
                memberToUpdate = member;
                break;
            } 
            saveResult = saveReviewTeamMember(true);    //isTriage = true
            
            if (memberToUpdate != null) {
                memberToUpdate.TriagedTo__c = pNewPubReviewTeamMembers.Id;
                update memberToUpdate;
            }
            
            
        } else if ( selectedAddMethod == 'delegate') {
            //code path for FPRC mocking triage
            if ( String.isBlank(delegatedById) || String.isBlank(pNewPubReviewTeamMembers.Delegation_Justification__c)) {
                String msg = 'To Delegate, please define Delegated By and Justification';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, msg);
                ApexPages.addMessage(myMsg);    
                AppLogModel.LogError('PubReviewTeamModel::saveNewReviewTeamMember', msg, PubId); 
                AppLogModel.flushLogs();
                
                return null;            
            }
            
            HierarchySettingsModel.updateOrgUrlCustomSetting();     
            
            PubReviewTeam__c delegatedBy;
            for(PubReviewTeam__c member : [Select Reviewer__c, Reviewer__r.Name, SubType__c, ProxyMember__c from PubReviewTeam__c Where Id = :delegatedById ]) {
                delegatedBy = member;
                ProxyDelegateUtility.lastDelegatedByName = member.Reviewer__r.Name;
                break;
            } 
            if (delegatedBy != null) {              
                pNewPubReviewTeamMembers.SubType__c = 'Delegate';
                saveResult = saveReviewTeamMember(false);   //isTriage = false
                
                ProxyDelegateUtility.ProxyDelegateCounter = 0; //reset counter to allow notify update to sync to proxy chain
                delegatedBy.DelegatedTo__c = pNewPubReviewTeamMembers.Id;
                delegatedBy.Type__c = 'Notify';
                update delegatedBy;              
            }
        } else {        
            HierarchySettingsModel.updateOrgUrlCustomSetting();
            saveResult = saveReviewTeamMember(false);   //isTriage = false
        }
        
        if ( saveResult) {
            return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
        } else {
            //error
            return null;
        }
    }
        
    public void clearCache() {
        pNewPubReviewTeamMembers = null;
    }
    
    public PageReference saveReviewTeamMemberTriage() {
        
        //Defect #204 - Do not allow Changes to Reviewer after Publication reaches Approved by All Authors
        if ( pubStatusPastApprovedByAllAuthors()) {
            String msg = 'Cannot Triage to new Review Team Members for this Publication since it has been Approved by All Authors';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, msg);
            ApexPages.addMessage(myMsg);    
            AppLogModel.LogError('PubReviewTeamModel::saveReviewTeamMemberTriage', msg, PubId); 
            AppLogModel.flushLogs();
            
            return null;            
        }
        
        if ( LoggedInTeamMemberForCycle != null) {
            if (LoggedInTeamMemberForCycle.SubType__c == 'Proxy') {
                List<PubReviewTeam__c> proxyChain = ProxyDelegateUtility.GetProxiesForAndProxiedBy(LoggedInTeamMemberForCycle); //Find bottom of proxy chain and set that as triageDelegatedBy
                for(PubReviewTeam__c chainMember : proxyChain) {
                    if (chainMember.SubType__c != 'Proxy') {
                        pNewPubReviewTeamMembers.TriageDelegatedBy__c = chainMember.Reviewer__c;
                        break;
                    }
                }
            } else {
                Set<Id> AppearUserContactIdSet = AppearContactModel.findContactForAppearUser(userInfo.getUserId());
                for (Id contactId :AppearUserContactIdSet ) {       
                    pNewPubReviewTeamMembers.TriageDelegatedBy__c = contactId;
                    break;
                }
            }       
            LoggedInTeamMemberForCycle.TriagedTo__c = pNewPubReviewTeamMembers.Id;
        }
        
        if ( pubModel.pubRecord.Current_FPRCycle_Id_Formula__c == null) {
            String msg = 'Cannot add a Review Team Member to this Publication since it is not in a FPR Cycle';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, msg);
            ApexPages.addMessage(myMsg);    
            AppLogModel.LogError('PubReviewTeamModel::saveNewReviewTeamMember', msg, PubId); 
            AppLogModel.flushLogs();
            
            return null;            
        }
        
        if ( saveReviewTeamMember(true)) {
            return new PageReference(AppearUrlModel.AppearFprMenuUrl(ActiveSubMenu, ActiveTile, PubId));
        } else {
            //error
            return null;
        }
    }
    
    private boolean saveReviewTeamMember(boolean isTriage) {
        
        if (pNewPubReviewTeamMembers.Reviewer__c == null || pNewPubReviewTeamMembers.Type__c == null ){
            if ( pNewPubReviewTeamMembers.Reviewer__c == null){
                //error do not save
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                    'Cannot create New Review Team Member record.  Please select a Team Member first');
                ApexPages.addMessage(myMsg);    
                AppLogModel.LogError('PubReviewTeamModel::saveNewReviewTeamMember', 'Cannot create New Review Team Member record.  Please select a Team Member first', PubId);
            }
            if ( pNewPubReviewTeamMembers.Type__c == null){
                //error do not save
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                    'Cannot create New Review Team Member record. Please select a Type [ Primary or Notify ]');
                ApexPages.addMessage(myMsg);    
                AppLogModel.LogError('PubReviewTeamModel::saveNewReviewTeamMember', 'Cannot create New Review Team Member record. Please select a Type [ Primary or Informer ]', PubId); 
            }
            AppLogModel.flushLogs();
            
            return false;
        }
        
        //make sure we cant add a duplicate Reviewer
        List<PubReviewTeam__c> dupReviewExists = [
            select id
            from PubReviewTeam__c
            where Publication__c = :PubId
            and FPR_Cycle__c = :pubModel.pubRecord.Current_FPRCycle_Id_Formula__c
            and Reviewer__c = :pNewPubReviewTeamMembers.Reviewer__c
            and IsLogicallyDeleted__c = false
        ];
        if (dupReviewExists.size() > 0) {
            
            String newReviewerName = ' [Contact Name = '+pNewPubReviewTeamMembers.Reviewer__c+']';
            Contact newReviewer = AppearContactModel.findContactByContactId(pNewPubReviewTeamMembers.Reviewer__c);
            
            if ( newReviewer  <> null) {
                newReviewerName = newReviewer.Name;// + newReviewerName;
            }
            
            string errorMsg = 'Cannot create duplicate Review Team Member for the same Review Cycle [FC=' +pubModel.CurrentFprCycleNum+'] ' +
                ' for '+pubModel.PubName +' with Reviewer = ' +newReviewerName;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMsg);
            ApexPages.addMessage(myMsg);    
            
            string extendedErrorMsg = ' Dup PubReviewteam id = '+dupReviewExists[0].id;
            AppLogModel.LogError('PubReviewTeamModel::saveNewReviewTeamMember', errorMsg+extendedErrorMsg, PubId); 
            AppLogModel.flushLogs();
            return false;
        }
        
        pNewPubReviewTeamMembers.FPR_Cycle__c = pubModel.pubRecord.Current_FPRCycle_Id_Formula__c;
        
        if (isTriage) {
            pNewPubReviewTeamMembers.SubType__c = 'Triagee';
            pNewPubReviewTeamMembers.Reviewer_Status__c = null;
            pNewPubReviewTeamMembers.HasVoted__c = false;
            pNewPubReviewTeamMembers.Comments__c = null;
            pNewPubReviewTeamMembers.Work_Notes__c = null;
        }
        
        if (pubModel.PubStatus.IsPubRoutedCurrentFPRCycle()) { //set reviewer's delivery date for routed pub
            pNewPubReviewTeamMembers.Delivered__c = Date.Today();
        }
        
        insert pNewPubReviewTeamMembers;        
        
         if (isTriage) {
            if ( LoggedInTeamMemberForCycle != null) {
                LoggedInTeamMemberForCycle.TriagedTo__c = pNewPubReviewTeamMembers.Id;
                
                LoggedInTeamMemberForCycle.Reviewer_Status__c = null;
                LoggedInTeamMemberForCycle.HasVoted__c = false;
                LoggedInTeamMemberForCycle.Comments__c = null;
                LoggedInTeamMemberForCycle.Work_Notes__c = null;                
                
                ProxyDelegateUtility.ProxyDelegateCounter = 0; //reset counter to sync triagedTo to other proxies after insert
                
                withoutSharingUtil.UpdateReviewerAsSystem(LoggedInTeamMemberForCycle); //invoked without sharing so trigger chain can update pub without edit access
            }
         }
        
        AppLogModel.LogInfo('PubReviewTeamModel::saveReviewTeamMember', 'Inserted new PubReviewTeamMember(s) : ' + pNewPubReviewTeamMembers, PubId);
        AppLogModel.flushLogs();      
        
        pubModel.resetSharing();
        pPubReviewTeamMembers = null;
        
        return true;
    }
    
    private static Publication__c getPubForEmail(id PubId) {
        List<Publication__c> activePubRecords = [
            Select CreatedById, Assigned_FPRC__c, FPR_Submitter__c, Current_Status_Id_FormulaField__c
            from Publication__c 
            WHERE Id = :PubId
        ];
        
        if ( activePubRecords.size() == 1) {
            return activePubRecords[0];
        } else {
            return null;
        }
    }
        
    
    //Logical Delete
    public PageReference deleteSelected() {
        
        //Defect #204 - Do not allow Changes to Reviewer after Publication reaches Approved by All Authors
        if ( pubStatusPastApprovedByAllAuthors()) {
            String msg = 'Cannot delete Review Team Member on this Publication since it has been Approved by All Authors';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, msg);
            ApexPages.addMessage(myMsg);    
            AppLogModel.LogError('PubReviewTeamModel::saveNewReviewTeamMember', msg, PubId); 
            AppLogModel.flushLogs();
            
            return null;            
        }
        
        
        Boolean recordHasDates = false;
          
        List<PubReviewTeam__c> itemsToLogicallyDelete = new List<PubReviewTeam__c>();
                
        for(PubReviewTeam__c teamMember : PubReviewTeamMembers){
            if (teamMember.IsLogicallyDeleted__c) {
                itemsToLogicallyDelete.add(teamMember);
                if (teamMember.SubType__c == 'Proxy' || teamMember.ProxyMember__c != null) {
                    List<PubReviewTeam__c> proxyChain = ProxyDelegateUtility.GetProxiesForAndProxiedBy(teamMember);
                    if (proxyChain != null) {
                        for(PubReviewTeam__c proxyChainMember : proxyChain) {
                            proxyChainMember.IsLogicallyDeleted__c = true;
                            itemsToLogicallyDelete.add(proxyChainMember);
                        }
                    }
                }
            }
        }
        
        AppLogModel.LogInfo('PubReviewTeamMember::deleteSelected', 'Logically deleting :'+itemsToLogicallyDelete, PubId);
        
        database.update(itemsToLogicallyDelete, true);  
        pPubReviewTeamMembers = null;   
        
        pubModel.resetSharing();
        
        //recount vote after delete
        PubReviewTeamTriggerLogic.ReCountVoteByPubId(pubId);
        
        AppLogModel.flushLogs();
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }  
    
    
    
    //query the list of team members and return it to UI
    // Reviewer_Role__c has been added in below Code for ENHC0011636:- Enhancement 
    public static List<PubReviewTeam__c> getReviewTeamMembers(Id PubId, Boolean excludeHasProxy) {
        if ( PubId == null) {
            return null;
        }
        string queryStr = 'Select Work_Notes__c, Type__c,'+
            'Triage_Justification__c, TriageDelegatedBy__c, TriageDelegatedBy__r.Name, '+
            'SubType__c, SubGroup__c, SubGroup__r.Name, Reviewer__c, Reviewer__r.Name, Reviewer__r.UserId__c, '+
            'Returned__c, Publication__c, ProxyMember__c, DisplayName__c, '+
            'FPR_Cycle__c, FPR_Cycle__r.FPR_Cycle_Num__c, isFromDataSourceSubGroup__c, '+
            'Name, IsLogicallyDeleted__c, Id, Reviewer_Status__c, PubIDLink__c, '+
            'Delivered__c, Delegation_Justification__c, HasVoted__c, '+
            'DelegatedTo__r.Reviewer__r.Name, TriagedTo__r.Reviewer__r.Name, '+
            'Appear_Role__c, Appear_Role__r.name, Reviewer_Role__c, Attachment_Detail__c, Comments__c, '+
            '(Select AttachmentType__c, Attachment_URL__c FROM Attachment_Details__r where isLogicallyDeleted__c = false) '+
            'From PubReviewTeam__c '+
            'where Publication__c = \''+PubId+'\' '+
            (excludeHasProxy ? 'AND ProxyMember__c = null ' : '')+
            'and IsLogicallyDeleted__c = false '+
            'order by FPR_Cycle__r.FPR_Cycle_Num__c desc, type__c, Reviewer__r.Name';
            
        List<PubReviewTeam__c> reviewTeamList = Database.query(queryStr);
        
        string msg = 'PubReviewTeam__c retrieved ' + reviewTeamList.size()+' records for PubId = '+PubId;
        System.Debug(msg);

        return reviewTeamList;  
   }
   
    private PubReviewTeam__c pLoggedInTeamMemberForCycle;
    public PubReviewTeam__c LoggedInTeamMemberForCycle {
        get {
            if (pLoggedInTeamMemberForCycle == null) {
                pLoggedInTeamMemberForCycle = getLoggedInTeamMemberForPubFprCycle(PubId, pubModel.CurrentFprCycleId);
            }           
            return pLoggedInTeamMemberForCycle;
        }
    }
    
    public static PubReviewTeam__c getLoggedInTeamMemberForPubFprCycle(Id pubId, Id fprCycleId) {
        return withoutSharingUtil.getLoggedInTeamMemberForPubFprCycle(pubId, fprCycleId);
    }
    
    public PageReference saveVote() {
        
        if (LoggedInTeamMemberForCycle != null) {    //LoggedInTeamMemberForCycle will return the PubReviewTeam Record for the current user of the current pub
            
            if ((LoggedInTeamMemberForCycle.Reviewer_Status__c == 'Withheld' ||
             LoggedInTeamMemberForCycle.Reviewer_Status__c == 'Discussion Required' ||
             LoggedInTeamMemberForCycle.Reviewer_Status__c == 'Reviewed With Comments' ||
             LoggedInTeamMemberForCycle.Reviewer_Status__c == 'Comments') &&
             LoggedInTeamMemberForCycle.Comments__c == null) {          
                    
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Comments are mandatory field when Vote is [' + LoggedInTeamMemberForCycle.Reviewer_Status__c +'].'));
                AppLogModel.LogError('PubReviewTeamModel::saveVote', 
                    'CurrentUser['+userInfo.getUserName()+'] voted for [' + LoggedInTeamMemberForCycle.Reviewer_Status__c + '] without a comment. Comments are mandatory field.', 
                    pubId);         
                AppLogModel.flushLogs();
                return null;
            }
            
            boolean isFinalVoteForReviewer = LoggedInTeamMemberForCycle.Reviewer_Status__c  != 'Discussion Required';
            LoggedInTeamMemberForCycle.HasVoted__c = isFinalVoteForReviewer;            
            
            withoutSharingUtil.UpdateReviewerAsSystem(LoggedInTeamMemberForCycle); //invoked without sharing so trigger chain can update pub without edit access
        }
        
        AppLogModel.flushLogs();
        return new PageReference(AppearUrlModel.AppearFprMenuUrl(ActiveSubMenu, AppearConstants.FprOtherDetailsTile, PubId));
    }
   
   
    private Map<id, PubReviewTeam__c> pCurrentCycleReviewTeamMapByContactId = null;
    public Map<id, PubReviewTeam__c> CurrentCycleReviewTeamMapByContactId {
        get {
            if (pCurrentCycleReviewTeamMapByContactId == null) {
                pCurrentCycleReviewTeamMapByContactId = new Map<id, PubReviewTeam__c>();
                
                for (PubReviewTeam__c prt : getReviewTeamMembersCurrentCycle(pubId, pubModel, false)) {
                    pCurrentCycleReviewTeamMapByContactId.put(prt.Reviewer__c, prt);
                }
            }
            return pCurrentCycleReviewTeamMapByContactId;
        }
    }   
   

    public static List<PubReviewTeam__c> getReviewTeamMembersCurrentCycle(Id PubId, AppearPubModel pubModel, Boolean excludeHasProxy) {
        if ( PubId == null) {
            return new List<PubReviewTeam__c>();
        }
        
        if ( PubModel == null){
            System.Debug('getReviewTeamMembersCurrentCycle pubModel is null !!');
            return new List<PubReviewTeam__c>();
        } 
        
        id FprCycleId = pubModel.pubRecord.Current_FPRCycle_Id_Formula__c;
        if ( FprCycleId == null) {
            return new List<PubReviewTeam__c>();
        }
    
        // Reviewer_Role__c has been added in below Code for ENHC0011636:- Enhancement 
        string queryStr = 'Select Work_Notes__c, Type__c,'+
            'Triage_Justification__c, TriageDelegatedBy__c, TriageDelegatedBy__r.Name, '+
            'SubType__c, SubGroup__c, SubGroup__r.Name, Reviewer__c, Reviewer__r.Name, '+
            'Returned__c, Publication__c, DisplayName__c, '+
            'FPR_Cycle__c, FPR_Cycle__r.FPR_Cycle_Num__c, '+
            'Name, IsLogicallyDeleted__c, isFromDataSourceSubGroup__c, Id, Reviewer_Status__c, '+
            'Delivered__c, Delegation_Justification__c, ProxyMember__c, '+
            'DelegatedTo__r.Reviewer__r.Name, TriagedTo__r.Reviewer__r.Name, '+
            'Appear_Role__c, Appear_Role__r.name, Reviewer_Role__c, Attachment_Detail__c, Comments__c, '+
            '(Select AttachmentType__c, Attachment_URL__c FROM Attachment_Details__r where isLogicallyDeleted__c = false) '+
            'From PubReviewTeam__c '+
            'where Publication__c = \''+PubId+'\' '+
            'and FPR_Cycle__c = \''+FprCycleId+'\' '+
            (excludeHasProxy ? 'AND ProxyMember__c = null ' : '')+
            'and IsLogicallyDeleted__c = false '+
            'order by FPR_Cycle__r.FPR_Cycle_Num__c desc, type__c, Reviewer__r.Name';
            
        List<PubReviewTeam__c> reviewTeamList = Database.query(queryStr);
        
        
        string msg = 'getReviewTeamMembersCurrentCycle retrieved ' + reviewTeamList.size()+' records for PubId = '+PubId;
        System.Debug(msg);
        AppLogModel.LogInfo('getReviewTeamMembersCurrentCycle', msg, PubId);
        return reviewTeamList;  
   }
   
   
   //between FPR Cycles  -- used by Material change for Congress - where we do not start a new submission cycle
    public void CopyPubReviewTeamBetweenCycles( integer fromCycleNum, integer toCycleNum) {
        String msg = String.format('Copy from Cycle {0} to Cycle {1} i  ', 
            new string[]{String.valueOf(fromCycleNum), string.ValueOf(toCycleNum) } );
        AppLogModel.LogInfo('PubReviewTeamModel::CopyPubReviewTeamBetweenCycles', msg, PubId);
        
        //excludeHasProxy = false;
        List<PubReviewTeam__c> allReviewTeam = getReviewTeamMembers(PubId, false);
        
        
        FPR_Cycle__c fromFprCycle = pubModel.FprCycle.getFprCycleByNum(fromCycleNum);
        FPR_Cycle__c toFprCycle  = pubModel.FprCycle.getFprCycleByNum(toCycleNum);
        
        List<PubReviewTeam__c> toCycleReviewTeam = new List<PubReviewTeam__c>();
                
        for(PubReviewTeam__c prt : allReviewTeam) {
            if (prt.SubType__c == 'Proxy') { //no copying of proxies. They will auto-insert.
                continue;
            }
            if ( prt.FPR_Cycle__c == fromFprCycle.Id && !prt.IsLogicallyDeleted__c && !prt.isFromDataSourceSubGroup__c) {
                
                PubReviewTeam__c newPrt = prt.clone();
                
                newPrt.FPR_Cycle__c = toFprCycle.Id;
                newPrt.HasVoted__c = false;
                newPrt.Returned__c = null;
                newPrt.Delivered__c = null;
                newPrt.ProxyMember__c = null;
                newPrt.Reviewer_Status__c = '';
                newPrt.Work_Notes__c = '';
                newPrt.Attachment_Detail__c = '';
                newPrt.Comments__c = '';
                            
                toCycleReviewTeam.add(newPrt);                          
            }
        }       
        insert toCycleReviewTeam;
        
        AppLogModel.LogInfo('PubReviewTeamModel::CopyPubReviewTeamBetweenCycles', 
            string.format('Inserted {0} review Team members to Fpr Cycle {1}',
            new string[] {string.valueOf(toCycleReviewTeam.size()), string.ValueOf(toFprCycle.FPR_Cycle_Num__c)} ), PubId);
    }
   
    //Static function that copy Review team member from SubGroup when user click Submit to FPR - or regenerate reviewers
    public string CopyPubReviewTeamFromSubGroup( FPR_Cycle__c nextFprCycle) {

        if ( nextFprCycle == null) {
            string errorMsg = 'Invalid FPR Cycle. Cannot CopyPubReviewTeamFromSubGroup for Pub '+pubModel.pubRecord.Name;
            AppLogModel.LogError('PubReviewTeamModel::CopyPubReviewTeamFromSubGroup', errorMsg, PubId);
            AppLogModel.flushLogs();
            return errorMsg;
        }
        
/*      Commented by Anu since this is a duplicate check. AppearPubViewModel line 227 does the same.
        if ( pubModel.pubRecord.SubGroup__c == null) {
            AppLogModel.LogError('PubReviewTeamModel::CopyPubReviewTeamFromSubGroup', 
                'Please assign a subGroup for Pub '+pubModel.pubRecord.Name);   
            AppLogModel.flushLogs();
            return 'Please assign a subGroup for Pub '+pubModel.pubRecord.Name; 
        }*/
        Id subGroupId = pubModel.pubRecord.SubGroup__c; 
        Id dataSourceId = pubModel.SubGroup.DataSourceId;
        
        AppLogModel.LogInfo('PubReviewTeamModel::CopyPubReviewTeamFromSubGroup', 
            'SubGroupId = '+subGroupId +'   DataSourceId = '+ dataSourceId + 
            '   FPRCycle = '+Integer.ValueOf(nextFprCycle.FPR_Cycle_Num__c), PubId);
        
        //Find all matching SubGroup Review Teams with Same ProductIndication
        Set<Id> pubProdIndIdSet = pubModel.PubProdIndication.ProdIndIdListForPub;
        AppLogModel.LogInfo('PubReviewTeamModel::CopyPubReviewTeamFromSubGroup', 
            'pubProdIndIdSet = '+pubProdIndIdSet, PubId );

        
        //Find all SubGroup Review Teams that matches ProductIndications of this pub
        List<Review_Team__c> SubGroupReviewTeams = 
            ReviewTeamModel.findReviewTeamsBySubGroupProdInd(subGroupId, pubProdIndIdSet);
        
        //Find all DataSource Review Teams that matches DataSources of this pub
        List<Review_Team__c> DataSourceReviewTeams = 
            ReviewTeamModel.findReviewTeamsByDataSourceProdInd(dataSourceId, pubProdIndIdSet);  
                
        //Collect all Team members
        SubGroupReviewTeams.AddAll(DataSourceReviewTeams);
        List<ReviewTeamMember__c> reviewTeamMembers = ReviewTeamMemberModel.findReviewTeamMembers(SubGroupReviewTeams); 
        
        AppLogModel.LogInfo('PubReviewTeamModel::CopyPubReviewTeamFromSubGroup', 
            'SubGroupReviewTeams = '+SubGroupReviewTeams, PubId );
    
        AppLogModel.LogInfo('PubReviewTeamModel::CopyPubReviewTeamFromSubGroup', 
            'ReviewTeamMember__c = '+reviewTeamMembers, PubId );
        
        //Consolidate team members into PubReviewTeamMembers
        //Primary role trump Inform Only 
        List<PubReviewTeam__c> PubReviewTeamMembers = ConvertReviewTeamMembers(reviewTeamMembers, nextFprCycle);
            
        //discussed with brandon - we dont use this line
        //List<PubReviewTeam__c> currentCycleTeamMembers = getReviewTeamMembersCurrentCycle(pubModel.PubId, pubModel, false);
        
        //Bulk insert all review team members
        Insert PubReviewTeamMembers;
        
        AppLogModel.flushLogs();
        
        return null;
    }
    
    
    // set pubReviewTeamMember = true - since this is only invoke by Submit to FPR that autogen based on SubGroup / DataSource
    public List<PubReviewTeam__c> ConvertReviewTeamMembers(List<ReviewTeamMember__c> reviewTeamMembers, FPR_Cycle__c fprCycle) {
        
        Map<Id,PubReviewTeam__c> pubReviewTeamMembers = new Map<Id,PubReviewTeam__c> ();
        
        //2 passes - handle the information only first - then overwrite with Primary if necessary
        for ( ReviewTeamMember__c reviewTeamMember : reviewTeamMembers) {
            if ( reviewTeamMember.ReviewerType__c == 'Notify' ) {
                if ( pubReviewTeamMembers.containsKey(reviewTeamMember.ReviewTeamMember__c)) {
                    //ignore - has been added already
                } else {
                    //create an entry
                    // pubReviewTeamMember.Reviewer_Role__c has been added in below Code for ENHC0011636:- Enhancement
                    PubReviewTeam__c pubReviewTeamMember = new PubReviewTeam__c();
                    pubReviewTeamMember.isFromDataSourceSubGroup__c = true;
                    pubReviewTeamMember.Type__c = 'Notify';
                    pubReviewTeamMember.FPR_Cycle__c = fprCycle.id;
                    pubReviewTeamMember.IsLogicallyDeleted__c = false;
                    pubReviewTeamMember.Publication__c = pubId;
                    pubReviewTeamMember.Reviewer__c = reviewTeamMember.ReviewTeamMember__c;
                    pubReviewTeamMember.Appear_Role__c = reviewTeamMember.Appear_Role__c;
                    pubReviewTeamMember.Reviewer_Role__c= reviewTeamMember.Reviewer_Role__c;
                    
                    pubReviewTeamMembers.put(pubReviewTeamMember.Reviewer__c, pubReviewTeamMember);     
                }
                            
            }
        }

        //2nd pass - primary
        for ( ReviewTeamMember__c reviewTeamMember : reviewTeamMembers) {
            if ( reviewTeamMember.ReviewerType__c == 'Primary' ) {
                if ( pubReviewTeamMembers.containsKey(reviewTeamMember.ReviewTeamMember__c)) {
                    //update type to Primary
                    pubReviewTeamMembers.get(reviewTeamMember.ReviewTeamMember__c).type__c = 'Primary';
                } else {
                    //create an entry
                    // pubReviewTeamMember.Reviewer_Role__c has been added in below Code for ENHC0011636:- Enhancement
                    PubReviewTeam__c pubReviewTeamMember = new PubReviewTeam__c();
                    pubReviewTeamMember.isFromDataSourceSubGroup__c = true;
                    pubReviewTeamMember.Type__c = 'Primary';
                    pubReviewTeamMember.FPR_Cycle__c = fprCycle.id;
                    pubReviewTeamMember.IsLogicallyDeleted__c = false;
                    pubReviewTeamMember.Publication__c = pubId;
                    pubReviewTeamMember.Reviewer__c = reviewTeamMember.ReviewTeamMember__c;
                    pubReviewTeamMember.Appear_Role__c = reviewTeamMember.Appear_Role__c;
                    pubReviewTeamMember.Reviewer_Role__c= reviewTeamMember.Reviewer_Role__c;
                    
                    pubReviewTeamMembers.put(pubReviewTeamMember.Reviewer__c, pubReviewTeamMember);     
                }
                            
            }
        }
        
        return pubReviewTeamMembers.values();
        
    }
    
    
    //Def #587
    //duplicate the adhocReviewer is a separate Future methods
    //since the number of review can be large 
    //this will restart the governor limits
    public void DuplicateAdHocReviewer() {
        
        Integer thisFprCyclNum = pubModel.CurrentFprCycleNum;
        Fpr_Cycle__c nextFprCycle = pubModel.FprCycle.getFprCycleByNum(thisFprCyclNum+1);
        
        DuplicateAdHocReviewerFuture(pubModel.pubId, pubModel.CurrentFprCycleId, nextFprCycle.Id);
    }
    public static boolean isDuplicatingAdhoc = false;
    @future
    public static void DuplicateAdHocReviewerFuture(Id pubId, Id fromFprId, Id toFprId) {
        isDuplicatingAdhoc = true;
        //collect a list of AdHoc reviewers first
        List<PubReviewTeam__c> adhocReviewers = [
            select isFromDataSourceSubGroup__c, Type__c, SubType__c, FPR_Cycle__c, IsLogicallyDeleted__c, Publication__c, Reviewer__c, Appear_Role__c, ProxyMember__c, DisplayName__c,
                DelegatedTo__c, Delegation_Justification__c, TriagedTo__c, Triage_Justification__c, TriageDelegatedBy__c
            from PubReviewTeam__c
            where Publication__c = :pubId
            and FPR_Cycle__c = :fromFprId
            and IsLogicallyDeleted__c = false
            and isFromDataSourceSubGroup__c = false
            and SubType__c <> 'Proxy'
        ]; //excluding existing proxies from clone as proxies will be re-evaluated upon insert within trigger context
    
        List<PubReviewTeam__c> newAdHocReviewTeamMembers = new List<PubReviewTeam__c>();
        for(pubReviewTeam__c reviewTeamMember :adhocReviewers ) {
            PubReviewTeam__c newAdhocReviewer = new PubReviewTeam__c();
            newAdhocReviewer.isFromDataSourceSubGroup__c = false;
            newAdhocReviewer.Type__c = reviewTeamMember.Type__c;
            newAdhocReviewer.SubType__c = reviewTeamMember.SubType__c;
            newAdhocReviewer.Appear_Role__c = reviewTeamMember.Appear_Role__c;  
            newAdhocReviewer.Reviewer__c = reviewTeamMember.Reviewer__c;
            newAdhocReviewer.DisplayName__c = reviewTeamMember.DisplayName__c;
            newAdhocReviewer.TriagedTo__c = reviewTeamMember.TriagedTo__c;
            newAdhocReviewer.TriageDelegatedBy__c = reviewTeamMember.TriageDelegatedBy__c;
            newAdhocReviewer.Triage_Justification__c = reviewTeamMember.Triage_Justification__c;
            newAdhocReviewer.DelegatedTo__c = newAdhocReviewer.DelegatedTo__c;
            newAdhocReviewer.Delegation_Justification__c = newAdhocReviewer.Delegation_Justification__c;
            newAdhocReviewer.Publication__c = pubId;
            newAdhocReviewer.FPR_Cycle__c = toFprId;
            newAdhocReviewer.IsLogicallyDeleted__c = false;
            newAdhocReviewer.ProxyMember__c = null;
            
            newAdHocReviewTeamMembers.add(newAdhocReviewer);        
        }
        insert newAdHocReviewTeamMembers;
        isDuplicatingAdhoc = false;
    }
    
    public void SetDeliveryDateForPubReviewTeam() {
        showCurrentCycleReviewer = true;
        boolean fprcAndSubmitterNotified = false;
        
        List<Id> ReviewerToAddresses = new List<Id>();
        List<Id> ReviewerCcAddresses = new List<Id>();
        ReviewerCcAddresses.Add(pubModel.pubRecord.FPR_Submitter__c);
        ReviewerCcAddresses.Add(pubModel.pubRecord.Assigned_FPRC__c);
        
        //triage does not apply for the initial email   
        
        PubReviewTeam__c emailReviewer = null;
        
        //Setup ToAddresses & CcAddresses
        List<PubReviewTeam__c> allReviewTeam = getReviewTeamMembers(PubId, false);
        AppLogModel.LogInfo('PubReviewTeamModel::SetDeliveryDateForPubReviewTeam', 
                'getReviewTeamMembers(PubId, false) retrieved '+allReviewTeam.size()+' records', PubId);
        for ( PubReviewTeam__c prt : allReviewTeam) {
            if (prt.FPR_Cycle__c == pubModel.CurrentFprCycleId) {
                                     
                if (prt.Type__c == 'Primary') {
                    ReviewerToAddresses.add(prt.reviewer__c);
                } else {
                    ReviewerCcAddresses.add(prt.reviewer__c);
                }
                
                if (prt.Delivered__c == null) { 
                    prt.Delivered__c = Date.Today();
                }
                emailReviewer = prt;
            } else {
                AppLogModel.LogInfo('PubReviewTeamModel::SetDeliveryDateForPubReviewTeam', 
                    'skipped due to old FprCycle', PubId);
            }
        }   
        
        AppLogModel.LogInfo('PubReviewTeamModel::SetDeliveryDateForPubReviewTeam', 
                'allReviewTeam size = '+allReviewTeam.size()+
                ' ToAddresses size ='+ReviewerToAddresses.size() +
                ' CcAddresses size = '+ReviewerCcAddresses.size(), PubId);
        
        //collected all TO & CC address list. Ready to send email now.
        if ( emailReviewer <> null) {
            //always send the Reviewer email - Delegated from in CC, Delegated to in To
            AppearPubModel activePub = new AppearPubModel(pubId);
            
            Email_02_RoutedForPrimary reviewerEmail = new Email_02_RoutedForPrimary(ReviewerToAddresses, ReviewerCcAddresses, emailReviewer, activePub.pubRecord);
            reviewerEmail.sendEmail();
        } else {
            AppLogModel.LogError('PubReviewTeamModel::SetDeliveryDateForPubReviewTeam', 
                'Skipped sending Email_02_RoutedForPrimary prt == null', PubId);
        }
        update allReviewTeam;
        
        AppLogModel.flushLogs();
    }   
    
    public static void DeleteAllPubReviewTeamMembers() {
        List<PubReviewTeam__c> tms = [select id from PubReviewTeam__c];
        delete tms;
    }
}