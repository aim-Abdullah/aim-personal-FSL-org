@istest
public class AppearPubModelTest {    
    private static void createData() {      
        TherapeuticAreaModelData.createData();
        PubProdIndModelTest.CreateData();
        StatusModelData.createData();
        JournalModelData.createData();
        MeetingModelData.createData();      
        AccountModelData.createData();  
        //R1:2017 - max author count data
        KeyValueSettings__c kvs = new KeyValueSettings__c(Name='CSP Pub Author Count',Key__c='Max_Author_Count',Value__c='10');
		insert kvs;
        
        //insert contact for user
        Contact contact = new Contact(UserId__c=UserInfo.getUserId(),
         LastName= 'user', FirstName='test',
         AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,
         Email='mike@amgen.com');
         
        insert contact;
    }
    
    @isTest 
    public static void unitTestUpdatePubIsEnbrelIsBiosimilar() {
        createData();
        
        Publication__c pub = UnitTestData.PublicationNew('AppearPubModelTestEnbrel');
        
        boolean IsEnbrelPub = true;
        Id TAid = TherapeuticAreaModel.TaList[0].id;
        AppearPubModel.UpdateProductIndicationForPub(pub.id, 'A production indication String', IsEnbrelPub, TAid);
        
        AppearPubModel activePub = new AppearPubModel(pub.id);
        System.assertEquals('A production indication String', activePub.PubRecord.Product_Indication__c);
        System.assertEquals(true,activePub.PubRecord.isEnbrel__c);
        System.assertEquals(TAid, activePub.PubRecord.TA__c);
        
        User u1 = ([Select Id from user where ProfileId =: '00eU0000000sFpU' LIMIT 1 ]);
        List<id> uid = new List<id>();
        uid.add(u1.Id);
        Status__c status;
        String st;
        AppearPubModelShare Apms = new AppearPubModelShare(pub.id);
        AppearPubModelShare.pubTeamShareEdit(pub.id, uid, status);
        apms.PubreviewTeamshareEdit(uid);
        AppearPubModelShare.SetGPPLRoleGroup(st); 
        AppearPubModelShare.SetWritingRoleGroup(st);
        AppearPubModelShare.SetFPRCRoleGroup(st); 
    }
    
