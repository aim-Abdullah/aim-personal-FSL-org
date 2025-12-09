/*******************************************************************************************************
 * $Id$ : ProdIndiObjectivesTrigger
 * $Created Date$ : 2014/04/11
 * $Author$ : Sesha Kurmana
 * $Description$ : This class contains unit tests for validating the behavior of Apex class 
                    ProdIndiObjectivesTriggerLogic. 
 *******************************************************************************************************/
@isTest
public with sharing class ProdIndiObjectivesTriggerLogicTest {
    private static void CreateData() {
        AmgenProductModelData.createData();
        TherapeuticAreaModelData.createData();
        IndicationModelData.createData();
        ProductIndicationModelData.createData();
        ProdIndiObjectiveModelData.createData();
        ProdIndObjSciStatementModelData.createData();
    }
    
    @IsTest 
    private static void CycleProdIndiObjectivesTrigger() {
    	CreateData();
    	
    	List<ProdIndiObjective__c> prodIndiObj = [SELECT Id,IsLogicallyDeleted__c,Name,Objective_no__c FROM ProdIndiObjective__c]; 
    	prodIndiObj[0].Objective_no__c = 2;
    	update prodIndiObj[0];
    }
    
    @IsTest
    private static void TestProdIndiObjectivesTriggerLogic() {
        CreateData();
        
        System.assertNotEquals(null, ProdIndiObjectiveModel.ProductIndiObjectiveList);
        System.assert(ProdIndiObjectiveModel.ProductIndiObjectiveList.size() > 0);
          
        System.assertNotEquals(null, ProdIndiObjectiveModel.ProdIndiObjectiveNameMap);
        System.assert(ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.size() > 0);
        
        System.assertNotEquals(null, ProdIndiObjectiveModel.ProductIndicationList);
        System.assert(ProdIndiObjectiveModel.ProductIndicationList.size() > 0);
        
        List<ProdIndiObjective__c> prodIndiObj = [SELECT Id,IsLogicallyDeleted__c,Name,Objective_no__c FROM ProdIndiObjective__c];      
        
        System.assertNotEquals(0, prodIndiObj.size());
        
        ProdIndiObjectivesTriggerLogic.handleAutomaticExpirationOfSS(prodIndiObj);      
        
        //The above step should skip the loop entirely because there is no Objective that is expired
        //System.assertNotEquals(0, prodIndiObj.size());
        
        for (ProdIndiObjective__c prdIndObj: prodIndiObj){
            if (prdIndObj.Name == 'Payors, employers, and benefit consultants') {
                prdIndObj.IsLogicallyDeleted__c = true;
                break;  
            }
        }      
        
        ProdIndiObjectivesTriggerLogic.handleAutomaticExpirationOfSS(prodIndiObj);
        
        //The above step should drill down into the loop because there is an Objective that is expired
        Map<String, ProdIndObjSciStatement__c> map1 = ProdIndObjSciStatementModel.ProdIndiObjSciStatementSciStmtMap;
                
        System.assertNotEquals(null, map1);
        System.assert(map1.size() > 0);
        System.assertEquals(null, map1.get('The safety profile associated with stopping and restarting etanercept'));
        System.assertEquals(null, map1.get('The long-term safety profile of etanercept in psoriasis.'));
    }
}