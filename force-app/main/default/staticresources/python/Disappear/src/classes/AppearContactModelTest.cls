@IsTest
public class AppearContactModelTest {

	@IsTest
	public static void UnitTestCreateContactAndUser() {
		Contact c = AppearContactModel.createContactAndUser(
			'contactLastName', 'contactFirstName', 'contactEmail@amgen.com', 
			12345678, ProfileModel.AppearFprOnlySubmitterProfile);
			
		System.assertNotEquals(null, c.id);
	}
	
    @IsTest
    public static void UnitTest(){
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        AccountModelData.createData();
        AppearContactModelData.createData(); 
       
        
        List<AppearSimilarContactDO> contactDO1s = AppearContactModel.SimilarContacts(null, 10);
        System.assertNotEquals(null, contactDO1s);
        System.assert(contactDO1s.size() == 0);
        
        List<AppearSimilarContactDO> contactDO2s = AppearContactModel.SimilarContacts('Mike', 10);
        System.assertNotEquals(null, contactDO2s);
        System.assert(contactDO2s.size() == 0);
        
        List<AppearSimilarContactDO> contactDO3s = AppearContactModel.SimilarContacts('Maxwell, Michelle', 10);
        System.assertNotEquals(null, contactDO3s);
        System.assert(contactDO3s.size() == 1);
        
        List<AppearSimilarContactDO> contactDO4s = AppearContactModel.SimilarContacts('mike@amgen', 10);
        System.assertNotEquals(null, contactDO4s);
        System.assert(contactDO4s.size() == 1);

        
        List<id> contactIdList = new List<Id>();
        List<Contact> contactListEmpty = AppearContactModel.getContactList(contactIdList);
        System.assertNotEquals(null, contactListEmpty);
        
        contactIdList.add(contactDO3s[0].id);
        contactIdList.add(contactDO4s[0].id);
        
        List<Contact> contactList = AppearContactModel.getContactList(contactIdList);
        System.assertNotEquals(null, contactIdList);
        System.assert(contactIdList.size() == 2);

        Map<id,contact> contactMap = AppearContactModel.getContactMap(contactIdList);
        System.assertNotEquals(null, contactMap);
        System.assert(contactMap.size() == 2);
        
        boolean enbrelRestricted = AppearContactModel.isCurrentUserEnbrelRestricted;
        
        User appearUser = null;
        System.assertEquals(null, AppearContactModel.findContactForAppearUser(appearUser));
        
        Id appearUserId = null;
        System.assertEquals(null, AppearContactModel.findContactForAppearUser(appearUserId));
        
        Set<Id> findContactIdSet = AppearContactModel.findContactForAppearUser(contactList[0].id);
        System.assertNotEquals(null,findContactIdSet);
       
        Contact contactProxy = AppearContactModel.findProxyForContactId(contactList[0].id);
        System.assertEquals(null,contactProxy);
        
        Department__c dept = AppearContactModel.findContactDepartment(contactDO3s[0].id);
        System.assertNotEquals(null, dept);
        

        System.assertEquals(null, AppearContactModel.findContactDepartment(null));
        System.assertEquals(null, AppearContactModel.findContactDepartment(contactDO4s[0].id));
        
        //test Enbrel restricted
		
		//dataless test - my id should not have a contact or enbrel restricted
		System.assertEquals(false, AppearContactModel.isCurrentUserEnbrelRestricted);
		Contact myContact = new Contact();
		myContact.LastName = 'Lau';  
		myContact.FirstName = 'Benjamin';
		myContact.UserId__c = UserInfo.getUserId();
		myContact.Restrict_Enbrel__c = true;
		myContact.IsActive__c = false;
		myContact.EmploymentStatusCode__c = '3';
		insert  myContact;
		
		System.assertEquals(true, AppearContactModel.isCurrentUserEnbrelRestricted);
		myContact.Restrict_Enbrel__c = false;
		myContact.EmploymentStatusCode__c = '0';
		update myContact;
		System.assertEquals(false, AppearContactModel.isCurrentUserEnbrelRestricted);
		
        //test findContactByContactId
        Contact myContactRec = AppearContactModel.findContactByContactId(myContact.Id);
        System.assertEquals(UserInfo.getUserId(),myContactRec.UserId__c );
        
        Id myUserId = AppearContactModel.findUserIdForContactId(myContact.Id);
        System.assertEquals(UserInfo.getUserId(),myUserId );
        
        myContact.EmploymentStatusCode__c = '0';
        myContact.UserId__c = null;
		update myContact;
		
		myContact.EmploymentStatusCode__c = null;
		myContact.IsActive__c = true;
        myContact.UserId__c = null;
		update myContact;
    } 
}