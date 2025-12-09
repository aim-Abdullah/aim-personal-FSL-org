@IsTest
public class PubStatusModelTest {
    
    private static Publication__c pPubStatusTestPub = null;
    
    public static Publication__c pubStatusTestPub {
       
        get {
            if (pPubStatusTestPub == null) {
                CreateData();
                pPubStatusTestPub = UnitTestData.PublicationNew('TestPubStatusModel');
            }
            return pPubStatusTestPub;
        }
    }
    
    
    public static void CreateData() {
        MEScopeOfWorkModelData.createData();
        DataSourceModelData.createData();
        SubGroupModelData.createData();
        
        JournalModelData.createData();
        PubProdIndModelTest.CreateData();
        //R1:2017 - max author count data
        KeyValueSettings__c kvs = new KeyValueSettings__c(Name='CSP Pub Author Count',Key__c='Max_Author_Count',Value__c='10');
		insert kvs;	
    }
    
    public static void RefreshPubModelPubRecord(AppearPubModel pubModel) {
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
            SponsorOrg_Pick__c, SponsorDept_Pick__c, // Appear Enhancement R2
            p.GPP_Type__c //Appear Enhancement R3
            From Publication__c p
            where Id = :pubModel.PubId 
        ];
        if (pubs.size() > 0) {
            pubModel.pubRecord = pubs[0];
        }
    }
    
    public static AppearPubModel MovePubtoFPR() {
        Publication__c pub = PubStatusTestPub;
        System.assertNotEquals(null, SubGroupModelData.DevelopmentSmpSubGroup);
        
       
        System.Test.startTest();
        
        AppearPubViewModel.SubmitSuggestion(pub.Id); //Status should change to Concept
        
        AppearPubModel pubModel = new AppearPubModel(Pub.Id);
        System.assertNotEquals(null, pubModel.PubRecord.Current_SubmissionCycle_Id_Formula__c);
        System.assertEquals('Suggested', pubModel.PubRecord.Current_Status_FormulaField__c);
        
        AppearPubViewModel.AcceptPub(pub.Id); //Status should change to Concept
   
        RefreshPubModelPubRecord(pubModel);
        System.assertEquals('Concept', pubModel.PubRecord.Current_Status_FormulaField__c); 
        
        pub.FPR_Due_Date__c = Date.today();

        pub.SubGroup__c = SubGroupModelData.DevelopmentSmpSubGroup.Id;
        pub.Journal__c = JournalModel.JournalNameMap.get('Annals of Oncology').Id;  
        
        pub.Meeting__c = null;
        pub.Current_Target__c = 'Annals of Oncology';

        pub.Authors_Not_Found__c = 'AuthorNotFoundUnitTest';
        
        update pub;
               
        //Changing Date for Publication proposal Status
        RefreshPubModelPubRecord(pubModel); 
        //Adding attachment to the Pub       
        AddAttachmenttoPub(pubModel,'Draft Sent for FPR');
        PubStatusModel pubstats = pubModel.PubStatus;
        String Stat = PubModel.CurrentStatus;
        
        for (PubStatus__c st: pubstats.PubStatusList){
            if (st.Status__c == StatusModel.ProposalComplete.Id ){
                st.ActualDate__c = Date.today();
                break;
            }
        }
        pubstats.save();
        
        RefreshPubModelPubRecord(pubModel);     
               
        System.assertEquals('Concept', pubModel.pubRecord.Current_Status_FormulaField__c);
        System.assertNotEquals(null, pubModel.pubRecord.Current_SubmissionCycle_Id_Formula__c);
        
        String ButtongMsg = AppearPubViewModel.SubmitForFPR(String.valueof(pub.Id));
        System.assertEquals('Submitted for FPR',ButtongMsg);
        
        RefreshPubModelPubRecord(pubModel);  
        
        System.assertEquals('In FPR', pubModel.pubRecord.Current_Status_FormulaField__c);
        System.assertNotEquals(null, pubModel.pubRecord.Current_SubmissionCycle_Id_Formula__c);
     
        return pubModel;
        

    }
    
    /* added the test method for AddStatuses3 method*/
    public static AppearPubModel MovePubtoFPRNew() {
        Publication__c pub = PubStatusTestPub;
        System.assertNotEquals(null, SubGroupModelData.DevelopmentSmpSubGroup);
        
       
        System.Test.startTest();
        
        AppearPubViewModel.SubmitSuggestion(pub.Id); //Status should change to Concept
        
        AppearPubModel pubModel = new AppearPubModel(Pub.Id);
        System.assertNotEquals(null, pubModel.PubRecord.Current_SubmissionCycle_Id_Formula__c);
        System.assertEquals('Suggested', pubModel.PubRecord.Current_Status_FormulaField__c);
        
        AppearPubViewModel.AcceptPub(pub.Id); //Status should change to Concept
   
        RefreshPubModelPubRecord(pubModel);
        System.assertEquals('Concept', pubModel.PubRecord.Current_Status_FormulaField__c); 
        
        pub.FPR_Due_Date__c = Date.today();

        pub.SubGroup__c = SubGroupModelData.DevelopmentSmpSubGroup.Id;
        pub.Journal__c = JournalModel.JournalNameMap.get('Annals of Oncology').Id;  
        
        pub.Meeting__c = null;
        pub.Current_Target__c = 'Annals of Oncology';

        pub.Authors_Not_Found__c = 'AuthorNotFoundUnitTest';
        
        update pub;
               
        //Changing Date for Publication proposal Status
        RefreshPubModelPubRecord(pubModel); 
        //Adding attachment to the Pub       
        AddAttachmenttoPub(pubModel,'Draft Sent for FPR');
        /*PubStatusModel pubstats = pubModel.PubStatus;
        String Stat = PubModel.CurrentStatus;
        
        for (PubStatus__c st: pubstats.PubStatusList){
            if (st.Status__c == StatusModel.ProposalComplete.Id ){
                st.ActualDate__c = Date.today();
                break;
            }
        }
        pubstats.save();*/
        
        RefreshPubModelPubRecord(pubModel);     
               
        System.assertEquals('Concept', pubModel.pubRecord.Current_Status_FormulaField__c);
        System.assertNotEquals(null, pubModel.pubRecord.Current_SubmissionCycle_Id_Formula__c);
        
        String ButtongMsg = AppearPubViewModel.SubmitForFPR(String.valueof(pub.Id));
        System.assertEquals('Submitted for FPR',ButtongMsg);
        
        //RefreshPubModelPubRecord(pubModel);  
        
        /*System.assertEquals('In FPR', pubModel.pubRecord.Current_Status_FormulaField__c);
        System.assertNotEquals(null, pubModel.pubRecord.Current_SubmissionCycle_Id_Formula__c);
     */
        return pubModel;
        

    }

    public static void AddAttachmenttoPub (AppearPubModel pubModel, String AttType){
        PubAttachmentDetails__c newattachrecord = pubModel.PubAttachments.getNewAttachment();
        newattachrecord.AttachmentType__c = AttType;
        newattachrecord.AttachmentName__c = 'TestAttachment';
        
        FeedItem feeditm = pubModel.PubAttachments.NewFeedItem1;
        feeditm.ContentData = blob.valueOf('Test');
        feeditm.ContentFileName = 'TestAttachment.txt';
        feeditm.Type = 'ContentPost';
        insert feeditm;
        
        newattachrecord.What__c = feeditm.Id;
        pubModel.PubAttachments.InsertAttachment(newattachrecord);

        FeedItem feedrecord = [Select Id,RelatedRecordId from FeedItem where ParentId = :pubModel.PubId limit 1];
        PubAttachmentDetails__c attachdtlrecord = [Select Id,what__c,AttachmentType__c,SubmissionCycle__c from PubAttachmentDetails__c where Publication__c = :pubModel.PubId and AttachmentType__c = :AttType  limit 1];
            
        System.assertNotEquals(null, feedrecord.Id);
        System.assertNotEquals(null, feedrecord.RelatedRecordId);
        System.assertNotEquals(null, attachdtlrecord.what__c);
        System.assertNotEquals(null, attachdtlrecord.SubmissionCycle__c );
          
    }

    @isTest 
    public static void AddStatuses1() { 
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
        
        StatModel.InsertDraftWithActualDate(pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId, true);
        StatModel.InsertApprovedByAllAuthors(pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId);
        
    }
    
        @isTest 
    public static void AddStatuses10a() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
        //Statmodel.InsertFPROnlyPubStatus(Pub.Id);
        StatusModelData.createData();
        Status__c status = StatusModel.LookUpStatus(StatusModel.SubmittedCompletedStatus);
        list<status__c> ststlist = new list<status__c>();
        ststlist.add(status);
        datetime datenow = date.today();
        Statmodel.CreateOrMovePubStatus(ststlist,pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId);

        // PubStatusModel.SetFprCompletedStatus(pub.id, status, pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId, 3, datetime.now()); 

    
    }

        @isTest 
    public static void AddStatuses10b() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
         //StatusModelData.createData();

        Statmodel.InsertGlobalStatusReviewSubmit(pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId);
   
       SubmissionCycle__c acycle = new SubmissionCycle__c();
        acycle.Publication__c = pub.Id; 
        acycle.Submission_Cycle_Num__c = 1; 
        insert acycle;
        System.Test.stopTest();
        StatModel.InsertGlobalStatus(acycle);  
        /*Statmodel.InsertProfileDependentInitialStatus(acycle);*/
    
    }
    /* Added Test method*/
    @isTest 
    public static void AddStatuses10bExtn() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
         //StatusModelData.createData();

        Statmodel.InsertGlobalStatusReviewSubmit(pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId);
   
       SubmissionCycle__c acycle = new SubmissionCycle__c();
        acycle.Publication__c = pub.Id; 
        acycle.Submission_Cycle_Num__c = 1; 
        insert acycle;
        System.Test.stopTest();
        /*StatModel.InsertGlobalStatus(acycle); */ 
        Statmodel.InsertProfileDependentInitialStatus(acycle);
    
    }
    
    
    
    @isTest 
    public static void AddStatuses10() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
        //Statmodel.InsertFPROnlyPubStatus(Pub.Id);
        StatusModelData.createData();
        Status__c status = StatusModel.LookUpStatus(StatusModel.SubmittedCompletedStatus);
        list<status__c> ststlist = new list<status__c>();
        ststlist.add(status);
        datetime datenow = date.today();

        id newId = StatModel.findSubmittedCompletedStatusId(pubModel.CurrentSubmissionCycleId);
        pubstatus__c PubSTs = PubStatusModel.InsertFPROnlyPubStatus(Pub.id);
        pubstatus__c PubSTs2 = PubStatusModel.UpdateDraftPubStatusActualTime(Pub.id,datenow);
        //pubstatus__c PubSTs3 = PubStatusModel.InsertCreatedPubStatusForClonedPubs(Pub.id);
        //PubStatusModel.InsertConceptPubStatusForClonedPubs(Pub.id);
        //PubSTstest = PubStatusModel.insertAssignToFPRC(Pub.id);
        //StatModel.InsertSuggestionRejectedPubStatus();
        //String test_str = StatModel.InsertSuggestionRejectedPubStatus(datenow);
        integer i = Statmodel.currCycleMaterialChangeWithActualDate; 
        boolean b = StatModel.currSubCycleHasOpenChange;
        Boolean c = StatModel.showResendButton ;
        i = Statmodel.currCycleNonMaterialChangeWithActualDate;
        i = Statmodel.currCycleResentWithActualDate; 
        pagereference pg = StatModel.ResentME();
        List<SelectOption> PI = StatModel.statuslist;
        //Pagereference testing = STatModel.MaterialChangeClick();
        //Pagereference testing2 = STatModel.TerminateFprClick();
        boolean test123 = StatModel.showMaterialChangeButton;
        boolean test22 = StatModel.ShowRemoveFromGPPButton;
        Pagereference pagere = StatModel.saveNewPubStatus();
        PubStatus__c p = StatModel.NewPub;
        List<SelectOption> listp =  StatModel.PubNewDepStatusItems;
        List<SelectOption> listopt = StatModel.PubStatusOptions;
        Map<id, PubStatus__c> PubStatusMap = StatModel.PubStatusMap; 
        PubStatus__c CurrentPubStatus =  StatModel.CurrentPubStatus; 
        //StatModel.ChangePubStatusToSubmitted();
        System.assertNotEquals(null, statModel.getPubStatus(CurrentPubStatus.Id));
        
        boolean isGlobalStatusInitial =  StatModel.isGlobalStatusInitial(status); 
        boolean isGlobalStatusFPR   =  StatModel.isGlobalStatusFPR(status); 
        FPR_Cycle__c aCycle = PubStatusModel.getNextFPRCycle(p); 
    
        
    }  
   
    @isTest 
    public static void AddStatuses11() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
        //Statmodel.InsertFPROnlyPubStatus(Pub.Id);
        StatusModelData.createData();
        Status__c status = StatusModel.LookUpStatus(StatusModel.SubmittedCompletedStatus);
        list<status__c> ststlist = new list<status__c>();
        ststlist.add(status);
        datetime datenow = date.today();
        pubstatus__c PubSTs3 = PubStatusModel.InsertCreatedPubStatusForClonedPubs(Pub.id);
        //PubStatusModel.InsertConceptPubStatusForClonedPubs(Pub.id);
        //pubstatus__c PubSTstest = PubStatusModel.insertAssignToFPRC(Pub.id);
        //StatModel.InsertSuggestionRejectedPubStatus();
        //String test_str = StatModel.InsertSuggestionRejectedPubStatus(datenow);
        
    } 
    
    @isTest 
    public static void AddStatuses12() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
        //Statmodel.InsertFPROnlyPubStatus(Pub.Id);
        //StatusModelData.createData();
        
        Status__c status = StatusModel.LookUpStatus(StatusModel.SubmittedCompletedStatus);
        list<status__c> ststlist = new list<status__c>();
        ststlist.add(status);
        datetime datenow = date.today();
        //pubstatus__c PubSTs3 = PubStatusModel.InsertCreatedPubStatusForClonedPubs(Pub.id);
        //PubStatusModel.InsertConceptPubStatusForClonedPubs(Pub.id);
        pubstatus__c PubSTstest = PubStatusModel.insertAssignToFPRC(Pub.id);
        StatModel.InsertSuggestionRejectedPubStatus();
        String test_str = StatModel.InsertSuggestionRejectedPubStatus(datenow);
        
    } 
    
  @isTest 
    public static void AddStatuses13() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
        //Statmodel.InsertFPROnlyPubStatus(Pub.Id);
        StatusModelData.createData();
        Status__c status = StatusModel.LookUpStatus(StatusModel.SubmittedCompletedStatus);
        list<status__c> ststlist = new list<status__c>();
        ststlist.add(status);
        datetime datenow = date.today();
        PubStatusModel.InsertConceptPubStatusForClonedPubs(Pub.id);
        //List<pubStatus__c> PUBS = New List<PubStatus__c>();
        //PUBS = StatModel.InsertMaterialChangeForCongressJournalStatus();
        //date dtT = date.today();
        //PubSTatusModel.UpdateLatestSubmittedCompletedStatusTargetDate(Pub.Id,dtT);
    } 

  @isTest 
    public static void AddStatuses130() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
        date dtT = date.today();
        PubSTatusModel.UpdateLatestSubmittedCompletedStatusTargetDate(Pub.Id,dtT);
    } 
   
   
   @isTest 
    public static void AddStatuses134() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
        //Statmodel.InsertFPROnlyPubStatus(Pub.Id);
        system.Test.stopTest();
        StatusModelData.createData();
        Status__c status = StatusModel.LookUpStatus(StatusModel.SubmittedCompletedStatus);
        list<status__c> ststlist = new list<status__c>();
        ststlist.add(status);
        datetime datenow = date.today();
        //PubStatusModel.InsertConceptPubStatusForClonedPubs(Pub.id);
        List<pubStatus__c> PUBS = New List<PubStatus__c>();
        PUBS = StatModel.InsertMaterialChangeForCongressJournalStatus();
       
    }
   
    @isTest 
    public static void AddStatuses2() {                 
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
        
        StatModel.InsertPublishedPresented(pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId);
        StatModel.InsertSubmitCompleted(pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId);
        StatModel.InsertAccepted(pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId);
     
        
    }

    @isTest 
    public static void AddStatuses20() {                 
    
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
            
            Status__c status = StatusModel.LookUpStatus(StatusModel.SubmittedCompletedStatus);
        list<status__c> ststlist = new list<status__c>();
        StatModel.MovePubStatusToCurrentFCandSC(ststlist, pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId, false); 
        
        StatModel.InsertTerminateFPRCycleStatus();  
}

    @isTest 
    public static void AddStatuses3() {
        AppearPubModel pubModel = MovePubtoFPRNew();
        
        pubModel.PubStatus.InsertFprWithHeldWithActualDate(pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId); 
    } 

    @isTest 
    public static void AddStatuses4() {
        AppearPubModel pubModel = MovePubtoFPR();
        
        pubModel.PubStatus.InsertNextSubmissionCycleGlobalStatus(); 
        pubModel.PubStatus.InsertRejectedAfterSubmissionStatus(); 
    } 


    @isTest 
    public static void AddAssignedtoFPRC() { 
        AppearPubModel pubModel = MovePubtoFPR();
        pubModel.FPRCAssignToMe(); 
    } 

    @isTest
    private static void ConditionalStatusButtonChecks() {        
        AppearPubModel pubModel = MovePubtoFPR();
        system.assert(!pubModel.PubStatus.showPubRejectedButton);
        //system.assert(!pubModel.PubStatus.showMaterialChangeButton);
        system.assert(pubModel.PubStatus.showTerminateFprButton);
        system.assert(!pubModel.PubStatus.showMoveToGPPButton);
        //system.assert(!pubModel.PubStatus.showRemoveFromGPPButton);
        
        system.assertNotEquals(null, pubModel.PubStatus.MoveToGPPClick());
        system.assertNotEquals(null, pubModel.PubStatus.RemoveFromGPPClick());
        system.assertNotEquals(null, pubModel.PubStatus.PubRejectedClick());
        //system.assertNotEquals(null, pubModel.PubStatus.MaterialChangeClick());
        //system.assertEquals(null, pubModel.PubStatus.TerminateFprClick());
    }

 
    @isTest 
    public static Publication__c AddTerminateFPRStatus() { 
        //R1:2017 - max author count data
        KeyValueSettings__c kvs = new KeyValueSettings__c(Name='CSP Pub Author Count',Key__c='Max_Author_Count',Value__c='10');
		insert kvs;	
        Publication__c pub = PubProdIndModelTest.TestSaveProdInd();
        pub.Add_Meeting_Journal__c = 'testTarget';
        //pub.Authors_Not_Found__c = 'testAuthor';
        update pub;
        
        String ReturnMsg = AppearPubViewModel.TerminateFPRCycle(String.valueof(pub.id));
        
        AppearPubModel activePub = new AppearPubModel(Pub.id);

        //System.AssertEquals(null,ReturnMsg ); //refactored that null == success.
        //System.assertEquals('Terminate FPR Cycle', activePub.CurrentStatus);
        
        return pub;
 
    }
 
    @IsTest
    private static void unitTest() {
        Publication__c newPub = PubStatusTestPub;
        
        AppearPubModel pubModel = new AppearPubModel(newPub.id);
        PubStatusModel statusModel = pubModel.PubStatus;
        
        //Set<Id> pubsToFilter = new Set<Id>();
        //pubsToFilter.add(newPub.id);
        //system.assertEquals(0, PubStatusModel.GetPubsRoutedCurrentFPRCycle(pubsToFilter).size());
        
        integer numStatus = statusModel.PubStatusList.size();
        system.assertNotEquals(0, numStatus);
        statusModel.save();
        PubStatus__c status = statusModel.PubStatusList[0];
        statusModel.PubStatusList[0].IsLogicallyDeleted__c = true;
        statusModel.deleteSelected();  
        statusModel.InsertSubmitSuggestion(datetime.now()); 
        //statusModel.InsertRoutePubStatus();
        //statusModel.InsertInFprPubStatus(null);
        //statusModel.InsertConceptPubStatus();
        //system.assertEquals(1, PubStatusModel.GetPubsRoutedCurrentFPRCycle(pubsToFilter).size());
        //system.assertEquals(true, statusModel.IsPubRoutedCurrentFPRCycle());
        
         FPR_Cycle__c aCycle = PubStatusModel.getNextFPRCycle(status); 
         statusModel.updatePubStatusFprCycle( status, pubModel.CurrentFprCycleId, aCycle);

    } 
 
 
    @IsTest
    private static void unitTest2() {
        Publication__c newPub = PubStatusTestPub;
        
        AppearPubModel pubModel = new AppearPubModel(newPub.id);
        PubStatusModel statusModel = pubModel.PubStatus;
        system.Test.startTest();
        Set<Id> pubsToFilter = new Set<Id>();
        pubsToFilter.add(newPub.id);
        system.assertEquals(0, PubStatusModel.GetPubsRoutedCurrentFPRCycle(pubsToFilter).size());
        
        statusModel.InsertRoutePubStatus();
        statusModel.InsertInFprPubStatus(null);
        statusModel.InsertConceptPubStatus();
        system.assertEquals(1, PubStatusModel.GetPubsRoutedCurrentFPRCycle(pubsToFilter).size());
        system.assertEquals(true, statusModel.IsPubRoutedCurrentFPRCycle());
        system.Test.stopTest();

    } 

    @IsTest
    private static void AddMaterialChangesforJournal() {
        //CreateData();
        AppearPubModel pubModel = MovePubtoFPR();
        //AppearPubViewModel.MaterialChangeForCongressJournal(pubModel.PubId);
        RefreshPubModelPubRecord(pubModel);
        
        System.assertEquals('In FPR', pubModel.pubRecord.Current_Status_FormulaField__c);
        System.Test.stopTest();
    }


    @IsTest
    public static void AuthorApprovalwithoutAttach() {
        //try Changing date for All Author Pub Status
         AppearPubModel pubModel = MovePubtoFPR();
         PubStatusModel pubstats = pubModel.PubStatus;
        
        for (PubStatus__c st: pubstats.PubStatusList)
        {
            if (st.Status__c == StatusModel.AuthorApprovals.Id )
            {
                st.ActualDate__c = Date.today();
                break;
            }
            
        }
        PageReference result = pubstats.save();
    }

    @IsTest
    private static void ActualDateFutureDate() {
        Publication__c pub = PubStatusTestPub;
        System.Test.startTest();
    
        //try Changing date for All Author Pub Status
        AppearPubModel pubModel = new AppearPubModel(Pub.Id);
        PubStatusModel pubstats = pubModel.PubStatus;
        
        for (PubStatus__c st: pubstats.PubStatusList)
        {
            if (st.Status__c == StatusModel.SubmittedCompleted.Id )
            {
                st.ActualDate__c = Date.today().addDays(5);
                break;
            }
            
        }
        PageReference result = pubstats.save();
    }

    @IsTest
    private static void ReasonforaChange() {
        Publication__c pub = PubStatusTestPub;
        System.Test.startTest();
    
        //try Changing date for All Author Pub Status
        AppearPubModel pubModel = new AppearPubModel(Pub.Id);
        PubStatusModel pubstats = pubModel.PubStatus;
        
        for (PubStatus__c st: pubstats.PubStatusList)
        {
            if (st.Status__c == StatusModel.SubmittedCompleted.Id )
            {
                st.ActualDate__c = Date.today();
                st.RevisedTargetDate__c = Date.today();
                st.Reason_For_Change__c = null;
                break;
            }
            
        }
        PageReference result = pubstats.save();
    }
    
    @isTest 
    public static void AddStatuses123() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
        StatusModelData.createData();
        Status__c status = StatusModel.LookUpStatus(StatusModel.SubmittedCompletedStatus);
        list<status__c> ststlist = new list<status__c>();
        ststlist.add(status);
        datetime datenow = date.today();
        pagereference pr = StatModel.TerminateFprClick();
        //Pagereference pr2 = StatModel.MaterialChangeClick();              
    }

	@isTest 
    public static void AddStatuses123Extn() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = MovePubtoFPR();
        PubStatusModel statModel = pubModel.PubStatus;
        //StatusModelData.createData();
        Status__c status = StatusModel.LookUpStatus(StatusModel.SubmittedCompletedStatus);
        list<status__c> ststlist = new list<status__c>();
        ststlist.add(status);
        datetime datenow = date.today();
        System.Test.stopTest(); 
        //pagereference pr = StatModel.TerminateFprClick();
        Pagereference pr2 = StatModel.MaterialChangeClick();             
    }
    @isTest 
    public static void AddStatusesForNewSOPChanges() { 
        Publication__c pub = PubStatusTestPub;
        AppearPubModel pubModel = new AppearPubModel(pub.id);
        PubStatusModel statModel = pubModel.PubStatus;
        StatusModelData.createData();
        Status__c statusObj = StatusModel.LookUpStatus(StatusModel.RejectedStatus);
        List<PubStatus__c> pubStatus = new List<PubStatus__c>();
        pubStatus.add( new PubStatus__c(ActualDate__c=Date.today(), Status__c=statusObj.Id));
        Pagereference pagere = StatModel.saveNewPubStatus();
        System.assert(statModel.rejectWithActualDate==0);
    }

    @IsTest
    private static void DraftAfterReject() {
        
        Publication__c pub = PubStatusTestPub;
        
        //System.test.startTest();
        AppearPubViewModel.SubmitSuggestion(pub.Id);
        AppearPubViewModel.RejectPublication(pub.Id);
        //System.test.stopTest();
        
        AppearPubModel checkPub = new AppearPubModel(pub.id);
        System.assertEquals('Rejected', checkPub.PubRecord.Current_Status_FormulaField__c);
    }
    
    @IsTest
    private static void MissingStatusInsertTest() {
        AppearPubModel pubModel = MovePubtoFPR();
        
        pubModel.PubStatus.InsertPublishedPresented(pubModel.CurrentSubmissionCycleId, pubModel.CurrentFprCycleId);
        BatchInsertMissingAcceptedStatus.test();
    }
 
 
    public static Id CreateContact(string fstname){
        //User
        List<User> UserList = new List<User>();
        
        UserList.add (new User (Alias = 'testing',EmailEncodingKey='UTF-8',username=fstname+'@test.com',
        LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles',firstname=fstname,
        lastname='Schoen',profileId =ProfileModel.ProfileNameMap.get('System Administrator').Id,email=fstname+'@salesforce.com' )); 
        
        insert UserList;
        
        Contact newContact = new Contact(AccountId=AccountModel.AccountNameMap.get('AMGEN').Id ,lastname='testing',firstname=fstname,userid__c=UserList[0].Id);
        insert newContact;
        
        return newContact.Id;
                       
    }
    
    //Appear Enhancement R3: Test methods added
    @isTest
    public static void testMethod1(){
      
      Publication__c pub = PubStatusTestPub;
      StatusModelData.createData();
        
        List<Contact> appearContacts = [Select id, FirstName from Contact limit 1];
      
      Profile profile= [select id, name from Profile where name ='Appear Portal Pub Author Login' limit 1];
        User u1 = new User(alias = 'external',ContactId = appearContacts[0].id,email='externaluser@testorg.com',emailencodingkey='UTF-8',lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid =profile.Id ,timezonesidkey='America/Los_Angeles',username='externaluser@testorg.com');
        insert u1;
      
      document d = new Document();
        d.Name='Author Invitation Disclaimer';
        d.AuthorId = UserInfo.getUserId();
        d.FolderId = UserInfo.getUserId();
        insert d;
        
        ProvisionDocumentVersion__c comp = new ProvisionDocumentVersion__c ();
        comp.ProvisionDocumentContent__c = 'testing123';   
        insert comp;
        
        PubAuthor__c PubAuth = new PubAuthor__c();
        PubAuth.Publication__c = Pub.Id;
        PubAuth.Author__c = appearContacts[0].Id;
        PubAuth.AuthorStatus__c='test';
        PubAuth.Disclaimer_ID__c = comp.id;
        PubAuth.ApprovalAcceptedDate__c = date.today();
        insert PubAuth;
      DateTime datenow = date.today();
      
      AppearPubModel pubModel = new AppearPubModel(Pub.Id);
      PubStatusModel statModel = pubModel.PubStatus;
      
      system.Test.startTest();
      list<status__c> ststlist = new list<status__c>();
      Status__c status = StatusModel.LookUpStatus(StatusModel.MaterialChangesForCongressJournalStatus);
        ststlist.add(status);
        
        SubmissionCycle__c subCyc1 = new SubmissionCycle__c();
        subCyc1.Publication__c = pub.Id; 
        subCyc1.Submission_Cycle_Num__c = 1.0;
        insert subCyc1;
        
        Fpr_cycle__c fpr1 = new Fpr_cycle__c();
        fpr1.Publication__c = pub.Id;
        fpr1.FPR_Cycle_Num__c = 2.0  ;
        insert fpr1;
        
        PubStatus__c pubStat1 = new PubStatus__c();
        pubStat1.Publication_id__c = pub.Id;
        pubStat1.Status__c  = ststlist[0].id;
        pubStat1.FPR_Cycle__c = fpr1.id;
        insert pubStat1;
        
        //today
        pubStat1.ActualDate__c = Date.today();
        update pubStat1;
        integer i1 = statmodel.currCycleMaterialChangeWithActualDate;
        //end today
        
        statModel.ResentME(); 
        statModel.insertAgreementSent();
        statModel.insertfinalApprovalresponse(pub.Id);
        
        System.RunAs(u1){
           statModel.insertfinalApprovalresponse(pub.Id);
        }
        
        statModel.InsertRoutePubStatus();
        statModel.InsertRoutePubStatus(datenow);
        statModel.ChangePubStatusToSubmitted();
        PubStatusModel.ToString(pubStat1);
        
        //coverage for ResentMe
        Status__c status2 = StatusModel.LookUpStatus(StatusModel.NonMaterialChangeStatus);
        ststlist.add(status2);
        update ststlist;
        Fpr_cycle__c fpr2 = new Fpr_cycle__c();
        fpr2.Publication__c = pub.Id;
        fpr2.FPR_Cycle_Num__c = 2.0  ;
        insert fpr2;
        PubStatus__c pubStat2 = new PubStatus__c();
        pubStat2.Publication_id__c = pub.Id;
        pubStat2.Status__c  = ststlist[1].id;
        pubStat2.FPR_Cycle__c = fpr2.id;
        insert pubStat2;
        statModel.ResentME();
        
        //today
        pubStat2.ActualDate__c = Date.today();
        update pubStat2;
        integer i2 = statmodel.currCycleNonMaterialChangeWithActualDate;
        integer a1 = statmodel.newSubmissionCycleNum;
        String a2 = statmodel.newAdminStatusId;
        integer a3 = statmodel.newFprCycleNum;
        boolean b1 = statmodel.IsPubRoutedCurrentFPRCycle();
        statmodel.cancelNewPubStatusCreation();
        
        Status__c status3 = StatusModel.LookUpStatus(StatusModel.ResentStatus);
        ststlist.add(status3);
        update ststlist;
        Fpr_cycle__c fpr3 = new Fpr_cycle__c();
        fpr3.Publication__c = pub.Id;
        fpr3.FPR_Cycle_Num__c = 2.0  ;
        insert fpr3;
        PubStatus__c pubStat3 = new PubStatus__c();
        pubStat3.Publication_id__c = pub.Id;
        pubStat3.Status__c  = ststlist[2].id;
        pubStat3.FPR_Cycle__c = fpr3.id;
        insert pubStat3;
        integer i3 = statmodel.currCycleResentWithActualDate;
        
        Status__c status4 = StatusModel.LookUpStatus(StatusModel.RejectedStatus);
        ststlist.add(status4);
        update ststlist;
        Fpr_cycle__c fpr4 = new Fpr_cycle__c();
        fpr4.Publication__c = pub.Id;
        fpr4.FPR_Cycle_Num__c = 2.0  ;
        insert fpr4;
        PubStatus__c pubStat4 = new PubStatus__c();
        pubStat4.Publication_id__c = pub.Id;
        pubStat4.Status__c  = ststlist[3].id;
        pubStat4.FPR_Cycle__c = fpr4.id;
        pubStat4.ActualDate__c = Date.today();
        insert pubStat4;
        integer i4 = statmodel.rejectWithActualDate;
        
        //end today
        
        system.Test.stopTest();
                
    }
    
    //today
    //Appear Enhancement R3 
    @isTest
    public static void testMethod2(){
      
      Publication__c pub = PubStatusTestPub;
      StatusModelData.createData();
      
      system.Test.startTest();
      list<status__c> ststlist = new list<status__c>();
      Status__c status1 = StatusModel.LookUpStatus(StatusModel.MaterialChangeforSubsequentSubmissionStaus);
        ststlist.add(status1);
        
        Meeting__c meet1 = new Meeting__c();
        meet1.Legacy_Meeting__c = 'test Annual EuroPCR';
        meet1.Meeting_Name__c = 'test Annual EuroPCR';
        meet1.MeetingName255__c = 'test Annual EuroPCR';
        insert meet1;
        
        SubmissionCycle__c subCyc1 = new SubmissionCycle__c();
        subCyc1.Publication__c = pub.Id; 
        subCyc1.Submission_Cycle_Num__c = 1.0; 
        subCyc1.Meeting__c = meet1.id;
        //subCyc1.TargetLabelFormula__c = 'Test Arthritis Care and Research';
        subCyc1.Target_Type__c = 'Meeting';
        insert subCyc1;
        
        Fpr_cycle__c fpr1 = new Fpr_cycle__c();
        fpr1.Publication__c = pub.Id;
        fpr1.FPR_Cycle_Num__c = 2.0  ;
        insert fpr1;
        
        PubStatus__c pubStat1 = new PubStatus__c();
        pubStat1.Publication_id__c = pub.Id;
        pubStat1.Status__c  = ststlist[0].id;
        pubStat1.FPR_Cycle__c = fpr1.id;
        pubStat1.IsLogicallyDeleted__c = true;
        insert pubStat1;
        
        
        AppearPubModel pubModel = new AppearPubModel(Pub.Id);
      PubStatusModel statModel = pubModel.PubStatus;
      
        /* PubStatus__c pubStat2 = statModel.PubStatusList[0];
        pubStat2.IsLogicallyDeleted__c = true;
        pubStat2.Status__c  = ststlist[0].id;
        pubStat2.FPR_Cycle__c = fpr1.id;
        pubStat2.Submission_Cycle__c = subCyc1.id; 
        pubStat2.TargetDate__c = date.today();
        update pubStat2;
        
      statModel.deleteSelected(); */
        statModel.InsertSubmitCompleted(subCyc1.id, fpr1.id);
        PubStatusModel.InsertConceptPubStatusForClonedPubs(pub.id);
        
        //rcTypes
        Status__c status2 = StatusModel.LookUpStatus(StatusModel.GlobalStatus);
        ststlist.add(status2);
        statModel.InsertGlobalStatusReviewSubmit(subCyc1.id, fpr1.id);
        
        Status__c status3 = StatusModel.LookUpStatus(StatusModel.AuthorApprovalsStatus);
        ststlist.add(status3);
        statModel.InsertApprovedByAllAuthors(subCyc1.id, fpr1.id);
        
        Status__c status4 = StatusModel.LookUpStatus(StatusModel.FprWithdrawnStatus);
        ststlist.add(status4);
        statModel.saveNewPubStatus();
        
        Status__c status5 = new Status__c();
        status5.New_Status_After_Terminate_FPR__c = true;
        insert status5;
        statModel.InsertNextSubmissionCycleGlobalStatus();
        
        Set<Id> idSet = new Set<Id>();
        idSet.add(pub.id);
        PubStatusModel.GetPubsRoutedCurrentFPRCycle(idSet);
        
        PubStatusModel.SetFprCompletedStatus(pub.id, ststlist[3], subCyc1.id, fpr1.id, 2, datetime.now()); 
        
        system.Test.stopTest();
      
    }
 	
   
}