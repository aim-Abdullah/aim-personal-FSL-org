@IsTest
public class PubAuthorModelTest {
    private static void createData() {
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        AccountModelData.createData();
        AppearContactModelData.createData();
        //R1:2017 - max author count data
        KeyValueSettings__c kvs = new KeyValueSettings__c(Name='CSP Pub Author Count',Key__c='Max_Author_Count',Value__c='10');
		insert kvs;	
		
    }
	
	//Appear Enhancement R3
	@IsTest
	  public static void authorAttachmentTest(){
        //R1:2017 - max author count data
        KeyValueSettings__c kvs = new KeyValueSettings__c(Name='CSP Pub Author Count',Key__c='Max_Author_Count',Value__c='10');
		insert kvs;	
          
	  	CollaborationGroup myGroup = new CollaborationGroup();
		myGroup.Name='Attachments';myGroup.CollaborationType='Public'; //can be 'Public' or 'Private'                   
		insert myGroup;
		
		Test.setCurrentPage(Page.AppearPub);
		Publication__c pub = UnitTestData.PublicationNew('PubAttachmentModelTestAppear');
		AppearPubModel pubModel = new AppearPubModel(Pub.Id);
		List<Contact> appearContacts = new List<Contact>();
        appearContacts.add(new Contact(FirstName='Pub',LastName='Author',email='testpubauthor@amgen.com',country__c='United States',middleName='test'));
		Database.insert(appearContacts);
		PubAuthor__c PubAuth = new PubAuthor__c();
            PubAuth.Publication__c = Pub.Id;
            PubAuth.Author__c = appearContacts[0].Id;
            PubAuth.AuthorStatus__c='test';
            insert PubAUth;
        pubModel.PubAuthor.PubAuthorList[0].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
		pubModel.PubAuthor.NewAuthorAttachment1.AttachmentName__c = 'test';
		pubModel.PubAuthor.NewAuthorAttachment1.AttachmentType__c = 'Approval to Remove Author';
		pubModel.PubAuthor.NewAuthorSupportAttachment.ContentFileName = 'mockFile.txt';
		pubModel.PubAuthor.NewAuthorSupportAttachment.ContentData = EncodingUtil.base64Decode('mockContent');		
		pubModel.PubAuthor.InsertAuthorSupportingAttachment();
		//System.assertNotEquals(null, pubModel.PubAuthor.InsertAuthorSupportingAttachment()); //success	
		pubModel.PubAuthor.clearCache();
		pubModel.PubAuthor.authorNotSelected();		
	  }     
     //Appear Enhancement R2
      @isTest
      public static void emailHistoryTest(){
        //R1:2017 - max author count data
        KeyValueSettings__c kvs = new KeyValueSettings__c(Name='CSP Pub Author Count',Key__c='Max_Author_Count',Value__c='10');
		insert kvs;	
          
        Publication__c pub = UnitTestData.PublicationNew('SendAuthorInvitationApprovalReminder');
        List<Contact> appearContacts = new List<Contact>();
        appearContacts.add(new Contact(FirstName='Pub',LastName='Author',email='pubauthor@amgen.com',country__c='United States',middleName='test'));
        Database.insert(appearContacts);
        ApexPages.currentPage().getParameters().put('PublicationId',pub.Id);
        ApexPages.currentPage().getParameters().put('ContactId', appearContacts[0].Id);
        //pubAuthorModel.PublicationId=pub.Id;
        //pubAuthorModel.ContactId=appearContacts[0].Id;
        
        PubAuthor__c PubAuth = new PubAuthor__c();
            PubAuth.Publication__c = Pub.Id;
            PubAuth.Author__c = appearContacts[0].Id;
            PubAuth.AuthorStatus__c='test';
            insert PubAUth;
            
            pubauthormodel PA = new pubauthormodel(Pub.Id,'Authors','Plan',pub,false);
            PA.PublicationId= pub.Id;
            PA.ContactId=appearContacts[0].Id;
            PA.viewSendEmails();
        
      }
        //Appear Enhancement R2
    @isTest
    public static void searchAndAddAuthor(){
        system.Test.startTest();
        createData();
        Publication__c pub = UnitTestData.PublicationNew('SelectDeselectAuthorsTest');
        List<Contact> appearContacts = new List<Contact>();
        appearContacts.add(new Contact(FirstName='Pub',LastName='Author',email='pubauthor@amgen.com',country__c='United States',middleName='test'));
        Database.insert(appearContacts);
        
        contact_address__c ca = new contact_address__c();
        ca.Contact_Name__c = appearContacts[0].id;
        ca.City__c='test';       
        ca.Address_Line_2__c='test';
        ca.Country__c='test';
        ca.State_Province__c ='test';
        ca.Street_Address__c ='test';
        ca.Zip_Postal_Code__c = '12345';
        ca.Primary_Address__c =true;
        insert ca;
        ApexPages.currentPage().getParameters().put('firstName',appearContacts[0].firstName);
        ApexPages.currentPage().getParameters().put('lastName',appearContacts[0].lastName);
        ApexPages.currentPage().getParameters().put('middleName',appearContacts[0].email);
        ApexPages.currentPage().getParameters().put('email',appearContacts[0].middleName);
        
        pubauthormodel PA = new pubauthormodel(Pub.Id,'Authors','Plan',pub,false);
        PA.remoteSaveAuthorAdd();
        PA.SearchAuthorList();
        pA.firstName=appearContacts[0].firstName;
        PA.lastName=appearContacts[0].lastName;
        PA.middleName=appearContacts[0].middleName;
        PA.email=appearContacts[0].email;
        PA.SearchAuthorList();
        PA.remoteSaveAuthorAdd();
        
        for(pubauthormodel.cContact conWrap: PA.addAuthorListNew){
                conWrap.selected = true;
            }
        
        PA.remoteSaveAuthorAdd();
        system.Test.stopTest();
    }


