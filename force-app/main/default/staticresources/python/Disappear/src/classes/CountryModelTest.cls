@isTest
public class CountryModelTest {

	@IsTest
    public static void myUnitTest() {
    	
		createData();
    	
		System.assertNotEquals(null, CountryModel.CountryList); 
		System.assertNotEquals(null, CountryModel.CountryNameMap); 
		System.assertNotEquals(null, CountryModel.Unknown);
    }
    
    private static void CreateData() {
    	 RegionModelData.createData();
         CountryModelData.createData();
    	
    }
}