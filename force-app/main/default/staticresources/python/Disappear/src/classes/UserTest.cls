@isTest
public class UserTest{

    @isTest
    public static void validateUser()
    {
    	List<User> UserList = new List<User>();
    	List<Contact> ConList = new List <Contact>();
    	
    	AccountModelData.createData();
    	Account Acct = [Select Id from Account where Name = 'AMGEN'];
    	   	
    	ConList.add(new Contact(AccountId=Acct.Id, firstname = 'JITFirstName',lastname='JITLastName',email='jittest@amgen.com',isactive__c=true,title='Manager'));
    	
    	insert ConList;
 
    	
    	Profile P = [select Id from Profile where Name = 'APPEAR FPR Only Submitter'];
    	
    	
    	UserList.add (new User (Alias = 'jittest',EmailEncodingKey='UTF-8',username='jittest@amgen.com',
    		LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles',
     		lastname='test',profileId =p.Id,email='jittest@amgen.com',Is_SAML_JIT__c ='TRUE' )); 
    	
    	
    	insert UserList;
    	
    
		Contact concheck = [Select Id,userid__c from Contact where email='jittest@amgen.com'];	
    	User usercheck =  [Select Id,firstname,title from User where email='jittest@amgen.com'];
    	
    	Set<Id> futureuserids = new Set<Id>();
    	futureuserids.add(usercheck.id);
    	
    	System.Test.startTest();
    	UpdateContactUserId.UpdateContact(futureuserids);
    	System.Test.stopTest();
    	
    	//refresh from DB after test
    	concheck = [Select Id,userid__c from Contact where email='jittest@amgen.com'];
    	usercheck =  [Select Id,firstname,title,username from User where email='jittest@amgen.com'];
    	
    	System.assertNotEquals(null, usercheck);
    	System.assertNotEquals(null, concheck);
    	//system.assertEquals('jittest@amgenappear.com', usercheck.Username);//JIT trigger changed domain to amgenappear
    	System.assertEquals(usercheck.firstname, 'JITFirstName');
    	System.assertEquals(usercheck.title, 'Manager');
    	System.assertNotEquals(null, concheck.Userid__c);
   	
    		
    }    
}