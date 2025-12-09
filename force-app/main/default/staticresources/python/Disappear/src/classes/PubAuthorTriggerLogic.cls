public without sharing class PubAuthorTriggerLogic {
	
	public final static string strAuthorCountry = 'United States';
	
	//new version that works with a formula field in publication Author
	//this version bulkify better.
	//only 2 SOQL + 1 DML regardless of # of pub Authors or pub involved
	public static void PubAuthorTriggerInsertOrDeleteLogic(List<PubAuthor__c> newList) {
		if ( newList == null || newList.size() == 0) {
			return;
		}
		
		//Sesha: This condition has been put in place to run the update ONLY during addition/updated/deletion of an Author
		//on a Publication. You need not run this every time there is an Author related workflow action for the collaboration 
		if (!AppearTriggerActivationModel.shouldSkipUsAuthorUpdate)
		{
			//create a unique set of Publication Id from Input 
			set<Id> pubIdSet = new set<Id>();
			Map<id,boolean> pubUsBasedAuthorMap = new Map<id,boolean>();
			for ( PubAuthor__c pubAuthor : newList){
				pubIdSet.add(pubAuthor.Publication__c);
				pubUsBasedAuthorMap.put(pubAuthor.Publication__c, false);  //default all to false
			}
			
			//retrieve all pubAuthors to check AuthorCountry
			List<PubAuthor__c> pubAuthors = [
				select id, AuthorCountry__c, Publication__c
				from PubAuthor__c
				where Publication__c in :pubIdSet
                and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
			];
	
			for(PubAuthor__c pubAuthor : pubAuthors) {
				if ( pubAuthor.AuthorCountry__c == strAuthorCountry) {
					pubUsBasedAuthorMap.put(pubAuthor.Publication__c, true);
				} 
			}
			
			//finally retrieve the set of pub to update
			List<publication__c> pubList = [
				Select id, HasUSAuthors__c, name
				FROM Publication__c 
				WHERE id in :pubIdSet
			];
		
			for ( publication__c pub : pubList) {
				if (pubUsBasedAuthorMap.get(pub.id)) {
					pub.HasUSAuthors__c = true;
					AppLogModel.LogDebug('PubAuthorTriggerLogic::US Author', pub.name + ' has US Based Author', pub.Id);
				} else {
					pub.HasUSAuthors__c = false;
					AppLogModel.LogDebug('PubAuthorTriggerLogic::US Author', pub.name + ' Does not have US Based Author', pub.Id);
				}
				
			}
			
			update pubList;
		}
		
		//Code to start creating a snaphot for the Publication Authors
		Publication__c tempPub = AppearPubModelShare.getPublicationSCandFC(newList[0].publication__c); 
        createSnapshotForPubAuthor(tempPub, newList);
		//Code to start creating a snaphot for the Publication Authors
		
		AppLogModel.flushLogs();
				
	}
	
	public static void PubProjectStudyUpdate(List<PubStudy__c> newList,List<Publication__c> Pubs) {
		if ( newList == null || newList.size() == 0) {
			return;
		}
		for(Publication__c Pub : Pubs){
		
			If (pub.SponsoringDept__c!=null){
			 	pub.SponsorDept_Pick__c = pub.SponsoringDept__r.Name;
		 	}
			If(pub.SponsoringOrg__c!=null) {
				pub.SponsorOrg_Pick__c = pub.SponsoringOrg__r.Name;
			}
			set<String> studyids = new set <String>();
			for(PubStudy__c pbs : newList){
				if(pbs.Publication__c == pub.Id){
            		studyids.add(pbs.Study__r.Name);
        		}
			}
			String Projectstudystring='';
			if(studyIds.size()>0){
				for(String st: studyids){
	        		Projectstudystring  = (Projectstudystring <> '') ?  Projectstudystring + ', ':'';
					Projectstudystring = Projectstudystring + st;
	        	} 
			}
			pub.Project_Ids__c = Projectstudystring;
		} 
        if(pubs.size()>0){
        	update Pubs;
        }
	}
	
	public static void createSnapshotForPubAuthor(Publication__c currentPub, List<PubAuthor__c> authorList) {
		Id submissionCycleId = currentPub.Current_SubmissionCycle_Id_Formula__c;
		Id fprCycleId = currentPub.Current_FPRCycle_Id_Formula__c;
		Id pubId = currentPub.Id;
		
		List<Snapshot_Pub_Author__c> authorSnapshotToInsert = new List<Snapshot_Pub_Author__c>();
		for(PubAuthor__c pubAuthorObj : authorList) {
			Snapshot_Pub_Author__c authorSnapshotRec = new Snapshot_Pub_Author__c();
			authorSnapshotRec.Additional_Details_For_Approval__c = pubAuthorObj.Additional_Details_For_Approval__c; // Appear Enhancement Backlog R3 - Comment and Uncomment for Data Type change in Snapshot Object
			authorSnapshotRec.Additional_Details_For_Invite__c = pubAuthorObj.Additional_Details__c;  // Appear Enhancement Backlog R3 - Comment and Uncomment for Data Type change in Snapshot Object
			authorSnapshotRec.Approval_Accepted_Date__c = pubAuthorObj.ApprovalAcceptedDate__c;
			authorSnapshotRec.Approval_Disclaimer_ID__c = pubAuthorObj.Approval_Disclaimer_ID__c;
			authorSnapshotRec.Approval_Rejected_Date__c = pubAuthorObj.Approval_Rejected_Date__c;
			authorSnapshotRec.Approval_Sent_Date__c = pubAuthorObj.ApprovalSentDate__c;
			authorSnapshotRec.Author_Status__c = pubAuthorObj.AuthorStatus__c;
			authorSnapshotRec.FPR_Cycle__c = fprCycleId;
			authorSnapshotRec.Invite_Accepted_Date__c = pubAuthorObj.InviteAcceptedDate__c;
			authorSnapshotRec.Invite_Disclaimer_ID__c = pubAuthorObj.Disclaimer_ID__c;
			authorSnapshotRec.Invite_Sent_Date__c = pubAuthorObj.InviteSentDate__c;
			authorSnapshotRec.Justification_for_Approval__c = pubAuthorObj.Justification_for_Approval__c;
			authorSnapshotRec.Justification_for_Invite__c = pubAuthorObj.Justification_for_Invite__c;
			authorSnapshotRec.On_behalf_of_for_Approval__c = pubAuthorObj.On_behalf_of_for_Approval__c;
			authorSnapshotRec.On_behalf_of_for_Invite__c = pubAuthorObj.On_behalf_of_for_Invite__c;
			authorSnapshotRec.Publication_Author__c = pubAuthorObj.Id;
			authorSnapshotRec.Rationale__c = pubAuthorObj.Rationale__c;
			authorSnapshotRec.Reason_to_Decline_Approval__c = pubAuthorObj.ReasonToDeclineApproval__c;
			authorSnapshotRec.Submission_Cycle__c = submissionCycleId;
			authorSnapshotRec.isLogicallyDeleted__c = pubAuthorObj.isLogicallyDeleted__c;//Appear Enhancement R3 : snapshot of Remove Author field
			authorSnapshotRec.Additional_Details_For_Draft_Share__c = pubAuthorObj.Additional_Details_For_Draft_Share__c;//Appear Enhancement R3 : snapshot of	Additional Details (For Draft Share) field
			authorSnapshotRec.Draft_Share_Date__c = pubAuthorObj.DraftShareDate__c;//Appear Enhancement R3 : snapshot of Draft Share Date field
			authorSnapshotRec.Please_respond_by_For_Draft_Share__c = pubAuthorObj.Please_respond_by_For_Draft_Share__c;//Appear Enhancement R3 : snapshot of Please respond by (For Draft Share) field
            authorSnapshotRec.CommentReceivedDate__c = pubAuthorObj.CommentReceivedDate__c;//Appear Enhancement R3 : snapshot of comment received date.
			authorSnapshotRec.Invite_Rejected_Date__c = pubAuthorObj.Invite_Rejected_Date__c;//Appear Enhancement 2017 Backlog R3 : Invitation Decline
            authorSnapshotToInsert.add(authorSnapshotRec);
		}
		
		if (authorSnapshotToInsert.size() > 0) {
			database.insert(authorSnapshotToInsert, false);
		}
	}
	
	/*
	public static void PubAuthorTriggerInsertOrDeleteLogicV1(List<PubAuthor__c> newList) {
		if ( newList == null || newList.size() == 0) {
			return;
		}
		
		//for multiple authors - dedup and get a unique set of Pub Ids
		Set<id> pubIdsToCheckSet = new Set<Id>();
		for (PubAuthor__c newAuthor : newList) {			
			if (!pubIdsToCheckSet.contains( newAuthor.Publication__c )) {
				pubIdsToCheckSet.add(newAuthor.Publication__c);
			}
		}
		
		
		List<Publication__c> pubsToUpdate = new List<Publication__c>();
		for (Publication__c pubToCheck : [ Select id, HasUSAuthors__c FROM Publication__c WHERE id in :pubIdsToCheckSet]) {
			
			Set<id> contactIdsToRetrieve = new Set<id>();
			List<PubAuthor__c> pubAuthors = PubAuthorModel.getPubAuthors(pubToCheck.Id);
			for(PubAuthor__c pubAuthor : pubAuthors) {
				if (!contactIdsToRetrieve.contains(pubAuthor.Author__c)) {
					contactIdsToRetrieve.add(pubAuthor.Author__c);
				}
			}
			
			integer numOfUSAuthors = [Select count() FROM Contact WHERE Country__c = 'United States' AND id in :contactIdsToRetrieve];
			boolean previousHasAuthors = pubToCheck.HasUSAuthors__c;
			boolean newHasAuthors = numOfUSAuthors > 0;
			if (previousHasAuthors != newHasAuthors) {
				pubToCheck.HasUSAuthors__c = newHasAuthors;
				pubsToUpdate.add(pubToCheck);
			}
		}
		
		if (pubsToUpdate.size() > 0) {
			update pubsToUpdate;
		}
	}
	*/
}