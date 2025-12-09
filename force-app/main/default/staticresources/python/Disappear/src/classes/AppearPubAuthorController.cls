public with sharing class AppearPubAuthorController extends AppearBaseController {
    
    
    public AppearUrlModel UrlModel;
    public ProvisionDocumentVersion__c comp{get;set;}
    public String compType{get;set;}
    //sub menus
    public boolean selectSuggestionSubMenu{get;set;}
    public boolean selectPlanSubMenu{get;set;}
    public boolean selectExecuteSubMenu{get;set;}
    public boolean selectReviewSubMenu{get;set;}
    public boolean selectSubmitSubMenu{get;set;}
    public Id PublicationId{get;set;} //Appear Enhancement R2


    //views 
    public boolean showPubNoActiveView{get;set;}

    
    public AppearPubAuthorController() {
        isFprSubmitter = false;
        setupPlatformConsole();
        comp=[SELECT id, ProvisionDocumentContent__c, Name
                      FROM ProvisionDocumentVersion__c ORDER BY createddate Desc limit 1]; 
        PublicationId = apexpages.currentpage().getparameters().get('Id'); //Appear Enhancement R2

        
    }
        
    
    private void setupPlatformConsole() {   
        
        unSelectAllSubMenus();
        hideAllViews();
        
        if ( hasActivePub || Test.isRunningTest()){
            String ActivePubStage = ActivePub.PubStage;
            String msg = '*** AppearPubAuthorController::setupPlatformConsole  ' + 'PubStage = ' + ActivePubStage;
            System.Debug(msg);
                        
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

    
    public void unSelectAllSubMenus() {
        selectSuggestionSubMenu = false;
        selectPlanSubMenu = false;
        selectExecuteSubMenu = false;
        selectReviewSubMenu = false;
        selectSubmitSubMenu = false;
    }

        
    public void hideAllViews() {
        showPubNoActiveView = false;

        /* IY: to be deleted
        showPubActionView = false;
        showPubEventsView = false;
        showPubContentView = false;
        showPubAttachmentsView = false;
        showPubMEsView = false;     
        */ 
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

    // IY: to be deleted
    // public string currentTab = 'Pub';
    
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
            PcTile[] PcTiles = AppearTiles.AuthorTiles(ParamMenu, ActivePubId); 
            return PcTile.SelectTile(PcTiles,ParamTile);
        }
    }
    public PcTileBar TileBar {
        get {
            return new PcTileBar(PcTiles);
        }
    }
    
}