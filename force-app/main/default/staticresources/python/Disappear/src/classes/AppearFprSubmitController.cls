public with sharing class AppearFprSubmitController extends AppearBaseController {
    
    //ToDo - need to combine with AppearPubExtension
    //used in AppearPubList
    
    public AppearUrlModel UrlModel;
    
    //sub menus
    public boolean selectSuggestionSubMenu{get;set;}
    public boolean selectPlanSubMenu{get;set;}
    public boolean selectExecuteSubMenu{get;set;}
    public boolean selectReviewSubMenu{get;set;}
    public boolean selectSubmitSubMenu{get;set;}

    //views 
    public boolean showPubNoActiveView{get;set;}
    public boolean showPubActionView{get;set;}
    public boolean showPubEventsView{get;set;}
    public boolean showPubContentView{get;set;}
    public boolean showPubAttachmentsView{get;set;}
    public boolean showPubMEsView{get;set;}
    
    public AppearFprSubmitController() {
    	isFprSubmitter = true;
        setupPlatformConsole();
    }
    
    private void setupPlatformConsole() {   
        
        unSelectAllSubMenus();
        hideAllViews();
        
        if ( hasActivePub || Test.isRunningTest()){
            String ActivePubStage = ActivePub.PubStage;
            String msg = '*** AppearFprSubmitController::setupPlatformConsole  ' + 'PubStage = ' + ActivePubStage;
            System.Debug(msg);
            
            //can't use PubDebug- DML error cannot write to DB in constructor
            //PubDebug(ActivePub, 'AppearFprSubmitController::setupPlatformConsole', 'PubStage = ' + ActivePubStage);
            
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
                    
        } else {  
            //no active pub
            showPubNoActiveView = true;            
        }

    }

    
    private void unSelectAllSubMenus() {
        selectSuggestionSubMenu = false;
        selectPlanSubMenu = false;
        selectExecuteSubMenu = false;
        selectReviewSubMenu = false;
        selectSubmitSubMenu = false;
    }

        
    private void hideAllViews() {
        showPubNoActiveView = false;
        showPubActionView = false;
        showPubEventsView = false;
        showPubContentView = false;
        showPubAttachmentsView = false;
        showPubMEsView = false;     
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
            PcTile[] PcTiles = AppearTiles.FprSubmitterTiles(ParamMenu, ActivePubId); 
            return PcTile.SelectTile(PcTiles,ParamTile);
        }
    }
    public PcTileBar TileBar {
        get {
            return new PcTileBar(PcTiles);
        }
    }
    
}