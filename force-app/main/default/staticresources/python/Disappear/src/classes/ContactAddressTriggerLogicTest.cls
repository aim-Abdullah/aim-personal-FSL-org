/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class ContactAddressTriggerLogicTest {
	
	 private static void CreateData() {
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        AccountModelData.createData();
        AppearContactModelData.createData(); 
        CreateContactAddressData();
    }
    
    private static void CreateContactAddressData() {
        List<Contact> chkContactList = [select Id, Name from Contact where FirstName='Michael' and LastName='Dorner'];
        if ( chkContactList.size() == 0) return;
        
        List<Contact_Address__c> ContactAddressList = new List<Contact_Address__c>();
        
        ContactAddressList.add( new Contact_Address__c(
										        	Contact_Name__c= chkContactList[0].Id, 
										        	Country__c = 'United States', 
										        	City__c = 'San Pismo',
										        	Primary_Address__c = false,
										        	State_Province__c = 'Oregon',
										        	Street_Address__c = '123 Mikrasio St',
										        	Zip_Postal_Code__c = '87654-9134'
										        	));


        insert ContactAddressList;
    }
    
    @IsTest 
    private static void contactAddressesTrigger() {
    	CreateData();
    	
    	List<Contact_Address__c> chkContactAddrList = [select Id, Contact_Name__c from Contact_Address__c where Contact_Name__r.FirstName='Michael' and Contact_Name__r.LastName='Dorner'];
    	
    	List<Contact_Address__c> testContactAddressList1 = ContactAddressTriggerLogic.findPrimaryContactAddresses(chkContactAddrList);
    	
    	System.assertNotEquals(null, testContactAddressList1);
        
        List<Contact_Address__c> ContactAddressList2 = new List<Contact_Address__c>(); 
        
	    ContactAddressList2.add( new Contact_Address__c(
																			        	Contact_Name__c= chkContactAddrList[0].Contact_Name__c, 
																			        	Country__c = 'United States', 
																			        	City__c = 'San Pedro Limo',
																			        	Primary_Address__c = false,
																			        	State_Province__c = 'California',
																			        	Street_Address__c = '123 Solvang Ave',
																			        	Zip_Postal_Code__c = '12349-0134'
																			        	));
        insert ContactAddressList2;
        
        List<Contact_Address__c> testContactAddressList2 = ContactAddressTriggerLogic.findPrimaryContactAddresses(ContactAddressList2);
        
        System.assertNotEquals(null, testContactAddressList2);    	
    }
}