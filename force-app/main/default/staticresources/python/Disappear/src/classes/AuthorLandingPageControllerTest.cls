@IsTest
public class AuthorLandingPageControllerTest {

  private static void createData() {
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        AccountModelData.createData();
        AppearContactModelData.createData();
  }

    @IsTest
    public static void UnitTest() {    
        createData();
        System.Test.startTest();
        document d = new Document();
        d.Name='Author Invitation Disclaimer';
        d.AuthorId = UserInfo.getUserId();
        d.FolderId = UserInfo.getUserId();
        insert d;
 
        ProvisionDocumentVersion__c prov = new ProvisionDocumentVersion__c ();
        prov.ProvisionDocumentContent__c = 'Test';
        insert prov;
        
        Publication__c pub = UnitTestData.PublicationNew('AuthorInvitationLandingPage');  
        Publication__c clonePub = UnitTestData.newPublication('AuthorInvitation');
        List<Contact> appearContacts = [Select id, FirstName from Contact limit 3];
        pubAuthor__c pubauthor = new pubAuthor__c();
        pubauthor.Publication__c  = pub.id;
        pubauthor.author__c= appearContacts[0].id;
        pubauthor.Disclaimer_ID__c = prov.id;
        insert pubauthor;
        
        
        AppearPubModel pubModel = new AppearPubModel(pub.id);
        
        PageReference pageRef = new PageReference('/apex/AuthorInvitationLandingPage');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('PubAuthorId', pubauthor.id);
        
        AuthorInvitationLandingPageController  AuthorLanding= new AuthorInvitationLandingPageController();
         
        PageReference p= AuthorLanding.getContentVersionPage();
        PageReference p1 = AuthorLanding.AppearPubAuthor();
        PageReference p2 = AuthorLanding.CancelAppearPubAuthor();
        AuthorLanding.getcomptype();
        AuthorLanding.setcomptype('test');
        System.Test.stopTest();
        
        }
    }