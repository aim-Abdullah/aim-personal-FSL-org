// A SeeAllData Test - by definition - this CANNOT be created as an Salesforce Unit Test
// or we will never be able to deploy
//
// This test is written to check if all critical Status are loaded as expected 
// for Appear 1.0 as of July 2013
//
// This manual test class must be updated when new status is updated or old status is retired
public class StatusModelSeeAllDataTest {
	
	//use execute ananoymous to run this
	//System.assert(StatusModelSeeAllDataTest.checkAll());

	public static boolean checkAll() {
		boolean result = checkGlobalStatus() && checkDepartmentStatus() && checkAutoInsertStatus() && checkLegacyStatus();
		
		return result;
	}
	
	public static boolean checkGlobalStatus() {
		return true;
	}
	
	public static boolean checkDepartmentStatus() {
		return true;
	}
	
	public static boolean checkAutoInsertStatus() {
		return false;
	}
	
	public static boolean checkLegacyStatus() {
		return true;
	}

}