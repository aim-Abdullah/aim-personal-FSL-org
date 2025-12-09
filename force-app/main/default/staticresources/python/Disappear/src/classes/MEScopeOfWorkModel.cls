public class MEScopeOfWorkModel {
    
    public static void resetCache() {
    	pWritingScope = null;
    	pMEScopeList = null;
    	pMEScopeNameMap = null;
    	pMEScopeNameByIdMap = null;
    }
    private static id pWritingScope = null;
    public static id WritingScope {
    	get {
    		if (pWritingScope == null) {
    			
    			MEScopeOfWork__c writingScope =  MEScopeNameMap.get('Writing');
    			if (writingScope == null ){
    				pWritingScope = null;
    			} else {
    				pWritingScope = writingScope.id;
    			}
    		}
    		return pWritingScope;
    	}
    }
    
    private static id pNotAvailScope = null;
    public static id NotAvailScope {
    	get {
    		if (pNotAvailScope == null) {
    			
    			MEScopeOfWork__c naScope = MEScopeNameMap.get('Not Available');
    			if (naScope == null ){
    				pNotAvailScope = null;
    			} else {
    				pNotAvailScope = naScope.id;
    			}
    		}
    		return pNotAvailScope;
    	}
    }
    
    private static List<MEScopeOfWork__c> pMEScopeList = null;
    public static List<MEScopeOfWork__c> MEScopeList{
        get{
            if(pMEScopeList == null){
              pMEScopeList = getAllMEScopeList();
            }               
        return pMEScopeList;
        }
    }  
    
   private static Map<String, MEScopeOfWork__c> pMEScopeNameMap = null;
   public static Map<String, MEScopeOfWork__c> MEScopeNameMap{
     get {
       if (pMEScopeNameMap == null){
         pMEScopeNameMap = getMEScopeMapByName();
       }
       return pMEScopeNameMap;
     }
   }


   private static Map<Id, MEScopeOfWork__c> pMEScopeNameByIdMap = null;
   public static Map<Id, MEScopeOfWork__c> MEScopeNameByIdMap{
	get {
		if (pMEScopeNameByIdMap == null){
			pMEScopeNameByIdMap = new Map<Id, MEScopeOfWork__c>();
			for(MEScopeOfWork__c MEScope : MEScopeList){
				pMEScopeNameByIdMap.put(MEScope.id, MEScope );
			}
		}
		return pMEScopeNameByIdMap;
	}
    
   }
   
   public static Map<String, MEScopeOfWork__c> getMEScopeMapByName() {
    Map<String, MEScopeOfWork__c> result = new Map<String, MEScopeOfWork__c>();
    for(MEScopeOfWork__c MEScope : MEScopeList){
      result.put(MEScope.Name, MEScope );
    }

    return result;
  }
      
    public static List<MEScopeOfWork__c> getAllMEScopeList(){
        List<MEScopeOfWork__c> result = [
          select id, Name, Scaling_Factor__c, isLogicallyDeleted__c
          From MEScopeOfWork__c
          where isLogicallyDeleted__c = false
          order by Name  
       	];
        return result;
    }
   


}