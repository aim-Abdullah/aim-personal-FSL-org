public with sharing class ProfileTabModel {
	//with sharing - System Admin RW  / Rest of Profile are RO

	private static Set<string> pPubTileAccessList = null;
    public static Set<string> PubTileAccessList {
        get{
        	if (pPubTileAccessList == null) {
        		pPubTileAccessList = preparePubTileAccessList();
        	}
            return pPubTileAccessList;
        }
    }
    
    public static Set<string> preparePubTileAccessList() {
    	ProfileTab__c pubTab = ProfileTabNameMap.get('Publication Tab');
    	Set<string> pubTabTiles = ProfileTabTileModel.getProfileTabTile(pubTab);
    	
    	return pubTabTiles; 
    }
    
    private static List<ProfileTab__c> pProfileTabList = null;
    public static List<ProfileTab__c> ProfileTabList{
        get{
            if(pProfileTabList == null){
              pProfileTabList = getAllProfileTabList();
            }               
        	return pProfileTabList;
        }
    }  
    
   	private static Map<String, ProfileTab__c> pProfileTabNameMap = null;
   	public static Map<String, ProfileTab__c> ProfileTabNameMap{
		get {
			if (pProfileTabNameMap == null){
         		pProfileTabNameMap = getProfileTabMapByName();
       		}
       		return pProfileTabNameMap;
     	}
   	}
   
	public static Map<String, ProfileTab__c> getProfileTabMapByName() {
 		Map<String, ProfileTab__c> result = new Map<String, ProfileTab__c>();
    	for(ProfileTab__c pProfileTab : ProfileTabList){
      		result.put(pProfileTab.Name, pProfileTab );
    	}
    	return result;
	}
      
    public static List<ProfileTab__c> getAllProfileTabList(){
        List<ProfileTab__c> result = [
			select id, Name, Comment__c
          	From ProfileTab__c
          	order by Name  
		];
        return result;
    }
}