trigger UserTrigger on User (before insert, after insert, before update) {

 /* The following section updates the Contact with the User Id.When a new user is created, 
 this trigger makes a call to UpdateContactUserId class to associate the user to 
the contact based on the email. There is a limitation in salesforce where a transaction
cannot occur simultaneously on set up object(User) and non-setup object(Contact).
Therefore a class was created with @future method to do the transaction.
*/       
        if ((trigger.isAfter ==true) && (trigger.isInsert == true))
        {
        	Set<id> usersToUpdate = new Set<id>();
        	for(User userToCheck : trigger.new) {
        		 //SESHA (12/11/2014): Commented so that all the Contact will have an associated User Id (Core as well Portal). This information can be utilized for reporting and validations
        		//if (!userToCheck.IsPortalEnabled) {
        			usersToUpdate.add(userToCheck.id);
        		//} 
        	}
        	if (usersToUpdate.size() > 0) {
            	UpdateContactUserId.UpdateContact(usersToUpdate);
        	}
        }
/* The following section updates the User with the details from contact. Once the JIT is ready
to create the user, this code will copy the first name and title from Contact onto that user
record*/     
        else if ((trigger.isBefore == true) && (trigger.isInsert == true))
        {
            List<User> UserAttrMod = Trigger.new;
            List<String> UserModEmail = new List<String>();
            id FprSubmitterOnlyRoleId = UserRoleModel.FPR_Only_SubmitterRoleId;
            
            for (User userloop :UserAttrMod)
            {
                if (userloop.Is_SAML_JIT__c == 'TRUE' && !userLoop.IsPortalEnabled)
                {
                    UserModEmail.add(userloop.email);
                    //userloop.UserRoleId = FprSubmitterOnlyRoleId;    //Def #671 - User Provisioning - for FPR Submitter
                }
            }
            if (UserModEmail.size() == 0) {
            	return;
            }
            List<Contact> contacts = [select id, firstname, Title, userId__c, email from contact where email in :UserModEmail];
                    
            Map<string, contact> contactMapByEmail = new Map<string, contact>();
                        
            for(Contact c : contacts) 
            {
                contactMapByEmail.put(c.email, c);
            }
                
            for (User Userloop1  :UserAttrMod)
            {
                if (contactMapByEmail.containskey(Userloop1.email) ) 
                {
                    Contact c = contactMapByEmail.get(Userloop1.email);
                    Userloop1.FirstName = c.FirstName;
                    Userloop1.Title = c.Title;
                    Userloop1.Is_SAML_JIT__c = null;
                    AppLogModel.LogInfo('UpdateUserDetails::', ' User Attributes Changed- '+Userloop1.email);
                }   
            }
            
            AppLogModel.flushLogs();    
 
        }       
/*The following section prevents the JIT process to update the profile of a user. 
As part of SSO, Siteminder will always send out the same constant Profile
To avoid profile updates, we will get Is_SAML_JIT__c fields from JIT and too with value "TRUE" and in that scenario, 
this code will prevent the update of the profile.*/
        else if ((trigger.isBefore == true) && (trigger.isUpdate == true))
        {
            for (User u : Trigger.new) 
            {
                if (u.Is_SAML_JIT__c == 'TRUE') 
                {
                    u.Is_SAML_JIT__c = '';
                    User uOld = System.Trigger.oldMap.get(u.Id);
                    if (u.ProfileID != uOld.ProfileId)
                    {
                        u.ProfileID = uOld.ProfileId;
                    }
                }
            }
        }
}