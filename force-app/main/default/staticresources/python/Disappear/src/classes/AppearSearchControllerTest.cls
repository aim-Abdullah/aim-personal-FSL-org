@IsTest
public class AppearSearchControllerTest {

	@IsTest
	public static void unitTest() {
		AppearSearchController SearchCtrl = new AppearSearchController();
		System.assertNotEquals(null, SearchCtrl);

		System.assertNotEquals(null, SearchCtrl.PcSubMenus);		
		System.assertNotEquals(null, SearchCtrl.PcTiles);
		System.assertNotEquals(null, SearchCtrl.TileBar);
		System.assertNotEquals(null, SearchCtrl.redirectSearch());
		
		
		List<String> ParamSubMenus = new List<string>();
		ParamsubMenus.add(null);
		ParamsubMenus.add(AppearConstants.SearchSubMenuSuggestions );
		ParamsubMenus.add(AppearConstants.SearchSubMenuFprRequests );
		ParamsubMenus.add(AppearConstants.SearchSubMenuPublications );
		ParamsubMenus.add(AppearConstants.SearchSubMenuContacts );
		ParamsubMenus.add(AppearConstants.SearchSubMenuUsers );
		
		
		List<String> ParamTiles = new List<string>();
		ParamTiles.add(null);
		ParamTiles.add(AppearConstants.SearchFilterTile );
		ParamTiles.add(AppearConstants.SearchRecentTile );
		ParamTiles.add(AppearConstants.SearchMyFavTile );
		ParamTiles.add(AppearConstants.SearchMyTeamTile );
		ParamTiles.add(AppearConstants.SearchMyDeptTile );
		
		
		for(string paramSubMenu : ParamSubMenus){
			for ( string paramTile : ParamTiles){
				SearchCtrl = new AppearSearchController(paramSubMenu, paramSubMenu);
				System.assertNotEquals(null, SearchCtrl);
			}			
		}
	}

}