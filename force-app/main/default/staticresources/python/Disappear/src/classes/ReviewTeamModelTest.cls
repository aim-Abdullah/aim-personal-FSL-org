@IsTest
public class ReviewTeamModelTest {
    
    @IsTest
    public static void unitTest() { 
      AmgenProductModelData.createData();
      IndicationModelData.createData();
      TherapeuticAreaModelData.createData();
      ProductIndicationModelData.createData();
      ProdIndiObjectiveModelData.createData();   
      DataSourceModelData.createData();
      SubGroupModelData.createData();  
       
      ReviewTeamModelData.createData();
        
      System.assertNotEquals(null, ReviewTeamModel.ReviewTeamList );
      System.assert(ReviewTeamModel.ReviewTeamList .size() > 0);
      
      System.assertNotEquals(null,ReviewTeamModel.ReviewTeamNameMap);
      System.assert(ReviewTeamModel.ReviewTeamNameMap.size() > 0);
      
      
      System.assertNotEquals(null,ReviewTeamModel.ReviewTeamMap);
      System.assert(ReviewTeamModel.ReviewTeamMap.size() > 0);
      
      System.assertNotEquals(null, ReviewTeamModelData.aranespCkdNotDialysisDevelopmentIrdReviewTeam);
      System.assertNotEquals(null, ReviewTeamModelData.abarelixOncologyDevelopmentSmpReviewTeam);
      System.assertNotEquals(null, ReviewTeamModelData.aranespCkdNotDialysisOperationCommericalQualityReviewTeam);
      
      
      Set<Id> ProdIndList = new Set<id>();
      ProdIndList.add(ProductIndicationModelData.abarelixOncologyProdInd.Id);
	  List<Review_Team__c> reviewTeams = 
	  	ReviewTeamModel.findReviewTeamsBySubGroupProdInd(SubGroupModelData.DevelopmentSmpSubGroup.Id, ProdIndList);
      System.assertNotEquals(null, reviewTeams);
      
	  List<Review_Team__c> reviewTeams2 = 
	  	ReviewTeamModel.findReviewTeamsByDataSourceProdInd(DataSourceModelData.Development.Id, ProdIndList);
      System.assertNotEquals(null, reviewTeams2);
      
      
      System.assertNotEquals(null, ReviewTeamModel.ReviewTeamList);
      System.assertNotEquals(0, ReviewTeamModel.ReviewTeamList.size());
    } 
    
}