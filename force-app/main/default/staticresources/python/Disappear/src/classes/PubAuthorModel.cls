Public with sharing class PubAuthorModel {
    private id PubId;
    private string ActiveTile;
    private string ActiveSubMenu;
    public publication__c ActivePub {get;set;}
    public string PubAuthorIDUpdate{get;set;}
    private boolean isFprSubmitter;
    Public boolean InviteDisabled{get;set;}
    Public Boolean BothSelected{get;set;}
    Public ProvisionDocumentVersion__c comp{get;set;}
    public boolean hasEditAccess { get; private set;}
    public List<ContactAddressWrapperCls> ContactAddressList{get;set;}
    public List<DocumentWrapperCls> DocList {get;set;}
    public List<DocumentWrapperCls> ReminderList {get;set;}
    public List<DocumentWrapperCls> ApprovalList {get;set;}
    public List<String> selDocumentNames {get;set;}
    public List<String> selContactAddressId{get;set;}
    public List<String> selApprovalTemplNames {get;set;}
    public Boolean hasSelDoc {get;set;}
    Public List<PubAuthor__c> selectedAuthors {get;set;}
    Public List<PubAuthor__c> delAut {get;set;}
    Public List<PubAuthor__c> InvSentAut {get;set;}
    Public string CreatedByName{get;set;}
    Public List<PubAuthor__c> InvAcceptAut {get;set;}
    Public List<PubAuthor__c> ApprSentAut {get;set;}
    Public List<contact_address__c> ConAdd{get;set;}
    public string AddtlDetails{get;set;}
    Public String AddtlDetailsReminderUpdate{get;set;}
    public string Justification{get;set;}
    public string PubName{get;set;}
    public string PubTitle{get;set;}
    public string PubType{get;set;}
    public string PubCurrentTarget{get;set;}
    public pagereference iframesource{get;set;}
    //public string AddtlDetails{get;set;}
    Public id DocId{get;set;}
    Public String ReminderType{get;set;}
    // public Date ByDateTime{get;set;}
    public pubAuthor__c tempPubAuthor {get; set;}    
    Public String DiscId{get;set;}
    public boolean IsFPROnlyPublication{get;set;}
    Public String AuthorContactAddressId{get;set;}
    Public String AuthorContactPubAuthorId{get;set;}
    Public String PublicationId{get;set;}
    Public String ContactId{get;set;}
    Public String ContactUserId{get;set;}
    Public pubAuthor__c PubAuthorAddress{get;set;}
    Public List<FeedItem> RelFeedItems {get;set;}
    private AppearPubModel pubModel;
    public boolean VerifyFinalAuthorApprovalAttachmentType {get;set;}
    //Appear Enhancement R2: Code Implemented for Advanced Author Search Functionality
    public List<PubEmail__c> invitationEmail{get;set;}
    public List<PubEmail__c> reminderEmail{get;set;}
    public List<PubEmail__c> finalAuthorApprovalEmail{get;set;}
    private String soql {get;set;}
    public string firstName{get;set;}
    public string lastName{get;set;}
    public string middleName{get;set;}
    public string email{get;set;}
    private List<Contact> pcontact = null;
    public List<Id> newAuthorIDList;
    public boolean authorSearched = false;
    public List<cContact> contactList {get; set;}
    public Boolean enableAddAuthorButton{get;set;}// Appear Enhancement R1:2017 - Add Author button visibility
    public integer noOfCurrentAuthorsinPub; //Appear Enhancement R1:2017 - Authors count
    public List<cContact> addAuthorListNew
    {
    get
        {
            return contactList;
        
        }
    set;
    }
    //public string attachmentPubId{get;set;} // Appear Enhancement 2017 Backlog R2
    //Appear Enhancement R2: Advanced Author Search method for searching Authors 
    public void SearchAuthorList() {
        pcontact = null;
        authorSearched= false;
        contactList = new List<cContact>();
       // soql = 'select firstname, lastname, email, Country__c, middlename,Isselected__c,Name from Contact where Id != null'; 
       	noOfCurrentAuthorsinPub = PubAuthorList.size(); // Appear Enhancement R1:2017 - Check No of Authors
        // Appear Enhancement R1:2017 - Remove inactive internal authors from author search.
        String intRecordTypeName = 'Internal Contact';
        String extRecordTypeName = 'Appear Contact';
        Set<String> empStatCode = new Set<String>{'1','3'};
        soql = 'select firstname, lastname, email, Country__c, middlename,Isselected__c,Name from Contact where Id != null AND ((RecordType.Name = :extRecordTypeName) OR (RecordType.Name =:intRecordTypeName and EmploymentStatusCode__c in :empStatCode))';
        
        if (firstName <> null && !firstName.equals(''))
              soql += ' and firstname LIKE \''+String.escapeSingleQuotes(firstName)+'%\'';
        if (lastName <> null && !lastName.equals(''))
              soql += ' and lastname LIKE \''+String.escapeSingleQuotes(lastName)+'%\'';
        if (email <> null && !email.equals(''))
              soql += ' and email LIKE \''+String.escapeSingleQuotes(email)+'%\'';  
        if (middleName <> null && !middleName.equals(''))
              soql += ' and middleName LIKE \''+String.escapeSingleQuotes(middleName)+'%\'';     
        
        
        if((firstName <> null && !firstName.equals('')) || (lastName <> null && !lastName.equals('')) || (email <> null && !email.equals('')) ||(middleName <> null && !middleName.equals(''))){
            try {
                string soqlFinal = soql + ' limit 25';
                pcontact= Database.query(soqlFinal);
                for(Contact con1: pContact){
                    contactList.add(new cContact(con1));
                }
                authorSearched= true;
             } catch (Exception e) {
                  system.debug('Entered exception block'); 
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! '+e.getMessage() + ' '+ soql));
               }
          }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'Please enter a search text.'));
           }
      }
    //Appear Enhancement R2: Advanced Author search adding authors to aPublication.
      public void remoteSaveAuthorAdd(){
        //Appear Enhancement R3: GPP Type added as a part of Historical Data Fix and error message updated.
        //if(activePub.isPlanning__c && (activePub.GPP_Type__c == null || activePub.RAE__c== null || activePub.SponsorDept_Pick__c == null || activePub.SponsorOrg_Pick__c == null || activePub.Country_pick__c == null )){
        //Appear Enhancement R1:2017 - activePub.GPP_Type__c == null  check removed
        if(activePub.isPlanning__c && (activePub.RAE__c== null || activePub.SponsorDept_Pick__c == null || activePub.SponsorOrg_Pick__c == null || activePub.Country_pick__c == null )){
            String message='Before Adding Authors to publication, please ensure the required fields Sponsoring Org, Sponsoring Amgen Dept, RAE, Country and Publication Classification are updated on the publication as the publication is a GPP Publication';
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,message));
        }else{
        boolean isAuthorSelected =  false;
        boolean isAuthorAdditionAllow = false; //Appear Enhancement R1:2017
        if(!authorSearched){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'Search Author(s) to add.'));
        }else{
            
            string authorsAddedMessage='Authors Added successfully: ';
            integer count=0;
            newAuthorIDList= new List<Id>();
            AppLogModel.LogDebug('PubAuthorModel::remoteSaveAuthorAdd', 'invoke save', pubId);
            for(cContact conWrap: addAuthorListNew){
                if(conWrap.selected == true){
                    isAuthorSelected = true;
                    newAuthorIDList.add(conWrap.con.Id);
                }
            }
            //Appear Enhancement R1:2017 - Author addition permission checked.
            if(activePub.GPP_Type__c != 'CSP'){
              isAuthorAdditionAllow = true;
            }else if((newAuthorIDList.size() + noOfCurrentAuthorsinPub > Integer.valueof(KeyValueSettingsModel.getValue('Max_Author_Count'))) && (ProfileModel.isAppearBusinessAdmin || ProfileModel.isSysAdmin) && pubModel.PubAttachments.checkAddAuthorLimitAttachment() && activePub.GPP_Type__c == 'CSP'){
              isAuthorAdditionAllow = true;
            }else if((newAuthorIDList.size() + noOfCurrentAuthorsinPub <= Integer.valueof(KeyValueSettingsModel.getValue('Max_Author_Count'))) && activePub.GPP_Type__c == 'CSP'){
              isAuthorAdditionAllow = true;
            }else{
              isAuthorAdditionAllow = false;
            }
           
            //Appear Enhancement R1:2017 - Additional criteria added - "isAuthorAdditionAllow"
            if ( isAuthorSelected == true && isAuthorAdditionAllow == true) {
                  List<Contact> authorList = [
                      select id 
                      from Contact
                      where id = :newAuthorIDList
                  ];
                  
                  List<contact_address__c> authorListcontaddress = [
                      select id,contact_name__c
                      from contact_address__c
                      where contact_name__c = :newAuthorIDList and Primary_Address__c =:true
                  ];
                  
                  if ( authorList <> null){
                      Database.saveresult sr;
                      for(Contact conList: authorList){
                          PubAuthor__c newAuthor = new PubAuthor__c();
                          newAuthor.publication__c = PubId;
                          newAuthor.Author__c = conList.Id;
                          newAuthor.isSelected__c = false;
                          for(contact_address__c conAddr : authorListcontaddress){
                              if(conAddr.Contact_Name__c== conList.Id){
                                  newAuthor.Author_Address__c = conAddr.Id;
                              }
                          }
                          sr = database.insert(newAuthor);
                          
                          if(sr.isSuccess()){
                              for(cContact conWrap: addAuthorListNew){
                                  if(conWrap.con.Id==newAuthor.Author__c){
                                      authorsAddedMessage= authorsAddedMessage + conWrap.con.Name + ',';
                                      count++;
                                  }
                              }
                           }
                      }
                      if(count==authorList.size()){
                          authorsAddedMessage = authorsAddedMessage.removeEnd(',');
                          firstName = null;
                          lastName = null;
                          middleName = null;
                          email= null;
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM,authorsAddedMessage));
                      }
                      // Saving Author List as String in Publication Record.
                      updateActivePub(); 
                      activePub.Authors__c = getPublicationAuthorString(activePub.Legacy_Authors__c, activePub.Authors_Not_Found__c);
                      database.update(activePub, true);
                      if(activePub.GPP_Type__c == 'CSP'){
                          noOfCurrentAuthorsinPub = PubAuthorList.size();
                      }
                  } else {
                      AppLogModel.LogError('PubAuthorModel::remoteSaveAuthorAdd', 'Select error for authorList '+ authorList, pubId);                                          
                  }
              } else if(isAuthorSelected == false) { // else if criteria added Appear Enhancement R1:2017
                  AppLogModel.LogError('PubAuthorModel::remoteSaveAuthorAdd', 'AuthorList == null', pubId);   
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'Select Author(s) to add'));             
              }else if(isAuthorAdditionAllow == false){ // else if condition added Appear Enhancement R1:2017
                newAuthorIDList.clear();
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'No more than 10 Authors can be added to this publication.'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'No more than 10 authors can be added to this CSP publication. Please email Contact Support for assistance.'));// Appear Enhamcement backlog R2 - Verbiage Changes 
              }                          
        	}      
        }      
      }
    
    /* Commented for Appear Enhancement R1:2017
      //Appear Enhancement R2: Advanced Author search adding authors to aPublication.
      public void remoteSaveAuthorAdd(){
        //Appear Enhancement R3: GPP Type added as a part of Historical Data Fix and error message updated.
        //activePub.GPP_Type__c == null  check removed - Appear Enhancement R1:2017
        if(activePub.isPlanning__c && (activePub.RAE__c== null || activePub.SponsorDept_Pick__c == null || activePub.SponsorOrg_Pick__c == null || activePub.Country_pick__c == null )){
            String message='Before Adding Authors to publication, please ensure the required fields Sponsoring Org, Sponsoring Amgen Dept, RAE and Country are updated on the publication as the publication is a GPP Publication';
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,message));
        }else{
            
        boolean isAuthorSelected =  false;      
        if(!authorSearched){
            system.debug('pcontact list');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'Search Author(s) to add.'));
        }else{
            string authorsAddedMessage='Authors Added successfully: ';
            integer count=0;
            newAuthorIDList= new List<Id>();
            AppLogModel.LogDebug('PubAuthorModel::remoteSaveAuthorAdd', 'invoke save', pubId);
            
            for(cContact conWrap: addAuthorListNew){
                if(conWrap.selected == true){
                    isAuthorSelected = true;
                    newAuthorIDList.add(conWrap.con.Id);
                }
            }
                        
            if ( isAuthorSelected == true) {
                List<Contact> authorList = [
                    select id 
                    from Contact
                    where id = :newAuthorIDList
                ];
                
                List<contact_address__c> authorListcontaddress = [
                    select id,contact_name__c
                    from contact_address__c
                    where contact_name__c = :newAuthorIDList and Primary_Address__c =:true
                ];
                
                if ( authorList <> null){
                    Database.saveresult sr;
                    for(Contact conList: authorList){
                        PubAuthor__c newAuthor = new PubAuthor__c();
                        newAuthor.publication__c = PubId;
                        newAuthor.Author__c = conList.Id;
                        newAuthor.isSelected__c = false;
                        for(contact_address__c conAddr : authorListcontaddress){
                            if(conAddr.Contact_Name__c== conList.Id){
                                newAuthor.Author_Address__c = conAddr.Id;
                            }
                        }
                        sr = database.insert(newAuthor);
                        
                        if(sr.isSuccess()){
                            for(cContact conWrap: addAuthorListNew){
                                if(conWrap.con.Id==newAuthor.Author__c){
                                    authorsAddedMessage= authorsAddedMessage + conWrap.con.Name + ',';
                                    count++;
                                }
                            }
                         }
                    }
                    if(count==authorList.size()){
                        authorsAddedMessage = authorsAddedMessage.removeEnd(',');
                        firstName = null;
                        lastName = null;
                        middleName = null;
                        email= null;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM,authorsAddedMessage));
                    }
                    // Saving Author List as String in Publication Record.
                    updateActivePub();
                    activePub.Authors__c = getPublicationAuthorString(activePub.Legacy_Authors__c, activePub.Authors_Not_Found__c);
                    database.update(activePub, true);
                    
                } else {
                    AppLogModel.LogError('PubAuthorModel::remoteSaveAuthorAdd', 'Select error for authorList '+ authorList, pubId);
                                        
                }
            } else {
                AppLogModel.LogError('PubAuthorModel::remoteSaveAuthorAdd', 'AuthorList == null', pubId);   
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'Select Author(s) to add'));             
            }  
        }
      
        }
      
      } */
    //Appear Enhancement R2, viewSendEmails is used to fetch the emails send to publication related authors
    public void viewSendEmails(){
        
          
        PublicationId = apexpages.currentpage().getparameters().get('PublicationId');
        ContactId = apexpages.currentpage().getparameters().get('ContactId');
        
        List <PubAuthor__c> pubAuthorList = [select id from PubAuthor__c where publication__c =:PublicationId and author__c=:ContactId
                                             and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
                                            ]; 
             
        List<Id> ids=new List<Id>();
        for(PubAuthor__c pubauth:pubAuthorList){
            ids.add(pubauth.id);
        }
        
        List<PubEmail__c> pubEmailList= [SELECT Author__c,Email_Body__c,Publication_Author__c,Subject__c,Type__c,CreatedBy.Name,CreatedDate 
                        FROM pubEmail__c
                        where Publication_Author__c in :ids];
                        
        for(PubEmail__c pubEmail:pubEmailList) {
            if(pubEmail.Type__c=='Invitation Email'){
                invitationEmail.add(pubEmail);
            }else if(pubEmail.Type__c=='Reminder Email'){
                reminderEmail.add(pubEmail);
            }else if(pubEmail.Type__c=='Final Author Approval Email'){
                finalAuthorApprovalEmail.add(pubEmail);
            }else if(pubEmail.Type__c=='Draft-Share Email'){  // Appear Enhancement R3 Draft Share button
                draftShareEmail.add(pubEmail);
            }
        }                   
        
    }
     
        
    public void DisplayAddresses(){
      AuthorContactAddressId = apexpages.currentpage().getparameters().get('AuthorIdForContact');
      AuthorContactPubAuthorId = apexpages.currentpage().getparameters().get('PubAuthorId');
      ContactAddressList.clear();
      for(contact_address__c d: [Select id, Street_Address__c,Address_Line_2__c, City__c, State_Province__c,Email__c, Primary_Address__c,Country__c,Zip_Postal_Code__c,Contact_Name__c From Contact_Address__c where Contact_Name__c =:AuthorContactAddressId ]){    
            ContactAddressList.add(new ContactAddressWrapperCls(d));
            ConAdd.add(d);
      }
      
    }
    
    public void FeedItems(){
      //PublicationId = apexpages.currentpage().getparameters().get('PublicationId');
      ContactId = apexpages.currentpage().getparameters().get('ContactId');
      ContactUserId = apexpages.currentpage().getparameters().get('CuserId');
      String CreatedByContactName = apexpages.currentpage().getparameters().get('AuthorName');
      System.debug('Hey');
      System.debug(apexpages.currentpage().getparameters().get('PubAuthorId')+'*************');
      pubAuthorRecordId = apexpages.currentpage().getparameters().get('PubAuthorId'); // Appear Enhancement R3 - Comment on behalf - pubauthorId passed to the feed items method
      //Start - Appear Enhancemenr R3-Enable comment on behalf section                      
        DateTime recentDraftShareAttachmentDate = null;  
        ID recentDraftShareAttachmentId = null;          
        DateTime recentSupportingCommentAttachmentDate = null;  
        ID recentSupportingCommentAttachmentId = null;
        boolean checkIfCommentEnabled = false;
        boolean checkIfInviteAccepted = false;
            if(pubAuthorList != null){
                pubAuthor__c pubauthrecord = PubAuthorList[0];
                //Appear Enhancement R4:isLogically Deleted added to the query below
                List<PubAttachmentDetails__c> allAttachments = [select Id,Name,AttachmentType__c,FeedItemIdForComment__c,Attachment_URL__c,Publication_Author__c,CreatedDate,FPR_Cycle__c,Publication__c from PubAttachmentDetails__c where publication__c =:PubId and isLogicallyDeleted__c=false]; 
                if(allAttachments!=null){           
                    for(PubAttachmentDetails__c attachmentRecord : allAttachments) {
                        if((recentDraftShareAttachmentDate == null || attachmentRecord.CreatedDate>recentDraftShareAttachmentDate) && attachmentRecord.AttachmentType__c =='Draft - Share with Authors' && (attachmentRecord.FPR_Cycle__c == pubauthrecord.Publication__r.Current_FPRCycle_Id_Formula__c || pubauthrecord.Publication__r.Current_FPRCycle_Id_Formula__c == null)){      
                            recentDraftShareAttachmentDate=attachmentRecord.CreatedDate;
                            recentDraftShareAttachmentId=attachmentRecord.ID;
                        }
                         //Appear Enhancement R4:The following line has been commented and the line below it added - multiple FPR cycle check removed 
                        //if((recentSupportingCommentAttachmentDate == null || attachmentRecord.CreatedDate>recentSupportingCommentAttachmentDate) && attachmentRecord.Publication_Author__c == pubAuthorRecordId && attachmentRecord.AttachmentType__c =='Substantial Comments' && (attachmentRecord.FPR_Cycle__c == pubauthrecord.Publication__r.Current_FPRCycle_Id_Formula__c || pubauthrecord.Publication__r.Current_FPRCycle_Id_Formula__c == null)){
                        if((recentSupportingCommentAttachmentDate == null || attachmentRecord.CreatedDate>recentSupportingCommentAttachmentDate) && attachmentRecord.Publication_Author__c == pubAuthorRecordId && attachmentRecord.AttachmentType__c =='Substantial Comments'){       
                            recentSupportingCommentAttachmentDate=attachmentRecord.CreatedDate;
                            recentSupportingCommentAttachmentId=attachmentRecord.ID;
                        }               
                     }
                //Appear Enhancement R4:commented - now substantial attachment is not mandatory for each comment 
               /* for(PubAttachmentDetails__c attachmentRecord : allAttachments) {
                    if(attachmentRecord.Id == recentSupportingCommentAttachmentId && attachmentRecord.FeedItemIdForComment__c == null){   
                        for(pubAuthor__c pubAuth:PubAuthorList){
                            if(pubAuth.InviteAcceptedDate__c != null && pubAuth.id == pubAuthorRecordId){
                                checkIfInviteAccepted = true;
                                break;
                        }
                        
                    }
                        if(checkIfInviteAccepted == true){
                            enableOnbehalfCommentSection = true;
                            checkIfCommentEnabled = true;
                            break;
                            
                        }
                   
                    }
                }*/
                //Appear Enhancement R4: below code - start
                for(pubAuthor__c pubAuth:PubAuthorList){
                            if(pubAuth.InviteAcceptedDate__c != null && pubAuth.id == pubAuthorRecordId){
                                checkIfInviteAccepted = true;
                                break;
                        }
                        
                    }
                if(checkIfInviteAccepted == true && recentSupportingCommentAttachmentId != null ){
                            enableOnbehalfCommentSection = true;
                            checkIfCommentEnabled = true;
                                                        
                    }
                 //Appear Enhancement R4: code - end   
                
                if(checkifgppcsp() == false){
                    enableOnbehalfCommentSection = true;
                }
                else if(checkifgppcsp() == true && checkIfCommentEnabled == false)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'If you want to add substantial comments, please make sure<br>  1)   An Invitation Acceptance Date is populated for all authors.<br>  2)  An attachment "Substantial Comments" is uploaded using the "Add Author Attachments" button.'));
                }
         }
        //End - Appear Enhancement R3-Enable comment on behalf section
      User u;
      if (ContactuserId == null) {
        ContactUserId = AppearContactModel.findUserIdForContactId(ContactId);
      }try{
        u = [Select Id,Name from user where ContactId =: ContactId or id =: ContactUserId limit 1];
      }catch ( Exception e){
         System.debug('-- Sorry No User found Related to this ID --');
      }
      if(u!= null){
        CreatedByName = U.name;
        RelFeedItems = PubAuthorModelNoSharing.GetFeedItems(u.id, PubId);
      } else {
        RelFeedItems = null;
        CreatedByName = CreatedByContactName;
      }      
    }       
    
    
    // map of contact Id, count of decimal 
    private transient Map<id, decimal> pFeedItemCountByAuthor; 
    public Map<Id, decimal> FeedItemCountByAuthor{
        get {
            if (pFeedItemCountByAuthor == null){
                pFeedItemCountByAuthor = new Map <id, decimal>();
                  Set <Id> contactIds = new set <id> ();
                  for (pubAuthor__c aPubAuthor : pubAuthorList){
                    contactIds.add(aPubAuthor.author__c); 
                  }
    
                 Map<id, List<FeedItem>> feedMap =  PubAuthorModelNoSharing.GetFeedItemCountByAuthor(contactIds, PubId); 
                for (Id aKey: feedMap.keySet()){
                    pFeedItemCountByAuthor.put(aKey, (feedMap.get(aKey)).size()  ); 
                }
                // set default, in case the contact has no user id setup yet
                for (Id aContactId :contactIds ){
                    if (!feedMap.containsKey(aContactId)){
                        pFeedItemCountByAuthor.put(aContactId, 0); 
                    }
                }
            }
            return pFeedItemCountByAuthor; 

        }
        
    }
    //Appear Enhancement R2: Contact Wrapper implemented for Author search
    public class cContact {
        public Contact con {get; set;}
        public Boolean selected {get; set;}
        public cContact(Contact c) {
            con = c;
            selected = false;
        }
    }
    public class ContactAddressWrapperCls{
        public Boolean isSelected {get;set;}
        public contact_address__c conAddress{get;set;}
        public ContactAddressWrapperCls(contact_address__c cdocument){
            this.conAddress = cdocument;
        }
    }
    
    public void UpdateAuthorIdRecord(){
      DiscId= apexpages.currentpage().getparameters().get('RecId');
      getInviteDisclaimerVersionPage();
    } 
    public class DocumentWrapperCls {
        public Boolean isSelected {get;set;}
        public EmailTemplate Disclaimers {get;set;}
        public DocumentWrapperCls(EmailTemplate cdocument){
            this.Disclaimers = cdocument;
        }
    }
    
    public pagereference getApproveDisclaimerVersionPage(){
        pagereference pageref = new Pagereference((AppearURLModel.IsAuthorComm? '/PubAuthor': '')+ '/servlet/servlet.FileDownload?file=');
        return pageref;
    } 
   
   public string getApproveAttachmentURL(){
        InvAcceptAut.clear();
        if(discid!= null&& discid!=''){
            InvAcceptAut = [select publication__c,publication__r.name,publication__r.Current_Target__c,publication__r.Publication_Title__c,publication__r.Publication_Type__c, isSelected__c, author__r.firstName, author__r.lastName, AuthorCountry__c,
            author__c, author__r.name, author__r.email, ApprovalAcceptedDate__c, ApprovalSentDate__c, InviteAcceptedDate__c, Approval_Rejected_Date__c,ReasonToDeclineApproval__c, 
            InviteSentDate__c, AuthorStatus__c,Rationale__c,Site_Investigator_PI__c,Justification_for_invite__c,Justification_for_Approval__c,
            author__r.MailingStreet, author__r.MailingCity, author__r.MailingState, author__r.MailingPostalCode, author__r.MailingCountry,
            author__r.SponsoringDept__c, author__r.SponsoringDept__r.name, 
            author__r.SponsoringDept__r.OrganizationId__c,
            author__r.SponsoringDept__r.OrganizationId__r.name,Disclaimer_ID__c, Approval_Disclaimer_ID__c, 
            AuthorOrder__c
            from PubAuthor__c
            where id =: DiscId
            and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality 
                           ] ;
            
            Id Cvid =InvAcceptAut[0].Approval_Disclaimer_ID__c;  // ContentVersion id
            PubName = InvAcceptAut[0].publication__r.name;
            PubTitle = InvAcceptAut[0].publication__r.Publication_Title__c;
            PubCurrentTarget = InvAcceptAut[0].publication__r.Current_Target__c;
            PubType = InvAcceptAut[0].publication__r.Publication_Type__c;
            return Cvid; 
            /*            
            try {
                PubAttachmentDetails__c aPubDetail = [select id,Attachment_URL__c from PubAttachmentDetails__c where id = :Cvid limit 1 ]; 
                if (aPubDetail != null){
                    return   aPubDetail.Attachment_URL__c;          
                } else {
                    return ''; 
                }
            }catch (Exception e){
                return ''; 
            }
*/
            
            }else return '';   
    } 
    
    public pagereference getInviteDisclaimerVersionPage(){
        if(discid!= null&& discid!=''){
            try {
                InvSentAut = [select publication__c,publication__r.name,publication__r.Current_Target__c,publication__r.Publication_Title__c,publication__r.Publication_Type__c, isSelected__c, author__r.firstName, author__r.lastName, AuthorCountry__c,
                author__c, author__r.name, author__r.email, ApprovalAcceptedDate__c, ApprovalSentDate__c, InviteAcceptedDate__c, Approval_Rejected_Date__c,ReasonToDeclineApproval__c,
                InviteSentDate__c, AuthorStatus__c,Rationale__c,Site_Investigator_PI__c,Justification_for_invite__c,Justification_for_Approval__c,
                author__r.MailingStreet, author__r.MailingCity, author__r.MailingState, author__r.MailingPostalCode, author__r.MailingCountry,
                author__r.SponsoringDept__c, author__r.SponsoringDept__r.name, 
                author__r.SponsoringDept__r.OrganizationId__c,
                author__r.SponsoringDept__r.OrganizationId__r.name,Disclaimer_ID__c,
                AuthorOrder__c
                from PubAuthor__c
                where id =: DiscId
                and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality              
                             ] ;
                comp=[SELECT id, ProvisionDocumentContent__c, Name FROM ProvisionDocumentVersion__c Where Id =: InvSentAut[0].Disclaimer_ID__c limit 1]; 
            } catch (Exception e){
                comp = null; 
                AppLogModel.LogDebug('PubAuthorModel::getInviteDisclaimerVersionPage', 'Cannot find provisonal doc:', InvSentAut[0].Disclaimer_ID__c);                  
            }
            return null;//Pageref;
        }
        else return null; 
   } 
      
   public pagereference getInviteAcceptDisclaimerVersionPage(){
            
        Document cv = [select id from Document Where Name='Author Invitation Disclaimer' limit 1];
        Id Cvid =cv.id;
        pagereference pageref = new Pagereference((AppearURLModel.IsAuthorComm? '/PubAuthor': '')+ '/apex/AuthorInvitationLandingPage?PubAuthorId='+'a0oZ0000001LSMpIAO');
        return pageref;
   }
    
    Public List<DocumentWrapperCls> ReminderTemplate(){
         return null;
    }
        
    private transient List<PubAuthor__c> pPubAuthorList = null;
    public List<PubAuthor__c> PubAuthorList {
        get {
            if (pPubAuthorList == null) {
                pPubAuthorList = getPubAuthors(this.PubId);
                resetIsSelected();
            }
            return pPubAuthorList;
            
        }  
    }
    
    private void resetIsSelected() {
        for(PubAuthor__c author : pPubAuthorList) {
            author.isSelected__c = false;
        }
    }
    
    
    public boolean canAddDelAuthors {
        get{
            return !(ProfileModel.isAppearReviewers && !isFprSubmitter)  &&  hasEditAccess;
        }
    }
    
    public PubAuthorModel(Id PubId, string tile, string subMenu, Publication__c activePub, boolean isFprSubmitter) {
        this.PubId = PubId;
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;
        this.activePub = activePub;
        this.isFprSubmitter = isFprSubmitter;
        selectedAuthors = new List<PubAuthor__c>();
        NoAuthorForInviteSelected = true;
        delAut = new List<PubAuthor__c>();
        InvSentAut = new List<PubAuthor__c>();
        InvAcceptAut = new List<PubAuthor__c>();
        ApprSentAut = new List<PubAuthor__c>();
        DocList = New list<DocumentWrapperCls>();
        PubAuthorAddress = New pubAuthor__c();
        AuthorContactPubAuthorId ='';
        ReminderList = New list<DocumentWrapperCls>();
        ContactAddressList = New List<ContactAddressWrapperCls>();
        ApprovalList = New list<DocumentWrapperCls>();
        conadd = new list<contact_address__c>();
        selDocumentNames = new List<String>();
        selContactAddressId = new List<String>();
        RelFeedItems = New List<FeedItem>();
        iframesource = new pagereference('/');
        discid='';
        selApprovalTemplNames = new list<string>();
        Justification ='';
        AddtlDetails ='';
        AddtlDetailsReminderUpdate ='';
        tempPubAuthor = new pubAuthor__c(); 
        tempPubAuthor.InviteSentDate__c = date.today() +7 ; //         ByDateTime =date.today();
        tempPubAuthor.ApprovalSentDate__c = date.today()  +7 ; 
        this.InviteDisabled = true;
        this.hasEditAccess = CheckUserAccessModel.CheckEditAccess(PubId);
        this.IsFPROnlyPublication = activePub.IsFprOnly__c;
        this.pubModel = new AppearPubModel(PubId);
        this.VerifyFinalAuthorApprovalAttachmentType = pubModel.PubAttachments.checkFinalAuthorApprovalAttachmentType();
        invitationEmail= new List<pubEmail__c>();// Appear Enhancement R2
        reminderEmail= new List<pubEmail__c>();// Appear Enhancement R2
        finalAuthorApprovalEmail= new List<pubEmail__c>();// Appear Enhancement R2
        this.authorAttachmentButtonDisabled = true;  // Appear Enhancment R3 : Author Supporting Attachment functionality
        //Appear R3 Enhancement Draft Share button
        DraftShareList = New list<DocumentWrapperCls>();
        tempPubAuthor.DraftShareDate__c = date.today()  +7 ;
        this.VerifyDraftShareAttachmentType = pubModel.PubAttachments.checkDraftShareAttachmentType();
        draftShareEmail= new List<pubEmail__c>();
        
        //if(InviteDisabled==false && validateAllAuthorInvitationResponse() ==true && VerifyDraftShareAttachmentType ==true && checkIfGppCsp() == true){
        //Above line commented and below if logic added as part of Appear enhancement R1:2017
        if(InviteDisabled==false && checkAuthorInviteResponseAndRationaleAvailable() && VerifyDraftShareAttachmentType ==true && checkIfGppCsp() == true){
            enableDraftShare=true;
        }
        else if(InviteDisabled == false && VerifyDraftShareAttachmentType == true && checkIfGppCsp() == false){
            enableDraftShare =true;
        }
        else{
            enableDraftShare=false;
        } 
        //Appear R3 Enhancement Draft Share button
        //Appear R3 Enhancement Disable Request Approval Button
        if(InviteDisabled==false && publicationFPRCompleted() == true && checkIfGppCsp() == true){
            enableRequestApproval=true;         
        }
        else if(InviteDisabled == false && checkIfGppCsp() == false){
            enableRequestApproval =true;
        }
        else{
            enableRequestApproval=false;  
        }
        //Appear R3 Enhancement Disable Request Approval Button
        enableOnbehalfCommentSection = false;//Appear Enhancement R3-Comment on behalf disable
        
        // Added draft share reminder template in the or section of the below query as part of Appear Enhancement R3       
        for(EmailTemplate d: [select id,name,Isactive,Folder.Name from EmailTemplate Where IsActive = true And (Folder.Name =: 'Author Invitation Templates' or Folder.Name =: 'Author Approval Templates' or Folder.Name =: 'Reminder Templates' or Folder.Name =: 'Draft Share Reminder Templates')]){    
            if(d.folder.name == 'Author Invitation Templates')
                DocList.add(new DocumentWrapperCls(d)); 
            if(d.folder.name == 'Author Approval Templates')
                ApprovalList.add(new DocumentWrapperCls(d));
            if(d.folder.name == 'Reminder Templates')
                ReminderList.add(new DocumentWrapperCls(d));
            if(d.folder.name == 'Draft Share Reminder Templates') // Appear Enhancement R3 - Draft Share button
                DraftShareList.add(new DocumentWrapperCls(d)); 
        }
        
        //Appear Enhancement R1:2017 - ADD Author button visibility  -- enableAddAuthorButton
        if((PubAuthorList.size() < Integer.valueof(KeyValueSettingsModel.getValue('Max_Author_Count')) && activePub.GPP_Type__c =='CSP') || ((ProfileModel.isAppearBusinessAdmin || ProfileModel.isSysAdmin) && pubModel.PubAttachments.checkAddAuthorLimitAttachment() && activePub.GPP_Type__c =='CSP')){
            enableAddAuthorButton = false;
        }else if(activePub.GPP_Type__c !='CSP'){
            enableAddAuthorButton = false;
        }else{
            enableAddAuthorButton=true;
        }
    	noOfCurrentAuthorsinPub = 0; // Appear Enhancement R1:2017- Check no of Authors in Pub
    }
    Public void UpdateAddtlDetailsForReminder(){
        AddtlDetailsReminderUpdate = apexpages.currentpage().getparameters().get('Details');
        
        for(PubAuthor__c author : delAut) {
            if (author.isSelected__c) {
                author.Addl_Details_for_Reminder__c = AddtlDetailsReminderUpdate;
            }
        }
        update delAut;
    }
    
    
    public PageReference cancel() {
        return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
    }   
    
    
    public string NewAuthorId {get;set;}
    
    
    
    public PageReference saveAuthorList() {
        //Appear Enhancement R2: Code Implemented for restricting BA profile to update date Fields to Null.
         List<PubAuthor__c> oldPubAuthorList = [
            select publication__c, isSelected__c, author__c, ApprovalAcceptedDate__c,InviteAcceptedDate__c  
            from PubAuthor__c
            where Publication__c = :PubId
            and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality 
         ];
           //system.debug('----->111'+oldPubAuthorList);
         Integer flag=0;
         
         PageReference p = apexpages.Currentpage();
        
         for(PubAuthor__c oldPubAuthList:oldPubAuthorList){
            for(pubAuthor__c pubAuthList:PubAuthorList){
                if(oldPubAuthList.id==pubAuthList.id){
                    if(oldPubAuthList.InviteAcceptedDate__c!=null && pubAuthList.InviteAcceptedDate__c==null){
                        flag=1;
                        break;
                    }
                    if(oldPubAuthList.ApprovalAcceptedDate__c!=null&&pubAuthList.ApprovalAcceptedDate__c==null){
                        flag=1;
                        break;
                    }
                }
            }
         }
        
        if(flag==1){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Date fields cannot be Blank'));
            pPubAuthorList = null;
            return p;
        }        
        else{
            database.update(PubAuthorList, true);
            pPubAuthorList = null;  //force refresh of new sort order
    
            //save the current list of authors as a string on the publication record
            activePub.Authors__c = getPublicationAuthorString(activePub.Legacy_Authors__c, activePub.Authors_Not_Found__c);
            //database.update(activePub, true); //Appear Enhancement R2: Historical Publication fix for Validation Rules
            try{
                database.update(activePub, true);
            }catch (System.DmlException err) {
                ApexPages.addMessages(err);
                return null;
            }
            
            AppLogModel.flushLogs();
    
            //return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)); 
            return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
        } 
    }
    

    public PageReference remoteSaveAuthor() {
        AppLogModel.LogDebug('PubAuthorModel::remoteSaveAuthor', 'invoke save', pubId);
        if ( NewAuthorId <> null) {
            List<Contact> authorList = [
                select id 
                from Contact
                where id = :NewAuthorId
            ];
            
            List<contact_address__c> authorListcontaddress = [
                select id 
                from contact_address__c
                where contact_name__c = :NewAuthorId and Primary_Address__c =:true
            ];
            
            
            if ( authorList.size() == 1){
                PubAuthor__c newAuthor = new PubAuthor__c();
                newAuthor.publication__c = PubId;
                newAuthor.Author__c = NewAuthorId;
                newAuthor.isSelected__c = false;
                if (authorListcontaddress.size() > 0) {
                    newAuthor.Author_Address__c = authorListcontaddress[0].Id;
                }
                
                
                insert newAuthor;
                pPubAuthorList = null;
                
                //update activePub to avoid overwriting the US Based Author flag
                updateActivePub();
            } else {
                AppLogModel.LogError('PubAuthorModel::remoteSaveAuthor', 'Select error for newAuthorId '+ NewAuthorId, pubId);
            }
        } else {
            AppLogModel.LogError('PubAuthorModel::remoteSaveAuthor', 'NewAuthorId == null', pubId);
        }
        
        //save the current list of authors as a string on the publication record
        activePub.Authors__c = getPublicationAuthorString(activePub.Legacy_Authors__c, activePub.Authors_Not_Found__c);
        database.update(activePub, true);
        
        AppLogModel.flushLogs();
        return null; 
    }
    
    
    public PageReference save() {
        AppLogModel.LogDebug('PubAuthorModel::save', 'invoke save', pubId);
        if ( NewAuthorId <> null) {
            List<Contact> authorList = [
                select id 
                from Contact
                where id = :NewAuthorId
            ];
            
            List<contact_address__c> authorListcontaddress = [
                select id 
                from contact_address__c
                where contact_name__c = :NewAuthorId and Primary_Address__c =:true
            ];
            
            
            if ( authorList.size() == 1){
                PubAuthor__c newAuthor = new PubAuthor__c();
                newAuthor.publication__c = PubId;
                newAuthor.Author__c = NewAuthorId;
                newAuthor.isSelected__c = false;
                if (authorListcontaddress.size() > 0) {
                    newAuthor.Author_Address__c = authorListcontaddress[0].Id;
                }
                // newAuthor.AuthorStatus__c = 'Pending Invite Delivery'; // set the default status being pending invite
                
                
                insert newAuthor;
                
                pPubAuthorList = null;
                
                //update activePub to avoid overwriting the US Based Author flag
                updateActivePub();
            } else {
                AppLogModel.LogError('PubAuthorModel::save', 'Select error for newAuthorId '+ NewAuthorId, pubId);
            }
        } else {
            AppLogModel.LogError('PubAuthorModel::save', 'NewAuthorId == null', pubId);
        }
        
        //save the current list of authors as a string on the publication record
        activePub.Authors__c = getPublicationAuthorString(activePub.Legacy_Authors__c, activePub.Authors_Not_Found__c);
        //Appear Enhancement R3: Try catch added as a part of Historical Data Fix
        try{
          database.update(activePub, true);
        }catch(DMLException ae){
          ApexPages.addMessages(ae);
          return null;
        }
                
        
        AppLogModel.flushLogs();
        return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
    }
    
    private void updateActivePub() {
        activePub = New AppearPubModel(PubId).PubRecord;
    }
    
    public pagereference UpdateAuthorRecord(){
        integer i =0;
        for(pubAuthor__c pa:InvSentAut){
            if(InvSentAut[0].InviteSentDate__c!= null && InvSentAut[0].InviteAcceptedDate__c == null){
                if(InvSentAut[0].Justification_for_invite__c != Null && InvSentAut[0].Justification_for_invite__c != ''){
                    pa.InviteAcceptedDate__c= system.today();
                    pa.Justification_for_invite__c = InvSentAut[0].Justification_for_invite__c ;
                    pa.AuthorStatus__c ='Publication Review by Authors';
                    pa.On_behalf_of_for_Invite__c = UserInfo.getUserId();
                }else {
                    i= i+1;
                }
            }else if(InvSentAut[0].InviteSentDate__c!= null && InvSentAut[0].InviteAcceptedDate__c != null && InvSentAut[0].ApprovalSentDate__c != Null && InvSentAut[0].ApprovalAcceptedDate__c == Null){
                if(InvSentAut[0].Justification_for_Approval__c!= Null && InvSentAut[0].Justification_for_Approval__c!= ''){    
                    pa.ApprovalAcceptedDate__c = system.today();
                    pa.Justification_for_Approval__c = InvSentAut[0].Justification_for_Approval__c ;
                    pa.AuthorStatus__c ='Completed Author Approval';
                    pa.On_behalf_of_for_Approval__c =UserInfo.getUserId();
                }
                else{i=i+1;
                }
            }
        }
        if(i==0){
            update InvSentAut;
            InvSentAut.clear();
            return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Justification is Required.'));
            return null;  
        }
   }
   
   public pagereference UpdateAuthorRecordReject(){
        if(InvSentAut[0].Justification_for_Approval__c != Null && InvSentAut[0].Justification_for_Approval__c != ''){
            for(pubAuthor__c pa:InvSentAut){
                pa.Justification_for_Approval__c = InvSentAut[0].Justification_for_Approval__c;
                pa.AuthorStatus__c ='Approval Rejected';
                pa.Approval_Rejected_Date__c = system.today();
                pa.On_behalf_of_for_Approval__c = UserInfo.getUserId();
            }
            update InvSentAut;
            InvSentAut.clear();
            return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Justification is Required.'));
            return null;  
        }
   }
    
    
    public void InviteLetterDetailsUpdate(){
        
        AddtlDetails = apexpages.currentpage().getparameters().get('InviteDetails');
        string datevalue = apexpages.currentpage().getparameters().get('InviteDatevalue');
        list<String> dateForParsing = New List<string>();

        if(datevalue!=null && datevalue != ''){
            dateForParsing = datevalue.split('/', 5);
            tempPubAuthor.InviteSentDate__c = date.newInstance(Integer.valueOf(dateForParsing[2]), Integer.valueOf(dateForParsing[0]), Integer.valueOf(dateForParsing[1]));             
        }

        for(PubAuthor__c author : delAut) {
            if (author.isSelected__c) {
                author.Additional_Details__c = AddtlDetails;
                author.By_Date_Time__c = datetime.newInstance(tempPubAuthor.InviteSentDate__c.year(), tempPubAuthor.InviteSentDate__c.month(),tempPubAuthor.InviteSentDate__c.day());  // ByDateTime;
            }
        }
        update delAut;  // save details to support preivew 
        
    }
        
    public void ApprovalLetterDetailsUpdate(){
        
        AddtlDetails = apexpages.currentpage().getparameters().get('ApproveDetails');
        string datevalue = apexpages.currentpage().getparameters().get('ApproveDatevalue');
        list<String> dateForParsing = New List<string>();
        
        if(datevalue!=null && datevalue != ''){
            dateForParsing = datevalue.split('/', 5);
            tempPubAuthor.ApprovalSentDate__c = date.newInstance(Integer.valueOf(dateForParsing[2]), Integer.valueOf(dateForParsing[0]), Integer.valueOf(dateForParsing[1])); 
        }

        for(PubAuthor__c author : delAut) {
            if (author.isSelected__c) {
                author.Additional_Details_For_Approval__c = AddtlDetails;
                author.Please_respond_by_For_Approval__c =  datetime.newInstance(tempPubAuthor.ApprovalSentDate__c.year(), tempPubAuthor.ApprovalSentDate__c.month(),tempPubAuthor.ApprovalSentDate__c.day());  // ByDateTime; 
            }
        }
        update delAut;  // save details to support preivew 
        
    }
    
    
    // 3 parts for the Pub Author string
    // 1 - the Pub Authors Summary
    // 2 - the Legacy Authors
    // 3 - the Not Found Authors
    public string getPublicationAuthorString(string LegacyAuthors, string AuthorNotFound) {
        string result = '';
        
        //part 1
        for(PubAuthor__c author : PubAuthorList) {
            if (result <> '') {
                result += ', ';
            }
            
            string name = '';
            if ( author.author__r.lastName <> null &&  author.author__r.lastName <>'' ){
                name += author.author__r.lastName.trim() + ' ';
            }
            if ( author.author__r.firstName <> null &&  author.author__r.firstName <>'' ){
                name += author.author__r.firstName.substring(0,1);
            }

            result += name;
        }   
        
        //part 2
        if ( LegacyAuthors <> null ) {
            if ( result.length() > 0 ) {
                result += ', '+LegacyAuthors;
            } else {
                result = LegacyAuthors;
            }
        }
        
        //part 3
        if ( AuthorNotFound <> null ) {
            if ( result.length() > 0 ) {
                result += ', '+AuthorNotFound;
            } else {
                result = AuthorNotFound;
            }
        }
        return result;
    }
    
    
    public void SavePrimaryContactAddress(){
        List<PubAuthor__c> PubAuthorAddress = [Select Author_address__c from pubAuthor__c where id =: AuthorContactPubAuthorId
                                              and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
                                              ];
        
        selContactAddressId.clear();
        hasSelDoc = false;
        for(ContactAddressWrapperCls cWrapper : ContactAddressList){
            if(cWrapper.isSelected){
                hasSelDoc = true;
                selContactAddressId.add(cWrapper.conAddress.Id);
            }
        }
        
        if(selContactAddressId.size() > 0) {
            PubAuthorAddress[0].Author_address__c = selContactAddressId.get(0);
            update PubAuthorAddress;
        }
        conadd.clear();
     }
    
    
    public PageReference displaySelectedDoc(){
          AppearPubModel appPubModel = new AppearPubModel(Pubid); //Appear Enhancement R3: Auto Populate Invite Sent Date
          List<Id> PubAuthorTemplId = New List<Id>();
          List<id> PubAuthorId = New List<Id>();
          selDocumentNames.clear();
          hasSelDoc = false;
          Integer i =0;
          for(DocumentWrapperCls cWrapper : DocList){
               if(cWrapper.isSelected){
                    hasSelDoc = true;
                    selDocumentNames.add(cWrapper.disclaimers.Id);
               }
          }
          if(selDocumentNames.size()>1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You can select only one Email Template'));
            return null; 
          } else if (selDocumentNames.size()==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Email Template'));
            return null; 
          } else if (AddtlDetails.length() > 4000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Additional Data details have exceeding the character limit of 4000. Please correct the data to proceed.'));
            return null; 
          }
          else{
            for(PubAuthor__c author : delAut) {
                if (author.isSelected__c) {
                    i=i+1;
                    PubAuthorId.add(author.Id);
                    PubAuthorTemplId.add(selDocumentNames.get(0));
                    author.Additional_Details__c = AddtlDetails;
                    author.By_Date_Time__c = datetime.newInstance(tempPubAuthor.InviteSentDate__c.year(), tempPubAuthor.InviteSentDate__c.month(),tempPubAuthor.InviteSentDate__c.day());  // ByDateTime;

                    //author.phone_number__c = Phone;
                    
                    if (author.author__r.email == null || author.author__r.email == ''){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'One or more of the selected Author(s) do not have an email. Please correct the information to proceed.'));
                        return null;
                    }
                }
            }
            update delAut;
            Email_16_AuthorInvitation.Email_16_AuthorInvitationBatch(PubAuthorId,PubAuthorTemplId); 
            appPubModel.PubStatus.insertAgreementSent(); //Appear Enhancement R3: Auto Populate Invite Sent Date
            pPubAuthorList = null;
            delAut.clear();
          }
           return null;   // in order to show pagemessage from email. 
            // return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
        }
        
        public PageReference displayReminderDoc(){
              integer i =0;
              List<Id> PubAuthorTemplId = New List<Id>();
              List<id> PubAuthorId = New List<Id>();
              selDocumentNames.clear();
              hasSelDoc = false;
              for(DocumentWrapperCls cWrapper : ReminderList){
                   if(cWrapper.isSelected){
                        hasSelDoc = true;
                        selDocumentNames.add(cWrapper.disclaimers.Id);
                   }
              }
              if(selDocumentNames.size()>1){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You can select only one Email Template'));
                return null; 
              } else if (selDocumentNames.size()==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Email Template'));
                return null; 
              }
              else{
                for(PubAuthor__c author : delAut) {
                    if (author.isSelected__c) {
                        PubAuthorId.add(author.Id);
                        PubAuthorTemplId.add(selDocumentNames.get(0));

                        if (author.author__r.email == null || author.author__r.email == ''){
                             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'One or more of the selected Author(s) do not have an email. Please correct the information to proceed.'));
                            return null;
                        }
                    }
                }
                
                update delAut;
                Email_18_AuthorReminder.Email_18_AuthorReminderBatch(PubAuthorId,PubAuthorTemplId); 
                AddtlDetailsReminderUpdate =''; 
                pPubAuthorList = null;
                delAut.clear();
              }
                return null;  // in order to show pagemessage from email. 
                // return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
            //}
        }
    
        Public void AuthorsSelected(){
            ReminderType = '';
            delAut.clear();
            integer AuthorSelected = 0;
            Integer InviteRem = 0;
            Integer ApprovalRem = 0;
            List<string> authorNameList= new List<String>(); // Appear Enhancment R3 : Author Supporting Attachment functionality
            //List<String> pubNameList= new List<String>(); // Appear Enhancement 2017 Backlog R2
            for(PubAuthor__c author : pPubAuthorList) {
                if (author.isSelected__c) {
                    AuthorSelected = AuthorSelected + 1;
                    delAut.add(author);
                    authorNameList.add(author.author__r.name); // Appear Enhancment R3 : Author Supporting Attachment functionality
                    //pubNameList.add(author.Publication__r.name);// Appear Enhancement 2017 Backlog R2
                    if(author.InviteAcceptedDate__c == Null && author.InviteSentDate__c != Null){
                        ReminderType='Invite' ;  
                        InviteRem = InviteRem + 1;   
                    }
                    if(author.ApprovalAcceptedDate__c == Null && author.ApprovalSentDate__c != Null){
                        ReminderType='Approval'; 
                        ApprovalRem = ApprovalRem + 1;
                    }
                }
            }
            
            // Appear Enhancment R3 : Start - Author Supporting Attachment functionality
            if(AuthorSelected == 1){
                this.authorAttachmentButtonDisabled= false;
                this.attachmentAuthorName=authorNameList[0];
                /*// Appear Enhancement 2017 Backlog R2
                if(pubNameList.size()>0){
                    this.attachmentPubId=pubNameList[0];
                }*/
                
                /*Appear Enhancement 2017 Backlog R3 : Issue id 106 :: STARTS*/
                this.pubAuthordataforAtt = delAut[0];
                this.authorFirstName = delAut[0].author__r.FirstName;
                this.authorLastName = delAut[0].author__r.LastNAme;
                this.authorPubID = delAut[0].Publication__r.name;
                if(delAut[0].InviteSentDate__c != null && delAut[0].InviteAcceptedDate__c == null && delAut[0].Invite_Rejected_Date__c == null){//&& checkIfGppCsp() == true
                    this.checkAuthInvSentDate = true;
                }
                else{
                    this.checkAuthInvSentDate = false;
                }
                if(delAut[0].InviteSentDate__c != null && delAut[0].InviteAcceptedDate__c != null 
                   	&& delAut[0].ApprovalSentDate__c != null && delAut[0].ApprovalAcceptedDate__c == null && delAut[0].Approval_Rejected_Date__c == null){//&& checkIfGppCsp() == true
                    this.checkAuthAppSentDate = true;
                    this.newAuthorAppDiscID = delAut[0].Approval_Disclaimer_ID__c;    
                    PubName = delAut[0].Publication__r.Name;
                    PubTitle = delAut[0].Publication__r.Publication_Title__c;    
                }
                else{
                    this.checkAuthAppSentDate = false;
                }
                /*Appear Enhancement 2017 Backlog R3 : Issue id 106 :: ENDS*/
                
            }else{
                this.authorAttachmentButtonDisabled= true;
            }
            // Appear Enhancment R3 : End - Author Supporting Attachment functionality
            if(AuthorSelected>0){
                this.InviteDisabled = false;
            }
            else{
                this.InviteDisabled = true;
            }
            /***if(((InviteRem >0 && ApprovalRem == 0) || (InviteRem == 0 && ApprovalRem >0)) && ReminderType=='Invite'|| ReminderType =='Approval'){
                
                 = ReminderTemplate();
                BothSelected = false;
            }
            else if((InviteRem >0 && ApprovalRem >0) ){
                BothSelected = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot select Authors for sending Invite and Ipproval reminder at the same time'));    
            }
            else{***/
                //ReminderList = ReminderTemplate();            //}
             
           //Start- Appear Enhancement R3 Enable-Disable Draft-Share button       
            //if(InviteDisabled==false && pubModel.PubAttachments.checkDraftShareAttachmentType()==true && validateAllAuthorInvitationResponse()==true && checkIfGppCsp() ==true){
            // Above line commented and below if logic added as part of Appear enhancement R1:2017
            if(InviteDisabled==false && pubModel.PubAttachments.checkSharedDraftAdditionalAttchmnt() && pubModel.PubAttachments.checkDraftShareAttachmentType()==true && checkAuthorInviteResponseAndRationaleAvailable() && checkIfGppCsp() ==true){
               enableDraftShare=true; 
            }
            else if(InviteDisabled == false && VerifyDraftShareAttachmentType == true && checkIfGppCsp() == false){
                enableDraftShare =true;
             }
            else{
                enableDraftShare=false;
            } 
            //End - Appear Enhancement R3 Enable-Disable Draft-Share button
            
            //Appear Enhancement R3 Enable-Disable Request Approval button
            if(InviteDisabled==false && publicationFPRCompleted() == true && checkIfGppCsp() == true){
               enableRequestApproval=true; 
            }
            else if(InviteDisabled == false && checkIfGppCsp() == false){
                enableRequestApproval =true;
            }
            else{
                enableRequestApproval=false;
            } 
            //Appear Enhancement R3 Enable-Disable Request Approval button
        }
    public Boolean NoAuthorForInviteSelected{get;set;}
    public void ValidateInvitationAuthors(){
       integer AuthorSelected = 0;
       for(PubAuthor__c author : delAut) {
            if (author.isSelected__c) {
                AuthorSelected=AuthorSelected+1;
            }
        }
      }
    
       
    public PageReference displaySelectedApprovalTemplate(){

          List<Id> PubAuthorTemplId = New List<Id>();
          List<id> PubAuthorId = New List<Id>();
          selApprovalTemplNames.clear();
          integer i =0;
          hasSelDoc = false;
          for(DocumentWrapperCls cWrapper : ApprovalList){
               if(cWrapper.isSelected){
                    hasSelDoc = true;
                    selApprovalTemplNames.add(cWrapper.disclaimers.Id);
               }
          }
          if(selApprovalTemplNames.size()>1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You can select only one Email Template'));
            return null;
          } else if (selApprovalTemplNames.size()==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Email Template'));
            return null;
          } else if (AddtlDetails.length() > 4000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Additional Data details have exceeding the character limit of 4000. Please correct the data to proceed.'));
            return null; 
          }else {
            for(PubAuthor__c author : delAut) {
                if (author.isSelected__c) {
                    i=i+1;
                    PubAuthorId.add(author.Id);
                    PubAuthorTemplId.add(selApprovalTemplNames.get(0));
                    //author.Phone_Number_For_Approval__c = ;
                    author.Please_respond_by_For_Approval__c =  datetime.newInstance(tempPubAuthor.ApprovalSentDate__c.year(), tempPubAuthor.ApprovalSentDate__c.month(),tempPubAuthor.ApprovalSentDate__c.day());  // ByDateTime; 
                    author.Additional_Details_For_Approval__c = AddtlDetails;
                    //Appear R4.0 and Defect 46:  
                    author.ApprovalSentDate__c = date.today();
                    author.ApprovalAcceptedDate__c = null;
                    author.Approval_Rejected_Date__c = null;
                    author.ReasonToDeclineApproval__c = null;
                    author.Approval_Disclaimer_ID__c = null;
                    author.AuthorStatus__c = 'Pending Author Approval';
                    
                    
                    if (author.author__r.email == null || author.author__r.email == ''){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'One or more of the selected Author(s) do not have an email. Please correct the information to proceed.'));
                        return null;
                    }
                    
                    if(author.InviteAcceptedDate__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'One or more of the selected Author(s) do not have an "Invite Accepted Date" to proceed with Request for an Author Approval. Please populate the "Invite Accepted Date" for the Author(s) to proceed.'));
                        return null;
                    }
                    
                    if(!VerifyFinalAuthorApprovalAttachmentType) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Attachment Type of "Final Attachment for Author Approval" is Required.'));
                        return null;
                    }
                }
            }
                update delAut; 
                Email_17_AuthorApproval.Email_17_AuthorApprovalBatch(PubAuthorId,PubAuthorTemplId); 
                pPubAuthorList = null;
                delAut.clear();
          }
          return null;   // in order to show pagemessage from email. 
          // return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
        }

        public PageReference deleteSelected() {
            List<PubAuthor__c> delAuthors = new List<PubAuthor__c>();
            for(PubAuthor__c author : pPubAuthorList) {
            if (author.isSelected__c) {
                delAuthors.add(author);
            }
        }
        Database.delete(delAuthors,true);
        pPubAuthorList = null;
        //update activePub to avoid overwriting the US Based Author flag
        updateActivePub();
                
        //refresh Author String after delete
        activePub.Authors__c = getPublicationAuthorString(activePub.Legacy_Authors__c, activePub.Authors_Not_Found__c);
        database.update(activePub, true);
        
        return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
    }
    
    //==============================================================
    // Start - Appear Enhancement R3
    //==============================================================
 public final static string RemoveAuthorAttachmentType = 'Approval to Remove Author';
   // Start - Soft Deleting Author  
   public PageReference removeAuthor() {
   
    List < PubAuthor__c > removeAuth = new List < PubAuthor__c > ();
    List <String> tempAuthor = new List<String>();
    Boolean chk = false;
        
    for (PubAuthor__c a: pPubAuthorList){
     if(a.IsSelected__c){ 
              tempAuthor.add(a.Id);
           }
         }
           
     if (tempAuthor.isEmpty() ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select an author.' ));
            return null;
        }  
     else if (tempAuthor.size() > 1 ){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select one author at a time.' ));
             return null; 
        } 
                    
     else if (tempAuthor.size() == 1 ){
          List<PubAttachmentDetails__c> removeList= PubAttachmentModel.getAllPubAttachmentList(pubId);                                   
         
          for (PubAuthor__c a: pPubAuthorList) {
               if(a.IsSelected__c && a.id == tempAuthor[0]){
                if(checkIfGppCsp() == true && removeList.isEmpty() == false ){
                 for(PubAttachmentDetails__c pAtt: removeList ) {  
                 //Appear Enhancement 2017 Backlog R2 - Issue Id 11 - Supporting attachment required only when invitation send date populated
                  /*if( pAtt.Publication_Author__c == tempAuthor[0]  && pAtt.AttachmentType__c == RemoveAuthorAttachmentType)    {
                  chk = true;     
                  }*/
                  if(a.InviteSentDate__c == null){
                  		chk = true;     
                  }else if(a.InviteSentDate__c != null && pAtt.Publication_Author__c == tempAuthor[0]  && pAtt.AttachmentType__c == RemoveAuthorAttachmentType)    {// Backlog R2 Req.11 - Appear Enhancement backlog R2 2017 - elseif condition updated
                  		chk = true;     
                  }   
                  }//for removeList ends
                 }else if(checkIfGppCsp() && a.InviteSentDate__c == null){
                    	chk = true;     
                 }else if (checkIfGppCsp() == false){
                  System.Debug('PubAuthorModel :: removeAuthor :: @@@check2@@@' + checkIfGppCsp() + removeList.size()+ removeList.isEmpty());   
                  chk = true; 
                  } 
                  
                 }
                }
               
            if (chk == true) {
                
                for (PubAuthor__c a: pPubAuthorList) {
                if(a.IsSelected__c && a.id == tempAuthor[0] ){
                  a.isLogicallyDeleted__c = true;
                  a.isSelected__c = false;
                  removeAuth.add(a);           
                  } 
                  }   
                  try {             
                  Database.Update(removeAuth,true);
                  pPubAuthorList = null;          
                  updateActivePub(); 
                  activePub.Authors__c = getPublicationAuthorString(activePub.Legacy_Authors__c, activePub.Authors_Not_Found__c);
                  database.update(activePub, true);             
                  }
                  catch (DmlException e) {
                    ApexPages.addMessages(e);
                    return null;
                  }         
                  //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'"'+ remvName+'"  '+ 'has been Deleted'));
                  return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
                  //return null;
             }    
           
            else   {
              System.Debug('PubAuthorModel :: removeAuthor :: @@@check3@@@' + checkIfGppCsp() + removeList.size() + removeList.isEmpty());  
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add attachment type "Approval to Remove Author" using the "Add Author Attachments" button.' ));
              return null;
             } 
                
      }//else tempAuthor.size()==1 ends
      return null ;
    }
    
   // End - Soft Deleting Author   
    
    // Start - New Draft Share button and validation Logic 
    public List<DocumentWrapperCls> DraftShareList {get;set;} // Store draft share email template
    public boolean VerifyDraftShareAttachmentType {get;set;} // used for draft share validation 
    public List<PubEmail__c> draftShareEmail{get;set;}
    public boolean enableDraftShare {get; set;} 
        
    //Method checks if current publication is GPP CSP
    boolean checkIfGppCsp(){
        boolean retval=false;
        if(PubAuthorList.size() > 0){
            pubAuthor__c pubauthorrecord = PubAuthorList[0];
            if(pubauthorrecord.Publication__r.GPP_Type__c == 'CSP'){ // removed  && pubauthorrecord.Publication__r.isPlanning__c == true as part of Appear Enhancement R1:2017
                retval=true;
            }
        }
        return retval;
    }
    
    // Method returns true if all authors have responded to Invitation
    /* Commented below as part of Appear Enhancment R1:2017
    public boolean validateAllAuthorInvitationResponse(){
        boolean invitationAcceptDateNull=false;
        for(pubAuthor__c pubAuthList:PubAuthorList){
            if(pubAuthList.InviteAcceptedDate__c==null){
                invitationAcceptDateNull=true;
                break;
            }
            
        }
        if(invitationAcceptDateNull==true){
            return false;
        }
        else
            return true;
    }
    */
    //Appear Enhancement R1:2017 - Code added as a part of All Authors Invitation and Rationale field check
    public boolean checkAuthorInviteResponseAndRationaleAvailable(){
        Integer i = 0;
        for(pubAuthor__c pa:PubAuthorList){
            if((pa.InviteAcceptedDate__c != null) && (pa.Rationale__c != null)){
                i++;
            }
        }
        if(PubAuthorList.size()== i){
            return true;
        }
        else{
            return false;
        }
        //return false;            
    }
    //Method to display the draft-share email preview and trigger draft share mail
        public PageReference displayDraftShareDoc(){
          
          List<Id> PubAuthorTemplId = New List<Id>();
          List<id> PubAuthorId = New List<Id>();
          selDocumentNames.clear();
          hasSelDoc = false;
          Integer i =0;
          for(DocumentWrapperCls cWrapper : DraftShareList){
               if(cWrapper.isSelected){
                    hasSelDoc = true;
                    selDocumentNames.add(cWrapper.disclaimers.Id);
               }
          }
          if(selDocumentNames.size()>1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You can select only one Email Template'));
            return null; 
          } else if (selDocumentNames.size()==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Email Template'));
            return null; 
          } else if (AddtlDetails.length() > 4000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Additional Data details have exceeding the character limit of 4000. Please correct the data to proceed.'));
            return null; 
          }
          else{
            for(PubAuthor__c author : delAut) {
                if (author.isSelected__c) {
                    i=i+1;
                    PubAuthorId.add(author.Id);
                    PubAuthorTemplId.add(selDocumentNames.get(0));
                    author.Additional_Details_For_Draft_Share__c = AddtlDetails;
                    author.Please_respond_by_For_Draft_Share__c  = datetime.newInstance(tempPubAuthor.DraftShareDate__c.year(), tempPubAuthor.DraftShareDate__c.month(),tempPubAuthor.DraftShareDate__c.day());  // ByDateTime;

                    //author.phone_number__c = Phone;
                    
                    if (author.author__r.email == null || author.author__r.email == ''){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'One or more of the selected Author(s) do not have an email. Please correct the information to proceed.'));
                        return null;
                    }
                }
            }
            update delAut;
            Email_19_DraftShare.Email_19_DraftShareBatch(PubAuthorId,PubAuthorTemplId); 
            pPubAuthorList = null;
            delAut.clear();
          }
           return null;   // in order to show pagemessage from email. 
            // return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
        }
    
        //Draft-Share on button click Additional Details Method
        public void DraftShareLetterDetailsUpdate(){
        
        AddtlDetails = apexpages.currentpage().getparameters().get('DraftDetails');
        string datevalue = apexpages.currentpage().getparameters().get('DraftDatevalue');
        list<String> dateForParsing = New List<string>();

        if(datevalue!=null && datevalue != ''){
            dateForParsing = datevalue.split('/', 5);
            tempPubAuthor.DraftShareDate__c = date.newInstance(Integer.valueOf(dateForParsing[2]), Integer.valueOf(dateForParsing[0]), Integer.valueOf(dateForParsing[1]));             
        }

        for(PubAuthor__c author : delAut) {
            if (author.isSelected__c) {
                author.Additional_Details_For_Draft_Share__c = AddtlDetails;
                author.Please_respond_by_For_Draft_Share__c  = datetime.newInstance(tempPubAuthor.DraftShareDate__c.year(), tempPubAuthor.DraftShareDate__c.month(),tempPubAuthor.DraftShareDate__c.day());  // ByDateTime;
            }
        }
        update delAut;  // save details to support preivew         
        }
    
    
    // End - New Draft Share button and validation Logic 
    
    // Start - Supporting attachment for Author - IE/CrossBrowser implementation
    
     
    public boolean authorAttachmentButtonDisabled{get;set;}
    public string attachmentAuthorName{get;set;}
    
    public PageReference authorNotSelected(){
        boolean hasError = false; 
        //attachmentAuthorName= 'palash';
        if(authorAttachmentButtonDisabled){
            system.debug('Entered the diabled button class');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select one Author for Adding supporting attachment'));
            //hasError = true;
            return null;
        }
        //AuthorsSelected();
        return null;
    }    
    
    public PageReference InsertAuthorSupportingAttachment() {  
        AppearPubModel appPubModel = new AppearPubModel(Pubid);//Appear Enhancement 2017 Backlog R3 : Issue id 106
        //Appear Enhancement R4:Draft Share Attachment Check
        List<PubAttachmentDetails__c> draftShareAttachments = [select Id,Name,AttachmentType__c,Attachment_URL__c,Publication_Author__c,CreatedDate,FPR_Cycle__c,Publication__c from PubAttachmentDetails__c where publication__c =:PubId and AttachmentType__c='Draft - Share with Authors' and isLogicallyDeleted__c = false order by createddate desc limit 1];
        PubAttachmentDetails__c newAttachmentToInsert = NewAuthorAttachment1;
        boolean hasError = false;           
        boolean noAuthorSelected = false;
        integer selectedAuthorCount=0;
        String authorName= '';
        List<PubAuthor__c> authorId= new List<PubAuthor__c>();
        
        for(PubAuthor__c authors : delAut){
            if(authors.IsSelected__c){
                authorId.add(authors);
                authorName=authors.Author__r.Name;
                selectedAuthorCount = selectedAuthorCount + 1;
            }
        }
        
        if(selectedAuthorCount == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an Author for Adding supporting attachment'));
            hasError = true;
        }else if(selectedAuthorCount > 1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a single Author.'));
            hasError = true;
        }else{
            newAttachmentToInsert.Publication_Author__c = authorId[0].Id;
        }
        if ( newAttachmentToInsert.AttachmentName__c == null || newAttachmentToInsert.AttachmentName__c == '') {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter a name for this attachment'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter a name for this attachment.'));//Appear Enhancement R5:Adding period to the end:Michelle suggestion
            hasError = true;
        } else if (NewAuthorSupportAttachment == null || NewAuthorSupportAttachment.ContentData == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a file for this attachment'));
            hasError = true;
        } else if ( newAttachmentToInsert.AttachmentType__c == null || newAttachmentToInsert.AttachmentType__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a type for this attachment'));
            hasError = true;
        } 
        
         /* Appear Enhancement 2017 Backlog R3 : Issue id 106 :: STARTS */
        if(newAttachmentToInsert.AttachmentType__c=='Response to Author Invitation' ){//&& checkIfGppCsp() == true
            String getSuccessMsg = InvAcceptDecline_CSP('Accept');//Appear Backlog 2017 R3: Req 106
            System.debug('newAttachmentToInsert::2017::aim' + getSuccessMsg); 
            if(getSuccessMsg != 'Success'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,getSuccessMsg));
                hasError = true; 
            }
        }
        
        if(newAttachmentToInsert.AttachmentType__c=='Response to Final Author Approval' ){//&& checkIfGppCsp() == true
            String getSuccessMsg2 = ApproveDecline_CSP('Approval');//Appear Backlog 2017 R3: Req 106
            System.debug('newAttachmentToInsert::2017::aim' + getSuccessMsg2); 
            if(getSuccessMsg2 != 'Success'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,getSuccessMsg2));
                hasError = true; 
            }
        }
        /*Appear Enhancement 2017 Backlog R3 : Issue id 106 :: ENDS*/
        
        //Appear Enhancement R4:The following if statement has been added to prevent feed item for being inserted if draft-share not present
        Contact authorContact = [select FirstName, LastName, UserId__r.id,id,email from contact where id=:authorId[0].Author__c limit 1];
        Profile authorProfille = [select Name, Id from Profile where Name = 'Appear Portal Pub Author Login'];
        if((draftShareAttachments.isEmpty()) && newAttachmentToInsert.AttachmentType__c=='Substantial Comments'){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Substantial Comment Attachment cannot be added before Draft-Share Attachment'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Substantial Comment Attachment cannot be added before a Draft-Share Attachment has been uploaded.'));//Appear Enhancement R5:Error message Verbiage change:Michelle suggestion
                return null;
        }
        //Appear Enhancement R5:Comment Date Mandatory on Attachment popup
        else if(evt.startDateTime == null && newAttachmentToInsert.AttachmentType__c=='Substantial Comments'){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'While uploading Substantial Comment Attachment, the Comment Date cannot be null'));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'When uploading Substantial Comment Attachment, enter the date & time of the Author comment'));//Appear Enhancement R5: Error message changed to the following
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'When uploading a Substantial Comment Attachment, enter the date & time the Substantial Comments were received.'));//Appear Enhancement R5:Error message Verbiage change:Michelle suggestion
            return null;
        }
        //Appear Enhancement R5:Comment Date Mandatory on Attachment popup
        //Appear Enhancement R5:Future Comment Date cannot be set
        else if(evt.startDateTime > System.now() && newAttachmentToInsert.AttachmentType__c=='Substantial Comments'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'While uploading Substantial Comment Attachment, the Comment Date cannot be set in future'));
            return null;
        }
        //Appear Enhancement R5:Future Comment Date cannot be set
        else if(newAttachmentToInsert.AttachmentType__c=='Substantial Comments' && authorContact.UserId__r.id == null){
            //Appear Enhancement R4:User being created for contact which doesn't have any Contact
            
                User u = new User();
                u.FirstName = authorContact.FirstName;
                u.LastName = authorContact.LastName;
                u.Email = authorContact.Email;
                u.ContactId = authorContact.Id;
                u.Username =  authorContact.Email;
                try{
                    u.Alias = authorContact.FirstName.substring(0,1)+authorContact.LastName.substring(0,2)+authorContact.Email.substring(0,4);
                }
                catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() ));
                    return null;
                }
                u.CommunityNickname = authorContact.FirstName+'_'+authorContact.LastName+'@amgen.com';
                u.LocaleSidKey = 'en_US';                                
                u.EmailEncodingKey = 'ISO-8859-1';
                u.LanguageLocaleKey = 'en_US';
                u.TimeZoneSidKey = 'America/Los_Angeles'; 
                u.ProfileId = authorProfille.Id;
                    try{
                         insert u; 
                         authorContact.UserId__c = u.id;     
                         update authorContact; 
                     }
                     catch(Exception e){
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() ));
                         return null;
                     }
                   
        }
        /*else{
            try{
                insert NewAuthorSupportAttachment; // Feed item record is created for this type of attachment
            }
            catch(Exception e){
                System.debug('Exception'+e);
            }
        }*/
        
         //Appear Enhancement R5:FeedItem Insert outside the if statement
        try{
            
              insert NewAuthorSupportAttachment; // Feed item record is created for this type of attachment
        }
        catch(DMLException e){
            ApexPages.addMessages(e);
            return null;
        }
        //Appear Enhancement R5:FeedItem Insert outside the if statement
        
        newAttachmentToInsert.SubmissionCycle__c = activePub.Current_SubmissionCycle_Id_Formula__c;
        newAttachmentToInsert.What__c = NewAuthorSupportAttachment.Id;
        newAttachmentToInsert.AttachmentDate__c = Date.Today(); 
        newAttachmentToInsert.FPR_Cycle__c = getCorrectFPRCycleIdForAuthorRelatedAttachments(newAttachmentToInsert.AttachmentType__c).Id;
        newAttachmentToInsert.Attachment_URL__c = AppearUrlModel.ChatterFeedIdToUrl(newAttachmentToInsert.what__c);
        
        if ( hasError ){
            
            AppLogModel.flushLogs();
            //return to Modal page to display VF Error Message
            pNewAuthorSupportAttachment = null;
            return null;
        }
        Database.Saveresult sr;
        try{
            sr=database.insert(newAttachmentToInsert, true);
            System.debug('New attachment to insert is called'+newAttachmentToInsert);
        }catch(DMLException ex){
            ApexPages.addMessages(ex);
            return null;
        }
        String message;
        if(sr.isSuccess()){
            if(newAttachmentToInsert.AttachmentType__c=='Response to Author Invitation'){
                    //message='The attachment type "'+ newAttachmentToInsert.AttachmentType__c +'" for "'+ authorName + '" was added successfully. To complete the process, click on the Authors tile to refresh the screen and then select "Pending."';
                    /*Appear Enhancement 2017 Backlog R3 : Issue id 106 :: STARTS*/
                if(pubAuthordataforAtt.InviteAcceptedDate__c == null && pubAuthordataforAtt.Invite_Rejected_Date__c == null){
                	pubAuthordataforAtt.AuthorStatus__c ='Publication Review by Authors';
                    pubAuthordataforAtt.On_behalf_of_for_Invite__c = UserInfo.getUserId();
                	pubAuthordataforAtt.InviteAcceptedDate__c = evt.RecurrenceEndDateOnly;
                	try{
                        update pubAuthordataforAtt;
                    }
                    catch(DMLException ex){
                        System.debug('Upload & Accept 2017 :pubAuthor2017' + ex);
                        throw ex;
                    }
                }
                	message='The attachment type "'+ newAttachmentToInsert.AttachmentType__c +'" for "'+ authorName + '" was added and you have successfully responded on behalf of this author. If the author has declined, proceed with the process for removing the author from the publication.';
                	/*Appear Enhancement 2017 Backlog R3 : Issue id 106 :: ENDS*/
                	//below message commented as part of Appear Enhancement 2017 Backlog R3 : Issue id 106 
                    //message='The attachment type "'+ newAttachmentToInsert.AttachmentType__c +'" for "'+ authorName + '" was added successfully. To complete the process, click on the Authors tile to refresh the screen. For Invitation Acceptances, click the corresponding Author’s “Pending” link.  For Author Declines, proceed with the process for removing the author from the publication.'; // Appear Enhamcement backlog R2 - Verbiage Changes
                }else if(newAttachmentToInsert.AttachmentType__c=='Approval to Remove Author'){
                    message='The attachment type "'+ newAttachmentToInsert.AttachmentType__c +'" for "'+ authorName + '" was added successfully. To complete the process, click on the Authors tile to refresh the screen, select the author, and select the "Remove Author" button.';
                }else if(newAttachmentToInsert.AttachmentType__c=='Substantial Comments'){
                    
                    //Appear Enhancement R4:Static Comment addition on Substantial Comment Attachment upload-Start
                
                            if(!(draftShareAttachments.isEmpty())){
                                Id authorContactUserId = AppearContactModel.findUserIdForContactId(authorId[0].Author__c);
                                string []urlSegments = newAttachmentToInsert.Attachment_URL__c.split('/', 0); //Appear Enhancement R5:The relatedrecordid is changed to substantial comment attachment
                                Id relatedrecordid =  ID.valueOf(urlSegments[urlSegments.size()-1]);
                                Feeditem draftComment= new FeedItem();
                                draftComment.Type = 'TextPost';
                                draftComment.Visibility = 'AllUsers';
                                draftComment.parentid=draftShareAttachments[0].Id;
                                draftComment.RelatedRecordId = relatedrecordid;
                                draftComment.createdbyid = authorContactUserId;
                                draftComment.body='Please See Attached';   
                                draftComment.CreatedDate = evt.startDateTime;   //Appear Enhancement R5:The draft comment date as entered by the user Added                  
                                try{
                                    insert draftComment;
                                    newAttachmentToInsert.FeedItemIdForComment__c = draftComment.id;// Appear Enhancement R5: The Draft Attachment has been changed to Substantial Comment Attachment
                                    update newAttachmentToInsert;// Appear Enhancement R5: The Draft Attachment has been changed to Substantial Comment Attachment
                                    for(pubAuthor__c pubList: pubAuthorList){
                                        // Comment Receive Date field added in if condition, Appear Enhancement R4
                                        if(pubList.id == authorId[0].Id && pubList.CommentReceivedDate__c == null){
                                            //pubList.CommentReceivedDate__c = System.today(); //Commented as Part of Appear Enhancement R5
                                            pubList.CommentReceivedDate__c = evt.startDateTime;//Appear Enhancement R5:The date entered by the user would be the comment received date, which would be updated only the first time
                                            update pubList;
                                            break;
                                        }
                                    }
                                    
                                }
                                catch(Exception e){
                                    System.debug('Exception'+e);
                                }
                            }
                
                      //Static Comment addition on Substantial Comment Attachment upload-End
                    
                    message='The attachment type, "'+ newAttachmentToInsert.AttachmentType__c +'" for "'+ authorName + '" was added successfully. Before performing any further action, please click on the Authors Tile.';
                }else if(newAttachmentToInsert.AttachmentType__c=='Response to Final Author Approval'){
                    //Appear Enhancement 2017 Backlog R3 : Issue id 106 :: STARTS
                    if(pubAuthordataforAtt.ApprovalAcceptedDate__c == null && pubAuthordataforAtt.Approval_Rejected_Date__c == null){
                	 pubAuthordataforAtt.ApprovalAcceptedDate__c = evt.ActivityDate;   
                	 pubAuthordataforAtt.AuthorStatus__c ='Completed Author Approval';
                     pubAuthordataforAtt.On_behalf_of_for_Approval__c = UserInfo.getUserId();
                	try{
                        update pubAuthordataforAtt;
                        appPubModel.PubStatus.insertfinalApprovalresponse(Pubid);
                    }
                    catch(DMLException ex){
                        System.debug('Upload & Approve 2017 :pubAuthor2017' + ex);
                        throw ex;
                    }
                    }
                    message='The attachment type "'+ newAttachmentToInsert.AttachmentType__c +'" for "'+ authorName + '" was added and you have successfully responded on behalf of this author.';
                	/*Appear Enhancement 2017 Backlog R3 : Issue id 106 :: ENDS*/
                    //below code commented as part of Appear Enhancement 2017 Backlog R3 : Issue id 106
                    //message='The attachment type "'+ newAttachmentToInsert.AttachmentType__c +'" for "'+ authorName + '" was added successfully. To complete the process, click on the Authors tile to refresh the screen and then select "Pending."';
                }else{
                    message= 'The attachment type "'+ newAttachmentToInsert.AttachmentType__c +'" for "'+ authorName + '" was added successfully. To complete the process, click on the Authors tile to refresh the screen and Continue';
                }
        }
        
        pNewAuthorSupportAttachment = null;
        for(PubAuthor__c pubAuthors : delAut){
            if(pubAuthors.IsSelected__c)
                pubAuthors.IsSelected__c= false;
        }
        AppLogModel.flushLogs();                
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,message));
        
        return null;
         
     }

    public FPR_Cycle__c getCorrectFPRCycleIdForAuthorRelatedAttachments(String attachmentType){
        
        FPR_Cycle__c nextFprCycle;

        integer currFprCycleNum = (activePub.Current_FPRCycle_Id_Formula__c == null) ? 1 : Integer.ValueOf(activePub.Current_FPR_Cycle_Num__c); //Modified to always start with FPR Cycle = 1 instead of 0
        nextFprCycle = pubModel.FprCycle.getFprCycleByNum(currFprCycleNum);
                
        
        return nextFprCycle;
    }


    private transient PubAttachmentDetails__c pNewAuthorAttachment1 = null;
        public PubAttachmentDetails__c NewAuthorAttachment1 {
            get {
                if ( pNewAuthorAttachment1 == null) {
                    pNewAuthorAttachment1 = getNewAttachment();
                }
                system.debug('New Author attachment record type selection is called');
                RecordType rt = [select Id from RecordType where DeveloperName = 'Author_Supporting_Documents' ];
                pNewAuthorAttachment1.RecordTypeId=rt.id;
                return pNewAuthorAttachment1;
         }
     }
        
     public PubAttachmentDetails__c getNewAttachment() {
        PubAttachmentDetails__c newAttach = new PubAttachmentDetails__c();
        System.assertNotEquals(null, PubId);
        newAttach.publication__c = PubId;
        return newAttach;
    }


    public void clearCache() {
        system.debug('Clear Cache is called');
            pNewAuthorAttachment1 = null;
            pNewAuthorSupportAttachment = null;
    }


    private transient FeedItem pNewAuthorSupportAttachment = null;
        public FeedItem NewAuthorSupportAttachment {
            
            get {
                system.debug('FeedItem is called');
                if (pNewAuthorSupportAttachment == null) {
                    pNewAuthorSupportAttachment = new FeedItem();
                    if (Test.IsRunningTest()) {
                        pNewAuthorSupportAttachment.ParentId = PubId;
                    } else {
                        pNewAuthorSupportAttachment.ParentId = ChatterGroupId;
                        pNewAuthorSupportAttachment.NetworkScope = ChatterNetworkId;
                    }
                    pNewAuthorSupportAttachment.Body = 'Pub Attachment';
                }
                return pNewAuthorSupportAttachment;
            }
            set; 
    }


     public Id ChatterNetworkId {
        get{
            if (ChatterNetworkId == null) {
                List<Network> networks = [SELECT Id FROM Network WHERE Name = 'FPR Submitter'];
                if (networks.size() > 0) {
                    ChatterNetworkId = networks[0].Id;
                }
            }
            return ChatterNetworkId;
        }
        private set;
    }
    public Id ChatterGroupId {
        get{
            if (ChatterGroupId == null) {
                List<CollaborationGroup> groups = [SELECT Id FROM CollaborationGroup WHERE Name = 'Attachments'];
                if (groups.size() > 0) {
                    ChatterGroupId = groups[0].Id;
                }
            }
            return ChatterGroupId;
        }
        private set;
    }
    // End - Supporting attachment for Author - IE/CrossBrowser implementation
    
    //Start - Approve on behalf method
    public final static string ApprRejOnBehalfAttachmentType = 'Response to Final Author Approval';
    
    public PageReference ApproveOnBehalf(){

    AppearPubModel appPubModel = new AppearPubModel(Pubid);
    Boolean updateCheck = false;
    List<PubAttachmentDetails__c> attachmentList= PubAttachmentModel.getAllPubAttachmentList(pubId);
    
     for(pubAuthor__c pa:InvSentAut){
          if(checkIfGppCsp() == true){
           for(PubAttachmentDetails__c pbAtt: attachmentList){  
           if (pbAtt.Publication_Author__c == pa.id && pbAtt.AttachmentType__c == ApprRejOnBehalfAttachmentType   ) {
                   updateCheck = true;
           }
           }
          }
         else {
               updateCheck = true;
               break;
          }
      }
    
    if (updateCheck == true){
      for(pubAuthor__c pa:InvSentAut){
          //Appear Enhancement 2017 Backlog R2 - Issue Id 9, If Statement Added and existing If statment moved to else if condition
          if(pa.ApprovalSentDate__c != null && (evt.ActivityDate == null || evt.ActivityDate < pa.ApprovalSentDate__c || evt.ActivityDate > System.today())){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Actual Approval accept date cannot be blank, a future date, or before the approval sent date.'));
              return null;
          	//if (pa.InviteSentDate__c!= null && pa.InviteAcceptedDate__c != null && pa.ApprovalSentDate__c != Null && pa.ApprovalAcceptedDate__c == Null
            }else if (pa.InviteSentDate__c!= null && pa.InviteAcceptedDate__c != null && pa.ApprovalSentDate__c != Null &&
                   		evt.ActivityDate >= pa.ApprovalSentDate__c && evt.ActivityDate <= System.today()){ // Issue Id 9,Validation to check incorrect date
                   if(pa.Justification_for_Approval__c!= Null && pa.Justification_for_Approval__c!= ''){
                      //pa.ApprovalAcceptedDate__c = system.today();//Issue Id 9
                      pa.ApprovalAcceptedDate__c = evt.ActivityDate; // Issue Id 9,User provided date is set for Approval Accepted Date
                      pa.Justification_for_Approval__c = pa.Justification_for_Approval__c ;
                      pa.AuthorStatus__c ='Completed Author Approval';
                      pa.On_behalf_of_for_Approval__c =UserInfo.getUserId();
                      
                      update InvSentAut;
                      appPubModel.PubStatus.insertfinalApprovalresponse(Pubid);
                      InvSentAut.clear();
                      return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
              }
                   else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Justification is Required.'));
                    return null;  
                  }
               }
           }
      
    }//if update==true ends
    
    else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add attachment type "Response to Final Author Approval" using the "Add Author Attachments" button.'));
        return null; 
        }
    return null;
    }
    //End - Approve on behalf method
    
    //Start - Decline on behalf method
    public PageReference declineOnBehalf(){
    
    AppearPubModel appPubModel = new AppearPubModel(Pubid);
    Boolean updateCheck = false;
    List<PubAttachmentDetails__c> attachmentList= PubAttachmentModel.getAllPubAttachmentList(pubId);
    
     for(pubAuthor__c pa:InvSentAut){
          if(checkIfGppCsp() == true){
           for(PubAttachmentDetails__c pbAtt: attachmentList){  
           if (pbAtt.Publication_Author__c == pa.id && pbAtt.AttachmentType__c == ApprRejOnBehalfAttachmentType   ) {
                   updateCheck = true;
           }
           }
           }
         else {
            system.debug('PubAuthorModel :: declineOnBehalf :: LIST VIEW' + InvSentAut);
            system.debug('PubAuthorModel :: declineOnBehalf :: LIST VIEW2' + InvSentAut[0] + pa.id);
            updateCheck = true;
            break;
           }
      }
    if (updateCheck == true){
      for(pubAuthor__c pa:InvSentAut){
          // Appear Enhancement 2017 Backlog R2, Issue Id 9 - Decline Author Approval
          if(pa.ApprovalSentDate__c != null && (evt.ActivityDate == null || evt.ActivityDate < pa.ApprovalSentDate__c || evt.ActivityDate > System.today() )){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Actual Approval decline date cannot be blank, a future date, or before the approval sent date.'));
              return null;
          }else if(evt.ActivityDate != null && evt.ActivityDate >= pa.ApprovalSentDate__c && evt.ActivityDate <= System.today() ){ // Appear Enhancement 2017 Backlog R2 - Exiasting If condition moved insider else if
              if(pa.Justification_for_Approval__c != Null && pa.Justification_for_Approval__c != ''){
                    pa.Justification_for_Approval__c = pa.Justification_for_Approval__c;
                    pa.AuthorStatus__c ='Approval Rejected';
                    //pa.Approval_Rejected_Date__c = system.today();//Appear Enhancement 2017 Backlog R2 - Issue Id 9
                    pa.Approval_Rejected_Date__c = evt.ActivityDate;//Appear Enhancement 2017 Backlog R2 - Issue Id 9
                    pa.On_behalf_of_for_Approval__c = UserInfo.getUserId();
                          
                    update InvSentAut;
                    appPubModel.PubStatus.insertfinalApprovalresponse(Pubid);
                    InvSentAut.clear();
                    return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
                }//if :ends
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Justification is Required.'));
                    return null;  
                  }
          }
        } 
      
    }//if update==true ends
    
    else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add attachment type "Response to Final Author Approval" using the "Add Author Attachments" button.'));
        return null; 
        }
    return null;
    }
    //End - Decline on behalf method
    
    
    //Start - Accept on behalf method
    public final static string InvAcceptAttachmentType = 'Response to Author Invitation';
    public PageReference InvAcceptOnBehalf(){

    Boolean updateCheck = false;
    List<PubAttachmentDetails__c> attachmentList= PubAttachmentModel.getAllPubAttachmentList(pubId);
    
     for(pubAuthor__c pa:InvSentAut){
          if(checkIfGppCsp() == true){
           for(PubAttachmentDetails__c pbAtt: attachmentList){  
           if (pbAtt.Publication_Author__c == pa.id && pbAtt.AttachmentType__c == InvAcceptAttachmentType   ) {
                   updateCheck = true;
           }
           }
          }
         else {
                   updateCheck = true;
                   break;
          }
      }
    
    if (updateCheck == true){
      for(pubAuthor__c pa:InvSentAut){
          //Appear Enhancement 2017 Backlog R2: Issue Id 9 :prompt the user for the acutal date the author accepted: 
          if(pa.InviteSentDate__c!= null && (pa.InviteAcceptedDate__c < pa.InviteSentDate__c || pa.InviteAcceptedDate__c > System.today() || pa.InviteAcceptedDate__c == null)){//pa.InviteAcceptedDate__c == null 
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Actual invitation accept date cannot be blank, a future date, or before the invite sent date.'));
              return null;
          }else if (pa.InviteSentDate__c!= null &&  pa.InviteAcceptedDate__c >= pa.InviteSentDate__c && pa.InviteAcceptedDate__c <= System.today()){//  Appear Enhancement 2017 Backlog R2 - Accepted Date validation
                   if(pa.Justification_for_invite__c != Null && pa.Justification_for_invite__c != ''){
                      //pa.InviteAcceptedDate__c= system.today(); //Appear Enhancement 2017 Backlog R2: Issue Id 9 :
                      pa.Justification_for_invite__c = pa.Justification_for_invite__c ;
                      pa.AuthorStatus__c ='Publication Review by Authors';
                      pa.On_behalf_of_for_Invite__c = UserInfo.getUserId();
                      update InvSentAut;
                      InvSentAut.clear();
                      return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
               }
                   else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Justification is Required.'));
                    return null;  
                  }
               }
           }
      
    }//if update==true ends
    
    else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add attachment type "Response to Author Invitation" using the "Add Author Attachments" button.'));
            return null; 
        }
    return null;
    }

    //End - Accept on behalf method
    
  /* Appear Enhancement 2017 Backlog R3 : Issue id 106 :: STARTS*/
  //Consolidation of Invite acceptance,Approval Acceptance and Decline. It checks actual author response date and updates the selected authors status,on behalf information.//
    public string authorFirstName{get;set;} 
    public string authorLastName{get;set;}
    public string newAuthorAppDiscID{get;set;}
    public Boolean checkAuthInvSentDate{get;set;}
    public Boolean checkAuthAppSentDate{get;set;}
    public string authorPubID{get;set;}
    public PubAuthor__c pubAuthordataforAtt {get;set;}
    
     public String InvAcceptDecline_CSP(String acceptDecline){
     String retValue = '';    
     System.debug('InvAcceptOnBehalf_CSP:: evt' + evt.RecurrenceEndDateOnly);   
        if(pubAuthordataforAtt.InviteSentDate__c == null){
            retValue  = 'You cannot Upload the Response to Author Invitation before the invitation is sent.';
            return retValue;
        }
         else if(pubAuthordataforAtt.InviteSentDate__c != null &&  (pubAuthordataforAtt.InviteAcceptedDate__c != null || pubAuthordataforAtt.Invite_Rejected_Date__c != null ) ){
             retValue = 'Success';
             return retValue;
         } 
        else if(pubAuthordataforAtt.InviteSentDate__c != null && (evt.RecurrenceEndDateOnly == null || evt.RecurrenceEndDateOnly < pubAuthordataforAtt.InviteSentDate__c || evt.RecurrenceEndDateOnly > System.today() )){
             if(acceptDecline == 'Accept'){
              retValue  = 'Actual invitation accept date cannot be blank, a future date, or before the invite sent date.';
            }
            if(acceptDecline == 'Decline'){
              retValue  = 'Actual invitation decline date cannot be blank, a future date, or before the invite sent date.';  
            }
            return retValue;
          }
        else if(pubAuthordataforAtt.Justification_for_invite__c == Null || pubAuthordataforAtt.Justification_for_invite__c == ''){
           retValue  = 'Justification is Required.';
           System.debug('InvAcceptOnBehalf_CSP :: retValue' + retValue); 
           return retValue;
        } 
        else if (pubAuthordataforAtt.InviteSentDate__c!= null && 
                  (evt.RecurrenceEndDateOnly >= pubAuthordataforAtt.InviteSentDate__c && evt.RecurrenceEndDateOnly <= System.today()) ) { 
                   retValue = 'Success';
                   return retValue;
       } 
       else {
             retValue = 'Fail';
             System.debug('InvAcceptOnBehalf_CSP :: retValue' + retValue);
             return retValue;           
       }  
    }
    
    public String ApproveDecline_CSP(String approveDecline){
        String retValue = ''; 
        if(pubAuthordataforAtt.ApprovalSentDate__c == null){
            retValue  = 'You cannot Upload the Response to Final Author Approval before the approval request is sent.';
            return retValue;
        }
        else if(pubAuthordataforAtt.ApprovalSentDate__c != null &&  (pubAuthordataforAtt.ApprovalAcceptedDate__c != null || pubAuthordataforAtt.Approval_Rejected_Date__c != null ) ){
             retValue = 'Success';
             return retValue;
        }
        else if(pubAuthordataforAtt.ApprovalSentDate__c!= null && (evt.ActivityDate == null || evt.ActivityDate < pubAuthordataforAtt.ApprovalSentDate__c || evt.ActivityDate > System.today())){
              //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Actual Invitation Accept date cannot be before Invitation Sent Date or Future Date or Blank. Please refresh the tile and try again.'));
            System.debug('Check param approveDecline' + approveDecline);
            if(approveDecline == 'Approval'){
              retValue  = 'Actual Approval accept date cannot be blank, a future date, or before the approval sent date.';
            }
            if(approveDecline == 'Decline'){
              retValue  = 'Actual Approval decline date cannot be blank, a future date, or before the approval sent date.';  
            }
            System.debug('ApproveDecline_CSP :: retValue' + retValue);
            return retValue;
          }
        else if(pubAuthordataforAtt.Justification_for_Approval__c == Null || pubAuthordataforAtt.Justification_for_Approval__c == ''){
           //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Justification is Required.'));
           retValue  = 'Justification is Required.';
           return retValue;
        } 
        else if (pubAuthordataforAtt.InviteSentDate__c!= null && pubAuthordataforAtt.InviteAcceptedDate__c != null && pubAuthordataforAtt.ApprovalSentDate__c != Null &&
                   		evt.ActivityDate >= pubAuthordataforAtt.ApprovalSentDate__c && evt.ActivityDate <= System.today() ) { 
                   retValue = 'Success';
                   return retValue;
       } 
       else {
             retValue = 'Fail';
            return retValue;           
       } 
    }
    
    public PageReference newUploadAndDecline() { 
        AppearPubModel appPubModel = new AppearPubModel(Pubid);
        PubAttachmentDetails__c newAttachmentToInsert = NewAuthorAttachment1;
        boolean hasError = false;           
        boolean noAuthorSelected = false;
        integer selectedAuthorCount=0;
        String authorName= '';
        List<PubAuthor__c> authorId= new List<PubAuthor__c>();
        
        for(PubAuthor__c authors : delAut){
            if(authors.IsSelected__c){
                authorId.add(authors);
                authorName=authors.Author__r.Name;
                selectedAuthorCount = selectedAuthorCount + 1;
            }
        }
        
        if(selectedAuthorCount == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an Author for Adding supporting attachment'));
            hasError = true;
        }else if(selectedAuthorCount > 1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a single Author.'));
            hasError = true;
        }else{
            newAttachmentToInsert.Publication_Author__c = authorId[0].Id;
        }
        if ( newAttachmentToInsert.AttachmentName__c == null || newAttachmentToInsert.AttachmentName__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter a name for this attachment.'));
            hasError = true;
        } else if (NewAuthorSupportAttachment == null || NewAuthorSupportAttachment.ContentData == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a file for this attachment'));
            hasError = true;
        } else if ( newAttachmentToInsert.AttachmentType__c == null || newAttachmentToInsert.AttachmentType__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a type for this attachment'));
            hasError = true;
        }
        
        if(newAttachmentToInsert.AttachmentType__c=='Response to Author Invitation' ){
            String getSuccessMsg = InvAcceptDecline_CSP('Decline');
            if(getSuccessMsg != 'Success'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,getSuccessMsg));
                hasError = true; 
            }
        }
        if(newAttachmentToInsert.AttachmentType__c=='Response to Final Author Approval' ){//&& checkIfGppCsp() == true
            String getSuccessMsg2 = ApproveDecline_CSP('Decline');
            if(getSuccessMsg2 != 'Success'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,getSuccessMsg2));
                hasError = true; 
            }
        }
        
		if ( hasError ){
            AppLogModel.flushLogs();
            //return to Modal page to display VF Error Message
            pNewAuthorSupportAttachment = null;
            return null;
        }
		
        try{
            
              insert NewAuthorSupportAttachment;
        }
        catch(DMLException e){
            ApexPages.addMessages(e);
            return null;
        }
        
        newAttachmentToInsert.SubmissionCycle__c = activePub.Current_SubmissionCycle_Id_Formula__c;
        newAttachmentToInsert.What__c = NewAuthorSupportAttachment.Id;
        newAttachmentToInsert.AttachmentDate__c = Date.Today(); 
        newAttachmentToInsert.FPR_Cycle__c = getCorrectFPRCycleIdForAuthorRelatedAttachments(newAttachmentToInsert.AttachmentType__c).Id;
        newAttachmentToInsert.Attachment_URL__c = AppearUrlModel.ChatterFeedIdToUrl(newAttachmentToInsert.what__c);
        
        
        Database.Saveresult sr;
        try{
            sr=database.insert(newAttachmentToInsert, true);
            System.debug('New attachment to insert is called :: for decline 2017'+newAttachmentToInsert);
        }catch(DMLException ex){
            ApexPages.addMessages(ex);
            return null;
        }
        String message;
        if(sr.isSuccess()){
            if(newAttachmentToInsert.AttachmentType__c=='Response to Author Invitation'){
                     pubAuthordataforAtt.AuthorStatus__c ='Invitation Rejected';
                     pubAuthordataforAtt.On_behalf_of_for_Invite__c = UserInfo.getUserId();
               		 pubAuthordataforAtt.Invite_Rejected_Date__c = evt.RecurrenceEndDateOnly;	
                	try{
                        update pubAuthordataforAtt;
                    }
                    catch(DMLException ex){
                        System.debug('Upload & Accept 2017 :pubAuthor2017' + ex);
                        throw ex;
                    }
                	message='The attachment type "'+ newAttachmentToInsert.AttachmentType__c +'" for "'+ authorName + '" was added and you have successfully responded on behalf of this author. If the author has declined, proceed with the process for removing the author from the publication.';
           } 
          else if(newAttachmentToInsert.AttachmentType__c=='Response to Final Author Approval'){
                     pubAuthordataforAtt.Approval_Rejected_Date__c = evt.ActivityDate;   
                	 pubAuthordataforAtt.AuthorStatus__c ='Approval Rejected';
                     pubAuthordataforAtt.On_behalf_of_for_Approval__c = UserInfo.getUserId();
                	try{
                        update pubAuthordataforAtt;
                        appPubModel.PubStatus.insertfinalApprovalresponse(Pubid);
                    }
                    catch(DMLException ex){
                        System.debug('Upload & Decline 2017 :pubAuthordataforAtt' + ex);
                        throw ex;
                    }
                	message='The attachment type "'+ newAttachmentToInsert.AttachmentType__c +'" for "'+ authorName + '" was added and you have successfully responded on behalf of this author.';
                }
        }
        
        pNewAuthorSupportAttachment = null;
        for(PubAuthor__c pubAuthors : delAut){
            if(pubAuthors.IsSelected__c)
                pubAuthors.IsSelected__c= false;
        }
        AppLogModel.flushLogs();                
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,message));
        
        return null;
         
     }
    
    /* Appear Enhancement 2017 Backlog R3 : Issue id 106 :: ENDS*/
   
    
   
    //Start - Enable Request Approval method
    public boolean enableRequestApproval {get; set;}
    
    //Method checks if publication is in FPR Completed status
    public boolean publicationFPRCompleted(){
        if(PubAuthorList.size()>0){
            pubAuthor__c pubauthrecord = PubAuthorList[0];
            if(pubauthrecord.Publication__r.Current_Status_FormulaField__c == 'FPR Completed' || pubauthrecord.Publication__r.Current_Status_FormulaField__c == 'FPR Completed with Comments' || pubauthrecord.Publication__r.Current_Status_FormulaField__c == 'Courtesy FPR Completed with Comments' || pubauthrecord.Publication__r.Current_Status_FormulaField__c == 'Courtesy FPR Completed'){
                return true;
            }
        }
        return false;
    }
    
    //End - Enable Request Approval method
    //Start - Comment on behalf
    public Id pubAuthorRecordId = null;
    public boolean enableOnbehalfCommentSection {get;set;}
    private Transient FeedItem pNewDraftComment = null;
        public FeedItem NewDraftComment {
        get{
            if (pNewDraftComment == null) {
                pNewDraftComment = new FeedItem();
                pNewDraftComment.Type = 'TextPost';
                pNewDraftComment.Visibility = 'AllUsers';
            }
            return pNewDraftComment;
        }
         set;
        }
        public Event evt { // proxy object, fld StartDateTime is creatable
          get {
            if (this.evt == null)
                 this.evt = new Event();
            return this.evt; 
          }
          set;
        }   
    //-------------------------------------------------
       public PageReference saveOnBehalfComment(){ 
            
                DateTime recentDraftShareAttachmentDate = null;  
                ID recentDraftShareAttachmentId = null;          
                DateTime recentSupportingCommentAttachmentDate = null;  
                ID recentSupportingCommentAttachmentId = null;
                    if(pubAuthorList != null){
                        pubAuthor__c pubauthrecord = PubAuthorList[0];
                        List<PubAttachmentDetails__c> allAttachments = [select Id,Name,AttachmentType__c,FeedItemIdForComment__c,Attachment_URL__c,Publication_Author__c,CreatedDate,FPR_Cycle__c,Publication__c from PubAttachmentDetails__c where publication__c =:PubId and isLogicallyDeleted__c = false]; 
                        if(allAttachments!=null){           
                            for(PubAttachmentDetails__c attachmentRecord : allAttachments) {
                                if((recentDraftShareAttachmentDate == null || attachmentRecord.CreatedDate>recentDraftShareAttachmentDate) && attachmentRecord.AttachmentType__c =='Draft - Share with Authors' && (attachmentRecord.FPR_Cycle__c == pubauthrecord.Publication__r.Current_FPRCycle_Id_Formula__c || pubauthrecord.Publication__r.Current_FPRCycle_Id_Formula__c == null)){      
                                    recentDraftShareAttachmentDate=attachmentRecord.CreatedDate;
                                    recentDraftShareAttachmentId=attachmentRecord.ID;
                                } 
                                //Appear Enhancement R4:The following line has been commeneted and the line below added
                                //if((recentSupportingCommentAttachmentDate == null || attachmentRecord.CreatedDate>recentSupportingCommentAttachmentDate) && attachmentRecord.Publication_Author__c == pubAuthorRecordId && attachmentRecord.AttachmentType__c =='Substantial Comments' && (attachmentRecord.FPR_Cycle__c == pubauthrecord.Publication__r.Current_FPRCycle_Id_Formula__c || pubauthrecord.Publication__r.Current_FPRCycle_Id_Formula__c == null)){
                                if((recentSupportingCommentAttachmentDate == null || attachmentRecord.CreatedDate>recentSupportingCommentAttachmentDate) && attachmentRecord.Publication_Author__c == pubAuthorRecordId && attachmentRecord.AttachmentType__c =='Substantial Comments'){       
                                    recentSupportingCommentAttachmentDate=attachmentRecord.CreatedDate;
                                    recentSupportingCommentAttachmentId=attachmentRecord.ID;
                                }               
                             }
                             Contact authorContact = [select FirstName, LastName, UserId__r.id,id,email from contact where id=:ContactId limit 1];
                             Profile authorProfille = [select Name, Id from Profile where Name = 'Appear Portal Pub Author Login'];
                             if(authorContact.UserId__r.id == null){
                                User u = new User();
                                u.FirstName = authorContact.FirstName;
                                u.LastName = authorContact.LastName;
                                u.Email = authorContact.Email;
                                u.ContactId = authorContact.Id;
                                u.Username =  authorContact.Email;
                                u.Alias = authorContact.FirstName.substring(0,1)+authorContact.LastName.substring(0,2)+authorContact.Email.substring(0,4);
                                u.CommunityNickname = authorContact.FirstName+'_'+authorContact.LastName+'@amgen.com';
                                u.LocaleSidKey = 'en_US';                                
                                u.EmailEncodingKey = 'ISO-8859-1';
                                u.LanguageLocaleKey = 'en_US';
                                u.TimeZoneSidKey = 'America/Los_Angeles'; 
                                u.ProfileId = authorProfille.Id;
                                try{
                                 insert u; 
                                 }
                                 catch(Exception e){
                                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() ));
                                     return null;
                                 }
                                authorContact.UserId__c = u.id;     
                                update authorContact;                           
                            }                            
                            if(checkifgppcsp() == true){
                                for(PubAttachmentDetails__c attachmentRecord : allAttachments) {
                                    //Appear Enhancement R4:The follwoing line has been commented and the line below has been added
                                    //if(attachmentRecord.Id == recentSupportingCommentAttachmentId && attachmentRecord.FeedItemIdForComment__c == null){ 
                                    if(attachmentRecord.Id == recentSupportingCommentAttachmentId){                                 
                                        string []urlSegments = attachmentRecord.Attachment_URL__c.split('/', 0);
                                        Id relatedrecordid =  ID.valueOf(urlSegments[urlSegments.size()-1]);
                                        NewDraftComment.parentid=recentDraftShareAttachmentId;
                                        NewDraftComment.RelatedRecordId = relatedrecordid;
                                        NewDraftComment.createdbyid = authorContact.UserId__c;
                                        NewDraftComment.CreatedDate = evt.startDateTime;
                                        if(recentDraftShareAttachmentId == null){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'A Draft-Share Attachment is needed for current FPR Cycle before adding comments'));   
                                            return null;                                        
                                        }
                                        else if(NewDraftComment.CreatedDate >  System.now()){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Comment Sent Date cannot be in future'));
                                            return null;
                                        }
                                        else if(String.isEmpty(NewDraftComment.Body)){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'A value must be entered for Comment'));
                                            return null;
                                        }
                                        else{   
                                            try{                         
                                                insert NewDraftComment; 
                                                //Appear Enhancement R4:The following piece of code has been commented                                          
                                                //attachmentRecord.FeedItemIdForComment__c = NewDraftComment.id;
                                                //update attachmentRecord;
                                                pNewDraftComment = null;
                                                
                                            }
                                            catch(Exception e){
                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Comment can not be added.'));
                                                return null;
                                            }
                                        }
                                    }
                                    //Appear Enhancement R4:The following lines have been commeneted
                                   /* else if(attachmentRecord.Id == recentSupportingCommentAttachmentId && attachmentRecord.FeedItemIdForComment__c != null){
                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'A Substantial Comments attachment needs to be added for the author'));
                                        return null;
                                    }*/                               
                                }
                             }
                             else{
                                        NewDraftComment.parentid=recentDraftShareAttachmentId;
                                        NewDraftComment.createdbyid = authorContact.UserId__c;
                                        NewDraftComment.CreatedDate = evt.startDateTime; 
                             
                                    if(recentDraftShareAttachmentId == null){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'A Draft-Share Attachment is needed for current FPR Cycle before adding comments'));   
                                            return null;                                        
                                        }
                                  else if(NewDraftComment.CreatedDate >  System.now()){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Comment Sent Date cannot be in future'));
                                            
                                            return null;
                                        }
                                        else if(String.isEmpty(NewDraftComment.Body)){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'A value must be entered for Comment'));
                                            return null;
                                        }
                                    else{
                                           
                                        try{                               
                                            insert NewDraftComment;
                                            pNewDraftComment = null;
                                        }
                                        catch(Exception e){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Comment can not be added.'));
                                            return null;
                                        }
                                    }
                             }
                        } 
                    }
                    /*
                    for(pubAuthor__c pubAuthList:pubAuthorList){
                        if(pubAuthList.Id == pubAuthorRecordId){
                            if(pubAuthList.CommentReceivedDate__c == null){
                                pubAuthList.CommentReceivedDate__c = evt.startDateTime;
                                System.debug('Checking to comment received date'+evt.startDateTime);
                                try{
                                    update pubAuthList;
                                }
                                catch(Exception e){
                                    System.debug('Cannot be inserted');
                                }
                                break;
                            }                           
                        }
                    }*/
                    
                   List <PubAuthor__c> pubAuthorRecordList = new List<PubAuthor__c>();
                    for(pubAuthor__c pubAuthListRec:pubAuthorList){
                        if(pubAuthListRec.Id == pubAuthorRecordId){
                            if(pubAuthListRec.CommentReceivedDate__c == null){
                            //Appear Enhancement R5: If date is not given, the CommentReceivedDate will be System date/time, otherwise it will be date provided
                            if(evt.startDateTime == null){
                                pubAuthListRec.CommentReceivedDate__c = System.now();
                            }
                            else{
                                pubAuthListRec.CommentReceivedDate__c = evt.startDateTime;
                            }
                            //Appear Enhancement R5: If date is not given, the CommentReceivedDate will be System date/time, , otherwise it will be date provided
                                System.debug('Checking to comment received date'+evt.startDateTime);
                                try{
                                    //update pubAuthListRec;
                                    pubAuthorRecordList.add(pubAuthListRec);
                                }
                                catch(Exception e){
                                     ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Pub Author can not be added to list'));
                                     return null;
                                }
                                break;
                            }                           
                        }
                    }
                    try{
                            if(!pubAuthorRecordList.isEmpty())
                            {
                            update pubAuthorRecordList;
                            }
                        
                    }
                    catch(Exception e){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Pub Author can not be updated.'));
                        return null;
                    }
                   pageReference del = ApexPages.currentPage(); 
                   Id pubid = del.getParameters().get('Id');
                   String tile = del.getParameters().get('tile');
                   String sfdc_tabName = del.getParameters().get('sfdc.tabName');
                   String submenu =  del.getParameters().get('submenu');
                   String sfdc_override = del.getParameters().get('sfdc.override');
                   del.getParameters().clear();  // clear view states assoicated with url
                   del.getParameters().put('Id', pubid );  
                   del.getParameters().put('tile', tile);  
                   del.getParameters().put('sfdc.tabName', sfdc_tabName);  
                   del.getParameters().put('sfdc.override', sfdc_override);         
                   del.getParameters().put('submenu', submenu);  
                   del.setRedirect(true);
                   return del;
        }


    
    //End - Comment on behalf
    
    
    //==============================================================
    // End - Appear Enhancement R3
    //==============================================================
    
    
    //This required to be reset based on the Defect 46 in APPEAR 4.0, otherwise Author will never be able to 
    //see the publication in the Review Queue Tab because it was approved in the previous FPR Cycle.
    //Users agreed to manually grant access for any subsequent cycles. Hence, GrantAccess is being reset to FALSE.
    public static void resetAuthorApprovalsForNextFPRCycle(Id pubId){
        List<PubAuthor__c> pubAuthors = getPubAuthors(pubId);
        
        for (PubAuthor__c pubAuth : pubAuthors){
            pubAuth.GrantDraftAccess__c = false;
            pubAuth.ApprovalSentDate__c = null;
            pubAuth.ApprovalAcceptedDate__c = null;
            pubAuth.Approval_Rejected_Date__c = null;
            pubAuth.Approval_Disclaimer_ID__c = null;
            pubAuth.ReasonToDeclineApproval__c = null;
            pubAuth.AuthorStatus__c = 'Publication Review by Authors';
        }
        
        database.update(pubAuthors, true);
    } 
    
    ////////////////////  static ///////////////////////
    public static List<PubAuthor__c> getPubAuthors(id PubId){
        List<PubAuthor__c> authors = [
            select publication__c,publication__r.name,publication__r.Current_Target__c,publication__r.Publication_Title__c,publication__r.Publication_Type__c, isSelected__c, author__r.firstName, author__r.lastName, AuthorCountry__c,
            author__c, author__r.name, author__r.email, ApprovalAcceptedDate__c, ApprovalSentDate__c, InviteAcceptedDate__c, Approval_Rejected_Date__c,ReasonToDeclineApproval__c,
            InviteSentDate__c, AuthorStatus__c,Rationale__c,author__r.userId__c,Site_Investigator_PI__c,Justification_for_invite__c,Justification_for_Approval__c,
            author__r.MailingStreet, author__r.MailingCity, author__r.MailingState, author__r.MailingPostalCode, author__r.MailingCountry,
            author__r.SponsoringDept__c, author__r.SponsoringDept__r.name,Author_Address__c ,Author_Address__r.Street_Address__c,Author_Address__r.State_Province__c,
            author__r.SponsoringDept__r.OrganizationId__c,Author_Address__r.Address_Line_2__c,Author_Address__r.City__c,
            author__r.SponsoringDept__r.OrganizationId__r.name,Disclaimer_ID__c,Author_Address__r.Country__c,Author_Address__r.Zip_Postal_Code__c,  
            AuthorOrder__c, GrantDraftAccess__c, author__r.EmailBouncedDate, author__r.EmailBouncedReason,publication__r.isPlanning__c,publication__r.GPP_Type__c,Publication__r.Current_FPRCycle_Id_Formula__c,Publication__r.Current_Status_FormulaField__c,// Appear Enhancement R3 - GPP_Type and isPlanning added current FPR cycle for onbehalf comment
            CommentReceivedDate__c, // Appear Enhancement R4, CommentReceivedDate__c field added in Pub Author Query
            Approval_Disclaimer_ID__c,Invite_Rejected_Date__c //Appear Enhancement 2017 Backlog R3 : Issue id 106 
            from PubAuthor__c
            where Publication__c = :PubId and isLogicallyDeleted__c = false // Appear Enhancement R3 remove author
            order by AuthorOrder__c, author__r.lastName
        ]; 
        return authors;
    }
        
    /////////////// clone ///////////////
    public static void clone(Id origPubId, Id destCloneId) {
        List<PubAuthor__c> origList = getPubAuthors(origPubId);
        
        List<PubAuthor__c> destList = new List<PubAuthor__c>();
        for(PubAuthor__c record : origList){
            PubAuthor__c clone = record.clone(false, true, false, false);
            clone.Publication__c = destCloneId;
            clone.ApprovalSentDate__c = null; //Appear Enhancement R2 Clone restriction
            clone.ApprovalAcceptedDate__c = null; //Appear Enhancement R2 Clone restriction
            clone.Approval_Rejected_Date__c = null; //Appear Enhancement R2 Clone restriction
            clone.ReasonToDeclineApproval__c = null; //Appear Enhancement R2 Clone restriction
            clone.Justification_for_Approval__c = null; //Appear Enhancement R2 Clone restriction
            clone.GrantDraftAccess__c = false; //Appear Enhancement R2 Clone restriction
            //CHG0052237- Enabling Draft-Share for Authors in Cloned publication
            if(!(record.AuthorStatus__c=='Pending Invite Delivery'||record.AuthorStatus__c=='Pending Invite Acceptance')){
            
                clone.AuthorStatus__c ='Publication Review by Authors';
            }
            destList.add(clone); 
        }
        
        insert destList;
    }


    public string EmailPreviewSettingOrgURL {
            get {
                OrgUrl__c orgUrl = OrgUrl__c.getOrgDefaults();
                string aURL = orgUrl.OrgURL__c; 
                return aURL;
            }           
        }
    public string EmailPreviewSettingContentURL {
            get {
                    OrgUrl__c orgUrl = OrgUrl__c.getOrgDefaults();
                    string aURL = orgUrl.ContentUrl__c;
                    return aURL; 
            }           
        }
     public id EmailPreviewSettingRelatedToId{
            get {
                for(PubAuthor__c author : delAut) {  
                        return author.id; // always return the first author
                 }
                 return null; 
            }
        }
     public id EmailPreviewSettingRecipientTypeId{
            get {
                for(PubAuthor__c author : delAut) {
                        return author.author__c; // always return the first author
                 }
                 return null; 
            }
        }
    public class ContactAuthorAddressWrapperCls{
        public Contact Con{get;set;}
        public contact_address__c conAddress{get;set;}
        public ContactAuthorAddressWrapperCls(contact c,contact_address__c con){
            this.con = c;
            this.conAddress=con;
        }
    }

    ///////////////  JS Remote support //////////////////
    public static List<Contact> findAuthorsByName(string startWith){
        List<Contact> contacts = new List<Contact>();
        List<ContactAuthorAddressWrapperCls>  wrapcon = new List<ContactAuthorAddressWrapperCls>();
        List<Contact_Address__c> ContAddresses = New List<Contact_Address__c>();
        if ( startWith.contains(',')) {
            //search pattern - LastName*, FirstName*
            
            //eliminate space
            startWith.replace(' ', '');
            string[] argu = startWith.splitByCharacterType();
            string lastName = argu[0]+'%';
            string firstName = argu[2] + '%';
            
            /***ContAddresses = [
                select id, Street_Address__c,Contact_Name__r.Name,
                Address_Line_2__c, City__c, Email__c, Primary_Address__c,Zip_Postal_Code__c, State_Province__c From Contact_Address__c 
                where Contact_Name__r.LastName like :lastName
                and Contact_Name__r.FirstName like :firstName
                order by Name
                limit 25
            ];
            
            **/
            contacts = [
                select id, name, email,
                MailingStreet, MailingCity, MailingState, MailingPostalCode,MailingCountry,Country__c
                From Contact 
                where LastName like :lastName
                and FirstName like :firstName
                order by Name
                limit 25
            ];
            
            
        } else {
        
            string startWithParam = startWith + '%';
            /***List<Contact_Address__c> lastNameContAddresses =[
                select id, Street_Address__c,
                Address_Line_2__c, City__c, Email__c, Contact_Name__r.Name,Primary_Address__c,Zip_Postal_Code__c,State_Province__c From Contact_Address__c 
                where Contact_Name__r.LastName like :startWithParam 
                order by Contact_Name__r.FirstName
                limit 25
            ];
            
            ***/
            List<Contact> lastNameContacts = [
                select id, name, email,
                MailingStreet, MailingCity, MailingState, MailingPostalCode,MailingCountry,Country__c
                From Contact 
                where LastName like :startWithParam
                order by Name
                limit 25
            ];
            
            /***List<Contact_Address__c> FirstNameContAddresses =[
                select id, Street_Address__c,
                Address_Line_2__c, City__c, Email__c,Contact_Name__r.Name, Primary_Address__c,Zip_Postal_Code__c,State_Province__c From Contact_Address__c 
                where Contact_Name__r.FirstName like :startWithParam and Primary_Address__c =:true
                order by Contact_Name__r.FirstName
                limit 25
            ];
            ****/
            
            List<Contact> firstNameContacts = [
                select id, name, email,
                MailingStreet, MailingCity, MailingState, MailingPostalCode,MailingCountry,Country__c
                From Contact 
                where FirstName like :startWithParam
                order by Name
                limit 25
            ];
            
            if ( firstNameContacts.size() == 0 && lastNameContacts.size() == 0) {
                string containParam = '%' + startWith + '%';
                List<Contact> containContacts = [
                    select id, name, email,
                    MailingStreet, MailingCity, MailingState, MailingPostalCode,MailingCountry,Country__c
                    From Contact 
                    where Name like :containParam 
                    order by Name
                    limit 25
                ];
                contacts.addAll(containContacts);
            } else {
                contacts.addAll(firstNameContacts);
                contacts.addAll(lastNameContacts);
            }
            /***
            
            if ( FirstNameContAddresses .size() == 0 && LastNameContAddresses .size() == 0) {
                string containParam = '%' + startWith + '%';
                List<Contact_Address__c> ContainContAddresses =[
                    select id, Street_Address__c,Contact_Name__r.Name,
                Address_Line_2__c, City__c, Email__c, Primary_Address__c,Zip_Postal_Code__c,State_Province__c From Contact_Address__c 
                where Contact_Name__r.Name like :containParam
                order by Contact_Name__r.Name
                limit 25
                ];
                ContAddresses.addAll(ContainContAddresses);
            } else {
                ContAddresses.addAll(FirstNameContAddresses);
                ContAddresses.addAll(LastNameContAddresses);
            }***/
    }
    
        /*** for(Contact_Address__c c : ContAddresses){
            if (c.email__c == null) c.email__c = '';
            if (c.Street_Address__c == null ) c.Street_Address__c = '';
            if (c.Address_Line_2__c == null ) c.Address_Line_2__c = '';
            if (c.City__c == null ) c.City__c = '';
            if (c.Zip_Postal_Code__c == null ) c.Zip_Postal_Code__c = '';
            
        }
        
        return ContAddresses;  
    ***/
        
        for(contact c : Contacts){
            if (c.email == null) c.email = '';
            if (c.MailingStreet == null ) c.MailingStreet = '';
            if (c.MailingCity == null ) c.MailingCity = '';
            if (c.MailingState == null ) c.MailingState = '';
            if (c.MailingPostalCode == null ) c.MailingPostalCode = '';
            if (c.MailingCountry == null ) c.MailingCountry = '';
            if (c.Country__c == null) c.Country__c = '';
            
        }
        
        return contacts;
        
        
             
    }
    
}