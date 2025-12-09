public class Email_06_PubWithdrawn extends AppearEmailBase {


	public Email_06_PubWithdrawn( List<Id> toAddressIds, List<Id> ccAddressIds, publication__c pub) {
		super(pub,'Email_06_PubWithdrawn');

		//PubReviewTeam__c reviewTeamMemberCycle = PubReviewTeamModel.loadPubReviewTeamRecord(reviewTeamMemberCycleId);
		
		if ( pub.Primary__c == null) {
			if ( pub.Product_Indication__c.contains(';'))  {
				pub.Primary__c = pub.Product_Indication__c.split(';',0)[0];
			} else {
				pub.Primary__c = pub.Product_Indication__c;
			}
		}
		
		subject('IMPORTANT: FPR '+ pub.name +', Due: ' +
			pub.fpr_Due_Date__c.format() + ', ' + pub.Primary__c + ', ' + pub.Publication_Type__c +' has been withdrawn.');
		ToAddresses(toAddressIds);
		CCAddresses(ccAddressIds);
		
		String htmlBodyStr =
			'Do not reply to this email message.<br><br>' +

			'FPR ' + pub.name + 
			', titled ' + pub.Publication_Title__c + ', has been withdrawn and no further action is required. Contact the FPR Coordinator, ' +
			pub.Assigned_FPRC__r.name + ', if you have any questions. <br><br>' +
			'<B>Submitters</B>: View the status of the FPR record using your bookmarked system URL or through the system launch button from the <a href="' + AppearUrlModel.GetSimpleFprPortalPath() + '" target="_blank">FPR Site</a>.<br><br>' +
			'Thank you,<br>' +
			'FPR System<br>';

		htmlBody(htmlBodyStr);
		plainTextBody(htmlBodyStr.replace('<br>', '\\r\\n'));
	}


	//Email_06_PubWithdrawn.testEmail();
	public static void testEmail() {
		AppearPubModel activePub = EmailPubReviewTeam.testPub;
		List<Id> ToAddressIds = new List<Id>();
		ToAddressIds.add(activePub.pubRecord.Assigned_FPRC__c);
		ToAddressIds.add(activePub.pubRecord.FPR_Submitter__c);

		Email_06_PubWithdrawn email = new Email_06_PubWithdrawn(
			ToAddressIds, ToAddressIds, activePub.pubRecord);
		email.sendEmail();

	}
}