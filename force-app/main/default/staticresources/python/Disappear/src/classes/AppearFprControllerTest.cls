@IsTest
public class AppearFprControllerTest {

	@IsTest
	public static void unitTest() {		
		Publication__c  newPub = UnitTestData.PublicationNew('Fpr Controller Pub');
		
		Test.setCurrentPageReference(new PageReference('Page.AppearFpr')); 
		System.currentPageReference().getParameters().put(AppearConstants.PUBID, newPub.id);		
		System.currentPageReference().getParameters().put(AppearConstants.TILE, AppearConstants.FprDetailsTile);
				
		AppearFprController fprController = new AppearFprController();
		 
		System.assertNotEquals(null, fprController);
		System.assertNotEquals(null, AppearBaseController.AmgenAppearTitle);
		System.assertEquals(true, AppearBaseController.AppearShowChatter);
		System.assertNotEquals(null, fprController.getException('test'));
		fprController.AppearAddErrorMessage('test');
		System.assertNotEquals(null, fprController.RedirectHomeTab());
		System.assertNotEquals(null, fprController.RedirectSearchTabFprRequest());
		System.assertNotEquals(null, fprController.RedirectSearchTabPub());
		

		System.assertNotEquals(null, fprController.ActivePubId);
		System.assertNotEquals(null, fprController.ActivePub);
		System.assertNotEquals(null, fprController.PcSubMenus);		
		System.assertNotEquals(null, fprController.PcTiles);
		System.assertNotEquals(null, fprController.TileBar);
		
		fprController.hideAllViews();
		fprController.unSelectAllSubMenus();  
	}

}


/*  
		ParamTiles.add( AppearConstants.FprDetailsTile);
		ParamTiles.add( AppearConstants.FprPreFprTile); 
		ParamTiles.add( AppearConstants.PubStudiesTile);
		ParamTiles.add( AppearConstants.FprOtherDetailsTile);
		ParamTiles.add( AppearConstants.FprAttachmentsTile);
		ParamTiles.add( AppearConstants.FprPubsForReviewTile);
*/