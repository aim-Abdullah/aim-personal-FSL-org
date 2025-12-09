@IsTest
public class AppearPickListControllerTest {

	@IsTest
	public static void unitTest() {
		CreateData();
		
		AppearPickListController picklist = new AppearPickListController();
		picklist.ProdIndPickList();
		System.assertNotEquals(null, picklist.pickListValues);
		
		picklist.ProdIndPickList();
		System.assertNotEquals(null, picklist.pickListValues);
		
		picklist.TherapeuticAreaPickList();
		System.assertNotEquals(null, picklist.pickListValues);
		
		picklist.DataSourcePickList();
		System.assertNotEquals(null, picklist.pickListValues);

		picklist.SponsoringOrgPickList();
		System.assertNotEquals(null, picklist.pickListValues);
				
		picklist.SponsoringDeptPickList();
		System.assertNotEquals(null, picklist.pickListValues);
				
		picklist.SubGroupPickList();
		System.assertNotEquals(null, picklist.pickListValues);
		
		picklist.AppearRolePickList();
		System.assertNotEquals(null, picklist.pickListValues);
		
		picklist.RegionPickList();
		System.assertNotEquals(null, picklist.pickListValues);
		
		picklist.CountryPickList();
		System.assertNotEquals(null, picklist.pickListValues);
		
		picklist.PubTypePickList();
		System.assertNotEquals(null, picklist.pickListValues);
	}
	
	public static void CreateData() {
		TherapeuticAreaModelData.createData();
		AmgenProductModelData.createData();
		IndicationModelData.createData();
		ProductIndicationModelData.createData();
		
	}
}