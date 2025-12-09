@IsTest
public class StatusModelTest {
    @IsTest 
    public static void UnitTestFprc() {
        StatusModelData.createData();
        System.assertNotEquals(null, StatusModel.InFprcStatusIdSet);
        System.assertNotEquals(null, StatusModel.AssignedToFPRC);
        
        System.assertEquals(2, StatusModel.InFprcStatusIdSet.size());

    }
    
    @IsTest
    public static void UnitTestSubmittedStatusSet() {
        StatusModelData.createData();
        Status__c status = StatusModel.LookUpStatus(StatusModel.SubmittedCompletedStatus);
        System.assertNotEquals(null, status);
        Id statusId = status.id;
        System.assertNotEquals(null, statusId);
        
        System.assertNotEquals(null, StatusModel.SubmittedStatusIdSet);
        System.assert(StatusModel.SubmittedStatusIdSet.size() >= 11, 
            'StatusModel.SubmittedStatusIdSet.size() = '+StatusModel.SubmittedStatusIdSet.size() );
        
        System.assert(StatusModel.SubmittedStatusIdSet.contains(statusId));
        
        System.assert(StatusModel.SubmittedStatusIdSet.contains(StatusModel.PublishedPresented.Id));
    }
    
     
    @IsTest
    public static void UnitTest() {
                
        RecordType departmentStatusRecType = RecordTypeModel.LookupRecordType('Status__c','Department_Status');
        RecordType globalStatusRecType = RecordTypeModel.LookupRecordType('Status__c','Global Status');
        RecordType autoInsertRecType = RecordTypeModel.LookupRecordType('Status__c','AutoInsert');
        RecordType legacyStatusRecType = RecordTypeModel.LookupRecordType('Status__c','Legacy Status');
        
        System.assertNotEquals(null, departmentStatusRecType);
        System.assertNotEquals(null, globalStatusRecType);
        System.assertNotEquals(null, autoInsertRecType);
        
        StatusModelData.createData();
        
        System.assertNotEquals(null, StatusModel.StatusList);
        System.assertEquals(45, StatusModel.StatusList.size(), 'found '+StatusModel.StatusList.size()+' status' );
         
        Status__c draftStatus = StatusModel.LookUpStatus('Draft');
        System.assertNotEquals(null, draftStatus);
        System.assertEquals('Execute', draftStatus.stage__c);
        System.assertEquals(globalStatusRecType.id, draftStatus.RecordTypeId);

        
        Status__c conceptStatus = StatusModel.LookUpStatus('Concept');
        System.assertNotEquals(null, conceptStatus);
        System.assertEquals('Plan', conceptStatus.stage__c);
        System.assertEquals(autoInsertRecType.id, conceptStatus.RecordTypeId);
        
        System.assertEquals(10, StatusModel.GlobalStatusList.size(), StatusModel.GlobalStatusList.size());
        //System.assertEquals(13, StatusModel.DepartmentStatusList.size(), StatusModel.DepartmentStatusList.size());
        System.assertEquals(18, StatusModel.AutoInsertStatusList.size(), StatusModel.AutoInsertStatusList.size());
        
        System.assertEquals(null, StatusModel.LookUpStatus('DoesNotExist'));
        System.assertEquals(0, StatusModel.getStatusByRecordType('DoesNotExist').size());
        
        System.assertEquals(45, StatusModel.StatusMap.size());
        
        
        //repeat test from lazy cache
        System.assertEquals(10, StatusModel.GlobalStatusList.size());
        System.assertEquals(13, StatusModel.DepartmentStatusList.size());
        System.assertEquals(18, StatusModel.AutoInsertStatusList.size());
        
        System.assertNotEquals(null, StatusModel.findStatusByTypeName('Department_Status', ''));
        
        
        ////validate importabt global status 
        validateImportantStatus('Draft', globalStatusRecType);
        validateImportantStatus('FPR Withdrawn', departmentStatusRecType);
        validateImportantStatus('FPR Withheld', autoInsertRecType);
        validateImportantStatus('Material Changes for Congress/Journal', autoInsertRecType);
        validateImportantStatus('Routed', autoInsertRecType);
    }
    
    private static void validateImportantStatus (string statusName, RecordType recType){
        Status__c status = StatusModel.LookUpStatus(statusName);
        System.assertNotEquals(null, status);
        System.assertEquals(statusName, Status.name, statusName);
        System.assertEquals(recType.id, Status.RecordTypeId, statusName + ' check recordType');     
    }

