global class BatchSharePubAttachments extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {
    
    public String SOQL = 'select Publication__c, What__c from PubAttachmentDetails__c where isSharedWithCommunity__c = false and what__c !=\'00-00\' and  Attachment_URL__c != null';
    
    public BatchSharePubAttachments() {
        super();
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
        }
        else {
    		SOQL = SOQL + ' and createdDate < 2014-01-12T00:00:00.00z limit 45000';  //45000 records maximum 
    	}
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchSharePubAttachments';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    

    global void execute(Database.BatchableContext BC, List<PubAttachmentDetails__c> attachments){
        Map<Id,Id> feedItemIdToPubIdMap = new Map<Id,Id>();//used for query
        for(PubAttachmentDetails__c attachment : attachments) {
            feedItemIdToPubIdMap.put(attachment.What__c, attachment.Publication__c);
            attachment.isSharedWithCommunity__c = true;
        }
        
        
        
        List<FeedItem> relatedFeedItems = [SELECT Id, RelatedRecordId FROM FeedItem WHERE Id in :feedItemIdToPubIdMap.keySet()];
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        for(FeedItem relatedFeedItem : relatedFeedItems) {
            Id pubId = feedItemIdToPubIdMap.get(relatedFeedItem.Id);
            Id contentVersionId = relatedFeedItem.RelatedRecordId;
            if (pubId == null || contentVersionId == null) {
                continue;
            }
            
            FeedItem pubFeedItem = new FeedItem();
            pubFeedItem.RelatedRecordId = contentVersionId;
            pubFeedItem.ParentId = pubId;
            pubFeedItem.Type = 'ContentPost';
            pubFeedItem.Visibility = 'AllUsers';
            feedItemsToInsert.add(pubFeedItem);
        }
        
        if (feedItemsToInsert.size() > 0) {
            insert feedItemsToInsert;
        }
        
        update attachments;
                
        AppLogModel.flushLogs();
    }
    

    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
    }
    
    public static void runNow(){
        BatchSharePubAttachments batch = new BatchSharePubAttachments();
        Database.executeBatch(batch, 1000);
    }
}