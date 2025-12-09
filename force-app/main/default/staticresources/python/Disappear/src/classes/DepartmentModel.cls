public class DepartmentModel {
    
    private static List<Department__c> dDepartmentList= null;
    public static List<Department__c> DepartmentList{
        get{
            if(dDepartmentList== null){
              dDepartmentList= getAllDepartmentList();
            }               
        return dDepartmentList;
        }
    }  

    public static List<Department__c> SponsoringDepartmentList{
        get{             
        	return getSponsoringDepartmentList();
        }
    }
    
	public static Department__c lookupDept(string dept) {
		if (DepartmentNameMap.containsKey(dept)) {
			return DepartmentNameMap.get(dept);
		} else {
			return null;
		}   
	} 
    
   private static Map<String, Department__c> dDepartmentNameMap = null;
   public static Map<String, Department__c> DepartmentNameMap{
     get {
       if (dDepartmentNameMap == null){
         dDepartmentNameMap = getDepartmentMapByName();
       }
       	
       return dDepartmentNameMap;
     }
   }
   
   
	//get Department will be used to insert Contact into PubME
	//if a Contact's Department does not exist in Department table
	//a new row will be inserted
	public static Department__c getDepartment(string DeptName) {
   		if (DepartmentNameMap.containsKey(DeptName)) {
   			return DepartmentNameMap.get(DeptName);
   		}
   		
   		Department__c newDept = new Department__c();
   		newDept.Name = DeptName;
   		newDept.OrganizationId__c = null;
   		newDept.Acronym__c = null;
   		
   		insert newDept;
   		
   		DepartmentNameMap.put(DeptName, newDept);
   		
   		return newDept;
	}
   
   
	public static Map<String, Department__c> getDepartmentMapByName() {
	    Map<String, Department__c> result = new Map<String, Department__c>();
	    for(Department__c dDepartment : DepartmentList){
			result.put(dDepartment.Name, dDepartment );
		}
		return result;
	}
    
    public static List<Department__c> getSponsoringDepartmentList(){
    	List<Department__c> result = new List<Department__c>();
    	for(Department__c dept : DepartmentList) {
    		if ( dept.SponsorDept__c) {
    			result.add(dept);
    		}
    	}
    	return result;
    }
      
    public static List<Department__c> getAllDepartmentList(){
        List<Department__c> result = [
          select id, Name, OrganizationId__c, Acronym__c, SiebelRowId__c, Type__c, URL__c, SponsorDept__c
          From Department__c
          where isLogicallyDeleted__c = false
          order by Name  
           ];
           
        return result;
    }
    
    public static List<Department__c> getCompleteDepartmentList(){
        List<Department__c> result = [
          select id, Name, OrganizationId__c, Acronym__c, SiebelRowId__c, Type__c, URL__c, SponsorDept__c,isLogicallyDeleted__c
          From Department__c
          order by Name  
           ];
           
        return result;
    }
    
    public static Department__c getDepartmentById(Id deptId){
        List<Department__c> result = [
	          select id, Name, OrganizationId__c, Acronym__c, SiebelRowId__c, Type__c, URL__c, SponsorDept__c, isLogicallyDeleted__c
	          From Department__c
	          where id =: deptId
           ];
        
        if(result.size() == 0) {
        	return null;
        }   
        
        return result[0];
    }
   
}