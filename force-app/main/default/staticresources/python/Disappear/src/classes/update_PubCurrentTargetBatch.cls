global class update_PubCurrentTargetBatch implements Database.Batchable<SObject>,Database.Stateful {
      public static set<id> idSet= getIdSetforQueryString();
    public static string SOQL = 'SELECT Name,Id,Current_Status_FormulaField__c,Current_SubmissionCycle_Id_Formula__c,isISStext__c,Current_Target__c,isPlanning__c,GPP_Type__c,RAE__c,SponsorDept_Pick__c,SponsorOrg_Pick__c,isISS__c,is_MTA__c ,MTA__c,SubGroup__r.Name,Country__c,PubStatus__r.Submission_Cycle__r.TargetLabelFormula__c,PubStatus__r.Submission_Cycle__c,PubStatus__r.IsCurrentSubmissionCycleForPub__c,PubStatus__r.Submission_Cycle__r.Meeting__r.MeetingName255__c,PubStatus__r.Submission_Cycle__r.Journal__r.JournalName255__c,PubStatus__c,Target_Type__c FROM Publication__C WHERE Id in:idSet';
    
    //public static string str = 'SELECT Current_SubmissionCycle_Id_Formula__c,Id,Current_Target__c,PubStatus__r.Submission_Cycle__r.TargetLabelFormula__c,PubStatus__r.Submission_Cycle__c,PubStatus__r.IsCurrentSubmissionCycleForPub__c,PubStatus__r.Submission_Cycle__r.Meeting__r.MeetingName255__c,PubStatus__r.Submission_Cycle__r.Journal__r.JournalName255__c,PubStatus__c,Target_Type__c FROM Publication__C where gpp_type__c != null and Target_Type__c !=NULL AND Current_Status_FormulaField__c not in ('+'\'Cancelled\''+','+'\'Published/Presented\''+')';
    private static set<id> getIdSetforQueryString() {
        set<id> pubIdSet = new set<id>();
         
        List<Publication__c> pubList = [SELECT Current_SubmissionCycle_Id_Formula__c,Id,Current_Target__c,PubStatus__r.Submission_Cycle__r.TargetLabelFormula__c,PubStatus__r.Submission_Cycle__c,PubStatus__r.IsCurrentSubmissionCycleForPub__c,PubStatus__r.Submission_Cycle__r.Meeting__r.MeetingName255__c,PubStatus__r.Submission_Cycle__r.Journal__r.JournalName255__c,PubStatus__c,Target_Type__c FROM Publication__C WHERE GPP_TYPE__c != null and Target_Type__c !=NULL AND Current_Status_FormulaField__c not in ('Cancelled','Published/Presented')];
        for(publication__c plBU: pubList){
            if(plBU.Target_Type__c == 'Meeting' || plBU.Target_Type__c == 'Journal'){
            if( plBU.Current_Target__c != plBU.PubStatus__r.Submission_Cycle__r.TargetLabelFormula__c
                                   &&
                                   plBU.PubStatus__r.Submission_Cycle__c == plBU.Current_SubmissionCycle_Id_Formula__c
                                   &&
                                   plBU.PubStatus__r.IsCurrentSubmissionCycleForPub__c == true){
                    pubIdSet.add(plBU.Id); 
                                           
                }
            }   
        
          /*  else if(plBU.Target_Type__c == 'Journal'){
                if( plBU.Current_Target__c != plBU.PubStatus__r.Submission_Cycle__r.TargetLabelFormula__c 
                                       &&
                                       plBU.PubStatus__r.Submission_Cycle__c == plBU.Current_SubmissionCycle_Id_Formula__c
                                       &&
                                       plBU.PubStatus__r.IsCurrentSubmissionCycleForPub__c == true){
                 	pubIdSet.add(plBU.Id); 
                }
            }*/
        }
        system.debug('-----'+pubIdSet.size());
        return pubIdSet;
    }
   
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.Debug('update_PubCurrentTarget :: QueryLocator ' + SOQL);
        return Database.getQueryLocator(SOQL);
    }
    
    
    global void execute(Database.BatchableContext BC, List<Publication__c> pubListBatchUpdate){
    	
        System.debug('update_PubCurrentTarget :: Execute' + pubListBatchUpdate);
        System.debug('update_PubCurrentTarget :: Execute :: pubListBatchUpdateSize' + pubListBatchUpdate.size());
        List<Database.Saveresult> sr;
        List<Publication__c> list2Update = new List<Publication__c>();
        Boolean invalidPubData = false;
        
        for(Publication__c plBU: pubListBatchUpdate){
        System.debug('$$$$PubName$$$$'+plBU.Name);
        //1st Val : Country_Required
        if((plBU.SubGroup__r.Name == 'Global Dev - Europe' || plBU.SubGroup__r.Name == 'Global Dev - Intercont'|| plBU.SubGroup__r.Name == 'Global Dev - JAPAC' || plBU.SubGroup__r.Name == 'Global Dev - US' || plBU.isPlanning__c == true) && plBU.Country__c == NULL ){
            invalidPubData = true;
            System.debug('update_PubCurrentTarget :: 1st Val : Country_Required'+plBU.Name);
        }
        /*    
        //2nd Val : GPP_Type_Required         
        if(plBU.GPP_Type__c == '' || plBU.GPP_Type__c == NULL){
            invalidPubData = true; //second Validation update as part of Appear Enhancement 2017 R1
            System.debug('update_PubCurrentTarget :: 2nd Val : GPP_Type_Required'+plBU.Name);
        }  */        
        
        //3rd val : ISS_Required
        if(plBU.isISS__c == true && plBU.isISStext__c == ''){
            invalidPubData = true;
            System.debug('update_PubCurrentTarget :: 3rd val : ISS_Required'+plBU.Name);
        }
        
        //4th val : MTA_Required
        if(plBU.is_MTA__c == true && plBU.MTA__c == ''){
            invalidPubData = true;
            System.debug('update_PubCurrentTarget :: 4th val : MTA_Required'+plBU.Name);
        }
        
        //5th Val : PST_Approval_Date :not req
        //6th Val : Rejected_publication_is_read_only : not req
        //8th Val : Restrict_Pub_Classification_Field_Update : not required
        
        //7th Val : Responsible_Amgen_Employee        //9th Val : Sponsoring_Amgen_Department_Required        //10th Val : Sponsoring_Organization_required  
        if(plBU.isPlanning__c == true && (plBU.RAE__c == NULL || plBU.SponsorDept_Pick__c == '' || plBU.SponsorOrg_Pick__c == '')){
            invalidPubData = true;
            System.debug('update_PubCurrentTarget :: 7th/8th/9th Val '+plBU.Name);
        }                
        
        if(invalidPubData == false){
        //update logic :: starts
        if(plBU.Target_Type__c == 'Meeting'){
        if( plBU.Current_Target__c != plBU.PubStatus__r.Submission_Cycle__r.TargetLabelFormula__c
                               &&
                               plBU.PubStatus__r.Submission_Cycle__c == plBU.Current_SubmissionCycle_Id_Formula__c
                               &&
                               plBU.PubStatus__r.IsCurrentSubmissionCycleForPub__c == true){
            plBU.Current_Target__c = plBU.PubStatus__r.Submission_Cycle__r.Meeting__r.MeetingName255__c; 
            list2Update.add(plBU); 
        }
        }   
    
        else if(plBU.Target_Type__c == 'Journal'){
        if( plBU.Current_Target__c != plBU.PubStatus__r.Submission_Cycle__r.TargetLabelFormula__c 
                               &&
                               plBU.PubStatus__r.Submission_Cycle__c == plBU.Current_SubmissionCycle_Id_Formula__c
                               &&
                               plBU.PubStatus__r.IsCurrentSubmissionCycleForPub__c == true){
            plBU.Current_Target__c = plBU.PubStatus__r.Submission_Cycle__r.Journal__r.JournalName255__c;
            list2Update.add(plBU);
        }
        }//update logic ends
        
        }//boolean check
        
        
        }   
       System.debug('THE PUBLIST TO UPDATE' + list2Update.size());
       
        try{
        if(!list2Update.isEmpty()){
            sr = database.update(list2Update, false);
          }
        }
        catch(Asyncexception ee){
            System.debug('AsyncException :: Debug' + ee);
            throw ee;
        }
        catch(DMLException dmlE){
            System.debug('DMLExecute :: Debug' + dmlE);
            throw dmlE;
        }
       
    }
    
    
    global void finish(Database.BatchableContext BC){
        System.debug('update_PubCurrentTarget :: Finish');
    }
}