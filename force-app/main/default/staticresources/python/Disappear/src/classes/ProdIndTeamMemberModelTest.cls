@IsTest
public class ProdIndTeamMemberModelTest {

    @IsTest
    public static void DataUnitTest() {
        
        //create data   
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        AccountModelData.createData();
        AppearContactModelData.createData();
        TherapeuticAreaModelData.createData(); 
        AmgenProductModelData.createData();
        IndicationModelData.createData();
        ProductIndicationModelData.createData();
        ProdIndTeamMemberModelData.createData();
        
        
        //find product indication in system
        Id prodIndId = ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - CKD Not Dialysis').Id;
        System.assertNotEquals(null, ProdIndTeamMemberModel.getProductIndTeamMember(prodIndId));
        
        Id prodIndId2 = ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id;
        
        Set<id> prodInds = new Set<Id>();
        
        Map<Id,List<ProdIndTeamMember__c>> map0 = ProdIndTeamMemberModel.getProductIndTeamMember(prodInds);
        System.assertNotEquals(null, map0);
        System.assertEquals(0, map0.size());
        
        prodInds.add(prodIndId);
        Map<Id,List<ProdIndTeamMember__c>> map1 = ProdIndTeamMemberModel.getProductIndTeamMember(prodInds);
        System.assertNotEquals(null, map1);
        //System.assertEquals(3, map1.size());
        
        prodInds.add(prodIndId2);
        Map<Id,List<ProdIndTeamMember__c>> map2 = ProdIndTeamMemberModel.getProductIndTeamMember(prodInds);
        System.assertNotEquals(null, map2);
        //System.assertEquals(5, map2.size());
   }
        
}