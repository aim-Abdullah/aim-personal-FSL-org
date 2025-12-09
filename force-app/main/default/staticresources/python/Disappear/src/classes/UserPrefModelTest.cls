@IsTest
public class UserPrefModelTest {

	@IsTest
	public static void UnitTest() {		
        Publication__c pub = UnitTestData.PublicationNew('UserPrefModelTest');
		System.Test.startTest();		
		
		System.AssertEquals(null, UserPrefModel.ActivePub);
		UserPrefModel.ActivePub = pub.Id;
		
		System.AssertNotEquals(null, UserPrefModel.UserId);
		System.AssertNotEquals(null, UserPrefModel.UserName);
		System.AssertNotEquals(null, UserPrefModel.ActivePub);		
		
		UserPrefModel.ActivePub = null;		
		UserPrefModel.clearMyPubIdPref();
		
		UserPrefModel.ActivePubAuthor = null;
		
		System.Test.stopTest();
	}
}