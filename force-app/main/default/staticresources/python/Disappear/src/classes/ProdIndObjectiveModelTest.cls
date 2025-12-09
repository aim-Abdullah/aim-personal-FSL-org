@IsTest
public class ProdIndObjectiveModelTest {

    @IsTest
    public static void UnitTest() {
        AmgenProductModelData.createData();
        TherapeuticAreaModelData.createData();
        IndicationModelData.createData();
        ProductIndicationModelData.createData();
        ProdIndiObjectiveModelData.createData();
        
      System.assertNotEquals(null, ProdIndiObjectiveModel.ProductIndiObjectiveList);
      System.assert(ProdIndiObjectiveModel.ProductIndiObjectiveList.size() > 0);
      
      System.assertNotEquals(null, ProdIndiObjectiveModel.ProdIndiObjectiveNameMap);
      System.assert(ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.size() > 0);
      
      System.assertNotEquals(null, ProdIndiObjectiveModel.ProductIndicationList);
      System.assert(ProdIndiObjectiveModel.ProductIndicationList.size() > 0);
      
      
      List<ProductIndication__c> productIndicationList = new List<ProductIndication__c>();
      List<ProdIndiObjective__c> productIndicationList2 = new List<ProdIndiObjective__c>(); 
      System.assertNotEquals(null,ProdIndiObjectiveModel.FindObjectivesByProductIndication(productIndicationList)) ;
      ProdIndiObjectiveModel.ProductIndicationList = productIndicationList;
      ProdIndiObjectiveModel.ProductIndiObjectiveList = productIndicationList2;
      
      System.assertNotEquals(null, ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.get('Differentiate from current and new competitors'));
      System.assertNotEquals(null, ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.get('Market expansion—Drive broad acceptance and use in clinical dermatology practice'));   
    }

}