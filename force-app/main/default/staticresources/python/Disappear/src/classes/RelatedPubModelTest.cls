@isTest
public class RelatedPubModelTest {
    @isTest
    private static void TestRelatedPubModel() {
        Publication__c  newPub = UnitTestData.PublicationNew('New Pub');
        Publication__c  pubToRelate = UnitTestData.newPublication('Related Pub');
        
        system.assertNotEquals(null, newPub.id);
        
        RelatedPubModel relatedModel = new RelatedPubModel(newPub.id,'','');
        system.assertEquals(0, relatedModel.PubRelatedList.size());
        relatedModel.saveNewRelatedPub(); //validation fail
        
        relatedModel.NewRelatedPub.RelatedPub__c = pubToRelate.id;      
        relatedModel.saveNewRelatedPub();  
        
        relatedModel = new RelatedPubModel(newPub.id,'',''); //new model to re-query simulating refresh
          
        relatedModel.PubRelatedList[0].ToDelete__c = true;
        relatedModel.deleteSelected();
        
        relatedModel = new RelatedPubModel(newPub.id,'',''); //new model to re-query simulating refresh
        system.assertEquals(0, relatedModel.PubRelatedList.size());     
        
        system.assertEquals(null, RelatedPubModel.getPubRelated(null)); //fail validation
        
    
    }  
    
    @IsTest
    public static void ClonePubUnitTest() {
        Publication__c  newPub = UnitTestData.PublicationNew('Test Clond Pub');
        System.assertNotEquals(null, newPub);
        System.assertNotEquals(null, newPub.id);
        
        System.Test.startTest();
        CloneResultDTO result = RelatedPubModel.ClonePub(newPub.Id);
        System.Test.stopTest();
        
        System.assertNotEquals(null, result);
        System.assertNotEquals(null, result.sourcePubId);
        System.assertNotEquals(null, result.destPubId);
    }
   // Implemented as part of Release 1 Appear enhancement 
    @IsTest
    public static void clonepubPageReferenceTest(){
        Publication__c  newPub;
        Publication__c  pubToRelate;
        Profile profile= [select id, name from Profile where name ='APPEAR External Writer'];
        User externalWriter = new User(alias = 'external',email='externaluser@testorg.com',emailencodingkey='UTF-8',lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid =profile.Id ,timezonesidkey='America/Los_Angeles',username='externaluser@testorg.com');
        insert externalWriter;
        AppearRoleModelData.createData();
        AccountModelData.createData();  
        Contact contact = new Contact(UserId__c=externalWriter.Id,
        LastName= 'user', FirstName='test',
        AccountId=AccountModel.AccountNameMap.get('AMGEN').Id,
        Email='mike@amgen.com');
        insert contact;
        
        
        System.runAs(externalWriter){           
            newPub = UnitTestData.PublicationNew('Test Clond Pub');
            pubToRelate = UnitTestData.newPublication('Related Pub');
                       
        }
        RelatedPubModel relatedModel = new RelatedPubModel(newPub.id,'','');
        relatedModel.NewRelatedPub.RelatedPub__c = pubToRelate.id;      
        relatedModel.saveNewRelatedPub(); 
        System.Test.startTest();
         System.runAs(externalWriter){   
            
            RelatedPubModel sc = new RelatedPubModel(newPub.id,'test','teststring');
            sc.ClonePub();
            
         }  
         System.Test.stopTest();
    }
}