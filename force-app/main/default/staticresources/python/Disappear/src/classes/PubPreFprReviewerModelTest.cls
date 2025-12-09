@IsTest
public with sharing class PubPreFprReviewerModelTest {
	
	private static AppearPubModel createData() {
        Publication__c pub = UnitTestData.PublicationNew('PubPreFprReviewerModelTest');
        
        System.assertNotEquals(null, pub);
        System.assertNotEquals(null, pub.id);
        
        System.Debug('*** PubId = '+Pub.id);    
        
        AppearPubModel pubModel = new AppearPubModel(Pub.Id, '', '', true);
        return pubModel;
	}
	
	@IsTest
	public static void UnitTest() {
		AppearPubModel pubModel = createData();
        Id userId = userInfo.getUserId();
		
		
        PubPreFprReviewerModel.InsertFprSubmitter(pubModel.PubId, userId);//fail with no assoc. contact
		
        Contact contact1 = new Contact(lastname='testing',firstname='contact1',userid__c=userId);
        insert contact1;
        
        pubModel.PreFprReviewer.NewPubPreFprReviewMember.PreFprReviewer__c = contact1.id;
        pubModel.PreFprReviewer.saveNewPreFprReviewer();
        
        PubPreFprReviewerModel.InsertFprSubmitter(pubModel.PubId, userId);
        
        Contact contact2 = new Contact(lastname='testing',firstname='contact2',userid__c=userId);
        insert contact2;
        
        List<PublicationTeamMember__c> mockMembers = new List<PublicationTeamMember__c>();
        PublicationTeamMember__c mockMember1 = new PublicationTeamMember__c();
        mockMember1.Publication__c = pubModel.PubId;
        mockMember1.Member__c = contact2.id;        
        mockMembers.add(mockMember1);
        
        System.assertEquals(2, pubModel.PreFprReviewer.PubPreFprReviewerList.size());
        
        
        PubPreFprReviewerModel.CopyPubTeamMembersAsPreFprReviewer(mockMembers, pubModel.PubId);
        pubModel.PreFprReviewer.clearCache(); 
        
        System.assertEquals(3, pubModel.PreFprReviewer.PubPreFprReviewerList.size());
        
        pubModel.PreFprReviewer.Save();
        
        pubModel.PreFprReviewer.PubPreFprReviewerList[1].IsSelected__c = true;
        pubModel.PreFprReviewer.deleteSelected();
        
        PubPreFprReviewerModel.InsertFprSubmitter(pubModel.PubId, userId);//fail with too many assoc. contact
        
        PubPreFprReviewerModel.CopyPubTeamMembersAsPreFprReviewerFuture(pubModel.PubId);
	}
	
	@IsTest
	public static void FailCases() {
		 Publication__c pub = UnitTestData.PublicationNew('PubPreFprReviewerModelTestFailCases');
        
        AppearPubModel pubModel = new AppearPubModel(Pub.Id);
        System.AssertNotEquals(null,pubModel.PreFprReviewer.NewPubPreFprReviewMember); //lazy-load for fail cases
        pubModel.PreFprReviewer.saveNewPreFprReviewer(); //cycling error cases
        
	}
}