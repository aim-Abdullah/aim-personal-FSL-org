@IsTest
public class SubGroupModelTest {

	@IsTest
	public static void UnitTest() {
		DataSourceModelData.createData();
		SubGroupModelData.createData();
		
		System.assertNotEquals(null, SubGroupModel.SubGroupList);
    	System.assert(SubGroupModel.SubGroupList.size() > 0);
    	
    	System.assertNotEquals(null, SubGroupModel.SubGroupNameMap);
    	System.assert(SubGroupModel.SubGroupNameMap.size() > 0);
    	
    	System.assertNotEquals(null, SubGroupModel.SubGroupMapById);
    	System.assert(SubGroupModel.SubGroupMapById.size() > 0);
    	
    	
    	System.assertNotEquals(null, SubGroupModelData.DevelopmentIrdSubGroup);
    	System.assertNotEquals(null, SubGroupModelData.DevelopmentSmpSubGroup);
    	
    	boolean caughtDupError = false;

    	try {
			SubGroup__c dupSg = new SubGroup__c();
			dupSg.name = 'GRAAS';
			insert dupSg;			
		} catch ( DMLException e){
			System.Debug(e);
			System.assert( e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
			caughtDupError = true;
		} finally {
			System.assert(caughtDupError);
		}
		
		
		
	}
}