    @IsTest
    public static void SelectDeselectAuthors() {        
        createData();
        
        Publication__c pub = UnitTestData.PublicationNew('SelectDeselectAuthorsTest');  
        Publication__c clonePub = UnitTestData.newPublication('SelectDeselectAuthorsTest2');
        List<Contact> appearContacts = [Select id, FirstName from Contact limit 3];
        contact_address__c ca = new contact_address__c();
        ca.Contact_Name__c = appearContacts[0].id;
        ca.City__c='test';       
        ca.Address_Line_2__c='test';
        ca.Country__c='test';
        ca.State_Province__c ='test';
        ca.Street_Address__c ='test';
        ca.Zip_Postal_Code__c = '12345';
        ca.Primary_Address__c =true;
        insert ca;
        
        document d = new Document();
        d.Name='Author Invitation Disclaimer';
        d.AuthorId = UserInfo.getUserId();
        d.FolderId = UserInfo.getUserId();
        insert d;
        
        ProvisionDocumentVersion__c comp = new ProvisionDocumentVersion__c ();
        comp.ProvisionDocumentContent__c = 'testing123';   
        insert comp;
        
          
        user u = new user();
        //u.ContactId = appearContacts[0].id;
        u.FirstName='test';
        u.LastName='sirnamr';
        u.Username='abc@gmail.com.testinglass';
        u.Email='abc@gmail.com';
        u.Alias='test';
        u.CommunityNickname='abc@gmail.com.testingclass.test1';// Appear Enhancement R3: Nick Name Updated
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='ISO-8859-1';
        u.ProfileId='00eU0000000sFpU';
        u.LanguageLocaleKey='en_US';
        insert u;
        
        PubAuthor__c PubAuth = new PubAuthor__c();
        PubAuth.Publication__c = Pub.Id;
        PubAuth.Author__c = appearContacts[0].Id;
        //PubAuth.AuthorCountry__c='test';
        PubAUth.InviteSentDate__c = date.today();
        PubAuth.AuthorStatus__c='test';
        PubAuth.Disclaimer_ID__c = comp.id;
        PubAuth.InviteAccepteddate__c=null;
        insert PubAUth;
        
        //list<PubAuthor__c> InvSentAut = New List<PubAuthor__c>();
        
        AppearPubModel pubModel = new AppearPubModel(pub.id);
        System.Test.startTest();
        
        //fail case
        pubModel.PubAuthor.save();
        pubModel.PubAuthor.cancel();
        pubmodel.pubAuthor.UpdateAuthorRecord();
        PageReference pageRefer = new PageReference('/apex/AppearPub?sfdc.tabName=01ri00000004OaA');
        Test.setCurrentPage(pageRefer);
        ApexPages.currentPage().getParameters().put('AuthorIdForContact', appearContacts[0].Id);
        ApexPages.currentPage().getParameters().put('PubAuthorId',PubAUth.id);
        ApexPages.currentPage().getParameters().put('NewAuthorId',appearContacts[0].id);
         ApexPages.currentPage().getParameters().put('RecId',PubAUth.id);
        ApexPages.currentPage().getParameters().put('ContactId', appearContacts[0].Id);
        ApexPages.currentPage().getParameters().put('CuserId',u.id);
        ApexPages.currentPage().getParameters().put('Details','test');
        ApexPages.currentPage().getParameters().put('AuthorContactPubAuthorId',PubAUth.Id);
        
        ApexPages.currentPage().getParameters().put('InviteDatevalue','12/20/2014');
        ApexPages.currentPage().getParameters().put('ApproveDetails','Yes');
        ApexPages.currentPage().getParameters().put('ApproveDatevalue','12/20/2014');
        pubauthormodel PA = new pubauthormodel(Pub.Id,'Authors','Plan',pub,false);
        PA.DisplayAddresses();
        PA.FeedItems();
        Map<Id, decimal> FeedItemCountByAuthor = PA.FeedItemCountByAuthor; 
        PA.UpdateAuthorIdRecord();
        PA.getApproveAttachmentURL();
        PA.ReminderTemplate();
        PA.remoteSaveAuthor();
        PA.getApproveDisclaimerVersionPage();
        PA.InviteLetterDetailsUpdate();
        PA.ApprovalLetterDetailsUpdate();
        PA.getInviteDisclaimerVersionPage();
        PA.getInviteAcceptDisclaimerVersionPage(); 
        PA.UpdateAuthorRecord();
        PA.UpdateAuthorRecordReject();
        PA.UpdateAddtlDetailsForReminder();
        PA.remoteSaveAuthor();
        
        
        
        for(PubAuthorModel.DocumentWrapperCls cWrapper : PA.DocList){
            cWrapper.isSelected = true; 
          }
        PA.displaySelectedDoc();

        for(PubAuthorModel.ContactAddressWrapperCls cWrapper : PA.ContactAddressList){
            cWrapper.isSelected = true; 
        }
        PA.SavePrimaryContactAddress();  
        
        for(PubAuthorModel.DocumentWrapperCls cWrapper : PA.ApprovalList){
            cWrapper.isSelected = true; 
        }
        PA.displaySelectedApprovalTemplate();
        
        
        for(PubAuthorModel.DocumentWrapperCls cWrapper : PA.ReminderList){
            cWrapper.isSelected = true; 
          }        
        PA.displayReminderDoc();

        
        string s = PA.EmailPreviewSettingOrgURL;
        string E2 = PA.EmailPreviewSettingContentURL;
        Id e3 = PA.EmailPreviewSettingRelatedToId;
        Id E4 = PA.EmailPreviewSettingRecipientTypeId;
        
        //add authors
        pubModel.PubAuthor.NewAuthorId = appearContacts[0].Id;
        pubModel.PubAuthor.save();
        pubModel.PubAuthor.NewAuthorId = appearContacts[1].Id;
        pubModel.PubAuthor.save();
                
        //check list count
        System.AssertEquals(3,pubModel.PubAuthor.PubAuthorList.size());
        System.AssertNotEquals(null, pubModel.PubAuthor.saveAuthorList());
        
        boolean canAdd = pubModel.PubAuthor.canAddDelAuthors;
        pubModel.PubAuthor.InvSentAut.add(PubAuth);
        pubModel.PubAuthor.InvSentAut[0].Justification_for_invite__c ='test';
        pubModel.PubAuthor.UpdateAuthorRecord();
        pubModel.PubAuthor.InvSentAut.add(PubAuth);
        pubModel.PubAuthor.InvSentAut[0].ApprovalSentDate__c = date.today();
        pubModel.PubAuthor.InvSentAut[0].InviteAcceptedDate__c = date.today();
        pubModel.PubAuthor.InvSentAut[0].InviteSentDate__c = date.today();
        pubModel.PubAuthor.InvSentAut[0].Justification_for_Approval__c ='test';
        update  pubModel.PubAuthor.InvSentAut;
        pubModel.PubAuthor.UpdateAuthorRecord();
        pubModel.PubAuthor.InvSentAut.add(PubAuth);
        pubModel.PubAuthor.InvSentAut[0].Justification_for_Approval__c = 'test';
        pubModel.PubAuthor.UpdateAuthorRecordReject();
        
        List<PubAuthor__c> authorList = PubAuthorModel.getPubAuthors(pub.Id); 
        
        //remove one author
        pubModel.PubAuthor.PubAuthorList[0].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.deleteSelected(); 
        pubModel.PubAuthor.ValidateInvitationAuthors(); 
        
        //invoke static methods
        PubAuthorModel.clone(pub.Id, clonePub.Id);
        list<contact> newListContact = PubAuthorModel.findAuthorsByName('a');
         
        PubAuthorModel.resetAuthorApprovalsForNextFPRCycle(pub.Id); 
        
        PA.NewAuthorId=appearContacts[0].id; //Appear Enhancement R2
        PA.remoteSaveAuthor();  //Appear Enhancement R2
        System.Test.stopTest();
    }

