@IsTest
public class PortalUserModelTest {

	@IsTest
	public static void unitTest() {
		Id portalContactId = createData();	
		System.assertNotEquals(null, portalContactId);	
		
		User portalUser = PortalUserModel.CreatePortalUser(
			portalContactId, 
			ProfileModel.AppearPortalFprOnlySubmitterProfile);
		System.assertNotEquals(null, portalUser);
		System.assertNotEquals(null, portalUser.id);
		
		//if the user exists already - make sure it is returned correctly
		//instead of creating a new one
		User portalUser2 = PortalUserModel.CreatePortalUser(
			portalContactId, 
			ProfileModel.AppearPortalFprOnlySubmitterProfile);
		System.assertNotEquals(null, portalUser2);
		System.assertEquals(portalUser2.id, portalUser.id);
		
		//test if I can create another non-setup objecg
		//Id portalContactId2 = createData();		
		//System.assertNotEquals(null, portalContactId2);
	}

	private static Id createData() {
		//https://developer.salesforce.com/forums?id=906F000000091RxIAI
		UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
		System.assertNotEquals(null, portalRole.Id);
		
		Profile sysAdminProfile = [
			Select Id 
			from Profile 
			where name = 'System Administrator'
		];
		System.assertNotEquals(null, sysAdminProfile);
		System.assertNotEquals(null, sysAdminProfile.Id);
		
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		User portalAccountOwner1  = null; 
        System.runAs ( thisUser ) {
		
			portalAccountOwner1 = new User(
				Username = System.now().millisecond() + 'test2@test.com',
			   	Alias = 'batman',
				Email='bruce.wayne@wayneenterprises.com',
				EmailEncodingKey='UTF-8',
				Firstname='Bruce',
				Lastname='Wayne',
				LanguageLocaleKey='en_US',
				LocaleSidKey='en_US',
				TimeZoneSidKey='America/Chicago'
			);
	
	
			portalAccountOwner1.UserRoleId = portalRole.Id;
			portalAccountOwner1.ProfileId = sysAdminProfile.id;
			Database.insert(portalAccountOwner1);
        }
        
		Account portalAccount1 = null; 
		System.runAs(portalAccountOwner1) {
			//Create account
			portalAccount1 = new Account(
				Name = 'TestAccount',
				OwnerId = portalAccountOwner1.Id
			);
			Database.insert(portalAccount1);
		} 
		System.assertNotEquals(null, ProfileModel.AppearPortalFprOnlySubmitterProfile);
		
		Contact c = null;
		System.runAs(portalAccountOwner1) {
			c = new contact(
				email='testPortalUser@amgen.com',
				FirstName='testFirstName',
				LastName='testLastName',
				AccountId=portalAccount1.Id);
			insert c;	
		}
		return c.id;
	}
	
	@IsTest
	public static void negUnitTest1() {
		User nullPortalUser = PortalUserModel.CreatePortalUser(
			null, 
			ProfileModel.AppearPortalFprOnlySubmitterProfile);
		System.assertEquals(null, nullPortalUser);		
	}

	@IsTest
	public static void negUnitTest2() {
		Id portalContactId = createData();		
		User nullProfilePortalUser = PortalUserModel.CreatePortalUser(
			portalContactId, 
			null);
		System.assertEquals(null, nullProfilePortalUser);	
	}
	

}