@IsTest
public class AppLogWebServiceTest {

	@IsTest
	public static void unitTest() {
		AppLogModel.setLogLevelDebug();
		AppLogWebService.post('LogType', 'MessageType', 'Message', 'Description');
	}
}