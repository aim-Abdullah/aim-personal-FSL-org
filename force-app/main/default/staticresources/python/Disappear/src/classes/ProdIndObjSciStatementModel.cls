public class ProdIndObjSciStatementModel {


    public static List<ProdIndObjSciStatement__c> findScientificStatementByObjectives(List<ProdIndiObjective__c> objectives) {
        List<Id> ObjIdList = new List<Id>();
        for(ProdIndiObjective__c obj : objectives) {
            ObjIdList.add(obj.id);
        }
        return findScientificStatementByObjectives(ObjIdList);      
    }


    public static List<ProdIndObjSciStatement__c> findScientificStatementByObjectives(List<Id> productIndObjectiveIdList) {
        
        List<ProdIndObjSciStatement__c> result = [
            select Name, start_date__c, End_date__c, 
            Product_Indication_Objective__c, Product_Indication_Objective__r.name,
            SiebelRowId__c, isSelected__c,
            ScientificStatement__c,ScientificStatement_no__c
            from ProdIndObjSciStatement__c
            where Product_Indication_Objective__c in :productIndObjectiveIdList
            and isLogicallyDeleted__c = false
            order by Product_Indication_Objective__r.name,ScientificStatement_no__c
           
        ];
        
        return result;
    }
    
    
    private static Map<String, ProdIndObjSciStatement__c> pProdIndiObjSciStatementNameMap = null;
     public static Map<String, ProdIndObjSciStatement__c> ProdIndiObjSciStatementNameMap {
    get {
      if (pProdIndiObjSciStatementNameMap == null){
        pProdIndiObjSciStatementNameMap = getProdIndiObjSciStatementMapByName();
      }
      return pProdIndiObjSciStatementNameMap;
    }
  }
   public static Map<String, ProdIndObjSciStatement__c> getProdIndiObjSciStatementMapByName() {
    Map<String, ProdIndObjSciStatement__c> result = new Map<String, ProdIndObjSciStatement__c>();
    for(ProdIndObjSciStatement__c prodIndSS : ProductIndiObjSciStatementList){
      result.put(prodIndSS.Name, prodIndSS);
    }
  
    return result;
  }
  
   private static Map<String, ProdIndObjSciStatement__c> pProdIndiObjSciStatementSciStmtMap = null;
     public static Map<String, ProdIndObjSciStatement__c> ProdIndiObjSciStatementSciStmtMap {
    get {
      if (pProdIndiObjSciStatementSciStmtMap == null){
        pProdIndiObjSciStatementSciStmtMap = getProdIndiObjSciStatementMapBySciStmt();
      }
      return pProdIndiObjSciStatementSciStmtMap;
    }
  }
   public static Map<String, ProdIndObjSciStatement__c> getProdIndiObjSciStatementMapBySciStmt() {
    Map<String, ProdIndObjSciStatement__c> result = new Map<String, ProdIndObjSciStatement__c>();
    for(ProdIndObjSciStatement__c prodIndSS : ProductIndiObjSciStatementList){
      result.put(prodIndSS.ScientificStatement__c, prodIndSS);
    }
    System.debug('ProdIndObjSciStatementModel::GetProdIndiObjSciStatementMapBySciStmt \n resultMap:'+result);
    return result;
  }
  
  private static List<ProdIndObjSciStatement__c> pProductIndiObjSciStatementList = null;
  public static List<ProdIndObjSciStatement__c> ProductIndiObjSciStatementList{
      get {
          if(pProductIndiObjSciStatementList == null){
              pProductIndiObjSciStatementList=getAllProductIndiObjSciStatements();
          }
      System.debug('ProdIndObjSciStatementModel::ProductIndiObjSciStatementList \n Scientific Statements List:'+pProductIndiObjSciStatementList);
      return pProductIndiObjSciStatementList;
    }  
  }
  public static List<ProdIndObjSciStatement__c> getAllProductIndiObjSciStatements(){
      List<ProdIndObjSciStatement__c> result = [select Name, start_date__c, End_date__c, Product_Indication_Objective__c, ScientificStatement__c,ScientificStatement_no__c, SiebelRowId__c
									            from ProdIndObjSciStatement__c
									            where isLogicallyDeleted__c = false];
      System.debug('ProdIndObjSciStatementModel::getAllProductIndiObjSciStatements \n Product Indication Scientific Statements List:'+result);            
      return result;
  }
  
}