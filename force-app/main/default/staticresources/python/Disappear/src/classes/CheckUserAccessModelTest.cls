@IsTest
public class CheckUserAccessModelTest {
    
    @IsTest
    public static void UnitTest() {
        AppLogModel.setLogLevelDebug();
        
        Publication__c pub1 = UnitTestData.PublicationNew('pub1');
        System.assertNotEquals(null, pub1);
        
        //make sure we are using map cache
        boolean readAccess = CheckUserAccessModel.CheckReadAccess(pub1.id);
        System.assert(readAccess);
        boolean editAccess = CheckUserAccessModel.CheckReadAccess(pub1.id);
        System.assert(editAccess);
        
        String uLogName = 'prathyusha.lella@amgen.com',PubName = 'Pub-Id-046639';
        CheckUserAccessModel.CheckAccess(uLogName,PubName);
        
        
        
        
    }
    

}