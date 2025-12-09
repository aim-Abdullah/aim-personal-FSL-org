public with sharing class ProfileTabTileModel {
    //with sharing - System Admin RW  / Rest of Profile are RO
  
    private static List<ProfileTabTile__c> pProfileTabTileList = null;
    public static List<ProfileTabTile__c> ProfileTabTileList{
        get{
            if(pProfileTabTileList == null){
              pProfileTabTileList = getAllProfileTabTileList();
            }               
        return pProfileTabTileList;
        }
    }  
    
    private static Map<String, ProfileTabTile__c> pProfileTabTileNameMap = null;
    public static Map<String, ProfileTabTile__c> ProfileTabTileNameMap{
        get {
            if (pProfileTabTileNameMap == null){
                pProfileTabTileNameMap = getProfileTabTileMapByName();
            }
            return pProfileTabTileNameMap;
        }
    }
   
    public static Map<String, ProfileTabTile__c> getProfileTabTileMapByName() {
        Map<String, ProfileTabTile__c> result = new Map<String, ProfileTabTile__c>();
        for(ProfileTabTile__c pProfileTabTile : ProfileTabTileList){
            result.put(pProfileTabTile.Name, pProfileTabTile );
        }

        return result;
    }
    //DEFECT 475 Added additional profile specifically for read-only users
      
    public static List<ProfileTabTile__c> getAllProfileTabTileList(){
        List<ProfileTabTile__c> result = [
            select id, Name, Profile_Tab__c,
            APPEAR_Business_Admin__c, APPEAR_FPRC__c, 
            APPEAR_FPR_Only_Submitters__c, APPEAR_GPPL__c,
            APPEAR_International_FPRC__c, APPEAR_Pub_Team__c,
            APPEAR_Reviewers__c, APPEAR_Writing__c,
            System_Admin__c, APPEAR_626__c, APPEAR_Read_Only__c,
            APPEAR_External_Writer__c,APPEAR_Functional_Pub_Team__c// Added as part of Appear Enhancement Release 1
            From ProfileTabTile__c
            order by Name  
        ];
        return result;
    }
    
    public static Set<String> getProfileTabTile(ProfileTab__c profileTab) {
        
        
        //find all profileTabTiles that belong to this Profile tab
        List<ProfileTabTile__c> tabs = new List<ProfileTabTile__c>();
        for(ProfileTabTile__c tab : ProfileTabTileList){
            if(tab.Profile_Tab__c == profileTab.id) {
                tabs.add(tab);
            }
        }
        
        //Find the current profile name
        string CurrentProfileName = ProfileModel.CurrentProfileName;
        Set<string> result = new Set<string>();
        for(ProfileTabTile__c tab : tabs) {
            
            if (tab.APPEAR_Pub_Team__c && ProfileModel.isAppearPubTeam) {
                result.add(tab.Name);
            }
            if (tab.APPEAR_GPPL__c && ProfileModel.isAppearGPPL) {
                result.add(tab.Name);
            }
            if (tab.APPEAR_Writing__c && ProfileModel.isAppearWriting) {
                result.add(tab.Name);
            }
            if (tab.APPEAR_Reviewers__c && ProfileModel.isAppearReviewers) {
                result.add(tab.Name);
            }
            if (tab.APPEAR_FPR_Only_Submitters__c && ProfileModel.isAppearFprOnlySubmitter) {
                result.add(tab.Name);
            }
            if (tab.APPEAR_626__c && ProfileModel.isAppear626) {
                result.add(tab.Name);
            }
            if (tab.APPEAR_FPRC__c && ProfileModel.isAppearFPRC) {
                result.add(tab.Name);
            }
            if (tab.APPEAR_International_FPRC__c && ProfileModel.isAppearIntFPRC) {
                result.add(tab.Name);
            }
            if (tab.APPEAR_Business_Admin__c && ProfileModel.isAppearBusinessAdmin) {
                result.add(tab.Name);
            }
            //DEFECT 475 additional read-only profile for specific users
             if (tab.APPEAR_Read_Only__c && ProfileModel.isAppearReadOnly) {
                result.add(tab.Name);
            }
            if (tab.System_Admin__c && ProfileModel.isSysAdmin) {
                result.add(tab.Name);
            }
            // ADDED as part of Appear Enhancement Release 1
            if (tab.APPEAR_External_Writer__c && ProfileModel.isAppearExternalWriter) {
                result.add(tab.Name);
            }
            if (tab.APPEAR_Functional_Pub_Team__c && ProfileModel.isAppearFunctionalPubTeam) {
                result.add(tab.Name);
            }

        }
        /*
        String message = UserInfo.getUserName() + ' has access to the following tiles in ' +
            profileTab.name+ '   :   '+ result;
        System.Debug('*** '+message);
        AppLogModel.LogError('ProfileTabTileModel::getProfileTabTile', message);
        AppLogModel.flushLogs();
        */
        return result;
    }
}