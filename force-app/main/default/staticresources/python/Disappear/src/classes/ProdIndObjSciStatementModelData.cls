public with sharing class ProdIndObjSciStatementModelData {
    
    public static void createData() {
         
        integer dataCount = [select count() from ProdIndiObjective__c];   
        List<ProdIndiObjective__c> prod = [Select name, Product_Indication__c from ProdIndiObjective__c];
     //   if ( dataCount <> 0) return;
        
        List<ProdIndObjSciStatement__c> ProdIndObjSciStatementList= new List<ProdIndObjSciStatement__c>();
            
           ProdIndObjSciStatementList.add(new ProdIndObjSciStatement__c( Product_Indication_Objective__c=ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.get('Differentiate from current and new competitors').Id, ScientificStatement__c='Burden of psoriasis, including psychological or social', ScientificStatement_no__c=1, start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c = false) );
           ProdIndObjSciStatementList.add(new ProdIndObjSciStatement__c( Product_Indication_Objective__c=ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.get('Differentiate from current and new competitors').Id, ScientificStatement__c='Healthcare-resource utilization or other costs associated with psoriasis', ScientificStatement_no__c=2, start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c = false) );
           ProdIndObjSciStatementList.add(new ProdIndObjSciStatement__c( Product_Indication_Objective__c=ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.get('Market expansion—Drive broad acceptance and use in clinical dermatology practice').Id, ScientificStatement__c='Comorbidities associated with Psoriasis', ScientificStatement_no__c=1, start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c = false) );
           ProdIndObjSciStatementList.add(new ProdIndObjSciStatement__c( Product_Indication_Objective__c=ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.get('Market expansion—Drive broad acceptance and use in clinical dermatology practice').Id, ScientificStatement__c='Safety of Etanercept in scalp psoriasis', ScientificStatement_no__c=2, start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c = false) );
           ProdIndObjSciStatementList.add(new ProdIndObjSciStatement__c( Product_Indication_Objective__c=ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.get('Payors, employers, and benefit consultants').Id, ScientificStatement__c='The safety profile associated with stopping and restarting etanercept', ScientificStatement_no__c=1, start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c = false) );
           ProdIndObjSciStatementList.add(new ProdIndObjSciStatement__c( Product_Indication_Objective__c=ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.get('Payors, employers, and benefit consultants').Id, ScientificStatement__c='The long-term safety profile of etanercept in psoriasis.', ScientificStatement_no__c=2, start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c = false) );
      //   ProdIndObjSciStatementList.add(new ProdIndObjSciStatement__c( Product_Indication_Objective__c=ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.get('Market Expansion—Encourage compliance and continual use to treat psoriasis as a chronic condition').Id, ScientificStatement__c='Safety of Etanercept in scalp psoriasis', ScientificStatement_no__c=1, start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c = false) );
      //   ProdIndObjSciStatementList.add(new ProdIndObjSciStatement__c( Product_Indication_Objective__c=ProdIndiObjectiveModel.ProdIndiObjectiveNameMap.get('Market Expansion—Encourage compliance and continual use to treat psoriasis as a chronic condition').Id, ScientificStatement__c='The safety profile of etanercept in combination with other agents', ScientificStatement_no__c=2, start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c = false) );
           
          insert ProdIndObjSciStatementList;
    }


}