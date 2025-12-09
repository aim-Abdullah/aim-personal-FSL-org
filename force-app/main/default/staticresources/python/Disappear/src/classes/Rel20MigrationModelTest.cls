@IsTest
public class Rel20MigrationModelTest {
	@IsTest 
	//Hello Sesha
	public static void unitTestStaticRoutines() {
		createDataFprSubmitter();
		System.assertNotEquals(null, Rel20MigrationModel.FprSubmittersUsers);
		System.assertNotEquals(0, Rel20MigrationModel.FprSubmittersUsers.size());
		
		System.assertNotEquals(null, Rel20MigrationModel.R20MigList);
		System.assertEquals(0, Rel20MigrationModel.R20MigList.size());
		
		//populateFprSubmitters into the R20mig__c table
		Rel20MigrationModel.populateFprSubmitters();
		
		
		Rel20MigrationModel.truncateAllRecords();
		System.assertEquals(0, Rel20MigrationModel.R20MigList.size());
	}

	private static void createDataFprSubmitter() {
		//create Contact with FromUserProfile = APPEAR FPR Only Submitter
		
		Contact c = AppearContactModel.createContactAndUser(
			'contactLastName', 'contactFirstName', 'contactEmail@amgen.com', 
			12345678, ProfileModel.AppearFprOnlySubmitterProfile);
				
		System.assertNotEquals(null, c.id);
	}
}