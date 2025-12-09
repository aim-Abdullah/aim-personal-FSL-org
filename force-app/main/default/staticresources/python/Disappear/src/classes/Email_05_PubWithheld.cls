public class Email_05_PubWithheld extends AppearEmailBase {


	public Email_05_PubWithheld( List<Id> toAddressIds, List<Id> ccAddressIds, Id withHeldReviewTeamMemberCycleId, publication__c pub) {
		super(pub,'Email_05_PubWithheld');

		PubReviewTeam__c reviewTeamMemberCycle = PubReviewTeamNoSharingModel.loadPubReviewTeamRecord(withHeldReviewTeamMemberCycleId);
		
		if ( pub.Primary__c == null) {
			if ( pub.Product_Indication__c.contains(';'))  {
				pub.Primary__c = pub.Product_Indication__c.split(';',0)[0];
			} else {
				pub.Primary__c = pub.Product_Indication__c;
			}
		}
		
		if ( reviewTeamMemberCycle == null) {
			return;
		}
		
		subject('IMPORTANT: FPR '+ reviewTeamMemberCycle.publication__r.name +', Due: ' + 
			pub.fpr_Due_Date__c.format() + ', ' + pub.Primary__c + ', ' + pub.Publication_Type__c +' has been withheld.');
		ToAddresses(toAddressIds);
		CCAddresses(ccAddressIds);

		String htmlBodyStr =
			'Do not reply to this email message.<br><br>' +
			//'Dear ' + pub.FPR_Submitter__r.name + ', <br><br>' +
			'FPR ' + reviewTeamMemberCycle.publication__r.name + 
			', titled ' + pub.Publication_Title__c + 
			', has been withheld by ' + ProxyDelegateUtility.getNameFromReviewer(reviewTeamMemberCycle) + '. ' +
			'To expedite the process, contact the withholding Reviewer directly to address their concerns. ' +
			'The updated version will need to be submitted to FPR for a subsequent review cycle. Contact your assigned FPR Coordinator, ' +
			pub.Assigned_FPRC__r.name +' , if you have any questions.<br><br>' +
			'<B>Submitters</B>: View the status of the FPR record using your bookmarked system URL or through the system launch button from the <a href="' + AppearUrlModel.GetSimpleFprPortalPath() + '" target="_blank">FPR Site</a>.<br><br>' +
			'Thank you,<br>' +
			'FPR System<br>';

		htmlBody(htmlBodyStr);
		plainTextBody(htmlBodyStr.replace('<br>', '\\r\\n'));
	}


	//Email_05_PubWithheld.testEmail();
	public static void testEmail() {
		AppearPubModel activePub = EmailPubReviewTeam.testPub;
		List<Id> ToAddressIds = new List<Id>();
		ToAddressIds.add(activePub.pubRecord.Assigned_FPRC__c);
		ToAddressIds.add(activePub.pubRecord.FPR_Submitter__c);

		Email_05_PubWithheld email = new Email_05_PubWithheld(
			ToAddressIds, ToAddressIds, activePub.PubReviewTeam.NewPubReviewTeamMembers.Id, activePub.pubRecord);
		email.sendEmail();

	}
}