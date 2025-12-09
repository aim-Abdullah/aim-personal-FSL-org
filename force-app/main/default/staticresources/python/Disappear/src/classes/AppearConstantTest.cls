@IsTest
public class AppearConstantTest {
	
	@IsTest
	public static void UnitTest() {
		AppearConstants.SupportUnitTest();
		
		//Running Unit Test for Global Utility APEX Classes to increase the Code Coverage
		System.assertNotEquals(null, AppearURLDomainController.BaseURL);
        System.assertNotEquals(null, AppearURLDomainController.DomainURL);
        
        Publication__c pub = prepareData();
        AppearPubModel activePub = new AppearPubModel(pub.id);
        
        System.assertNotEquals(null, AppearUrlModel.AppearPubMenuUrl(AppearConstants.SUBMENU, AppearConstants.TILE, pub.id));
        System.assertNotEquals(null, AppearUrlModel.AppearFprMenuUrl(AppearConstants.SUBMENU, AppearConstants.TILE, pub.id));
        System.assertNotEquals(null, AppearUrlModel.AppearFprSubmitterMenuUrl(AppearConstants.SUBMENU, AppearConstants.TILE, pub.id));
        System.assertNotEquals(null, AppearUrlModel.AppearAuthorMenuUrl(AppearConstants.SUBMENU, AppearConstants.TILE, pub.id));
        System.assertNotEquals(null, AppearUrlModel.AppearPubMenuUrl(AppearConstants.SUBMENU, AppearConstants.TILE));
        System.assertNotEquals(null, AppearUrlModel.GetFprPortalPathForPubId(pub.id));
        System.assertNotEquals(null, AppearUrlModel.GetSimpleFprPortalPath());
        System.assertNotEquals(null, AppearUrlModel.AppearPubListUrl());
        
        ExecutionNotesModel enm = new ExecutionNotesModel(pub.id, AppearConstants.TILE, AppearConstants.SUBMENU, activePub);
        PageReference pr = enm.SaveComment();
        
        enm.Notes = 'This is something else for Unit Test';
        enm.NotesReadOnly = 'false';
        enm.SingleNote = 'One more single';
        PageReference pr1 = enm.SaveComment();
        
        pub.Execution_Notes_Last_Mod__c = DateTime.valueOf('2014-10-09 20:57:10');
        update pub;
        
        PageReference pr2 = enm.SaveComment();
    }
	
	private static Publication__c prepareData() {
        Publication__c pub = UnitTestData.PublicationNew('testPub');
        System.assertNotEquals(null, pub);
        System.assertNotEquals(null, pub.id);
        
        return pub;
    }
}