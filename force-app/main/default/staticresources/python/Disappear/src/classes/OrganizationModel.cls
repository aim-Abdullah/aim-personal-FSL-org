public class OrganizationModel {
    
    private static List<Organization__c> pOrganizationList = null;
    public static List<Organization__c> OrganizationList{
        get{
            if(pOrganizationList == null){
              pOrganizationList = getAllOrganizationList();
            }               
        return pOrganizationList;
        }
    }  
    
    
    public static List<Organization__c> SponsoringOrganizationList{
        get {              
        	return getSponsoringOrganizationList();
        }
    }
    
    public static Organization__c lookupOrg(string org) {
		if (OrganizationNameMap.containsKey(org)) {
			return OrganizationNameMap.get(org);
		} else {
			return null;
		}   
	}
      
	private static Map<String, Organization__c> pOrganizationNameMap = null;
	public static Map<String, Organization__c> OrganizationNameMap{
		get {
			if (pOrganizationNameMap == null){
				pOrganizationNameMap = getOrganizationMapByName();
			}
       		return pOrganizationNameMap;
     	}
	}
   
	public static Map<String, Organization__c> getOrganizationMapByName() {
   		Map<String, Organization__c> result = new Map<String, Organization__c>();
    	for(Organization__c pOrganization: OrganizationList){
    		result.put(pOrganization.Name, pOrganization);
    	}

    	return result;
	}
      
	public static List<Organization__c> getSponsoringOrganizationList(){
    	List<Organization__c> result = new List<Organization__c>();
    	for(Organization__c org : OrganizationList) {
    		if ( org.SponsorOrg__c) {
    			result.add(org);
    		}
    	}
    	return result;		
	}   
	 
    public static List<Organization__c> getAllOrganizationList(){
        List<Organization__c> result = [
			select id, Name, ParentOrgId__c, SiebelRowId__c, Type__c, URL__c, SponsorOrg__c
			From Organization__c
			where isLogicallyDeleted__c = false
			order by Name  
		];
        return result;
    }

	public static Organization__c getOrganizationById(Id orgId){
        List<Organization__c> result = [
			select id, Name, ParentOrgId__c, SiebelRowId__c, Type__c, URL__c, SponsorOrg__c, isLogicallyDeleted__c
			From Organization__c
			where Id =: orgId
		];
		
		if(result.size() == 0){
			return null;
		}
		
        return result[0];
    }

}