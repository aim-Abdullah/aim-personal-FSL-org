public with sharing class PubPreFprReviewerModel {

    ////////  members ////////////////////////
    private id PubId;
    private string ActiveTile;
    private string ActiveSubMenu;
    private AppearPubModel pActivePub;
    private boolean isFprSubmitter;    
    
    public PubPreFprReviewerModel(Id PubId,  string tile, string subMenu, Boolean isFprSubmitter) {
        this.PubId = PubId; 
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;
        this.isFprSubmitter = isFprSubmitter;
        
    }
    
    public AppearPubModel ActivePub {
        get{
            if (pActivePub == null) {
                pActivePub = new AppearPubModel(this.PubId);
            }
            return pActivePub;
        }
    }
    
    public void clearCache() {
        pPubPreFprReviewerList = null; 
    }
    
    private List<PublicationPreFprReviewer__c> pPubPreFprReviewerList = null;
    public List<PublicationPreFprReviewer__c> PubPreFprReviewerList {
        get {
            if (pPubPreFprReviewerList == null) {
                pPubPreFprReviewerList = getPubPreFprReviewers(this.PubId);
            }
            return pPubPreFprReviewerList;
        }
    }
    
    
    //Def 281 - insert Fpr Submitter as a Pre FPR Reviewer
    public static void InsertFprSubmitter(id pubId, string UserId) {
        
        Set<id> contactIds = AppearContactModel.findContactForAppearUser(UserId);

        
        if ( contactIds.size() == 0) {
            AppLogModel.LogError('PubPreFprReviewerModel::InsertFprSubmitter', 
                'Cannot insert FPR Submitter as PreFPR Reviewer.  Cannot find assocated Contact Record', PubId);
            AppLogModel.flushLogs();
            return;
        }
        for(Id contactId : contactIds) {
            PublicationPreFprReviewer__c preFpr = new PublicationPreFprReviewer__c();
            preFpr.isSelected__c = false;
            preFpr.PreFprReviewer__c =contactId;
            preFpr.Publication__c = pubId;
            //preFpr.Product_Indication__c = ptm.Product_Indication__c;
            //preFpr.Appear_Role__c = ptm.Appear_Role__c;
            
            insert preFpr;
            
            AppLogModel.LogInfo('PubPreFprReviewerModel::InsertFprSubmitter', 
                'inserted FPR Submitter ['+ contactId +'] as a preFPR reviewer '+preFpr, PubId);
            break;
        }
    }
    
    public PageReference save() {       
        
        //def 281
        //def 792 - 
        //Changed for Functional Pub Team
        if ( ProfileModel.isAppearPubTeam ||  ProfileModel.isAppearBusinessAdmin || ProfileModel.isSysAdmin || ProfileModel.isAppearGPPL ||  ProfileModel.isAppearReviewers ||
            ProfileModel.isAppearWriting || ProfileModel.isAppearExternalWriter || ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC || ProfileModel.isAppearFprOnlySubmitter || test.isRunningTest() || ProfileModel.isAppearFunctionalPubTeam ) {
                
            //clear checkbox before persisting
            for(PublicationPreFprReviewer__c p : pPubPreFprReviewerList){
                p.IsSelected__c = false;
            }
            
            //Defect 260 CC 12 add the additional check for PreFPRReviewers Not Found
            activePub.PubRecord.PreFPRReviewers_Not_Found__c = getPublicationPreFPRReviewersString(activePub.PubRecord.PreFPRReviewers_Not_Found__c);
            //Appear Enhancement R3: Historical Data Fix for Validation Rule
            try{
            	database.update(activePub.PubRecord, true);
            }catch(DMLException ae){
            	ApexPages.addMessages(ae);
            	return null;
            }
            
            database.update(pPubPreFprReviewerList, true);
            pPubPreFprReviewerList = null;  //clear cache
            
            if ( isFprSubmitter) {
                return new PageReference(AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId));
            } else {
                return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
            }
        } else {
            String errorMsg = 'You do not have permission to change PreFPR Reviewer List';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMsg);
     
            ApexPages.addMessage(myMsg);     
            AppLogModel.LogError('PubPreFprReviewerModel::save', errorMsg, PubId);
            return null;
        }
    }
    
    public string getPublicationPreFPRReviewersString(string PreFPRReviewersNotFound){
        string result='';
        if (PreFPRReviewersNotFound <> null){
            if (result.length() <> 0) {
                result += ',' + PreFPRReviewersNotFound;
            } else {
                result = PreFPRReviewersNotFound;
            }
        }
        return result;
    }
    
    public PageReference deleteSelected() {
        Boolean recordHasDates = false;
          
        List<PublicationPreFprReviewer__c> itemsToLogicallyDelete = new List<PublicationPreFprReviewer__c>();
        for(PublicationPreFprReviewer__c p : pPubPreFprReviewerList){
            if (p.IsSelected__c) {
                itemsToLogicallyDelete.add(p);
            }
        }
        //Appear Enhancement R3: Start - Historical Data Validation fix        
        String message='Please ensure the required field(s):';
        if(ActivePub.pubRecord.SponsorDept_Pick__c == null){
        	message=message +' Sponsoring Amgen Department,';
        } 
        if(ActivePub.pubRecord.SponsorOrg_Pick__c == null){
        	message=message +' Sponsoring Organization,';
        }
        if(ActivePub.pubRecord.RAE__c == null){
        	message=message +' Responsible Amgen Employee,';
        }
        if (ActivePub.pubRecord.Country_pick__c == null){
        	message=message +' Country,';
        }
        //Commented below as part of Appear Enhancment R1:2017
        /*if(ActivePub.pubRecord.GPP_Type__c == null){
        	message=message +' Publication Classification,';
        }*/
        message= message.removeEnd(',');
        message = message + ' are updated on the publication as the publication is Part of GPP.';
        
        if(ActivePub.pubRecord.SponsorDept_Pick__c == null || ActivePub.pubRecord.SponsorOrg_Pick__c == null || ActivePub.pubRecord.RAE__c == null
        	|| ActivePub.pubRecord.Country_pick__c == null){ // removed || ActivePub.pubRecord.GPP_Type__c == null as part of Appear Enhancment R1:2017
        		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                    message);
 
                ApexPages.addMessage(myMsg);
        		return null;
        	}
		//Appear Enhancement R3: End - Historical Data Validation fix
        
        database.delete(itemsToLogicallyDelete);    
        pPubPreFprReviewerList = null;  
        
        activePub.PubRecord.PreFPRReviewers_Not_Found__c = getPublicationPreFPRReviewersString(activePub.PubRecord.PreFPRReviewers_Not_Found__c);
        database.update(activePub.PubRecord,true);
        
        if ( isFprSubmitter) {  
            return new PageReference(AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId));
        } else {
            return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
        }
    }  
    
    private transient PublicationPreFprReviewer__c pNewPubPreFprReviewMember = null;
    public PublicationPreFprReviewer__c NewPubPreFprReviewMember { //insert from model
        get {
            if (pNewPubPreFprReviewMember == null) {                
                pNewPubPreFprReviewMember = new PublicationPreFprReviewer__c();
                pNewPubPreFprReviewMember.Publication__c = PubId;
            }
            return pNewPubPreFprReviewMember;
        }
        set {
            pNewPubPreFprReviewMember = value;
        }
    }
    
    
    public PageReference saveNewPreFprReviewer() {
        //def 281
        //Changed for Functional pub team
        if ( ProfileModel.isAppearBusinessAdmin || ProfileModel.isSysAdmin || ProfileModel.isAppearGPPL || 
            ProfileModel.isAppearWriting || ProfileModel.isAppearExternalWriter || ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC || ProfileModel.isAppearFprOnlySubmitter || ProfileModel.isAppear626 || ProfileModel.isAppearPubTeam || profilemodel.isAppearReviewers || ProfileModel.isAppearFunctionalPubTeam ) {
                
            if ( pNewPubPreFprReviewMember.PreFprReviewer__c == null ){
                //error do not save
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                    AppearErrorMessages.NeedNewPreFprReviewer);
 
                ApexPages.addMessage(myMsg);     
                AppLogModel.LogError('PubPreFprReviewerModel::saveNewPreFprReviewer', AppearErrorMessages.NeedNewPreFprReviewer, PubId);                                   
                AppLogModel.flushLogs();
                
                return null; //to show error
            }
            insert pNewPubPreFprReviewMember;         
            
            pPubPreFprReviewerList = null;
        } else {
            String errorMsg = 'You do not have permission to edit PreFPR Reviewer List';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMsg);
     
            ApexPages.addMessage(myMsg);     
            AppLogModel.LogError('PubPreFprReviewerModel::saveNewPreFprReviewer', errorMsg, PubId);
            return null;
        }

        if ( isFprSubmitter) {  
            return new PageReference(AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId));
        } else {
            return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
        }
    }
    
    /*** CR 247 03/19/2014 
    public string ValidAppearRoles {
        get {
            return AppearRoleModel.ValidAppearRoles;
        }
    }
    ***/
    @future
    public static void CopyPubTeamMembersAsPreFprReviewerFuture(id pubId) {
        
        AppearPubModel activePub = new AppearPubModel(PubId);
        List<PublicationTeamMember__c> pubTeamMemberList = ActivePub.PubTeamMember.PubTeamMembers;
        CopyPubTeamMembersAsPreFprReviewer(pubTeamMemberList, pubid);
        
    }
    
    public static string CopyPubTeamMembersAsPreFprReviewer( List<PublicationTeamMember__c> pubTeamMemberList, id pubId) {
        AppLogModel.LogInfo('PubPreFprReviewerModel:CopyPubTeamMembersAsPreFprReviewer', 'start', PubId);
        
        List<PublicationPreFprReviewer__c> newPreFprReviewers = new List<PublicationPreFprReviewer__c>();
        for(PublicationTeamMember__c ptm :  pubTeamMemberList) {
            if ( !ptm.IsLogicallyDeleted__c ) {
                
                PublicationPreFprReviewer__c preFpr = new PublicationPreFprReviewer__c();
                // CR 247 03/19/2014 preFpr.Appear_Role__c = ptm.Appear_Role__c;
                preFpr.isSelected__c = false;
                preFpr.PreFprReviewer__c = ptm.Member__c;
                preFpr.Product_Indication__c = ptm.Product_Indication__c;
                preFpr.Publication__c = ptm.Publication__c;
                
                newPreFprReviewers.add(preFpr);
            }
        }
        
        insert newPreFprReviewers;
        
        AppLogModel.LogInfo('PubPreFprReviewerModel:CopyPubTeamMembersAsPreFprReviewer', 'completed', PubId);
        AppLogModel.flushLogs();
        return ''; //no error message to return     
    }
     

    
    
    ////////////// static ///////////////////
    //System.Debug(PubPreFprReviewerModel.getPubPreFprReviewers('a00K0000002CAeL'));
    
    public static List<PublicationPreFprReviewer__c> getPubPreFprReviewers(Id PubId) {
        if ( PubId == null) {
            return null;
        }
        //Defect 260 CC 12 Adding PreFPRReviewersNotFound
        List<PublicationPreFprReviewer__c> pubPreFprReviewerTeamList = [ 
            select id, 
            Publication__c, isSelected__c,
            Product_Indication__c, Product_Indication__r.Name,
            PreFprReviewer__c, PreFprReviewer__r.Name, PreFprReviewer__r.UserId__c,
            Appear_Role__c, Appear_Role__r.Name,Publication__r.PreFPRReviewers_Not_Found__c
            from PublicationPreFprReviewer__c
            where Publication__c = :PubId 
        ];
        
        string msg = 'PublicationPreFprReviewer__c retrieved ' + pubPreFprReviewerTeamList.size()+' records for PubId = '+PubId;
        System.Debug(msg);
        
        
        return pubPreFprReviewerTeamList;
    }
    
}