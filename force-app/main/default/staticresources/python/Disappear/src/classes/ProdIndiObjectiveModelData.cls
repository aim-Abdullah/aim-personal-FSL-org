public with sharing class ProdIndiObjectiveModelData {

    public static void createData() {
         
        integer dataCount = [select count() from ProdIndiObjective__c];
        if ( dataCount <> 0) return;
        
        List<ProdIndiObjective__c> ProductIndiObjectiveList = new List<ProdIndiObjective__c>();
            
		ProductIndiObjectiveList.add(new ProdIndiObjective__c(Name='Differentiate from current and new competitors', 
			Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - CKD Not Dialysis').Id,
			start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c=false));
			
		ProductIndiObjectiveList.add(new ProdIndiObjective__c(Name='Market expansion—Drive broad acceptance and use in clinical dermatology practice', 
			Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - Dialysis').Id,
			start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c=false));
			
		ProductIndiObjectiveList.add(new ProdIndiObjective__c(Name='Payors, employers, and benefit consultants', 
			Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id,
			start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c=false));
			
         //  ProductIndiObjectiveList.add(new ProdIndiObjective__c(Name='Market Expansion—Encourage compliance and continual use to treat psoriasis as a chronic condition', Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('AMG 108 - Inflammation').Id,start_date__c=null, End_date__c=null, SiebelRowId__c=null, IsLogicallyDeleted__c = false) );
        insert ProductIndiObjectiveList ;
    }

}