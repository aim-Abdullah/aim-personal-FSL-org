public with sharing class CodefromSandbox_Controller {
    public CodefromSandbox_Controller() {

    }
/*

    private static Id sCurrentUserProfileId = null;
    public static Id CurrentUserProfileId{
        get{
            if(sCurrentUserProfileId == null){
                sCurrentUserProfileId = UserInfo.getProfileId();
            }
            return sCurrentUserProfileId;
        }
    }

    private static Id sCurrentUserId = null;
    public static Id CurrentUserId{
        get{
            if(sCurrentUserId == null){
                sCurrentUserId = UserInfo.getUserId();
            }
            return sCurrentUserId;
        }
    }

    private static Boolean sIsSDLProfileUser = false;
    public static Boolean IsSDLProfileUser{
        get{
            String getProfileName = '';
            Boolean returnValue = false;
            try{
                getProfileName = [SELECT Id,Name FROM Profile WHERE Id=:UserInfo.getProfileId() LIMIT 1].Name;
            }catch(QueryException qe){
                System.debug('IsSDLProfileUser Getter :: ' + qe.getMessage() );
            }
            if(getProfileName != ''  && getProfileName == CGT_Constants.ProfileName.SDL_ProfileName){
                returnValue = true;
            }
            return returnValue;
        }    
    }
 
    public static Decimal getCurrentUserOffset(){

            DateTime now = DateTime.now();
            Decimal offset = DateTime.newInstance(now.date(), now.time()).getTime()- DateTime.newInstance(now.dateGmt(), now.timeGmt()).getTime();
            Decimal currentUserOffset_stat = offset/ (60 * 60 * 1000 * 24);
            return currentUserOffset_stat;

    }   
    
    public static Id getDefaultAccountId(){
        Id returnValue = null;
        try{
            returnValue = [SELECT Id FROM Account WHERE Name='GSK CGT Parent Account' AND RecordTypeId =:Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IndustriesBusiness').getRecordTypeId()  LIMIT 1].Id;
        }
        catch(QueryException qe){
            System.debug('CGT_BookAppointments_Controller :: getDefaultAccountId :: QueryException' + qe.getMessage() );
        }
        
        return returnValue;
    }
    
    public static CGT_Referenced_Service_Appointments__c getCustomSettingRefrencedRecord(){

        String CurrentUsername = UserInfo.getUserName();
        if(CurrentUsername.length() >= 38){
            CurrentUsername = CurrentUsername.substring(0,38);
        }
        CGT_Referenced_Service_Appointments__c return_CSRecord = new CGT_Referenced_Service_Appointments__c();
        return_CSRecord = CGT_Referenced_Service_Appointments__c.getValues(CurrentUsername);

        return return_CSRecord;
    }
        

    @AuraEnabled(cacheable=true)
    public static List<CGT_Study__c> getAssignedStudyforSDL(){
        //System.debug('getAssignedStudyforSDL :: STARTS');
        
        List<CGT_Study__c> returnValue = new List<CGT_Study__c>();
        try{

            if( IsSDLProfileUser ){
                returnValue = [SELECT Id,Name FROM CGT_Study__c WHERE Active__c = true AND Id IN (Select Study__c FROM CGT_Study_Resource__c WHERE User__c =:UserInfo.getUserId() ) ];
                
            }
            else{
                returnValue = [SELECT Id,Name FROM CGT_Study__c WHERE Active__c = true];
            }
            
        }
        catch(QueryException qe){
            System.debug('getAssignedStudyforSDL :: QueryException :: ' + qe.getMessage() );
        }
       
        //System.debug('getAssignedStudyforSDL :: ENDS');
        return returnValue;
    }


    @AuraEnabled(cacheable=true)
    public static List<Account> getSubjectsforStudy(String studyId, String subjectSearchKey){

        system.debug('getSubjectsforStudy :: STARTS :: ');

        if(String.isBlank(subjectSearchKey)){
            System.System.debug('getPatientsforStudy :: Inside balnk Text');
            return new List<Account>();
        }
        
        String key= '%' + subjectSearchKey + '%';
        List<Account> returnList = new List<Account>();
        
        try {

            returnList = [SELECT Id,Name,Study_ID__c,PersonContactId,CGT_Is_Active__c FROM Account WHERE Study_ID__c =:studyId AND RecordType.DeveloperName = 'PersonAccount' AND CGT_Is_Active__c = true AND Name LIKE: key ORDER BY CreatedDate DESC LIMIT 20 ];
            
        } catch (Exception e) {
            throw new AuraHandledException('getPatients :: Exception :: ' + e.getMessage());
        }
        system.debug('getSubjectsforStudy :: ENDS :: ');

        return returnList;
    }


    @AuraEnabled
    public static String initializeUserSetup(){

        String returnValue = '';
        CGT_Referenced_Service_Appointments__c dummyRecord_CS = new CGT_Referenced_Service_Appointments__c();
        dummyRecord_CS = getCustomSettingRefrencedRecord();
        
        if(dummyRecord_CS == null){
            System.debug('initializeUserSetup :: No Custom Setting Record Found for Current user :: ' + UserInfo.getUserName() );
            returnValue = setUpReferenceDataforUser();
            
        }
        else{

            returnValue = String.valueOf(dummyRecord_CS.CGT_Service_Appointment_Id__c);
        }

        return returnValue; 
        
    }//initializeUserSetup Method Ends


    //Method to check if the selected Study is Assigned to the Clinic :: STARTS
    public Static String isStudyAssignedtoClinic(String studyId, String serviceResourceId){
        String returnValue = '';
        Id assignedStudyToClinic_Record;
        try{
            if(studyId != null & serviceResourceId != null){
                assignedStudyToClinic_Record = [SELECT Id from CGT_Clinical_Site_Study__c WHERE Clinical_Site__c=:serviceResourceId AND  Study_ID__c=:studyId LIMIT 1].Id;
            }

        }catch(QueryException qe){
            System.debug('isStudyAssignedtoClinic :: QueryException' + qe);
        }
        if(assignedStudyToClinic_Record != null){
            returnValue = 'Success';
        }
        else{
            returnValue = 'Not Assigned';
        }
        
        return returnValue;

    }//Method to check if the selected Study is Assigned to the Clinic :: STARTS

    //Method to update the Referenced ServiceAppointment in CustomSetting with selected Study & Clinic :: STARTS
    @AuraEnabled
    public static String updateRefrencedServiceAppointment(String studyId, String serviceResourceId, Integer currentPageNumber){
        
        String returnValue = '';
        ServiceAppointment appointmentToUpdate = new ServiceAppointment();
        CGT_Referenced_Service_Appointments__c  customSettingRecord_CurrentUser = getCustomSettingRefrencedRecord();
        String checkAssignedStudyToClinic = isStudyAssignedtoClinic(studyId, serviceResourceId);

        if(checkAssignedStudyToClinic != 'Success' ){
            returnValue = 'Study Not Assigned';
            System.debug('updateRefrencedServiceAppointment :: Study Not Assigned to clinic' );

        }else{

            try{
                if(studyId != null && serviceResourceId != null){
                    appointmentToUpdate = [SELECT Id,CGT_Study_ID__c,Selected_QTC__c,EarliestStartTime,DueDate FROM ServiceAppointment WHERE Id =:customSettingRecord_CurrentUser.CGT_Service_Appointment_Id__c LIMIT 1];
        
                }
    
            }catch(QueryException qe){
                System.debug('updateRefrencedServiceAppointment :: QueryException :: ' + qe.getMessage() );
            }
            
            if(appointmentToUpdate != null){
    
                appointmentToUpdate.CGT_Study_ID__c = studyId;
                appointmentToUpdate.Selected_QTC__c = serviceResourceId;
                if(currentPageNumber == 1){
                    appointmentToUpdate.EarliestStartTime = System.Now() + 30;
                    appointmentToUpdate.DueDate = System.now() + 60;
                }
                else if(currentPageNumber == 2 ){
                    appointmentToUpdate.EarliestStartTime = System.Now() + 60;
                    appointmentToUpdate.DueDate = System.now() + 91;
                }
                else{
                    //if(appointmentToUpdate.EarliestStartTime.date() < System.today() ){
                        appointmentToUpdate.EarliestStartTime = System.Now();
                        appointmentToUpdate.DueDate = System.now() + 30;
                    //}
                }
                
                try{
                    update appointmentToUpdate;
                    returnValue = 'Success';
                }
                catch(DMLException de){
                    returnValue = 'Error';
                    System.debug('updateRefrencedServiceAppointment :: DMLException :: ' + de.getMessage() );
                    throw new AuraHandledException(de.getMessage());
                }
                
    
            }

        }

        return returnValue;
    }//Method to update the Referenced ServiceAppointment in CustomSetting with selected Study & Clinic :: ENDS


    //method to render wrapper class values in LWC component
    @AuraEnabled(cacheable=true)
    public static List<ResourceAvailabilityWrapper> getResourceAvailability(Id resourceId){

        System.debug('getResourceAvailability :: STARTS  ' );

        String CurrentUsername = UserInfo.getUserName();
        if(CurrentUsername.length() >= 38){
            CurrentUsername = CurrentUsername.substring(0,38);
        }
        
        Decimal CurrentUseroffset = getCurrentUserOffset();
        Integer arrayKey =0;
        List<ResourceAvailabilityWrapper> rSA_WrapperListInstance = new List<ResourceAvailabilityWrapper>();
        Map<Id, ServiceResource> getResourceIDVName_Map = getResourceIDVName_Map();
        Map<String, Integer> getLeadTime_Map = getLeadTime_Map(resourceId);
        

        CGT_Referenced_Service_Appointments__c dummyRecord_CS = new CGT_Referenced_Service_Appointments__c();
        dummyRecord_CS = CGT_Referenced_Service_Appointments__c.getValues(CurrentUsername);

        
        if(dummyRecord_CS == null){

            System.debug('No Custom Setting Record Found for Current user :: ' + UserInfo.getUserName() );
            
        }else{
            

            Id schedulingPolicyId = [SELECT Id,Name FROM FSL__Scheduling_Policy__c WHERE Name=:CGT_Constants.GSK_SchedulingPolicy_Name LIMIT 1].id;
            // GENERATE the graded time slots for the service appointment
            FSL.GradeSlotsService mySlotService = new FSL.GradeSlotsService(schedulingPolicyId,dummyRecord_CS.CGT_Service_Appointment_Id__c);
            
            // STORE the matrix of service resource id's and graded time slots
            FSL.AdvancedGapMatrix myResultMatrix = mySlotService.getGradedMatrix(true);

            Map<Id,FSL.ResourceScheduleData> mySRGradedTimeSlotMap = myResultMatrix.ResourceIDToScheduleData;
            System.debug('mySlotService :: ' + mySRGradedTimeSlotMap );
            System.debug('mySlotService :: ' + dummyRecord_CS.CGT_Service_Appointment_Id__c );
            
            for (Id thisresourceid : mySRGradedTimeSlotMap.keySet()){
                for (FSL.SchedulingOption thisso : mySRGradedTimeSlotMap.get(thisresourceid).SchedulingOptions ) {
                    
                    ResourceAvailabilityWrapper rSA_WrapperInstance = new ResourceAvailabilityWrapper();
                    system.debug('***** Resource Id' + thisresourceid);
                    system.debug('***** Start - ' + thisso.Interval.Start);
                    system.debug('***** Finish - ' + thisso.Interval.Finish);
                    system.debug('****** Grade - ' + thisso.Grade);
                    system.debug('****** Resource Name - ' + getResourceIDVName_Map.get(thisresourceid) );

                    if(getLeadTime_Map.containsKey(String.valueOf(thisresourceid)+String.valueOf(resourceId)) ){

                        DateTime calculatedValue;
                        calculatedValue= thisso.Interval.Start - CurrentUseroffset - getLeadTime_Map.get(String.valueOf(thisresourceid)+String.valueOf(resourceId))  ;
                        
                        if(calculatedValue.Date() >= System.today() ){

                            rSA_WrapperInstance.qtc_StartTime = calculatedValue.Date();//qtcStarts
                            DateTime qtc_StartTime_Conv = calculatedValue.Date() + 1;
                            rSA_WrapperInstance.qtc_DueDate = qtc_StartTime_Conv - 0.02;//qtcDueDate
                            rSA_WrapperInstance.qtc_resourceId = resourceId;//qtcId
                            rSA_WrapperInstance.cmo_resourceId = thisresourceid;//cmoID
                            rSA_WrapperInstance.cmo_resourceName = getResourceIDVName_Map.get(thisresourceid).Name;//cmoName
                            rSA_WrapperInstance.qtc_resourceName = getResourceIDVName_Map.get(resourceId).Name;//qtcName
                            rSA_WrapperInstance.cmo_StartTime = thisso.Interval.Start;//cmoStarts
                            rSA_WrapperInstance.cmo_DueDate = thisso.Interval.Finish;//cmoDueDate
                            rSA_WrapperInstance.wrapperKey = arrayKey;//wrapperKey
                            if(getResourceIDVName_Map.get(thisresourceid).CGT_No_Work_Period__c != null){
                                rSA_WrapperInstance.noWorkPeriod = System.Today() + Integer.valueOf(getResourceIDVName_Map.get(thisresourceid).CGT_No_Work_Period__c) ;//CMONoWorkPeriod
                            }
                            arrayKey++;
                            
                            rSA_WrapperListInstance.add(rSA_WrapperInstance);


                        }//if QTC starts less than today ::ends
                        
                    }//if LeadTimeExists for QTC
                    

                }
            } 
        
        }//else::ends
        
        system.debug('getResourceAvailability :: ' + rSA_WrapperListInstance.size());
        return  rSA_WrapperListInstance;

    }//getResourceAvailability Method Ends

    //Method to verify if the slected slot is booked or not
    public static Boolean isSelecetdSlotAvailable(ResourceAvailabilityWrapper selectedAppointment){

        AssignedResource check_AR ;
        System.debug('isSelecetdSlotAvailable :: check value' + selectedAppointment.cmo_StartTime );

        try{
           // check_AR = [SELECT Id FROM AssignedResource WHERE ServiceAppointment.Selected_CMO__c=:selectedAppointment.cmo_resourceId AND ServiceAppointment.Selected_QTC__c=:selectedAppointment.qtc_resourceId AND ServiceAppointment.RecordTypeId=:Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByDeveloperName().get('CGT_Manufacturing_Appointment').getRecordTypeId() AND ServiceAppointment.SchedStartTime =:selectedAppointment.cmo_StartTime LIMIT 1];

        }catch(QueryException qE){
            System.debug('isSelecetdSlotAvailable :: QueryException' + qE.getMessage());
        }

        if(check_AR != null){
            return false;
        }else{
            return true;
        }


    }

    //Method to create appointments for QTC & CMO locations :: STARTS
    @AuraEnabled
    public static String createAppointments(ResourceAvailabilityWrapper selectedAppointment,String selectedPatientValue, String selectedValue ){

        Boolean returnBoolean = false;
        String returnValue = '';

        if(!isSelecetdSlotAvailable(selectedAppointment) ){
            returnValue = 'Already Booked';
            return returnValue;
        }
        else{

        //Start Booking Logic    
        
        Map<String, Id> all_ServiceApp_RecorTypes = get_ServiceAppointmentRecordTypes();
        String psc_QueueEmail = getPSCQueueEmail();
        //String refernce_defaultAccountforSA = System.Label.Default_Account_for_Service_Appointment;
        Id refernce_defaultAccountforSA = getDefaultAccountId();
        Id serviceTerritoryId_value = getServiceTerritoryIdforCMOorQTC(null);
        Decimal cmo_TimeZoneOffsetValue = getCMOTimeZoneOffsetValue(serviceTerritoryId_value) / 24;
        Id serviceTerritoryId_QTCvalue = getServiceTerritoryIdforCMOorQTC(selectedAppointment.qtc_resourceId);
        DateTime qtc_StartTime_conv = selectedAppointment.qtc_StartTime;
        Decimal CurrentUseroffset = getCurrentUserOffset().abs();

        List<ServiceAppointment> sa_InsertList = new List<ServiceAppointment>();
        List<AssignedResource> ar_InsertList = new List<AssignedResource>();
        //List<Database.SaveResult> sr_List = new List<Database.SaveResult>();
        Map<Id, ServiceAppointment> insertedAppointments_Map = new Map<Id, ServiceAppointment>();
        

            for(Integer i=0; i<2; i++){

                ServiceAppointment records_Appointment = new ServiceAppointment();
                records_Appointment.CGT_GSK_Support_Mailbox_Id__c = psc_QueueEmail;
                records_Appointment.CGT_Study_ID__c = selectedValue;
                records_Appointment.ContactId = selectedPatientValue; 
                records_Appointment.ParentRecordId = refernce_defaultAccountforSA;
                records_Appointment.Selected_CMO__c = selectedAppointment.cmo_resourceId;
                records_Appointment.Selected_QTC__c = selectedAppointment.qtc_resourceId;
                records_Appointment.Status = 'Pending PSC Approval';

                if(i==0){
                    //CMO Appointment Details
                    records_Appointment.RecordTypeId = all_ServiceApp_RecorTypes.get('CGT_Manufacturing_Appointment');
                    records_Appointment.DueDate = selectedAppointment.cmo_DueDate - cmo_TimeZoneOffsetValue ;
                    records_Appointment.Duration = 0.99;
                    records_Appointment.EarliestStartTime = selectedAppointment.cmo_StartTime - cmo_TimeZoneOffsetValue ;
                    records_Appointment.CGT_Intial_Appointment_Date_Time__c = selectedAppointment.cmo_StartTime - cmo_TimeZoneOffsetValue ;
                    records_Appointment.SchedStartTime = selectedAppointment.cmo_StartTime - cmo_TimeZoneOffsetValue ;
                    records_Appointment.SchedEndTime = selectedAppointment.cmo_DueDate - cmo_TimeZoneOffsetValue ;
                    records_Appointment.FSL__GanttColor__c = '#f26118';
                    records_Appointment.ServiceTerritoryId = serviceTerritoryId_value;
                    //records_Appointment.FSL__Related_Service__c = ;
                }

                if(i==1){
                    //QTC Appointment Details
                    records_Appointment.RecordTypeId = all_ServiceApp_RecorTypes.get('CGT_Collection_Appointment');
                    records_Appointment.DueDate = selectedAppointment.qtc_DueDate + CurrentUseroffset;
                    records_Appointment.Duration = 23.8;
                    records_Appointment.EarliestStartTime = qtc_StartTime_conv + CurrentUseroffset;
                    records_Appointment.CGT_Intial_Appointment_Date_Time__c = qtc_StartTime_conv + CurrentUseroffset;
                    records_Appointment.SchedStartTime = qtc_StartTime_conv + CurrentUseroffset;
                    records_Appointment.SchedEndTime = selectedAppointment.qtc_DueDate + CurrentUseroffset;
                    records_Appointment.FSL__GanttColor__c = '#f79c0d';
                    records_Appointment.ServiceTerritoryId = serviceTerritoryId_QTCvalue;
                    //records_Appointment.FSL__Related_Service__c = ;

                }
                sa_InsertList.add(records_Appointment);

            }//for loop Ends :

        try{ 

            /*
            System.debug('Total Number of SOQL Queries allowed in this Apex code context: ' +  Limits.getLimitQueries());
            System.debug('Total Number of records that can be queried  in this Apex code context: ' +  Limits.getLimitDmlRows());
            System.debug('Total Number of DML statements allowed in this Apex code context: ' +  Limits.getLimitDmlStatements() );
            System.debug('Total Number of CPU usage time (in ms) allowed in this Apex code context: ' +  Limits.getLimitCpuTime());
            System.debug('1. Number of Queries used in this Apex code so far: ' + Limits.getQueries());
            System.debug('2. Number of rows queried in this Apex code so far: ' + Limits.getDmlRows());
            System.debug('3. Number of DML statements used so far: ' +  Limits.getDmlStatements());   
            System.debug('4. Amount of CPU time (in ms) used so far: ' + Limits.getCpuTime());

            System.debug('Compare DML Limit Values :: Current Value :: ' + sa_InsertList.size() + Limits.getDMLRows() );
            System.debug('Compare DML Limit Values :: Allowed Value :: ' + Limits.getLimitDMLRows() );

            System.debug('createAppointments :: sa_InsertList ::' + sa_InsertList );

            List<Database.SaveResult> sr_List = Database.insert(sa_InsertList, false);

            System.debug('createAppointments :: Debug Complete list :: ' + sr_List);

            if(sr_List.size() == sa_InsertList.size()){
                for(Integer i=0; i<sr_List.size(); i++){
                    if(sr_List.get(i).isSuccess() ){
                        System.debug('createAppointments :: Success ' + sr_List.get(i).getId() );
                        insertedAppointments_Map.put(sr_List.get(i).getId(), sa_InsertList.get(i));
                        
                    }
                    else{
                        returnValue = 'DML Issue';
                        
                    }
                }
            }

            //create AssignedResource values for scheduling :: Starts
            if(insertedAppointments_Map.size() == 2){
                for(Id saId: insertedAppointments_Map.keyset() ){

                    AssignedResource assignedRes_Rec = new AssignedResource();
                    assignedRes_Rec.ServiceAppointmentId = saId ;
                        

                    if( insertedAppointments_Map.get(saId).Duration == 0.99 ){
                        //CMO Assigned Resource
                        assignedRes_Rec.FSL__calculated_duration__c = insertedAppointments_Map.get(saId).Duration;
                        assignedRes_Rec.ServiceResourceId = insertedAppointments_Map.get(saId).Selected_CMO__c;
                    }
                    else{
                        //QTC Assigned Resource
                        assignedRes_Rec.FSL__calculated_duration__c = insertedAppointments_Map.get(saId).Duration;
                        assignedRes_Rec.ServiceResourceId = insertedAppointments_Map.get(saId).Selected_QTC__c;
                    }
                    ar_InsertList.add(assignedRes_Rec);
                    
                }
            }

            List<Database.SaveResult> sr_List_AssignedRes = Database.insert(ar_InsertList, false);
            update_RelatedAppointmentsInfo(insertedAppointments_Map.keyset());
            returnValue = 'Return Check';
            
            //create AssignedResource values for scheduling :: Ends
            
        }catch(DMLException de){
            returnValue = 'DML Issue';
            
            System.debug('createAppointments :: DMLException' + de.getMessage() );
        }
        catch(Exception ex){
            returnValue = 'DML Issue';
            
            System.debug('createAppointments :: DMLException' + ex.getMessage() );
        }

        }    

        return  String.valueOf(returnValue) ;

    }//Method to create appointments for QTC & CMO locations :: ENDS


    //Future Method to update the FSL__Related_Service__c for the Appointments :: STARTS 
    @future
    public static void update_RelatedAppointmentsInfo(Set<Id> appointmentIds_Set){
        
        List<ServiceAppointment> update_List = new List<ServiceAppointment>();
        List<Id> set2List = new List<Id>(); set2List.addAll(appointmentIds_Set);
        
        if(!set2List.isEmpty() ){

            for(Integer i=0; i<set2List.size(); i++){

                ServiceAppointment sa_Record = new ServiceAppointment();
                if(i==0){
                    sa_Record.id = set2List.get(0);
                    sa_Record.FSL__Related_Service__c = set2List.get(1);
                }
                if(i==1){
                    sa_Record.id = set2List.get(1);
                    sa_Record.FSL__Related_Service__c = set2List.get(0);
                }
                
                update_List.add(sa_Record);
            } 

        }

        //System.debug('update_RelatedAppointmentsInfo' + update_List);
        try{

            //System.debug('3. Number of DML statements used so far: ' +  Limits.getDmlStatements());
            //System.debug('Total Number of DML statements allowed in this Apex code context: ' +  Limits.getLimitDmlStatements() );
            List<Database.SaveResult> sr_SAUpdates = Database.update(update_List, false);

        }catch(DMLException de){
            System.debug('update_RelatedAppointmentsInfo :: Exception' + de.getMessage() );
        }

    }//Future Method to update the FSL__Related_Service__c for the Appointments :: ENDS 

    



    //Method to get ServiceAppointment Record Types :: STARTS
    public static Map<String, Id> get_ServiceAppointmentRecordTypes(){

        Map<String, Id> return_Map = new Map<String, Id>();
        List<RecordType> all_SARecordTypes = new List<RecordType>();

        try{
            all_SARecordTypes = [SELECT DeveloperName,Id FROM RecordType WHERE SobjectType = 'ServiceAppointment' AND IsActive = TRUE];
        }catch(QueryException qe){
            System.debug( 'get_ServiceAppointmentRecordTypes :: Exception'+  qe.getMessage() );

        }
        
        if(!all_SARecordTypes.isEmpty()){
            for(RecordType rt: all_SARecordTypes){
                return_Map.put(String.valueOf(rt.DeveloperName), rt.Id);
            }

        }

        return return_Map;
    }//Method to get ServiceAppointment Record Types :: END

    //Method to get PSC Queue Email :: STARTS
    public static String getPSCQueueEmail(){
        String returnValue = '';
        String psc_Queue  = '';
        try{
            psc_Queue = [SELECT Id,Email FROM Group WHERE Type = 'Queue' AND DeveloperName =:CGT_Constants.GSK_PSCQueue_DevName LIMIT 1 ].Email;

        }catch(QueryException qe){
            System.debug( 'getPSCQueueEmail :: Exception'+  qe.getMessage() );
        }
        if(psc_Queue <> null || psc_Queue <> ''){
            returnValue = psc_Queue;
        }
        
        return returnValue;
    }//Method to get PSC Queue Email :: END



    //Method to get ServiceTerritory Id for CMO or QTC :: STARTS
    public static Id getServiceTerritoryIdforCMOorQTC(Id resourceId){
        Id returnValue = null;
        try{
            if(resourceId != null ){
                returnValue = [SELECT ServiceTerritoryId FROM ServiceTerritoryMember WHERE ServiceResourceId =: resourceId AND TerritoryType = 'P' LIMIT 1].ServiceTerritoryId ; 
            }else{
                returnValue = [SELECT id FROM ServiceTerritory WHERE RecordType.DeveloperName =: CGT_Constants.ServiceTerritory.RecordType_DevName_CMO ORDER BY CreatedDate ASC LIMIT 1].id ;
            }
        }catch(QueryException qe){
            System.debug('getServiceTerritoryIdforCMOorQTC :: Exception :: ' + qe.getMessage() );
        }
        
        return returnValue;
    }//getServiceTerritoryIdforCMOorQTC Method ends :: ENDS

    //Method to return CMO Offset value :: STARTS
    public static Decimal getCMOTimeZoneOffsetValue(Id serviceTerritoryId){

        Decimal returnValue;
        try{
            if(serviceTerritoryId <> null){
                returnValue = [SELECT OperatingHours.TimeZone_Offset_Value__c FROM ServiceTerritory WHERE Id=:serviceTerritoryId LIMIT 1].OperatingHours.TimeZone_Offset_Value__c;
            }

        }catch(QueryException qe){
            System.debug('getCMOTimeZoneOffsetValue :: ' + qe.getMessage() );
        }
        
        return returnValue;

    }//Method to return CMO Offset value :: ENDS

    //Method to create Reference Record in Custom Setting for the logged in User 
    public static String setUpReferenceDataforUser(){

        //String refernce_defaultAccountforSA = System.Label.Default_Account_for_Service_Appointment;
        Id refernce_defaultAccountforSA = getDefaultAccountId();
        System.debug('setUpReferenceDataforUser :: refernce_defaultAccountforSA ' + refernce_defaultAccountforSA );
        Id serviceTerritoryId_value = getServiceTerritoryIdforCMOorQTC(null);
        String returnValue = '';
        Timezone CurrentUsertz = UserInfo.getTimeZone();
        String CurrentUsername = UserInfo.getUserName();
        if(CurrentUsername.length() >= 38){
            CurrentUsername = CurrentUsername.substring(0,38);
        }
        
        Id insertedDummyRecord;

        ServiceAppointment dummyRecord = new ServiceAppointment();
        dummyRecord.ParentRecordId = refernce_defaultAccountforSA;
        dummyRecord.ServiceTerritoryId = serviceTerritoryId_value;
        dummyRecord.EarliestStartTime = System.Now();
        dummyRecord.DueDate = System.Now() + 20;
        dummyRecord.Duration = 0.99 ;
        dummyRecord.Subject = 'Reference Data for '+CurrentUsername+'. Please donot delete.';
        
        
        
        try{
            Database.SaveResult saveRes_DummyRecord = Database.insert(dummyRecord, false);
            if(saveRes_DummyRecord.isSuccess()){
                System.debug('setUpReferenceDataforUser :: saveRes_DummyRecord :: ' + saveRes_DummyRecord.getId() );
                insertedDummyRecord = saveRes_DummyRecord.getId();
            }

            if(insertedDummyRecord != null){
                CGT_Referenced_Service_Appointments__c newCSRecord = new CGT_Referenced_Service_Appointments__c();
                newCSRecord.Name = CurrentUsername;
                newCSRecord.CGT_User_Id__c = UserInfo.getUserId();
                newCSRecord.CGT_Service_Appointment_Id__c = insertedDummyRecord;
                Database.SaveResult saveRes_CSRecord = Database.insert(newCSRecord , false);
                if(saveRes_CSRecord.isSuccess()){
    
                    System.debug('setUpReferenceDataforUser :: saveRes_CSRecord :: ' + saveRes_CSRecord.getId() );
                }
            }
            returnValue = 'User Setup Record Created';

        }
        catch(DMLException dmle){
            System.debug('setUpReferenceDataforUser :: ' + dmle.getMessage() );
        }
        
        return returnValue;
    }

    
    //Map to return all the CMO Id vs Name 
    public static Map<Id, ServiceResource> getResourceIDVName_Map(){

        Map<Id, String> returnMap = new Map<Id, String>();
        Map<Id, ServiceResource> getMapValues = new Map<Id, ServiceResource>();
        
        try{
             getMapValues = new Map<Id, ServiceResource>([SELECT Id,Name,CGT_No_Work_Period__c FROM ServiceResource WHERE isActive = true LIMIT 5000]);
        }
        catch(QueryException qe){
            System.debug('getResourceIDVName_Map :: ' + qe.getMessage());
        }
       
        return getMapValues; 
        
    }//getResourceIDVName_Map


    //Method to return Map of QTC+CMO VS LeadTime :: STARTS
    public static Map<String,Integer> getLeadTime_Map(Id serviceResourceId){
        Map<String, Integer> returnValue = new Map<String, Integer>();
        List<CGT_Lead_Time__c> getLeadTimes_List = new List<CGT_Lead_Time__c>();
        if(serviceResourceId <> null){
            getLeadTimes_List = [SELECT Selected_Clinical_Site__c, Selected_CMO__c, Lead_Time__c FROM CGT_Lead_Time__c WHERE Selected_Clinical_Site__c =: serviceResourceId ];
        }
        if(!getLeadTimes_List.isEmpty()){
            for(CGT_Lead_Time__c lts: getLeadTimes_List){
                String keyvalue = String.valueOf(lts.Selected_CMO__c)+String.valueOf(lts.Selected_Clinical_Site__c);
                returnValue.put(keyvalue, Integer.valueOf(lts.Lead_Time__c));
            }
        }

        return returnValue;
    }//Method to return Map of QTC+CMO VS LeadTime :: ENDS


    
    //Wrapper Class to Display Available Slots for QTC/Clinics in LWC Component : CGT_DisplayAppointment :: STARTS
    public class ResourceAvailabilityWrapper{
        @AuraEnabled
        public Id cmo_resourceId{get; set;}
        @AuraEnabled
        public String cmo_resourceName{get; set;}
        @AuraEnabled
        public DateTime cmo_StartTime{get; set;}
        @AuraEnabled
        public DateTime cmo_DueDate{get; set;}
        @AuraEnabled
        public Id qtc_resourceId{get; set;}
        @AuraEnabled
        public String qtc_resourceName{get; set;}
        @AuraEnabled
        public Date qtc_StartTime{get; set;}
        @AuraEnabled
        public DateTime qtc_DueDate{get; set;}
        @AuraEnabled
        public Date noWorkPeriod{get; set;}
        @AuraEnabled
        public Integer wrapperKey{get; set;}
        
        public ResourceAvailabilityWrapper(){
            
        }

    }//Wrapper Class to Display Available Slots for QTC/Clinics in LWC Component : CGT_DisplayAppointment :: ENDS

    */

}