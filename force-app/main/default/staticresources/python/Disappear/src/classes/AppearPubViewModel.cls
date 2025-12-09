global without sharing class AppearPubViewModel {
    // Appear Enhancement R1:2017 :: starts 
    public Boolean gotoFPROnly{get;set;}
    public id ansRecId{get; set;}
    public static String ansFieldName {get; set;}
    public static Id questionId{get; set;}
    public String parentQuestion{get;set;}//Custom setting donot have lookup
    public String answerValue {get; set;}
    public boolean disableRad {get; set;}
    
    //variable relative to FPR Only Pubs
    public static String isSPFull{get; set;}
    public static String isISS{get; set;}
    public static String courtesyReview{get; set;}
    public static String isMTA{get; set;}
    public static String sopException{get; set;}
    public static String noProdPolicy{get; set;}
    
    public AppearPubViewModel(){
         this.gotoFPROnly = false;
         QuestionContent = getQuestionContent(null,null);
    }
    
   //List to map picklistvalues with answerField string 
   private transient Map<String,Schema.SObjectField> pfield_map = null; 
   public Map<String,Schema.SObjectField> field_map{ 
        get{
            if(pfield_map == null){
            sObjectType sobject_type = FPR_Only_Answers__c.getSObjectType();
            DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
            pfield_map = sobject_describe.fields.getMap();
               
        }
            return pfield_map;
      }
    }
    
    
    public String QuestionContent{get; set;}
    public String getQuestionContent(String parentResponse , String parentQuestionName){
        String retqContent = '';
        boolean noRecordfound = false;
        Map<String,FPR_Only_Questions__c> getAMapRecords = FPR_Only_Questions__c.getall();
        
        if(!getAMapRecords.isEmpty()){
        for(FPR_Only_Questions__c qL: getAMapRecords.values()){
            
            if(qL.Is_inActive__c == false){//new inActive check Appear Enhancement 2017 backlog R4
                if(qL.Parent_Question_Response__c == parentResponse && qL.Parent_Question__c == parentQuestionName ){
                    ansFieldName = qL.Answer_Field_Name__c;
                    parentQuestion = qL.Name;
                    if(qL.Question_Content_2__c <> null){
                        retqContent = qL.Question_Content__c + qL.Question_Content_2__c;
                    }
                    else{
                        retqContent = qL.Question_Content__c;  
                    }
                }
            }//new inActive check Appear Enhancement 2017 backlog R4
          }
        }
        
        if(ansFieldName <> null || ansFieldName <> ''){
        ReqOptions = getReqOptions(ansFieldName);
        //helpText
        HelpText = getHelpText(ansFieldName);   
        }
        
        
        return retqContent;
    }
    
     public String getErrorContent(String parentResponse, String parentQuestionName){
        String errContent = '';
        Map<String,FPR_Only_Questions__c> getFPRQuesRecords = FPR_Only_Questions__c.getall();
        if(!getFPRQuesRecords.isEmpty()){
            for(FPR_Only_Questions__c qL: getFPRQuesRecords.values()){
                if(qL.Is_inActive__c == false){//new inActive check Appear Enhancement 2017 backlog R4
                    if(qL.Parent_Question_Response__c == parentResponse && qL.Parent_Question__c == parentQuestionName ){
                        if(qL.Error_Message_2__c <> null){
                            errContent = qL.Error_Message__c + qL.Error_Message_2__c;
                        }
                        else{
                            errContent = qL.Error_Message__c;
                        }
                    }
                }//new inActive check Appear Enhancement 2017 backlog R4
            }
        }
        
        return errContent;
    }
    
    public List<SelectOption> ReqOptions{get; set;}
        public List<SelectOption> getReqOptions(String fieldname){
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldname).getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
                  options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    /*check HelpTxt : starts*/
    public String HelpText{get; set;}
    public String getHelpText(String fieldname){
        //Schema.DescribeFieldResult field_describe = field_map.get(fieldname).getDescribe();
        String help_text_values = field_map.get(fieldname).getDescribe().getInlineHelpText();
        return help_text_values;
    }
    /*check HelpTxt : ends*/
    public PageReference FPRQuestionresponse(){
        string errorMsg = '';
        //AppearPubModel apPubMod = new AppearPubModel();
        FPR_Only_Answers__c ansObjRec = new FPR_Only_Answers__c();
        
        
        //First Stop/Check : Amgen Authors
        if(parentQuestion == 'Have Amgen Author') {
            if(answerValue == 'Yes'){
                //System.debug('Response Method 2' + FPR_Only_Questions__c.getvalues('Error Message Amgen Author').Error_Message__c);
                errorMsg = getErrorContent(answerValue,parentQuestion);//getError
                ansObjRec.Is_ISS_Pub__c = 'Yes';
                ansObjRec.Have_Amgen_Author__c = 'Yes';
                ansObjRec.Answer_Error_Message__c = errorMsg;
                disableRad = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMsg));
            }
                if(answerValue == 'No'){
                System.debug('Is ISS is true enable 2nd form');
                ansObjRec.Is_ISS_Pub__c = 'Yes';
                ansObjRec.Have_Amgen_Author__c = 'No';
                
                //AppearPubModel aPVM = new AppearPubModel('No','Yes','Yes','','','');
                isSPFull = 'No';//change
                isISS = 'Yes';//change
                courtesyReview = 'Yes';//change
                gotoFPROnly = true;
             }
        }
        
        //Second Stop/Check : Have Amgen Author & DSR
        if(parentQuestion == 'Have Amgen Author DSR'){
            if(answerValue == 'No'){
                ansObjRec.Is_ISS_Pub__c = 'No';
                ansObjRec.Is_Data_Sharing_Request__c = 'Yes';//changed for backlogR4
                ansObjRec.Have_Amgen_Author_DSR__c = 'No';//changed for backlogR4
                isSPFull = 'No';
                isMTA = 'Optional';//changed for backlogR4
                courtesyReview = 'Yes';//change
                gotoFPROnly = true;
            }
            if(answerValue == 'Yes'){
                errorMsg = getErrorContent(answerValue,parentQuestion);//getError
                ansObjRec.Is_ISS_Pub__c = 'No';
                ansObjRec.Is_Data_Sharing_Request__c = 'Yes';//changed for backlogR4
                ansObjRec.Have_Amgen_Author_DSR__c = 'Yes';//changed for backlogR4
                ansObjRec.Answer_Error_Message__c = errorMsg;
                disableRad = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMsg ));
            }
        }
        
        //Third stop/check :partner-led & SOP Exception
        if(parentQuestion == 'Is Partner led SOP' && answerValue == 'Yes'){
            ansObjRec.Is_ISS_Pub__c = 'No';
            ansObjRec.Is_Data_Sharing_Request__c = 'No';//changed for backlogR4
            ansObjRec.Is_partner_led_SOP_exception__c = 'Yes';
            isSPFull = 'No';
            courtesyReview = 'No';
            sopException = 'Yes';
            gotoFPROnly = true;
            
        }
        
        //Fourth stop/check :Is this CSP
        if(parentQuestion == 'Is this a CSP'){
            if(answerValue == 'Yes'){
                errorMsg = getErrorContent(answerValue,parentQuestion);
                ansObjRec.Is_ISS_Pub__c = 'No';
                ansObjRec.Is_Data_Sharing_Request__c = 'No';//changed for backlogR4
                ansObjRec.Is_partner_led_SOP_exception__c = 'No';
                ansObjRec.is_CSP__c = 'Yes';
                ansObjRec.Answer_Error_Message__c = errorMsg;
                disableRad = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMsg ));
            }
            if(answerValue == 'No'){
                ansObjRec.Is_ISS_Pub__c = 'No';
                ansObjRec.Is_Data_Sharing_Request__c = 'No';
                ansObjRec.Is_partner_led_SOP_exception__c = 'No';
                ansObjRec.is_CSP__c = 'No';
                
                isSPFull = 'Yes';
                gotoFPROnly = true;
            }
            
         }
        
        if(gotoFPROnly <> true){
        
        QuestionContent = getQuestionContent(answerValue,parentQuestion);
                answerValue = null;
        }
        
        if(disableRad == true || gotoFPROnly == true){
           
            try{
                insert ansObjRec;
                
            }
            catch(Exception e){
                ApexPages.addMessages(e);
                return null;
            }
            
        }
        ansRecId =  ansObjRec.Id;
        return null;
    }
    
    /* // Appear Enhancement 2017: Backlog R4 - Below method commented.
    public PageReference FPRQuestionresponse(){
        string errorMsg = '';
        //AppearPubModel apPubMod = new AppearPubModel();
        FPR_Only_Answers__c ansObjRec = new FPR_Only_Answers__c();
            System.debug('Response Method ::::' + ansFieldName + answerValue + parentQuestion + questionId  );
        
        //First Stop/Check : Amgen Authors
        if(parentQuestion == 'Have Amgen Author') {
            if(answerValue == 'Yes'){
                //System.debug('Response Method 2' + FPR_Only_Questions__c.getvalues('Error Message Amgen Author').Error_Message__c);
                errorMsg = getErrorContent(answerValue,parentQuestion);//getError
                ansObjRec.Is_ISS_Pub__c = 'Yes';
                ansObjRec.Have_Amgen_Author__c = 'Yes';
                ansObjRec.Answer_Error_Message__c = errorMsg;
                disableRad = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMsg));
            }
                if(answerValue == 'No'){
                System.debug('Is ISS is true enable 2nd form');
                ansObjRec.Is_ISS_Pub__c = 'Yes';
                ansObjRec.Have_Amgen_Author__c = 'No';
                
                //AppearPubModel aPVM = new AppearPubModel('No','Yes','Yes','','','');
                isSPFull = 'No';//change
                isISS = 'Yes';//change
                courtesyReview = 'Yes';//change
                gotoFPROnly = true;
             }
        }
        
        //Second Stop/Check : Interventional study 
        if(parentQuestion == 'Does include human study or reasearch'){
            if(answerValue == 'No'){
                ansObjRec.Is_ISS_Pub__c = 'No';
                ansObjRec.Is_MTA_Pub__c = 'Yes';
                ansObjRec.Have_human_study_or_TA_research_MTA__c = 'No';
                isSPFull = 'No';//change
                isMTA = 'Yes';//change
                courtesyReview = 'Yes';//change
                gotoFPROnly = true;
            }
            if(answerValue == 'Yes'){
                //errorMsg = FPR_Only_Questions__c.getvalues('Error Message human study or reasearch').Error_Message__c + FPR_Only_Questions__c.getvalues('Error Message human study or reasearch').Error_Message_2__c;
                errorMsg = getErrorContent(answerValue,parentQuestion);//getError
                ansObjRec.Is_ISS_Pub__c = 'No';
                ansObjRec.Is_MTA_Pub__c = 'Yes';
                ansObjRec.Have_human_study_or_TA_research_MTA__c = 'Yes';
                ansObjRec.Answer_Error_Message__c = errorMsg;
                disableRad = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMsg ));
            }
        }
        
        //Third stop/check :partner-led & SOP Exception
        if(parentQuestion == 'Is Partner led SOP' && answerValue == 'Yes'){
            ansObjRec.Is_ISS_Pub__c = 'No';
            ansObjRec.Is_MTA_Pub__c = 'No';
            ansObjRec.Is_partner_led_SOP_exception__c = 'Yes';
            isSPFull = 'No';//change
            courtesyReview = 'No';//change
            sopException = 'Yes';//change
            gotoFPROnly = true;
            
            //disableRad = true;
           //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FPR Questionnaire Build in Progress' ));
        }
        
        //Fourth stop/check :Have human study or research No SOP
        if(parentQuestion == 'Have human study or research No SOP' && answerValue == 'Yes'){
            errorMsg = getErrorContent(answerValue,parentQuestion);//getError
            ansObjRec.Is_ISS_Pub__c = 'No';
            ansObjRec.Is_MTA_Pub__c = 'No';
            ansObjRec.Is_partner_led_SOP_exception__c = 'No';
            ansObjRec.Have_human_study_or_TA_research_No_SOP__c = 'Yes';
            ansObjRec.Answer_Error_Message__c = errorMsg;
            disableRad = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMsg ));
         }
        
        //Fifth stop/check :Sponsored data or product materials
        if(parentQuestion == 'Have data or product materials' && answerValue == 'Yes'){
            ansObjRec.Is_ISS_Pub__c = 'No';
            ansObjRec.Is_MTA_Pub__c = 'No';
            ansObjRec.Is_partner_led_SOP_exception__c = 'No';
            ansObjRec.Have_human_study_or_TA_research_No_SOP__c = 'No';
            ansObjREc.Have_data_or_product_materials__c = 'Yes';
            isSPFull = 'Yes';//change
            gotoFPROnly = true;
         }
        
        //Sixth stop/check :Catch All ;Is self written and no discussion 
        if(parentQuestion == 'Is self written and no discussion' ){
            if(answerValue == 'Yes'){
            ansObjRec.Is_ISS_Pub__c = 'No';
            ansObjRec.Is_MTA_Pub__c = 'No';
            ansObjRec.Is_partner_led_SOP_exception__c = 'No';
            ansObjRec.Have_human_study_or_TA_research_No_SOP__c = 'No';
            ansObjREc.Have_data_or_product_materials__c = 'No';
            ansObjRec.Is_self_written_and_no_discussion__c = 'Yes';
            isSPFull = 'No';
            noProdPolicy ='Yes';
            gotoFPROnly = true;
            } 
            if(answerValue == 'No'){
            errorMsg = getErrorContent(answerValue,parentQuestion);//getError
            ansObjRec.Is_ISS_Pub__c = 'No';
            ansObjRec.Is_MTA_Pub__c = 'No';
            ansObjRec.Is_partner_led_SOP_exception__c = 'No';
            ansObjRec.Have_human_study_or_TA_research_No_SOP__c = 'No';
            ansObjREc.Have_data_or_product_materials__c = 'No';
            ansObjRec.Is_self_written_and_no_discussion__c = 'No';
            ansObjRec.Answer_Error_Message__c = errorMsg;
            disableRad = true;    
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMsg ));    
            }
        }
        
        if(gotoFPROnly <> true){
        system.debug('--------'+FPR_Only_Questions__c.getall().values());
        QuestionContent = getQuestionContent(answerValue,parentQuestion);
                answerValue = null;
        }
        
        if(disableRad == true || gotoFPROnly == true){
           
            try{
                insert ansObjRec;
                
            }
            catch(Exception e){
                ApexPages.addMessages(e);
                return null;
            }
            
        }
        ansRecId =  ansObjRec.Id;
        System.debug('Check the inserted Id' + ansRecId);
        return null;
    }*/ 
  //Appear Enhancement R1:2017 :: ends
    
    @remoteAction
    global static List<IdNameDTO> findPubsByName( string startWith){      
        List<IdNameDTO> results = new List<IdNameDTO>();
        
        List<Publication__c> pubs = AppearPubModel.findPubsByNameA(startWith);
        for(Publication__c p : pubs) {
            results.add(new IdNameDTO(null , p.Name + ' : ' + p.publication_title__c));
        }
        
        AppLogModel.flushLogs();
        return results;     
    }
    
    //FPR Only submitter button to delete publication
    WebService static String DeleteThisPublication(string Id) {
        AppearPubModel ActivePub = new AppearPubModel(id);
        if ( !ActivePub.hasValidPub) {
            AppLogModel.LogError('AppearPubViewModel::SubmitSuggestion', 
                'AppearPubModel cannot find valid pub for ' + id, id);
            AppLogModel.flushLogs();
            return 'Cannot find valid pub for ' + id;
        }
        
        AppLogModel.LogInfo('AppearPubViewModel::DeleteThisPublication', 
                'Invoke DeleteThisPublication for PubId : ['+Id+']', Id);
            
        AppLogModel.flushLogs();
        
        DeletePub(Id);
            
        AppLogModel.flushLogs();
        return 'Pending FPR Submission Canceled';
    }
    
    ////// Delete a Pub - static function - maybe invoked by batch
    private static boolean DeletePub(Id PubId) {
        AppearPubModel activePub = new AppearPubModel(PubId);
        
        if (!activePub.hasValidPub) {
            string msg = 'Aborting Delete Pub - Not a valid pub - cannot load '+PubId;
            AppLogModel.LogError('AppearPubModel::DeletePub', msg, pubId);
            AppLogModel.flushLogs();
            return false;
        }
        
        if (!activePub.hasEditAccess) {
            string msg = 'User : ' + UserInfo.getUserName()+ ' does not have EDIT access to '+activePub.PubTitle+'.  aborting now';
            AppLogModel.LogError('AppearPubModel::DeletePub', msg, pubId);
            AppLogModel.flushLogs();
            return false;
        }       
        
        //delete the childrens first
        List<sObject> delSObjectList = new List<sObject>();
        List<sObject> records = null;
        
        //Pub Attachment
        records = [select id from PubAttachmentDetails__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        records = [select id from Pub_Prod_Ind__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //FeedItems
        records = [select id from FeedItem where ParentId = :PubId];
        delSObjectList.addAll(records);
        
        //Pub Team Member
        records = [select id from PublicationTeamMember__c where publication__c = :PubId and isDeleted=false ];
        delSObjectList.addAll(records);
        
        //Pre FPR Reviewer
        records = [select id from PublicationPreFprReviewer__c where publication__c = :PubId and isDeleted=false ];
        delSObjectList.addAll(records);
        
        //Pub Review Team Member
        records = [select id from PubReviewTeam__c where publication__c = :PubId];
        delSObjectList.addAll(records);
                
        //Pub ME
        records = [select id from PubME__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        

        
        //FPR Cycle
        records = [select id from FPR_Cycle__c where publication__c = :PubId];
        delSObjectList.addAll(records);

        //Submission Cycle
        records = [select id from SubmissionCycle__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //Pub Related
        records = [select id from PubRelated__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        records = [select id from PubRelated__c where RelatedPub__c = :PubId];
        delSObjectList.addAll(records);
        
        
        //PubNotes
        records = [select id from PubNote__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //PubStudy
        records = [select id from PubStudy__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //PubScientific Statement
        records = [select id from PubScientificStatement__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //PubAuthors
        records = [select id from pubAuthor__c where publication__c = :PubId];
        delSObjectList.addAll(records);
        
        //Delete delSObjectList;
        List<Database.Deleteresult> drList = Database.delete(delSObjectList, true);
        
        boolean hasError = false;
        for(Database.Deleteresult dr : drList) {
            if(dr.isSuccess()){
                // Indicates success
                //return true;
            } else {
                hasError = true;
                // Get first save result error.
                Database.Error err = dr.getErrors()[0];
                string msg = err.getStatusCode() + ' '+ err.getMessage();
                AppLogModel.LogError('ApexShareModel::persistApexShare', msg, pubId);
                System.Debug(msg);

                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.FATAL, msg);
                ApexPages.addMessage(errMsg);
            }
        }
        if ( hasError) {
            AppLogModel.flushLogs();
            return false;
        }
        
        if ( delSObjectList.size() > 0) {
            Database.emptyRecycleBin(delSObjectList);
        }
        
        AppLogModel.LogInfo('AppearPubModel::DeletePub', UserInfo.getUserName() + ' invoked deletePub for Pub - '+activePub.PubId+
            '.    removed '+delSObjectList.size()+' records', pubId);
        
        delSObjectList.clear();
        
        activePub.pubRecord.PubStatus__c = null;
        update activePub.pubRecord;
        
        
        //Pub Prod Ind
        records = [select id from Pub_Prod_Ind__c where publication__c = :PubId  and isDeleted=false ];
        delSObjectList.addAll(records);
                
        //PubStatus
        records = [select id from PubStatus__c where Publication_id__c = :PubId];
        delSObjectList.addAll(records);     
                
        //The pub record
        delSObjectList.add(activePub.PubRecord);
        
        delete delSObjectList;
        if ( delSObjectList.size() > 0) {
            Database.emptyRecycleBin(delSObjectList);
        }
        
        AppLogModel.flushLogs();
        return true; 
    }
    
    //Appear Enhancement R2: Checking historical planning records if mandatory fields present or not before adding target.
    WebService static String CheckValidityOfPub(string Id) {
        AppearPubModel ActivePub = new AppearPubModel(Id);
        if ( !ActivePub.hasValidPub) {
            AppLogModel.LogError('AppearPubViewModel::AcceptPub', 
                'AppearPubModel cannot find valid pub for ' + id, Id);
            AppLogModel.flushLogs();
            return 'Cannot find valid pub for ' + id;
        }
        //Added if Logic as part of Appear Enhancment R1:2017
        if(ActivePub.pubRecord.Gpp_type__c == null){
            return 'Before Adding Target to publication, Please add Publication Classification';
        }
        
        String message='Before Adding Target to publication, please ensure the required field(s):';
            if(ActivePub.pubRecord.SponsorDept_Pick__c == null){
                message=message +' Sponsoring Amgen Department,';
            } 
            if(ActivePub.pubRecord.SponsorOrg_Pick__c == null){
                message=message +' Sponsoring Organization,';
            }
            if(ActivePub.pubRecord.RAE__c == null){
                message=message +' Responsible Amgen Employee,';
            }
            if (ActivePub.pubRecord.Country_pick__c == null){
                message=message +' Country,';
            }
            //Appear Enhancement R3: GPP Type field validation Added
            //Commented below as part of Appear Enhancment R1:2017
        /*if(ActivePub.pubRecord.GPP_Type__c == null){
                message=message +' Publication Classification,';
            }*/
            message= message.removeEnd(',');
            message = message + ' are updated on the publication as the publication is Part of GPP.';
            
            if(ActivePub.pubRecord.isPlanning__c){
                if(ActivePub.pubRecord.RAE__c == null || ActivePub.pubRecord.SponsorOrg_Pick__c == null || ActivePub.pubRecord.SponsorDept_Pick__c == null || ActivePub.pubRecord.Country_pick__c == null){//Appear Enhancement R3: GPP Type field validation Added - GPP Type Validation Removed R1:2017
                    return message;
                }
            }
            return null;
    }
    
    //anyone with edit access can submit a Pub
    WebService static String SubmitSuggestion(string Id) {
        AppearPubModel ActivePub = new AppearPubModel(id);
        if ( !ActivePub.hasValidPub) {
            AppLogModel.LogError('AppearPubViewModel::SubmitSuggestion', 
                'AppearPubModel cannot find valid pub for ' + id, id);
            AppLogModel.flushLogs();
            return 'Cannot find valid pub for ' + id;
        }
        
        if ( !ActivePub.hasEditAccess) {
            string msg = 'As '+ ProfileModel.CurrentProfileName + 
                ' you DO NOT have access to Submit this suggestion.';
            AppLogModel.LogError('AppearPubViewModel::SubmitSuggestion', 
                msg + '  pub id = ' + id, Id);
            AppLogModel.flushLogs();
            return msg;          
        }
        
        if (ActivePub.isPubTeamMemberOnRejectedPub) {
            string msg = 'As '+ ProfileModel.CurrentProfileName + 
                ' you DO NOT have access to Submit a Rejected suggestion.';
            AppLogModel.LogError('AppearPubViewModel::SubmitSuggestion', 
                msg + '  pub id = ' + id, Id);
            AppLogModel.flushLogs();
            return msg;          
        }
        
        AppLogModel.LogInfo('AppearPubViewModel::SubmitSuggestion', 
                'Invoke SubmitSuggestion for PubId : ['+Id+']', Id);
                
        ActivePub.PubStatus.InsertSubmitSuggestion(DateTime.Now());
            
        AppLogModel.flushLogs();
        return 'Suggestion Submitted';  
    }
    
    //Submit for FPR will copy reviewer based on subGroup & DataSource
    //
    WebService Static String SubmitForFPR(string Id){
        return SubmitForFPR(Id, true);  //shouldSetFprSubmitter = true
    }

    public Static String SubmitForFPR(string Id, boolean shouldSetFprSubmitter){
        
        AppearPubModel ActivePub = new AppearPubModel(id);
        if ( !ActivePub.hasValidPub) {
            AppLogModel.LogError('AppearPubViewModel::SubmitForFPR', 
                'AppearPubModel cannot find valid pub for ' + id, Id);
            AppLogModel.flushLogs();
            return 'AppearPubModel cannot find valid pub for ' + id;
        }
        
        if ( !ActivePub.hasEditAccess) {
            string msg = 'As '+ ProfileModel.CurrentProfileName + 
                ' you DO NOT have access to Submit this publication in ' +
                ActivePub.pubRecord.PubStatus__r.Status__r.stage__c + ' stage to FPR.';
            AppLogModel.LogError('AppearPubViewModel::SubmitForFPR', 
                msg + '  pub id = ' + id, Id);
            AppLogModel.flushLogs();
            return msg;         
        }
        //Defect 662 - check for data source before submitting to FPR
         if ( ActivePub.pubRecord.Data_Source__c == null) {
            AppLogModel.LogError('PubReviewTeamModel::SubmitForFPR', 
                'Please assign a Data Source for Pub '+ActivePub.pubRecord.Name, Id);  
            AppLogModel.flushLogs();
            return 'Please assign a Data Source for Pub '+ActivePub.pubRecord.Name;    
        }
        
        if ( ActivePub.pubRecord.SubGroup_Pick__c == null) {
            AppLogModel.LogError('PubReviewTeamModel::SubmitForFPR', 
                'Please assign a subGroup for Pub '+ActivePub.pubRecord.Name, Id);  
            AppLogModel.flushLogs();
            return 'Please assign a subGroup for Pub '+ActivePub.pubRecord.Name;    
        }
        
        if ( ActivePub.pubRecord.FPR_Due_Date__c == null) {
            AppLogModel.LogError('PubReviewTeamModel::SubmitForFPR', 
                'Please assign a FPR Due Date for Pub '+ActivePub.pubRecord.Name, Id);  
            AppLogModel.flushLogs();
            return 'Please assign a FPR Due Date for Pub '+ActivePub.pubRecord.Name;    
        }
        
        if ( ActivePub.pubRecord.Publication_Title__c == null) {
            AppLogModel.LogError('PubReviewTeamModel::SubmitForFPR', 
                'Please assign a Publication Title for Pub '+ActivePub.pubRecord.Name, Id); 
            AppLogModel.flushLogs();
            return 'Please assign a Publication Title for Pub '+ActivePub.pubRecord.Name;   
        }
        
        if ( ActivePub.pubRecord.Publication_Type__c == null) {
            AppLogModel.LogError('PubReviewTeamModel::SubmitForFPR', 
                'Please assign a Publication Type for Pub '+ActivePub.pubRecord.Name, Id);  
            AppLogModel.flushLogs();
            return 'Please assign a Publication Type for Pub '+ActivePub.pubRecord.Name;    
        }
        
        
        if ( ActivePub.pubRecord.Journal__c == null && ActivePub.pubRecord.Meeting__c == null && ActivePub.pubRecord.Add_Meeting_Journal__c == null) {
            AppLogModel.LogError('PubReviewTeamModel::SubmitForFPR', 
                'Please assign a Target for Pub '+ActivePub.pubRecord.Name, Id);    
            AppLogModel.flushLogs();
            return 'Please assign a Target for Pub '+ActivePub.pubRecord.Name;  
        }
        
        //CC140 - Added validation to include legacy authors on legacy publication
        //Miscellaneous change - LogError was incorrectly noting PubReviewTeamModel instead of AppearPubViewModel
        if ( ActivePub.PubAuthor.PubAuthorList.size() == 0 && ActivePub.pubRecord.Authors_Not_Found__c == null && ActivePub.pubRecord.Legacy_Authors__c == null) {
            AppLogModel.LogError('AppearPubViewModel::SubmitForFPR', 
                'Please assign an Author for Pub '+ActivePub.pubRecord.Name, Id);   
            AppLogModel.flushLogs();
            return 'Please assign an Author for Pub '+ActivePub.pubRecord.Name; 
        }
        
                    
        //Defect 234 - check if Attachment of Type ('Draft Sent For FPR ) has been uploaded
        if (!ActivePub.PubAttachments.hasDraftSentForFPRAttachmentType && !test.isRunningTest()) {
            string errorMsg = 'Attachment of Attachment Type ("Draft Sent For FPR") is required for the FPR process.';
            AppLogModel.LogError('AppearPubViewModel::SubmitForFPR', errorMsg, Id);
            AppLogModel.flushLogs();
            return errorMsg;
        }
        
        //Appear R3 Enhancement Submit for FPR Check for CSP Publications
        string errorMsg = 'Before submission to FPR:';
        /* Commented below as part of Appear Enhancment R1:2017
        if((ActivePub.PubRecord.Current_FPR_Cycle_Num__c == null || ActivePub.PubRecord.Current_FPR_Cycle_Num__c == '1') && !ActivePub.PubAttachments.returnIfAllAuthorsdHaveProvidedComments(ActivePub.PubAuthor.PubAuthorList, ActivePub.PubRecord.Current_FPRCycle_Id_Formula__c) && ActivePub.pubRecord.GPP_Type__c == 'CSP' && ActivePub.pubRecord.isPlanning__c == true){
           errorMsg = errorMsg +'\n'+'Substantial comments are required for each author.';
        }
        if((ActivePub.PubRecord.Current_FPR_Cycle_Num__c == null || ActivePub.PubRecord.Current_FPR_Cycle_Num__c == '1') && !ActivePub.PubAttachments.checkAttachmentTypeOfRaeChecklist() && ActivePub.pubRecord.GPP_Type__c == 'CSP' && ActivePub.pubRecord.isPlanning__c == true){
           errorMsg = errorMsg +'\n'+'Attachment type \"RAE Attestation Checklist\" is required.';
        }
        if((ActivePub.PubRecord.Current_FPR_Cycle_Num__c == null || ActivePub.PubRecord.Current_FPR_Cycle_Num__c == '1') && !ActivePub.PubStatus.isDraftDatePopulated(ActivePub.PubRecord.Current_FPRCycle_Id_Formula__c) && ActivePub.pubRecord.GPP_Type__c == 'CSP' && ActivePub.pubRecord.isPlanning__c == true){
           errorMsg = errorMsg +'\n'+'Draft date [actual] is required on the Status tab.';    
        } */
        // Start - Updated Submit for FPR validation Appear Enhancment R1:2017
        if((ActivePub.PubRecord.Current_FPR_Cycle_Num__c == null || ActivePub.PubRecord.Current_FPR_Cycle_Num__c == '1') && ActivePub.pubRecord.GPP_Type__c == 'CSP'){
            if(!ActivePub.PubAttachments.returnIfAllAuthorsdHaveProvidedComments(ActivePub.PubAuthor.PubAuthorList, ActivePub.PubRecord.Current_FPRCycle_Id_Formula__c)){
               errorMsg = errorMsg +'\n'+'Substantial comments are required for each author.';
            }
            if(!ActivePub.PubStatus.isDraftDatePopulated(ActivePub.PubRecord.Current_FPRCycle_Id_Formula__c)){
               errorMsg = errorMsg +'\n'+'Draft date [actual] is required on the Status tab.';    
            }
            if(!ActivePub.PubAttachments.checkAuthorDisclouserAttachment(ActivePub.PubAuthor.PubAuthorList)){
                //errorMsg = errorMsg  +'\n'+'Attachment type \"Author Disclouser\" is required for All Authors.';
                errorMsg = errorMsg  +'\n'+'An \"Author Disclosures\" attachment is required for each Author.';
            }
            if(!ActivePub.PubAttachments.checkRAEAttachmentPart2Checklist()){
                //errorMsg = errorMsg +'\n'+'Attachment type \"RAE Checklist Part 2\" is required.';
                errorMsg = errorMsg +'\n'+'An \"RAE Attestation Sec B\" attachment is required.';
            }
            if(!ActivePub.PubAttachments.checkMonitoringAttachmentPart2Checklist()){
                //errorMsg = errorMsg  +'\n'+'Attachment type \"Monitoring Checklist Part 2\" is required.';
                errorMsg = errorMsg  +'\n'+'Functional Monitoring has not yet completed validation for this checkpoint. You will be notified via email once you can proceed.';
            }
        }
         // End - Updated Suubmit for FPR validation Appear Enhancment R1:2017
        if(errorMsg.endsWith('.'))  {
            return errorMsg;
        }
        //Appear R3 Enhancement Submit for FPR Check for CSP Publications
        
        AppLogModel.LogInfo('AppearPubViewModel::SubmitForFPR', 
                'Invoke Submit for FPR for PubId : '+Id+' isFpr__c = '+ActivePub.pubRecord.isFPR__c);
        
        AppLogModel.LogDebug('AppearPubViewModel::SubmitForFPR', 
                'isFpr__c = '+ActivePub.pubRecord.isFPR__c);
    
        string PubId = Id;
    
        ActivePub.pubRecord.Route_Pattern__c = ActivePub.CurrentRoutePattern;
        
        //Def based on discussion between Benjamin & Swapnil on 7/16/2013
        //
        ActivePub.pubRecord.Sponsored_Date__c = DateTime.Now();
                    
        if (shouldSetFprSubmitter) {
            Set<id> contactIds = AppearContactModel.findContactForAppearUser(UserInfo.getUserId()); //set Fpr_Submitter
            for(id contactId : contactIds) {
                ActivePub.pubRecord.FPR_Submitter__c = contactId;
                break;
            }
        }
        
        ActivePub.pubRecord.Assigned_FPRC__c = null; //always set Assigned_FPRC to null
        
        AppLogModel.LogDebug('AppearPubViewModel::SubmitForFPR', 
                'before update isFpr__c = '+ActivePub.pubRecord.isFPR__c, Id);
        update ActivePub.pubRecord;
        AppLogModel.LogDebug('AppearPubViewModel::SubmitForFPR', 
                'after update isFpr__c = '+ActivePub.pubRecord.isFPR__c, Id);
                
        boolean currentFprCycleBeenReset = ActivePub.FprCycle.FprCycleHasBeenReset(ActivePub.CurrentFprCycleId);
        
        //find current FPR Cycle - and increment by 1 if there is an FPR Cycle
        FPR_Cycle__c nextFprCycle;
        if ( ActivePub.PubRecord.Current_FPRCycle_Id_Formula__c == null){
            nextFprCycle = ActivePub.FprCycle.getFprCycleByNum(1);
            AppLogModel.LogInfo('AppearPubViewModel::SubmitForFPR', 
                'Created FPR Cycle 1 for pub '+ ActivePub.PubName, Id);
        } else {
            // we do have a FPR Cycle - check if we need to increment it.
            if (currentFprCycleBeenReset){
                nextFprCycle = ActivePub.IncrFprCycle();    
            } else {
                integer currFprCycleNum = ActivePub.CurrentFprCycleNum;
                nextFprCycle = ActivePub.FprCycle.getFprCycleByNum(currFprCycleNum);
            }
        }
    
        PubStatus__c inFprPubStatus = ActivePub.PubStatus.InsertInFprPubStatus(nextFprCycle.id);                
        AppLogModel.LogDebug('AppearPubViewModel::SubmitForFPR', 
                'after InsertInFprPubStatus isFpr__c = '+ActivePub.pubRecord.isFPR__c, Id);
        /*
        //set the rest of status of the Current FPR Cycle to the new FPR Cycle
        ActivePub.PubStatus.updatePubStatusFprCycle(inFprPubStatus,ActivePub.CurrentFprCycleId, nextFprCycle);          
        */
        ActivePub.PubStatus.InsertGlobalStatusReviewSubmit(null, nextFprCycle.id);
        
        //Update the Current FPR Cycle Num on the Attachment especially Draft Sent for FPR (during FPR Submission irrespective of whether it is Planned/Unplanned/FPR Only)
        //Start 
        List<PubAttachmentDetails__c> pubAttachmentsLst = PubAttachmentModel.getAllPubAttachmentList(pubId);
        List<PubAttachmentDetails__c> updPubAttachmentsLst = new List<PubAttachmentDetails__c>();
        
        for(PubAttachmentDetails__c pubAttachment : pubAttachmentsLst) {
            If(pubAttachment.AttachmentType__c == PubAttachmentModel.DraftSentForFPRAttachmentType && pubAttachment.FPR_Cycle__c == null) {
                pubAttachment.FPR_Cycle__c = nextFprCycle.id;
                updPubAttachmentsLst.add(pubAttachment);
            }
        }
        
        update updPubAttachmentsLst;
        //End
        
        /* //Def #805 accepted is now inserted at pub insert
        if (nextFprCycle.FPR_Cycle_Num__c == 1) {
            ActivePub.PubStatus.InsertAccepted(null, nextFprCycle.id);
        }
        */
        
        //Def #686 S3 - move status to new FPR cycle 
        /*
        Finally, this is how the statuses should look like:
        > "In FPR" w/ Actual Date; SC = 1, FC = 2
        > "Approved by all Authors" w/o Actual Date; SC = 1, FC = 2
        > "Submitted/Completed" w/o Actual Date; SC = 1, FC = 2
        > "Accepted" w/o Actual Date; SC = 1, FC = 2
        > "Published/Presented" w/o Actual Date; SC = 1, FC = 2
        */
        ActivePub.PubStatus.MovePubStatusToCurrentFCandSC(StatusModel.ResetFprCycleStatusList, 
            ActivePub.pubRecord.Current_SubmissionCycle_Id_Formula__c, nextFprCycle.id,false);
        
        /* now handled by move function created for def #805
        //Def 534 - Insert Approved By all Authors if FC > 1
        if ( nextFprCycle.FPR_Cycle_Num__c > 1.0 ) {
            ActivePub.PubStatus.InsertApprovedByAllAuthors(ActivePub.CurrentSubmissionCycleId, nextFprCycle.Id);
        }
        */
        
        string responseMessage = '';
        ActivePub.PubReviewTeam.CopyPubReviewTeamFromSubGroup(nextFprCycle);
        AppLogModel.LogDebug('AppearPubViewModel::SubmitForFPR', 
                'after CopyPubReviewTeamFromSubGroup isFpr__c = '+ActivePub.pubRecord.isFPR__c, Id);
        ActivePub.resetSharing();
        AppLogModel.LogDebug('AppearPubViewModel::SubmitForFPR', 
                'after resetSharing isFpr__c = '+ActivePub.pubRecord.isFPR__c, Id);
        
        //Def 281 
        //Auto copy all PubTeamMembers to preFPRreviewer including manual if Pub is Planned
        //only the first time - SC num == 1 / FC num == 1
        //PreFprReview is not SC / FC specific
        if ( !ActivePub.pubRecord.IsFpr__c && ActivePub.CurrentSubmissionCycleNum == 1 && ActivePub.pubRecord.Current_FPRCycle_Id_Formula__c == null) {
            //ActivePub.PreFprReviewer.CopyPubTeamMembersAsPreFprReviewer(ActivePub.PubTeamMember.PubTeamMembers);
            PubPreFprReviewerModel.CopyPubTeamMembersAsPreFprReviewerFuture(ActivePub.PubId);
        } else {
            AppLogModel.LogDebug('AppearPubViewModel::SubmitForFPR', 'skipped Auto copy all PubTeamMembers to preFPRreviewer including manual if Pub is Planned'
                + '  isFpr__c='+ActivePub.pubRecord.IsFpr__c+' ActivePub.CurrentSubmissionCycleNum = '+ ActivePub.CurrentSubmissionCycleNum 
                + ' ActivePub.pubRecord.Current_FPRCycle_Id_Formula__c = '+ ActivePub.pubRecord.Current_FPRCycle_Id_Formula__c, 
                ActivePub.pubid);   
        }
        
        //Def #621 - C - isFPR flag
        ActivePub = new AppearPubModel(pubId);
        ActivePub.PubRecord.isFPR__c = true;
        update ActivePub.PubRecord;
        
        AppLogModel.flushLogs(); 
        
        ActivePub = new AppearPubModel(PubId);
        ActivePub.ChangeOwnershipToTemporaryPoolUser(true);
        ActivePub.resetSharing(); //second reset sharing intentional - after ownership change and in FPR current status at this point to exclude pub team edit access
        return 'Submitted for FPR';     
    }

    WebService static String RouteForReview(string Id) {
        AppearPubModel ActivePub = new AppearPubModel(id);
        if ( !ActivePub.hasValidPub) {
            AppLogModel.LogError('AppearPubViewModel::RouteForReview', 
                'AppearPubModel cannot find valid pub for ' + id, Id);
            AppLogModel.flushLogs();
            return 'Cannot find valid pub for ' + id;
        }
        
        if ( !ActivePub.hasEditAccess) {
            string msg = 'As '+ ProfileModel.CurrentProfileName + 
                ' you DO NOT have access to Route this publication in ' +
                ActivePub.pubRecord.pubStatus__r.Status__r.stage__c + ' stage for Review.';
            AppLogModel.LogError('AppearPubViewModel::RouteForReview', 
                msg + '  pub id = ' + id, Id);
            AppLogModel.flushLogs();
            return msg;         
        }
        
         //Defect 234 - check if Attachment of Type ('Draft Sent For FPR ) has been uploaded
        if (!ActivePub.PubAttachments.hasDraftSentForFPRAttachmentType) {
            string errorMsg = 'Attachment of Attachment Type ("Draft Sent For FPR") is required for the FPR process.';
            AppLogModel.LogError('AppearPubViewModel::RouteForReview', errorMsg, Id);
            AppLogModel.flushLogs();
            return errorMsg;
        }

        //CC 20 - Added validation for a review team member to be associated before routing
        if ( ActivePub.PubReviewTeam.PubReviewTeamMembers.size() == 0 || ActivePub.PubReviewTeam.PubReviewTeamMembers[0].type__c != 'Primary')
        {
           string errorMsg= 'To route the publication, include at least one Primary Reviewer in the Reviewers list for the current FPR cycle.';
            AppLogModel.LogError('AppearPubViewModel::RouteforReview',errorMsg, Id);
            return errorMsg; 
        }
        
        AppLogModel.LogInfo('AppearPubViewModel::RouteForReview', 
                'Invoke Route for Review for PubId : '+Id, Id);
                
        ActivePub.PubStatus.InsertRoutePubStatus();
        
        //setup Delivered date for Reviewer
        ActivePub.PubReviewTeam.SetDeliveryDateForPubReviewTeam();

        ActivePub.resetSharing();
        AppLogModel.flushLogs();
        
        return 'Routed';    
    }
    
    
    WebService Static String SubmitToTarget(string Id){
        AppearPubModel ActivePub = new AppearPubModel(id);
        if ( !ActivePub.hasValidPub) {
            AppLogModel.LogError('AppearPubViewModel::SubmitForTarget', 
                'AppearPubModel cannot find valid pub for ' + id, Id);
            AppLogModel.flushLogs();
            return 'Cannot find valid pub for ' + id;
        }
        
        if ( !ActivePub.hasEditAccess) {
            string msg = 'As '+ ProfileModel.CurrentProfileName + 
                ' you DO NOT have access to Submit this publication in ' +
                ActivePub.pubRecord.pubStatus__r.Status__r.stage__c + ' stage to Target.';
            AppLogModel.LogError('AppearPubViewModel::SubmitToTarget', 
                msg + '  pub id = ' + id, Id);
            AppLogModel.flushLogs();
            return msg;         
        }
        
        AppLogModel.LogInfo('AppearPubViewModel::SubmitForTarget', 
                'Invoke Submit To Target for PubId : '+Id, Id);
                
        //need action
        //change status to submitted
        ActivePub.PubStatus.ChangePubStatusToSubmitted();
        
        //update the Submission cycle if this is not the first submission.
        ActivePub.resetSharing();
        AppLogModel.flushLogs(); 
        return 'Submitted to target';       
    }

    WebService static String AcceptPub(string Id) {
        AppearPubModel ActivePub = new AppearPubModel(id);
        if ( !ActivePub.hasValidPub) {
            AppLogModel.LogError('AppearPubViewModel::AcceptPub', 
                'AppearPubModel cannot find valid pub for ' + id, Id);
            AppLogModel.flushLogs();
            return 'Cannot find valid pub for ' + id;
        }
        
        //TC4.3 - No other user except GPPL will be able to accept the Suggestions 
        //TC5.2 - No other user except GPPL will be able to Reject a Suggestion. 
        if ( ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearGPPL || ProfileModel.isSysAdmin) {
            if ( !ActivePub.hasEditAccess) {
                string msg = 'As '+ ProfileModel.CurrentProfileName + 
                    ' you DO NOT have access to Accept this publication in ' +
                    ActivePub.pubRecord.PubStatus__r.Status__r.stage__c + ' stage.';
                AppLogModel.LogError('AppearPubViewModel::AcceptPub', 
                    msg + '  pub id = ' + id, Id);
                AppLogModel.flushLogs();
                return msg;         
            }
            
            AppLogModel.LogInfo('AppearPubViewModel::AcceptPub', 
                    'Invoke Accept Publication for PubId : '+Id, Id);
                    
            //Def #621
            //CR #227/229 - set IsPlanning__c to false if Istracking or IsISS            
            ActivePub.pubRecord.isPlanning__c = (!ActivePub.pubRecord.Is_Tracking_Only__c && !ActivePub.pubRecord.isISS__c);
            
            //Checking the mandate fields present for Publication if isPlanning__c is checked: Appear R2 Enhancement
            String message='The following field(s) are required for a GPP Publication :'; // Error Message changed as Defect 1 Appear Enhancement R2
            if(ActivePub.pubRecord.SponsorDept_Pick__c == null){
                message=message +' Sponsoring Amgen Department,';
            } 
            if(ActivePub.pubRecord.SponsorOrg_Pick__c == null){
                message=message +' Sponsoring Organization,';
            }
            if(ActivePub.pubRecord.RAE__c == null){
                message=message +' Responsible Amgen Employee(RAE),';
            }
            if (ActivePub.pubRecord.Country_pick__c == null){
                message=message +' Country,';
            }
            //Appear Enhancement R3: GPP Type field validation Added in Accept button.
            //Commented below as part of Appear Enhancment R1:2017
            /*if(ActivePub.pubRecord.GPP_Type__c == null){
                message = message + ' Publication Classification,';
            }*/
            message= message.removeEnd(',');
                                    
            if(ActivePub.pubRecord.isPlanning__c){
                 if(ActivePub.pubRecord.RAE__c == null || ActivePub.pubRecord.SponsorOrg_Pick__c == null || ActivePub.pubRecord.SponsorDept_Pick__c == null || ActivePub.pubRecord.Country_pick__c == null){ //Appear Enhancement R3: GPP Type field validation Added - GPP Type field validation removed R1:2017
                    return message;
                 }
            }
            update ActivePub.pubRecord;
                    
            //Def 16, 17 - change owner of pub to GPPL - or the person accepting this pub record
            ActivePub.ChangeOwnershipToCurrentUser(true);  //update pub record
            
            ActivePub.PubStatus.InsertConceptPubStatus();
            
            AppLogModel.flushLogs();
             
            return 'Accepted';              
        } else {
            string message = 'Your login id is associated with ['+ProfileModel.CurrentProfileName +
                ' profile], you do not have access to accept this Suggestion.';
            AppLogModel.LogError('AcceptPub', message, Id);
            AppLogModel.flushLogs();
            return message;
        }
        
        

    }

    // used to reject a suggestion 
    WebService static String RejectPub(string Id) {
        AppearPubModel ActivePub = new AppearPubModel(id);
        if ( !ActivePub.hasValidPub) {
            AppLogModel.LogError('AppearPubViewModel::RejectPub', 
                'AppearPubModel cannot find valid pub for ' + id, Id);
            AppLogModel.flushLogs();
            return 'Cannot find valid pub for ' + id;
        }
        
        
        //TC4.3 - No other user except GPPL will be able to accept the Suggestions 
        //TC5.2 - No other user except GPPL will be able to Reject a Suggestion. 
        if ( ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearGPPL || ProfileModel.isAppearIntFPRC  || ProfileModel.isSysAdmin) {
            if ( !ActivePub.hasEditAccess) {
                string msg = 'As '+ ProfileModel.CurrentProfileName + 
                    ' you DO NOT have access to Reject this Suggestion in ' +
                    ActivePub.pubRecord.PubStatus__r.Status__r.stage__c + ' stage.';
                AppLogModel.LogError('AppearPubViewModel::RejectPub/Suggestion', 
                    msg + '  pub id = ' + id, Id);
                AppLogModel.flushLogs();
                return msg;         
            }
            
            AppLogModel.LogInfo('AppearPubViewModel::RejectPub', 
                    'Invoke Reject Publication for PubId : '+Id, Id);

            //Def #17 - change owner to tempPoolUser - so submitter only have R/O access
            ActivePub.ChangeOwnershipToTemporaryPoolUser(true);
                    
            ActivePub.PubStatus.InsertSuggestionRejectedPubStatus();
        
            AppLogModel.flushLogs();
            
            return 'Rejected';  
        } else {
            string message = 'Your login id is associated with ['+ProfileModel.CurrentProfileName +
                ' profile], you do not have access to reject this Suggestion.';
            AppLogModel.LogError('RejectPub', message, Id);
            AppLogModel.flushLogs();
            return message;
        }
    }
    
    //TerminateFPRCycle returns string for error message. Null for success
    WebService static String TerminateFPRCycle(string Id) {
        AppearPubModel ActivePub = new AppearPubModel(id);
        if ( !ActivePub.hasValidPub) {
            AppLogModel.LogError('AppearPubViewModel::TerminateFPRCycle', 
                'AppearPubModel cannot find valid pub for ' + id, Id);
            AppLogModel.flushLogs();
            return 'Cannot find valid pub for ' + id;
        } 
        
    
        if ( ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC  || ProfileModel.isSysAdmin) {
            if ( !ActivePub.hasEditAccess) {
                string msg = 'As '+ ProfileModel.CurrentProfileName + 
                    ' you DO NOT have access to Terminate FPR Cycle for this publication in ' +
                    ActivePub.pubRecord.PubStatus__r.Status__r.stage__c + ' stage.';
                AppLogModel.LogError('AppearPubViewModel::TerminateFPRCycle', 
                    msg + '  pub id = ' + id, Id);
                AppLogModel.flushLogs();
                return msg;         
            }
            
            //Def 228 - now check if FPRC has changed the Route Pattern
            if ( ActivePub.CurrentRoutePattern == ActivePub.pubRecord.Route_Pattern__c) {
                return 'Please update/modify the Product-Indications and/or Data Source and/or Sub-Group before proceeding with FPR Cycle Termination.';
            }
            
            AppLogModel.LogInfo('AppearPubViewModel::TerminateFPRCycle', 
                    'Invoke Terminate FPR Cycle for PubId : '+id, Id);
                    
            //Code unit started for CR: #88 and #32
            //Setting the Assigned FPRC as null after the Terminate FPR Action 
            ActivePub.pubRecord.Assigned_FPRC__c = null;
            update ActivePub.pubRecord;
            // Code unit ended for CR: #88 and #32
            
            ActivePub.PubStatus.InsertTerminateFPRCycleStatus();
            
            //Copy the adhoc reviewer -- the ones wth isFromSubGroupDataSource = false          
            //Dev #587 - Duplicate Adhoc Reviewer has been moved to execute in future
            ActivePub.PubReviewTeam.DuplicateAdHocReviewer();
            
            //Now we have a new Product Indication - should flush PubTeamMember cache
            //get the latest pubteam in cache before SubmitForFPR
            ActivePub.PubTeamMember.flushCache();
            ActivePub.PubReviewTeam.flushCache();
            
            Id lastScId = ActivePub.CurrentSubmissionCycleId;
            Id lastFcId = ActivePub.CurrentFprCycleId;
            
            String strMsgAfterSubmitForFPR = SubmitForFPR(Id, false);
            
            if(strMsgAfterSubmitForFPR.length() > 18) return strMsgAfterSubmitForFPR;
            
            ActivePub = new AppearPubModel(id);
            
            /* after defect 805, this move routine is moved to central function inside SubmitForFpr()
            //Def #534 - Move Published/Presented & Submitted Completed to  the new FPR Cycle
            //AppLogModel.LogInfo("")
            List<PubStatus__c> pubStatusToMove = [
                select Fpr_Cycle__c
                from PubStatus__c
                where publication_id__c = :id
                and Submission_Cycle__c = :lastScId
                and Fpr_Cycle__c = :lastFcId
                and Status__r.name in ( :StatusModel.SubmittedCompletedStatus, :StatusModel.PublishedPresentedStatus)
            ];
            
            for(PubStatus__c ps : pubStatusToMove) {
                ps.Fpr_Cycle__c = ActivePub.CurrentFprCycleId;
            }
            update pubStatusToMove;
            */
            
            AppLogModel.flushLogs();
            
            
            
                    
            return null;    
        } else {
            string message = 'Your login id is associated with ['+ProfileModel.CurrentProfileName +
                ' profile], you do not have access to Terminate this FPR Cycle.';
            AppLogModel.LogError('AppearPubViewModel::TerminateFPRCycle', message, Id);
            AppLogModel.flushLogs();
            return message;
        }
    }
    
    
    //RejectPublication is for rejection by Journal / Congress
    //As per Def 271 - we will increment both SC & FC after a rejection
    //Returns string for error message. Null for success
    WebService static String RejectPublication(string Id) {
        AppearPubModel ActivePub = new AppearPubModel(id);
        if ( !ActivePub.hasValidPub) {
            AppLogModel.LogError('AppearPubViewModel::RejectPublication', 
                'AppearPubModel cannot find valid pub for ' + id, Id);
            AppLogModel.flushLogs();
            return 'Cannot find valid pub for ' + id;
        }
         
    
        if ( ProfileModel.isAppearWriting || ProfileModel.isAppearGPPL || ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC  || ProfileModel.isSysAdmin) {
            if ( !ActivePub.hasEditAccess) {
                string msg = 'As '+ ProfileModel.CurrentProfileName + 
                    ' you DO NOT have EDIT access to Reject this publication in ' +
                    ActivePub.pubRecord.PubStatus__r.Status__r.stage__c + ' stage.';
                AppLogModel.LogError('AppearPubViewModel::TerminateFPRCycle', 
                    msg + '  pub id = ' + id, Id);
                AppLogModel.flushLogs();
                return msg;         
            } 
            
            AppLogModel.LogInfo('AppearPubViewModel::RejectPublication', 
                    'Invoke RejectPublication for PubId : '+Id, Id);
                    
            //insert the reject status
            ActivePub.PubStatus.InsertRejectedAfterSubmissionStatus();
             
            //create new global status for next submission cycle without actual date
            /* disable creation on status and next submission / fpr cycle as per Def 296/271
            
            integer nextSubmissionCycleNum = ActivePub.CurrentSubmissionCycleNum + 1;
            SubmissionCycle__c nextSubCycle = ActivePub.SubmissionCycle.getSubmissionCycleByNum(nextSubmissionCycleNum);
            
            //Def 271 - increment FprCycleNum after Reject
            integer nextFprCycleNum = ActivePub.CurrentFprCycleNum + 1;
            FPR_Cycle__c nextFprCycle = ActivePub.FprCycle.getFprCycleByNum(nextFprCycleNum);
            
            ActivePub.PubStatus.InsertDraftWithActualDate(nextSubCycle.id, nextFprCycle.id);
            ActivePub.PubStatus.InsertGlobalStatusReviewSubmit(nextSubCycle.id, nextFprCycle.id);
            ActivePub.PubStatus.InsertSubmitCompleted(nextSubCycle.id, nextFprCycle.id);
             
            */ 
            AppLogModel.flushLogs();
            //change in return message based on defect 360.
            //return 'Publication has been successfully rejected. Please change/confirm new target for re-purposing the current publication.
            //PLEASE NOTE: When re-purposing an "Abstract" after Rejection, 
            //user should always create a new publication record instead of using the same publication record.';
            return null;     
        } else {
            string message = 'Your login id is associated with ['+ProfileModel.CurrentProfileName +
                ' profile], you do not have access to Reject this Publication.';
            AppLogModel.LogError('AppearPubViewModel::RejectPublication', message, Id);
            AppLogModel.flushLogs();
            return message;
        }
    }
    
    //MaterialChangeForCongressJournal returns string if error message, otherwise null
    WebService static String MaterialChangeForCongressJournal(string Id) {
        AppearPubModel ActivePub = new AppearPubModel(id);
        if ( !ActivePub.hasValidPub) {
            AppLogModel.LogError('AppearPubViewModel::MaterialChangeForCongressJournal', 
                'AppearPubModel cannot find valid pub for ' + id, Id);
            AppLogModel.flushLogs();
            return 'Cannot find valid pub for ' + id;
        }
        
    
        if ( ProfileModel.isAppearGPPL || ProfileModel.isAppearBusinessAdmin || ProfileModel.isAppearExternalWriter || ProfileModel.isAppearWriting ||  ProfileModel.isAppearFPRC || ProfileModel.isAppearIntFPRC  || ProfileModel.isSysAdmin) {
            if ( !ActivePub.hasEditAccess) {
                string msg = 'As '+ ProfileModel.CurrentProfileName + 
                    ' you DO NOT have access to initiate a [Material Change For Congress/Journal] for this publication in ' +
                    ActivePub.pubRecord.PubStatus__r.Status__r.stage__c + ' stage.';
                AppLogModel.LogError('AppearPubViewModel::MaterialChangeForCongressJournal', 
                    msg + '  pub id = ' + id, Id);
                AppLogModel.flushLogs();
                return msg;         
            }
            
            AppLogModel.LogInfo('AppearPubViewModel::MaterialChangeForCongressJournal', 
                    'initiate a [Material Change For Congress/Journal] for PubId : '+Id, Id);
        
            //Code unit started for CR: #121
            //Setting the Assigned FPRC as null after the Terminate FPR Action 
            ActivePub.pubRecord.Assigned_FPRC__c = null;
            ActivePub.pubRecord.FPR_Due_Date__c = null; //This needs to be set as blank when Pub is going to the next FPR Cycle.
            update ActivePub.pubRecord;
            // Code unit ended for CR: #121
            
            ActivePub.PubStatus.InsertMaterialChangeForCongressJournalStatus();
            
            AppLogModel.flushLogs();
            //return 'Material Changes for Journal/Congress status added';
            return null;    
        } else {
            string message = 'Your login id is associated with ['+ProfileModel.CurrentProfileName +
                ' profile], you do not have access to initiate a [Material Change For Congress/Journal] for this Publication.';
            AppLogModel.LogError('AppearPubViewModel::MaterialChangeForCongressJournal', message, Id);
            AppLogModel.flushLogs();
            return message;
        }
    }
    
    
}