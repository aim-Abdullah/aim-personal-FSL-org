public class Email_14_ChangeReviewerTypeOrNewPrimary extends AppearEmailBase {


	public Email_14_ChangeReviewerTypeOrNewPrimary( List<Id> toAddressIds, List<Id> ccAddressIds, Id reviewTeamMemberCycleId, publication__c pub) {
		super(pub,'Email_11_IndividCourtesyFprRevCommented');

		PubReviewTeam__c reviewTeamMemberCycle = PubReviewTeamNoSharingModel.loadPubReviewTeamRecord(reviewTeamMemberCycleId);
		
		if ( pub.Primary__c == null) {
			if ( pub.Product_Indication__c.contains(';'))  {
				pub.Primary__c = pub.Product_Indication__c.split(';',0)[0];
			} else {
				pub.Primary__c = pub.Product_Indication__c;
			}
		}
		
		subject('FPR '+ reviewTeamMemberCycle.publication__r.name +', Due: ' + 
			pub.fpr_Due_Date__c.format() + ', ' + pub.Primary__c + ', ' + pub.Publication_Type__c +' has been assigned to you for review.');
		ToAddresses(toAddressIds);
		CCAddresses(ccAddressIds);
		
		String htmlBodyStr =
			'Do not reply to this email message.<br><br>' +
			'FPR ' + reviewTeamMemberCycle.publication__r.name + 
			', titled ' + pub.Publication_Title__c +', with a current target of ' + pub.Current_Target__c +', has been assigned to you for review by ' +
			pub.fpr_Due_Date__c.format() + '. It is your responsibility to uphold this assignment. ' +
			'If you are unavailable and cannot meet this deadline, contact the FPR Coordinator, ' + pub.Assigned_FPRC__r.name + ', to arrange delegation in your place. <br><br>' +
			'Note: If additional Reviewers are needed, triage this assignment BEFORE voting. All new Reviewers must be trained on the FPR System. <br><br>' +
	        '<B>Reviewers</B>: Access the FPR record using this link <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/apex/AppearFpr?Id=' + Pub.id +'&param=blah'+'">'+Pub.Name+'</a><br>' +
			'<B>Submitters</B>: View the status of the FPR record using your bookmarked system URL or through the system launch button from the <a href="' + AppearUrlModel.GetSimpleFprPortalPath() + '" target="_blank">FPR Site</a>.<br><br>' +
			'FPR Submitter and Notify Reviewers, this notification has been emailed to you for notification purposes only. No action is required from you.<br><br>' +
			'Thank you,<br>' +
			'FPR System<br>';

		htmlBody(htmlBodyStr);
		plainTextBody(htmlBodyStr.replace('<br>', '\\r\\n'));
	}


	//Email_14_ChangeReviewerTypeOrNewPrimary.testEmail();
	public static void testEmail() {
		AppearPubModel activePub = EmailPubReviewTeam.testPub;
		List<Id> ToAddressIds = new List<Id>();
		ToAddressIds.add(activePub.pubRecord.Assigned_FPRC__c);
		ToAddressIds.add(activePub.pubRecord.FPR_Submitter__c);

		Email_14_ChangeReviewerTypeOrNewPrimary email = new Email_14_ChangeReviewerTypeOrNewPrimary(
			ToAddressIds, ToAddressIds, activePub.PubReviewTeam.NewPubReviewTeamMembers.Id, activePub.pubRecord);
		email.sendEmail();

	}
}