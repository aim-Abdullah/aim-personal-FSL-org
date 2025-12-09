@IsTest
public class UnitTestDataTest {

    @IsTest
    public static void unitTest() {

        System.Debug('*** invoking UnitTestData.PublicationNew');
        Publication__c pub = UnitTestData.PublicationNew('UnitTestDataTest');
        
        System.assertNotEquals(null, pub);
        System.assertNotEquals(null, pub.id);
        System.assertEquals('UnitTestDataTest', pub.Publication_Title__c);
        
        AppearPubModel appearPub = new AppearPubModel(pub.id);
        System.assertNotEquals(null, appearPub.CurrentStatus);
        
    }
    
     @IsTest
    public static void unitTest1() {
        UnitTestData.PubTypeTestData();
    }
}