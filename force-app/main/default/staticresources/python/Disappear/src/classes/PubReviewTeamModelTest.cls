@isTest
public with sharing class PubReviewTeamModelTest {
     
    private static AppearPubModel createData() {
        Publication__c pub = UnitTestData.PublicationNew('PubReviewTeamModelTest');
        FPR_Cycle__c fprCycle = new FPR_Cycle__c(FPR_Cycle_Num__c=1, Incremental_FPR_Cycle_c__c=1, Publication__c=pub.Id);
        insert fprCycle; 
        System.Debug('-----------------------'+fprCycle.id);       
        
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = pub.Id;   
        newPubStatusRecord.ActualDate__c = DateTime.Now();
        newPubStatusRecord.Status__c = StatusModel.StatusMap.get('In FPR').Id;
        newPubStatusRecord.FPR_Cycle__c = fprCycle.Id;
        insert newPubStatusRecord;
        System.debug('---------------Pubstatus record--------'+newPubStatusRecord.id);
        System.assertNotEquals(null, pub);
        System.assertNotEquals(null, pub.id);
        System.Debug('*** PubId = '+Pub.id);  
        AppearPubModel pubModel = new AppearPubModel(Pub.Id); 
        return pubModel;
    }
    private static AppearPubModel createDataAccepted() {
        Publication__c pub = UnitTestData.PublicationNew('PubReviewTeamModelTest');
        FPR_Cycle__c fprCycle = new FPR_Cycle__c(FPR_Cycle_Num__c=1, Incremental_FPR_Cycle_c__c=1, Publication__c=pub.Id);
        insert fprCycle; 
        
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = pub.Id;   
        newPubStatusRecord.ActualDate__c = DateTime.Now();
        newPubStatusRecord.Status__c = StatusModel.StatusMap.get('Accepted').Id;
        newPubStatusRecord.FPR_Cycle__c = fprCycle.Id;
        insert newPubStatusRecord;
        System.assertNotEquals(null, pub);
        System.assertNotEquals(null, pub.id);
        System.Debug('*** PubId = '+Pub.id);  
        AppearPubModel pubModel = new AppearPubModel(Pub.Id); 
        return pubModel;
    }
    
   private static AppearPubModel createDataNullfpr() {
        Publication__c pub = UnitTestData.PublicationNew('PubReviewTeamModelTest');
        PubStatus__c newPubStatusRecord = new PubStatus__c();
        newPubStatusRecord.Publication_id__c = pub.Id;   
        newPubStatusRecord.ActualDate__c = DateTime.Now();
        insert newPubStatusRecord;
        AppearPubModel pubModel = new AppearPubModel(Pub.Id); 
        return pubModel;
    } 
    
    
    @isTest(seealldata=true)
    private static void TestLoggedInTeamMemberAdhoc() {
        AppearPubModel pubModel = createData();//load newly inserted status and fpr cycle
        Id userId = userInfo.getUserId();
        System.Debug('*** UserId = '+userId); 
        Test.startTest(); 
        List<Contact> contactsToAdd = new List<Contact>(); 
        Contact newContact = new Contact(lastname='testing',firstname='apex',userid__c=userId);
        contactsToAdd.add(newContact);
        Contact triageContact = new Contact(lastname='testing',firstname='triage',userid__c=userId);
        contactsToAdd.add(triageContact);
        //Contact triageContact2 = new Contact(lastname='testing',firstname='triage2',userid__c=userId);
        //contactsToAdd.add(triageContact2);
        //Contact delegateContact = new Contact(lastname='testing',firstname='delegate',userid__c=userId);
        //contactsToAdd.add(delegateContact);  
        insert contactstoadd; 
        System.assertNotEquals(null, pubModel.pubRecord.Current_FPRCycle_Id_Formula__c);
                       
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = newContact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        PageReference referenceResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();
        //pubModel.pubReviewTeam.RegenerateReviewers();
                      
        System.assertNotEquals(null, pubModel.pubRecord.Current_FPRCycle_Id_Formula__c);
        System.assertNotEquals(true, pubModel.PubReviewTeam.pubStatusPastApprovedByAllAuthors());
        
        //add an ad-hoc triage                
        pubModel.PubReviewTeam.clearCache(); 
        pubModel.PubReviewTeam.selectedAddMethod = 'triage';
        pubModel.PubReviewTeam.triagedById = newContact.Id;
        //pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = triageContact2.ID;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        PageReference triageResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();        
        System.assertEquals(null, triageResult);//assert is error by no justification defined***/   
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Triage_Justification__c = 'Additional legal expertise required';
        //PageReference triageResultnew = pubModel.PubReviewTeam.saveNewReviewTeamMember();        
        //System.assertNotEquals(null, triageResultnew); //null return == encountered error saving
        //pubModel.pubReviewTeam.RegenerateReviewers();
        PageReference pr = pubModel.PubReviewTeam.ShowAllReviewers();
        PageReference prNew = pubModel.PubReviewTeam.ShowCurrentReviewersOnly();
        pubModel.PubReviewTeam.UpdateToCcListForCurrentCycleReviewer('abc@gmail.com','abcd@gmail.com');
        Test.stopTest(); 
                      
        //add an ad-hoc delegate                
        pubModel.PubReviewTeam.clearCache();  
        //pubModel.PubReviewTeam.selectedAddMethod = 'delegate';
        //pubModel.PubReviewTeam.DelegatedById = delegateContact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = triagecontact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        PageReference delegateResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();
        System.assertEquals(null, delegateResult);//assert is error by no justification defined                
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Delegation_Justification__c = 'Reviewer on travel';
        delegateResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();        
        //pubModel.pubReviewTeam.RegenerateReviewers();
        
        
        /***AppearPubModel pubModel2 = createDataNullfpr();
        pubModel2.PubReviewTeam.clearCache();  
        pubModel2.PubReviewTeam.selectedAddMethod = 'delegate';
        //pubModel2.PubReviewTeam.DelegatedById = delegateContact.Id;
        //pubModel2.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = triageContact2.Id;
        pubModel2.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        PageReference delegateResult2 = pubModel2.PubReviewTeam.saveNewReviewTeamMember();
        pubModel2.PubReviewTeam.NewPubReviewTeamMembers.Delegation_Justification__c = 'Reviewer on travel';
        delegateResult2 = pubModel2.PubReviewTeam.saveNewReviewTeamMember(); 
        pubModel.pubReviewTeam.RegenerateReviewers();  **/
        
    }
    
    @isTest(seealldata=true)
    private static void TestLoggedInTeamMemberAdhocAccepted() {
        AppearPubModel pubModel = createDataAccepted();//load newly inserted status and fpr cycle
        Id userId = userInfo.getUserId();
        System.Debug('*** UserId = '+userId); 
        Test.startTest(); 
        List<Contact> contactsToAdd = new List<Contact>(); 
        Contact newContact = new Contact(lastname='testing',firstname='apex',userid__c=userId);
        contactsToAdd.add(newContact);
        Contact triageContact = new Contact(lastname='testing',firstname='triage',userid__c=userId);
        contactsToAdd.add(triageContact);
        //Contact triageContact2 = new Contact(lastname='testing',firstname='triage2',userid__c=userId);
        //contactsToAdd.add(triageContact2);
        //Contact delegateContact = new Contact(lastname='testing',firstname='delegate',userid__c=userId);
        //contactsToAdd.add(delegateContact);  
        insert contactstoadd; 
        System.assertNotEquals(null, pubModel.pubRecord.Current_FPRCycle_Id_Formula__c);
                       
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = newContact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        PageReference referenceResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();
        System.assertEquals(true, pubModel.PubReviewTeam.pubStatusPastApprovedByAllAuthors());
        
        //add an ad-hoc triage                
        pubModel.PubReviewTeam.clearCache(); 
        pubModel.PubReviewTeam.selectedAddMethod = 'triage';
        pubModel.PubReviewTeam.triagedById = newContact.Id;
//        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = triageContact2.ID;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        PageReference triageResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();        
        System.assertEquals(null, triageResult);//assert is error by no justification defined 
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Triage_Justification__c = 'Additional legal expertise required';
        PageReference triageResultnew = pubModel.PubReviewTeam.saveNewReviewTeamMember();        
        //System.assertNotEquals(null, triageResultnew); //null return == encountered error saving
        //pubModel.pubReviewTeam.RegenerateReviewers();
        PageReference pr = pubModel.PubReviewTeam.ShowAllReviewers();
        PageReference prNew = pubModel.PubReviewTeam.ShowCurrentReviewersOnly();
        pubModel.PubReviewTeam.UpdateToCcListForCurrentCycleReviewer('abc@gmail.com','abcd@gmail.com');
        Test.stopTest(); 
                      
        //add an ad-hoc delegate                
        pubModel.PubReviewTeam.clearCache();  
        pubModel.PubReviewTeam.selectedAddMethod = 'delegate';
        //pubModel.PubReviewTeam.DelegatedById = delegateContact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = triagecontact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        PageReference delegateResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();
        //System.assertEquals(null, delegateResult);//assert is error by no justification defined                
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Delegation_Justification__c = 'Reviewer on travel';
        delegateResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();        
        pubModel.pubReviewTeam.RegenerateReviewers();
        
        
       
    }
    
    
    @isTest
    private static void TestLoggedInTeamMember() {
        AppearPubModel pubModel = createData();//load newly inserted status and fpr cycle
        Id userId = userInfo.getUserId();
        System.Debug('*** UserId = '+userId); 
        
        List<Contact> contactsToAdd = new List<Contact>();        
        Contact proxyContact = new Contact(lastname='testing',firstname='proxy',userid__c=userId);
        contactsToAdd.add(proxyContact);
        Contact newContact = new Contact(lastname='testing',firstname='apex',userid__c=userId,Proxy__c=proxyContact.id);
        contactsToAdd.add(newContact);
        Contact triageContact = new Contact(lastname='testing',firstname='triage',userid__c=userId);
        contactsToAdd.add(triageContact);
        Contact triageContact2 = new Contact(lastname='testing',firstname='triage2',userid__c=userId);
        contactsToAdd.add(triageContact2);
        Contact delegateContact = new Contact(lastname='testing',firstname='delegate',userid__c=userId);
        contactsToAdd.add(delegateContact);
        insert contactsToAdd;
        
        System.Debug('*** ContactId = '+newContact.Id); 
        System.Debug('*** FprCycleId = '+pubModel.CurrentFprCycleNum);
        
        AppLogModel.LogDebug('PubReviewTeamModelTest::TestLoggedInTeamMember', 'pubModel.pubRecord.Current_FPRCycle_Id_Formula__c = ' + pubModel.pubRecord.Current_FPRCycle_Id_Formula__c);
        
        //add a review team member
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = newContact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        PageReference referenceResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();
        //pubModel.pubReviewTeam.RegenerateReviewers();
        System.assertNotEquals(null, referenceResult); //encountered error saving
        
        System.assertEquals(1, PubReviewTeamModel.getReviewTeamMembers(pubModel.pubId, true).size());
        List<PubReviewTeam__c> teamMembers = PubReviewTeamModel.getReviewTeamMembersCurrentCycle(pubModel.pubid,pubModel,false);
        System.assertEquals(1, teamMembers.size());   
        
        Test.startTest(); 
        
        System.assertNotEquals(null, pubModel.PubReviewTeam.LoggedInTeamMemberForCycle);  
        // pubModel.PubReviewTeam.saveVote();    // call out in seperate test
        System.assertNotEquals(null, pubModel.pubReviewTeam.NewPubReviewTeamMembers);
        
        integer nextfprCycleNum = integer.valueOf(pubModel.pubRecord.Current_FPR_Cycle_Num__c)+1;
        FPR_Cycle__c fprCycleNext = pubModel.FprCycle.getFprCycleByNum(nextfprCycleNum);
        
        pubModel.PubReviewTeam.ConvertReviewTeamMembers(new List<ReviewTeamMember__c>(),fprCycleNext);

        pubModel.PubReviewTeam.SetDeliveryDateForPubReviewTeam();
        System.assertEquals(2, pubModel.pubReviewTeam.getAddedByItems().size());
        pubModel.PubReviewTeam.saveReviewTeamMemberTriage(); //duplicate reviewer
        Test.stopTest();  


        
        pubModel.PubReviewTeam.CopyPubReviewTeamBetweenCycles(1,2);
        // call out in seperate test 
        /*   
        pubModel.PubReviewTeam.save();   


		     		
        pubModel.PubReviewTeam.clearCache();
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = triageContact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';


        pubModel.PubReviewTeam.saveReviewTeamMemberTriage(); //triage reviewer        
        Test.stopTest();  
        
        pubModel.pubReviewTeam.CopyPubReviewTeamFromSubGroup(pubModel.IncrFprCycle());
        
        pubModel.pubReviewTeam.PubReviewTeamMembers[0].IsLogicallyDeleted__c = true;
        pubModel.pubReviewTeam.deleteSelected();
        PubReviewTeamModel.DeleteAllPubReviewTeamMembers();
        System.assertNotEquals(0, pubModel.pubReviewTeam.getVoterOptions().size());
        System.assertNotEquals(0, pubModel.pubReviewTeam.getAddMethodItems().size());
        
        System.assertEquals(0, PubReviewTeamModel.getReviewTeamMembersCurrentCycle(pubModel.pubid,pubModel,false).size()); //all items removed
        
        
        pubModel.pubReviewTeam.DuplicateAdHocReviewer();
        pubModel.pubReviewTeam.flushCache();
        boolean showRoute = pubModel.pubReviewTeam.ShowRoutePattern;
        string routeString = pubModel.pubReviewTeam.RoutePatternUsedToGenerateReviewTeam;
        
        pubModel.pubReviewTeam.NewPubReviewTeamMembers = null;
        pubModel.pubReviewTeam.RegenerateReviewers();        
        */
    } 


    @isTest
    private static void TestLoggedInTeamMemberSaveVote() {
        AppearPubModel pubModel = createData();//load newly inserted status and fpr cycle
        Id userId = userInfo.getUserId();
        System.Debug('*** UserId = '+userId); 
        
        List<Contact> contactsToAdd = new List<Contact>();        
        Contact proxyContact = new Contact(lastname='testing',firstname='proxy',userid__c=userId);
        contactsToAdd.add(proxyContact);
        Contact newContact = new Contact(lastname='testing',firstname='apex',userid__c=userId,Proxy__c=proxyContact.id);
        contactsToAdd.add(newContact);
        Contact triageContact = new Contact(lastname='testing',firstname='triage',userid__c=userId);
        contactsToAdd.add(triageContact);
        Contact triageContact2 = new Contact(lastname='testing',firstname='triage2',userid__c=userId);
        contactsToAdd.add(triageContact2);
        Contact delegateContact = new Contact(lastname='testing',firstname='delegate',userid__c=userId);
        contactsToAdd.add(delegateContact);
        insert contactsToAdd;
        
        System.Debug('*** ContactId = '+newContact.Id); 
        System.Debug('*** FprCycleId = '+pubModel.CurrentFprCycleNum);
        
        AppLogModel.LogDebug('PubReviewTeamModelTest::TestLoggedInTeamMember', 'pubModel.pubRecord.Current_FPRCycle_Id_Formula__c = ' + pubModel.pubRecord.Current_FPRCycle_Id_Formula__c);
        
        //add a review team member
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = newContact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        PageReference referenceResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();
        //pubModel.pubReviewTeam.RegenerateReviewers();
        System.assertNotEquals(null, referenceResult); //encountered error saving
        
        System.assertEquals(1, PubReviewTeamModel.getReviewTeamMembers(pubModel.pubId, true).size());
        List<PubReviewTeam__c> teamMembers = PubReviewTeamModel.getReviewTeamMembersCurrentCycle(pubModel.pubid,pubModel,false);
        System.assertEquals(1, teamMembers.size());   
        
        Test.startTest(); 
        
        System.assertNotEquals(null, pubModel.PubReviewTeam.LoggedInTeamMemberForCycle);  
        pubModel.PubReviewTeam.saveVote();    // call out in seperate test
        System.assertNotEquals(null, pubModel.pubReviewTeam.NewPubReviewTeamMembers);

        Test.stopTest();  
        

    }


   @isTest
    private static void TestLoggedInTeamMember2() {
        AppearPubModel pubModel = createData();//load newly inserted status and fpr cycle
        Id userId = userInfo.getUserId();
        System.Debug('*** UserId = '+userId); 
        
        List<Contact> contactsToAdd = new List<Contact>();        
        Contact proxyContact = new Contact(lastname='testing',firstname='proxy',userid__c=userId);
        contactsToAdd.add(proxyContact);
        Contact newContact = new Contact(lastname='testing',firstname='apex',userid__c=userId,Proxy__c=proxyContact.id);
        contactsToAdd.add(newContact);
        Contact triageContact = new Contact(lastname='testing',firstname='triage',userid__c=userId);
        contactsToAdd.add(triageContact);
        Contact triageContact2 = new Contact(lastname='testing',firstname='triage2',userid__c=userId);
        contactsToAdd.add(triageContact2);
        Contact delegateContact = new Contact(lastname='testing',firstname='delegate',userid__c=userId);
        contactsToAdd.add(delegateContact);
        insert contactsToAdd;
        
        System.Debug('*** ContactId = '+newContact.Id); 
        System.Debug('*** FprCycleId = '+pubModel.CurrentFprCycleNum);
        
        AppLogModel.LogDebug('PubReviewTeamModelTest::TestLoggedInTeamMember', 'pubModel.pubRecord.Current_FPRCycle_Id_Formula__c = ' + pubModel.pubRecord.Current_FPRCycle_Id_Formula__c);
        
        //add a review team member
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = newContact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        PageReference referenceResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();
        
        Test.startTest(); 
        
        pubModel.PubReviewTeam.clearCache();
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = triageContact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';


        pubModel.PubReviewTeam.saveReviewTeamMemberTriage(); //triage reviewer        

        
        pubModel.pubReviewTeam.CopyPubReviewTeamFromSubGroup(pubModel.IncrFprCycle());
        
        pubModel.pubReviewTeam.PubReviewTeamMembers[0].IsLogicallyDeleted__c = true;
        pubModel.pubReviewTeam.deleteSelected();
        PubReviewTeamModel.DeleteAllPubReviewTeamMembers();
        System.assertNotEquals(0, pubModel.pubReviewTeam.getVoterOptions().size());
        System.assertNotEquals(0, pubModel.pubReviewTeam.getAddMethodItems().size());
        
        System.assertEquals(0, PubReviewTeamModel.getReviewTeamMembersCurrentCycle(pubModel.pubid,pubModel,false).size()); //all items removed
        
        
        pubModel.pubReviewTeam.DuplicateAdHocReviewer();
        pubModel.pubReviewTeam.flushCache();
        boolean showRoute = pubModel.pubReviewTeam.ShowRoutePattern;
        string routeString = pubModel.pubReviewTeam.RoutePatternUsedToGenerateReviewTeam;
        
        pubModel.pubReviewTeam.NewPubReviewTeamMembers = null;
        pubModel.pubReviewTeam.RegenerateReviewers();        
        pubModel.PubReviewTeam.save();   
        Test.stopTest();  
        
    } 

    
   @isTest
    private static void TestLoggedInTeamMemberAccepted() {
        AppearPubModel pubModel = createDataAccepted();//load newly inserted status and fpr cycle
        Id userId = userInfo.getUserId();
        System.Debug('*** UserId = '+userId); 
        
        List<Contact> contactsToAdd = new List<Contact>();        
        Contact proxyContact = new Contact(lastname='testing',firstname='proxy',userid__c=userId);
        contactsToAdd.add(proxyContact);
        Contact newContact = new Contact(lastname='testing',firstname='apex',userid__c=userId,Proxy__c=proxyContact.id);
        contactsToAdd.add(newContact);
        Contact triageContact = new Contact(lastname='testing',firstname='triage',userid__c=userId);
        contactsToAdd.add(triageContact);
        Contact triageContact2 = new Contact(lastname='testing',firstname='triage2',userid__c=userId);
        contactsToAdd.add(triageContact2);
        Contact delegateContact = new Contact(lastname='testing',firstname='delegate',userid__c=userId);
        contactsToAdd.add(delegateContact);
        insert contactsToAdd;
        
        System.Debug('*** ContactId = '+newContact.Id); 
        System.Debug('*** FprCycleId = '+pubModel.CurrentFprCycleNum);
        
        AppLogModel.LogDebug('PubReviewTeamModelTest::TestLoggedInTeamMember', 'pubModel.pubRecord.Current_FPRCycle_Id_Formula__c = ' + pubModel.pubRecord.Current_FPRCycle_Id_Formula__c);
        
        //add a review team member
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = newContact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        PageReference referenceResult = pubModel.PubReviewTeam.saveNewReviewTeamMember();
        //pubModel.pubReviewTeam.RegenerateReviewers();
        System.assertEquals(null, referenceResult); //encountered error saving
        List<PubReviewTeam__c> teamMembers = PubReviewTeamModel.getReviewTeamMembersCurrentCycle(pubModel.pubid,pubModel,false);
        Test.startTest(); 
        pubModel.PubReviewTeam.saveVote();   
        integer nextfprCycleNum = integer.valueOf(pubModel.pubRecord.Current_FPR_Cycle_Num__c)+1;
        FPR_Cycle__c fprCycleNext = pubModel.FprCycle.getFprCycleByNum(nextfprCycleNum);
        
        pubModel.PubReviewTeam.ConvertReviewTeamMembers(new List<ReviewTeamMember__c>(),fprCycleNext);
        pubModel.PubReviewTeam.SetDeliveryDateForPubReviewTeam();
        pubModel.PubReviewTeam.saveReviewTeamMemberTriage(); //duplicate reviewer
        pubModel.PubReviewTeam.CopyPubReviewTeamBetweenCycles(1,2);
        
        pubModel.PubReviewTeam.clearCache();
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Reviewer__c = triageContact.Id;
        pubModel.PubReviewTeam.NewPubReviewTeamMembers.Type__c = 'Primary';
        pubModel.PubReviewTeam.saveReviewTeamMemberTriage(); //triage reviewer
        
        Test.stopTest();  
        
        pubModel.pubReviewTeam.CopyPubReviewTeamFromSubGroup(pubModel.IncrFprCycle());
        pubModel.pubReviewTeam.deleteSelected();
               
    }
    
    @isTest
    private static void testMaxReviewerInsert() {
        integer limitToAssert = 100;
        Id userId = userInfo.getUserId();
        
        List<Contact> contactsToAdd = new List<Contact>(); 
        for (integer i = 0; i < limitToAssert; i++) {
            Contact newContact = new Contact(lastname='testing'+i,firstname='apex'+i,userid__c=userId);
            contactsToAdd.add(newContact);
        }
        insert contactsToAdd; //set initially to utilize cache as in real-world scenario
        
        Test.startTest();
        
        AppearPubModel pubModel = CreateData();
        List<PubReviewTeam__c> reviewersToAdd = new List<PubReviewTeam__c>();
        
        for(Contact contactToAdd : contactsToAdd) {
            PubReviewTeam__c primaryReviewer = new PubReviewTeam__c( Reviewer__c = contactToAdd.Id, Type__c = 'Primary', 
                                                         Publication__c = pubModel.PubId, FPR_Cycle__c = pubModel.PubRecord.Current_FPRCycle_Id_Formula__c); 
            reviewersToAdd.add(primaryReviewer);
        }
        insert reviewersToAdd;
        
        for (PubReviewTeam__c addedReviewer : reviewersToAdd) {
            system.assertNotEquals(null, addedReviewer.Id);
        }
        
        Test.stopTest();
    }
        
}