public with sharing class PublicationTriggerLogic {

    public static boolean byPassForLegacyPubType(List<Publication__c> PubList) {
        
        return false;
        /*
        Set<id> LegacyPubRecordIdSet = RecordTypeModel.LegacyPubRecordIdSet;
        
        System.assertNotEquals(null, LegacyPubRecordIdSet);
        System.assert(LegacyPubRecordIdSet.size() == 4);
        
        if(PubList == null || pubList.size() == 0) {
            return false;
        }
        
        for(Publication__c pub : pubList) {
            if (pub <> null && LegacyPubRecordIdSet.contains(pub.recordTypeId) ) {
                return true;  
            }
        }    
        return false;
        */
    } 
 

    public static void PubBeforeUpsertTriggerLogic(List<Publication__c> PubList,  Map<id, Publication__c> oldPubMap) {

    
        AppLogModel.LogInfo('PublicationTriggerLogic::PubBeforeUpsertTriggerLogic', 
            'PubList = '+PubList);
            
        for(Publication__c pub : PubList) {
            
            //copy the PubType in PickList to pubType__c
            PubType__c pubType = PubTypeModel.LookupPubType(pub.Publication_Type__c);
            if ( pubType == null){
                //error - mismatch here
                AppLogModel.LogError('PublicationTriggerLogic::PubBeforeUpsertTriggerLogic', 'Publication_Type__c Not Found for |'+pub.Publication_Type__c+'|', pub.id);
            } else {
                pub.pubType__c = pubType.Id;
            }
            
            //R1.1 Def 599 - use Pick List instead of lookup
            
            if ( pub.SubGroup_pick__c <> null){
                SubGroup__c sg = SubGroupModel.lookUpSG(pub.SubGroup_pick__c);
                if ( sg == null ) {
                    AppLogModel.LogError('PublicationTriggerLogic::PubBeforeUpsertTriggerLogic', 'SubGroup_pick__c Not Found for |'+pub.SubGroup_pick__c+'|', pub.id);  
                } else {
                    pub.SubGroup__c = sg.id;
                }   
            } else if (pub.SubGroup__c != null) {
                pub.SubGroup__c = null;
            }
            
            if ( pub.Country_pick__c <> null) {
                Country__c country = CountryModel.lookupCountry(pub.Country_pick__c);
                if ( country == null ) {
                    AppLogModel.LogError('PublicationTriggerLogic::PubBeforeUpsertTriggerLogic', 'Country_pick__c Not Found for |'+pub.Country_pick__c+'|', pub.id);    
                } else {
                    pub.Country__c = country.id;
                }            
                //country will set Region automatically  
            } else if (pub.Country__c != null) {
                pub.Country__c = null;
            }
            
            ////////////////////////////////////////////////////
            //cr 108 sponsoring dept 
            if ( pub.SponsorDept_Pick__c <> null) {
                
                Department__c sponsorDept = DepartmentModel.lookupDept(pub.SponsorDept_Pick__c);
                if ( sponsorDept == null ) {
                    AppLogModel.LogError('PublicationTriggerLogic::PubBeforeUpsertTriggerLogic', 'SponsorDept_Pick__c Not Found for |'+pub.SponsorDept_Pick__c+'|', pub.id);    
                } else {
                    pub.SponsoringDept__c = sponsorDept.id;
                }            
            } else if (pub.SponsoringDept__c != null) {
                pub.SponsoringDept__c = null;
            }
            
            if ( pub.SponsorOrg_Pick__c <> null) {
                Organization__c sponsorOrg = OrganizationModel.lookupOrg(pub.SponsorOrg_Pick__c);
                if ( sponsorOrg == null ) {
                    AppLogModel.LogError('PublicationTriggerLogic::PubBeforeUpsertTriggerLogic', 'SponsorOrg_Pick__c Not Found for |'+pub.SponsorOrg_Pick__c+'|', pub.id);    
                } else {
                    pub.SponsoringOrg__c = sponsorOrg.id;
                }            
            } else if (pub.SponsoringOrg__c != null) { 
                pub.SponsoringOrg__c = null;
            }
            // end of cr 108 changes for sponsoring Org / Dept
            ////////////////////////////////////////////////////
            
            if ( pub.ScopeOfWork__c == null){
                pub.ScopeOfWork__c = MEScopeOfWorkModel.WritingScope; //default to WritingScope
            }
            
            //check if PST Approval Submmission Date has changed
            //if so - update the target
            if ( pub.PST_Approval_Submission_Date__c <> null) {
                if ( oldPubMap <> null && oldPubMap.containsKey(pub.id)) {
                    Publication__c oldPubRec = oldPubMap.get(pub.id);
                    //Defect 196 - Auto Set IsPlanning for Planning Group
                    if ((oldPubRec.PST_Approval_Submission_Date__c == NULL) && (oldPubRec.isPlanning__c == NULL || oldPubRec.isPlanning__c == false))
                    {
                        pub.isPlanning__c = (!pub.Is_Tracking_Only__c && !pub.isISS__c);
                    }
                    if ( pub.PST_Approval_Submission_Date__c <> oldPubRec.PST_Approval_Submission_Date__c) {
                        //future call to avoid multiple levels of trigger firing
                        PubStatusModel.UpdateLatestSubmittedCompletedStatusTargetDate(Pub.Id, pub.PST_Approval_Submission_Date__c );
                    }
                    
                    //CCB 239: (Sesha Kurmana) Setting the PST Approved Audit Submission Date to track when the PST Approved Submission Date was initially entered/changed
                    if(oldPubRec.PST_Approval_Submission_Date__c == NULL){
                        pub.PST_Approved_Audit_Date__c = Date.today();
                    }
                }
            }
            
            //Sesha Kurmana: Business Rules to accomplish requirement ->
            //ISS = True or Tracking Only = True then Comments Only should be True and Planning should be False
            //ISS = False or Tracking Only = False then Comments Only should be False
            //Just making Comments Only = True or False, should not affect ISS or Tracking
            //Just making Tracking Only = True or False, should affect Planning = True or False respectively. 
            
            if ( oldPubMap <> null && oldPubMap.containsKey(pub.id)) {
                Publication__c oldPubRec = oldPubMap.get(pub.id);
                /*
                AppLogModel.LogDebug('PublicationTriggerLogic::PubBeforeUpsertTriggerLogic', 'SESHA::BEFORE '+ 
                            '\n pub.IsComments_Only__c = '+pub.IsComments_Only__c+
                            '\n oldPubRec.IsComments_Only__c = '+oldPubRec.IsComments_Only__c+
                            '\n pub.isISS__c = ' +pub.isISS__c+
                            '\n oldPubRec.isISS__c = ' +oldPubRec.isISS__c+
                            '\n pub.Is_Tracking_Only__c = '+pub.Is_Tracking_Only__c+
                            '\n oldPubRec.Is_Tracking_Only__c = '+oldPubRec.Is_Tracking_Only__c);
                */          
            
                if (( oldPubRec.Is_Tracking_Only__c == false && pub.Is_Tracking_Only__c == true && pub.isPlanning__c ) ||
                    ( oldPubRec.isISS__c == false && pub.isISS__c == true && pub.isPlanning__c )) {
                    pub.isPlanning__c = false;
                } else if (oldPubRec.Is_Tracking_Only__c == true && pub.Is_Tracking_Only__c == false && !pub.isPlanning__c) {
                    pub.isPlanning__c = true;
                }
                
                /** Sesha Kurmana: IsComments__Only flag logic. Complex IF conditions based on a matrix **/
                if (pub.isISS__c || pub.Is_Tracking_Only__c) {
                    pub.IsComments_Only__c = true;
                } else {
                    if ((oldPubRec.isISS__c && !pub.isISS__c) || (oldPubRec.Is_Tracking_Only__c && !pub.Is_Tracking_Only__c)) {
                        pub.IsComments_Only__c = false; 
                    }
                }
                /** Sesha Kurmana: IsComments__Only flag logic. Complex IF conditions based on a matrix **/
                /*
                AppLogModel.LogDebug('PublicationTriggerLogic::PubBeforeUpsertTriggerLogic', 'SESHA::AFTER '+ 
                                '\n pub.IsComments_Only__c = '+pub.IsComments_Only__c+
                                '\n oldPubRec.IsComments_Only__c = '+oldPubRec.IsComments_Only__c+
                                '\n pub.isISS__c = ' +pub.isISS__c+
                                '\n oldPubRec.isISS__c = ' +oldPubRec.isISS__c+
                                '\n pub.Is_Tracking_Only__c = '+pub.Is_Tracking_Only__c+
                                '\n oldPubRec.Is_Tracking_Only__c = '+oldPubRec.Is_Tracking_Only__c);*/
            } else {
                //Sesha Kurmana: During the creation of a brand new Publication (Planned/Unplanned/FPR Only), check to make sure the flags are captured correctly.
                if (pub.isISS__c || pub.Is_Tracking_Only__c) {
                    pub.IsComments_Only__c = true;
                }           
            }
            
        }
        AppLogModel.LogInfo('PublicationTriggerLogic::PubBeforeUpsertTriggerLogic', 'Trigger Completed for all publications'); //not specific to a single pub
        AppLogModel.flushLogs();
        
    }
    
    private static boolean pPublicationAfterInsertHasFired = false;
    
    public static void PubAfterInsertTriggerLogic(List<Publication__c> PubList) {   
        
        AppLogModel.LogInfo('PublicationTriggerLogic::PubAfterInsertTriggerLogic','Processing '+pubList.size()+' records.');
        
        /*for(Publication__c pub : PubList) {
            if ( !pub.NoGlobalStatus__c) {  
                PubAfterInsertTriggerLogicOnePub(pub);
            }           
        }*/
        for(Publication__c pub : PubList) {
            String message='The following field(s) are required for a GPP publication:';
            if((!pub.Is_Tracking_Only__c && !pub.isISS__c) && profileModel.isAppearGPPL && !pub.IsFprOnly__c)
                {
                 if(pub.SponsorDept_Pick__c == null || pub.SponsorOrg_Pick__c == null || pub.Country_pick__c == null || pub.RAE__c == null){ //|| pub.GPP_Type__c == null - removed as part of Appear Enanhancment R1:2017//Appear Enhancement R3: GPP Type field validation Added
              
                  if(pub.SponsorDept_Pick__c == null)
                      message = message + ' Sponsoring Amgen Department,';
                  if(pub.SponsorOrg_Pick__c == null)
                      message = message + ' Sponsoring Organization,';
                  if(pub.RAE__c == null)
                      message = message + ' Responsible Amgen Employee (RAE),';
                  if(pub.Country_pick__c == null)
                      message = message + ' Country,';                     
				//Commented below as part of Appear Enhancment R1:2017
                 /* if(pub.GPP_Type__c == null)   //Appear Enhancement R3: GPP Type field validation Added
                  	  message = message + ' Publication Classification,';*/
              
                  message = message.removeEnd(',');
              
                  pub.addError(message);
                 }else if( !pub.NoGlobalStatus__c) {  
                        PubAfterInsertTriggerLogicOnePub(pub);
                     }             
                 }
           
            else if( !pub.NoGlobalStatus__c) {  
                PubAfterInsertTriggerLogicOnePub(pub);
            }           
        }
    }
    
    private static void PubAfterInsertTriggerLogicOnePub(Publication__c pub) {
        
        
        
        //create a submission cycle for each pub
        Id pid = pub.id;
        AppearPubModel appearPub = new AppearPubModel(pid);
        AppLogModel.LogInfo('PublicationTriggerLogic::PubAfterInsertTriggerLogicOnePub','Processing Pub '+ appearPub.PubTitle, pub.id);
        
        SubmissionCycle__c firstSubmissionCycle = PublicationTriggerLogic.CreateSubmissionCycleOne(pid);
        
        AppLogModel.LogDebug('PublicationTriggerLogic::PubAfterInsertTriggerLogicOnePub', 
                'First Submission Cycle  =  '+ firstSubmissionCycle.Name + '   :    ' + firstSubmissionCycle.Id, pub.id);
            
        List<PubStatus__c> PubGlobalStatusList = appearPub.PubStatus.InsertGlobalStatus(firstSubmissionCycle);
        
        /*  special code to add actual date to Global Status Draft - disabled for Def #355
        if ( ProfileModel.isAppearWriting) { 
            //update actual date to Draft
            for(PubStatus__c pubStatus : PubGlobalStatusList) {
                if ( pubStatus.Status__c == StatusModel.Draft.Id) {
                    pubStatus.ActualDate__c = DateTime.Now();
                    update pubStatus;
                }   
            }
        } else {
            
        }
        */
        
        appearPub.PubStatus.InsertProfileDependentInitialStatus(firstSubmissionCycle);  
        
        appearPub.resetSharing();
        UpdateLatestPubStatus(pub);     
    }
    
    private static boolean pPublicationCreationInProgress = false;
    public static boolean PublicationCreationInProgress{
        get {
            return pPublicationCreationInProgress;
        }  
    }
    
    
    public static void UpdateLatestPubStatusById(Id pubId) {
        UpdateLatestPubStatusById(pubId, false);
    }
    public static void UpdateLatestPubStatusById(Id pubId, boolean ForceRecTypeUpdate) {

        
        Publication__c pub = [
            select id, name, pubStatus__c, Publication_Title__c, RecordTypeId,
            Current_FPR_Cycle_Num__c, Current_FPRCycle_Id_Formula__c
            from Publication__c 
            where id = :pubId
        ];
        AppLogModel.LogInfo('PublicationTriggerLogic:UpdateLatestPubStatusById', 
            'for '+pub.name +' : '+pub.Publication_Title__c, pubId);
        UpdateLatestPubStatus(pub, true);
    }
    
    public static void UpdateLatestPubStatus(Publication__c pub) {
        UpdateLatestPubStatus( pub, false);
    }
    
    public static void UpdateLatestPubStatus(Publication__c pub, boolean ForceRecTypeUpdate) {
        //Find latest PubStatus with Actual Date  
        List<PubStatus__c> latestPubStatusList = [
            select id, name, Publication_id__c,  ActualDate__c,
            status__c, status__r.name,  status__r.displayOrder__c, 
            Submission_Cycle__c, submission_Cycle__r.Submission_Cycle_Num__c, 
            fpr_Cycle__c, fpr_Cycle__r.FPR_Cycle_Num__c,RecordTypeId
            from PubStatus__c
            where Publication_id__c = :pub.id
            and ActualDate__c <> null
            order by 
                Submission_Cycle_Num_Formula__c desc,
                FPR_Cycle_sort_num__c desc,
                Status__r.displayOrder__c desc,
                ActualDate__c desc
            limit 1
        ];
        
                
        //handle case during insert of new publication - where no pubstatus has actual date
        if (latestPubStatusList.size() <> 1) {
            AppLogModel.LogError('PublicationTriggerLogic::UpdateLatestPubStatus','Error = No pubstatus has an actual date', pub.id);
            return;
        }
        PubStatus__c latestPubStatus = latestPubStatusList[0];
        
        string msg = 'Latest status for pub - '+latestPubStatus.status__r.name + ' = '+latestPubStatus.name +
             ' Submission Cycle [' + latestPubStatus.submission_Cycle__r.Submission_Cycle_Num__c+']';
             
        if (latestPubStatus.FPR_Cycle__c == null) {
            msg += ' FPR Cycle = [not started]';
        } else {
            msg += ' FPR Cycle [' + latestPubStatus.fpr_Cycle__r.FPR_Cycle_Num__c +']';
        }
        
        
        AppLogModel.LogInfo('PublicationTriggerLogic::UpdateLatestPubStatus',  msg, pub.Id);
        
        
        //2013-08-03 - Benjamin force update for Migration --- need to force this update to true for IQ step
        if ( ForceRecTypeUpdate || pub.pubStatus__c <> latestPubStatus.id) {
            
            Publication__c updatePub = new Publication__c();
            updatePub.id = pub.id;
            updatePub.pubStatus__c = latestPubStatus.id;

            //string debugmsg = 'Updated PubStatus to  ['+latestPubStatus.status__r.name +']  for Publication : ['+ pub.Publication_Title__c+']';             
            //AppLogModel.LogInfo('PublicationTriggerLogic::UpdateLatestPubStatus', debugmsg);            
                
            //update the PubRecord Type according to the latest status  
            //setup RecordType accord to Stage field in PubStatus
            Status__c statusRec = StatusModel.StatusMapById.get(latestPubStatus.Status__c);
        
            if ( statusRec == null){
                //error - mismatch here
                AppLogModel.LogError('PublicationTriggerLogic::UpdateLatestPubStatus', 
                    'Update RecType for Publication - cannot find Status__c with id = ['+latestPubStatus.Status__r.name+']', pub.Id);
            } else {
                AppLogModel.LogInfo('PublicationTriggerLogic::UpdateLatestPubStatus', 
                    'Attempting to set Pub rectype to ['+ statusRec.PubRecordType__c+']', pub.Id);
                RecordType pubRecType = RecordTypeModel.LookupRecordType('Publication__c', statusRec.PubRecordType__c);
                if ( pubRecType == null){
                    string errorMsg = 'cannot find Publication__c Record type for '+ statusRec.PubRecordType__c ;
                    AppLogModel.LogError('PublicationTriggerLogic::UpdateLatestPubStatus', errorMsg, pub.Id);
                } else {
                    AppLogModel.LogInfo('PublicationTriggerLogic::UpdateLatestPubStatus', 
                        'Updating Pub RecType to ' + pubRecType.name+' Latest status = '+latestPubStatus.name, pub.Id);
                    updatePub.RecordTypeId = pubRecType.id;
                    
                } 
            }     
            withoutSharingUtil.UpdatePub(updatePub);
        }   
    }
    
    public static SubmissionCycle__c CreateSubmissionCycleOne(Id PubId) {
        SubmissionCycle__c newCycle = new SubmissionCycle__c();
        newCycle.publication__c = pubid;
        newCycle.Submission_Cycle_Num__c = 1;
        insert newCycle;
        AppLogModel.LogDebug('PublicationTriggerLogic', 'first submissionCycle Id = ' + newCycle.id, pubId);
            
        return newCycle;
    }
    /*Code implemented as part of Release 1 Appear Ennhancement savign user as Writer role for EW profile*/
     public static void addWritingRoleForExternalWriter(List<Publication__c> PubList){
        for(Publication__c pub : PubList) {
            Id pubId=pub.Id;
            Id userId=pub.OwnerId;
            System.debug('Entered into the Publication Trigger Logic class----->'+pubid);
            System.debug('Entered into the Publication Trigger Logic class----->'+userId);
            PubMeModel pubMe= New PubMeModel();
            pubMe.addWriterDuringCloneandCreate(pubId, userId);
        }
    }
    
}