@IsTest
public with sharing class PubAuthorTriggerLogicTest {
    private static Publication__c pPubAuthorTestPub = null;
    public static Publication__c PubAuthorTestPub {
        get {
            if (pPubAuthorTestPub == null) {
                CreateData();
                pPubAuthorTestPub = UnitTestData.PublicationNew('PubAuthorTriggerLogicTest');
            }
            return pPubAuthorTestPub;
        }
    }
    
    private static void CreateData() {
		OrganizationModelData.createData();
        DepartmentModelData.createData();
        AccountModelData.createData();
        AppearContactModelData.createData();
        //R1:2017 - max author count data
        KeyValueSettings__c kvs = new KeyValueSettings__c(Name='CSP Pub Author Count',Key__c='Max_Author_Count',Value__c='10');
		insert kvs;
    }
    
    @IsTest
    private static void TestPubAuthorTriggerLogic() {
    	System.assert(PubAuthorTestPub != null);
    	PubStudy__c pubstudy = new PubStudy__c();
    	Pubstudy.Publication__c = PubAuthorTestPub.Id;
    	PubStudy.Study__c = null;
    	insert Pubstudy;
    	
    	list<pubstudy__c> pslist = new list<PubStudy__c>();
    	pslist.add(PubSTudy);
    	//PubAuthorTestPub.SponsoringDept__c ='test';
    	//PubAuthorTestPub.SponsoringOrg__c='test';
    	//update PubAuthorTestPub;
    	list<Publication__c> publist = new List<Publication__c>();
    	publist.add(PubAuthorTestPub);
    	PubAuthorTriggerLogic.PubProjectStudyUpdate(pslist, publist);
    	List<Contact> testContacts = [Select id From Contact Where Country__c =:'United States' Limit 5];
    	
    	PubAuthorModel authorModel = new PubAuthorModel(PubAuthorTestPub.Id, '','', PubAuthorTestPub, false);    	
    	
    	for(Contact author : testContacts) {
    		authorModel.NewAuthorId = author.Id;
    		System.assertNotEquals(null, authorModel.save());    		
    	}    	
    	
    	List<PubAuthor__c> pubAuthors = authorModel.PubAuthorList;    	
    	System.assertNotEquals(0, pubAuthors.size());
    	
    	PubAuthorTriggerLogic.PubAuthorTriggerInsertOrDeleteLogic(pubAuthors);    	
    	
    	//Publication__c refreshedPub = [Select id, HasUSAuthors__c from Publication__c where id = :PubAUthorTestPub.Id];
    	//System.assertequals(true,PubAUthorTestPub.HasUSAuthors__c); //Has US Authors On Pub
    	
    	//Contact usContact = [Select id, Country__c from Contact Where Country__c =:'United States'];
    	contact uscontact = testContacts[0];
    	usContact.Country__c = null;
    	update usContact;
    	
    	PubAuthorTriggerLogic.PubAuthorTriggerInsertOrDeleteLogic(pubAuthors);
    	
    	//refreshedPub = [Select id, HasUSAuthors__c from Publication__c where id = :PubAUthorTestPub.Id];
    	System.assertEquals(false,PubAUthorTestPub.HasUSAuthors__c); //No Longer US Authors On Pub
    	
    	PubAuthorTriggerLogic.PubAuthorTriggerInsertOrDeleteLogic(null);
    }
}