	 //Appear Enhancement R3
    @isTest 
  public static void testMethod1(){
    createData();

    Publication__c pub = UnitTestData.PublicationNew('TestRemoveAuthor1');
    pub.isPlanning__c = true;
        pub.GPP_Type__c = 'CSP';
        pub.Publication_Type__c = 'Manuscript';
        pub.SponsorDept_Pick__c = 'Clinical Development';
        pub.SponsorOrg_Pick__c = 'Amgen';
        update pub;
            
        Publication__c clonePub = UnitTestData.newPublication('TestRemoveAuthor1Clone');
        AppearPubModel pubModel = new AppearPubModel(pub.id);
        
        List<Contact> appearContacts = [Select id, FirstName from Contact limit 1];
        contact_address__c ca = new contact_address__c();
        ca.Contact_Name__c = appearContacts[0].id;
        ca.City__c='test';       
        ca.Address_Line_2__c='test';
        ca.Country__c='test';
        ca.State_Province__c ='test';
        ca.Street_Address__c ='test';
        ca.Zip_Postal_Code__c = '12345';
        ca.Primary_Address__c =true;
        insert ca;
        
        
    document d = new Document();
        d.Name='Author Invitation Disclaimer';
        d.AuthorId = UserInfo.getUserId();
        d.FolderId = UserInfo.getUserId();
        insert d;
        
        ProvisionDocumentVersion__c comp = new ProvisionDocumentVersion__c ();
        comp.ProvisionDocumentContent__c = 'testing123';   
        insert comp;

        PubAuthor__c PubAuth = new PubAuthor__c();
        PubAuth.Publication__c = Pub.Id;
        PubAuth.Author__c = appearContacts[0].Id;
        PubAuth.AuthorStatus__c='test';
        PubAuth.Disclaimer_ID__c = comp.id;
        insert PubAuth;
             
        CollaborationGroup myGroup = new CollaborationGroup();
        myGroup.Name='Author Attachments';
        myGroup.CollaborationType='Public';     
        insert myGroup;
        
        FeedItem NewFeedItem1 = new FeedItem(); 
        NewFeedItem1.ContentFileName = 'testText1.txt';
        NewFeedItem1.ParentId = pubModel.PubAttachments.AuthorAttachmentGroupId; 
        NewFeedItem1.ContentData = EncodingUtil.base64Decode('TestContent');        
        insert NewFeedItem1; 
        
        PubAttachmentDetails__c pubAtt = new PubAttachmentDetails__c(); 
        pubAtt.Publication__c = pub.Id; 
        pubAtt.AttachmentType__c = 'Approval to Remove Author';  
        pubAtt.AttachmentName__c = 'testAtt1';   
        pubAtt.What__c = NewFeedItem1.Id;
        insert pubAtt;
        
       /* FeedItem NewFeedItem2 = new FeedItem(); 
        NewFeedItem2.ContentFileName = 'testText1.txt';
        NewFeedItem2.ParentId = pubModel.PubAttachments.AuthorAttachmentGroupId; 
        NewFeedItem2.ContentData = EncodingUtil.base64Decode('TestContent');        
        insert NewFeedItem2; */
        
        PubAttachmentDetails__c pubAtt2 = new PubAttachmentDetails__c(); 
        pubAtt2.Publication__c = pub.Id; 
        pubAtt2.AttachmentType__c = 'Response to Author Invitation';  
        pubAtt2.AttachmentName__c = 'testAtt2';   
        pubAtt2.What__c = NewFeedItem1.Id;
        insert pubAtt2;
        
        PubAttachmentDetails__c pubAtt3 = new PubAttachmentDetails__c(); 
        pubAtt3.Publication__c = pub.Id; 
        pubAtt3.AttachmentType__c = 'Response to Final Author Approval';  
        pubAtt3.AttachmentName__c = 'testAtt3';   
        pubAtt3.What__c = NewFeedItem1.Id;
        insert pubAtt3;
        
        System.Test.startTest();
        
    List<PubAuthor__c> authorList = PubAuthorModel.getPubAuthors(pub.Id);
    List<PubAttachmentDetails__c> pAttList = PubAttachmentModel.getAllPubAttachmentList(pub.Id);
    List<PubAuthor__c> InvSentList = pubModel.PubAuthor.InvSentAut;
        
    pubModel.PubAuthor.InvSentAut.add(PubAuth);
    pubAtt.Publication_Author__c  = InvSentList[0].id;
    update pubAtt;
    pubModel.PubAuthor.InvAcceptOnBehalf();
    pubAtt2.Publication_Author__c  = InvSentList[0].id;
    update pubAtt2;
    PubAuth.InviteSentDate__c = date.today();
    PubAuth.InviteAcceptedDate__c = null;
    update  PubAuth;
    pubModel.PubAuthor.InvAcceptOnBehalf();
    PubAuth.Justification_for_invite__c ='Email from Author';
      update  PubAuth;
      pubModel.PubAuthor.InvAcceptOnBehalf();
            
      //pubModel.PubAuthor.InvSentAut.add(PubAuth);//Appear Enhancement 2017 Backlog R2
      pubAtt.Publication_Author__c  = InvSentList[0].id;
    update pubAtt;
    pubModel.PubAuthor.ApproveOnBehalf();
    pubAtt3.Publication_Author__c  = InvSentList[0].id;
      update pubAtt3;
      pubModel.PubAuthor.evt.ActivityDate = date.today();//Appear Enhancement 2017 Backlog R2: adding event field value
      PubAuth.InviteSentDate__c = date.today();
      PubAuth.InviteAcceptedDate__c = date.today();
      PubAuth.ApprovalSentDate__c = date.today();
      PubAuth.ApprovalAcceptedDate__c = null;
      pubModel.PubAuthor.ApproveOnBehalf();
      PubAuth.Justification_for_Approval__c ='Email from Author';
      update PubAuth;
      pubModel.PubAuthor.ApproveOnBehalf();
      
      pubModel.PubAuthor.InvSentAut.add(PubAuth);
    pubAtt3.Publication_Author__c  = InvSentList[0].id;  
    update pubAtt3;
      pubModel.PubAuthor.evt.ActivityDate = null;//Appear Enhancement BacklogR2 2017: adding event field value
      pubModel.PubAuthor.declineOnBehalf();
      pubModel.PubAuthor.evt.ActivityDate = date.today();//Appear Enhancement BacklogR2 2017: adding event field value
      PubAuth.InviteSentDate__c = date.today();
      PubAuth.InviteAcceptedDate__c = date.today();
      PubAuth.ApprovalSentDate__c = date.today();
      PubAuth.ApprovalAcceptedDate__c = null;
      update PubAuth;
      pubModel.PubAuthor.declineOnBehalf();
      PubAuth.Justification_for_Approval__c ='Email from Author';
      update PubAuth;
      pubModel.PubAuthor.declineOnBehalf();
      
      //remove
    pubAtt.Publication_Author__c  = null;  
    update pubAtt;
    pubModel.PubAuthor.PubAuthorList[0].isSelected__c = true;
    pubModel.PubAuthor.removeAuthor();
            
    pubAtt.Publication_Author__c  = authorList[0].Id;  
    update pubAtt;
      pubModel.PubAuthor.PubAuthorList.add(PubAuth);//Appear Enhancement BacklogR2 2017: adding event field value
    pubModel.PubAuthor.PubAuthorList[0].isSelected__c = true;
    pubModel.PubAuthor.removeAuthor();
    
    pubModel.PubAuthor.InvSentAut.add(PubAuth);
    pubModel.PubAuthor.InvAcceptOnBehalf();
      pubModel.PubAuthor.ApproveOnBehalf();
      
      pubModel.PubAuthor.InvSentAut.add(PubAuth);
    PubAuth.Justification_for_Approval__c =null;
      update PubAuth;
      pubModel.PubAuthor.declineOnBehalf();
    
      
      System.Test.stopTest();
  
  }  
   @IsTest 
    public static void testCommentInsertSP() {  
    CollaborationGroup myGroup = new CollaborationGroup();
    myGroup.Name='Attachments';myGroup.CollaborationType='Public'; //can be 'Public' or 'Private'                   
    insert myGroup;
    Test.setCurrentPage(Page.AppearPub);
        System.test.startTest();
        //createData();
    //R1:2017 - max author count data
        KeyValueSettings__c kvs = new KeyValueSettings__c(Name='CSP Pub Author Count',Key__c='Max_Author_Count',Value__c='10');
		insert kvs;	
	
    Publication__c pub = UnitTestData.PublicationNew('TestCommentAuthor1');
    pub.isPlanning__c = true;
        pub.GPP_Type__c = 'SP';
        pub.Publication_Type__c = 'Manuscript';
        pub.SponsorDept_Pick__c = 'Clinical Development';
        pub.SponsorOrg_Pick__c = 'Amgen';
        update pub;
            
        AppearPubModel pubModel = new AppearPubModel(pub.id);
        
        List<Contact> appearContacts = [Select id,userId__c, FirstName from Contact]; 
        Contact appearContact1 = new Contact();
        Contact appearContact2 = new Contact();
        for(Contact appContact : appearContacts){
            if(appContact.userId__c == null){
                appearContact1 = appContact;
                break;
            }
        }
        for(Contact appContact : appearContacts){
            if(appContact.userId__c != null){
                appearContact2 = appContact;
                break;
            }
        }
        PubAuthor__c PubAuth = new PubAuthor__c();
        PubAuth.Publication__c = Pub.Id;
        PubAuth.Author__c = appearContact1.Id;
        PubAuth.AuthorStatus__c='test';
        insert PubAuth;
        pubModel.PubAuthor.PubAuthorList[0].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.NewAuthorAttachment1.AttachmentName__c = 'test';
        pubModel.PubAuthor.NewAuthorAttachment1.AttachmentType__c = 'Draft - Share with Authors';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentFileName = 'mockFile.txt';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentData = EncodingUtil.base64Decode('mockContent');    
        pubModel.PubAuthor.InsertAuthorSupportingAttachment();
    
        pubauthormodel pubAuthModel = new pubauthormodel(Pub.Id,'Authors','Plan',pub,false);
        pubAuthModel.PublicationId= pub.Id;
        pubAuthModel.ContactId=appearContact1.Id;
        
        //pubAuthModel.evt = '';
        //pubAuthModel.NewDraftComment = feed;
        pubAuthModel.NewDraftComment.Body='';
        pubAuthModel.saveOnBehalfComment();
        pubAuthModel.NewDraftComment.Body='Test Body';
        pubAuthModel.saveOnBehalfComment();
        System.Test.stopTest();
 	}
    
