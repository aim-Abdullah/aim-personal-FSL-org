public class RegionModel {
	
    private static List<Region__c> rRegionList = null;
    public static List<Region__c> RegionList{
        get{
            if(rRegionList == null){
              rRegionList = getAllRegionList();
            }               
        return rRegionList;
        }
    }  
    
   private static Map<String, Region__c> rRegionNameMap = null;
   public static Map<String, Region__c> RegionNameMap{
     get {
       if (rRegionNameMap == null){
         rRegionNameMap = getRegionMapByName();
       }
       return rRegionNameMap;
     }
   }
   
   public static Map<String, Region__c> getRegionMapByName() {
    Map<String, Region__c> result = new Map<String, Region__c>();
    for(Region__c rRegion : RegionList){
      result.put(rRegion.Name, rRegion );
    }

    return result;
  }
      
    public static List<Region__c> getAllRegionList(){
        List<Region__c> result = [
          select id, Name
          From Region__c
          where isLogicallyDeleted__c = false
          order by Name  
		];
        return result;
    }


}