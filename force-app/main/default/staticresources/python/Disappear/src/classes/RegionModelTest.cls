@IsTest
public class RegionModelTest {
    
    private static testMethod void unitTest() {  
        RegionModelData.createData();
        
 		System.assertNotEquals(null, RegionModel.RegionList);
		System.assert(RegionModel.RegionList.size() > 0);
      
		System.assertNotEquals(null,RegionModel.RegionNameMap);
		System.assert(RegionModel.RegionNameMap.size() > 0);
      
      
      	System.assertNotEquals(null, RegionModel.RegionNameMap.get('Asia Pacific'));
		System.assertNotEquals(null, RegionModel.RegionNameMap.get('US'));
		System.assertNotEquals(null, RegionModel.RegionNameMap.get('Unknown'));
    }
    
}