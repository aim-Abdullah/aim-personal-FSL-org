@IsTest
public class AppearDataScriptControllerTest {
	@IsTest
	public static void UnitTest() {
		StatusModelData.createData();
		
		AppearDataScriptController ctrl = new AppearDataScriptController();
		
		ctrl.StatusDataScript();
		System.assertNotEquals(null, ctrl.dataScriptValues);
	}
}