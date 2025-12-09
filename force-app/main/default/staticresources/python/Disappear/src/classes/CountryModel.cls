public class CountryModel {
    private static Country__c pUnknown = null;
	public static Country__c Unknown {
		get {
			if (pUnknown == null) {
				pUnknown = CountryNameMap.get('Unknown');
			}
			return pUnknown;
		}
	}
	
    private static List<Country__c> cCountryList = null;
    public static List<Country__c> CountryList{
        get{
            if(cCountryList == null){
              cCountryList = getAllCountryList();
            }               
        return cCountryList;
        }
    }  
    
   private static Map<String, Country__c> cCountryNameMap = null;
   public static Map<String, Country__c> CountryNameMap{
     get {
       if (cCountryNameMap == null){
         cCountryNameMap = getCountryMapByName();
       }
       return cCountryNameMap;
     }
   }
   
   public static Map<String, Country__c> getCountryMapByName() {
    Map<String, Country__c> result = new Map<String, Country__c>();
    for(Country__c cCountry : CountryList){
      result.put(cCountry.Name, cCountry );
    }

    return result;
  }
      
    public static List<Country__c> getAllCountryList(){
        List<Country__c> result = [
          select id, Name, RegionId__c, RegionId__r.name, isLogicallyDeleted__c
          From Country__c
          where isLogicallyDeleted__c = false
          order by Name  
        ];
        return result;
    }

	public static Country__c lookupCountry(string country) {
        if (CountryNameMap.containsKey(country)) {
            return CountryNameMap.get(country);
        } else {
            return null;
        }   
    } 
}