/*
*** Class Details *** 
Email_20_RAEChecklist class is used to trigger email notification to RAE & WCs. Email will be triggered when Monitoring Checklist Part 1/2/3 type
attachment added.
*/

public class Email_20_RAEChecklist extends AppearEmailBase {
	
	public Email_20_RAEChecklist(){ 
		super();
	}
	
	public Email_20_RAEChecklist(List<Id> aCon,id attachmentId,Id emailTemplateId,User userId,String monitoringDL){
		super();
		replyTo(userId.email); 
		ToAddresses(aCon);
        CcAddress(monitoringDL);
        whatId(attachmentId);
        templateId(emailTemplateId);
        targetObjectId(aCon[0]); 
	}
	
	@future
	public static void Email_20_RAEChecklistBatch(Id attchmentDetailsId,Id pubId){
		EmailTemplate emailTemplateId = [select id,name,Isactive,Folder.Name from EmailTemplate Where IsActive = true And (Folder.Name = 'Monitoring Checklist Folder') order by createdDate desc limit 1];
        
        PubAttachmentDetails__c pubAttachment = [Select Id, AttachmentType__c,Publication__c,Publication__r.Name,Publication__r.Current_Target__c,
        											Publication__r.RAE__c, publication__r.GPP_Type__c,publication__r.Publication_Title__c from
        											PubAttachmentDetails__c where id =:attchmentDetailsId];
        
        User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];
        
        Contact monitoringContact=[Select Id,FirstName,LastName,Email from Contact where Name = 'Monitoring Team'];
       
        List<id> receipentIds = new List<Id>();
        if(pubAttachment.Publication__r.RAE__c != null)
        receipentIds.add(pubAttachment.Publication__r.RAE__c); 
        
        //Email will be triggered only to the Writing role members who have Appear Role as Writing Coordinator, GPPL // Appear Enhancement Backlog R4:2017
        //List<PubME__c> writingRoleMember = [SELECT Id,WritingRoleMember__c FROM PubME__c WHERE AppearRole__r.Name ='Writing Coordinator' and Publication__c =:pubId];
        List<PubME__c> writingRoleMember = [SELECT Id,WritingRoleMember__c FROM PubME__c WHERE AppearRole__r.Name in ('Writing Coordinator','GPPL') and Publication__c =:pubId];
        
        for(PubME__c wc : writingRoleMember){
        	receipentIds.add(wc.WritingRoleMember__c);
        }
        
        System.debug('$$$$$$$$$$$'+receipentIds);
        List<PubEmail__c> monitoredEmailNotificationList = new List<PubEmail__c>();
        if(receipentIds.size()>0){
        	
        		try{
	        		Email_20_RAEChecklist email = new Email_20_RAEChecklist(receipentIds,pubAttachment.Id,emailTemplateId.Id,currentUser,monitoringContact.email);
	        		if (!email.sendEmailWithResult()){
                    	System.debug('Email_20_RAEChecklist / failed to deliver to:' + pubAttachment.Id ); 
                	}
        			
        		}catch (AppearException appearEx){
        			
        		}catch (EmailException emailEx) {
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The invitation email delivery to ' + pubAuthorList[i].author__r.email + ' failed. Please validate if the email address is correct. If the problem persists, please contact the system administrator.' + ' Error Details: ' + emailEx.getMessage()));
                    AppLogModel.LogError('Email_20_RAEChecklistBatch', 'The monitoring email delivery to '+receipentIds);                   
                } catch(DmlException dmlEx) {
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The invitation email delivery to ' + pubAuthorList[i].author__r.email + ' failed. Please validate if the email address is correct. If the problem persists, please contact the system administrator.' + ' Error Details: ' + dmlEx.getMessage()));
                    AppLogModel.LogError('Email_20_RAEChecklistBatch', 'The monitoring email delivery to ' + receipentIds, pubAttachment.Id);                   
                } finally {
                    AppLogModel.flushLogs();
                }
        		
        	
        }										
         
	}
}