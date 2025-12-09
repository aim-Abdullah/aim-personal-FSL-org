public without sharing class SobjectSchema_Controller {
    public SobjectSchema_Controller() {

    }

    //test some changes
    @AuraEnabled(cacheable=true)
    public static Map<String,List<String>> getAllFieldsSchema(){
        Map<String,List<String>> returnValue = new Map<String,List<String>>();
        try {

            SObjectType accountType = Schema.getGlobalDescribe().get('Shift');
            Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();

            for (String eachfield: mfields.keySet()) {

            List<String> tempList = new List<String>();
            tempList.add(String.valueOf(mfields.get(eachfield).getDescribe().getLabel()));
            tempList.add(String.valueOf(mfields.get(eachfield).getDescribe().getType()));
            returnValue.put(eachfield, tempList);

            }
            
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        System.debug('getAllFieldsSchema' + returnValue);
        return returnValue;
    }
}