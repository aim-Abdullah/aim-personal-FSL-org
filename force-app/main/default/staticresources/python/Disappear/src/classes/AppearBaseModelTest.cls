@IsTest
public class AppearBaseModelTest extends AppearBaseModel {

	@IsTest
	public static void unitTest() {
		AppearBaseModelTest bmt = new AppearBaseModelTest();
		bmt.AppearAddErrorMessage('hello world !');
	}
}