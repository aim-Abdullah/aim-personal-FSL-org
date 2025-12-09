public class TherapeuticAreaModel {

    public static TherapeuticArea__c lookUpTA(string TaArea) {
        if (TaMap.containsKey(TaArea)) {
            return TaMap.get(TaArea);
        } else {
            return null;
        }   
    }
    

   private static Map<String, TherapeuticArea__c> pTaMap = null;
   public static Map<String, TherapeuticArea__c> TaMap{
     get {
       if (pTaMap == null){
         pTaMap = getTaByName();
       }
       return pTaMap;
     }
   }

   private static Map<Id, TherapeuticArea__c> pTaMapById = null;
   public static Map<Id, TherapeuticArea__c> TaMapById{
     get {
       if (pTaMapById == null){
         pTaMapById = getTaMapById();
       }
       return pTaMapById;
     }
   }

   public static Map<Id, TherapeuticArea__c> getTaMapById() {
    Map<Id, TherapeuticArea__c> result = new Map<Id, TherapeuticArea__c>();
    for(TherapeuticArea__c pTA : TaList){
      result.put(pTA.Id, pTA );
    }

    return result;
   }

   
   public static Map<String, TherapeuticArea__c> getTaByName() {
    Map<String, TherapeuticArea__c> result = new Map<String, TherapeuticArea__c>();
    for(TherapeuticArea__c pTA : TaList){
      result.put(pTA.Name, pTA );
    }

    return result;
  }
    
    private static List<TherapeuticArea__c> pTaList = null;
    public static List<TherapeuticArea__c> TaList {
        get {
            if ( pTaList == null) {
                pTaList = getAllTa();
            }
            return pTaList;
        }
    }
    
    public static List<TherapeuticArea__c> getAllTa() {
        List<TherapeuticArea__c> result = [
            Select id, Name
            From TherapeuticArea__c 
            where isLogicallyDeleted__c = false   //def #592
            order by Name
        ];
        return result;
    }

}