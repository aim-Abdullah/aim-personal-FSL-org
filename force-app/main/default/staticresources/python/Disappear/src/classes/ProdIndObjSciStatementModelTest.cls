@IsTest
public class ProdIndObjSciStatementModelTest {

  @IsTest
    public static void UnitTest() {
        AmgenProductModelData.createData();
        TherapeuticAreaModelData.createData();
        IndicationModelData.createData();
        ProductIndicationModelData.createData();
        ProdIndiObjectiveModelData.createData();
        ProdIndObjSciStatementModelData.createData();
        
        
        
        System.assertNotEquals(null, ProdIndObjSciStatementModel.ProductIndiObjSciStatementList);
        System.assert(ProdIndObjSciStatementModel.ProductIndiObjSciStatementList.size() > 0);
      
        System.assertNotEquals(null, ProdIndObjSciStatementModel.ProdIndiObjSciStatementNameMap);
        System.assert(ProdIndObjSciStatementModel.ProdIndiObjSciStatementNameMap.size() > 0);
       
        list<ProdIndiObjective__c> l2 = new list<ProdIndiObjective__c>();
        list<ProdIndObjSciStatement__c> pi = new List<ProdIndObjSciStatement__c>();
        Map<String, ProdIndObjSciStatement__c> map1 = new Map<String, ProdIndObjSciStatement__c>();
        ProdIndObjSciStatementModel.ProdIndiObjSciStatementNameMap = map1;
        ProdIndObjSciStatementModel.ProdIndiObjSciStatementSciStmtMap = map1;
        ProdIndObjSciStatementModel.ProductIndiObjSciStatementList = pi;
        ProdIndObjSciStatementModel.getProdIndiObjSciStatementMapBySciStmt();
        ProdIndObjSciStatementModel.findScientificStatementByObjectives(l2);
       
    }

}