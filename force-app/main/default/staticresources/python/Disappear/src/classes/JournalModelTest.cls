@isTest
public class JournalModelTest {

    @IsTest
    public static void UnitTest() {
        JournalModelData.createData();
        
        System.assertNotEquals(null, JournalModel.JournalList);      
        System.assertNotEquals(null, JournalModel.JournalNameMap);      
        System.assertNotEquals(null, JournalModel.JournalMap);          
        
        Journal__c j = JournalModel.JournalNameMap.get('Blood Reviews');    
        System.assertNotEquals(null, j);
        System.assertNotEquals(null, j.id);
        System.assertNotEquals(null, JournalModel.JournalMap.get(j.id));
        
    
        //findJournalsByName
        List<Journal__c> journals = JournalModel.findJournalsByName('%The');
        System.assert(journals.size() > 0);
        
        JournalModel.resetJournalName255();
        Map<String,Journal__c> Test = JournalModel.JournalNameMap;
        
        //getAllJournalList
        List<Journal__c> journalsList = JournalModel.JournalList;
        System.assert(journalsList.size() > 0);
        
        //JournalMap
        Map<id, Journal__c> testJournalMap = JournalModel.JournalMap;
        JournalModel.JournalMap = testJournalMap ;
        //findJournalsByName
        List<Journal__c> JournalList = New List<Journal__c>();
        JournalModel.JournalList = JournalList;
        Map<String, Journal__c> JnMap = New Map<String, Journal__c>();
        JournalModel.JournalNameMap = JnMap;
        List<Journal__c> journals1 = JournalModel.findJournalsByName('%Transplantation');
        System.assert(journals1.size() > 0);
        
        JournalModelData.deleteData();
    }
    
    @IsTest
    public static void UnitTest152() {
    	JournalModelData.createData();
        
        System.assertNotEquals(null, JournalModel.JournalList);      
		System.assertEquals(3,JournalModel.findJournalsByName('Annal').size()) ;
		
		List<Journal__c> journals1 = JournalModel.findJournalsByName('Transplantation');
        System.assertEquals(2,journals1.size());

		List<Journal__c> journals2 = JournalModel.findJournalsByName('%Transplantation');
        System.assertEquals(2,journals2.size());
        
        List<Journal__c> journals3 = JournalModel.findJournalsByName('%Transplantation%');
        System.assertEquals(2,journals3.size());
        
        List<Journal__c> journals4 = JournalModel.findJournalsByName('Transplantation%');  //search Journal_Abbreviation__c
        System.assertEquals(2,journals4.size());
        
        List<Journal__c> journals5 = JournalModel.findJournalsByName('AB');  //search Journal_Abbreviation__c
        System.assertEquals(2,journals5.size());
        
        List<Journal__c> journals6 = JournalModel.findJournalsByName('A');  //search Journal_Abbreviation__c
        System.assertEquals(50,journals6.size());
    }
}