@IsTest
public class PubAttachmentUpdateWebServiceTest {

    public static final string pubSiebelId = 'TestPubSiebelId';
    public static final string pubAttachmentDetailsSiebelId = 'TestAttachSiebelId';
	public static final string fileName = 'TestFileName';

    @IsTest
  
    public static void UnitTest() {
		createPubWithAttachment();
    }
    
    //PubAttachmentUpdateWebServiceTest.createPubWithAttachment();
    public static void createPubWithAttachment(){
       	id pubId = createData();
    	id feedItemId = createAttachment(pubId);
    	System.assertNotEquals(null, feedItemId);
    	
    	PubAttachmentUpdateWhatWebService.post(pubId, pubAttachmentDetailsSiebelId, feedItemId, fileName); 	
    	
    	List<PubAttachmentDetails__c> details = PubAttachmentModel.getAllPubAttachmentList(Pubid);
		System.assertEquals(1, details.size());
		System.assertEquals(pubAttachmentDetailsSiebelId, details[0].SiebelRowId__c);
    	System.assertEquals(feedItemId, details[0].what__c);
    	System.assertEquals(fileName, details[0].AttachmentName__c);
    	System.assertNotEquals(null, details[0].Attachment_URL__c);
    }
    

    
    //PubAttachmentUpdateWebServiceTest.createData();
    public static id createData() {
    	cleanup();
	
		Publication__c testpub = UnitTestData.PublicationNew('PubAttachmentUpdateWebServiceTest');
		System.assertNotEquals(null, testpub.id);
		testpub.SiebelRowId__c = pubSiebelId;
		update testpub;
		
		AppearPubModel activePub = new AppearPubModel(testPub.id);
		System.assert(activePub.hasValidPub);
		System.assertEquals(pubSiebelId, activePub.pubRecord.SiebelRowId__c);
		
		PubAttachmentDetails__c attachment = activePub.PubAttachments.getNewAttachment();
		attachment.SubmissionCycle__c = activePub.CurrentSubmissionCycleId;
		attachment.SiebelRowId__c = pubAttachmentDetailsSiebelId;
		attachment.What__c = 'missing';
		insert attachment; 
		//activePub.PubAttachments.InsertAttachment(attachment);
		
		List<PubAttachmentDetails__c> details = PubAttachmentModel.getAllPubAttachmentList(testPub.id);
		System.assertEquals(1, details.size());
		System.assertEquals(pubAttachmentDetailsSiebelId, details[0].SiebelRowId__c);
		
		return testpub.id;
    }  
    
    //create a dump attachment 
    public static id createAttachment(id parentId) {
    	
    	FeedItem item = new FeedItem();
    	item.Title = 'test FeedItem';
    	item.Body = 'just a dummy string for a feed item';
    	item.ParentId = ParentId;
    	insert item;
    	
    	return item.id;
    	
    }
    
    
    
    public static void cleanup() {
     	
    	List<PubAttachmentDetails__c> oldDetails= [select id from PubAttachmentDetails__c where SiebelRowId__c = :pubAttachmentDetailsSiebelId];
    	if ( oldDetails.size() > 0 ) {
    		delete oldDetails;
    	}
    	List<Publication__c> oldPubs = [select id from Publication__c where SiebelRowId__c = :pubSiebelId];
    	if ( oldPubs.size() > 0) {
    		for ( Publication__c pub : oldPubs) {
    			AppearPubModel.DeletePub(pub.id);
    		}
    	}   	
    }
}