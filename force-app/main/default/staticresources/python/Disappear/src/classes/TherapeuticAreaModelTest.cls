@IsTest
 public class TherapeuticAreaModelTest {

 @IsTest
  Public static void unitTest() {
    TherapeuticAreaModelData.createData();
    System.assertNotEquals(null, TherapeuticAreaModel.TaMap);
    System.assertEquals(null, TherapeuticAreaModel.lookUpTA('DoesNotExists'));
    
    String Str;
    Id Id1;
    list<TherapeuticArea__c > list1 = new List<TherapeuticArea__c >();
    TherapeuticArea__c ta = new TherapeuticArea__c();
    Map<id,TherapeuticArea__c> Map1 = new map<id,TherapeuticArea__c>();
    map1.put(id1,ta);
    Map<String,TherapeuticArea__c> Map2 = new map<String,TherapeuticArea__c>();
    map2.put(Str,ta);
    TherapeuticAreaModel.TaMapById = map1;
    TherapeuticAreaModel.TaMap = map2;
    TherapeuticAreaModel.TaList = list1;
    TherapeuticAreaModel.getTaMapById();
        
    System.assertNotEquals(null, TherapeuticAreaModel.lookUpTA('Bone'));
    System.assertNotEquals(null, TherapeuticAreaModel.lookUpTA('Cardiovascular'));
    System.assertNotEquals(null, TherapeuticAreaModel.lookUpTA('Inflammation'));
    System.assertNotEquals(null, TherapeuticAreaModel.lookUpTA('Nephrology/Metabolics'));
    System.assertNotEquals(null, TherapeuticAreaModelData.OncologyTA);
  }
  
}