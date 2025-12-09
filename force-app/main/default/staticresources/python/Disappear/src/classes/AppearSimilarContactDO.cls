global class AppearSimilarContactDO {
	
	public string id{get;set;}
	public string FirstName {get;set;}
	public string LastName {get;set;}
	public string Email {get;set;}
	public string Phone {get;set;}
	
	global AppearSimilarContactDO(Contact aContact){
		id = aContact.id;
		FirstName = aContact.FirstName;
		LastName = aContact.LastName;
		Email = aContact.Email;
		Phone = aContact.Phone;
	} 
	
	global static List<AppearSimilarContactDO> getSimilarContacts(string soql) {
		System.Debug('AppearSimilarContactDO.getSimilarContacts : '+soql);
		List<Contact> contacts = Database.query(soql);
		
		List<AppearSimilarContactDO> results = new list<AppearSimilarContactDO>();
		for(Contact aContact : contacts){  
			results.add(new AppearSimilarContactDO(aContact));
		}  
		return results;
	}
	
	global static List<AppearSimilarContactDO> getSampleContacts(integer numResult) {
		string soql = 'select id, FirstName, LastName, Email, Phone from Contact limit '+ numResult;
		List<AppearSimilarContactDO>  results = getSimilarContacts(soql);
		   
		return results; 
	}
	
	private static testMethod void unitTest() {
		List<AppearSimilarContactDO> results = AppearSimilarContactDO.getSampleContacts(10);
		System.assertNotEquals(null, results);
	}
	
	private static testMethod void unitTestSimilarContact() {
		List<contact> contacts = new List<contact>();
		contacts.add(new Contact(firstName='Ben', LastName='Lau'));
		insert contacts;
		
		string soql = 'select id, FirstName, LastName, Email, Phone from Contact where Firstname = \'Ben\' ';
		List<AppearSimilarContactDO> results = AppearSimilarContactDO.getSimilarContacts(soql);
		System.assertNotEquals(null, results);
	}
	
}