@IsTest
public class AppearPubControllerTest {
    
    @IsTest
    public static void unitTest() {
        prepareData();      
        
        AppearPubController pub = new AppearPubController();
        
        System.assertNotEquals(null, pub.PcSubMenus);
        string s;
        boolean b;
        PcTileBar tileBar = pub.TileBar;
        System.assertNotEquals(null, tileBar);
        System.assertEquals(-1, tileBar.maxLabelLength); //no permissions
        AppearPubController.getShowSharingDetailsUsers();
        AppearPubController.setShowSharingDetailsUsers(s);
        
        
    }
    @IsTest
    public static void unitTest2() {
        prepareData(); 
        Publication__c publication=UnitTestData.newPublication('publication 1');
        ApexPages.StandardController sc = new ApexPages.StandardController(publication);
        AppearPubController pub = new AppearPubController(sc);
        
        System.assertNotEquals(null,pub.showSharingDetails);
        System.assertNotEquals(null,pub.isTileDetails);
        System.assertNotEquals(null,pub.displayAdminOnly);
        System.assertNotEquals(null,pub.is626Profile);
    }
    
    private static void prepareData() {
        UnitTestData.PublicationNew('publication 1');
    }
}