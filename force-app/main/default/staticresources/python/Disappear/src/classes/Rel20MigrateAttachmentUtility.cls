public with sharing class Rel20MigrateAttachmentUtility {
	/*
	//This function does not seem to work. 17 inserts in dev attempted, saw count go up by 1, and https://dev20-appeardev20.cs11.force.com/FprSubmitter/069Z00000005IHR is still inaccessible from the portal.
	public static void MigrateAllAttachmentFeedItems() {
		Id groupId = null;
		
		List<CollaborationGroup> groups = [SELECT Id FROM CollaborationGroup WHERE Name = 'Attachments'];
		if (groups.size() > 0) {
			groupId = groups[0].Id;
		}
		
		Id communityId = null;
		List<Network> networks = [SELECT Id FROM Network WHERE Name = 'FPR Submitter'];
		if (networks.size() > 0) {
			communityId = networks[0].Id;
		}
		
		if (groupId == null || communityId == null) {
			return;
		}
		
		//cannot filter for ContentFileName or other fileds in query, so only ParentId is filtered
		List<FeedItem> feedItems = [Select Body, CommentCount, ContentData, ContentDescription, ContentFileName, 
									ContentSize, ContentType, CreatedById, CreatedDate, Id, InsertedById, IsDeleted, 
									LastModifiedDate, LikeCount, LinkUrl, NetworkScope, ParentId, RelatedRecordId, 
									SystemModstamp, Title, Type, Visibility
									from FeedItem
									where ParentId <> :groupId AND id = '0D5Z000000KBZfoKAH']; 
		
		//List<FeedItem> feedItemsToInsert = new List<FeedItem>();
		for(FeedItem feedItemToCheck : feedItems) {
			if (feedItemToCheck.ContentFileName == null || feedItemToCheck.ContentFileName == '') {
				continue;
			}
			
			//unable to bulkify here. Todo: test limit
			ConnectApi.ChatterFeeds.shareFeedItem(null, ConnectApi.FeedType.Record, groupId, feedItemToCheck.Id);
			
       		/*FeedItem newItem = new FeedItem();
            newItem.ParentId = groupId;
            newItem.Body = 'Pub Attachment';
            newItem.RelatedRecordId = feedItemToCheck.RelatedRecordId;
			
				
			ewItem.ParentId = groupId;
			newItem.NetworkScope = '0DBZ00000004CBEOA2';
			newItem.Visibility = 'AllUsers';
			newItem.ContentFileName = null;
			newItem.ContentData = null;
			feedItemsToInsert.add(newItem);*/
		//}
		
		/*if (feedItemsToInsert.size() > 0) {
			//database.insert(feedItemsToInsert, false);
			insert feedItemsToInsert;
		}*/
	//}
	
	
	
	
}