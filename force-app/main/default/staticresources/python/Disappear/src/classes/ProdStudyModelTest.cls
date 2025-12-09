@IsTest
public class ProdStudyModelTest {

    @IsTest
    public static void UnitTest() {
    	CreateData();
    	
      System.assertNotEquals(null, ProdStudyModel.ProdStudyList);
      System.assert(ProdStudyModel.ProdStudyList.size() > 0);
      
      System.assertNotEquals(null, ProdStudyModel.ProdStudyNameMap);
      System.assert(ProdStudyModel.ProdStudyNameMap.size() > 0);
      
      
      System.assertNotEquals(null, ProdStudyModel.ProdStudyNameMap.get('ProdStudy01'));
      System.assertNotEquals(null, ProdStudyModel.ProdStudyNameMap.get('ProdStudy02'));
    }
    
    public static void CreateData(){
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        TherapeuticAreaModelData.createData();
        AmgenProductModelData.createData();
        StudyModelData.createData();
        ProdStudyModelData.createData();     	
    }
    
}