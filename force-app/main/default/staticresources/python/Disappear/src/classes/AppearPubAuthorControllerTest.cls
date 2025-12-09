@IsTest
public class AppearPubAuthorControllerTest {

	@IsTest
	public static void unitTest() {		
		Publication__c  newPub = UnitTestData.PublicationNew('Author Controller Pub');
		
		Test.setCurrentPageReference(new PageReference('Page.appearpubauthordashboard')); 
		System.currentPageReference().getParameters().put(AppearConstants.PUBID, newPub.id);		
		System.currentPageReference().getParameters().put(AppearConstants.TILE, AppearConstants.AuthorPubDetailsTile);
		ProvisionDocumentVersion__c provdoc = new ProvisionDocumentVersion__c();
		Provdoc.ProvisionDocumentContent__c ='testing123';
		insert provdoc;
		AppearPubAuthorController authorController = new AppearPubAuthorController();
		 
		System.assertNotEquals(null, authorController);
		System.assertNotEquals(null, AppearBaseController.AmgenAppearTitle);
		System.assertEquals(true, AppearBaseController.AppearShowChatter);
		authorController.AppearAddErrorMessage('test');
		System.assertNotEquals(null, authorController.RedirectHomeTab());
		
		System.assertNotEquals(null, authorController.ActivePubId);
		System.assertNotEquals(null, authorController.ActivePub);
		System.assertNotEquals(null, authorController.ParamMenu);	
		System.assertNotEquals(null, authorController.PcSubMenus);		
		System.assertNotEquals(null, authorController.PcTiles);
		System.assertNotEquals(null, authorController.TileBar);
		
		authorController.hideAllViews();
		authorController.unSelectAllSubMenus();  
		
	}

}