    @isTest
    public static void unitTest() {
        createData();  
        System.assertNotEquals(null, StatusModel.Concept);
              
        //create pub        
        Publication__c pub = UnitTestData.PublicationNew('AppearPubModelTest');  
        System.assert(ProductIndicationModel.ProductIndicationList.size() > 0 );
        set<string> prodIndicationStringSet = new set<string>();        
        for(ProductIndication__c pi : ProductIndicationModel.ProductIndicationList) {
            prodIndicationStringSet.add(pi.name);
            if ( prodIndicationStringSet.size() > 5) break;
        }        
        PubProdIndModel.insertPubProdInd(pub.id, prodIndicationStringSet);       
        Journal__c journal = [Select Id from Journal__c limit 1]; 
        Meeting__c meeting = [Select Id from Meeting__c limit 1];
        
        
        //create pub model
        AppearPubModel pubModel = new AppearPubModel(pub.id);
        System.Test.startTest();
        
        pubmodel.UpdateProjectstudy(pub.id, 'Projectstudystring');
        pubmodel.resetCurrentStatus();
        pubmodel.CountVote();
        pubModel.showSharingdetails();
        pubModel.hideSharingDetails();
        
        //properties
        system.assert(!pubModel.PubName.equals(''));
        system.assert(!pubModel.PubTitle.equals(''));
        system.assert(!pubModel.PubType.equals(''));     
        system.assertNotEquals(null, pubModel.NewFprOnlyPublication);  
        system.assertNotEquals(null, pubModel.PubTypeId);   
        system.assertNotEquals(null, pubModel.RecordTypeName);  
        system.assertNotEquals(null, pubModel.PreFprReviewer);
        system.assertNotEquals(null, pubModel.CurrentRoutePattern);
        system.assertNotEquals(null, pubModel.PubStage);
        
        system.assertEquals(null, pubModel.PubClassification);
        system.assertEquals(null, pubModel.PubProductIndicationNotFound);
        system.assertEquals(null, pubModel.ListDetailObject);   
        system.assertEquals(false, pubModel.isEnbrel);
        system.assertEquals(false, pubModel.IsCommentsOnly); 
        system.assertEquals(null, pubModel.Authors);
        system.assertEquals(true, pubModel.AllowReviewTeamEdit);        
        system.assertEquals('', pubModel.CurrentTarget);     
        pubModel.IsCommentsOnly = true;   
               
        //submodels
        system.assertNotEquals(null, pubModel.PubHeader);
        system.assertNotEquals(null, pubModel.PubStatus);
        system.assertNotEquals(null, pubModel.PubStudy);
        system.assertNotEquals(null, pubModel.PubTeamMember);
        system.assertNotEquals(null, pubModel.PubScientificStatement);
        system.assertNotEquals(null, pubModel.RelatedPub);
        system.assertNotEquals(null, pubModel.SubmissionCycle);
        system.assertNotEquals(null, pubModel.FprCycle);
        system.assertNotEquals(null, pubModel.SubGroup);
        system.assertNotEquals(null, pubModel.PubMe);
        system.assertNotEquals(null, pubModel.PubAuthor);
        system.assertNotEquals(null, pubModel.PubProdIndication);
        system.assertNotEquals(null, pubModel.PubAttachments);
        system.assertNotEquals(null, pubModel.PubHeader);
        
        //VF props
        system.assertEquals(0, pubModel.AllFPRCPubList.size());  
        system.assertEquals(0, pubModel.MyFPRCPubList.size());   
        system.assertEquals(0, pubModel.routedPublicationsForReviewer.size()); 
        System.assertNotEquals(0, pubModel.PubProdIndNameList.size()); 
        system.assertNotEquals(null, pubModel.FprDetailUrl);
        system.assertNotEquals(null, pubModel.sharingDetails);   
        boolean temp = pubModel.isSystemAdmin;
        
        //target functions
        system.assertEquals('journal', pubModel.targetMode); 
        pubModel.newTargetId = journal.Id;
        system.assertNotEquals(null, pubModel.saveTarget()); 
        pubModel.targetMode = 'meeting';
        system.assertEquals('meeting', pubModel.targetMode);
        pubModel.newTargetId = meeting.Id;
        system.assertEquals(meeting.Id, pubModel.newTargetId);  
        system.assertNotEquals(null, pubModel.saveTarget());    
        pubModel.targetMode = 'testInvalidEntry';
        pubModel.saveTarget();
        
        //functions     
        system.assertNotEquals(false, pubModel.Persist());  
        pubModel.FPRCAssignToMe();   
        //Appear Enhancement R1: 2017 : below lines 138-140 commented as SaveNewFprOnlyPublication is modified
        //coverage for the same is done in AppearPubViewModelTest.fprquestionTest()
        /*system.assertEquals(null, pubModel.SaveNewFprOnlyPublication());
        pubModel.NewFprOnlyPublication.Publication_Title__c = 'test';
        system.assertNotEquals(null, pubModel.SaveNewFprOnlyPublication());
        */
        pubModel.ChangeOwnershipToFprSubmitter(false);
        pubModel.ChangeOwnershipToCurrentUser(false);
        system.assertNotEquals(null, pubModel.IncrFprCycle());
        system.assertNotEquals(null, pubModel.IncrSubmissionCycle());
        pubModel.FprOnlySubmitPub();
        
        //static functions        
        system.assertNotEquals(0, AppearPubModel.findPubsByNameA('AppearPubModelTest').size());
        system.assertEquals(0, AppearPubModel.findPubsByNameA('invalid').size());
        system.assertNotEquals(null, AppearPubModel.findPubName(pub.Id));
        List<Publication__c> pubsToSync = new List<Publication__c>();
        pubsToSync.add(pub);        
        AppearPubModel.SyncPubIndicationFields(pubsToSync);
        //AppearPubModel.resetPubStatus();
        //AppearPubModel.resetSharing(pub.Id);
        AppearPubModel.checkForDup(null,null);//invalid id
        AppearPubModel.checkForDup('AppearPubModelTest','a00K0000002Cf94IAC');//invalid id
        //system.assertEquals(1, AppearPubModel.findPublicationsForReviewer().size());
        //system.assertEquals(0, AppearPubModel.findMyFPRCPubList(UserInfo.getUserId()).size());
                
        System.Test.stopTest();
        
        //pub cleanup tests
        //system.assertNotEquals(null, pubModel.DeleteThisPub());
    }
    
    @IsTest
    private static void testFailConditions() {
        AppearPubModel pubModel = new AppearPubModel('a00K0000002Cf94IAC');//invalid id
        
        system.assert(!pubModel.PubName.equals(''));
        system.assert(!pubModel.PubTitle.equals(''));
        system.assert(!pubModel.PubClassification.equals(''));
        system.assert(!pubModel.PubProductIndicationNotFound.equals(''));
        system.assert(!pubModel.PubType.equals(''));
        system.assert(!pubModel.CurrentStatus.equals(''));
        system.assert(!pubModel.PubStage.equals(''));
        system.assert(!pubModel.RecordTypeName.equals(''));
        pubModel.getFprSubmitterMyRequestOptions();
        pubModel.getReviewerMyRequestOptions();
        
        system.assert(pubModel.Authors.equals(''));
        
        system.assertEquals(null, pubModel.PubTypeId);  
        system.assertEquals(null, pubModel.pubRecord);  
        system.assertEquals(false, pubModel.IsCommentsOnly);
        system.assertEquals(false, pubModel.Persist());
    }
// for increasing the code coverage, the code is implemented
        @IsTest
        public static void testDeletePub(){
          Publication__c newPub = UnitTestData.PublicationNew('Test Clond Pub');
          AppearPubModel activePub = new AppearPubModel(newPub.Id);
          activePub.DeleteThisPub();
        }
    }