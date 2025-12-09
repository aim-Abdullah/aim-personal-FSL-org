public class Email_16_AuthorInvitation extends AppearEmailBase  {

    public Email_16_AuthorInvitation(pubAuthor__c aPub , Id emailTemplateId, User currentUser) {
        super();            
                //List<String> toAddressIds = new List<String> {aPub.author__r.email};
                //ToAddresses(toAddressIds); // SFDC CASE: 11260997 {Sesha: This is not required when using the standard SFDC VF email template as the TARGET OBJECT is already calling the EMAIL Object and working as DESIGNED by SFDC.}
                replyTo(currentUser.email); 
                CcAddress(currentUser.email);
                whatId(aPub.id);
                templateId(emailTemplateId);
                targetObjectId(aPub.author__c);  
        
    }

    public Email_16_AuthorInvitation() {
        super();
    }
    
    @future 
    public static void Email_16_AuthorInvitationBatchLimit(List <id> pubAuthorIds, List<id> emailTemplateIds ){
            
        // the caller of this method is responsible for grovenor limit. 
               
        List <pubAuthor__c> pubAuthorList = [select id,  AuthorStatus__c, publication__c, author__c, author__r.name, author__r.email, AuthorOrder__c, ApprovalSentDate__c, InviteSentDate__c, Disclaimer_ID__c
                                             from PubAuthor__c
                                             where id in :pubAuthorIds
                                             AND isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
                                            ]; 
        User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];   
        id docId = PubAuthorModelNoSharing.getLatestInviteDisclaimerId(); 
        //Appear Enhancement R2, list is created for Store Author Email functionality
        List<PubEmail__c> authorInvitationEmailList = new List<PubEmail__c>();
        
        for (integer i = 0; i < pubAuthorList.size(); i++ ){
                // iy: currently use SingleEmailMessage. Shoud consider bulkifying the code if volume is large
                try {
                    Email_16_AuthorInvitation email = new Email_16_AuthorInvitation(pubAuthorList[i], emailTemplateIds[i], currentUser);
                    if (email.sendEmailWithResult()){
                        pubAuthorList[i].InviteSentDate__c = date.today(); 
                        pubAuthorList[i].Disclaimer_ID__c = docId;                  
                        if (pubAuthorList[i].AuthorStatus__c == null || pubAuthorList[i].AuthorStatus__c == PubAuthorModelNoSharing.sPendingInviteDelivery || pubAuthorList[i].AuthorStatus__c =='' ){
                            pubAuthorList[i].AuthorStatus__c = PubAuthorModelNoSharing.sPendingInviteAcceptance;
                        }
                        //Appear Enhancement R2
                        PubEmail__c invitationEmail = new PubEmail__c();
                        invitationEmail.Email_Body__c  = email.getHtmlMailBody();
                        List<String> ccaddresses=email.getCCAddresses();
                        String ccAddressString;
                        for(String ccadd:ccaddresses){
                            ccAddressString=ccadd+';';
                        }
                        invitationEmail.CC__c=ccAddressString;
                        invitationEmail.Author__c = pubAuthorList[i].author__c;   
                        invitationEmail.Subject__c = email.getSubject();   
                        invitationEmail.Publication_Author__c= pubAuthorList[i].id;  
                        invitationEmail.Type__c='Invitation Email';                        
                        authorInvitationEmailList.add(invitationEmail);
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
        //Appear Enhancement R2, inserting teh invitation Email Records to Publication Email Object
        insert authorInvitationEmailList;
        
        AppearTriggerActivationModel.shouldSkipUsAuthorUpdate = true;
        update pubAuthorList; 
        AppearTriggerActivationModel.shouldSkipUsAuthorUpdate = false;
        
    }
    
    public static void Email_16_AuthorInvitationBatch(List <id> pubAuthorIds, List<id> emailTemplateIds ){
            
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
                Email_16_AuthorInvitationBatchLimit(pubAuthorIdsByLimit,  emailTemplateIdsByLimit ); 
                batchCount = 0; 
                pubAuthorIdsByLimit.clear();
                emailTemplateIdsByLimit.clear();  
            }
        }
        if (batchCount > 0){
                Email_16_AuthorInvitationBatchLimit(pubAuthorIdsByLimit,  emailTemplateIdsByLimit );
                batchCount = 0; 
                pubAuthorIdsByLimit.clear();
                emailTemplateIdsByLimit.clear();  
        }

        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,  'Author invitation email(s) are queued for delivery. Please check back after couple minutes to view the system updates.'));    
    }
    
    
    public static void testBatchEmails(){
        /*EmailTemplate template = New EmailTemplate(Name = 'Author Agreement', Body = null, BrandTemplateId=null, DeveloperName='Author_Agreement', FolderId=UserInfo.getUserId(), IsActive=True, Subject='test', TemplateType='Text');
        insert template;*/

        List<pubAuthor__c> pubAuthors = [
                select id,  author__r.Email, author__c from pubAuthor__c where  author__r.Email like '%if%'
        		AND isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
        		]; // pick any one record 
        List <EmailTemplate> emailTemplates = [SELECT id, Name FROM EmailTemplate where name like '%Author Agreement%' limit 1];
        
        List <id> pubAuthorIds = new list <id>();
        list <id> emailTemplateIds = new list <id>();
        for (pubAuthor__c aPub :pubAuthors ){
            pubAuthorIds.add(aPub.id);
            emailTemplateIds.add(emailTemplates[0].id);
        }
        /*
        for (EmailTemplate aEmailTemplate : emailTemplates ){
            emailTemplateIds.add(aEmailTemplate.id);
        }*/
        Email_16_AuthorInvitationBatch(pubAuthorIds,emailTemplateIds );
    }
    
    
    

    public static void testEmail() {

        // whatId : pub_author__c
        // templateid : Author Invitation 
        // targetObjectId: contact 
        
        // this test method send email to the current user, even though the body of the email is reference to one of the pub author
        List<pubAuthor__c> pubAuthors = [
               							select id,  author__r.Email, author__c from pubAuthor__c 
            							Where isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
            							limit 1 
        								]; // pick any one record 
        if (!pubAuthors.isEmpty()) {
                pubAuthor__c aPubAuthorId = pubAuthors[0]; 
                
                EmailTemplate aTemplate = [SELECT id, Name FROM EmailTemplate where name like '%Author Agreement%' limit 1];
                
                if (aTemplate != null){

                    Email_16_AuthorInvitation email = new Email_16_AuthorInvitation(); 
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
                    AppLogModel.LogDebug('Email_16_AuthorInvitation::testEmail','missing template');                    
                }      
        } else {
                     AppLogModel.LogDebug('Email_16_AuthorInvitation::testEmail','Cannot find contact');                    
        }
        
    }

}