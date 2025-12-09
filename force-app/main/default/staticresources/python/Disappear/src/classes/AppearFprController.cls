public with sharing class AppearFprController extends AppearBaseController {
    
    //ToDo - need to combine with AppearPubExtension
    //used in AppearPubList
    
    public AppearUrlModel UrlModel;
    
    //sub menus
    public boolean selectSuggestionSubMenu{get;set;}
    public boolean selectPlanSubMenu{get;set;}
    public boolean selectExecuteSubMenu{get;set;}
    public boolean selectReviewSubMenu{get;set;}
    public boolean selectSubmitSubMenu{get;set;}

    //tiles
    public boolean showPubTiles {get;set;}

    //views 
    public boolean showPubNoActiveView{get;set;}
    public boolean showPubActionView{get;set;}
    
    public AppearFprController() {
        setupPlatformConsole();
    }
    
    private void setupPlatformConsole() {   
        //load publication
        
        //find stage / state of publication 
        
        //find user info / role 
        
        unSelectAllSubMenus();
        hideAllViews();
        
        if ( hasActivePub){
            String ActivePubStage = ActivePub.PubStage;
            String msg = '*** AppearFprController::setupPlatformConsole  ' + 'PubStage = ' + ActivePubStage;
            System.Debug(msg);
            
            //can't use PubDebug- DML error cannot write to DB in constructor
            //PubDebug(ActivePub, 'AppearFprController::setupPlatformConsole', 'PubStage = ' + ActivePubStage);
            
            if ( ActivePubStage == null){
                System.Debug('*** PubStage is Null - while CurrentStatus = ' + ActivePub.CurrentStatus);
            } else if ( ActivePubStage == AppearConstants.PubSubMenuPlan){
                selectPlanSubMenu = true;
            } else if ( ActivePubStage == AppearConstants.PubSubMenuExecute){
                selectExecuteSubMenu = true; 
            } else if ( ActivePubStage == AppearConstants.PubSubMenuReview){
                selectReviewSubMenu = true;
            } else if ( ActivePubStage == AppearConstants.PubSubMenuSubmit){ 
                selectSubmitSubMenu = true;
            } else {
                selectPlanSubMenu = true;
            }   
            
            showPubTiles = true;
                    
        } else {
            //no active pub
            showPubNoActiveView = true;   
            
            showPubTiles = false;
        }

    }
    
	public static string getShowSharingDetailsUsers() {
    	KeyValueSettings__c result = KeyValueSettingsModel.GetKey('showSharingDetailsUsers');
  		if ( result == null) {
  			return null;
  		} else {
    		return result.Value__c;
  		}
    }
    
    public boolean showSharingDetails {
    	get {
    		
    		string showSharingUsers = getShowSharingDetailsUsers();
    		
    		if ( ProfileModel.isSysAdmin || ProfileModel.isAppearHyperCare  || ( showSharingUsers <> null && showSharingUsers.contains(UserInfo.getUserName()))) {
    			return true;
    		} else {
    			return false;
    		}
    	}
    }

    
    public void unSelectAllSubMenus() {
        selectSuggestionSubMenu = false;
        selectPlanSubMenu = false;
        selectExecuteSubMenu = false;
        selectReviewSubMenu = false;
        selectSubmitSubMenu = false;
    }

        
    public void hideAllViews() {
        showPubNoActiveView = false;
    }

    public string ParamMenu {
        get {
            if (ParamSubMenu == NULL) {
                return AppearConstants.PubSubMenuPlan;
            } else {
                return ParamSubMenu;
            }
            
        }
    }
    public string currentTab = 'Pub';
    
    public PcSubMenu[] PcSubMenus {
        get {
            return PcSubMenu.PubSubMenu(
                selectSuggestionSubMenu,
                selectPlanSubMenu,
                selectExecuteSubMenu, 
                selectReviewSubMenu,
                selectSubmitSubMenu); 
        }
    }  
    
    public PcTile[] PcTiles {
        get{
            PcTile[] PcTiles = AppearTiles.FprTiles(ParamMenu, ActivePubId); 
            return PcTile.SelectTile(PcTiles,ParamTile);
        }
    }
    public PcTileBar TileBar {
        get {
            return new PcTileBar(PcTiles);
        }
    } 
}