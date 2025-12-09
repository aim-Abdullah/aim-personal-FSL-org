@IsTest
public class PubTypeModelTest {
    
    private static testMethod void unitTest() {  
        PubTypeModelData.createData();
        
        PubType__c posterPubType = PubTypeModel.LookupPubType('Poster');
        System.assertNotEquals(null, posterPubType);
        System.assertEquals('Poster', posterPubType.Name);
        
        PubType__c doesNotExistType = PubTypeModel.LookupPubType('DoNotExist');
        System.assertEquals(null, doesNotExistType);        
        
        
        System.assertNotEquals(null, PubTypeModel.PubTypeList);   
        System.assertNotEquals(null, PubTypeModel.PubTypeMap);    
        
        System.assertEquals(null, PubTypeModel.PubTypeMap.get('DoesNotExist'));
        System.assertEquals(null, PubTypeModel.LookupPubType('DoesNotExist'));
        
        System.assertNotEquals(null, PubTypeModel.LookupPubType('Manuscript'));
        System.assertNotEquals(null, PubTypeModel.LookupPubType('Abstract'));
        
        PubType__c manuscript = PubTypeModel.LookupPubType('Manuscript');
        System.assertNotEquals(null, manuscript);
        System.assertNotEquals(null, manuscript.id);
        
        PubType__c manuscript2 = PubTypeModel.PubTypeMapById.get(manuscript.id);
        System.assertNotEquals(null, manuscript2);
        System.assertNotEquals(null, manuscript2.id);
        System.assertEquals(manuscript.id, manuscript2.id); 
        
        
        System.assertEquals(1.0,  PubTypeModel.LookupPubType('Manuscript').MePoint__c);
        System.assertEquals(0.25, PubTypeModel.LookupPubType('Manuscript').ME_plus__c);
        
        System.assertEquals(0.15, PubTypeModel.LookupPubType('Abstract').MePoint__c);
        System.assertEquals(0.15, PubTypeModel.LookupPubType('Abstract').ME_plus__c);
        
        System.assertEquals(2.00, PubTypeModel.LookupPubType('Review Article').MePoint__c);
        System.assertEquals(0.25, PubTypeModel.LookupPubType('Review Article').ME_plus__c);
        
        
        Id manuscriptId = PubTypeModel.LookupPubType('Manuscript').Id;

        System.assertEquals(1, PubTypeModel.findPubTypeMe(manuscriptId));
        System.assertEquals(0.25, PubTypeModel.findPubTypeMePlus(manuscriptId));
        System.assertEquals(0.25, PubTypeModel.findPubTypeMePlus(manuscriptId));
        
        manuscriptId = null;
        System.assertEquals(0, PubTypeModel.findPubTypeMe(manuscriptId));
        System.assertEquals(0, PubTypeModel.findPubTypeMe(manuscriptId));
        System.assertEquals(0, PubTypeModel.findPubTypeMe(manuscriptId));
    }
     
}