@IsTest
public class ContactIdentifierTriggerLogicTest{
    
    @IsTest
    public static void unitTest1(){
        List<Contact> contactList=new List<Contact>();
        AccountModelData.createData();  
        contactList.add(new Contact(LastName= 'CI', FirstName='test1',AccountId=AccountModel.AccountNameMap.get('AMGEN').Id, Email='test1@amgen.com'));
        contactList.add(new Contact(LastName= 'CI', FirstName='test2',AccountId=AccountModel.AccountNameMap.get('AMGEN').Id, Email='test2@amgen.com'));
        contactList.add(new Contact(LastName= 'CI', FirstName='test3',AccountId=AccountModel.AccountNameMap.get('AMGEN').Id, Email='test3@amgen.com'));
        insert contactList;
        
        Author_Identity__c authIdentity= new Author_Identity__c();
        authIdentity.Author_Contact__c=contactList[0].Id;
        authIdentity.Identity_Number__c='CI001';
        authIdentity.Identity_Type__c='National Provider Identifier (NPI)';
        insert authIdentity;
        
        Author_Identity__c authIdentity2= new Author_Identity__c();
        authIdentity2.Author_Contact__c=contactList[0].Id;
        authIdentity2.Identity_Number__c='CI0003';
        authIdentity2.Identity_Type__c='National Provider Identifier (NPI)';
        insert authIdentity2;
        
        
        Author_Identity__c authIdentity3= new Author_Identity__c();
        authIdentity3.Author_Contact__c=contactList[0].Id;
        authIdentity3.Identity_Number__c='ABC123';
        authIdentity3.Identity_Type__c='Others';
        insert authIdentity3;
        
        authIdentity.Identity_Type__c='Others';
        authIdentity.Identity_Number__c='CI002';
        authIdentity2.Identity_Type__c='Others';
        authIdentity2.Identity_Number__c='CI003';

        update authIdentity;
        update authIdentity2;
        authIdentity2.Identity_Type__c='National Provider Identifier (NPI)';
        authIdentity2.Identity_Number__c='123ABC2';
        update authIdentity2;
        
        delete authIdentity;
        delete authIdentity2; 
        delete authIdentity3;
    }
}