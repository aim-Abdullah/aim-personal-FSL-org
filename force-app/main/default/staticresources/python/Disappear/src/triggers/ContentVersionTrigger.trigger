trigger ContentVersionTrigger on ContentVersion (after insert) {
    if(!AppearTriggerActivationModel.isContentVersionTriggerActive){
        return;
    }
    
    if(trigger.isInsert && trigger.isAfter){
        ContentVersionTriggerLogic.contentVersionAfterInsertLogic(trigger.new);
    }
}