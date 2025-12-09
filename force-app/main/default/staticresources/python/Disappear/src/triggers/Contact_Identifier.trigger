trigger Contact_Identifier on Author_Identity__c (after insert,after delete,after update) {
    
     if ( !AppearTriggerActivationModel.isPublicationTriggerActive) {
        return;
      }
      
     if(trigger.isInsert && trigger.isAfter){
         ContactIdentifierTriggerLogic.contactIdentifierAfterInsertTriggerLogic(trigger.new);
     } 
     if(trigger.isDelete && trigger.isAfter ){
     
         ContactIdentifierTriggerLogic.contactIdentifierAfterDeleteTriggerLogic(trigger.old);
         System.debug('Trigger.old'+trigger.old);
     }
     if(trigger.isUpdate && trigger.isAfter){
             ContactIdentifierTriggerLogic.contactIdentifierAfterUpdateTriggerLogic(trigger.new,trigger.old);
         
     } 

}