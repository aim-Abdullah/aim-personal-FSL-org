@IsTest
public class AppearSearchViewModelTest {

	@IsTest
	public static void unitTest() {
		List<AppearSimilarContactDO> results = AppearSearchViewModel.GetSimilarContacts('test');
		System.assertNotEquals(null, results);
	}
}