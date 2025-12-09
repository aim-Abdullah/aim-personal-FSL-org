@IsTest
public class StudyModelTest {

    @IsTest
    public static void UnitTest() {
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        TherapeuticAreaModelData.createData();
        StudyModelData.createData();
        
        
        System.assertNotEquals(null, StudyModel.StudyRecType);
        System.assertNotEquals(null, StudyModel.ProjectRecType);
        
        System.assertNotEquals(null, StudyModel.StudyStudyList);
        System.assertNotEquals(0, StudyModel.StudyStudyList.size());

        System.assertNotEquals(null, StudyModel.ProjectStudyList);
        System.assertNotEquals(0, StudyModel.ProjectStudyList.size());
   
   
        System.assertNotEquals(null, StudyModel.StudyMapByTitle);
        System.assertNotEquals(0, StudyModel.StudyMapByTitle.size());

        System.assertNotEquals(null, StudyModel.ProjectMapByTitle);
        System.assertNotEquals(0, StudyModel.ProjectMapByTitle.size());
          
        System.assertNotEquals(null, StudyModel.ProjectMapByTitle.get('Dummy Project 1'));
        
        System.assertNotEquals(null, StudyModel.StudyMapByTitle.get('Avanti Patient Use Study'));
        System.assertNotEquals(null, StudyModel.StudyMapByTitle.get('Enbrel PsO Inflamm Joints Pilot Study'));
        
        System.assertNotEquals(null, StudyModel.getStudyByRecordType(null));
        System.assertEquals(0, StudyModel.getStudyByRecordType(null).size());

        System.assertNotEquals(null, StudyModel.StudyMapByName);
        System.assertNotEquals(0, StudyModel.StudyMapByName.size());
        System.assertNotEquals(null, StudyModel.StudyMapByName.get('20110107'));

        List<Study__c> studies = studyModel.findStudyByName('2011');
        System.assertNotEquals(null, studies);
        System.assertNotEquals(0, studies.size());
        
        List<Study__c> projects = studyModel.findProjectByName('Dummy');
        System.assertNotEquals(null, projects);
        System.assertNotEquals(0, projects.size());
    }
        
}