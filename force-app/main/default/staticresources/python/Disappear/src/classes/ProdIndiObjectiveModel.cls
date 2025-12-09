public class ProdIndiObjectiveModel {

    public static List<ProdIndiObjective__c> FindObjectivesByProductIndication(List<ProductIndication__c> productIndicationList) {
        List<Id> productIndicationIdList = new List<Id>();
        for(ProductIndication__c prodInd : productIndicationList) {
            productIndicationIdList.add(prodInd.id);
        }
        return FindObjectivesByProductIndication(productIndicationIdList);
    }
    
    public static List<ProdIndiObjective__c> FindObjectivesByProductIndication(List<Id> productIndicationIdList) {
        
        List<ProdIndiObjective__c> result = [
            select Name, start_date__c, End_date__c, Product_Indication__c, 
            Product_Indication__r.name, SiebelRowId__c, isSelected__c
            from ProdIndiObjective__c
            where Product_Indication__c in :productIndicationIdList
            and IsLogicallyDeleted__c = false
        ];
        
        return result;
    }
    
   private static Map<String, ProdIndiObjective__c> pProdIndiObjectiveNameMap = null;
     public static Map<String, ProdIndiObjective__c> ProdIndiObjectiveNameMap {
    get {
      if (pProdIndiObjectiveNameMap == null){
        pProdIndiObjectiveNameMap = getProdIndiObjectivMapByName();
      }
      return pProdIndiObjectiveNameMap;
    }
  }
   public static Map<String, ProdIndiObjective__c> getProdIndiObjectivMapByName() {
    Map<String, ProdIndiObjective__c> result = new Map<String, ProdIndiObjective__c>();
    for(ProdIndiObjective__c prodIndO : ProductIndiObjectiveList){
      result.put(prodIndO.Name, prodIndO);
    }
  
    return result;
  }
  private static List<ProdIndiObjective__c> pProductIndiObjectiveList = null;
  public static List<ProdIndiObjective__c> ProductIndiObjectiveList{
      get {
          if(pProductIndiObjectiveList == null){
              pProductIndiObjectiveList=getAllProductIndiObjectives();
          }
      
      return pProductIndiObjectiveList;
    }  
  }
  public static List<ProdIndiObjective__c> getAllProductIndiObjectives(){
      List<ProdIndiObjective__c> result = [
            select Name, start_date__c, End_date__c, Product_Indication__c,
            Product_Indication__r.name, SiebelRowId__c, isSelected__c
            from ProdIndiObjective__c
            where isLogicallyDeleted__c = false
      ];
      return result;
  }
  private static List<ProductIndication__c> pProductIndicationList = null;
  public static List<ProductIndication__c> ProductIndicationList{
    get {
      if ( pProductIndicationList == null){
        pProductIndicationList = getAllProductIndications();
      }
      
      return pProductIndicationList;
    }
  }
   public static List<ProductIndication__c> getAllProductIndications() {
     List<ProductIndication__c>  result = [
       select id, Name, Product__c, Indication__c, Therapeutic_Area__c
       from ProductIndication__c
       where isLogicallyDeleted__c = false
       order by Name
     ];
     system.debug('result:'+result);
     return result;
  }
  
}