    @IsTest
    public static void testCommentInsertCSP() {  
    CollaborationGroup myGroup = new CollaborationGroup();
    myGroup.Name='Attachments';myGroup.CollaborationType='Public'; //can be 'Public' or 'Private'                   
    insert myGroup;
    Test.setCurrentPage(Page.AppearPub);
        //createData();
        //R1:2017 - max author count data
        KeyValueSettings__c kvs = new KeyValueSettings__c(Name='CSP Pub Author Count',Key__c='Max_Author_Count',Value__c='10');
		insert kvs;	
	
    Publication__c pub = UnitTestData.PublicationNew('TestCommentAuthor1');
    pub.isPlanning__c = true;
        pub.GPP_Type__c = 'CSP';
        pub.Publication_Type__c = 'Manuscript';
        pub.SponsorDept_Pick__c = 'Clinical Development';
        pub.SponsorOrg_Pick__c = 'Amgen';
        update pub;
            
        AppearPubModel pubModel = new AppearPubModel(pub.id);
        System.Test.startTest();
        List<Contact> appearContacts = [Select id, FirstName from Contact limit 1];       
        
        PubAuthor__c PubAuth = new PubAuthor__c();
        PubAuth.Publication__c = Pub.Id;
        PubAuth.Author__c = appearContacts[0].Id;
        PubAuth.AuthorStatus__c='test';
        insert PubAuth;
        pubModel.PubAuthor.PubAuthorList[0].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.NewAuthorAttachment1.AttachmentName__c = 'test';
        pubModel.PubAuthor.NewAuthorAttachment1.AttachmentType__c = 'Substantial Comments';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentFileName = 'mockFile.txt';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentData = EncodingUtil.base64Decode('mockContent');    
        pubModel.PubAuthor.InsertAuthorSupportingAttachment();
        
    	pubModel.PubAuthor.NewAuthorAttachment1.AttachmentName__c = 'test2';
        pubModel.PubAuthor.NewAuthorAttachment1.AttachmentType__c = 'Draft - Share with Authors';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentFileName = 'mockFile.txt';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentData = EncodingUtil.base64Decode('mockContent');    
		pubModel.PubAuthor.InsertAuthorSupportingAttachment();
        
        //Appear Enhancemet R4:Start
        pubModel.PubAuthor.PubAuthorList[0].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.NewAuthorAttachment1.AttachmentName__c = 'test3';
        pubModel.PubAuthor.NewAuthorAttachment1.AttachmentType__c = 'Substantial Comments';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentFileName = 'mockFile.txt';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentData = EncodingUtil.base64Decode('mockContent');    
        pubModel.PubAuthor.InsertAuthorSupportingAttachment();
        //Appear Enhancement R4:End
        
        
        pubauthormodel pubAuthModel = new pubauthormodel(Pub.Id,'Authors','Plan',pub,false);
        pubAuthModel.PublicationId= pub.Id;
        pubAuthModel.ContactId=appearContacts[0].Id;

        pubAuthModel.NewDraftComment.Body='Test Body';
        
        pubAuthModel.saveOnBehalfComment();
        for(PubAuthorModel.DocumentWrapperCls cWrapper : pubAuthModel.DraftShareList){
            cWrapper.isSelected = true; 
          } 
        pubModel.PubAuthor.PubAuthorList[0].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubAuthModel.displayDraftShareDoc();
        pubAuthModel.DraftShareLetterDetailsUpdate();
        System.Test.stopTest();
 	}
	
