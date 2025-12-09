public class EmailPubReviewTeam{


	private static AppearPubModel pTestPub = null;
	public static AppearPubModel testPub {
		get {  
			if (pTestPub == null) {
				pTestPub = createTestPub();
			}
			return pTestPub;
		}
	}


	private static Contact pContact1 = null;
	public static Contact contact1 {
		get {
			if ( pContact1 <> null) { 
				return pContact1;
			}
			List<Contact> contacts = [
				select id,name,FirstName, Lastname, Email
				from Contact
				where email = 'benjamin_lau@yahoo.com'
			];
			if ( contacts.size() == 1) {
				pContact1 = contacts[0];
			} else {
				Contact myContact = new Contact();
				myContact.FirstName = 'Benjamin';
				myContact.LastName = 'Lau';
				myContact.Email = 'benjamin_lau@yahoo.com';
				insert myContact;	
				pContact1 = myContact;			
			}
			return pContact1;
		}
	}

	private static Contact pContact2 = null;
	public static Contact contact2 {
		get {
			if ( pContact2 <> null) {
				return pContact2;
			}
			List<Contact> contacts = [
				select id,name,FirstName, Lastname, Email
				from Contact
				where email = 'benjamin_lau@hotmail.com'
			];
			if ( contacts.size() == 1) {
				pContact2 = contacts[0];
			} else {
				Contact myContact = new Contact();
				myContact.FirstName = 'Brandon';
				myContact.LastName = 'Schoen';
				myContact.Email = 'benjamin_lau@hotmail.com';
				insert myContact;	
				pContact2 = myContact;			
			}
			return pContact2;
		}
	}


	public static AppearPubModel createTestPub() {

		Publication__c pub = UnitTestData.PublicationNew('test pub');
		pub.Assigned_FPRC__c = contact2.id;
		pub.FPR_Submitter__c = contact1.id;
		pub.FPR_Due_Date__c = Date.today().addDays(30);
		pub.Current_Target__c = '[Current Target Meeting]';
		pub.Primary__c = '[Primary Product]';
		pub.Publication_Type__c ='[Publication Type]';
		pub.Product_Indication__c = 'Product Indication 1; Product Indication2;';
		update pub;		
		
		AppearPubModel activePub = new AppearPubModel(pub.id); 
		PubReviewTeam__c reviewTeamMemberCycle = activePub.PubReviewTeam.NewPubReviewTeamMembers;
		FPR_Cycle__c firstFprCycle = activePub.FprCycle.getFprCycleByNum(1);
		reviewTeamMemberCycle.FPR_Cycle__c = firstFprCycle.id;
		reviewTeamMemberCycle.Reviewer__c = contact1.id;
		reviewTeamMemberCycle.Delegation_Justification__c = '[A good delegation justification]';
		//reviewTeamMemberCycle.DelegatedTo__c = 
		
		reviewTeamMemberCycle.TriageDelegatedBy__c = contact1.id;
		reviewTeamMemberCycle.Triage_Justification__c = '[A good triage justification]';
		
		insert reviewTeamMemberCycle;
		 
		return activePub;
	}

}