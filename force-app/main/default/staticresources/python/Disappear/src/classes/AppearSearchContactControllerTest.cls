@IsTest
public class AppearSearchContactControllerTest {
	
	@IsTest
	private static void unitTest() {
		List<AppearSimilarContactDO> results = AppearSearchContactController.GetSimilarContacts('test');
		System.assertNotEquals(null, results);
	}
}