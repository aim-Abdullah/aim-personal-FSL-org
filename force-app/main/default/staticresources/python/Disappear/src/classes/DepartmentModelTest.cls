@IsTest
public class DepartmentModelTest {

	@IsTest
	public static void UnitTest() {
		System.assertNotEquals(null, DepartmentModel.getAllDepartmentList());
    	System.assertEquals(0, DepartmentModel.getAllDepartmentList().size());
		
	    OrganizationModelData.createData();
	    DepartmentModelData.createData();
	    
	    System.assertNotEquals(null, DepartmentModel.DepartmentList);  
	    System.assertNotEquals(null, DepartmentModel.getAllDepartmentList()); 
	    System.assert(DepartmentModel.getCompleteDepartmentList().size() > 0);
	    System.assert(DepartmentModel.DepartmentList.size() > 0);
	    System.assert(DepartmentModel.SponsoringDepartmentList.size() > 0);
	    System.assertNotEquals(null, DepartmentModel.lookupDept('Medical Writing'));
	    System.assertEquals(null, DepartmentModel.lookupDept('Sesha'));
	     
	    System.assertNotEquals(null, DepartmentModel.DepartmentNameMap);  
		System.assertNotEquals(null, DepartmentModel.DepartmentNameMap.size() > 0);  
		
		System.assertNotEquals(null, DepartmentModel.DepartmentNameMap.get('Global Health Economics (GHE)'));
		System.assertNotEquals(null, DepartmentModel.getDepartment('A new Department'));  //insert 
		System.assertNotEquals(null, DepartmentModel.getDepartment('A new Department'));  //retrieval from Map 
		
		System.assertNotEquals(null, DepartmentModelData.GlobalHealthEconomicDept);
		System.assertNotEquals(null, DepartmentModelData.GlobalMedicalWritingDept);
		System.assertNotEquals(null, DepartmentModelData.MedicalCommunicationsDept);
		
		System.assertNotEquals(null, DepartmentModel.getDepartmentById(DepartmentModel.DepartmentList[0].Id));
		 
		try {
			Department__c dupDept = new Department__c();
			dupDept.name = 'Global Health Economics (GHE)';
			insert dupDept;			
		} catch ( DMLException e){
			System.Debug(e);
			System.assert( e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
		}

  	}
}