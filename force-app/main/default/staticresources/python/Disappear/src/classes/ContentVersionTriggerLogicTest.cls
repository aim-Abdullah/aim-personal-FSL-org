@IsTest
public with sharing class ContentVersionTriggerLogicTest {
	
	/*Test Class for Uploading a New Version*/
	
	/*@IsTest
	public static void uploadNewVersion(){
		
		Network network = [SELECT Id FROM Network WHERE Name = 'FPR Submitter' limit 1];
		
		ContentVersion conVer1 = new ContentVersion();
		conVer1.Description='First Version Creation';conVer1.VersionData = blob.valueof('New Test Document.txt');
		conVer1.OwnerId= UserInfo.getUserId();conVer1.NetworkId = network.Id;conVer1.Title='First Version';
		conVer1.PathOnClient='www.google.com';
		insert conVer1;		
		System.debug('******'+conVer1);
		
		
	}*/
	private static void createData() {

		List<CollaborationGroup> myGroup = new List<CollaborationGroup>();
		myGroup.add(new CollaborationGroup(Name='Author Attachments',CollaborationType='Public')); //can be 'Public' or 'Private'                   
		myGroup.add(new CollaborationGroup(Name='Attachments',CollaborationType='Public'));
		insert myGroup;
		
		

	}
	@IsTest
	public static void uploadNewVersion1(){
		Test.setCurrentPage(Page.AppearPub); //solves errors from calling ApexPages.currentPage in models
    	createData();
    	Publication__c pub = UnitTestData.PublicationNew('PubAttachmentModelTestAppear');
		AppearPubModel pubModel = new AppearPubModel(Pub.Id);
		
		//create a legacy attachment 
		pubModel.PubAttachments.NewAttachment1.AttachmentName__c = 'test';
		//pubModel.PubAttachments.NewAttachment1.AttachmentType__c = 'Draft - Share with Authors';
		pubModel.PubAttachments.NewFeedItem1.ContentFileName = 'mockFile.txt';
		pubModel.PubAttachments.NewFeedItem1.ContentData = EncodingUtil.base64Decode('mockContent');		
		System.assertNotEquals(null, pubModel.PubAttachments.InsertFeedItem1()); //success		

		
		pubModel.PubAttachments.clearCache();
		
		//Appear Enhancement R5 :start
		List<Contact> appearContacts = new List<Contact>();
        appearContacts.add(new Contact(FirstName='Pub',LastName='Author',UserId__c=userinfo.getUserId(),email='testpubauxyz1@amgen.com',country__c='United States',middleName='test'));
    	Database.insert(appearContacts);
		PubAuthor__c PubAuth = new PubAuthor__c();
        PubAuth.Publication__c = Pub.Id;
        PubAuth.Author__c = appearContacts[0].Id;
        PubAuth.AuthorStatus__c='test';
        PubAuth.CommentReceivedDate__c = null;
        PubAuth.InviteAcceptedDate__c = System.today();
        PubAuth.InviteSentDate__c = System.today();
        PubAuth.DraftShareDate__c = System.today();
        PubAuth.GrantDraftAccess__c = true;
        insert PubAuth;
		//Appear Enhancement R5 :stop
		
		List<PubAttachmentDetails__c> paList = pubModel.PubAttachments.PubAttachmentList;
		System.assertEquals(1, paList.size());
		System.assert(!pubModel.PubAttachments.showLegacyInfo);
		paList[0].AttachmentType__c = 'Draft - Share with Authors';
		update paList;
		string []urlSegments = paList[0].Attachment_URL__c.split('/', 0);
		List<ContentVersion> conVer = [Select contentdocumentId from contentversion where id =:ID.valueOf(urlSegments[urlSegments.size()-1])];
		
		System.assertEquals('Draft - Share with Authors', paList[0].AttachmentType__c);
		
		Network network = [SELECT Id FROM Network WHERE Name = 'FPR Submitter' limit 1];
		
		ContentVersion conVer1 = new ContentVersion();
		conVer1.ContentDocumentId = conVer[0].contentdocumentId;
		conVer1.Description='First Version Creation';conVer1.VersionData = blob.valueof('New Test Document.txt');
		conVer1.OwnerId= UserInfo.getUserId();
		conVer1.NetworkId = network.Id;
		conVer1.Title='First Version';
		conVer1.PathOnClient='www.google.com';
		insert conVer1;		
		System.debug('******'+conVer1);
	}
	
}