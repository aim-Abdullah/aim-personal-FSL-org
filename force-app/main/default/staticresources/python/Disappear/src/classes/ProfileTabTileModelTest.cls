@IsTest
public class ProfileTabTileModelTest {
	private static void createData() {
        ProfileTabModelData.createData();
        ProfileTabTileModelData.createData();
	}
	
    @IsTest
    public static void UnitTest() {
    	createData();
    	
    	ProfileTab__c profileTab = [select id from ProfileTab__c limit 1];
    	System.assertNotEquals(0, ProfileTabTileModel.getProfileTabTile(profileTab).size());
        System.assertNotEquals(0, ProfileTabTileModel.ProfileTabTileList.size());
      
        System.assertNotEquals(null, ProfileTabTileModel.ProfileTabTileNameMap.get('Details'));      
        System.assertNotEquals(null, ProfileTabTileModel.ProfileTabTileNameMap.get('Pub Details'));
    }
}