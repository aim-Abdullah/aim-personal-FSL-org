public class Email_01_FprcConfirmationForSubmitter  extends AppearEmailBase{

	
	public Email_01_FprcConfirmationForSubmitter(publication__c pub) {
		super(pub, 'Email_01_FprcConfirmationForSubmitter'); 

		subject('FPR '+pub.Name+', Due: '+pub.FPR_Due_Date__c.format() +' has been Assigned to an FPR Coordinator');

		Contact toContact = AppearContactModel.findContactByContactId(pub.FPR_SUBMITTER__C );
		Contact fprcContact = AppearContactModel.findContactByContactId(pub.Assigned_FPRC__c);
		if ( toContact == null) {
			//cannot send email with toContact == null
			AppLogModel.LogError('Email_01_FprcConfirmationForSubmitter', 'ToContact == null.  Cannot send email',pub.id);
			AppLogModel.flushLogs();
			return;
		}
		
		ToAddress(toContact.Email);
  
		string htmlBodyStr =
			'Do not reply to this email message.<br><br>' +
			'FPR '+pub.Name+' has been assigned to ' + fprcContact.Name + ' for processing.' +
			'Contact your assigned FPR Coordinator if you have questions or need support.<br><br>' +
			'Thank you,<br>' +
			'FPR System<br>'; 

		htmlBody(htmlBodyStr);
		plainTextBody(htmlBodyStr.replace('<br>', '\\r\\n'));
	}

	//Email_01_FprcConfirmationForSubmitter.testEmail()
	public static void testEmail() {
		Publication__c pub = EmailPubReviewTeam.testPub.pubRecord;
		
		Email_01_FprcConfirmationForSubmitter email = new Email_01_FprcConfirmationForSubmitter(pub);
		email.sendEmail();
	}  
	

}