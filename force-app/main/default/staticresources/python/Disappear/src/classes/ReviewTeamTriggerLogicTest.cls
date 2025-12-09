/***************************************************************************************************
 * $Id$ : ReviewTeamTriggerLogicTest
 * $Created Date$ : 2014/04/03
 * $Author$ : Sudha
 * $Description$ : This is a Test Class for ReviewTeamCOntroller 
 ***********************************************************************************************/
@isTest(SeeAllData=true)
public class ReviewTeamTriggerLogicTest {
    private static testMethod void TestReviewTeamTriggerLogic(){
        Test.startTest();
        //Creating data of ProductIndication.
        List<ProductIndication__c> ProductIndicationList = new List<ProductIndication__c>();
        ProductIndication__c ProductIndication = new ProductIndication__c(name= 'ABP 215 - Not Applicable' , Product__c=AmgenProductModel.getProductByName('ABP 215').id, 
            Indication__c=IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = null);
        ProductIndicationList.add(ProductIndication);
        
        ProductIndication__c ProductIndication1 = new ProductIndication__c(name= 'ABP 215 - Not Applicable' , Product__c=AmgenProductModel.getProductByName('ABP 215').id, 
            Indication__c=IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = null,isLogicallyDeleted__c = true);
        ProductIndicationList.add(ProductIndication1);
        insert ProductIndicationList;
        
        //Creating data for Review Team 
        List<Review_Team__c> reviewTeamList = new List<Review_Team__c>();
        Review_Team__c reviewTeam = new Review_Team__c();
        reviewTeam.Data_Source__c = DataSourceModelData.Development.id;
        reviewTeam.Product_Indication__c = ProductIndication.id;
        reviewTeam.SubGroup__c = SubGroupModelData.DevelopmentSmpSubGroup.id;
        reviewTeam.SiebelRowId__c = '12445567899';
        reviewTeam.IsLogicallyDeleted__c = false;
        reviewTeamList.add(reviewTeam);
        
        //Data Source set null.
        Review_Team__c reviewTeam1 = new Review_Team__c();
        //reviewTeam1.Data_Source__c = DataSourceModelData.Development.id;
        reviewTeam1.Product_Indication__c = ProductIndication.id;
        reviewTeam1.SubGroup__c = SubGroupModelData.DevelopmentSmpSubGroup.id;
        reviewTeam1.SiebelRowId__c = '12445567899';
        reviewTeam1.IsLogicallyDeleted__c = false;
        reviewTeamList.add(reviewTeam1);
        
        //Both Data Source and Sub Group set to null
        Review_Team__c reviewTeam3 = new Review_Team__c();
        //reviewTeam3.Data_Source__c = DataSourceModelData.Development.id;
        reviewTeam3.Product_Indication__c = ProductIndication1.id;
        //reviewTeam3.SubGroup__c = SubGroupModelData.DevelopmentSmpSubGroup.id;
        reviewTeam3.SiebelRowId__c = '12445567899';
        reviewTeam3.IsLogicallyDeleted__c = false;
        reviewTeamList.add(reviewTeam3);    
           
        try{
        insert reviewTeamList;
        }
        catch(Exception ex){
            system.debug('ex--'+ex);
            Boolean expectedExceptionThrown = ex.getMessage().contains('Invalid Review Team') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.stopTest();
    }
    
     private static testMethod void TestReviewTeamTriggerLogic1(){
        Test.startTest();
        //Creating data of ProductIndication.
        List<ProductIndication__c> ProductIndicationList = new List<ProductIndication__c>();
        ProductIndication__c ProductIndication = new ProductIndication__c(name= 'ABP 215 - Not Applicable' , Product__c=AmgenProductModel.getProductByName('ABP 215').id, 
            Indication__c=IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = null);
        ProductIndicationList.add(ProductIndication);
        
        insert ProductIndicationList;
        
        //Creating data for Review Team 
        List<Review_Team__c> reviewTeamList = new List<Review_Team__c>();
        
        //Sub Group set Null
        Review_Team__c reviewTeam2 = new Review_Team__c();
        reviewTeam2.Data_Source__c = DataSourceModelData.Development.id;
        reviewTeam2.Product_Indication__c = ProductIndication.id;
        reviewTeam2.SiebelRowId__c = '12445567899';
        reviewTeam2.IsLogicallyDeleted__c = false;
        reviewTeamList.add(reviewTeam2);
        
        try{
        insert reviewTeamList;
        }
        catch(Exception ex){
            system.debug('ex1111--'+ex);
            Boolean expectedExceptionThrown = ex.getMessage().contains('Invalid Review Team') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.stopTest();
    }
    private static testMethod void TestReviewTeamTriggerLogic3(){
        Test.startTest();
        //Creating data of ProductIndication.
        List<ProductIndication__c> ProductIndicationList = new List<ProductIndication__c>();
        ProductIndication__c ProductIndication = new ProductIndication__c(name= 'ABP 215 - Not Applicable' , Product__c=AmgenProductModel.getProductByName('ABP 215').id, 
            Indication__c=IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = null);
        ProductIndicationList.add(ProductIndication);
        
        insert ProductIndicationList;
        
        //Creating data for Review Team 
        List<Review_Team__c> reviewTeamList = new List<Review_Team__c>();
        
        //Both Data Source and Sub Group set to null
        Review_Team__c reviewTeam2 = new Review_Team__c();
        reviewTeam2.Product_Indication__c = ProductIndication.id;
        reviewTeam2.SiebelRowId__c = '12445567899';
        reviewTeam2.IsLogicallyDeleted__c = false;
        reviewTeamList.add(reviewTeam2);
        
        try{
        insert reviewTeamList;
        }
        catch(Exception ex){
            system.debug('ex2222--'+ex);
            Boolean expectedExceptionThrown = ex.getMessage().contains('invalid Review Team') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.stopTest();
    }
}