    //Appear Enhancement 2017 Backlog R3
    @IsTest
    public static void newOnbehalf_Method(){
        CollaborationGroup myGroup = new CollaborationGroup();
    	myGroup.Name='Attachments';myGroup.CollaborationType='Public';                   
    	insert myGroup;
        
        KeyValueSettings__c kvs = new KeyValueSettings__c(Name='CSP Pub Author Count',Key__c='Max_Author_Count',Value__c='10');
		insert kvs;	
	
    	Publication__c pub = UnitTestData.PublicationNew('TestPubOnbehalf');
    	pub.GPP_Type__c = 'CSP';
        pub.Publication_Type__c = 'Manuscript';
        pub.SponsorDept_Pick__c = 'Clinical Development';
        pub.SponsorOrg_Pick__c = 'Amgen';
        update pub;
            
        AppearPubModel pubModel = new AppearPubModel(pub.id);
        System.Test.startTest();
        
        Profile profile= [select id, name from Profile where name ='APPEAR External Writer'];
        List<User> userList = new List<User>();
        userList.add(new User(alias = 'external',email='asdUser@testorg.com',emailencodingkey='UTF-8',lastname='asdTest', languagelocalekey='en_US',localesidkey='en_US', profileid =profile.Id ,timezonesidkey='America/Los_Angeles',username='asdtest@testorg.com'));
        userList.add(new User(alias = 'exte2',email='asdUser2@testorg.com',emailencodingkey='UTF-8',lastname='asdTest2', languagelocalekey='en_US',localesidkey='en_US', profileid =profile.Id ,timezonesidkey='America/Los_Angeles',username='asdtest22@testorg.com'));
        userList.add(new User(alias = 'exte3',email='asdUser3@testorg.com',emailencodingkey='UTF-8',lastname='asdTest3', languagelocalekey='en_US',localesidkey='en_US', profileid =profile.Id ,timezonesidkey='America/Los_Angeles',username='asdtest33@testorg.com'));
        userList.add(new User(alias = 'exte4',email='asdUser4@testorg.com',emailencodingkey='UTF-8',lastname='asdTest4', languagelocalekey='en_US',localesidkey='en_US', profileid =profile.Id ,timezonesidkey='America/Los_Angeles',username='asdtest44@testorg.com'));
		userList.add(new User(alias = 'exte5',email='asdUser5@testorg.com',emailencodingkey='UTF-8',lastname='asdTest5', languagelocalekey='en_US',localesidkey='en_US', profileid =profile.Id ,timezonesidkey='America/Los_Angeles',username='asdtest55@testorg.com'));
        userList.add(new User(alias = 'exte6',email='asdUser6@testorg.com',emailencodingkey='UTF-8',lastname='asdTest6', languagelocalekey='en_US',localesidkey='en_US', profileid =profile.Id ,timezonesidkey='America/Los_Angeles',username='asdtest66@testorg.com'));
        insert userList;
        
        AccountModelData.createData();
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(UserId__c=userList[0].Id, LastName= 'user', FirstName='test', 
                                	AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,  Email='testacdc@dadss.com') );
        conList.add(new Contact(UserId__c=userList[1].Id, LastName= 'user2', FirstName='test2',
                                	AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,  Email='testacdc2@dadss2.com') );
        conList.add(new Contact(UserId__c=userList[2].Id, LastName= 'user3', FirstName='test3',
                                	AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,  Email='testacdc3@dadss2.com') );
        conList.add(new Contact(UserId__c=userList[3].Id, LastName= 'user4', FirstName='test4',
                                	AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,  Email='testacdc4@dadss2.com') );
		conList.add(new Contact(UserId__c=userList[4].Id, LastName= 'user5', FirstName='test5',
                                	AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,  Email='testacdc5@dadss2.com') );
        conList.add(new Contact(UserId__c=userList[5].Id, LastName= 'user6', FirstName='test6',
                                	AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,  Email='testacdc6@dadss2.com') );
        insert conList;     
        
