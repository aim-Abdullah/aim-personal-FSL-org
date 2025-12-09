public  class ProfileTabModelData {
	
	public static void refreshProfilePermission() {
		List<sObject> records = [select id from ProfileTabTile__c];
		delete records;
		
		records = [select id from ProfileTab__c];
		delete records;
		
		ProfileTabModelData.createData();
		ProfileTabTileModelData.createData();
	}

    public static void createData() {
    
        integer dataCount = [select count() from ProfileTab__c];
        if ( dataCount <> 0) return;
        
        List<ProfileTab__c> ProfileTabList = new List<ProfileTab__c>();
        
        ProfileTabList.add( new ProfileTab__c(Name='FPR Tab',Comment__c=null));         
        ProfileTabList.add( new ProfileTab__c(Name='Publication Tab',Comment__c=null));         
               
        insert ProfileTabList;
                
     }
    
}