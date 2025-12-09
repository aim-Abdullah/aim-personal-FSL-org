//Developer.force.com/cookbook/recipe/email-utility-class
//
//This is the base class for Appear Email that support a To list of 100 recipients
//and cc list of 25 recipents

public virtual class AppearEmailBase {  
       private Messaging.SingleEmailMessage singleEmailMessage;
       protected List<String> toAddresses;
       protected List<String> ccAddresses;
       protected List<String> bccAddresses;
       
       protected publication__c pub;
       protected string emailName;
       
       //optional parameters set to default        
       protected String subject = '';
       protected String htmlBody = ''; 
       protected Boolean useSignature = false;
       protected List<Messaging.EmailFileAttachment> fileAttachments = null;
       
       //defaults to current user's first name + last name
       protected String senderDisplayName = UserInfo.getFirstName()+' '+UserInfo.getLastName();
       
       //get the current user in context
       User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];        
       
       //replyTo defaults to current user's email 
       private String replyTo = currentUser.email;
       private String plainTextBody = '';
       
       // additional parameters to support visualforce template
       protected id targetObjectId = null;
       protected id whatId = null; 
       protected id templateId = null; 
       
              
	   
	   public AppearEmailBase(){
	   	// added for Release 4.0
	   }

       public AppearEmailBase(string emailName) {
			setup() ;
       }      
              
       public AppearEmailBase(publication__c pub, string emailName) {
       		if ( pub == null) {
       			string errMsg = 'Exception : Instantiating AppearEmailBase with Pub = null for '+ emailName;
       			AppLogModel.LogError('AppearEmailBase', errMsg);
       			AppLogModel.flushLogs();
       			AppearException ex = new AppearException(errMsg, '');
       			throw ex;
       		}
       	
       		//all pubs must have a FPR Due Date
       		if ( pub.fpr_Due_Date__c == null) {
       			string errMsg = 'Exception : Instantiating AppearEmailBase with Pub.fpr_Due_Date__c = null for '+ emailName;
       			AppLogModel.LogError('AppearEmailBase', errMsg);
       			AppLogModel.flushLogs();
       			AppearException ex = new AppearException(errMsg, '');
       			throw ex;
       		}
       		
       		this.pub = pub;
       		this.emailName = emailName;
       		checkForPrimary(pub);
       		     		
	
			setup() ;
       }
       
       private void setup() {
       		string senderName = KeyValueSettingsModel.GetKey('FprEmailSenderDisplayName','FPR System').value__c;
       		senderDisplayName(senderName);
       		
       		string replyEmail = KeyValueSettingsModel.GetKey('FprEmailReplyToEmailAddress','fpa-coordinator@amgen.com').value__c;
			replyTo(replyEmail);       	
       }
       
       private void checkForPrimary( publication__c pub) {
			if ( pub.Primary__c == null) {
				if ( pub.Product_Indication__c <> null && pub.Product_Indication__c.contains(';'))  {
					pub.Primary__c = pub.Product_Indication__c.split(';',0)[0];
				} else {
					pub.Primary__c = pub.Product_Indication__c;
				}
			}         	
       }
         
       public AppearEmailBase ToAddresses(List<String> toAddresses) {
       		this.toAddresses = ToAddresses;
       		return this;
       }
       public AppearEmailBase ToAddresses(List<Id> toAddressIds) {
       		this.toAddresses = AppearContactModel.findContactEmailByContactIds(toAddressIds);
       		return this;
       }
       public AppearEmailBase ToAddress(String toAddress) {
       		if ( toAddresses == null) {
       			toAddresses = new List<String>();
       		}
       		this.toAddresses.Add(toAddress);
       		return this;
       }

       
       public AppearEmailBase CcAddresses(List<String> ccAddresses) {
       		this.ccAddresses = ccAddresses;
       		return this;
       }
       public AppearEmailBase CcAddresses(List<Id> ccAddressIds) {
       		this.ccAddresses = AppearContactModel.findContactEmailByContactIds(ccAddressIds);
       		return this;
       }
       public AppearEmailBase CcAddress(String ccAddress) {
       		if ( ccAddresses == null) {
       			ccAddresses = new List<String>();
       		}
       		this.ccAddresses.Add(ccAddress);
       		return this;
       }
       public AppearEmailBase BccAddress(String bccAddress) {
       		if ( bccAddresses == null) {
       			bccAddresses = new List<String>();
       		}
       		this.bccAddresses.Add(bccAddress);
       		return this;
       }              
       public AppearEmailBase senderDisplayName(String val) {
           senderDisplayName = val;
           return this;
       }
       

       // additional parameters to support visualforce template
       public AppearEmailBase targetObjectId(id val) {
           targetObjectId = val;
           return this;
       }
       public AppearEmailBase whatId(id val) {
           whatId = val;
           return this;
       }
       public AppearEmailBase templateId(id val) {
           templateId = val;
           return this;
       }


       public AppearEmailBase subject(String val) {
           subject = val;
           return this;
       }
       
       public AppearEmailBase htmlBody(String val) {
           htmlBody = val;
           return this;
       }
       
       public AppearEmailBase useSignature(Boolean bool) {
           useSignature = bool;
           return this;
       }
       
       public AppearEmailBase replyTo(String val) {
           replyTo = val;
           return this;
       }
       
       public AppearEmailBase plainTextBody(String val) {
           plainTextBody = val;
           return this;
       }
       
       public AppearEmailBase fileAttachments(List<Messaging.Emailfileattachment> val) {
           fileAttachments = val;
           return this;
       }
       
       //where it all comes together
       //this method is private and is called from sendEmail()
       private AppearEmailBase build() {
           singleEmailMessage = new Messaging.SingleEmailMessage();
           
           singleEmailMessage.setToAddresses(this.toAddresses);
           singleEmailMessage.setCcAddresses(this.ccAddresses);
           singleEmailMessage.setBccAddresses(this.bccAddresses);
           
           singleEmailMessage.setSenderDisplayName(this.senderDisplayName);
           singleEmailMessage.setUseSignature(this.useSignature);
           singleEmailMessage.setReplyTo(this.replyTo);
           singleEmailMessage.setFileAttachments(this.fileAttachments);
           

           if (this.templateId != null)  {
           // parameters specific for visualforce template
	           singleEmailMessage.setTargetObjectId(this.targetObjectId);
	           singleEmailMessage.setSaveAsActivity(false); // must be set to false if whatid is specified 
	           singleEmailMessage.setWhatId(this.whatId);
	           singleEmailMessage.setTemplateId(this.templateId);
           } else {
	           singleEmailMessage.setHtmlBody(this.htmlBody);           	
          	   singleEmailMessage.setPlainTextBody(this.plainTextBody);
           	   singleEmailMessage.setSubject(this.subject);
           }

           return this; 
       }
       
       
       public boolean sendEmailWithResult(){

			boolean result = false; 
       		if (abortEmail() ) {
       			AppLogModel.LogError('AppearEmailBase::sendEmail', 
       				'Abort - toAddress is NULL - cannot send email. Subject = '+subject,
       				pub.id);
       			AppLogModel.flushLogs();
       			return false;
       		}
       	
          	try {
				//call build first to create the email message object
				build();
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singleEmailMessage });
      	
      			if ( pub <> null) {
	      			AppLogModel.LogInfo(emailName,  'Sent for pub : ['+pub.name+ + '] to '+toAddresses+' cc '+ ccAddresses, pub.id);
	      			AppLogModel.LogDebug(emailName, 'Subject ['+subject+']', pub.id);
	      			AppLogModel.LogDebug(emailName, 'HtmlBody ['+htmlBody+']', pub.id);
      			} else if ( targetObjectId != null) {
	      			AppLogModel.LogDebug('AppearEmailBase:SendEmail',  'Sent to:'+toAddresses+' cc: '+ ccAddresses + 'targetObject : ' + targetObjectId  );      				
      			}
      			result = true;
			} catch (Exception ex) {
				if ( pub <> null) {
					string errMag = 'Exception raised during sendEmail []'+emailName+'] for pub : ['+pub.name+ + '] error = '+ ex.getMessage() +' to '+toAddresses+' cc '+ ccAddresses ;
					AppLogModel.LogError('AppearEmailBase', errMag, pub.id);
				} else {
					throw new AppearException('AppearEmailBase encountered exception - ' + ex.getMessage(), '');
				}
				result = false; 
			} finally {
				AppLogModel.flushLogs();
			}
			return result; 
       	
       }
       
       //Appear Enhancement R2, to store the emails getHtmlMailBody,getSubject,getCCAddresses are implemented
       public String getHtmlMailBody(){
           return singleEmailMessage.HTMLBody;
       }
             
       public String getSubject(){
       		return singleEmailMessage.subject;
       }
       
       public List<String>  getCCAddresses(){
       		return singleEmailMessage.ccAddresses;
       }
       
       //send the email message
       public void sendEmail() {
			Boolean result = sendEmailWithResult(); 
       }    
       
	   public boolean abortEmail() {
		   	integer toAddressCount = 0;
		   	if ( toAddresses <> null ) {
		   		toAddressCount = toAddresses.size();
		   	}
		   	
		   	integer ccAddressCount = 0;
		   	if ( ccAddresses <> null ) {
		   		ccAddressCount = ccAddresses.size();
		   	}
		   	
		   	integer bccAddressCount = 0;
		   	if ( bccAddresses <> null ) {
		   		bccAddressCount = bccAddresses.size();
		   	}
		   	
		   	integer totalAddressCount = toAddressCount + ccAddressCount + bccAddressCount;
		   	if ( totalAddressCount == 0) {
		   		return true; //abort email due to no address
		   	}
		   	
		   	//we can add other conditions here such as check for blank subject line etc.
		   	
		   	return false;
	   }
           
   }