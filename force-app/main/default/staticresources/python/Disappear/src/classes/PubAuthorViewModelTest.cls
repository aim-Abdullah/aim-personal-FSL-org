@IsTest
public class PubAuthorViewModelTest {

	@IsTest
	public static void UnitTest() {
		List<IdAuthorDTO>  authors = PubAuthorViewModel.findAuthorsByName('Ben');
		System.assertNotEquals(null, authors);
	}
	
	@IsTest
	public static void IdAuthorDTOUnitTest(){
		IdAuthorDTO author = new IdAuthorDTO('123','Ben','ben@gmail.com','street','City','ca','90292', 'US');
		System.AssertEquals('123', author.Id);
		System.assertEquals('ben@gmail.com', author.email);
	}
}