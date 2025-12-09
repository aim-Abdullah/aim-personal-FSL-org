@IsTest
public class PubStudyModelTest {
    private static void createData() {
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        TherapeuticAreaModelData.createData();
        AmgenProductModelData.createData();
        StudyModelData.createData();
    }
    
    @IsTest
    private static void SelectDeselectStudies() {
        createData();
        
        
        Test.startTest();
        Publication__c pub = UnitTestData.PublicationNew('SelectDeselectStudiesTest');
        Publication__c clonePub = UnitTestData.newPublication('PubScientificStatementModelTest2');
        AppearPubModel pubModel = new AppearPubModel(pub.id);
        Study__c study = [Select Id, Name from Study__c limit 1];
          
        System.assertEquals(true,  pubModel.PubStudy.canAddDelStudies);  
        
        //fail cases        
        pubModel.PubStudy.saveNewPubStudy(); 
        pubModel.PubStudy.StudyProjectId = 'invalid';
        pubModel.PubStudy.saveNewPubStudy(); 
        
        //add a study           
        pubModel.PubStudy.StudyProjectId = study.Id;
        System.assertNotEquals(null, pubModel.PubStudy.saveNewPubStudy());        
           
        //check count of list
        System.assertEquals(1, pubModel.PubStudy.PubStudyList.size());
        
        PubStudyModel.setupMiscFromProdStudy(pub.Id); 
        
        
        //clone
        PubStudyModel.clone(pub.Id, clonePub.id);        
        System.assertEquals(1, PubStudyModel.getAllPubStudyList(clonePub.Id).size()); 
        
        //delete study
        pubModel.PubStudy.PubStudyList[0].isSelected__c = true;
        
        Test.stopTest();
        
        System.assertNotEquals(null, pubModel.PubStudy.deleteSelected());
        
        //invoke static functions
        System.assertEquals(0, PubStudyModel.getAllPubStudyList(pub.Id).size()); 
        System.assertEquals(false,  PubStudyModel.CheckDupStudyForPub(pub.Id,study.Id));
    }        
}