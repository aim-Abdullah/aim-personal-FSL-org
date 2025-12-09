public class CloneResultDTO {
	
	public string sourcePubId{get;set;}
	public string destPubId{get;set;}
	public string clonePrefix{get;set;}
	public string clondPubTitle{get;set;}
	
	public boolean hasCloneCompleted{get;set;}
	public List<string> errorMsgs{get;set;}
	
	public CloneResultDTO(string PubId) {
		sourcePubId = PubId;
		hasCloneCompleted = false;
	}	
	
	
	public void AddErrorMsg(string msg){
		if ( errorMsgs == null) {
			errorMsgs = new List<string>();
		}
		errorMsgs.add(msg);
	}
	
	@IsTest
	public static void UnitTest() {
		CloneResultDTO cr = new CloneResultDTO('CR Pub');
		cr.AddErrorMsg('just an error');
		
		System.assertNotEquals(null, cr);
		System.assertEquals('just an error', cr.errorMsgs[0]);
	}
	
}