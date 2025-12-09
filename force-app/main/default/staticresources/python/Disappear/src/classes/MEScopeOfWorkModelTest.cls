@IsTest
public class MEScopeOfWorkModelTest {

  @IsTest
  public static void UnitTest() {
  	System.assertEquals(null, MEScopeOfWorkModel.WritingScope); 
    MEScopeOfWorkModelData.createData();
    
    System.assertNotEquals(null, MEScopeOfWorkModel.MEScopeList);  
    System.assertNotEquals(null, MEScopeOfWorkModel.getAllMEScopeList()); 
    System.assertNotEquals(null, MEScopeOfWorkModel.MEScopeNameMap);  
    System.assertNotEquals(null, MEScopeOfWorkModel.MEScopeNameByIdMap);
    System.assertNotEquals(null, MEScopeOfWorkModel.WritingScope); 

	System.assert(MEScopeOfWorkModel.MEScopeNameMap.get('Writing').Scaling_Factor__c == 1.0);
	System.assert(MEScopeOfWorkModel.MEScopeNameMap.get('Editing/Formatting').Scaling_Factor__c == 0.5);
	System.assert(MEScopeOfWorkModel.MEScopeNameMap.get('Encore').Scaling_Factor__c == 0.5);
  }

}