@IsTest
public class AppearFprSubmitControllerTest {
	
	@IsTest
	public static void unitTest() {
		prepareData();		
		
		AppearFprSubmitController pub = new AppearFprSubmitController();
		
		System.assertNotEquals(null, pub.PcSubMenus);
		
		PcTileBar tileBar = pub.TileBar;
		System.assertNotEquals(null, tileBar);
		System.assertNotEquals(-1, tileBar.maxLabelLength);		
	}
	  
	private static void prepareData() {
		UnitTestData.PublicationNew('publication 1');
	}
}