@IsTest
public  class PubAttachmentSiebelIdWebServiceTest {

    @IsTest 
    public static void UnitTest() {
        Publication__c pub1 = UnitTestData.PublicationNew('Pub1');
        Publication__c pub2 = UnitTestData.newPublication('Pub2');
        
        pub1.SiebelRowId__c = 'SiebelRowId1';
        pub2.SiebelRowId__c = 'SiebelRowId2';
        
        update pub1;
        update pub2;
        
        List<String> pubSiebelIdList = new List<String>();
        pubSiebelIdList.add(pub1.SiebelRowId__c);
        pubSiebelIdList.add(pub2.SiebelRowId__c);
        
        Map<String, String>  resultMap = PubAttachmentSiebelIdWebService.post(pubSiebelIdList);
        System.assert(resultMap.size() == 2);
        System.assert(pub1.id == resultMap.get(pub1.SiebelRowId__c));
        System.assert(pub2.id == resultMap.get(pub2.SiebelRowId__c));
    }
}