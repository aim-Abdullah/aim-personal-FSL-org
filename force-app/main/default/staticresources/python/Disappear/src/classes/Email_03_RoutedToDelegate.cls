public class Email_03_RoutedToDelegate extends AppearEmailBase {


	public Email_03_RoutedToDelegate( List<Id> toAddressIds, List<Id> ccAddressIds, String delegatedFromName,  
		PubReviewTeam__c reviewTeamMemberCycle, publication__c pub) {
		super(pub,'Email_03_RoutedToDelegate');
		 
		subject('FPR '+ pub.name +', Due: ' + 
			pub.fpr_Due_Date__c.format() + ', ' + pub.Primary__c + ', ' + pub.Publication_Type__c +' has been delegated to you for review.');
		ToAddresses(toAddressIds);
		CCAddresses(ccAddressIds);

		String htmlBodyStr =
			'Do not reply to this email message.<br><br>' +
			delegatedFromName + ' has delegated FPR ' + pub.name + 
			', titled ' + pub.Publication_Title__c + 
			', with a current target of ' + pub.Current_Target__c + ', ' +
			'to you for review by ' + pub.fpr_Due_Date__c.format() + '. The delegation justification is: '+ reviewTeamMemberCycle.Delegation_Justification__c +  '.<br><br>'+
			'Note: If additional Reviewers are needed, triage this assignment BEFORE voting. All new Reviewers must be trained on the FPR System. ' +
			'Contact your assigned FPR Coordinator, ' + pub.Assigned_FPRC__r.name + 
			', if you have any questions. <br><br>' + 
			'<B>Reviewers</B>: Access the FPR record using this link <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/apex/AppearFpr?Id=' + Pub.id +'&param=blah'+'">'+Pub.Name+'</a><br>' +
			'<B>Submitters</B>: View the status of the FPR record using your bookmarked system URL or through the system launch button from the <a href="' + AppearUrlModel.GetSimpleFprPortalPath() + '" target="_blank">FPR Site</a>.<br><br>' +
			'FPR Submitter, this notification has been emailed to you for notification purposes only. No action is required from you. <br><br>' +
			'Thank you,<br>' +
			'FPR System<br>';

		htmlBody(htmlBodyStr);
		plainTextBody(htmlBodyStr.replace('<br>', '\\r\\n'));
		
		AppLogModel.LogInfo('Email_03_RoutedToDelegate', 'Created Email_03_RoutedToDelegate for pub : '+pub.name+' to '+toAddresses+' cc '+ ccAddresses, pub.id);
		AppLogModel.flushLogs();
	}
	public Email_03_RoutedToDelegate( List<Id> toAddressIds, List<Id> ccAddressIds, String delegatedFromName,  
		Id reviewTeamMemberCycleId, publication__c pub) {
		super(pub,'Email_03_RoutedToDelegate');
	
		PubReviewTeam__c reviewTeamMemberCycle = PubReviewTeamNoSharingModel.loadPubReviewTeamRecord(reviewTeamMemberCycleId);  
		if ( pub.Primary__c == null) {
			if ( pub.Product_Indication__c.contains(';'))  {
				pub.Primary__c = pub.Product_Indication__c.split(';',0)[0];
			} else {
				pub.Primary__c = pub.Product_Indication__c;
			}
		}
		 
		subject('FPR '+ reviewTeamMemberCycle.publication__r.name +', Due: ' + 
			pub.fpr_Due_Date__c.format() + ', ' + pub.Primary__c + ', ' + pub.Publication_Type__c +' has been delegated to you for review.');
		ToAddresses(toAddressIds);
		CCAddresses(ccAddressIds);

		String htmlBodyStr =
			'Do not reply to this email message.<br><br>' +
			delegatedFromName + ' has delegated FPR ' + reviewTeamMemberCycle.publication__r.name + 
			', titled ' + pub.Publication_Title__c + 
			', with a current target of ' + pub.Current_Target__c + ', ' +
			'to you for review by ' + pub.fpr_Due_Date__c.format() + '. The delegation justification is: '+ reviewTeamMemberCycle.Delegation_Justification__c +  '.<br><br>'+
			'Note: If additional Reviewers are needed, triage this assignment BEFORE voting. All new Reviewers must be trained on the FPR System. ' +
			'Contact your assigned FPR Coordinator, ' + pub.Assigned_FPRC__r.name + 
			', if you have any questions. <br><br>' + 
			'<B>Reviewers</B>: Access the FPR record using this link <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/apex/AppearFpr?Id=' + Pub.id +'&param=blah'+'">'+Pub.Name+'</a><br>' +
			'<B>Submitters</B>: View the status of the FPR record using your bookmarked system URL or through the system launch button from the <a href="' + AppearUrlModel.GetSimpleFprPortalPath() + '" target="_blank">FPR Site</a>.<br><br>' +
			'FPR Submitter, this notification has been emailed to you for notification purposes only. No action is required from you. <br><br>' +
			'Thank you,<br>' +
			'FPR System<br>';

		htmlBody(htmlBodyStr);
		plainTextBody(htmlBodyStr.replace('<br>', '\\r\\n'));
		
		AppLogModel.LogInfo('Email_03_RoutedToDelegate', 'Created Email_03_RoutedToDelegate for pub : '+pub.name+' to '+toAddresses+' cc '+ ccAddresses, pub.id);
		AppLogModel.flushLogs();
	}

  
	//Email_03_RoutedToDelegate.testEmail();
	
	public static void testEmail() {
		AppearPubModel activePub = EmailPubReviewTeam.testPub;
		List<Id> ToAddressIds = new List<Id>();
		ToAddressIds.add(activePub.pubRecord.Assigned_FPRC__c);
		ToAddressIds.add(activePub.pubRecord.FPR_Submitter__c);

		Email_03_RoutedToDelegate email = new Email_03_RoutedToDelegate(
			ToAddressIds, ToAddressIds, activePub.pubRecord.Assigned_FPRC__c,
				activePub.PubReviewTeam.NewPubReviewTeamMembers.Id, activePub.pubRecord);
		email.sendEmail();

	}
	
	
}