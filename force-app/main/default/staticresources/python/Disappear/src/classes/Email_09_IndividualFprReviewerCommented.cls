public class Email_09_IndividualFprReviewerCommented extends AppearEmailBase {


	public Email_09_IndividualFprReviewerCommented( List<Id> toAddressIds, List<Id> ccAddressIds, Id reviewTeamMemberCycleId, publication__c pub) {
		super(pub,'Email_09_IndividualFprReviewerCommented');

		PubReviewTeam__c reviewTeamMemberCycle = PubReviewTeamNoSharingModel.loadPubReviewTeamRecord(reviewTeamMemberCycleId);
		
		if ( pub.Primary__c == null) {
			if ( pub.Product_Indication__c.contains(';'))  {
				pub.Primary__c = pub.Product_Indication__c.split(';',0)[0];
			} else {
				pub.Primary__c = pub.Product_Indication__c;
			}
		}
		
		
		subject('FPR '+reviewTeamMemberCycle.publication__r.name+', Due: ' + 
			pub.fpr_Due_Date__c.format() + ', ' + pub.Primary__c + ', ' +
			pub.Publication_Type__c + ' has been reviewed with comments by '+
			ProxyDelegateUtility.getNameFromReviewer(reviewTeamMemberCycle) + '.');
		ToAddresses(toAddressIds);
		CCAddresses(ccAddressIds);

		String htmlBodyStr =
			'Do not reply to this email message.<br><br>' +
			'FPR ' + reviewTeamMemberCycle.publication__r.name + 
			', titled ' + pub.Publication_Title__c + ' has been reviewed with comments by ' + 
			ProxyDelegateUtility.getNameFromReviewer(reviewTeamMemberCycle) + '. ' +
			'Please note, the FPR process has not completed and other reviews are still pending. ' +
			'Contact the FPR Coordinator, '+reviewTeamMemberCycle.AssignedFPRCFF__c +', if you have questions. <br><br>' +
			'View the status of the FPR record using your bookmarked system URL or through the system launch button from the <a href="' + AppearUrlModel.GetSimpleFprPortalPath() + '" target="_blank">FPR Site</a>.<br><br>' +
			'Thank you,<br>' +
			'FPR System<br>';

		htmlBody(htmlBodyStr);
		plainTextBody(htmlBodyStr.replace('<br>', '\\r\\n'));
	}


	//Email_09_IndividualFprReviewerCommented.testEmail();
	public static void testEmail() {
		AppearPubModel activePub = EmailPubReviewTeam.testPub;
		List<Id> ToAddressIds = new List<Id>();
		ToAddressIds.add(activePub.pubRecord.Assigned_FPRC__c);
		ToAddressIds.add(activePub.pubRecord.FPR_Submitter__c);

		Email_09_IndividualFprReviewerCommented email = new Email_09_IndividualFprReviewerCommented(
			ToAddressIds, ToAddressIds, activePub.PubReviewTeam.NewPubReviewTeamMembers.Id, activePub.pubRecord);
		email.sendEmail();

	}
}