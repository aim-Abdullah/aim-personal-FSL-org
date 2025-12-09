public class ProdStudyModel {
    
    private static List<ProdStudy__c> pProdStudyList = null;
    public static List<ProdStudy__c> ProdStudyList{
        get{
            if(pProdStudyList == null){
              pProdStudyList = getAllProdStudyList();
            }               
        return pProdStudyList;
        }
    }  
    
   private static Map<String, ProdStudy__c> pProdStudyNameMap = null;
   public static Map<String, ProdStudy__c> ProdStudyNameMap{
     get {
       if (pProdStudyNameMap == null){
         pProdStudyNameMap = getProdStudyMapByName();
       }
       return pProdStudyNameMap;
     }
   }
   
   public static Map<String, ProdStudy__c> getProdStudyMapByName() {
    Map<String, ProdStudy__c> result = new Map<String, ProdStudy__c>();
    for(ProdStudy__c pProdStudy: ProdStudyList){
      result.put(pProdStudy.Name, pProdStudy);
    }

    return result;
  }
      
    public static List<ProdStudy__c> getAllProdStudyList(){
        List<ProdStudy__c> result = [
          select id, Name, Prod_id__c, Study_id__c
          From ProdStudy__c
          order by Name  
           ];
        return result;
    }


}