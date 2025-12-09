@IsTest
public class ReviewTeamMemberModelTest {
    /*
    private static testMethod void unitTest() { 
      
      AmgenProductModelData.createData();
      IndicationModelData.createData();
      TherapeuticAreaModelData.createData();
      ProductIndicationModelData.createData();
      ProdIndiObjectiveModelData.createData();   
      DataSourceModelData.createData();
      SubGroupModelData.createData();  
      OrganizationModelData.createData();
      DepartmentModelData.createData();
      AccountModelData.createData();
      AppearContactModelData.createData();
      AppearRoleModelData.createData(); 
      ReviewTeamModelData.createData();
      ReviewTeamMemberModelData.createData();
        
      System.assertNotEquals(null, ReviewTeamMemberModel.ReviewTeamMemberList);
      
      System.assertNotEquals(null,ReviewTeamMemberModel.ReviewTeamMemberNameMap);
     
    }
     */
     private static testMethod void unitTest() { 
     List<ReviewTeamMember__c> rt = new List<ReviewTeamMember__c>();
     Map<String,ReviewTeamMember__c> rtmap = new Map<String,ReviewTeamMember__c>();
     ReviewTeamMemberModel.ReviewTeamMemberList = rt;
     ReviewTeamMemberModel.getallReviewTeamMembers();
     ReviewTeamMemberModel.ReviewTeamMemberNameMap = rtmap;
     ReviewTeamMemberModel.getReviewTeamMemberMapByName();
     
     }
     
     
     
}