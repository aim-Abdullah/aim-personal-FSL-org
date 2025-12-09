global class BlockResourceVisibleTime implements FSL.CustomGanttServiceResourceAction {
    
    public string returnedValues {get; set;}
    
    
    public BlockResourceVisibleTime(){
        
        returnedValues = apexpages.currentpage().getparameters().get('id');//initializing variables to parameter values from the related apex page (VF page that launched via console custom action)
        /*territoryMemberId = apexpages.currentpage().getparameters().get('stm');
        ganttStartDate = apexpages.currentpage().getparameters().get('start');
        ganttEndDate = apexpages.currentpage().getparameters().get('end');*/
    
    }
    
    global String action(Id resourceId, Id stmId, Datetime ganttStartDate, Datetime ganttEndDate, Map<String, Object> additionalParameters) {

        /*
        ResourceAbsence na = new ResourceAbsence();

        // get Resource Absence record type - NA
        RecordType recordTypeNA = [
            SELECT 
                Id, SobjectType, Name 
            FROM 
                RecordType 
            WHERE 
                DeveloperName =: 'Non_Availability' 
                AND 
                SObjectType =: ResourceAbsence.getSobjectType().getDescribe().getName() 
            ];

        na.RecordTypeId = recordTypeNA.Id;
        na.ResourceId = resourceId;
        na.FSL__Approved__c = true;
        na.Start = ganttStartDate;
        na.End = ganttEndDate;

        insert na;

        ServiceResource resource = [SELECT Name FROM ServiceResource WHERE Id =: resourceId];

        return 'Blocked availability to ' + resource.Name + ' from ' + ganttStartDate.format() + ' to ' + ganttEndDate.format();
        */
        
        String returnValue = resourceId + ' :: ' + stmId ;
        returnedValues = returnValue;
        System.debug('CustomGanttServiceResourceAction :: called');
        return returnValue;
    }

}