public with sharing class ContentVersionTriggerLogic {
    
    public static void contentVersionAfterInsertLogic(List<ContentVersion> conVersList){        
        
        set<id> contentDocumentSet = new set<Id>();
        for(ContentVersion conVer : conVersList){
            contentDocumentSet.add(conVer.ContentDocumentId);
        }
        
        /*Fetching the First Content Version ID of all the content version documents inserted*/
        List<ContentVersion> firstVersionIdList = [Select Id, ContentDocumentId from contentversion where contentdocumentId in :contentDocumentSet
                                                    and VersionNumber = '1'];
        // Fetching the ORG URL
        String baseURL = KeyValueSettingsModel.GetKey('ChatterFeedItem_BaseDomain').value__c;
        
        Map<Id,Id> attachmentDetailMap = new Map<Id,Id>();
        Map<String,Id> attchmntURLMap = new Map<String,Id>();
        List<string> attachmentURLList = new List<string>();
        for(ContentVersion cv : firstVersionIdList){
            attachmentURLList.add(baseURL + '/' +cv.Id);
            attchmntURLMap.put(baseURL + '/' +cv.Id,cv.ContentDocumentId);
        }
        List<PubAttachmentDetails__c> dsAttachmentList = [Select Id,AttachmentType__c,Attachment_URL__c,Publication__c from PubAttachmentDetails__c where
                                                            AttachmentType__c = 'Draft - Share with Authors' and Attachment_URL__c in :attachmentURLList ];
        
        set<Id> publicationIdSet = new set<Id>();
        for(PubAttachmentDetails__c pad : dsAttachmentList){
            publicationIdSet.add(pad.Publication__c);
            attachmentDetailMap.put(attchmntURLMap.get(pad.Attachment_URL__c),pad.Id);
        }
        
        Map<id,PubAuthor__c> authorUserIdAuthorMap =  new Map<id,pubAuthor__c>(); //Appear Enhancement R5 : Update CommentReceivedDate__c on new content version upload
        
        List<pubAuthor__c> pubAuthorList = [Select Id, Author__c,Author__r.UserId__c,CommentReceivedDate__c from pubAuthor__c where Publication__c in :publicationIdSet and isLogicallyDeleted__c = false]; //Appear Enhancement R5 : CommentReceivedDate__c added in the query
        set<Id> authorUserIdSet = new set<Id>();
        if(!pubAuthorList.isEmpty()){
            for(pubAuthor__c pubAuth : pubAuthorList){
                authorUserIdSet.add(pubAuth.Author__r.UserId__c);
                 authorUserIdAuthorMap.put(pubAuth.Author__r.UserId__c,pubAuth);//Appear Enhancement R5 : Update CommentReceivedDate__c on new content version upload
            }
        }
        
        /* Inserting comments in Feed Item*/
        List<FeedItem> feedItemList = new List<FeedItem>();
        
        PubAuthor__c authorCommentUpdate ;//Appear Enhancement R5 : Update CommentReceivedDate__c on new content version upload
        Boolean check = false;//Appear Enhancement R5 : Update CommentReceivedDate__c on new content version upload
        List<Database.Saveresult> sr;//Appear Enhancement R5 : Update CommentReceivedDate__c on new content version upload
        
        for(ContentVersion contentVersion : conVersList){
            if(contentVersion.VersionNumber != '1' && attachmentDetailMap.get(contentVersion.ContentDocumentId)!= null && authorUserIdSet.contains(contentVersion.CreatedById)){
                feedItemList.add(new FeedItem(parentid = attachmentDetailMap.get(contentVersion.ContentDocumentId), RelatedRecordId =contentVersion.Id, 
                                          createdbyid =contentVersion.CreatedById, CreatedDate= contentVersion.CreatedDate,  
                                          Body= 'Please See Attached',
                                          Type= 'TextPost', Visibility= 'AllUsers'));
              
	             //Appear Enhancement R5 : Update CommentReceivedDate__c on new content version upload : start//
	             authorCommentUpdate =  authorUserIdAuthorMap.get(contentVersion.CreatedById); 
	             if(authorCommentUpdate.CommentReceivedDate__c == null){
	             authorCommentUpdate.CommentReceivedDate__c= System.Now();
	             check = true;
	             }
	             //Appear Enhancement R5 : Update CommentReceivedDate__c on new content version upload : end//
            }
        }
        try{
            //insert feedItemList;
            sr = database.insert(feedItemList, true);//Appear Enhancement R5 : Update CommentReceivedDate__c on new content version upload
            //Appear Enhancement R5 : Update CommentReceivedDate__c on new content version upload : start//
            if (authorCommentUpdate != null && check == true && sr[0].isSuccess() ){
               update authorCommentUpdate;
            }
            //Appear Enhancement R5 : Update CommentReceivedDate__c on new content version upload : end//
        }catch(DMLException de){
            system.debug('DML Exception caught'+de);
        }
        
    }
}