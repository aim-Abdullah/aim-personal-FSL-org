global class AppearContactModel {

  

///////////////////////////    static    ////////////////////////////

    //SimilarContacts returns an array of similar contact
    global static List<AppearSimilarContactDO> SimilarContacts(string searchBy, integer numResult) {
        
        if (searchBy == null){ 
            return new List<AppearSimilarContactDO>();
        }
          
        if (searchBy.contains(',')) {
            //return searchTwoWords(word1, word2, numResult);  
            string[] words = searchBy.split(',');
            List<AppearSimilarContactDO> results = searchFirstLastName(words[0].trim(), words[1].trim(), numResult);  
            results.addAll(searchFirstLastName(words[1].trim(), words[0].trim(), numResult));
            return results;
        } else  if (searchBy.contains('@')) {
            return searchEmail(searchBy, numResult);
        } else {
            return searchOneWord(searchBy, numResult);  
        }   
    }
    
    private static List<AppearSimilarContactDO> searchOneWord(string searchBy, integer numResult) {
        string soql = 'select id, FirstName, LastName, Email, Phone from Contact '+
            'where Name like \'%'+ searchBy+'%\' ' + 
            'limit '+ numResult;
        List<AppearSimilarContactDO>  results = AppearSimilarContactDO.getSimilarContacts(soql);
          
        return results; 
    }
      
    private static List<AppearSimilarContactDO> searchEmail(string searchBy, integer numResult) {
        string soql = 'select id, FirstName, LastName, Email, Phone from Contact '+
            'where Email like \'%'+ searchBy+'%\' ' + 
            'limit '+ numResult;
        List<AppearSimilarContactDO>  results = AppearSimilarContactDO.getSimilarContacts(soql);
          
        return results;
    }
    
    private static List<AppearSimilarContactDO> searchFirstLastName(string firstName, string lastName, integer numResult) {
        string soql = 'select id, FirstName, LastName, Email, Phone from Contact '+
            'where FirstName like \''+ firstName+'%\' and LastName like \''+ lastName+'%\'' + 
            'limit '+ numResult;
        List<AppearSimilarContactDO>  results = AppearSimilarContactDO.getSimilarContacts(soql);
          
        return results;
    }  
      
    public static Map<id,contact> getContactMap(List<id> contactIdList) {
    	map<Id,Contact> resultMap = new map<Id,Contact> ();
    	for(Contact c : getContactList(contactIdList)) {
    		resultMap.put(c.id, c);
    	}
    	return resultMap;
    }
    public static List<Contact> getContactList(List<id> contactIdList){
		List<Contact> result = [
			select id, Name
			From Contact
			where id in :contactIdList
          	order by Name  
		];
		return result;
    } 
    
    public static boolean isCurrentUserEnbrelRestricted{
		get {
			List<Contact> contacts = [
				select id,Restrict_Enbrel__c
				from Contact
				where UserId__c = :UserInfo.getUserId()
			];
			
			for(Contact c : contacts) {
				if (c.Restrict_Enbrel__c) {
					return true;
				}
			}
			return false;
		}
	}
	
	public static List<Contact> findContactByName(String firstName, String LastName) {
		List<Contact> result = [
			select id, Name
			From Contact
			where firstName = :FirstName
			and LastName = :LastName
		];
		return result;
	}
    
    
	public static Set<Id> findContactForAppearUser(User appearUser) {
		if ( appearUser == null) return null;
		return findContactForAppearUser(appearUser.id);
	}
	
	public static Set<Id> findContactForAppearUser(Id appearUserId) {
		
		if ( appearUserId == null) return null;
		
		Set<id> userContactIdSet = new Set<id>();
		// Note the usage of AppearUrlModel call won't work for SF1 since the uRL does not contain community prefix
		if (AppearUrlModel.IsPortal  || AppearUrlModel.IsAuthorComm) {
			List<User> users = [
				Select id, ContactId
				from User
				where id = :appearUserId
			];
			
			for(User u : users) {
				userContactIdSet.add(u.ContactId);
			}
		} else {
			List<Contact> contacts = [
				Select id
				from Contact
				where UserId__c = :appearUserId
			];
			
			for(contact c : contacts){
				userContactIdSet.add(c.id);
			}
		}
		return userContactIdSet;
	}

	public static Contact findContactByContactId(Id contactId) {
		if ( contactId == null) return null;
		
		List<Contact> contacts = [
			Select Id, name, email, Restrict_Enbrel__c, UserId__c
			from Contact
			where Id = :contactId
		];
		
		if (contacts.size() == 1) {
			return contacts[0];
		}
		
		return null;
	}

	//This function will de-duplicate requested contactIds
	public static List<string> findContactEmailByContactIds(List<Id> contactIds) {
		if ( contactIds == null) {
			System.Debug('AppearContactModel::findContactEmailByContactIds contactIds=null');
			return new List<string>();
		}
		
		List<Contact> contacts = [
			Select email, name, UserId__c, id, firstname, lastname
			from Contact
			where Id in :contactIds
		];
	
		List<string> result = new List<string>();
		for(Contact c : contacts) {
			if ( c.email <> null) {
				result.add(c.email);
			}
		}	
		return result;
	}
	
	
	// key: user id ,  values: contactIds
	public static Map<id, id> findUserIdsForContactIds(Set <id> contactIds ){
		
    	Map <id, id > contactToUser = new Map<id, id>(); 	
    			
		List<User> portalUsers = [
			Select Id, ContactId
			from User
			where ContactId in :contactIds
		];
		
		for (User aUser : portalUsers){
			contactToUser.put( aUser.Id, aUser.ContactId); 
		}
		
		List<Contact> contacts = [
			Select UserId__c, id, firstName, lastName, email, name
			from Contact
			where Id in :contactIds
		];
		
		for (Contact aContact : contacts){
			contactToUser.put( aContact.UserId__c, aContact.id ); 
		}	
		return contactToUser; 
		
	}

	
	public static id findUserIdForContactId(Id contactId) {
		if ( contactId == null) return null;
		
		List<User> portalUsers = [
			Select Id
			from User
			where ContactId = :contactId
		];
		
		if (portalUsers.size() > 0) {
			return portalUsers[0].Id;
		} else {
			List<Contact> contacts = [
				Select UserId__c, id, firstName, lastName, email, name
				from Contact
				where Id = :contactId
			];
			
			if (contacts.size() > 0) {
				return contacts[0].UserId__c;
			} 
		}		
		
		return null;
	}
	
	private static transient Map<Id,Contact> contactsWithProxies;
	
	public static Contact findProxyForContactId(Id contactId) {
		if ( contactId == null) {
			 return null;
		 }
		
		if (contactsWithProxies == null) {
			contactsWithProxies = new Map<Id,Contact>([
				Select id, Name, Proxy__c, proxy__r.Name
				from Contact
				where Proxy__c != null
			]);
		}
		
		if (contactsWithProxies.containsKey(contactId)) {
			return contactsWithProxies.get(contactId);
		}
		
		return null;
	}
	
	public static Department__c findContactDepartment(id contactId) {
		if ( contactId == null) return null;
		
		List<Contact> contacts = [
			Select UserId__c, Department
			from Contact
			where Id = :contactId
		];
		
		if (contacts.size() == 0 || contacts[0].Department == null || contacts[0].Department == '') {
			return null;
		}
		
		Department__c department = DepartmentModel.getDepartment(contacts[0].Department);
		return department;
		
	}
	
	public static String findContactOrganization(String dept) {
		if ( dept == null) return null;
		
		List<Department__c> orgList= [
			Select OrganizationId__c, OrganizationId__r.Name
			from Department__c
			where Name = :dept
		];
		
		if (orgList.size() == 0 || orgList[0].OrganizationId__c == null || orgList[0].OrganizationId__r.Name == '') {
			return null;
		}
		
		return orgList[0].OrganizationId__r.Name;
	}
	
	public static String findContactEmployeeType(id contactId) {
		if ( contactId == null) return null;
		
		List<Contact> empTypeList= [
			Select Emp_Type__c
			from Contact
			where Id = :contactId
		];
		
		if (empTypeList.size() == 0 || empTypeList[0].Emp_Type__c == null) {
			return null;
		}
		
		return empTypeList[0].Emp_Type__c;
	}
	
	//create a contact with a linked User Record - for Amgen Appear Testing
	public static Contact createContactAndUser(string contactLastName, string contactFirstName,
		string contactEmail, integer contactEmployeeNumber, Profile contactProfile) {
		
		User u = new User(
			username=contactEmail, 
			firstname=contactFirstName,
			lastname=contactLastName, 
			email=contactEmail,
			communityNickname = contactLastName + '_' + Rnd(),
			alias = string.valueof(contactFirstName.substring(0,1) + contactLastName.substring(0,1)), 
			profileid = contactProfile.Id, 
			emailencodingkey='UTF-8',
			languagelocalekey='en_US', 
			localesidkey='en_US', 
			timezonesidkey='America/Los_Angeles');
		
		Database.DMLOptions dlo = new Database.DMLOptions();
		dlo.EmailHeader.triggerUserEmail= false;
		Database.saveresult sr = Database.insert(u,dlo);
		
		//System.assertNotEquals(null, u.id);
		
		Contact c = new Contact(
			lastname = contactLastName,
			firstname = contactFirstName,
			email = contactEmail,
			EmployeeNumber__c = Decimal.ValueOf(contactEmployeeNumber),
			IsActive__c = true,
			isFlaggedForDelete__c = false,
			UserId__c = u.id
		);
		
		insert c;
		//System.assertNotEquals(null, c.id);
		//System.assertEquals(true, c.IsActive__c);
		
		return c;
	}
	
	private static string Rnd() {
		return String.valueOf(Math.random() * 100000);
	}
    
}