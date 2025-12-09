//special library created by Benjamin & Brandon to migrate users from Release 1.4 to Release 2.0 portal

public without sharing class Rel20MigrationModel {

	public static boolean commitChanges = false;
	
	private static List<r20mig__c> pR20MigList = null;
    public static List<r20mig__c> R20MigList {
        get {
            if (pR20MigList == null) {
                pR20MigList = [
                	select id, Action__c, FromProfile__c, FromUser__c, FromUser__r.email, 
                	FromEmailAddress__c, fromContactFedId__c, FromFederationId__c,
                	isSelected__c, FromUser__r.ProfileId,
                	ToFprPortalUser__c, ToProfile__c, ToUser__c, toContactFedId__c
                	from r20mig__c];
            }
            return pR20MigList;
        }
    }
	
	public static void reloadR20MigList () {
		pR20MigList = null;
	}
	
    public static void truncateAllRecords() {
    	List<r20mig__c> r20List = R20MigList;
    	delete r20List;
    	pR20MigList = null;
    }
    
    public static List<User> FprSubmittersUsers {
    	get {
    		List<User> fprSubmitterUsers = [
    			select id, username, profileId, FederationIdentifier, UserRoleId, email, UserType
    			from user
    			where ProfileId = :ProfileModel.AppearFprOnlySubmitterProfile.Id
    			and isActive = true
    		];
    		return fprSubmitterUsers;
    	}
    }
    
    //Rel20MigrationModel.testFprSubmitterWithData();
    public static void testFprSubmitterWithData() {	
		List<User> testUsers = [
			select  id, username, profileId, FederationIdentifier, UserRoleId, email, UserType
			from User
			where ProfileId = :ProfileModel.AppearFprOnlySubmitterProfile.Id
			and email = 'tonyp@amgen.com.dev20'
			and isActive = true
		];
		
		populateFprSubmitters(testUsers);
		
		AppLogModel.flushLogs();
	}
    
    //Rel20MigrationModel.populateFprSubmitters();
	public static void populateFprSubmitters() {
		populateFprSubmitters(FprSubmittersUsers);
	}
	
	public static void populateFprSubmitters(List<User> fprUsers) {
		AppLogModel.LogDebug('Rel20MigrationModel::populateFprSubmitters', 'fprUsers has '+fprUsers.size()+' records');
		
		
		truncateAllRecords();
		List<r20mig__c> newR20MigList = new List<r20mig__c>();
		
		for (User fprUser : fprUsers) {
			r20mig__c fprUserMig = new r20mig__c();
			fprUserMig.FromUser__c = fprUser.id;	
			fprUserMig.FromFederationId__c = fprUser.FederationIdentifier;
			fprUserMig.FromEmailAddress__c = fprUser.Email;
			
			newR20MigList.add(fprUserMig);
		}
		insert newR20MigList;
		
		//clear cache after insert
		pR20MigList = null;
		newR20MigList = refreshFromProfile(R20MigList);
		
		//take all users to be migrated - find if there is another login with same email address but different profile and active
		newR20MigList = matchFprSubmitters(newR20MigList);  
		
		update newR20MigList;
		
	}
	
	//update from Profile for all entries in r20mig__c to latest
	public static void refreshFromProfile () {	
		update refreshFromProfile(R20MigList);
	}
	
	//refreshFromProfile will write the populate or update the fromProfile field with the user's current profile.
	private static List<r20mig__c> refreshFromProfile (List<r20mig__c> MigList) {
		AppLogModel.LogDebug('Rel20MigrationModel::refreshFromProfile', 'MigList has '+MigList.size()+' records');
		
		for (r20mig__c fprUserMig : MigList ) {
			if ( fprUserMig.FromUser__c <> null && fprUserMig.FromUser__r.ProfileId <> null ) {  
				fprUserMig.FromProfile__c = ProfileModel.ProfileMap.get(fprUserMig.FromUser__r.ProfileId).name;
				AppLogModel.LogInfo('Rel20MigrationModel::refreshFromProfile','Profile for '+ fprUserMig.FromUser__r.email+' is '+ fprUserMig.FromProfile__c+
					' email = '+fprUserMig.FromEmailAddress__c);
			} else {
				AppLogModel.LogError('Rel20MigrationModel::refreshFromProfile','Cannot find Profile for '+ fprUserMig.name);
			}
		}
		return MigList;
	}
	
	
	
	//match FPR only Submitter email as much as we can
	//this routine will be invoked by populateFprSubmitters
	//it can also be invoked from UI for additional matching
	public static List<r20mig__c> matchFprSubmitters(List<r20mig__c> MigList) {
		AppLogModel.LogDebug('Rel20MigrationModel::matchFprSubmitters', 'MigList has '+MigList.size()+' records');
		
		//create a unique set of Userid to match to Contact.userId__c
		set<id> fromUserIdSet = new Set<id>();
		for (r20mig__c fprUserMig : MigList ) {
			if (fprUserMig.FromUser__c <> null) {
				fromUserIdSet.add(fprUserMig.FromUser__c);
			}
		}
		
		List<Contact> fromContacts = [
			select id, UserId__c
			from Contact
			where isFlaggedForDelete__c = false
			and UserId__c in :fromUserIdSet
		];
		
		Map<Id, Contact> ContactMapByUserId = new Map<Id, Contact>();
		for(Contact c : fromContacts) {
			ContactMapByUserId.put(c.UserId__c, c);
		}	
		
		for (r20mig__c fprUserMig : MigList ) {
			if (ContactMapByUserId.containsKey(fprUserMig.FromUser__c)) {
				fprUserMig.fromContact__c = ContactMapByUserId.get(fprUserMig.FromUser__c).id; 
			} else {
				
			}
		}
		
		//create a unique set of email
		set<string> emailSet = new set<string>();
		for (r20mig__c fprUserMig : MigList ) {
			if ( fprUserMig.FromEmailAddress__c <> null) {
				emailSet.add(fprUserMig.FromEmailAddress__c);
			} else {
				AppLogModel.LogError('Rel20MigrationModel::matchFprSubmitters', 'fprUserMig missing FromEmailAddress__c' );
			}
		}
		
		AppLogModel.LogInfo('matchFprSubmitters', 'found '+emailSet.size()+' unique email addresses');
		
		
		//retrieve all users with same email address but Profile <> AppearFprOnlySubmitterProfile
		List<User> toUserList = [
			select id, name, email, profileId, federationIdentifier
			from User
			where email in :emailSet
			and ProfileId <> :ProfileModel.AppearFprOnlySubmitterProfile.Id
			and isActive = true
		];

		AppLogModel.LogInfo('matchFprSubmitters', 'toUserList has '+toUserList.size()+' records');

		//create a map by email
		//create a list where more than 1 to users have the same email address
		Map<string, user> emailMap = new Map<string, user>();
		List<User> emailDupList = new List<User>();
		Set<string> emailDupSet = new Set<string>();
		
		for(User toUser : toUserList) {

			
			if ( emailMap.containsKey(toUser.email)) {
				emailDupSet.add(toUser.email);  //mark that dup exists
				emailDupList.add(toUser);
				AppLogModel.LogInfo('matchFprSubmitters', toUser.email +' is a duplicated email addresses');
			} else {
				if (toUser.email<> null && toUser.email.endsWith('.dev20') ) {
					toUser.email = toUser.email.replace('.dev20','');
				}
			
				emailMap.put(toUser.email, toUser);
				AppLogModel.LogInfo('matchFprSubmitters', 'found toUser email '+toUser.email);
			}
		}
		
		//fill out the toUser section now.
		for (r20mig__c fprUserMig : MigList ) {
			fprUserMig.ToFprPortalUser__c = false;
			//remove the sandbox suffix
			if (fprUserMig.FromEmailAddress__c<> null && fprUserMig.FromEmailAddress__c.endsWith('.dev20') ) {
				fprUserMig.FromEmailAddress__c = fprUserMig.FromEmailAddress__c.replace('.dev20','');
			}
			
			if ( emailMap.containsKey(fprUserMig.FromEmailAddress__c)) {
				User toUser = emailMap.get(fprUserMig.FromEmailAddress__c);
				fprUserMig.ToUser__c = toUser.Id;
				fprUserMig.ToProfile__c = ProfileModel.ProfileMap.get(toUser.profileId).name;
				fprUserMig.ToFederationId__c = toUser.FederationIdentifier;
				fprUserMig.ToEmailAddress__c = toUser.email;
				fprUserMig.ToFprPortalUser__c = false;
				
				if (emailDupSet.contains(fprUserMig.FromEmailAddress__c) ) {
					// this from user maps to multiple to users
					// write that in notes section
					fprUserMig.Note__c = 'Has more than one matching To Users';
					AppLogModel.LogInfo('matchFprSubmitters',fprUserMig.FromEmailAddress__c +'with ' +' profile will be merged with '+fprUserMig.toEmailAddress__c);
				} 
			} else {
				//if no matching - then these FPR Submitter will be converted to Portal users
				fprUserMig.ToFprPortalUser__c = true;
				
				// auto select migration to Portal 
				//fprUserMig.isSelected__c = true; 
				
				AppLogModel.LogInfo('matchFprSubmitters',fprUserMig.FromEmailAddress__c +' will be converted to a FPR Portal User');
			}
		}
		
		//create a unique set of Userid to match to Contact.userId__c
		set<id> toUserIdSet = new Set<id>();
		for (r20mig__c fprUserMig : MigList ) {
			if (fprUserMig.ToUser__c <> null) {
				toUserIdSet.add(fprUserMig.ToUser__c);
			}
		}
		
		List<Contact> toContacts = [
			select id, UserId__c
			from Contact
			where isFlaggedForDelete__c = false
			and UserId__c in :toUserIdSet
		];
		
		Map<Id, Contact> toContactMapByUserId = new Map<Id, Contact>();
		for(Contact c : toContacts) {
			toContactMapByUserId.put(c.UserId__c, c);
		}	
		
		
		for (r20mig__c fprUserMig : MigList ) {
			if (toContactMapByUserId.containsKey(fprUserMig.ToUser__c)) {
				fprUserMig.toContact__c = toContactMapByUserId.get(fprUserMig.ToUser__c).id; 
			}
		}
		
		AppLogModel.flushLogs();
		
		return MigList;
		
	}

	public static void pubOwnerShipMigration(User fromUser, User toUser) {
		MigratePubOwnershipUtil.migratePubAndJunctionOwnership(fromUser.Id, toUser.Id);
	}
	
	public static boolean FlagContactForDelete(Id contactToDeleteId) {
		if ( contactToDeleteId == null) {
			AppLogModel.LogError('Rel20MigrationModel::FlagContactForDelete',
				'Error - contactToDeleteId is NULL');
			AppLogModel.flushLogs();
			return false;
		}
		List<Contact> contacts = [
			select id,firstName, lastName, email, isFlaggedForDelete__c,EmployeeNumber__c
			from Contact
			where id = :contactToDeleteId
		];
		
		if ( contacts.size() == 1) {
			Contact c = Contacts[0];
			
			//may need logic to warn if contact was created and maintain by the interface
		
			c.isFlaggedForDelete__c = true;
			update c;	
			
			String msg = String.Format('Flagged Contact {0} {1} {2} {3} {4} For Deletion ', 
				new String[] {string.valueOf(c.id), c.firstName, c.lastName, c.email, String.valueOf(c.EmployeeNumber__c)});
			
			AppLogModel.LogInfo('Rel20MigrationModel::FlagContactForDelete', msg);  
			AppLogModel.flushLogs();
			return true;
			
		} else {
			AppLogModel.LogError('Rel20MigrationModel::FlagContactForDelete',
				'ContactToDelete cannot be found id='+contactToDeleteid);
			AppLogModel.flushLogs();
			return false;			
		}
	}
	
	//Rel20MigrationModel.selectToPortalUser();
	public static void selectToPortalUser() {
		List<r20mig__c> r20list = R20MigList;
		
		for ( r20mig__c m : r20list) {
			if ( m.fromContactFedId__c == m.FromFederationId__c && m.ToFprPortalUser__c) {
				m.isSelected__c = true;
			} else {
				m.isSelected__c = false;
			}
		}
		update r20list;
	}

	//Rel20MigrationModel.selectToPlatformUser();
	public static void selectToPlatformUser() {
		List<r20mig__c> r20list = R20MigList;
		
		for ( r20mig__c m : r20list) {
			if ( m.ToFprPortalUser__c == false && m.ToUser__c <> null && m.toContactFedId__c <> '0') {
				m.isSelected__c = true;
			} else {
				m.isSelected__c = false;
			}
		}
		update r20list;
	}

	
	//Rel20MigrationModel.unselectAll();
	public static void unselectAll() {
		List<r20mig__c> r20list = R20MigList;
		
		for ( r20mig__c m : r20list) {
			m.isSelected__c = false;
		}
		update r20list;
	}
	
	
	//@future
	public static void DeactivateUser(Id userToDeactivateId) {	
		
		User u = [
			select id, Username, isActive 
			from user 
			where id = :userToDeactivateId
		];
		
		/*
		AppLogModel.LogInfo('Rel20MigrationModel::DeactiveUser', 
			u.Username +' has been deactiaved after migration to Portal User');
		AppLogModel.flushLogs();
		*/
		
		u.isActive = false;
		update u;
		
		
		
		
	}

}