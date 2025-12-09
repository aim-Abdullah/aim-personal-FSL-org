global class AppearSearchController extends AppearBaseController {


	
	public AppearSearchController() {
		super();
		SetupSubMenu();
		SetupParamTile();
	}
	
	private string pPubIdPrefix;
	public String pubIdPrefix {
		get{
			if (pPubIdPrefix == null) {
				Schema.DescribeSObjectResult dsr = Publication__c.SObjectType.getDescribe();
				
				pPubIdPrefix = dsr.getKeyPrefix();
			}
			return pPubIdPrefix;
		}
	}

	//unit test entry
	public AppearSearchController(string ParamSubMenu, string ParamTile) {
		super(ParamSubMenu, ParamTile);
		SetupSubMenu();
		SetupParamTile(); 
	}
	
	public void SetupSubMenu() {
		///////////////////////////////
		//find requested subMenu
		string reqSubMenu = ParamSubMenu;
		if (reqSubMenu == null){
			//for prototype - use planning
			reqSubMenu = AppearConstants.SearchSubMenuPublications;  
		}
		unSelectAllSubMenus();
		if ( reqSubMenu == null){
			selectSuggestionSubMenu = true;
		} else if ( reqSubMenu == AppearConstants.SearchSubMenuSuggestions){
			selectSuggestionSubMenu = true;
		} else if ( reqSubMenu == AppearConstants.SearchSubMenuFprRequests){
			selectFprRequestSubMenu = true;
		} else if ( reqSubMenu == AppearConstants.SearchSubMenuPublications){
			selectPublSubMenu = true;
		} else if ( reqSubMenu == AppearConstants.SearchSubMenuContacts){ 
			selectContactSubMenu = true;
		} else if ( reqSubMenu == AppearConstants.SearchSubMenuUsers){ 
			selectUserSubMenu = true;
		} else {
			selectSuggestionSubMenu = true;
		}		
	}
	 
	public void SetupParamTile() {
		if ( ParamTile == null){
			showSearchFilterView = true;
		} else if ( ParamTile == AppearConstants.SearchFilterTile){
			showSearchFilterView = true;
		} else if ( ParamTile == AppearConstants.SearchRecentTile){
			showSearchRecentView = true;
		} else if ( ParamTile == AppearConstants.SearchMyFavTile){ 
			showSearchMyFavView = true;
		} else if ( ParamTile == AppearConstants.SearchMyTeamTile){
			showSearchMyTeamView = true;
		} else if ( ParamTile == AppearConstants.SearchMyDeptTile){
			showSearchMyDeptView = true;
		} else {
			showSearchFilterView = true;
		}		
	}
	
	
	public boolean selectSuggestionSubMenu{get;set;}
	public boolean selectFprRequestSubMenu{get;set;}
	public boolean selectPublSubMenu{get;set;}
	public boolean selectContactSubMenu{get;set;}
	public boolean selectUserSubMenu{get;set;}
	
	private void unSelectAllSubMenus() {
		selectSuggestionSubMenu = false;
		selectFprRequestSubMenu = false;
		selectPublSubMenu = false;
		selectContactSubMenu = false;
		selectUserSubMenu = false;
	}
	
	public boolean showSearchFilterView{get;set;}
	public boolean showSearchRecentView{get;set;}
	public boolean showSearchMyFavView{get;set;}
	public boolean showSearchMyTeamView{get;set;}
	public boolean showSearchMyDeptView{get;set;}
		
	/*
	private void hideAllViews() {
		showSearchFilterView = false;
		showSearchRecentView = false;
		showSearchMyFavView = false;
		showSearchMyTeamView = false;
		showSearchMyDeptView = false;	
	}
	*/
	

	public string ParamMenu {
    	get {
    		if (ParamSubMenu == NULL) {
    			return AppearConstants.SearchSubMenuSuggestions;
    		} else {
    			return ParamSubMenu;
    		}
    		
    	}
    }
	
	public string currentTab = 'Search';
	
	public PcSubMenu[] PcSubMenus {  
		get {
			return PcSubMenu.SearchSubMenu(
				selectSuggestionSubMenu,  
				selectFprRequestSubMenu,
				selectPublSubMenu, 
				selectContactSubMenu,
				selectUserSubMenu); 
		}
	}  
	 
	public PcTile[] PcTiles {
		get {
			PcTile[] PcTiles = AppearTiles.SearchTiles(ParamMenu);
			return PcTile.SelectTile(PcTiles,ParamTile);
		}
	} 
	
	public PcTileBar TileBar {
		get {
			return new PcTileBar(PcTiles);
		}
	}
	
	public PageReference redirectSearch() {		
		PageReference searchPage = new PageReference(URL.getSalesforceBaseUrl()+'/_ui/search/ui/UnifiedSearchResults?searchType=2&str=pub#!/fen=a00&initialViewMode=detail');
		searchPage.setRedirect(true);
	
		return searchPage;
	}

}