        List<PubAuthor__c> pubAuthList = new List<PubAuthor__c>();
        pubAuthList.add(new PubAuthor__c(Publication__c = Pub.Id, Author__c = conList[0].Id,  InviteSentDate__c = null,
                                         ApprovalSentDate__c = null)  );
        pubAuthList.add(new PubAuthor__c(Publication__c = Pub.Id, Author__c = conList[1].Id,  InviteSentDate__c = System.today(),
                                         InviteAcceptedDate__c=System.today(), ApprovalSentDate__c = System.today(), ApprovalAcceptedDate__c = System.today())  );
        pubAuthList.add(new PubAuthor__c(Publication__c = Pub.Id, Author__c = conList[2].Id,  InviteSentDate__c = System.today(),
                                        ApprovalSentDate__c = System.today())  );
        pubAuthList.add(new PubAuthor__c(Publication__c = Pub.Id, Author__c = conList[3].Id,  InviteSentDate__c = System.today(),Justification_for_invite__c = Null,
                                         Justification_for_Approval__c = Null) );
        pubAuthList.add(new PubAuthor__c(Publication__c = Pub.Id, Author__c = conList[4].Id,  InviteSentDate__c = System.today(), Justification_for_invite__c = 'Email from Author') );
        pubAuthList.add(new PubAuthor__c(Publication__c = Pub.Id, Author__c = conList[5].Id,  InviteSentDate__c = System.today(), InviteAcceptedDate__c=System.today(),
                                         ApprovalSentDate__c = System.today(), ApprovalAcceptedDate__c = Null) );
        insert pubAuthList;
        System.assertEquals(Null, pubAuthList[3].Justification_for_invite__c);
        System.assertEquals('Email from Author', pubAuthList[4].Justification_for_invite__c);
        
