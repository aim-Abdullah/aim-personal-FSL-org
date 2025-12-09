public class AppearEmailTest extends AppearEmailBase{

    public AppearEmailTest(Contact toContact) {
        super('AppearEmailTest');
 
        subject('AppearEmailTest');
        ToAddress(toContact.Email);

        string htmlBodyStr =
            'AppearEmailTest - this is body';

        htmlBody(htmlBodyStr);
        plainTextBody(htmlBodyStr.replace('<br>', '\\r\\n'));
    }

    //AppearEmailTest.testGoodCase();
    public static void testGoodCase() {
    
        AppearEmailTest email = new AppearEmailTest(EmailPubReviewTeam.contact2);
        email.sendEmail();
    }
    
    //AppearEmailTest.testMaxAddresses();
    public static void testMaxAddresses() {
        AppearEmailTest email = new AppearEmailTest(EmailPubReviewTeam.contact2);
        for(integer x=0; x<99; x++) {
            email.ToAddress('benjamin_lau@hotmail.com');
        }
        for(integer x=0; x<25; x++) {
            email.CcAddress('benjamin_lau@hotmail.com');
            email.BccAddress('benjamin_lau@hotmail.com');
        } 
        email.sendEmail();
    }
     
    //AppearEmailTest.undeliverableEmail();
    public static void undeliverableEmail() {
        AppearEmailTest email = new AppearEmailTest(EmailPubReviewTeam.contact1);
        email.CcAddress('canotbedelivered-bademailaddress@benjaminlau.com');
        email.senderDisplayName('[sender for test undeliverable email]');
        
        //overrode replyTo
        email.replyTo('benjamin_lau@hotmail.com');
        
        email.sendEmail();
    }
    //Appear Enhancement R2
    @isTest(SeeAllData=false) // Appear Enhancement Backlog R2
    public static void authorInvitationReminderApprovalMailTest(){
        Publication__c pub = UnitTestData.PublicationNew('SelectDeselectAuthorsTest');
        User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];
        Contact aContact = new Contact(lastname='testing', firstname='test', Email='ranjeet.kumar3@cognizant.com',country__c='United States');
        insert aContact;
        
        List<PubAuthor__c> pubAuthors= new List<PubAuthor__c>();
        pubAuthors.add(new PubAuthor__c(Publication__c = Pub.Id,Author__c = aContact.Id,GrantDraftAccess__c = true,ApprovalSentDate__c = date.today(),AuthorStatus__c='Pending Invite Delivery'));
        insert pubAuthors;      
        List<Id> pubAuthorIds= new List<Id>();
        for(PubAuthor__c pubs: pubAuthors){
            pubAuthorIds.add(pubs.Id);
        }
        
        system.debug('checking the Id set'+pubAuthorIds);
        
        List<EmailTemplate> emailTemplate = new List<EmailTemplate>([Select id from EmailTemplate where Name='Abstract and Scientific Presentations Author Agreement (Lead Author)' limit 1]);
        List<Id> emailTemplateIds= new List<Id>();
        emailTemplateIds.add(emailTemplate[0].Id);
        //Author Invitation part
        Email_16_AuthorInvitation.Email_16_AuthorInvitationBatchLimit(pubAuthorIds, emailTemplateIds);      
        Email_16_AuthorInvitation.Email_16_AuthorInvitationBatch(pubAuthorIds, emailTemplateIds);
        
        //Author Reminder part
        Email_18_AuthorReminder email_18= new Email_18_AuthorReminder(pubAuthors[0],emailTemplateIds[0],currentUser);
        Email_18_AuthorReminder.Email_18_AuthorReminderBatchLimit(pubAuthorIds, emailTemplateIds);
        Email_18_AuthorReminder.Email_18_AuthorReminderBatch(pubAuthorIds, emailTemplateIds);
        
        //Final Author Approval
        Email_17_AuthorApproval email_17= new Email_17_AuthorApproval(pubAuthors[0],emailTemplateIds[0],currentUser);
        Email_17_AuthorApproval.Email_17_AuthorApprovalBatchLimit(pubAuthorIds, emailTemplateIds);
    }
    
    
    
    @IsTest
    public static void EmailUnitTest1() {
        testGoodCase() ;
        testMaxAddresses();
    }
    
    
    @IsTest
    public static void EmailTemplatesUnitTest1(){
        Email_01_FprcConfirmationForSubmitter.testEmail();
        Email_02_RoutedForPrimary.testEmail();
        Email_03_RoutedToDelegate.testEmail();
        Email_04_RoutedToTriagee.testEmail();
        Email_05_PubWithheld.testEmail();
    }
    
    @IsTest
    public static void EmailTemplatesUnitTest2(){
        Email_06_PubWithdrawn.testEmail();
        Email_07_FprDiscussionRequired.testEmail();
        Email_08_IndividualFprReviewerReviewed.testEmail();
        Email_09_IndividualFprReviewerCommented.testEmail();
        Email_10_FullFprReviewComplete.testEmail();
    }

    @IsTest
    public static void EmailTemplatesUnitTest3(){
        Email_11_IndividCourtesyFprRevCommented.testEmail();
        Email_12_IndividCourtesyFprRevReviewed.testEmail();
        Email_13_CourtesyFprReviewComplete.testEmail();
        Email_14_ChangeReviewerTypeOrNewPrimary.testEmail();
        Email_15_FullFprReviewWithCmtsComplete.testEmail();
    }
    
    @IsTest(SeeAllData=false)
    public static void EmailTemplatesUnitTest16_17(){

        /*
        EmailTemplate aTemplate = new EmailTemplate();
        aTemplate.name = 'Author Agreement'; 
        aTemplate.DeveloperName = 'author_agreement'; 
        insert aTemplate; 
        */
    
        Id userId = userInfo.getUserId();              
        

        
        Publication__c pub = UnitTestData.PublicationNew('SelectDeselectAuthorsTest');
        Contact aContact = new Contact(lastname='testing', firstname='test', userid__c=userId, Email='if@test.com.invalid');
        insert aContact;
        
        PubAuthor__c PubAuthApprove = new PubAuthor__c();
        PubAuthApprove.Publication__c = Pub.Id;
        PubAuthApprove.Author__c = aContact.Id;
        PubAuthApprove.GrantDraftAccess__c = true; 
        PubAuthApprove.ApprovalSentDate__c = date.today();
        PubAuthApprove.InviteAcceptedDate__c  = date.today();
        PubAuthApprove.AuthorStatus__c='Pending Author Approval';
        insert PubAuthApprove;
        

        Email_16_AuthorInvitation.testBatchEmails();
        Email_16_AuthorInvitation.testEmail();
        Email_17_AuthorApproval.testBatchEmails();
        Email_17_AuthorApproval.testEmail();        
        Email_18_AuthorReminder.testEmail();
        Email_18_AuthoRreminder.testBatchEmails();
        Email_19_DraftShare.testEmail();
        Email_19_DraftShare.testBatchEmails();      
    }
    
    
    @IsTest(SeeAllData=false)
    private static void TestMultipleBatchEmail16(){       
        AppearTriggerActivationModel.shouldSkipPubAuthorTrigger = true;
        
        Id userId = userInfo.getUserId();       
        Publication__c pub = UnitTestData.PublicationNew('TestMultipleBatchEmail16');
        for(integer i = 0; i < 11; i++) {
            Contact aContact = new Contact(lastname='testing'+i,firstname='test'+i,userid__c=userId, Email=i+'if@test.com.invalid');
            insert aContact;
            
            PubAuthor__c PubAuthApprove = new PubAuthor__c();
            PubAuthApprove.Publication__c = pub.Id;
            PubAuthApprove.Author__c = aContact.Id;
            PubAuthApprove.GrantDraftAccess__c = true; 
            PubAuthApprove.ApprovalSentDate__c = date.today();
            PubAuthApprove.InviteAcceptedDate__c  = date.today();
            PubAuthApprove.AuthorStatus__c='Pending Author Approval';
            insert PubAuthApprove;
        }
        
        Test.startTest();
        Email_16_AuthorInvitation.testBatchEmails();
        Test.stopTest();
        AppearTriggerActivationModel.shouldSkipPubAuthorTrigger = true;
    }
    
}