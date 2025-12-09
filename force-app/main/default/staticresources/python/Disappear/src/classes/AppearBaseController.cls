public virtual class AppearBaseController {
	
	//default constructor  
	public AppearBaseController(){
		
	}
	
	//constructor for unit test
	public AppearBaseController(string ParamSubMenu, string ParamTile){
		this.ParamSubMenu = ParamSubMenu;
		this.ParamTile = ParamTile;
	}

	public static string AmgenAppearTitle {
		get {
			return 'APPEAR';
		} 
	}
	public static boolean AppearShowChatter {
		get {
			return true;
			//return false;
		} 
	}

	public static boolean DebugVF {
		get {
			return true;
		} 
	}
	
    private static Map<String, String> pPageParameters = null;
    public static Map<String, String> PageParameters {
    	get {
    		if ( pPageParameters == null){
    			pPageParameters = System.currentPageReference().getParameters();
    		}
    		return pPageParameters;
    	}
    }
    
    private string pParamTile = null;
    public string ParamTile {
    	get {
    		if (pParamTile == null) {
    			pParamTile = AppearBaseController.PageParameters.get(AppearConstants.TILE);
    		}
    		return pParamTile;
    	}
    	set{
    		pParamTile = value;
    	}
    }
    
    //return null if undefined - the controller will pick by default
    private string pParamSubMenu = null;
    public string ParamSubMenu {
    	get {
    		if (pParamSubMenu == null){
    			pParamSubMenu = AppearBaseController.PageParameters.get(AppearConstants.SUBMENU);
    		}
    		return pParamSubMenu;
    	}
    	set{
    		pParamSubMenu = value;
    	}
    }
    
    protected string pPubId = null;
    public string ActivePubId {
    	get {
    		if ( pPubId == null){
    			string paramPubId = AppearBaseController.PageParameters.get(AppearConstants.PUBID);
    			if ( paramPubId == null) {
    				//try to get the last Active Pub from Custom Settingh
    				pPubId = UserPrefModel.ActivePub;
    			} else {
    				pPubId = paramPubId;
    			}
    			
    			List<Publication__c> publist = null; 
    			if (ProfileModel.isAppearPortalPubAuthor || ProfileModel.isAppearFprOnlySubmitter){
    				// pub author community use no sharing rule. 
    				publist = PubAuthorModelNoSharing.checkPublicationId(pPubId); 
    			} else {
    				publist= [select id, isDeleted from Publication__c where id = :pPubId];
    			}
    			if (publist.size() ==1  && publist[0].isDeleted == false) {
    				//it is still a valid pub
    			} else {
    				pPubId = null;
    			}
    		}
    		return pPubId;
    	}
    }
	
    //not allowed to save ActivePubId in constructor
	public void saveActivePub() {
		UserPrefModel.ActivePub = pPubId;
	}	
    	
	public PageReference saveActivePubRedirect() {
		saveActivePub();
		
		set<string> TileAccessList = ProfileTabModel.PubTileAccessList;
		
		if ( !TileAccessList.contains(AppearConstants.PubDetailsTile)) {			
			if (ProfileModel.isAppearFprOnlySubmitter) { //goto fpr submitter detail tile
				PageReference fprOnlyRef = new PageReference(AppearUrlModel.AppearFprSubmitterMenuUrl(ParamSubMenu, AppearConstants.FprDetailsTile, pPubId));
				fprOnlyRef.setredirect(true);
				return fprOnlyRef;
			} else { //goto fpr detail tile
				PageReference fprTabRef = new PageReference(AppearUrlModel.AppearFprMenuUrl(ParamSubMenu, AppearConstants.FprDetailsTile, pPubId));
				fprTabRef.setredirect(true);
				return fprTabRef;				
			}
		}

		return null;		
	}
    
    public boolean hasActivePub{ 
    	get {
    		if ( ActivePubId != null){
    			return true;
    		} else {
    			return false;
    		}
    	}
    }
    
    public boolean canEditActivePub{
    	get {
    		if ( !hasActivePub) {
    			return false;
    		}
    		if ( ActivePub.pubRecord.createdById == UserInfo.getUserId() ) {
    			return true;
    		} 
    		// for now - by default == false
    		return false;
    	} 
    }
    protected boolean isFprSubmitter = false;
    private  AppearPubModel pActivePub = null;
    public AppearPubModel ActivePub {
    	get {
    		if (pActivePub == null) {
    			pActivePub = new AppearPubModel(ActivePubId,ParamTile,ParamSubMenu,isFprSubmitter);
    		} 
    		System.Debug(pActivePub.PubStatus); 
    		return pActivePub; 
    		 
    	}
    }
    
	/////////////////////////////////////////////////////////
	//  common nav
	/////////////////////////////////////////////////////////
	
	public PageReference RedirectHomeTab() {
		PageReference homeTab = new PageReference(AppearUrlModel.AppearHomePartialUrl);
		homeTab.setRedirect(true);  
		return homeTab;
	}   

	public PageReference RedirectSearchTabFprRequest() {
		String searchTabFprRequestUrl = AppearUrlModel.AppearSearchUrl;
		PageReference searchTab = new PageReference(searchTabFprRequestUrl);
		searchTab.setRedirect(true);
		return searchTab;
	} 

	public PageReference RedirectSearchTabPub() {
		String searchTabPubUrl = AppearUrlModel.AppearSearchUrl;
		PageReference searchTab = new PageReference(searchTabPubUrl);
		searchTab.setRedirect(true);
		return searchTab;
	} 
	
	/////////////////////////
	//  Util
	
	
	public Exception getException(String message) {
		return new AppearException(message);
	}
	
	
	public void AppearAddErrorMessage(string message){
		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, message));
	}
    
}