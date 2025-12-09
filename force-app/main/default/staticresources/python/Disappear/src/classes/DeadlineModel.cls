public class DeadlineModel {
    
    private static List<Deadline__c> dDeadlineList = null;
    public static List<Deadline__c> DeadlineList{
        get{
            if(dDeadlineList == null){
              dDeadlineList = getAllDeadlineList();
            }               
        return dDeadlineList;
        }
    }  
    
   private static Map<String, Deadline__c> dDeadlineNameMap = null;
   public static Map<String, Deadline__c> DeadlineNameMap{
     get {
       if (dDeadlineNameMap == null){
         dDeadlineNameMap = getDeadlineMapByName();
       }
       return dDeadlineNameMap;
     }
   }
   
   public static Map<String, Deadline__c> getDeadlineMapByName() {
    Map<String, Deadline__c> result = new Map<String, Deadline__c>();
    for(Deadline__c dDeadline : DeadlineList){
      result.put(dDeadline.Name, dDeadline );
    }

    return result;
  }
      
    public static List<Deadline__c> getAllDeadlineList(){
        List<Deadline__c> result = [
          select id, Name, Date__c, Meeting__c
          From Deadline__c
          order by Name  
           ];
        return result;
    } 
}