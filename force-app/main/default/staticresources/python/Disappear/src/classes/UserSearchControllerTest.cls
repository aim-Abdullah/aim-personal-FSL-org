@IsTest
public class UserSearchControllerTest {

	@IsTest
	public static void UnitTest() {
		
		CreateData();

		
		UserSearchController usc = new UserSearchController();
		
		System.assertNotEquals(null, usc.Users);
		System.assertNotEquals(null, usc.debugSoql);
		usc.toggleSort();
		
		Apexpages.currentPage().getParameters().put('firstname','firstname');
    	Apexpages.currentPage().getParameters().put('lastname','lastname');
    	Apexpages.currentPage().getParameters().put('email','email');
    	Apexpages.currentPage().getParameters().put('alias','alias');
    	Apexpages.currentPage().getParameters().put('username','username');
    	Apexpages.currentPage().getParameters().put('isactive','isactive');
    	Apexpages.currentPage().getParameters().put('userRoleID','userRoleID');
    	Apexpages.currentPage().getParameters().put('profileID','profileID');
    	Apexpages.currentPage().getParameters().put('federationidentifier','federationidentifier');
    	
    	usc.parseURL();
    	usc.runSearch();
    	
    	usc.saveChanges();
	}
	
	public static void CreateData(){
		
		Pagereference pageRef = Page.AppearUserAdmin;
		Test.setCurrentPage(pageRef);
		

	}
}