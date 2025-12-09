global without sharing class withoutSharingUtil {


	global static void DelRecords(List<sObject> objects, boolean AllOrNothing) {
		database.delete(objects,AllOrNothing);
	}
	
	global static void MoveToGpp(Publication__c pub) {
		pub.isPlanning__c = true;		
		update pub;
	}
	
	global static void RemoveFromGPP(Publication__c pub) {
		pub.isPlanning__c = false;		
		update pub;
	}
	
	global static void UpdatePub(Publication__c pub) {		
		update pub;
	}
	
	global static void ChangeOwnershipToTemporaryPoolUser(Publication__c pub, boolean updatePubRecord) {
		User temporaryPoolUser;
		string userName = KeyValueSettingsModel.getValue('TemporaryPubOwner'); //Cannot user getKey because userName needs to be unique between login.salesforce.com or test.salesforce.com
		
		List<User> userList = [select id, name from User where Username = :userName and IsActive = true];
		if (userList.size() == 0) {
			AppLogModel.LogError('UserModel::GetTemporaryPoolUser', 
			'No active user found with Username = "'+ userName +'"');
		} else {
			temporaryPoolUser = userList[0];
		}

        if (temporaryPoolUser == null) {
            AppLogModel.LogError('withoutSharingUtil::ChangeOwnershipToTemporaryPoolUser', 'Cannot find Temporary Pool User. Aborting', pub.Id);
            AppLogModel.flushLogs();
            return;
        }
        pub.OwnerId = temporaryPoolUser.Id;
        
        if (updatePubRecord ) {
            update pub;
        }
        AppLogModel.LogInfo('withoutSharingUtil::ChangeOwnershipToTemporaryPoolUser', 
            'Changed ownership for Pub['+pub.Publication_Title__c +'] to user ' + temporaryPoolUser.Name, pub.Id);  
	}
	
	global static void InsertReviewerAsSystem(PubReviewTeam__c reviewTeamMember) {
		insert reviewTeamMember;
	}
	
	global static PubReviewTeam__c getLoggedInTeamMemberForPubFprCycle(Id pubId, Id fprCycleId) {
   		if (pubId == null ||  fprCycleId == null) {
   			return null;
   		}
   		
   		Set<Id> AppearUserContactIdSet = AppearContactModel.findContactForAppearUser(userInfo.getUserId());
   		
   		if (AppearUserContactIdSet.size() > 0) {
   			//Id loggedInContactId = contacts[0].Id;
   		
	   		List<PubReviewTeam__c> teamMembers = [
	   			Select Reviewer_Status__c, Comments__c, HasVoted__c, Type__c, ProxyMember__c, ProxyMember__r.HasVoted__c, SubType__c
	   			From PubReviewTeam__c
	   			Where Publication__c = :pubId 
	   			And Reviewer__c in :AppearUserContactIdSet 
	   			And FPR_Cycle__c= :fprCycleId 
	   			And IsLogicallyDeleted__c = false
	   		];
	   			
   			if (teamMembers.size() > 0) {
   				return teamMembers[0];
   			} else {
   				AppLogModel.LogError('PubReviewTeamModel::getLoggedInTeamMemberForPubFprCycle', 
   					'PubReviewTeam record fround for CurrentUser['+userInfo.getUserName()+'] for this publication['+ pubId +'] ', pubId);
   			}
   		} else {
   			AppLogModel.LogError('PubReviewTeamModel::getLoggedInTeamMemberForPubFprCycle', 
   				'CurrentUser['+userInfo.getUserName()+'] is not a member of the review team of this publication['+ pubId +'] ', pubId);
   		}
		return null;
	}
	
	global static void UpdateReviewerAsSystem(PubReviewTeam__c reviewTeamMember) {
		update reviewTeamMember;
	}
	
    global static void ChangeOwnershipToFprSubmitter(Publication__c pubRecord, boolean updatePubRecord) { //used to remove edit access to a submitted suggestion or in fpr from creator. Sharing criteria will grant redundantly where appropriate
        Id submitterUserId = AppearContactModel.findUserIdForContactId(pubRecord.Fpr_Submitter__c);
        if (submitterUserId == null) {
            AppLogModel.LogError('withoutSharingUtil::ChangeOwnershipToFprSubmitter', 'Cannot find FPR Submitter. Aborting', pubRecord.Id);
            AppLogModel.flushLogs();
            return;
        }
        pubRecord.OwnerId = submitterUserId;
        
        AppearPubModelShare pubShare = new AppearPubModelShare(pubRecord.Id, pubRecord.RecordTypeId, pubRecord.isEnbrel__c);
        pubShare.resetAllApexSharing(); //reset sharing so ownership can be handed back to portal user
        
        if (updatePubRecord ) {
            update pubRecord;
        }
        AppLogModel.LogInfo('withoutSharingUtil::ChangeOwnershipToFprSubmitter', 
            'Changed ownership for Pub['+pubRecord.Publication_Title__c +'] to userId ' + submitterUserId, pubRecord.Id);
    }
    /*Code implemented to check when EW user try to clone a publication whether they have access to all the 
    Related Pubs of Original Pub or NOT*/
    
	  global static List<PubRelated__c> getPubRelatedSystemContext(Id PubId) {
	        if ( PubId == null) {
	            return null;
	        }
	        List<PubRelated__c> pubRelatedList = [ 
	            select id, ToDelete__c,
	            Publication__c, publication__r.Name, publication__r.Publication_Title__c,
	            RelatedPub__c, RelatedPub__r.Name, RelatedPub__r.Publication_Title__c,
	            RelatedPub__r.Publication_Type__c,  RelatedPub__r.Current_Status_FormulaField__c, RelatedPub__r.Authors__c,
	            RelatedPub__r.Current_Status_Date_FormulaField__c, RelatedPub__r.Current_Target__c, RelatedPub__r.isPlanning__c,
	            RelatedPub__r.Data_Source__c, RelatedPub__r.SubGroup_pick__c, RelatedPub__r.Datasourceformulafield__c,
	            RelatedPub__r.Subgroup__c, RelatedPub__r.Is_Tracking_Only__c, RelatedPub__r.Country_Pick__c, RelatedPub__r.Presentation_Type__c,
	            RelatedPub__r.RAE__c, RelatedPub__r.Search_Identifier__c
	            from PubRelated__c
	            where Publication__c = :PubId
	        ];
	        
	        string msg = 'Related Pub Model retrieved from System Context ' + pubRelatedList.size()+' records for PubId = '+PubId;
	        System.Debug(msg);
	        System.debug('Related list fetched'+pubRelatedList);// updated 2/11/15
	        
	        return pubRelatedList;
	    }
    

}