@IsTest
public class PubAuthorModelNoSharingTest {

    private static void createData() {
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        AccountModelData.createData();
        AppearContactModelData.createData();
    }
    

    @IsTest
    public static void UnitTest() {     

        // test dat prep
        //createData();//Appear Enhancement R2
        Publication__c pub = UnitTestData.PublicationNew('SelectDeselectAuthorsTest');  
        Publication__c clonePub = UnitTestData.newPublication('SelectDeselectAuthorsTest2');
        AppearPubModel pubModel = new AppearPubModel(Pub.Id);

        // createPubAttachmentData(pubModel); 

        Id userId = userInfo.getUserId();              
        List<Contact> contactsToAdd = new List<Contact>();        
        Contact proxyContact = new Contact(lastname='testing',firstname='proxy',userid__c=userId);
        contactsToAdd.add(proxyContact);
        Contact newContact = new Contact(lastname='testing',firstname='apex',userid__c=userId,Proxy__c=proxyContact.id);
        contactsToAdd.add(newContact);
        Contact triageContact = new Contact(lastname='testing',firstname='triage',userid__c=userId);
        contactsToAdd.add(triageContact);
        Contact triageContact2 = new Contact(lastname='testing',firstname='triage2',userid__c=userId);
        contactsToAdd.add(triageContact2);
        Contact delegateContact = new Contact(lastname='testing',firstname='delegate',userid__c=userId);
        contactsToAdd.add(delegateContact);
        insert contactsToAdd;

        ProvisionDocumentVersion__c comp = new ProvisionDocumentVersion__c ();
        comp.ProvisionDocumentContent__c = 'testing123';   
        insert comp;        

        List<Contact> appearContacts = [Select id, FirstName from Contact limit 3];

         PageReference pageRef = new PageReference('/apex/AppearPub?sfdc.tabName=01ri00000004OaA'); 
         Test.setCurrentPage(pageRef);
        
        PubAuthorModelNoSharing aPubAuthorNoSharing = pubModel.PubAuthorNoSharing; 
        
        PubAuthor__c PubAuthInvite = new PubAuthor__c();
        PubAuthInvite.Publication__c = Pub.Id;
        PubAuthInvite.Author__c = appearContacts[0].Id;
        PubAuthInvite.InviteSentDate__c = date.today();
        PubAuthInvite.AuthorStatus__c='Pending Invite Acceptance';
        PubAuthInvite.Disclaimer_ID__c = comp.id;
        PubAuthInvite.InviteAccepteddate__c=null;
        insert PubAuthInvite;
        PubAuthor__c PubAuthReview = new PubAuthor__c();
        PubAuthReview.Publication__c = Pub.Id;
        PubAuthReview.Author__c = appearContacts[1].Id;
        PubAuthReview.InviteSentDate__c = date.today();
        PubAuthReview.AuthorStatus__c='Publication Review by Authors';
        PubAuthReview.Disclaimer_ID__c =comp.id;
        PubAuthReview.InviteAccepteddate__c = date.today();
        insert PubAuthReview;        
        PubAuthor__c PubAuthApprove = new PubAuthor__c();
        PubAuthApprove.Publication__c = Pub.Id;
        PubAuthApprove.Author__c = appearContacts[2].Id;
        PubAuthApprove.ApprovalSentDate__c = date.today();
        PubAuthApprove.AuthorStatus__c='Pending Author Approval';
        PubAuthApprove.Approval_Disclaimer_ID__c =   PubAuthorModelNoSharing.getLatestPubAuthorAttachmentId(Pub.Id); 
        PubAuthApprove.ApprovalAcceptedDate__c =null;
        System.Test.startTest();  //Appear Enhancement R2
        insert PubAuthApprove;     
        //System.Test.stopTest();
              
        Id aPubId = aPubAuthorNoSharing.PubId; 
        aPubAuthorNoSharing.PubId = aPubId;
        
        Id aPubAuthorId = aPubAuthorNoSharing.PubAuthorId; 
         aPubAuthorNoSharing.PubAuthorId = aPubAuthorId;
        
        pubAuthor__c aPubAuthorRecord = aPubAuthorNoSharing.PubAuthorRecord; 
        
        boolean aIsAuthorComm= PubAuthorModelNoSharing.IsAuthorComm; 
        
        id inviteId = PubAuthorModelNoSharing.getLatestInviteDisclaimerId();
        
        map<id, string> aApprovePubAuthorAttachmentMap = aPubAuthorNoSharing.ApprovePubAuthorAttachmentMap; 
        
        aPubAuthorNoSharing.pubIdForAttachment =  PubAuthorModelNoSharing.getLatestPubAuthorAttachmentId(Pub.Id); 
        Id aPubIdForAttachment = aPubAuthorNoSharing.pubIdForAttachment; 
        
        aPubAuthorNoSharing.remoteSetPubIdForAttachment(); 
        
        id   aCurrentPubAuthorAttachmentId =  aPubAuthorNoSharing.currentPubAuthorAttachmentId;
        
        pagereference aRef = aPubAuthorNoSharing.getInviteDisclaimerVersionPage();
        
        string approvalURL = aPubAuthorNoSharing.getApproveAttachmentURL();
        
        pubAuthor__c apubAuthorc =  PubAuthorModelNoSharing.findPubAuthorRecord(Pub.Id, userId);  

        Set<Id>  aSetId =  PubAuthorModelNoSharing.findContactForAppearUser(userId); 
        
        List<PubAuthor__c> aPubAuthorList = aPubAuthorNoSharing.PubAuthorList;
        
        List<PubAuthor__c> aAuthorList = PubAuthorModelNoSharing.getPubAuthors(pub.id);

        List<Publication__c> acheckPublicationId = PubAuthorModelNoSharing.checkPublicationId(pub.id); 

        Publication__c aPubRecord = aPubAuthorNoSharing.PubRecord;

        string CommentsByAuthors = aPubAuthorNoSharing.CommentsByAuthors; 
        aPubAuthorNoSharing.CommentsByAuthors = 'abc'; 

        Id aCurrentSubmissionCycleId =  aPubAuthorNoSharing.CurrentSubmissionCycleId;
        Id CurrentFprCycleId = aPubAuthorNoSharing.CurrentFprCycleId; 
        integer aCurrentFprCycleNum =  aPubAuthorNoSharing.CurrentFprCycleNum;

        List<SelectOption> aOption = aPubAuthorNoSharing.getAuthorMyRequestOptions();
        aPubAuthorNoSharing.SelectedAuthorMyRequestOption = 'all'; 
        string SelectedAuthorMyRequestOption    =  aPubAuthorNoSharing.SelectedAuthorMyRequestOption;
        boolean aIsSelectedAuthorRequestMainDetail =     aPubAuthorNoSharing.IsSelectedAuthorRequestMainDetail; 
        boolean aIsSelectedAuthorRequestCollaboration = aPubAuthorNoSharing.IsSelectedAuthorRequestCollaboration;
           
        List<pubAuthor__c> aMyAuthorPubStatusList = aPubAuthorNoSharing.MyAuthorPubStatusList;
        List<pubAuthor__c> aMyAuthorPubPendingAccessList = aPubAuthorNoSharing.MyAuthorPubPendingAccessList;        
        decimal aMyAuthorPubPendingAccessListCount = aPubAuthorNoSharing.MyAuthorPubPendingAccessListCount;
        List<pubAuthor__c> MyAuthorPubInviteList = aPubAuthorNoSharing.MyAuthorPubInviteList;
        decimal aMyAuthorPubInviteListCount = aPubAuthorNoSharing.MyAuthorPubInviteListCount;
        List<pubAuthor__c> MyAuthorPubApproveList = aPubAuthorNoSharing.MyAuthorPubApproveList;
        decimal aMyAuthorPubApproveListCount  = aPubAuthorNoSharing.MyAuthorPubApproveListCount;
        List<pubAuthor__c> MyAuthorPubReviewList = aPubAuthorNoSharing.MyAuthorPubReviewList;
        decimal aMyAuthorPubReviewListCount  = aPubAuthorNoSharing.MyAuthorPubReviewListCount;        
        List<pubAuthor__c> MyAuthorPubStatusFullList = aPubAuthorNoSharing.MyAuthorPubStatusFullList;


        Map<id, boolean> aPendingAuthorApprovalMap = aPubAuthorNoSharing.PendingAuthorApprovalMap;
        Map<id, boolean> aAuthorInviteAccepetedMap = aPubAuthorNoSharing.AuthorInviteAccepetedMap;        
        Map<id, boolean> aAuthorApprovedMap = aPubAuthorNoSharing.AuthorApprovedMap;

        boolean isAuthorInvite = PubAuthorModelNoSharing.IsAuthorAcceptedInvite ('');     
        boolean IsAuthorApproved = PubAuthorModelNoSharing.IsAuthorApproved('');
        
        PageReference saveRef = aPubAuthorNoSharing.saveCommentsByAuthors(); 
        
        aPubAuthorNoSharing.newRejectApprovalReason = 'test';
        aPubAuthorNoSharing.authorApprovePub(); 
        aPubAuthorNoSharing.authorAcceptInvitePub();
        
        aPubAuthorNoSharing.pubAuthorIdForInviteAccept = PubAuthInvite.Id; 
        aPubAuthorNoSharing.acceptInviteSF1(); 
        
        aPubAuthorNoSharing.pubAuthorIdForApprove = PubAuthInvite.Id; 
        aPubAuthorNoSharing.approvePubSF1();
        
        aPubAuthorNoSharing.pubAuthorIdForReject  = PubAuthInvite.Id; 
        aPubAuthorNoSharing.authorRejectPubSF1();    

        aPubAuthorNoSharing.updatePubAuthorStatusAndInvitedDate(PubAuthInvite.Id);
        
        List<FeedItem> aListFeedItem = PubAuthorModelNoSharing.GetFeedItems(userId, Pub.Id);  

        
        aPubAuthorNoSharing.updatePubAuthorStatus(PubAuthInvite.Id, 'Pending Author Approval' ); 
        
        
        id apubAuthorIdForViewProvision = aPubAuthorNoSharing.pubAuthorIdForViewProvision;
        aPubAuthorNoSharing.RemoteSetPubAuthorIdForViewProvision();  
         string pubAuthorViewProvision = aPubAuthorNoSharing.pubAuthorViewProvision; 

        aPubAuthorNoSharing.activeOpr = 'update';
        aPubAuthorNoSharing.RemoteSetActiveOpr(); 

        decimal activePubAuthorOprTabSF1 = aPubAuthorNoSharing.activePubAuthorOprTabSF1; 
        Map<id, boolean> ActivePubAuthorMapSF1 = aPubAuthorNoSharing.ActivePubAuthorMapSF1;
        
        Map<id, PubAuthorPubDTO> PubAuthorPubMap = aPubAuthorNoSharing.PubAuthorPubMap;
        Map<id, List<PubAuthorPubDraftAttachCommentDTO>> PubAuthorCommentMap = aPubAuthorNoSharing.PubAuthorCommentMap;
        Map<id, decimal> PubAuthorCommentCountMap =  aPubAuthorNoSharing.PubAuthorCommentCountMap;
        
        aPubAuthorNoSharing.RemoteSetPubAttachmentIdForComment(); 
        List<PubAuthorPubDraftAttachCommentDTO> AuthorCommentbyAttachment = aPubAuthorNoSharing.AuthorCommentbyAttachment;
        aPubAuthorNoSharing.CommentAuthorStatusForDelete = 'Approval Rejected';
        aPubAuthorNoSharing.deletecomment() ;
        aPubAuthorNoSharing.CommentAuthorStatusForDelete = '';
        aPubAuthorNoSharing.deletecomment() ;       
        
       List<PubAuthorPubDTO>  PubAuthorPubsDraftsAttachments = aPubAuthorNoSharing.PubAuthorPubsDraftsAttachments;
        
        
        
        
        
                                                
        // ------ 
        
        String aParamPubAuthorId = aPubAuthorNoSharing.ParamPubAuthorId; 
        id puAuthorId = aPubAuthorNoSharing.PubAuthorId;         
        

        System.assertNotEquals(null, aPubAuthorNoSharing.PubId);






        string aSelectedOption = aPubAuthorNoSharing.SelectedAuthorMyRequestOption;


        PageReference apageReference =  aPubAuthorNoSharing.saveCommentsByAuthors();
        apageReference =  aPubAuthorNoSharing.authorApprovePub();        
        apageReference =  aPubAuthorNoSharing.authorAcceptInvitePub();
        
        System.Test.stopTest();
    }




