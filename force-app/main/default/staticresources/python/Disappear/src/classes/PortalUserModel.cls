public class PortalUserModel {
	
	public static User CreatePortalUser(Id portalContactId, Profile portalUserProfile) {
		
		if (portalUserProfile == null) {
			AppLogModel.LogError('PortalUserModel::CreatePortalUser', 
				'portalUserProfile is null');
			AppLogModel.flushLogs();
			return null;		
		}
		
		//check if the PortalContact exists
		List<Contact> contacts = [
			select id,name,email,lastname,firstname,accountid 
			from contact 
			where Id=:portalContactId 
		];
		
		if (contacts.size() == 0){
			AppLogModel.LogError('PortalUserModel::CreatePortalUser', 
				'Cannot locate contact for PortalContactId - ' + portalContactId);
			AppLogModel.flushLogs();
			return null;
		}
		
		//check if the PortalContact is already associated with a user
		List<User> users = [
			select id, ProfileId
			from user
			where ContactId = :portalContactId
		];
		
		if (users.size() == 1) {  
			if (users[0].ProfileId == portalUserProfile.id) {
				//found an user for contact with the correct profile
				//return that anyway
				AppLogModel.LogInfo('PortalUserModel::CreatePortalUser', 
					'Located User for PortalContactId - ' + portalContactId);
				AppLogModel.flushLogs();
				return users[0];
			}	
		}
		
		if (users.size() <> 0){
			//fouund more than 1 user for the contact --> error
			AppLogModel.LogError('PortalUserModel::CreatePortalUser', 
				'Located more than one contact for PortalContactId - ' + portalContactId);
			AppLogModel.flushLogs();
			return null;			
		}

		AppLogModel.Loginfo('PortalUserModel::CreatePortalUser', 
				'Error checking completed for PortalContactId - ' + portalContactId);
		
		//https://developer.salesforce.com/forums?id=906F000000091RxIAI
		
		Contact con = contacts[0];
		
		User u2 = new User(
			contactId=portalContactId, 
			username=con.Email, 
			firstname=con.FirstName,
			lastname=con.LastName, 
			email=con.Email,
			communityNickname = con.LastName + '_' + Rnd(),
			alias = string.valueof(con.FirstName.substring(0,1) + con.LastName.substring(0,1)), 
			profileid = portalUserProfile.Id, 
			emailencodingkey='UTF-8',
			languagelocalekey='en_US', 
			localesidkey='en_US', 
			timezonesidkey='America/Los_Angeles');
		
		Database.DMLOptions dlo = new Database.DMLOptions();
		dlo.EmailHeader.triggerUserEmail= false;
		Database.saveresult sr = Database.insert(u2,dlo);
		
		if (sr.isSuccess()) {
			
			AppLogModel.LogInfo('PortalUserModel::CreatePortalUser', 
				'Created user with id ['+u2.id+
				'] for PortalContactId - ' + portalContactId);
		} else {
			AppLogModel.LogError('PortalUserModel::CreatePortalUser', 
				'Failed to create Portal User : ' + sr.getErrors());
		}
		AppLogModel.flushLogs();
		
		return u2;
	}
	
	private static string Rnd() {
		return String.valueOf(Math.random() * 100000);
	}

}