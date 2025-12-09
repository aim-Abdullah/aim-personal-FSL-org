@IsTest
public class UserModelTest {
    
    @IsTest
    public static void unitTest() {     
        System.assertNotEquals(null, UserModelData.bschoenUser);
        System.assertNotEquals(null, UserModelData.cruesgaUser);
        user u;
        UserModelData.cruesgaUser = u;
        UserModelData.bschoenUser = u;
    }
    
    @isTest
    public static void JitValidateUser(){
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
        
        
        List<id> pubUserOrGroupIds = new list<Id>();
        pubUserOrGroupIds.add(usercheck.id);
        
        UserModel.getUserMap(pubUserOrGroupIds);
        UserModel.getallUserList();
        Map<String,User> UserMapByName = UserModel.getUserMapByName();
        user TempPoolUser = UserModel.TemporaryPoolUser;
        Map<String,User> UserNameMap = UserModel.UserNameMap;
        
        Set<Id> futureuserids = new Set<Id>();
        futureuserids.add(usercheck.id);
        
        System.Test.startTest();
        UpdateContactUserId.UpdateContact(futureuserids);
        System.Test.stopTest();
        
        //refresh from DB after test
        concheck = [Select Id,userid__c from Contact where email='jittest@amgen.com'];
        usercheck =  [Select Id,firstname,title,username from User where email='jittest@amgen.com'];
        
        // System.assertNotEquals(null, usercheck);
        //System.assertNotEquals(null, concheck);
        //system.assertEquals('jittest@amgenappear.com', usercheck.Username);//JIT trigger changed domain to amgenappear
        //System.assertEquals(usercheck.firstname, 'JITFirstName');
        //System.assertEquals(usercheck.title, 'Manager');
        // System.assertNotEquals(null, concheck.Userid__c);
    
            
    } 

	//Appear Enhancement - backlog Item R1:2017 Release
    @isTest
    public static void testUserEmailUpdate(){
    	Test.startTest();
        AccountModelData.createData();
        Account Acct = [Select Id from Account where Name = 'AMGEN'];
        RecordType recordType = [SELECT Id FROM RecordType WHERE Name = 'Appear Contact' AND SobjectType = 'Contact'];
        
        List<Contact> ConList = new List <Contact>();
        ConList.add(new Contact(AccountId=Acct.Id, firstname = 'FirstName',lastname='LastName',email='test@amgen.com',country__c = 'United States',RecordTypeId=recordType.Id));
        insert ConList;
        
        Profile P = [select Id from Profile where Name = 'APPEAR Business Admin'];
        
        List<User> UserList = new List<User>();
        UserList.add (new User (Alias = 'test9891',EmailEncodingKey='UTF-8',username='testramuk@amgen.com',
            LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles',
            lastname='test',profileId =p.Id,email='test@amgen.com',Is_SAML_JIT__c ='TRUE'));
        
        insert UserList;
        
        Contact con =[Select Id, Email, UserId__c from Contact where id =:ConList[0].Id];
        con.Email='newEmail@email.com';
        con.UserId__c = UserList[0].id;
        update con;
        Test.stopTest();        
    }
}