        pubModel.PubAuthor.PubAuthorList[0].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.NewAuthorAttachment1.AttachmentName__c = 'test Auth Invt';
        pubModel.PubAuthor.NewAuthorAttachment1.AttachmentType__c = 'Response to Author Invitation';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentFileName = 'mockFile.txt';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentData = EncodingUtil.base64Decode('mockContent'); 
        
        //pubModel.PubAuthor.InsertAuthorSupportingAttachment();
        pubModel.PubAuthor.newUploadAndDecline();//scenario 1
        
        pubModel.PubAuthor.PubAuthorList[0].isSelected__c = false;
        pubModel.PubAuthor.PubAuthorList[1].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.newUploadAndDecline();//scenario 2
        
        pubModel.PubAuthor.PubAuthorList[1].isSelected__c = false;
        pubModel.PubAuthor.PubAuthorList[2].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.evt.RecurrenceEndDateOnly = null;
        pubModel.PubAuthor.newUploadAndDecline();//scenario 3
        
        pubModel.PubAuthor.PubAuthorList[2].isSelected__c = false;
        pubModel.PubAuthor.PubAuthorList[3].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.evt.RecurrenceEndDateOnly = System.today();
        pubModel.PubAuthor.newUploadAndDecline();//scenario 4
        
        pubModel.PubAuthor.PubAuthorList[3].isSelected__c = false;
        pubModel.PubAuthor.PubAuthorList[4].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.evt.RecurrenceEndDateOnly = System.today();
        pubModel.PubAuthor.newUploadAndDecline();//scenario 5
		   
