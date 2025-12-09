public class CreatePubResult {
	public Publication__c pub { get; private set;}
	public Boolean isSuccessful { get; private set;}
	public String errorMessage { get; private set;}
	
	public CreatePubResult(Publication__c pub, boolean isSuccessful, String errorMessage) {
		this.pub = pub;
		this.isSuccessful = isSuccessful;
		this.errorMessage = errorMessage;
	}
	
	//Successful
	public CreatePubResult(Publication__c pub){
		this(pub, true, null);  
	}
	
	//error
	public CreatePubResult(string error){
		this(null, false, error);	
	}
	
	@IsTest 
	public static void UnitTest() {
		publication__c pub1 = UnitTestData.PublicationNew('CPR Pub');
		
		CreatePubResult cpr = new CreatePubResult(pub1);
		System.assertNotEquals(null, cpr);
		
		CreatePubResult cpr2 = new CreatePubResult('Error cannot create');
		System.assertNotEquals(null, cpr2);
		
	}
}