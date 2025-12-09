@IsTest
public class PubScientificStatementModelTest {
    public static void createData() {
        TherapeuticAreaModelData.createData();
        AmgenProductModelData.createData();
        IndicationModelData.createData();
        ProductIndicationModelData.createData();
        ProdIndiObjectiveModelData.createData();        
        ProdIndObjSciStatementModelData.createData();
    }
    
    
    
    
    @IsTest
    public static void TestAddAndRetrieveStatements() {     
        createData();
        
        Publication__c pub = UnitTestData.PublicationNew('PubScientificStatementModelTest');
      
        Pub_Prod_Ind__c pubProdInd = new Pub_Prod_Ind__c(name='PubPI 1', Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - CKD Not Dialysis').Id, Publication__c=pub.Id);
        insert pubProdInd;        
        
        AppearPubModel pubModel = new AppearPubModel(pub.Id);             
        System.Test.startTest();   
        
        System.AssertNotEquals(0, pubModel.PubProdIndication.ProdIndListForPub.size());   
        System.AssertNotEquals(0, pubModel.PubScientificStatement.AllPubObjectives.size());
        
        pubModel.PubScientificStatement.AllPubObjectives[0].IsSelected__c = true;
        System.AssertNotEquals(0, pubModel.PubScientificStatement.AllPubScientificStatements.size());
        
        pubModel.PubScientificStatement.AllPubScientificStatements[0].IsSelected__c = true;
        pubModel.PubScientificStatement.saveSelectedObjectivesSciStatements();
        pubModel.PubScientificStatement.save();
        
        System.AssertNotEquals(0, PubScientificStatementModel.PubSciStmtList.size());
        System.AssertNotEquals(0, PubScientificStatementModel.PubSciStmtNameMap.size());
        pubModel.PubScientificStatement.cancel();
        pubModel.PubScientificStatement.AllPubScientificStatements[0].IsSelected__c = true;
        pubModel.PubScientificStatement.deleteSelected();   
        
        
        System.Test.stopTest(); 
    }
    
    @IsTest
    public static void TestClone() {
        createData();
        
        Publication__c pub = UnitTestData.PublicationNew('PubScientificStatementModelTest');
        Publication__c clonePub = UnitTestData.newPublication('PubScientificStatementModelTest2');
        
        System.Test.startTest();   
        PubScientificStatementModel.clone(pub.Id, clonePub.Id);
        System.Test.stopTest(); 
    }
}