@IsTest
public with sharing class PubStudyTriggerLogicTest {
    
    private static void CreateData() {
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        TherapeuticAreaModelData.createData();
        AmgenProductModelData.createData();
		StudyModelData.createData();
    }
    
    private static Publication__c pPubStudyTestPub = null;
    public static Publication__c PubStudyTestPub {
        get {
            if (pPubStudyTestPub == null) {
                CreateData();
                pPubStudyTestPub = UnitTestData.PublicationNew('PubStudyTriggerLogicTest');
            }
            return pPubStudyTestPub;
        }
    }
    
    @IsTest
    private static void TestPubStudyTriggerLogic() {
    	createData();
    	
		Test.startTest();
        AppearPubModel pubModel = new AppearPubModel(PubStudyTestPub.id);
        Study__c studyPass = [Select Id, Name, Pass__c from Study__c where Name = '20119218' limit 1];
          
        PubStudyTriggerLogic.PubStudyTriggerInsertOrDeleteLogic(null); //error case 
         
        System.assertEquals(true,  pubModel.PubStudy.canAddDelStudies);  
        
        //add a study           
        pubModel.PubStudy.StudyProjectId = studyPass.Id;
        System.assertNotEquals(null, pubModel.PubStudy.saveNewPubStudy());       
           
        //check count of list
        System.assertEquals(1, pubModel.PubStudy.PubStudyList.size());
        
        PubStudyTriggerLogic.PubStudyTriggerInsertOrDeleteLogic(pubModel.PubStudy.PubStudyList);
        
        //assert trigger synchronized PASS on insert
        Publication__c pubToCheck = [Select Pass__c from Publication__c where id =:PubStudyTestPub.id];
        System.assertEquals(true,pubToCheck.Pass__c);
        
        //delete study
        pubModel.PubStudy.PubStudyList[0].isSelected__c = true;
        
        System.assertNotEquals(null, pubModel.PubStudy.deleteSelected());
        
        PubStudyTriggerLogic.PubStudyTriggerInsertOrDeleteLogic(PubStudyModel.getAllPubStudyList(PubStudyTestPub.id));
        
        //assert trigger synchronized PASS on delete
        pubToCheck = [Select Pass__c from Publication__c where id =:PubStudyTestPub.id];
        System.assertEquals(false, pubToCheck.Pass__c);
        
        Test.stopTest();
    }
}