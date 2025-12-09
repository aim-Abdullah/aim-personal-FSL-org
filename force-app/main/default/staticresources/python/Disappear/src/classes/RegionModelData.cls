public  class RegionModelData {
	
    public static void createData() {
    
		integer dataCount = [select count() from Region__c];
        if ( dataCount <> 0) return;
        
        List<Region__c> RegionList = new List<Region__c>();
        
		RegionList.add( new Region__c(name= 'Asia Pacific'));
		RegionList.add( new Region__c(name= 'China'));  
		RegionList.add( new Region__c(name= 'EEMEA'));  
		RegionList.add( new Region__c(name= 'Europe'));  
		RegionList.add( new Region__c(name= 'Japan'));  
		RegionList.add( new Region__c(name= 'LACAN'));   
		RegionList.add( new Region__c(name= 'Unknown'));  
        RegionList.add( new Region__c(name= 'US'));   
        
        insert RegionList;
                
     }
    
}