    @IsTest
    public static void UnitTest2() {        

         PageReference pageRef = new PageReference('/apex/AppearPub?sfdc.tabName=01ri00000004OaA'); 
         Test.setCurrentPage(pageRef);
         
        // test dat prep
        //createData(); //Appear Enhancement R2
        
        Publication__c pub = UnitTestData.PublicationNew('SelectDeselectAuthorsTest');  
        Publication__c clonePub = UnitTestData.newPublication('SelectDeselectAuthorsTest2');
        AppearPubModel pubModel = new AppearPubModel(Pub.Id);

        CollaborationGroup myGroup = new CollaborationGroup();
        myGroup.Name='Author Attachments';
        myGroup.CollaborationType='Public'; //can be 'Public' or 'Private'     
         
        insert myGroup;    
        FeedItem NewFeedItem1 = new FeedItem(); 
        NewFeedItem1.ContentFileName = 'mockFile.txt';
        NewFeedItem1.ParentId = pubModel.PubAttachments.AuthorAttachmentGroupId; 
        NewFeedItem1.ContentData = EncodingUtil.base64Decode('mockContent');        
        insert NewFeedItem1; 
        
        PubAttachmentDetails__c aPubAttachmentDetail = new PubAttachmentDetails__c(); 
        aPubAttachmentDetail.Publication__c = pubModel.pubId; 
        aPubAttachmentDetail.AttachmentType__c = 'Draft - Share with Authors';      
        aPubAttachmentDetail.AttachmentName__c = 'test1';   
        aPubAttachmentDetail.What__c = NewFeedItem1.Id;
        aPubAttachmentDetail.Attachment_URL__c   = AppearUrlModel.ChatterFeedIdToUrl(aPubAttachmentDetail.what__c);
        insert aPubAttachmentDetail;         

        FeedItem NewFeedItem2 = new FeedItem(); 
        NewFeedItem2.ContentFileName = 'mockFile.txt';
        NewFeedItem2.ParentId = aPubAttachmentDetail.Id; 
        NewFeedItem2.ContentData = EncodingUtil.base64Decode('mockContent');        
        insert NewFeedItem2;        

        Id userId = userInfo.getUserId();              
        List<Contact> contactsToAdd = new List<Contact>();        
        Contact triageContact = new Contact(lastname='testing',firstname='triage',userid__c=userId);
        contactsToAdd.add(triageContact);
        Contact triageContact2 = new Contact(lastname='testing',firstname='triage2',userid__c=userId);
        contactsToAdd.add(triageContact2);
        Contact delegateContact = new Contact(lastname='testing',firstname='delegate',userid__c=userId);
        contactsToAdd.add(delegateContact);
        insert contactsToAdd;

        List<Contact> appearContacts = [Select id, FirstName from Contact limit 3];
        Set<Id> contactSet =  new Set<Id>();
        for (Contact aContact: contactsToAdd){
            contactSet.add(aContact.Id);
        }

        
        PubAuthorModelNoSharing aPubAuthorNoSharing = pubModel.PubAuthorNoSharing; 
        
        PubAuthor__c PubAuthApprove = new PubAuthor__c();
        PubAuthApprove.Publication__c = Pub.Id;
        PubAuthApprove.Author__c = appearContacts[2].Id;
        PubAuthApprove.ApprovalSentDate__c = date.today();
        PubAuthApprove.AuthorStatus__c='Pending Author Approval';
        PubAuthApprove.Approval_Disclaimer_ID__c =   PubAuthorModelNoSharing.getLatestPubAuthorAttachmentId(Pub.Id); 
        PubAuthApprove.ApprovalAcceptedDate__c =null;
        
        insert PubAuthApprove;        
        

        System.Test.startTest();
        aPubAuthorNoSharing.PubAuthorId = PubAuthApprove.Id; 
        map<id, string> ApprovePubAuthorAttachmentMap =       aPubAuthorNoSharing.ApprovePubAuthorAttachmentMap;
        string approvalURL = aPubAuthorNoSharing.getApproveAttachmentURL();
         List<FeedItem> aFeedItemLIst = PubAuthorModelNoSharing.GetFeedItems(userId, Pub.Id); 
         Map< id, List<FeedItem>> aFeedMap =   PubAuthorModelNoSharing.GetFeedItemCountByAuthor( contactSet, Pub.Id); 
        aPubAuthorNoSharing.NewDraftComment.body = 'test comments 1'; 
        aPubAuthorNoSharing.NewDraftComment.parentId = aPubAttachmentDetail.id; 
        aPubAuthorNoSharing.AddDraftComment(); 
        aPubAuthorNoSharing.NewDraftComment.body = 'test comments 2'; 
        aPubAuthorNoSharing.NewDraftComment.parentId = aPubAttachmentDetail.id; 
        aPubAuthorNoSharing.AddDraftComment2(); 

        Map<id, PubAuthorPubDTO> PubAuthorPubMap = aPubAuthorNoSharing.PubAuthorPubMap;
        Map<id, List<PubAuthorPubDraftAttachCommentDTO>> PubAuthorCommentMap = aPubAuthorNoSharing.PubAuthorCommentMap;
        Map<id, decimal> PubAuthorCommentCountMap =  aPubAuthorNoSharing.PubAuthorCommentCountMap;
        
        aPubAuthorNoSharing.pubAttachmentIdForComment =  aPubAttachmentDetail.id; 
        aPubAuthorNoSharing.RemoteSetPubAttachmentIdForComment(); 
        List<PubAuthorPubDraftAttachCommentDTO> AuthorCommentbyAttachment = aPubAuthorNoSharing.AuthorCommentbyAttachment;
        aPubAuthorNoSharing.CommentAuthorStatusForDelete = 'Approval Rejected';
        aPubAuthorNoSharing.deletecomment() ;
        aPubAuthorNoSharing.CommentAuthorStatusForDelete = '';
        aPubAuthorNoSharing.deletecomment() ;       
                
        aPubAuthorNoSharing.updatePubAfterApproval(pub.id);//Appear Enhancement R3
        
        System.Test.stopTest();
    }



}