    @IsTest
    public static void unitTestCoverage() {
        Map<Id,Status__c> StatusMapBID = New Map<Id,Status__c>();
        StatusModel.StatusMapById = StatusMapBID ;
        Map<String,Status__c> StatusM = New Map<String,Status__c>();
        StatusModel.StatusMap = StatusM ;
        List<Status__c> StatList = New List<Status__c>();
        StatusModel.GlobalStatusList = StatList ;
        StatusModel.NewStatusAFterTerminateFprCycleList= StatList ;
        StatusModel.departmentSTatusList= StatList ;
        StatusModel.AutoInsertSTatusList= StatList ;
         StatusModel.STatusList= StatList ;
        
        StatusModelData.createData();
        Status__c Statustest;
        StatusModel.Unknown = StatusTest;
        StatusModel.Suggested = StatusTest;
        StatusModel.SuggestionRejected = StatusTest;
        StatusModel.ProposalComplete = StatusTest;
        StatusModel.Started = StatusTest;
        StatusModel.DataAnalysisAvailable = StatusTest;
        StatusModel.AuthorAgreementsSent = StatusTest;
        StatusModel.KickOffMeetingMinutesMemo= StatusTest;
        StatusModel.Outline = StatusTest;
        StatusModel.DraftCirculated= StatusTest;
        StatusModel.DraftReviewed= StatusTest;
        StatusModel.WithHeld= StatusTest;
        StatusModel.Approved= StatusTest;
        StatusModel.MaterialChangesForAuthors= StatusTest;
        StatusModel.NonMaterialChange= StatusTest;
        StatusModel.OnlineEarlyRelease= StatusTest;
        StatusModel.PublishedPresented= StatusTest;
        StatusModel.Routed= StatusTest;
        StatusModel.Created= StatusTest;
        StatusModel.FprWithdrawn= StatusTest;
        StatusModel.Accepted= StatusTest;
        StatusModel.AuthorApprovals= StatusTest;
        StatusModel.AuthorNotApproved= StatusTest;
        StatusModel.TerminateFprCycle= StatusTest;
        StatusModel.Concept= StatusTest;
        StatusModel.Draft= StatusTest;
        StatusModel.PendingSuggestion= StatusTest;
        StatusModel.AssignedToFPRC= StatusTest;
        StatusModel.FPRonly= StatusTest;
        StatusModel.Cancelled= StatusTest;
        StatusModel.SubmittedCompleted= StatusTest;
        StatusModel.InFpr= StatusTest;
        StatusModel.Resent= StatusTest;
        
        StatusModel.MaterialChangesForCongressJournal= StatusTest;
        StatusModel.Rejected= StatusTest;
        StatusModel.OnHold= StatusTest;
        StatusModel.WithDrawn= StatusTest;
        //StatusModel.FprCompletedId = StatusTest;
        StatusModel.FprCompleted= StatusTest;
        StatusModel.FprCourtesyCompleted= StatusTest;
        StatusModel.FprCourtesyCompletedWithComment= StatusTest;
        
        
        StatusModel.FprWithHeld= StatusTest;
        StatusModel.DiscussionRequired= StatusTest;
        StatusModel.FprCompletedWithComment= StatusTest;
        
        
        
        
        System.assertNotEquals(null, StatusModel.Unknown);
        System.assertNotEquals(null, StatusModel.SuggestionRejected);
        System.assertNotEquals(null, StatusModel.ProposalComplete);
        System.assertNotEquals(null, StatusModel.Started);
        System.assertNotEquals(null, StatusModel.DataAnalysisAvailable);
        System.assertNotEquals(null, StatusModel.AuthorAgreementsSent);
        System.assertNotEquals(null, StatusModel.KickOffMeetingMinutesMemo);
        System.assertNotEquals(null, StatusModel.Outline);
        System.assertNotEquals(null, StatusModel.OnlineEarlyRelease);
        System.assertNotEquals(null, StatusModel.DraftCirculated);
        System.assertNotEquals(null, StatusModel.DraftReviewed);
        System.assertNotEquals(null, StatusModel.Withheld);
        System.assertNotEquals(null, StatusModel.Approved);
        System.assertNotEquals(null, StatusModel.MaterialChangesforAuthors);
        System.assertNotEquals(null, StatusModel.NonMaterialChange);
        System.assertNotEquals(null, StatusModel.Accepted);
        System.assertNotEquals(null, StatusModel.AuthorNotApproved);
        System.assertNotEquals(null, StatusModel.FPROnly);
        System.assertNotEquals(null, StatusModel.Cancelled);
        System.assertNotEquals(null, StatusModel.SubmittedCompleted);
        System.assertNotEquals(null, StatusModel.MaterialChangesForCongressJournal);
        System.assertNotEquals(null, StatusModel.Resent);
        System.assertNotEquals(null, StatusModel.OnHold);
        System.assertNotEquals(null, StatusModel.WithDrawn);
        System.assertNotEquals(null, StatusModel.FprCompletedId);
        System.assertNotEquals(null, StatusModel.FprCompletedWithComment);

    }
}