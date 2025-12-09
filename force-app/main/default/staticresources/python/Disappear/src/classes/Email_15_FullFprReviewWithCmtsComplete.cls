public class Email_15_FullFprReviewWithCmtsComplete extends AppearEmailBase {

	public Email_15_FullFprReviewWithCmtsComplete( List<Id> toAddressIds, List<Id> ccAddressIds, Id reviewTeamMemberCycleId, publication__c pub) {
		super(pub,'Email_15_FullFprReviewWithCmtsComplete');

		PubReviewTeam__c reviewTeamMemberCycle = PubReviewTeamNoSharingModel.loadPubReviewTeamRecord(reviewTeamMemberCycleId);
		if ( reviewTeamMemberCycle == null || reviewTeamMemberCycle.publication__c == null) {
			return;
		}
		if ( pub == null || pub.fpr_Due_Date__c == null) {
			return;
		}
		
		if ( pub.Primary__c == null) {
			if ( pub.Product_Indication__c.contains(';'))  {
				pub.Primary__c = pub.Product_Indication__c.split(';',0)[0];
			} else {
				pub.Primary__c = pub.Product_Indication__c;
			}
		}
	
		subject('FPR '+ pub.name +', Due: ' + 
			pub.fpr_Due_Date__c.format() + ', ' + pub.Primary__c + ', ' +
			pub.Publication_Type__c + ' has been reviewed with comments and is now complete. ');
			
		ToAddresses(toAddressIds);
		CCAddresses(ccAddressIds);

		String htmlBodyStr =
			'Do not reply to this email message.<br><br>' +
			'FPR ' + reviewTeamMemberCycle.publication__r.name + 
			', titled ' + pub.Publication_Title__c + ', has been reviewed with comments and is now complete. Reviewer comments should be ' +
			'addressed prior to external submission or presentation and can be accessed using the link below. ' +
			'Contact the FPR Coordinator, ' + reviewTeamMemberCycle.AssignedFPRCFF__c + ', if you have any questions. <br><br>' +
			'View the status of the FPR record using your bookmarked system URL or through the system launch button from the <a href="' + AppearUrlModel.GetSimpleFprPortalPath() + '" target="_blank">FPR Site</a>.<br><br>' +
			'LEGAL AND COMPLIANCE DISCLAIMER: If an electronic copy of the publication is submitted to external Reviewers or meeting/journal, please ensure the following: <br>' +
			'<ul><li>There are no embedded data (links to data or confidential information). Pay special attention to tables and/or figures generated from underlying Excel spreadsheets that may contain Amgen Confidential Information. </li>' +
			'<li>Remove proprietary information that may appear in the Speaker Notes of oral presentations. </li>' +
			'<li>Set the security on all documents. Note that PDFs are editable unless secured. </li>' +
			'<li>Be aware that Amgen may not wish to disclose AMG numbers for early-phase products. </li>' +
			'<li>Remove "Amgen Confidential" from versions of documents to be publicly disseminated. </li></ul>' +
			'Please note that the FPR process does not fulfill the Amgen requirement for Final Review by All Authors. Refer to the Amgen Publications SOP (014321-7.0) for policy and standard practices across all groups that collaborate with outside Authors.<br><br>' +
			'Thank you,<br>' +
			'FPR System<br>';

		htmlBody(htmlBodyStr);
		plainTextBody(htmlBodyStr.replace('<br>', '\\r\\n').replace('<ul>','-').remove('</ul>').replace('<li>',' --').remove('</li>'));
	}


	//Email_15_FullFprReviewWithCmtsComplete.testEmail();
	public static void testEmail() {
		AppearPubModel activePub = EmailPubReviewTeam.testPub;
		List<Id> ToAddressIds = new List<Id>();
		ToAddressIds.add(activePub.pubRecord.Assigned_FPRC__c);
		ToAddressIds.add(activePub.pubRecord.FPR_Submitter__c);

		Email_15_FullFprReviewWithCmtsComplete email = new Email_15_FullFprReviewWithCmtsComplete(
			ToAddressIds, ToAddressIds, activePub.PubReviewTeam.NewPubReviewTeamMembers.Id, activePub.pubRecord);
		email.sendEmail();

	}
}