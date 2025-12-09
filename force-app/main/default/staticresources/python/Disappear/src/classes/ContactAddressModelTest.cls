@isTest
public class ContactAddressModelTest {

@isTest
public static void UnitTest() {
		AccountModelData.createData();
		
		Contact contact = new Contact(UserId__c=UserInfo.getUserId(),
														LastName= 'Contact Address', FirstName='ContactTest',
														AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,
														Email='skurmana1@amgen.com');

        insert contact;
    	
    	Contact_Address__c contAddr1 = new Contact_Address__c (Contact_Name__c=contact.id,
    															Street_Address__c='Hello World 123',
    															Address_Source__c='Manual',
    															Primary_Address__c=true,
    															City__c='Lala Land',
    															State_Province__c='CA',
    															Country__c='United States',
    															Zip_Postal_Code__c='123455'	 
    															);
    	
    	insert contAddr1;
    	
    	Contact_Address__c contAddr2 = new Contact_Address__c (Contact_Name__c=contact.id,
    															Street_Address__c='Abc World 123',
    															Address_Source__c='Manual',
    															Primary_Address__c=false,
    															City__c='Lala Land 2',
    															State_Province__c='MS',
    															Country__c='United States',
    															Zip_Postal_Code__c='123455',
    															isLogicallyDeleted__c=true	 
    															);
    	
    	insert contAddr2;
    	
    	Contact_Address__c allContactAddresses = ContactAddressModel.getAllContactAddresses(contact);
    	System.assertNotEquals(null, allContactAddresses);
    	List<Contact_Address__c> activeContactAddresses = ContactAddressModel.getActiveContactAddresses(contact);
    	System.assertEquals(1, activeContactAddresses.size());
    	
    	
    	Contact contact2 = new Contact(UserId__c=UserInfo.getUserId(),
														LastName= 'Contact Address 2', FirstName='ContactTest2',
														AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,
														Email='skurmana2@amgen.com');

        insert contact2;
    	
    	allContactAddresses = ContactAddressModel.getAllContactAddresses(contact2);
    	System.assertEquals(null, allContactAddresses);
    	activeContactAddresses = ContactAddressModel.getActiveContactAddresses(contact2);
    	System.assertEquals(null, activeContactAddresses);
    }
}