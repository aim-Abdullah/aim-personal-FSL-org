public class Email_19_DraftShare extends AppearEmailBase  {


    public Email_19_DraftShare(pubAuthor__c aPub , Id emailTemplateId, User currentUser) {
        super();            
                //List<String> toAddressIds = new List<String> {aPub.author__r.email};
                //ToAddresses(toAddressIds); // SFDC CASE: 11260997 {Sesha: This is not required when using the standard SFDC VF email template as the TARGET OBJECT is already calling the EMAIL Object and working as DESIGNED by SFDC.}
                replyTo(currentUser.email); 
                CcAddress(currentUser.email);
                whatId(aPub.id);
                templateId(emailTemplateId);
                targetObjectId(aPub.author__c);     
    }

    public Email_19_DraftShare() {
        super();
    }
    
    @future
    public static void Email_19_DraftShareBatchLimit(List<id> pubAuthorIds){        
        EmailTemplate emailTemplateId = [select id,name,Isactive,Folder.Name from EmailTemplate Where IsActive = true And (Folder.Name = 'Draft Share Reminder Templates') order by createdDate desc limit 1];
            
        List <pubAuthor__c> pubAuthorList = [select id, InviteAcceptedDate__c, GrantDraftAccess__c, InviteSentDate__c, AuthorStatus__c, publication__c, author__c, author__r.name, author__r.email, AuthorOrder__c, Approval_Disclaimer_ID__c, ApprovalSentDate__c
                                            from PubAuthor__c
                                            where id in :pubAuthorIds
                                            AND isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality                                     
                                            ];
        
        User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];   
        for (integer i = 0; i < pubAuthorList.size(); i++ ){
            // iy: currently use SingleEmailMessage. Shoud consider bulkifying the code if volume is large
            try {
                Email_19_DraftShare email = new Email_19_DraftShare(pubAuthorList[i], emailTemplateId.id, currentUser);
                if (!email.sendEmailWithResult()){
                    System.debug('Email_19_DraftShare / failed to deliver to:' + pubAuthorList[i].id ); 
                }
            } catch (AppearException appearEx){
                AppLogModel.LogError('Email_19_DraftShareBatchLimit', 'The invitation email delivery to ' + pubAuthorList[i].author__r.email, pubAuthorList[i].id);                         
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The attachment status email delivery to ' + pubAuthorList[i].author__r.email + ' failed. Please validate if the email address is correct. If the problem persists, please contact the system administrator.' ));                       
            } catch (EmailException emailEx) {
                AppLogModel.LogError('Email_19_DraftShareBatchLimit', 'The invitation email delivery to ' + pubAuthorList[i].author__r.email, pubAuthorList[i].id);                     
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The attachment status email delivery to ' + pubAuthorList[i].author__r.email + ' failed. Please validate if the email address is correct. If the problem persists, please contact the system administrator.' + ' Error Details: ' + emailEx.getMessage()));
            } catch(DmlException dmlEx) {
                AppLogModel.LogError('Email_19_DraftShareBatchLimit', 'The invitation email delivery to ' + pubAuthorList[i].author__r.email, pubAuthorList[i].id);                         
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The attachment status email delivery to ' + pubAuthorList[i].author__r.email + ' failed. Please validate if the email address is correct. If the problem persists, please contact the system administrator.' + ' Error Details: ' + dmlEx.getMessage()));
            } finally {
                AppLogModel.flushLogs();
            }
        }         
    }
    
    public static void Email_19_DraftShareBatch(id pubId ){
        List <pubAuthor__c> pubAuthorList = [select id
                                            from PubAuthor__c
                                            where GrantDraftAccess__c = true and InviteAcceptedDate__c != null
                                            and  publication__c = :PubId
                                            and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality                                     
                                            ];    
        
        // the size of pubAuthorIds and emailTemplates should match. Currently, all emailTemplates are the same. 
        Decimal APILimit = 10;  // Total number of sendEmail methods allowed = 10
        Decimal batchCount = 0; 
        List <id> pubAuthorIdsByLimit = new List<id>(); 
        
        for (integer i = 0; i < pubAuthorList.size(); i++ ){

            batchCount++; 
            pubAuthorIdsByLimit.add(pubAuthorList[i].Id);
            
            if (batchCount == APILimit){
                Email_19_DraftShareBatchLimit(pubAuthorIdsByLimit); 
                batchCount = 0; 
                pubAuthorIdsByLimit.clear();  
            }
        }
        if (batchCount > 0){
            Email_19_DraftShareBatchLimit(pubAuthorIdsByLimit);             
            batchCount = 0; 
            pubAuthorIdsByLimit.clear();  
        }
                             
    }
    
    //=====================
 // Appear Enhancment R3
 // =====================
 	
    //Future Method to send the Draft-Share email
      @future 
    public static void Email_19_DraftShareBatchLimit(List <id> pubAuthorIds, List<id> emailTemplateIds ){
            
        // the caller of this method is responsible for grovenor limit. 
               
        List <pubAuthor__c> pubAuthorList = [select id,  AuthorStatus__c, publication__c, author__c, author__r.name, author__r.email, AuthorOrder__c, ApprovalSentDate__c, InviteSentDate__c, Disclaimer_ID__c
                                            from PubAuthor__c
                                            where id in :pubAuthorIds
                                            and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality                                    
                                            ]; 
        User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];   
        //Appear Enhancement R2, list is created for Store Author Email functionality
        List<PubEmail__c> authorDraftShareEmailList = new List<PubEmail__c>();
        
        for (integer i = 0; i < pubAuthorList.size(); i++ ){
                // iy: currently use SingleEmailMessage. Shoud consider bulkifying the code if volume is large
                try {
                	id docId = PubAuthorModelNoSharing.getLatestPubAuthorDraftShareId(pubAuthorList[i].publication__c); 
                    Email_19_DraftShare email = new Email_19_DraftShare(pubAuthorList[i], emailTemplateIds[i], currentUser);
                    if (email.sendEmailWithResult()){
                        pubAuthorList[i].DraftShareDate__c = date.today(); 
                        pubAuthorList[i].Disclaimer_ID__c = docId;  
                        // Backlog R2 Req.29 - Appear Enhancement backlog R2 2017 - Remove Nullification of CommentReceiveDate
                        //pubAuthorList[i].CommentReceivedDate__c = null;//Changing the comment received to null once Draft has been shared
                        if (pubAuthorList[i].AuthorStatus__c == null || pubAuthorList[i].AuthorStatus__c == PubAuthorModelNoSharing.sPublicationReviewByAuthors || pubAuthorList[i].AuthorStatus__c =='' ){
                            pubAuthorList[i].AuthorStatus__c = PubAuthorModelNoSharing.sPublicationReviewByAuthors;
                        }
                        pubAuthorList[i].GrantDraftAccess__c = true; //Appear Enhancement R3 Share Draft -Grant Draft Access checked to true
                        //Appear Enhancement R2
                        PubEmail__c draftShareEmail = new PubEmail__c();
                        draftShareEmail.Email_Body__c  = email.getHtmlMailBody();
                        List<String> ccaddresses=email.getCCAddresses();
                        String ccAddressString;
                        for(String ccadd:ccaddresses){
                            ccAddressString=ccadd+';';
                        }
                        draftShareEmail.CC__c=ccAddressString;
                        draftShareEmail.Author__c = pubAuthorList[i].author__c;   
                        draftShareEmail.Subject__c = email.getSubject();   
                        draftShareEmail.Publication_Author__c= pubAuthorList[i].id;  
                        draftShareEmail.Type__c='Draft-Share Email';                        
                        authorDraftShareEmailList.add(draftShareEmail);
                    }
                } catch (AppearException appearEx){
                    // remove message from future all since it is out of VF context
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The invitation email delivery to ' + pubAuthorList[i].author__r.email + ' failed. Please validate if the email address is correct. If the problem persists, please contact the system administrator.' ));  
                    AppLogModel.LogError('Email_16_AuthorInvitationBatchLimit', 'The invitation email delivery to ' + pubAuthorList[i].author__r.email, pubAuthorList[i].id);                   
               } catch (EmailException emailEx) {
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The invitation email delivery to ' + pubAuthorList[i].author__r.email + ' failed. Please validate if the email address is correct. If the problem persists, please contact the system administrator.' + ' Error Details: ' + emailEx.getMessage()));
                    AppLogModel.LogError('Email_16_AuthorInvitationBatchLimit', 'The invitation email delivery to ' + pubAuthorList[i].author__r.email, pubAuthorList[i].id);                   
                } catch(DmlException dmlEx) {
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The invitation email delivery to ' + pubAuthorList[i].author__r.email + ' failed. Please validate if the email address is correct. If the problem persists, please contact the system administrator.' + ' Error Details: ' + dmlEx.getMessage()));
                    AppLogModel.LogError('Email_16_AuthorInvitationBatchLimit', 'The invitation email delivery to ' + pubAuthorList[i].author__r.email, pubAuthorList[i].id);                   
                } finally {
                    AppLogModel.flushLogs();
                }
               
        } 
        //Appear Enhancement R2, inserting the Draft-Share Email Records to Publication Email Object
        insert authorDraftShareEmailList;
        
        AppearTriggerActivationModel.shouldSkipUsAuthorUpdate = true;
        update pubAuthorList; 
        AppearTriggerActivationModel.shouldSkipUsAuthorUpdate = false;
        
    }
    //Future Method to send the Draft-Share email
    
    //Start - New overloaded method written to pass the email template as parameters along with the PubIds
        public static void Email_19_DraftShareBatch(List <id> pubAuthorIds, List<id> emailTemplateIds ){
            
        // the size of pubAuthorIds and emailTemplates should match. Currently, all emailTemplates are the same. 
        Decimal APILimit = 10;  // Total number of sendEmail methods allowed = 10
        Decimal batchCount = 0; 
        List <id> pubAuthorIdsByLimit = new List<id>(); 
        List <id> emailTemplateIdsByLimit = new List <id>(); 
        
        for (integer i = 0; i < pubAuthorIds.size(); i++ ){

            batchCount++; 
            pubAuthorIdsByLimit.add(pubAuthorIds[i]); 
            emailTemplateIdsByLimit.add(emailTemplateIds[i]); 
            
            if (batchCount == APILimit){
                Email_19_DraftShareBatchLimit(pubAuthorIdsByLimit,  emailTemplateIdsByLimit ); 
                batchCount = 0; 
                pubAuthorIdsByLimit.clear();
                emailTemplateIdsByLimit.clear();  
            }
        }
        if (batchCount > 0){
                Email_19_DraftShareBatchLimit(pubAuthorIdsByLimit,  emailTemplateIdsByLimit );
                batchCount = 0; 
                pubAuthorIdsByLimit.clear();
                emailTemplateIdsByLimit.clear();  
        }

        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,  'Author Draft Share email(s) are queued for delivery. Please check back after couple minutes to view the system updates.'));    
    }
    //End - New overloaded method written to pass the email template as parameters along with the PubIds
    
    
    //=====================
 // Appear Enhancment R3
 // =====================
    
    
  
    public static void testBatchEmails(){       
        /*EmailTemplate template = New EmailTemplate(Name = 'Author Approval', Body = null, BrandTemplateId=null, DeveloperName='Author_Agreement', FolderId=UserInfo.getUserId(), IsActive=True, Subject='test', TemplateType='Text');
        insert template;*/
        
        List<pubAuthor__c> pubAuthors = [select id, publication__c, author__r.Email, author__c from pubAuthor__c where GrantDraftAccess__c = true and InviteAcceptedDate__c != null and author__r.Email like '%if%' 
            							and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
                                         limit 1 
                                        ]; // pick any one record 
        
        if (pubAuthors.size() > 0 ) {
            Email_19_DraftShareBatch(pubAuthors[0].publication__c );
        }
    }
    
    
    

    public static void testEmail() {

        // whatId : pub_author__c
        // templateid : Author Invitation 
        // targetObjectId: contact 
        
        // this test method send email to the current user, even though the body of the email is reference to one of the pub author
        List<pubAuthor__c> pubAuthors = [select id,  author__r.Email, author__c from pubAuthor__c 
                                         Where isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
                                         limit 1                                         
                                        ]; // pick any one record 
        if (!pubAuthors.isEmpty()) {
                pubAuthor__c aPubAuthorId = pubAuthors[0]; 
                
                EmailTemplate aTemplate = [SELECT id, Name FROM EmailTemplate where name like '%Author Approval%' limit 1];
                
                if (aTemplate != null){

                    Email_19_DraftShare email = new Email_19_DraftShare(); 
                    //get the current user in context
                    User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];   
                    List<String> toAddressIds = new List<String> {currentUser.email};
                    email.replyTo(currentUser.email); 
                    email.ToAddresses(toAddressIds);
                    email.CcAddress(currentUser.email);
                    email.whatId(aPubAuthorId.id);
                    email.templateId(aTemplate.id);
                    email.targetObjectId(aPubAuthorId.author__c); 
                    email.sendEmail();

                } else{
                    AppLogModel.LogDebug('Email_19_DraftShare::testEmail','missing template');                  
                }      
        } else {
                     AppLogModel.LogDebug('Email_19_DraftShare::testEmail','Cannot find contact');                  
        }
        
    }

}