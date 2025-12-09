@IsTest
public class PubHeaderDTOTest {
	
	@isTest
	public static void UnitTest() {
		Publication__c pub = UnitTestData.PublicationNew('PubHeaderDTOTest');
		
		AppearPubModel activePub = new AppearPubModel(pub.id);
		
		System.assertNotEquals(null, activePub.PubHeader);
		System.assertNotEquals(null, activePub.PubHeader.PubId);
		System.assertNotEquals(null, activePub.PubHeader.PubTitle);
		System.assertNotEquals(null, activePub.PubHeader.CurrentSubmissionCycle);
		System.assertEquals(null, activePub.PubHeader.CurrentFprCycle);
		System.assertNotEquals(null, activePub.PubHeader.PubType);
		System.assertNotEquals(null, activePub.PubHeader.CurrentStatus);
		System.assertEquals(null, activePub.PubHeader.Authors);
		System.assertNotEquals(null, activePub.PubHeader.CurrentTarget);
	}

}