@isTest
public with sharing class ProxyDelegateUtilityTests {
	private static void CreateData() {
		OrganizationModelData.createData();
        DepartmentModelData.createData();
        AccountModelData.createData();
        AppearContactModelData.createData();
        AppearTriggerActivationModel.isPubReviewTeamTriggerActive = false;
	}
	
	private static Publication__c pProxyDelegateTestPub;
    public static Publication__c ProxyDelegateTestPub {
        get {
            if (pProxyDelegateTestPub == null) {
                CreateData();
                pProxyDelegateTestPub = UnitTestData.PublicationNew('ProxyDelegateUtilityTests');
            }
            return pProxyDelegateTestPub;
        }
    }
	
	@isTest
	private static void TestSingleProxy() {
		CreateData();
		
		List<Contact> allContacts = [Select id, Name, UserId__c, Proxy__c from Contact];
		System.assert(allContacts.size() > 3);	
			
		Contact contactBeingProxied = allContacts[0];
		Contact proxyContact =  allContacts[1];
		contactBeingProxied.Proxy__c = proxyContact.Id;
		update contactBeingProxied;
		
		AppearPubModel pubModel = new AppearPubModel(ProxyDelegateTestPub.Id);
		
		FPR_Cycle__c fprCycle = new FPR_Cycle__c(FPR_Cycle_Num__c=1, Incremental_FPR_Cycle_c__c=1, Publication__c=pubModel.PubId);
		insert fprCycle;
		
		//Insert Primary Reviewer
		PubReviewTeam__c primaryReviewer = new PubReviewTeam__c( Reviewer__c = contactBeingProxied.Id, Type__c = 'Primary', 
																 Publication__c = pubModel.PubId, FPR_Cycle__c = fprCycle.Id, Delivered__c = Date.today() ); 
		insert primaryReviewer;		 
		 
		ProxyDelegateUtility.ProxyOrDelegatePrimary(primaryReviewer);
		
		primaryReviewer.HasVoted__c = true;
		primaryReviewer.Reviewer_Status__c = 'test';
		primaryReviewer.Comments__c = 'test';
		
		ProxyDelegateUtility.SyncUpdateWithProxies(primaryReviewer);
		
		List<PubReviewTeam__c> allReviewers = PubReviewTeamModel.getReviewTeamMembers(pubModel.PubId, false);
		
		System.AssertEquals(2, allReviewers.size()); //expect 1 additional reviewer to be proxied
		
		for(PubReviewTeam__c reviewer : ProxyDelegateUtility.GetProxiesForAndProxiedBy(primaryReviewer)) { //assert that vote update synced properly
			System.assertEquals(primaryReviewer.HasVoted__c, reviewer.HasVoted__c);
			System.assertEquals(primaryReviewer.Reviewer_Status__c, reviewer.Reviewer_Status__c);
			System.assertEquals(primaryReviewer.Comments__c, reviewer.Comments__c);
		}
	}
	
	
	@isTest
	private static void TestSingleDelegate() {
		CreateData();
		
		List<Contact> allContacts = [Select id, Name, UserId__c, Proxy__c from Contact];
		System.assert(allContacts.size() > 3);
			
		Contact contactBeingDelegated = allContacts[0];
		Contact delegateContact =  allContacts[1];
		
		ContactDelegate__c testDelegate = new ContactDelegate__c(Contact__c = contactBeingDelegated.id, Delegate__c = delegateContact.id, start_Date__c = Date.today().addDays(-7),
																 end_Date__c = Date.today().addDays(7), isActive__c = true);
		insert testDelegate;
		
		AppearPubModel pubModel = new AppearPubModel(ProxyDelegateTestPub.Id);
		
		FPR_Cycle__c fprCycle = new FPR_Cycle__c(FPR_Cycle_Num__c=1, Incremental_FPR_Cycle_c__c=1, Publication__c=pubModel.PubId);
		insert fprCycle;
		
		//Insert Primary Reviewer
		PubReviewTeam__c primaryReviewer = new PubReviewTeam__c( Reviewer__c = contactBeingDelegated.Id, Type__c = 'Primary', 
																 Publication__c = pubModel.PubId, FPR_Cycle__c = fprCycle.Id, Delivered__c = Date.today() ); 
		
		insert primaryReviewer;		 
		 
		system.AssertNotEquals(null, ProxyDelegateUtility.ProxyOrDelegatePrimary(primaryReviewer));
		
		List<PubReviewTeam__c> allReviewers = PubReviewTeamModel.getReviewTeamMembers(pubModel.PubId, false);
		
		System.AssertEquals(2, allReviewers.size()); //expect 1 additional reviewer to be proxied
		
		Integer numOfPrimary = 0;
		Integer numOfNotify = 0;
		for(PubReviewTeam__c reviewer : allReviewers) {
			if (reviewer.Type__c == 'Primary') {
				numOfPrimary++;
			} else if (reviewer.Type__c == 'Notify') {
				numOfNotify++;
			}  
		}
		
		System.AssertEquals(1, numOfPrimary);
		System.AssertEquals(1, numOfNotify);
	}
	
	@isTest
	private static void TestDelegateTopOfProxyChain() {
		CreateData();
		
		List<Contact> allContacts = [Select id, Name, UserId__c, Proxy__c from Contact];
		System.assert(allContacts.size() > 3);	
		
		Contact contactBeingProxied = allContacts[0];
		Contact proxyContactBeingDelegated =  allContacts[1];
		Contact delegateContact =  allContacts[2];
		
		contactBeingProxied.Proxy__c = proxyContactBeingDelegated.Id;
		update contactBeingProxied;
		
		ContactDelegate__c testDelegate = new ContactDelegate__c(Contact__c = proxyContactBeingDelegated.id, Delegate__c = delegateContact.id, start_Date__c = Date.today().addDays(-7),
																 end_Date__c = Date.today().addDays(7), isActive__c = true);
		insert testDelegate;
		
		AppearPubModel pubModel = new AppearPubModel(ProxyDelegateTestPub.Id);
		
		FPR_Cycle__c fprCycle = new FPR_Cycle__c(FPR_Cycle_Num__c=1, Incremental_FPR_Cycle_c__c=1, Publication__c=pubModel.PubId);
		insert fprCycle;
		
		//Insert Primary Reviewer
		PubReviewTeam__c primaryReviewer = new PubReviewTeam__c( Reviewer__c = contactBeingProxied.Id, Type__c = 'Primary', 
																 Publication__c = pubModel.PubId, FPR_Cycle__c = fprCycle.Id, Delivered__c = Date.today() ); 
		
		insert primaryReviewer;		 
		 
		system.AssertNotEquals(null, ProxyDelegateUtility.ProxyOrDelegatePrimary(primaryReviewer));
		
		List<PubReviewTeam__c> allReviewers = PubReviewTeamModel.getReviewTeamMembers(pubModel.PubId, false);
		
		System.AssertEquals(3, allReviewers.size()); //expect 1 additional reviewer to be proxied
		
		Integer numOfPrimary = 0;
		Integer numOfNotify = 0;
		for(PubReviewTeam__c reviewer : allReviewers) {
			if (reviewer.Type__c == 'Primary') {
				numOfPrimary++;
			} else if (reviewer.Type__c == 'Notify') {
				numOfNotify++;
			}  
		}
		
		System.AssertEquals(1, numOfPrimary);
		System.AssertEquals(2, numOfNotify);
	}
	
	@isTest
	private static void TestMaxProxy() {
		CreateData();
		
        List<Contact> additionalContacts = new List<Contact>();
        
        additionalContacts.add( new Contact(LastName= 'Dorner2', FirstName='Michael2', Country__c='United States', 
        	AccountId=AccountModelData.AmgenAccount.Id, 
            SponsoringDept__c=DepartmentModelData.GlobalHealthEconomicDept.Id,
            Email='mike1@amgen.com'));
        additionalContacts.add( new Contact(LastName= 'Weiss2', FirstName='Solange2', 
        	AccountId=AccountModelData.AmgenAccount.Id, 
            SponsoringDept__c=DepartmentModelData.GlobalMedicalWritingDept.Id,
            Department='Global Medical Writing'));
        insert additionalContacts;
		
		List<Contact> allContacts = [Select id, Name, UserId__c, Proxy__c from Contact];
		System.assert(allContacts.size() > ProxyDelegateUtility.MaxProxyDelegateCount + 1);	
		
		for(integer i = 0; i < allContacts.size() - 1; i++) {
			allContacts[i].Proxy__c = allContacts[i + 1].Id;
		}

		update allContacts;
		
		AppearPubModel pubModel = new AppearPubModel(ProxyDelegateTestPub.Id);
		
		FPR_Cycle__c fprCycle = new FPR_Cycle__c(FPR_Cycle_Num__c=1, Incremental_FPR_Cycle_c__c=1, Publication__c=pubModel.PubId);
		insert fprCycle;
		
		//Insert Primary Reviewer
		PubReviewTeam__c primaryReviewer = new PubReviewTeam__c( Reviewer__c = allContacts[0].Id, Type__c = 'Primary', 
																 Publication__c = pubModel.PubId, FPR_Cycle__c = fprCycle.Id ); 
		insert primaryReviewer;		 
		 
		ProxyDelegateUtility.ProxyOrDelegatePrimary(primaryReviewer);
		
		List<PubReviewTeam__c> allReviewers = PubReviewTeamModel.getReviewTeamMembers(pubModel.PubId, false);
		System.AssertEquals(ProxyDelegateUtility.MaxProxyDelegateCount+1, allReviewers.size()); //expect max  additional reviewers to be proxied + initial reviewer
		System.AssertEquals(ProxyDelegateUtility.MaxProxyDelegateCount, ProxyDelegateUtility.GetProxiesForAndProxiedBy(allReviewers[1]).size()); //expect exact # of reviewers to be proxied by and for as max. Testing both directions		
		System.AssertEquals(ProxyDelegateUtility.MaxProxyDelegateCount, ProxyDelegateUtility.GetProxiesForAndProxiedBy(allReviewers[allReviewers.size()-2]).size()); //expect exact # of reviewers to be proxied by and for as max. Testing both directions
	}
}