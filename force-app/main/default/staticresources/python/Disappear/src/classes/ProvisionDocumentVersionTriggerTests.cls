@isTest
public with sharing class ProvisionDocumentVersionTriggerTests {
    @isTest
    private static void TestProvisionUpdateRejection() {
        ProvisionDocumentVersion__c newDoc = new ProvisionDocumentVersion__c();
        newDoc.ProvisionDocumentContent__c = '<p>test</p>';
        insert newDoc;
        
        ProvisionDocumentVersion__c docToUpdate = [select ProvisionDocumentContent__c from ProvisionDocumentVersion__c where id = :newDoc.Id];
        docToUpdate.ProvisionDocumentContent__c = '<p>updated</p>';
        
        try{update docToUpdate;}
        catch(DMLException ex) {
        
        }
    }
}