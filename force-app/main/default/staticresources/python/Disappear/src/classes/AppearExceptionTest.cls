@IsTest
public class AppearExceptionTest {

	@IsTest
	public static void unitTest() {
		AppearException ae = new AppearException('test') ;
		System.assertNotEquals(null, ae);
		
		AppearException ae2 = new AppearException('test','appearErrorMsg') ;
		System.assertNotEquals(null, ae2.AppearErrorMsg);
		System.assertEquals('appearErrorMsg', ae2.AppearErrorMsg);
	}
}