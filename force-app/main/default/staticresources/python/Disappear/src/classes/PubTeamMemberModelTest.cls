@isTest
public class PubTeamMemberModelTest {

    private static testMethod void unitTest() {
        Id pubId = prepareData();  
        
        
        
        AppearPubModel activePub = new AppearPubModel(pubId);
        System.assertNotEquals(null, activePub);
        System.assert(activePub.hasValidPub);
        
        PubTeamMemberModel pubTeamModel = new PubTeamMemberModel(pubId,'tile','menu', false, activePub);
        Id id1,Id2;
        List<PublicationTeamMember__c>  myteam = pubTeamModel.PubTeamMembers;
        System.assertEquals(null, pubTeamModel.LoggedInTeamMember);
        pubTeamModel.save();
        
        
    }

    
    private static Id prepareData() {
        Publication__c pub = UnitTestData.PublicationNew('testPub');
        System.assertNotEquals(null, pub);
        System.assertNotEquals(null, pub.id);
        return pub.id;
    }
    
    @isTest
    private static void testMaxPubTeamInsert() {
		integer limitToAssert = 100;
		Id userId = userInfo.getUserId();
		
        List<Contact> contactsToAdd = new List<Contact>(); 
        for (integer i = 0; i < limitToAssert; i++) {
        	Contact newContact = new Contact(lastname='testing'+i,firstname='apex'+i,userid__c=userId);
        	contactsToAdd.add(newContact);
        }
        insert contactsToAdd; //set initially to utilize cache as in real-world scenario
    	
    	Id pubId = prepareData();    	
    	
		Test.startTest();
    	
        AppearPubModel pubModel = new AppearPubModel(pubId);
		List<ProdIndTeamMember__c> teamMembersToAdd = new List<ProdIndTeamMember__c>();
		
		for(Contact contactToAdd : contactsToAdd) {
			ProdIndTeamMember__c teamMember = new ProdIndTeamMember__c( Contact__c = contactToAdd.Id);
			teamMembersToAdd.add(teamMember);
		}
		
		PubTeamMemberModel.createPubTeamMembers2(pubId, teamMembersToAdd, null); //inserts teamMembers using mechanism from pubTeam copy from indication		
		
		List<PublicationTeamMember__c>  myteam = pubModel.PubTeamMember.PubTeamMembers;
		for (PublicationTeamMember__c addedMember : myteam) {
			system.assertNotEquals(null, addedMember.Id);
		}
		
		System.assertNotEquals(null, pubModel.PubTeamMember.PubTeamMembersWritingRole);
		System.assertNotEquals(null, pubModel.PubTeamMember.NewPubTeamMember);
		System.assertNotEquals(null, PubTeamMemberModel.getPubTeamMembers(pubId));
		
		pubModel.PubTeamMember.NewPubTeamMember.Member__c = null;
		PageReference p = pubModel.PubTeamMember.saveNewTeamMember();
		
		Test.stopTest();
    }
        
    

}