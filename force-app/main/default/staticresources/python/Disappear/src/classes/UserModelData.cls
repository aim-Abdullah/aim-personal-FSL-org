public class UserModelData {

	private static User pBschoenUser = null;
	public static User bschoenUser {
		get {
			if ( pBschoenUser == null) {
				pBschoenUser = UserModel.getUserByUserName('bschoen@test.com');
				if ( pBschoenUser == null) {
					pBschoenUser = new User (Alias = 'bschoen',EmailEncodingKey='UTF-8',username='bschoen@test.com',
    					LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles',firstname='Brandon',
     					lastname='Schoen',profileId =ProfileModel.ProfileNameMap.get('System Administrator').Id,email='bschoen@salesforce.com');
     				insert 	pBschoenUser; 
				}
			}
			return pBschoenUser;
		}
	}
	
	private static User pCruesgaUser = null;
	public static User cruesgaUser {
		get {
			if ( pCruesgaUser == null) {
				pCruesgaUser = UserModel.getUserByUserName('bschoen@test.com');
				if ( pCruesgaUser == null) {
					pCruesgaUser = new User (Alias = 'cruesga',EmailEncodingKey='UTF-8',username='cruesga@test.com',
    	LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles',firstname='Cid',
     	lastname='Ruesga',profileId =ProfileModel.ProfileNameMap.get('System Administrator').Id,email='cruesga@salesforce.com' );
     				insert 	pCruesgaUser; 
				}
			}
			return pCruesgaUser;
		}
	}
}