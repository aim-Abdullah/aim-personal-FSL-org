public with sharing class RelatedPubModel extends AppearBaseModel {
    ////////  members ////////////////////////
    private id PubId;
    private string ActiveTile;
    private string ActiveSubMenu;
    
    private transient List<PubRelated__c> pPubRelatedList = null;
    public List<PubRelated__c> PubRelatedList {
        get {
            if (pPubRelatedList == null) {
                pPubRelatedList = getPubRelated(this.PubId);
            }
            return pPubRelatedList;
            
        }
    }
    
    public RelatedPubModel(Id PubId,  string tile, string subMenu) {
        this.PubId = PubId; 
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;
    }
    
    //save not requied - no inline edit
    public PageReference saveNewRelatedPub() {
        if (pNewRelatedPub == null || NewRelatedPub.RelatedPub__c == null) {
            AppearAddErrorMessage(AppearErrorMessages.NeedRelatedPubToSave);
        } else {
            insert NewRelatedPub;
            
            //circular related as discussed with business during demo
            PubRelated__c circle = new PubRelated__c();
            circle.Publication__c = NewRelatedPub.RelatedPub__c;
            circle.RelatedPub__c = PubId;
            insert circle;
        }
        
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    //physical delete not logical
    public PageReference deleteSelected() {
          
        List<PubRelated__c> itemsToDelete = new List<PubRelated__c>();
        
        
        
        for(PubRelated__c p : pPubRelatedList){
            if (p.ToDelete__c) {
                itemsToDelete.add(p);
                
                //def 100 - find the related to Pub & Delete the relationship as well
                itemsToDelete.addAll(findRelatedTo(p));
            }
        }
        database.Delete(itemsToDelete, true);   
        pPubRelatedList = null; 
        
        
        
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }  
    
    
    private List<PubRelated__c> findRelatedTo(PubRelated__c p) {
        List<PubRelated__c> qList = [
            select id
            from PubRelated__c
            where publication__c = :p.RelatedPub__c
            and relatedPub__c = :p.publication__c
        ];
        
        return qList;
    }
    
    //////////////////
    private transient PubRelated__c pNewRelatedPub = null;
    public PubRelated__c NewRelatedPub { //insert from modal
        get {
            if (pNewRelatedPub == null) {               
                pNewRelatedPub = new PubRelated__c();
                pNewRelatedPub.Publication__c = PubId;          
            }
            return pNewRelatedPub;
        }
    }   
    public static List<PubRelated__c> getPubRelated(Id PubId) {
        if ( PubId == null) {
            return null;
        }
        //Defect 573 - Added Add to GPP field for GPP planned publication
        //Defect 662 - Added DataSource and Subgroup fields for cloning because there are more than
        //one used in the app vs. UI
        List<PubRelated__c> pubRelatedList = [ 
            select id, ToDelete__c,
            Publication__c, publication__r.Name, publication__r.Publication_Title__c,
            RelatedPub__c, RelatedPub__r.Name, RelatedPub__r.Publication_Title__c,
            RelatedPub__r.Publication_Type__c,  RelatedPub__r.Current_Status_FormulaField__c, RelatedPub__r.Authors__c,
            RelatedPub__r.Current_Status_Date_FormulaField__c, RelatedPub__r.Current_Target__c, RelatedPub__r.isPlanning__c,
            RelatedPub__r.Data_Source__c, RelatedPub__r.SubGroup_pick__c, RelatedPub__r.Datasourceformulafield__c,
            RelatedPub__r.Subgroup__c, RelatedPub__r.Is_Tracking_Only__c, RelatedPub__r.Country_Pick__c, RelatedPub__r.Presentation_Type__c,
            RelatedPub__r.RAE__c, RelatedPub__r.Search_Identifier__c
            from PubRelated__c
            where Publication__c = :PubId
        ];
        
        string msg = 'Related Pub Model retrieved ' + pubRelatedList.size()+' records for PubId = '+PubId;
        System.Debug(msg);
        
        return pubRelatedList;
    }
    
    
    /////////////// clone ///////////////
    /*Restricting clone functionality for EW user if they dont have access in all the related pubs*/
    public PageReference ClonePub() {
        //Appear Enhancement R2: Updated Cloning Functionlity. For GPP Publication mentioned fields are required Sponsoring Org, Sponsoring Amgen Dept, RAE, Country
        Publication__c pub= [Select id,Country_pick__c,RAE__c,SponsorDept_Pick__c,SponsorOrg_Pick__c,GPP_Type__c from Publication__c where Id = :PubId]; //Appear Enhancement R3: GPP Type field Added
        String message='Before cloning the publication, please ensure the required field(s):';
          if(pub.Country_pick__c == null)
            message= message+' Country,';
          if(pub.SponsorDept_Pick__c == null)
            message= message+ ' Sponsoring Department,';
          if(pub.SponsorOrg_Pick__c == null)
            message= message+ ' Sponsoring organization,';
          if(pub.RAE__c == null)
            message= message+' Responsible Amgen Employee,';
        //Commented below as part of Appear Enhancment R1:2017
         /* if(pub.GPP_Type__c == null) //Appear Enhancement R3: GPP Type field validation Added
          	message = message + ' Publication Classification,';     */   
          message = message.removeEnd(',');
          message = message + ' are updated on the publication being cloned';
        //String message='Before cloning the publication, please ensure the required fields Sponsoring Org, Sponsoring Amgen Dept, RAE, Country are updated on the publication being cloned';
        
        if(pub.Country_pick__c == null || pub.SponsorDept_Pick__c == null || pub.SponsorOrg_Pick__c == null || pub.RAE__c == null){ //Appear Enhancement R3: GPP Type field validation Added -- Appear Enhancment R1:2017 GPP Type field validation removed 
            AppearAddErrorMessage(message);
            return null;
        }
        
        CloneResultDTO cloneResult ;
        List<PubRelated__c> relPubList = withoutSharingUtil.getPubRelatedSystemContext(PubId); // populating the Related Pub List for the Original Pub
        
        if(ProfileModel.isAppearExternalWriter && relPubList.size()>0){
            Map<Id,String> relatedPubMap = new Map<Id,String>();
            Set<Id> relatedPubIdSet = new Set<Id>();
            Map<Id,String> pubShareMap = new Map<Id,String>();
            Set<Id> pubShareIdSet = new Set<Id>();
            
            String nonAccessPubs=AppearErrorMessages.RestrictCloneFunctionality;
            Id userid= UserInfo.getUserId();
             
            for(PubRelated__c relPub:relPubList){
                relatedPubMap.put(relPub.RelatedPub__c,relPub.RelatedPub__r.Name);
                relatedPubIdSet.add(relPub.RelatedPub__c);
            }
            System.debug('checking details please do not disturb'+relatedPubMap+ '******'+relatedPubIdSet+'*****UserID****'+userid);
             //checking Related publication has Edit Access or not
            
            List<UserRecordAccess> recordsEditAccessList = [
            SELECT RecordId, HasReadAccess, HasEditAccess, HasTransferAccess, MaxAccessLevel
            FROM UserRecordAccess
            WHERE UserId = :userid
            AND RecordId IN :relatedPubIdSet
            ];
            
            System.debug('UserAccesList#####'+recordsEditAccessList);
            //Populating the Publication records where user dont have the Access. 
            for(UserRecordAccess ua :recordsEditAccessList){
                if(!ua.HasEditAccess){
                    String pubName = relatedPubMap.get(ua.RecordId);
                    nonAccessPubs = nonAccessPubs+' '+pubName;
                }
            }
            
            if(nonAccessPubs!=AppearErrorMessages.RestrictCloneFunctionality){
                AppearAddErrorMessage(nonAccessPubs);
                return null; 
            }else{
                System.debug('Entered the code logic');
                cloneResult= RelatedPubModel.ClonePub(PubId);    
            } 
                    
         }else {
            cloneResult=RelatedPubModel.ClonePub(PubId);    
         }
        
        pPubRelatedList = null;
        if (cloneResult.destPubId != null) {  
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, AppearConstants.PubDetailsTile, cloneResult.destPubId));
        } 
              
        return null;
    }
    //END PART OF Release 1
    
    public static CloneResultDTO ClonePub(Id PubId){
        //publication title must be unique 
        //generate a prefix of 'Cloned <DateTime.Now>' by default
        
        string defaultPrefix = ' Cloned '+string.valueOf(DateTime.now());
        return ClonePub(PubId, defaultPrefix);   
    }
    
    public static CloneResultDTO ClonePub(Id OrigPubId, string prefix) {
        AppLogModel.LogInfo('RelatedPubModel::Clone', 'initiating cloning - prefix = '+ prefix);
        
        CloneResultDTO result = new CloneResultDTO(OrigPubId);  
        
        //load a clean copy of the publication from the Database 
        AppearPubModel origPubModel = new AppearPubModel(OrigPubId);
        if (!origPubModel.hasValidPub) {
            result.AddErrorMsg(AppearErrorMessages.CloneInvalidSourcePub);
            return result;
        }
        
        boolean preserveId = false; //we want new PubId 
        boolean isDeepClone = true; //deep clone means change field does not affect original 
        boolean preserveReadOnlyTimeStamp = false;
        boolean preserveAutoNumber = false;
        publication__c clonePub = origPubModel.pubRecord.clone(preserveId, isDeepClone, preserveReadOnlyTimeStamp, preserveAutoNumber);
        
        //now - cleanup
        string tempPubTitle = origPubModel.pubRecord.Publication_Title__c + prefix; 
        if (tempPubTitle.length() > 255) {
            tempPubTitle = origPubModel.pubRecord.Publication_Title__c;
        }
        clonePub.Publication_Title__c = tempPubTitle;
        clonePub.Pubstatus__c = null;
        clonePub.Assigned_FPRC__c = null;
        clonePub.RecordTypeId = RecordTypeModel.PublicationPlanRecTypeId;   //make sure we start with a record type that owner have access to
        clonePub.OwnerId = UserInfo.getUserId();
        //Defect 701 - Part of the cleanup to ensure certain fields are not cloned
        clonePub.FPR_Due_Date__c = null;
        clonePub.FPR_Submitter__c = null;
        clonePub.FPR_Submitter_text__c = null;
        clonePub.PST_Approval_Submission_Date__c = null;
        clonePub.MTA__c = origPubModel.pubRecord.MTA__c; // Enhancement R2 implementation clone pub
        clonePub.is_MTA__c = origPubModel.pubRecord.is_MTA__c;  // Enhancement R2 implementation clone pub
        clonePub.isFPR__c = false;
        clonePub.Partner__c = origPubModel.pubRecord.Partner__c;   // Enhancement R2 implementation clone pub
        clonePub.Citation__c = null;
        clonePub.Priority__c = null;
        clonePub.Comments_For_Approvers__c = null;
        clonePub.Comments_For_Coordinator__c = null;
        clonePub.Planning_Comments__c = null;
        clonePub.Link_to_Final_Publication__c = null;
        clonePub.Execution_Notes__c = null;
        clonePub.Execution_Notes_Last_Mod__c = null;
        clonePub.isExecution__c = false;
        clonePub.SiebelRowId__c = null; //Should not Clone Legacy Siebel Id's as it is impacting IRO Reporting by making it Duplicate.
        clonePub.IsComments_Only__c = false;// Appear Enhancement R2 clone pub
        clonePub.isISS__c = false; // Appear Enhancement R2 clone pub
        clonePub.isISStext__c = null; // Appear Enhancement R2 clone pub
        clonePub.Sponsored_Date__c = null; // Appear Enhancement R2 clone pub
        clonePub.Current_Target__c = null; // Appear Enhancement R2 clone pub
        clonePub.Publication_Type__c = null;  // Appear Enhancement R2 clone pub
        clonePub.Is_Tracking_Only__c = false;  // Appear Enhancement R2 clone pub
        
        
         //10/16/2014: (CCB 252) Added by Sesha to clone these because it is a Picklist Value. Publilcation Trigger will pick it up automatically.
        clonePub.SponsorOrg_Pick__c = origPubModel.pubRecord.SponsorOrg_Pick__c;
        clonePub.SponsorDept_Pick__c = origPubModel.pubRecord.SponsorDept_Pick__c; 
        
        //clone the Product Indication String
        clonePub.Product_Indication__c = origPubModel.pubRecord.Product_Indication__c;
        
        //Defect 573 - Add to cloned publication whether it is added to the plan
        clonePub.isPlanning__c = origPubModel.pubRecord.isPlanning__c;
        
        //Defect 662 - Add all fields related to data source and sub group
        clonePub.Data_Source__c = origPubModel.pubRecord.Data_Source__c;
        clonePub.SubGroup_pick__c = origPubModel.pubRecord.SubGroup_pick__c;
        clonePub.SubGroup__c = origPubModel.pubRecord.SubGroup__c;   
        
        //Defect 701 - Include all fields that should be cloned as per Business Request 
        clonePub.Is_Tracking_Only__c =false;// origPubModel.pubRecord.Is_Tracking_Only__c; // Appear Enhancement R2 clone pub
        clonePub.Country_Pick__c = origPubModel.pubRecord.Country_Pick__c;
        clonePub.Presentation_Type__c = null ;//origPubModel.pubRecord.Presentation_Type__c; Appear Enhancement R2 clone pub
        clonePub.RAE__c = origPubModel.pubRecord.RAE__c;
        clonePub.Search_Identifier__c = null; // origPubModel.pubRecord.Search_Identifier__c; Appear Enhancement R2 clone pub
        
        insert clonePub;
        Id clonePubId = clonePub.Id;
         /*Method call for Adding Latest Writing Coordinator Appear Role user in cloned Pub*/
        If(ProfileModel.isAppearExternalWriter)
            {
              system.debug('Cloned Pub Id '+ clonePubId);
              system.debug('Original Pub Id'+ OrigPubId);
              PuBMeModel pubMe= New PubMeModel(clonePubId);
              //pubMe.addWriterDuringCloneandCreate(clonePubId,userId);(OrigPubId, ClonePubId);
              pubMe.saveWritingRoleDuringClone(OrigPubId, ClonePubId);
           }
        System.assertNotEquals(null, clonePub.id);
        AppLogModel.LogInfo('RelatedPubModel::Clone', 'Cloned Publication - PubID = '+clonePub.id);
        
        


        //switch status to Created - based on latest Def from Sesha / Wyeth
        //PubStatusModel.UpdateDraftPubStatusActualTime(clonePub.Id, DateTime.now());
        //switch status to Concept - based on latest Def from Business (CR #202)
        //PubStatusModel.InsertCreatedPubStatusForClonedPubs(clonePub.id);
        PubStatusModel.InsertConceptPubStatusForClonedPubs(clonePub.id);
        PublicationTriggerLogic.UpdateLatestPubStatus(clonePub, true);
        
        RelatedPubModel.clone(OrigPubId, ClonePubId); 
        CloneFuture(OrigPubId, ClonePubId);
       
               
        AppearPubModel clonedPubModel = new AppearPubModel(clonePubId);
        clonedPubModel.resetSharing();
        
        result.destPubId = clonePub.Id;
        result.hasCloneCompleted = true;
    
        return result ;
    }
    
    @Future
    private static void CloneFuture(Id OrigPubId,Id ClonePubId) {
         try {
            PubProdIndModel.clone(OrigPubId, ClonePubId);
            
            PubStudyModel.clone(OrigPubId, ClonePubId);
            PubAuthorModel.clone(OrigPubId, ClonePubId);
            PubScientificStatementModel.clone(OrigPubId, ClonePubId);
            
            //Defect 701 - Adding PublicationTeamMembers to cloned pub from original one
            PubTeamMemberModel.clone(OrigPubId,ClonePubId);    
                          
            List<Publication__c> clonedPubList = new List<Publication__c>();
            AppearPubModel clonedPubModel = new AppearPubModel(clonePubId);
            clonedPubList.add(clonedPubModel.PubRecord);
            AppearPubModel.SyncPubIndicationFields(clonedPubList);//sync indication fields in future call to fix indication string mainly
            clonedPubModel.resetSharing();
            
        } catch ( Exception ex) {
            //result.AddErrorMsg('Cloning operation failed for child records.');
            //return nu ;
        } finally {
            AppLogModel.flushLogs();
        }   
    }
        
    //this function will cloned the related pub list for the pub Appear is trying to clone */
    public static void clone(Id origPubId, Id destCloneId) {
        List<PubRelated__c> origList = getPubRelated(origPubId);
        
        List<PubRelated__c> destList = new List<PubRelated__c>();
        for(PubRelated__c record : origList){
            PubRelated__c clone = record.clone(false, true, false, false);
            clone.Publication__c = destCloneId;
            destList.add(clone); 
        }
        
        //add original pub into the related pub list of the clone pub
        PubRelated__c orig = new PubRelated__c();
        orig.publication__c = destCloneId;
        orig.RelatedPub__c = origPubId;
        
        destList.add(orig);
        
        //add the cloned pub as a related pub to the orig
        PubRelated__c relatedClone = new PubRelated__c();
        relatedClone.publication__c = origPubId;
        relatedClone.RelatedPub__c = destCloneId;
        
        destList.add(relatedClone);
        
        insert destList;
        AppLogModel.LogInfo('RelatedPubModel::Clone', 'Cloned Related Publication inserted '+destList.size()+' records');
    }
    
    
}