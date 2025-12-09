/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
    @IsTest(SeeAllData=true) 
    public static void testCommunitiesSelfRegController() {
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
    }    

    @IsTest(SeeAllData=true) 
    public static void testRegister() {

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();

		// create two contacts
		Contact c1 = new Contact(FirstName ='John', LastName = 'Smith', Phone = '415.123.4567', Email = 'jsmith@test.com');
		insert c1;
		System.assert(c1.id != null); 
		Contact c2 = new Contact(FirstName ='Joan', LastName = 'Smith', Phone = '415.123.4567', Email = 'jsmith1@test.com');   
		insert c2;

		Contact aContact = CommunitiesSelfRegController.getContactInfo(c2.Id); 

		controller.firstName = c1.FirstName;
		controller.lastName = c1.lastName;		
		controller.email = c1.email;
		controller.password = 'John12345'; 
        controller.confirmPassword = 'John12345';
        controller.userId = 'jsmith@test.com';    
        controller.contactId = c1.id;
        controller.pubid = '123456789012345678';
       
         
         
		PageReference loginResult =     controller.registerUser();     		
		System.assert(c1.id != null); 
		
    }        
   
    
}