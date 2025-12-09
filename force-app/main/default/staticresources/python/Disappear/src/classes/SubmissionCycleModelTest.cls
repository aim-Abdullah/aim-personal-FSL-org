@IsTest
public class SubmissionCycleModelTest {
        
   	@isTest
	public static void unitTest() {
        //create a test pub
        Publication__c pub = unitTestData.PublicationNew('SubmissionCycleModelTest');
        System.assertNotEquals(null, pub.id);
        
        //load the test pub into AppearPubModel
        AppearPubModel pubModel = new AppearPubModel(pub.id, '', '');
        System.assertNotEquals(null, pubModel);
        System.assertNotEquals(null, pubModel.PubId);
        System.assertNotEquals(null, pubModel.PubName);
        
        //Create a SubmissionCycleModel
        SubmissionCycleModel subCycleModel = new SubmissionCycleModel(pubModel.PubId, pubModel.PubStatus.CurrentPubStatus);
        System.assertNotEquals(null, subCycleModel.SubmissionCycleMap);
        System.assertEquals(1, subCycleModel.SubmissionCycleMap.size());  //Create a pub always create the first Submission Cycle
        
        //retrieve SubmissionCycleModel from AppearPubModel
        
    }
}