        //approvals
        pubModel.PubAuthor.NewAuthorAttachment1.AttachmentName__c = 'test Auth Approvals';
        pubModel.PubAuthor.NewAuthorAttachment1.AttachmentType__c = 'Response to Final Author Approval';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentFileName = 'mockFile.txt';
        pubModel.PubAuthor.NewAuthorSupportAttachment.ContentData = EncodingUtil.base64Decode('mockContent');
        
        pubModel.PubAuthor.PubAuthorList[4].isSelected__c = false;
        pubModel.PubAuthor.PubAuthorList[0].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.newUploadAndDecline();//scenario 1
                
        pubModel.PubAuthor.PubAuthorList[0].isSelected__c = false;
        pubModel.PubAuthor.PubAuthorList[1].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.newUploadAndDecline();//scenario 2
        
        pubModel.PubAuthor.PubAuthorList[1].isSelected__c = false;
        pubModel.PubAuthor.PubAuthorList[2].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.evt.ActivityDate = null;
        pubModel.PubAuthor.newUploadAndDecline();//scenario 3
        
        pubModel.PubAuthor.PubAuthorList[2].isSelected__c = false;
        pubModel.PubAuthor.PubAuthorList[5].isSelected__c = true;
        pubModel.PubAuthor.AuthorsSelected();
        pubModel.PubAuthor.evt.ActivityDate = System.today();
        pubModel.PubAuthor.newUploadAndDecline();//scenario 5
            
        System.Test.stopTest();
    }
    
}