@IsTest
public class AppearBaseControllerTest {

	@IsTest
	public static void UnitTest() {
		
	}
	
	@IsTest
	public static void testAppearException() {
		AppearException ae = new AppearException('test AppearException');
		System.assertNotEquals(null, ae);
	}
}