@IsTest
public class PubTOVModelTest {


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
        
        //Create a PubTOVModel

        PubTOVModel pubTOV = new PubTOVModel(pubModel.PubId, pubModel, '', '', false);
        pubTOV.deleteSelected();
        boolean canEdit = pubTOV.canAddDelTOVs;
        
        pubTOV.newPubTOV.ContractNumber__c = 'abc';
        pubTOV.saveNewPubTOV();
        pubTOV.saveTOVList();
        List<PubTOV__c>  listPOV = pubTOV.PubTOVList; 
        
        System.assertEquals(pubModel.CurrentSubmissionCycleId, listPOV[0].SubmissionCycle__c);
	
        
        //retrieve SubmissionCycleModel from AppearPubModel
        
    }


}