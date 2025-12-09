trigger ProvisionDocTrigger on ProvisionDocumentVersion__c (before update) {
    if ( !AppearTriggerActivationModel.isProvisionDocumentVersionTriggerActive) {
        return;
    }

    for(ProvisionDocumentVersion__c updatedVersion : trigger.new) {
        updatedVersion.AddError('Update is not allowed on Provision Documents. Please upload a new version.');
    }
}