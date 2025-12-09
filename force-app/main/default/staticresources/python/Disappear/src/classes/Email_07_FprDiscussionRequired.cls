public class Email_07_FprDiscussionRequired extends AppearEmailBase {


	public Email_07_FprDiscussionRequired( List<Id> toAddressIds, List<Id> ccAddressIds, Id reviewTeamMemberCycleId, publication__c pub) {
		super(pub,'Email_07_FprDiscussionRequired');

		PubReviewTeam__c reviewTeamMemberCycle = PubReviewTeamNoSharingModel.loadPubReviewTeamRecord(reviewTeamMemberCycleId);
		
		if ( pub.Primary__c == null) {
			if ( pub.Product_Indication__c.contains(';'))  {
				pub.Primary__c = pub.Product_Indication__c.split(';',0)[0];
			} else {
				pub.Primary__c = pub.Product_Indication__c;
			}
		}
		
		subject('IMPORTANT: FPR '+ pub.Name +', Due: '+
			pub.fpr_Due_Date__c.format() + ', '+ pub.Primary__c +', '+pub.Publication_Type__c+'  Requires Discussion');
		ToAddresses(toAddressIds);
		CCAddresses(ccAddressIds);

		String htmlBodyStr =
			'Do not reply to this email message.<br><br>' +
			'FPR '+ pub.Name + 
			', titled ' + pub.Publication_Title__c + ' requires additional discussion. ' +
			'To expedite the process, contact '+ ProxyDelegateUtility.getNameFromReviewer(reviewTeamMemberCycle) + ' to address their concerns. ' +
			'Contact the FPR Coordinator, '+reviewTeamMemberCycle.AssignedFPRCFF__c + ', if you have questions or need support. <br><br>' +
			'View the status of the FPR record using your bookmarked system URL or through the system launch button from the <a href="' + AppearUrlModel.GetSimpleFprPortalPath() + '" target="_blank">FPR Site</a>.<br><br>' +
			'Thank you,<br>' +
			'FPR System<br>';

		htmlBody(htmlBodyStr);
		plainTextBody(htmlBodyStr.replace('<br>', '\\r\\n'));
	}

	//Email_07_FprDiscussionRequired.testEmail();
	public static void testEmail() {
		AppearPubModel activePub = EmailPubReviewTeam.testPub;
		List<Id> ToAddressIds = new List<Id>(); 
		ToAddressIds.add(activePub.pubRecord.Assigned_FPRC__c);
		
		Email_07_FprDiscussionRequired email = new Email_07_FprDiscussionRequired(
			ToAddressIds, ToAddressIds, activePub.PubReviewTeam.NewPubReviewTeamMembers.Id, activePub.pubRecord);
		email.sendEmail();

	}
}