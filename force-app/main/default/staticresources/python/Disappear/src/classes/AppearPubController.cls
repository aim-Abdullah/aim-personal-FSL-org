public class AppearPubController extends AppearBaseController {
        
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
        public boolean showPubEventsView{get;set;}
        public boolean showPubContentView{get;set;}
        public boolean showPubAttachmentsView{get;set;}
        public boolean showPubMEsView{get;set;}

 
        public AppearPubController(ApexPages.StandardController stdController) {        
                if (stdController != null) {    
                        Id currentPubId = stdController.getId();
                        
                        if ( currentPubId == null){
                                AppLogModel.LogInfo('AppearPubController::constructor for extension', 'CurrentPidId == null.  Need to redirect to PubList');  //pubid = null - cannot log
                                //AppLogModel.flushLogs();
                        } else {
                                pPubId = currentPubId;
                                setupPlatformConsole();
            
                                
                                if ( ActivePub.isEnbrel  && AppearContactModel.isCurrentUserEnbrelRestricted) {
                                    AppLogModel.LogInfo('AppearPubController::constructor for extension', 'Current user '+UserInfo.getName()+'is enbrel restricted.  No Access to Pub', currentPubId);  //pubid = null - cannot log
                                    showPubNoActiveView = true;
                                    isEnbrelRestricted = true;
                                } else {
                                    isEnbrelRestricted = false;
                                }
                        }
                } 
        }
        
        //AppearPubController.setShowSharingDetailsUsers('bus3admin@amgen.com.dev11a;bus8admin@amgen.com.dev11a');
        public static void setShowSharingDetailsUsers(string showSharingDetailsUsers){
            if ( showSharingDetailsUsers <> null){
                KeyValueSettingsModel.SetKey('showSharingDetailsUsers', showSharingDetailsUsers);
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
        
        public boolean isEnbrelRestricted { get; private set;}
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
        
        public boolean showStatusAdmin {
            get {
                return showSharingDetails;
            }
        }
        

        public AppearPubController() {
            
            setupPlatformConsole();
            
            
            if ( ActivePub.isEnbrel  && AppearContactModel.isCurrentUserEnbrelRestricted) {
                showPubNoActiveView = true;
                isEnbrelRestricted = true;
            } else {
                isEnbrelRestricted = false;
            }

        }  

        


        private void setupPlatformConsole() {   
                //load publication
                
                //find stage / state of publication 
                
                //find user info / role
                
                unSelectAllSubMenus();
                hideAllViews();
                
                if ( hasActivePub || Test.isRunningTest()){
                        String ActivePubStage = ActivePub.PubStage;
                        String msg = '*** AppearPubController::setupPlatformConsole  ' + 'PubStage = ' + ActivePubStage;
                        System.Debug(msg);
                        
                        //can't use PubDebug- DML error cannot write to DB in constructor
                        //PubDebug(ActivePub, 'AppearPubController::setupPlatformConsole', 'PubStage = ' + ActivePubStage);                                       
                        
                        if ( ActivePubStage == null){
                                System.Debug('*** PubStage is Null - while CurrentStatus = ' + ActivePub.CurrentStatus);
                        } else if ( ActivePubStage == AppearConstants.PubSubMenuSuggest){ 
                                selectSuggestionSubMenu = true;
                        } else if ( ActivePubStage == AppearConstants.PubSubMenuPlan){
                                selectPlanSubMenu = true;
                        } else if ( ActivePubStage == AppearConstants.PubSubMenuExecute){
                                selectExecuteSubMenu = true; 
                        } else if ( ActivePubStage == AppearConstants.PubSubMenuReview){
                                selectReviewSubMenu = true;
                        } else if ( ActivePubStage == AppearConstants.PubSubMenuFprOnly){ 
                                selectReviewSubMenu = true;                         
                        } else if ( ActivePubStage == AppearConstants.PubSubMenuSubmit){ 
                                selectSubmitSubMenu = true;
                        } 
                        
                        
                        ///////////////////////////////
                        //find requested tile 
                        string reqTile = ParamTile;
                        if (reqTile == null){                            
                                //for prototype - use Pub Events
                                reqTile = AppearConstants.PubDetailsTile;
                        }
                        showPubTiles = true;
                        if ( ParamTile == null){
                                showPubEventsView = true;
                        } else if ( ParamTile == AppearConstants.PubSubMenuSuggest){
                                showPubActionView = true;
                        } else if ( ParamTile == AppearConstants.PubSubMenuPlan){
                                showPubActionView = true;
                        } else if ( ParamTile == AppearConstants.PubSubMenuExecute){
                                showPubEventsView = true;
                        } else if ( ParamTile == AppearConstants.PubSubMenuReview){
                                showPubContentView = true;
                        } else if ( ParamTile == AppearConstants.PubSubMenuSubmit){ 
                                showPubAttachmentsView = true;
                        } else {
                                showPubEventsView = true;
                        }
                                        
                } else {
                        //no active pub
                        showPubNoActiveView = true;
                        
                        showPubTiles = false;
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
                        PcTile[] PcTiles = AppearTiles.PubTiles(ParamMenu, ActivePubId); 
                        return PcTile.SelectTile(PcTiles,ParamTile);
                }
        }
        public PcTileBar TileBar {
                get {
                        return new PcTileBar(PcTiles);
                }
        } 
        
        public Boolean isTileDetails {
                get {
                    
                        if( TileBar == null || TileBar.ActiveTile == null) {
                            return false;
                        }
                        return TileBar.ActiveTile.PcTileId  == AppearConstants.PubDetailsTile;
                }
        }
        
        private boolean pDisplayAdminOnlyInit = false;
        private boolean pDisplayAdminOnly = false;
        public boolean displayAdminOnly {
            get {
                if ( !pDisplayAdminOnlyInit) {
                    pDisplayAdminOnlyInit = true;
                    if (ProfileModel.isAppearBusinessAdmin || ProfileModel.isSysAdmin) {
                        pDisplayAdminOnly = true;
                    } else {
                        pDisplayAdminOnly = false;
                    }
                }
                return pDisplayAdminOnly;
            }
        }
        
        public boolean is626Profile {
            get{
                return ProfileModel.isAppear626;
            }
        }

}