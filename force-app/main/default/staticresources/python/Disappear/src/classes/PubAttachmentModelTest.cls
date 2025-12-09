@IsTest
public class PubAttachmentModelTest {
	
	
	private static void createData() {

		CollaborationGroup myGroup = new CollaborationGroup();
		myGroup.Name='Attachments';
		myGroup.CollaborationType='Public'; //can be 'Public' or 'Private'                   
		insert myGroup;

	}
		

    @IsTest
    public static void TestAttachmentLogic() {
    	Test.setCurrentPage(Page.AppearPub); //solves errors from calling ApexPages.currentPage in models
    	
		createData(); 
        Publication__c pub = UnitTestData.PublicationNew('PubAttachmentModelTest');
		AppearPubModel pubModel = new AppearPubModel(Pub.Id);
		System.Test.startTest();
		
		System.assertEquals(null, pubModel.PubAttachments.InsertFeedItem1()); //no name or content
		
		pubModel.PubAttachments.NewAttachment1.AttachmentName__c = 'test';
		
		System.assertEquals(null, pubModel.PubAttachments.InsertFeedItem1()); //name but no content
		
		pubModel.PubAttachments.NewFeedItem1.ContentFileName = 'mockFile.txt';
		pubModel.PubAttachments.NewFeedItem1.ContentData = EncodingUtil.base64Decode('mockContent');		
		System.assertNotEquals(null, pubModel.PubAttachments.InsertFeedItem1()); //success
		
		pubModel.PubAttachments.clearCache();
        //Appear Enhancement 2017 Backlog R2 : starts
        CollaborationGroup myGroup = new CollaborationGroup(Name='Author Attachments',CollaborationType='Public');
        insert myGroup;
        FeedItem NewFeedItem1 = new FeedItem(ContentFileName = 'testTextww.txt',ParentId = pubModel.PubAttachments.AuthorAttachmentGroupId,ContentData = EncodingUtil.base64Decode('TestContentww')); 
        insert NewFeedItem1;
		pubModel.PubAttachments.NewAttachment1.what__c = NewFeedItem1.Id; 
        pubModel.PubAttachments.NewAttachment2.what__c = NewFeedItem1.Id;
        pubModel.PubAttachments.NewAttachment3.what__c = NewFeedItem1.Id;
		//Appear Enhancement 2017 Backlog R2 : ends
		
		pubModel.PubAttachments.InsertAttachment1();
		pubModel.PubAttachments.InsertAttachment2();
		pubModel.PubAttachments.InsertAttachment3();
		
		pubModel.PubAttachments.save();
		pubModel.PubAttachments.deleteSelected();
		pubModel.PubAttachments.findFeedItems(new List<Id>());
		pubModel.PubAttachments.getPubAttachmentMapById();
		
		boolean allowAll = pubModel.PubAttachments.AllowAllDelete;
		boolean allowAdd = pubModel.PubAttachments.AllowAddAttachments;	
		boolean allowAnyDelete = pubModel.PubAttachments.AllowAnyDelete;
		boolean hasDraftForFpr = pubModel.PubAttachments.hasDraftSentForFPRAttachmentType;
		boolean hasVoted = pubModel.PubAttachments.HasVotedForCurrentCycle;
		boolean canViewAttachments = pubModel.PubAttachments.canViewAttachments;
		boolean canAddDelAttachments = pubModel.PubAttachments.canAddDelAttachments;
		boolean CanProfileConfigureAttachments = pubModel.PubAttachments.CanProfileConfigureAttachments;
	    
		pubModel.PubAttachments.getCorrectFPRCycleIdForFPRRelatedAttachments('Draft Sent for FPR');
			    		
				
		PubAttachmentModel.recoverStorageByDeletingAllAttachments();
        System.Test.stopTest();
    }
    
    
        
    @IsTest
    public static void TestAppearAttachmentLogic() {
    	Test.setCurrentPage(Page.AppearPub); //solves errors from calling ApexPages.currentPage in models
    	
    	Publication__c pub = UnitTestData.PublicationNew('PubAttachmentModelTestAppear');
		AppearPubModel pubModel = new AppearPubModel(Pub.Id);
		
		//create a legacy attachment 
		pubModel.PubAttachments.NewAttachment1.AttachmentName__c = 'test';
		pubModel.PubAttachments.NewFeedItem1.ContentFileName = 'mockFile.txt';
		pubModel.PubAttachments.NewFeedItem1.ContentData = EncodingUtil.base64Decode('mockContent');		
		System.assertNotEquals(null, pubModel.PubAttachments.InsertFeedItem1()); //success		

		
		pubModel.PubAttachments.clearCache();
		
		List<PubAttachmentDetails__c> paList = pubModel.PubAttachments.PubAttachmentList;
		System.assertEquals(1, paList.size());
		System.assert(!pubModel.PubAttachments.showLegacyInfo);
		
    }
    
    @IsTest
    public static void TestLegacyAttachmentLogic() {
    	Test.setCurrentPage(Page.AppearPub); //solves errors from calling ApexPages.currentPage in models
    	
    	Publication__c pub = UnitTestData.PublicationNew('PubAttachmentModelTestLegacy');
		AppearPubModel pubModel = new AppearPubModel(Pub.Id);
		
		//create a legacy attachment 
		pubModel.PubAttachments.NewAttachment1.AttachmentName__c = 'test';
		pubModel.PubAttachments.NewAttachment1.LegacyCreatedBy__c = 'A legacy user';
		pubModel.PubAttachments.NewAttachment1.LegacyCreatedDate__c = Date.Today();
		
		pubModel.PubAttachments.NewFeedItem1.ContentFileName = 'mockFile.txt';
		pubModel.PubAttachments.NewFeedItem1.ContentData = EncodingUtil.base64Decode('mockContent');	
	
		System.assertNotEquals(null, pubModel.PubAttachments.InsertFeedItem1()); //success		
		System.assertNotEquals(null, pubModel.PubAttachments.NewAttachment1.What__c);
		
		pubModel.PubAttachments.clearCache();
		
		List<PubAttachmentDetails__c> paList = pubModel.PubAttachments.PubAttachmentList;
		System.assertEquals(1, paList.size());
		System.assert(pubModel.PubAttachments.showLegacyInfo);
		
    }
}