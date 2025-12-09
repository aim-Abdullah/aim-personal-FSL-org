public without sharing class FullCalendarService {
    public FullCalendarService() {

    }
    public Id parentRecordId = '0015g000004TgQrAAK';
    public Id workTypeId = '08q5g0000008WK9AAM';
    Id dummySA_Record_noUse = '08p5g0000004XAAAA2';
    //public Id schedulingPolicyId = 'a0Y5g0000008a2nEAA';
    
    @AuraEnabled
    public static String updateDummyRecord(){

        String returnValue = '';
        String CurrentUsername = UserInfo.getUserName();
        Id CurrentUserId = UserInfo.getUserId();
        System.debug('Current User Info :: ' + CurrentUsername + ' :: ' + CurrentUserId);

        Dummy_Service_Appoitments__c dummyRecord_CS = new Dummy_Service_Appoitments__c();
        dummyRecord_CS = Dummy_Service_Appoitments__c.getValues(CurrentUsername);

        ServiceAppointment dummyRecord =  new ServiceAppointment();
        
        if(dummyRecord_CS == null){
            System.debug('No Custom Setting Record Found for Current user :: ' + CurrentUsername );
            returnValue = setUpDummyDataforUser();
            //returnValue = 'New Custom Data Required';
            
            
        }
        else{
            dummyRecord = [SELECT Id,EarliestStartTime,DueDate FROM ServiceAppointment WHERE Id =:dummyRecord_CS.Record_Id__c LIMIT 1];
            
            try{
                dummyRecord.EarliestStartTime = System.Now();
                dummyRecord.DueDate = System.NOw() + 20;
                update dummyRecord;
            }
            catch(Exception dmle){
                throw new AuraHandledException(dmle.getMessage());
            }
        
            returnValue = 'Success';
            
        
        }

        return returnValue; 
        
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<ResourceAvailabilityWrapper> getResourceAvailability(Id resourceId){

        String CurrentUsername = UserInfo.getUserName();
        Id CurrentUserId = UserInfo.getUserId();
        List<ResourceAvailabilityWrapper> rSA_WrapperListInstance = new List<ResourceAvailabilityWrapper>();
        Map<Id, String> getResourceIDVName_Map = getResourceIDVName_Map();
        Map<String, Integer> getLeadTime_Map = getLeadTime_Map(resourceId);
        

        Dummy_Service_Appoitments__c dummyRecord_CS = new Dummy_Service_Appoitments__c();
        dummyRecord_CS = Dummy_Service_Appoitments__c.getValues(CurrentUsername);

        
        if(dummyRecord_CS == null){

            System.debug('No Custom Setting Record Found for Current user :: ' + CurrentUsername );
            
        }else{
            

            Id schedulingPolicyId = 'a0Y5g0000008a2nEAA';
            // GENERATE the graded time slots for the service appointment
            FSL.GradeSlotsService mySlotService = new FSL.GradeSlotsService(schedulingPolicyId,dummyRecord_CS.Record_Id__c);
            
            // STORE the matrix of service resource id's and graded time slots
            FSL.AdvancedGapMatrix myResultMatrix = mySlotService.getGradedMatrix(true);

            Map<Id,FSL.ResourceScheduleData> mySRGradedTimeSlotMap = myResultMatrix.ResourceIDToScheduleData;
            for (Id thisresourceid : mySRGradedTimeSlotMap.keySet()){
                for (FSL.SchedulingOption thisso : mySRGradedTimeSlotMap.get(thisresourceid).SchedulingOptions ) {
                    
                    ResourceAvailabilityWrapper rSA_WrapperInstance = new ResourceAvailabilityWrapper();
                    system.debug('***** Resource Id' + thisresourceid);
                    system.debug('***** Start - ' + thisso.Interval.Start);
                    system.debug('***** Finish - ' + thisso.Interval.Finish);
                    system.debug('****** Grade - ' + thisso.Grade);
                    system.debug('****** Resource Name - ' + getResourceIDVName_Map.get(thisresourceid) );

                    rSA_WrapperInstance.resourceId = thisresourceid;
                    rSA_WrapperInstance.resourceName = getResourceIDVName_Map.get(thisresourceid);
                    //rSA_WrapperInstance.res_StartTime = thisso.Interval.Start.Date();
                    if(getLeadTime_Map.containsKey(String.valueOf(thisresourceid)+String.valueOf(resourceId)) ){
                        rSA_WrapperInstance.res_StartTime = thisso.Interval.Start.Date() + getLeadTime_Map.get(String.valueOf(thisresourceid)+String.valueOf(resourceId));
                    }
                    rSA_WrapperInstance.res_EndTime = thisso.Interval.Finish.Date();
                    rSA_WrapperInstance.res_Grades = thisso.Grade;

                    rSA_WrapperListInstance.add(rSA_WrapperInstance);

                }
            } 
        
        }//else::ends
        
                    
       system.debug('getResourceAvailability :: ' + rSA_WrapperListInstance.size());

        string returnValue = 'No Value @@@@';
        return  rSA_WrapperListInstance;


    }

    public static String setUpDummyDataforUser(){

        String returnValue = '';
        Timezone CurrentUsertz = UserInfo.getTimeZone();
        String CurrentUsername = UserInfo.getUserName();
        Id CurrentUserId = UserInfo.getUserId();

        Id insertedDummyRecord;

        ServiceAppointment dummyRecord = new ServiceAppointment();
        dummyRecord.ParentRecordId = '0015g000004TgQrAAK';
        dummyRecord.ServiceTerritoryId = '0Hh5g0000008WKxCAM';
        dummyRecord.EarliestStartTime = System.Now();
        dummyRecord.DueDate = System.NOw() + 10;
        dummyRecord.Duration = 20 ;
        dummyRecord.Subject = 'Reference Data for '+CurrentUsername+'. Please donot delete.';
        
        
        try{
            Database.SaveResult saveRes_DummyRecord = Database.insert(dummyRecord, false);
            if(saveRes_DummyRecord.isSuccess()){
                System.debug('Check Dummy Inserted Id :: ' + saveRes_DummyRecord.getId() );
                insertedDummyRecord = saveRes_DummyRecord.getId();
            }

            if(insertedDummyRecord != null){
                Dummy_Service_Appoitments__c newCSRecord = new Dummy_Service_Appoitments__c();
                newCSRecord.Name = UserInfo.getUserName();
                newCSRecord.SDL_User_Id__c = UserInfo.getUserId();
                newCSRecord.Record_Id__c = insertedDummyRecord;
                Database.SaveResult saveRes_CSRecord = Database.insert(newCSRecord , false);
                if(saveRes_CSRecord.isSuccess()){
    
                    System.debug('Check CS Inserted Id :: ' + saveRes_CSRecord.getId() );
                }
            }
            returnValue = 'User Setup Record Created';

        }
        catch(DMLException dmle){
            System.debug('createDummyServiceAppointment :: ' + dmle.getMessage() );
        }

        

        return returnValue;
    }


    public static Map<Id, String> getResourceIDVName_Map(){

        Map<Id, String> returnMap = new Map<Id, String>();
        
        Map<Id, ServiceResource> getMapValues = new Map<Id, ServiceResource>([SELECT Id,Name FROM ServiceResource WHERE Id='0Hn5g0000008Zp2CAE' LIMIT 1]);
        for(ServiceResource sr: getMapValues.values() ){
            returnMap.put(sr.Id, sr.Name);
        }
        
        return returnMap;
    }

    public static Map<String,Integer> getLeadTime_Map(Id serviceResourceId){
        Map<String, Integer> returnValue = new Map<String, Integer>();
        List<Lead_Time__c> getLeadTimes_List = new List<Lead_Time__c>();
        if(serviceResourceId <> null){
            getLeadTimes_List = [SELECT Selected_CMO__c, Selected_QTC__c, Lead_Time_Value__c 
                                FROM Lead_Time__c WHERE Selected_QTC__c =: serviceResourceId 
                                ];
        }
        if(!getLeadTimes_List.isEmpty()){
            for(Lead_Time__c lts: getLeadTimes_List){
                String keyvalue = String.valueOf(lts.Selected_CMO__c)+String.valueOf(lts.Selected_QTC__c);
                returnValue.put(keyvalue, Integer.valueOf(lts.Lead_Time_Value__c));
            }
        }

        return returnValue;
    }


    public class ResourceAvailabilityWrapper{
        @AuraEnabled
        public Id resourceId{get; set;}
        @AuraEnabled
        public String resourceName{get; set;}
        @AuraEnabled
        public Date res_StartTime{get; set;}
        @AuraEnabled
        public Date res_EndTime{get; set;}
        @AuraEnabled
        public Double res_Grades{get; set;}

        public ResourceAvailabilityWrapper(){
            
        }


    }
}