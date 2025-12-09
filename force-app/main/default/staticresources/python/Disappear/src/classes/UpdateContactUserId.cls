/* This class is used for @future functions to deal with User-Contact changes
The function UpdateContact is used when a new User is created, this function
associates the User to the contact
The functioan UpdateUser sets a user inactive, if the Contact is set inactive
via the interface */

public class UpdateContactUserId{
    
    @future
    //UpdateContact with UserId by matching email address
    public static void UpdateContact (Set<Id> UserIds) {
    
        List<User> UserAdded = [Select Id,Email from User where Id in :UserIds];
        List<string> userEmails = new List<string>();
         
        for(User userRecord : UserAdded){
            userEmails.add(userRecord.email);
        }

        List<Contact> contacts = [
            select id, userId__c, email
            from contact
            where email in :userEmails
        ];
        
        //put contact retrieved in a map for quick search
        Map<string, contact> contactMapByEmail = new Map<string, contact>();
        
        for(Contact c : contacts) {
            contactMapByEmail.put(c.email, c);
        }
        
        //create a list of User with no match contact records
        List<Contact> contactsUpdate = new List<Contact>();
        for(User userRecord1 : UserAdded) {
            if (contactMapByEmail.containskey(userRecord1.email) ) {
                Contact conemail = contactMapByEmail.get(userRecord1.email);
                conemail.userId__c = userRecord1.id;
                contactsUpdate.add(conemail);
                
                AppLogModel.LogInfo('UpdateContactUserId::UpdateContact', 'Linked User: '+userRecord1.email + ' to contact ');
            } else {
                AppLogModel.LogError('UpdateContactUserId::UpdateContact', 'No contact found corresponding to email:' + userRecord1.email);
            }
        } 
        
        if ( contactsUpdate.size() > 0 ) {
            update contactsUpdate;
        }
          
        AppLogModel.flushLogs();
    }
        
    @future        
    public static void DeactivateUser (List<Id> UserIdinactivated){
        List<User> Usertobedeactivated = new List<User>();
        
        //Sesha: Check for the User Id 1st for all Platform Users
        Usertobedeactivated = [Select Id,Email,IsPortalEnabled,IsActive,FederationIdentifier,ContactId,Is_SAML_JIT__c from User where Id in :UserIdinactivated];
        
		//Sesha: Check for the Contact Id in the User Object for all Community Users
      	/**if (Usertobedeactivated.size() == 0) {
            Usertobedeactivated = [Select Id,email,FederationIdentifier from User where ContactId in :UserIdinactivated];
        }**/
        
        //List<Profile> profileId = [Select id from profile where name ='APPEAR FPR Only Submitter'];
        
        for (User Userloop  : Usertobedeactivated)
        {
            Userloop.IsActive = false;
            Userloop.IsPortalEnabled = false;           	//Sesha: This needs to be set for the AMGEN Community Users. Anyways, by default this is false for Platform User
            Userloop.Email = '_'+Userloop.email;        	//Sesha: This needs to be set for the AMGEN Community Users. Anyways, systematically we can't change this for Platform User
            //Need this Random Hash so that we can deactivate the user with the same Federation Id.
            String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
			Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
			String hexDigest = EncodingUtil.convertToHex(hash);
			//Need this Random Hash so that we can deactivate the user with the same Federation Id.
            Userloop.FederationIdentifier = (Userloop.FederationIdentifier != null ? Userloop.FederationIdentifier + '-disabled-'+hexDigest : null);
            //Userloop.ProfileId = profileId[0].Id;
            
            //AppLogModel.LogInfo('UpdateContactUserId::DeactivateUser', ' User Deactivated - '+Userloop.FederationIdentifier);
        }
        
        database.update(Usertobedeactivated,false);
        //AppLogModel.flushLogs();
    }

	//Appear Enhancement - backlog Item R1:2017 Release - Change UserEmail while Updating Contact Email for Appear Contacts
    @future
    public static void UpdateUserEmail(List<Id> contactIdset){
    	List<Contact> con= [Select id,Email,UserId__c,UserId__r.Email,RecordType.Name from contact where id in:contactIdset];
    	map<id,string> userEmailMap = new map<id,string>();
    	List<User> updateuserList = new List<User>();
    	for(contact c : con){
    		if(c.RecordType.Name == 'Appear Contact'){
    			userEmailMap.put(c.UserId__c,c.Email); 
    		}    		
    	}
    	
    	List<User> userList =[Select id,email from user where id in:userEmailMap.keySet() ];
    	
    	for(User u : userList){
    		u.email = userEmailMap.get(u.Id);
    		updateuserList.add(u);
    	}
    	update updateuserList;    	
    }
}