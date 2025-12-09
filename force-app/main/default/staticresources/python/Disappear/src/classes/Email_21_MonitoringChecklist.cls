/*
*** Class Details *** 
Email_21_MonitoringChecklist class is used to trigger email notification to Monitoring Team User DL group. Email will be triggered when RAE Checklist Part 1/2/3 type
attachment added.
NOTE** Support and Development Team need to make sure whenever any New Sandbox is created, they should change the Custom Setting value which hold the Monitoring DL 
group. Otherwise Business Users will continuously receiving emails from sandbox during any testing or development. 
*/
public with sharing class Email_21_MonitoringChecklist extends AppearEmailBase{
	
	public Email_21_MonitoringChecklist(){
		super();
	}
	
	public Email_21_MonitoringChecklist(Contact email,pubAttachmentDetails__c attachmentId,Id emailTemplateId,User userId){
		super();
		replyTo(email.email); 
        CcAddress(userId.email);
        whatId(attachmentId.id);
        templateId(emailTemplateId);
        targetObjectId(email.Id); 
	}
	
	
	
	
	@future
    public static void Email_21_MonitoringChecklistBatchLimit(Id attachmentId){        
        EmailTemplate emailTemplateId = [select id,name,Isactive,Folder.Name from EmailTemplate Where IsActive = true And (Folder.Name = 'RAE Checklist Folder') order by createdDate desc limit 1];
            
        Contact monitoringContact=[Select Id,FirstName,LastName,Email from Contact where Name = 'Monitoring Team'];
        
        PubAttachmentDetails__c pubAttachment = [Select Id, AttachmentType__c,Publication__c,Publication__r.Name,Publication__r.Current_Target__c,
        											publication__r.GPP_Type__c,publication__r.Publication_Title__c from
        											PubAttachmentDetails__c where id =:attachmentId];
        
        User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];
           
        try {
                system.debug('Reached this place');
                Email_21_MonitoringChecklist email = new  Email_21_MonitoringChecklist(monitoringContact,pubAttachment, emailTemplateId.id, currentUser);
                if (!email.sendEmailWithResult()){
                    System.debug('Email_19_DraftShare / failed to deliver to:' + pubAttachment.Id ); 
                }
            } catch (AppearException appearEx){
                AppLogModel.LogError('Email_21_MonitoringChecklist', 'The monitoring email delivery to ' + monitoringContact.Id, pubAttachment.id);                         
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The attachment status email delivery to ' + pubAttachment + ' failed. Please validate if the email address is correct. If the problem persists, please contact the system administrator.' ));                       
            } catch (EmailException emailEx) {
                AppLogModel.LogError('Email_21_MonitoringChecklist', 'The monitoring email delivery to ' + monitoringContact.Id, pubAttachment.id);                     
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The attachment status email delivery to ' + pubAttachment+ ' failed. Please validate if the email address is correct. If the problem persists, please contact the system administrator.' + ' Error Details: ' + emailEx.getMessage()));
            } catch(DmlException dmlEx) {
                AppLogModel.LogError('Email_21_MonitoringChecklist', 'The monitoring email delivery to ' + monitoringContact.Id, pubAttachment.id);                         
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The attachment status email delivery to ' + pubAttachment + ' failed. Please validate if the email address is correct. If the problem persists, please contact the system administrator.' + ' Error Details: ' + dmlEx.getMessage()));
            } finally {
            	system.debug('Email Triggered');
                AppLogModel.flushLogs();
            }
                 
    }
	
}