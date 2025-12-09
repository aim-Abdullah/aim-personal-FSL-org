@IsTest
public class StudyNoteModelTest {

    @IsTest
    public static void UnitTest() {
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        TherapeuticAreaModelData.createData();
        
        StudyModelData.createData();
        StudyNoteModelData.createData();
    
      System.assertNotEquals(null, StudyNoteModel.StudyNoteList);
      System.assert(StudyNoteModel.StudyNoteList.size() > 0);
      
      System.assertNotEquals(null, StudyNoteModel.StudyNoteMap);
      System.assert(StudyNoteModel.StudyNoteMap.size() > 0);
      
      
      System.assertNotEquals(null, StudyNoteModel.StudyNoteMap.get('StudyNote1'));
      System.assertNotEquals(null, StudyNoteModel.StudyNoteMap.get('StudyNote2'));
    }
    
    
}