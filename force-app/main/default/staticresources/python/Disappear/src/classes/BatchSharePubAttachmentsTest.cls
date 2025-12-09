@isTest
public class BatchSharePubAttachmentsTest {
    @isTest
    private static void unitTest() {
        CreateData();       
        
        List<FeedItem> allFeedItems = [Select id From FeedItem];
        System.assertEquals(1, allFeedItems.size());
        
        
        List<ContentVersion> allContentVersions = [Select id From ContentVersion];
        System.assertEquals(1, allContentVersions.size());
        
        BatchSharePubAttachments.runNow();
        
        
    } 
    
    private static void CreateData() {
        Publication__c testPub = UnitTestData.PublicationNew('BatchSharePubAttachmentsTestPub');
        
        FeedItem pubFeedItem = new FeedItem();
        pubFeedItem.ContentFileName = 'testFile.txt';
        pubFeedItem.ContentData = blob.valueOf('BatchSharePubAttachmentsTestPub');
        pubFeedItem.ParentId = testPub.Id;
        pubFeedItem.Type = 'ContentPost';       
        insert pubFeedItem;
        
        PubAttachmentDetails__c pubAttachmentDetails = new PubAttachmentDetails__c(What__c = pubFeedItem.Id,issharedwithcommunity__c= false, Publication__c = testPub.Id);
        insert pubAttachmentDetails;
    }
}