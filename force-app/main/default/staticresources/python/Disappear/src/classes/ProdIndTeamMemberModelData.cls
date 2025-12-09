public with sharing class ProdIndTeamMemberModelData {

   /* public static testMethod void UnitTest() {
        ProductModelData.createData();
        IndicationModelData.createData();
        ProductIndicationModelData.createData();
        ProdIndTeamMemberModelData.createData();
;
    }*/
    
    public static void createData() {
         
        integer dataCount = [select count() from ProdIndTeamMember__c];                
        if ( dataCount <> 0) return;
        
        List<ProdIndTeamMember__c> ProdIndTeamMemberList= new List<ProdIndTeamMember__c>();
            
		Contact mike = AppearContactModel.findContactByName('Michael', 'Dorner')[0];    
		Contact solange = AppearContactModel.findContactByName('Solange', 'Weiss')[0];    
		Contact melissa = AppearContactModel.findContactByName('Melissa', 'Seal')[0];    
            
		ProdIndTeamMemberList.add(new ProdIndTeamMember__c(
			Contact__c=mike.id ,
            Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - CKD Not Dialysis').Id));
            
          ProdIndTeamMemberList.add(new ProdIndTeamMember__c(
            Contact__c=mike.id ,
            Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - Dialysis').Id));
            
          ProdIndTeamMemberList.add(new ProdIndTeamMember__c(
            Contact__c=solange.id ,
            Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - CKD Not Dialysis').Id));
            
          ProdIndTeamMemberList.add(new ProdIndTeamMember__c(
            Contact__c=melissa.id ,
            Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id));
           
          insert ProdIndTeamMemberList;
    }


}