public class PlanModel {
    
    private static List<Plan__c> pPlanList= null;
    public static List<Plan__c> PlanList{
        get{
            if(pPlanList== null){
              pPlanList= getAllPlanList();
            }               
        return pPlanList;
        }
    }  
    
   private static Map<String, Plan__c> pPlanNameMap = null;
   public static Map<String, Plan__c> PlanNameMap{
     get {
       if (pPlanNameMap == null){
         pPlanNameMap = getPlanMapByName();
       }
       return pPlanNameMap;
     }
   }
   
   public static Map<String, Plan__c> getPlanMapByName() {
    Map<String, Plan__c> result = new Map<String, Plan__c>();
    for(Plan__c pPlan : PlanList){
      result.put(pPlan.Name, pPlan );
    }

    return result;
  }
      
    public static List<Plan__c> getAllPlanList(){
        List<Plan__c> result = [
          select id, Name, ProductId__c, PlanYear__c, PlanDescription__c
          From Plan__c
          order by Name  
           ];
        return result;
    }
    
}