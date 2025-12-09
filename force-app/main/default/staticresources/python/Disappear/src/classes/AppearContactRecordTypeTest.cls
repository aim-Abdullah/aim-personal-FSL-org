@isTest
public with sharing class AppearContactRecordTypeTest 
{

   @isTest
    public static void validateConRecTypebatch()
    {	
		List<Contact> ConList = new List <Contact>();
    	
    	AccountModelData.createData();
    	Account Acct = [Select Id from Account where Name = 'AMGEN'];
    	   	
    	ConList.add(new Contact(AccountId=Acct.Id, firstname = 'FirstName',lastname='LastName',email='jittest@amgen.com',isactive__c=true));
    	ConList.add(new Contact(AccountId=Acct.Id, firstname = 'FirstName',lastname='LastName',email='jittest@salesforce.com',isactive__c=true));
    	ConList.add(new Contact(AccountId=Acct.Id, firstname = 'FirstName',lastname='LastName',isactive__c=true));
    	insert ConList;
    	
    	RecordType ac = [select Id from recordtype where Name = 'Appear Contact' limit 1];
		RecordType ic = [select Id from recordtype where Name = 'Internal Contact' limit 1];
    	
    	
    	AppearContactRecordType.UpdateConRecType(ConList, ac,ic);
    	
    	List<Contact> concheck = [Select Id,RecordTypeId from Contact where firstname='FirstName'];
    	
    	for (Contact c: concheck)
    	{
    	   	System.assertNotEquals(c.RecordTypeId, null);
    	}  	
    }	

}