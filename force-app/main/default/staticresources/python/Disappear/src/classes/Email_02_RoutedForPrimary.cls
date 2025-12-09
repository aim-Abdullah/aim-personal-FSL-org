public class Email_02_RoutedForPrimary extends AppearEmailBase {

	public Email_02_RoutedForPrimary( List<Id> toAddressIds, List<Id> ccAddressIds, PubReviewTeam__c primaryReviewer,  publication__c pub) {
		super(pub,'Email_02_RoutedForPrimary');
				
		if (primaryReviewer == null ) {
       			string errMsg = 'Exception : Instantiating Email_02_RoutedForPrimary with primaryReviewer = null for '+ emailName;
       			AppLogModel.LogError('Email_02_RoutedForPrimary', errMsg);
       			AppLogModel.flushLogs();
       			AppearException ex = new AppearException(errMsg, '');
       			throw ex;			
		}
		
		subject('FPR '+ pub.name +', Due: ' + 
			pub.fpr_Due_Date__c.format() + ', ' + pub.Primary__c + ', ' + pub.Publication_Type__c +' has been assigned to you for review.');
		ToAddresses(toAddressIds);
		CCAddresses(ccAddressIds);
		
		String htmlBodyStr =
			'Do not reply to this email message.<br><br>' +
			'FPR ' + pub.name + ', titled ' + pub.Publication_Title__c +
			', with a current target of ' + pub.Current_Target__c +', has been assigned to you for review by ' +
			pub.fpr_Due_Date__c.format() + '. It is your responsibility to uphold this assignment. ' +
			'If you are unavailable and cannot meet this deadline, contact the FPR Coordinator, ' + pub.Assigned_FPRC__r.name + 
			', to arrange delegation in your place. <br><br>' +
			'Note: If additional Reviewers are needed, triage this assignment BEFORE voting. All new Reviewers must be trained on the FPR System. <br><br>' +
			'<B>Reviewers</B>: Access the FPR record using this link <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/apex/AppearFpr?Id=' + Pub.id +'&param=blah'+'">'+Pub.Name+'</a><br>' +
			'<B>Submitters</B>: View the status of the FPR record using your bookmarked system URL or through the system launch button from the <a href="' + AppearUrlModel.GetSimpleFprPortalPath() + '" target="_blank">FPR Site</a>.<br><br>' +
			'FPR Submitter and Notify Reviewers, this notification has been emailed to you for notification purposes only. No action is required from you.<br><br>' +
			'Thank you,<br>' +
			'FPR System<br>';


		htmlBody(htmlBodyStr);
		plainTextBody(htmlBodyStr.replace('<br>', '\\r\\n'));
		
		AppLogModel.LogInfo('Email_02_RoutedForPrimary', 'Created Email_02_RoutedForPrimary for Pub : '+pub.name+' to: '+toAddresses+'; cc: '+ ccAddresses, pub.id);
		AppLogModel.LogInfo('Email_02_RoutedForPrimary', 
			'Created Email_02_RoutedForPrimary for pub : '+pub.name+' to: '+toAddressIds+'; cc: '+ ccAddressIds + ' reviewTeamMbereCycleId '+primaryReviewer.Id, pub.id);
		AppLogModel.flushLogs();
		
	}
	public Email_02_RoutedForPrimary( List<Id> toAddressIds, List<Id> ccAddressIds, Id reviewTeamMemberCycleId,  publication__c pub) {
		super(pub,'Email_02_RoutedForPrimary');
	}


	//Email_02_RoutedForPrimary.testEmail();
	
	public static void testEmail() {
		AppearPubModel activePub = EmailPubReviewTeam.testPub;
		List<Id> ToAddressIds = new List<Id>();
		ToAddressIds.add(activePub.pubRecord.Assigned_FPRC__c);
		ToAddressIds.add(activePub.pubRecord.FPR_Submitter__c);

		Email_02_RoutedForPrimary email = new Email_02_RoutedForPrimary(
			ToAddressIds, ToAddressIds, activePub.PubReviewTeam.NewPubReviewTeamMembers, activePub.pubRecord);
		email.sendEmail();
		AppLogModel.flushLogs();
	}
	
}