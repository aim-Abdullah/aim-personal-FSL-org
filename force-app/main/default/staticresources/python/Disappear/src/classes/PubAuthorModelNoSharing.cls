public without sharing class PubAuthorModelNoSharing {
  
    public static final string sPendingInviteDelivery = 'Pending Invite Delivery';
    public static final string sPendingInviteAcceptance = 'Pending Invite Acceptance'; 
    public static final string sInviteCancelled = 'Invite Cancelled';
    public static final string sPublicationReviewByAuthors = 'Publication Review by Authors';
    public static final string sPendingAuthorApproval = 'Pending Author Approval';
    public static final string sCompletedAuthorApproval = 'Completed Author Approval';
    public static final string sApprovalRejected = 'Approval Rejected';
    
    public static final string sOprInvite = 'Invite';
    public static final string sOprUpdate = 'Update';    
    public static final string sOprApprove = 'Approve';
    
    
    private Id pPubId = null;
    private Id pPubAuthorId = null;
    private pubAuthor__c pPubAuthorRecord = null; 
    private string ActiveTile;   
    private string ActiveSubMenu;  
    

    public PubAuthorModelNoSharing(Id PubId) {
        // to do: validate if the current user (author) is part of the author? 
        this.pPubId = PubId;
    }
  
    public PubAuthorModelNoSharing(Id PubId, string sActiveSubMenu) {
        // to do: validate if the current user (author) is part of the author? 
        this.ActiveSubMenu = sActiveSubMenu;
        this.pPubId = PubId;
    }

    private string pParamPubAuthorId = null;
    public string ParamPubAuthorId {
        get {
            if (pParamPubAuthorId == null) {
                pParamPubAuthorId = AppearBaseController.PageParameters.get(AppearConstants.PUBAUTHORID);
            }
            return pParamPubAuthorId;
        }
    }
    
    public Id PubId {
        get {
            if (pPubId == null){
                  AppLogModel.LogError('PubAuthorModelNoSharing::PubId', 'Missing Pub Id - please contact Support');                
            }
            return pPubId;
        }
        set {
            pPubId = value; 
        }
    } 
    
     public Id PubAuthorId {
        get {
            // to do: get from parameters and user key reference. 
            if (pPubAuthorId == null ){
                // get pubAuthorId based upon current user and active pubId
                pPubAuthorRecord = findPubAuthorRecord(this.pPubId, UserInfo.getUserId());
                if (pPubAuthorRecord != null)
                    pPubAuthorId = pPubAuthorRecord.id;
            }
            return pPubAuthorId;
        }
        set {
            pPubAuthorId = value; 
        }
    }  
    
    public pubAuthor__c PubAuthorRecord {
        get {
            if (pPubAuthorRecord == null){
                pPubAuthorRecord = findPubAuthorRecord(this.pPubId, UserInfo.getUserId());
            }
            return pPubAuthorRecord; 
        }
    }
    

    public static boolean IsAuthorComm{
        get{
            // note url model only works with desktop app but not in sf1 app
            return AppearURLModel.IsAuthorComm;
        }   
    }
    

  public static id getLatestInviteDisclaimerId(){
    try {
        ProvisionDocumentVersion__c comp = [SELECT id, ProvisionDocumentContent__c, Name
                      FROM ProvisionDocumentVersion__c ORDER BY createddate Desc limit 1]; 
        if (comp != null) return comp.id;
        else return null;
        /***Document cv = [select id from Document Where Name like '%Author Invitation Disclaimer%' limit 1];
        if (cv != null) return cv.id;
         else return null;**/
      } catch (exception e){
            return null; 
      }
  } 



  private map<id, string> pApprovePubAuthorAttachmentMap; 
  public map<id, string> ApprovePubAuthorAttachmentMap{
    get{
        if (pApprovePubAuthorAttachmentMap == null){
            pApprovePubAuthorAttachmentMap = new map<id, string> (); 
            id AttachId = null;
            
            for ( pubAuthor__c aPubAuthor:  MyAuthorPubApproveList){
                AttachId = PubAuthorModelNoSharing.getLatestPubAuthorAttachmentId(aPubAuthor.publication__c ); 
                if (  AttachId == null  ){
                    pApprovePubAuthorAttachmentMap.put(aPubAuthor.publication__c , ''); 
                } else {
                    pApprovePubAuthorAttachmentMap.put(aPubAuthor.publication__c, AttachId); 
                }
            }
        }
       return pApprovePubAuthorAttachmentMap; 
    }
    
  }

  
  
  public static id getLatestPubAuthorAttachmentId(id aPubId){
    
     try {
      PubAttachmentDetails__c aPubDetail =
       // IY: to do - add additonal logic/filter such as fpr cycle 
       // [select id,Attachment_URL__c from PubAttachmentDetails__c where Publication__c = :aPubId  order by CreatedDate desc  limit 1 ];
       //[select id,Attachment_URL__c, FPR_Cycle__c, AttachmentType__c from PubAttachmentDetails__c where Publication__c = :aPubId  and AttachmentType__c = 'Final Attachment for Author Approval'  and isLogicallyDeleted__c = false   order by FPR_Cycle__c desc, CreatedDate desc  limit 1 ];
       [select id,Attachment_URL__c, FPR_Cycle__c, AttachmentType__c from PubAttachmentDetails__c where Publication__c = :aPubId  and AttachmentType__c = 'Final Attachment for Author Approval'  and isLogicallyDeleted__c = false   order by  FPR_Cycle__r.FPR_Cycle_Num__c desc, CreatedDate desc  limit 1 ];//Appear Enhancement R6: Discretionary Requirement DISCR0002581: Attachment Visibility 
          
        string[] urlSegments = aPubDetail.Attachment_URL__c.split('/', 0);
        if (urlSegments != null && urlSegments.size() > 0) {
            return urlSegments[urlSegments.size() - 1];
        } else return null;
         
     } catch (Exception e){
        System.debug('PubAuthorModelNoSharing::getLatestPubAuthorAttachmentId = '+e.getMessage());
        return null; 
     }
     
  }
  //=====================
 // Appear Enhancment R3
 // =====================
//Start - Latest Draft-Share Attachment ID is returned by this method
   public static id getLatestPubAuthorDraftShareId(id aPubId){
    
     try {
      PubAttachmentDetails__c aPubDetail =
       // IY: to do - add additonal logic/filter such as fpr cycle 
       // [select id,Attachment_URL__c from PubAttachmentDetails__c where Publication__c = :aPubId  order by CreatedDate desc  limit 1 ];
       [select id,Attachment_URL__c, FPR_Cycle__c, AttachmentType__c from PubAttachmentDetails__c where Publication__c = :aPubId  and AttachmentType__c = 'Draft - Share with Authors'  and isLogicallyDeleted__c = false   order by FPR_Cycle__c desc, CreatedDate desc  limit 1 ];
         
        string[] urlSegments = aPubDetail.Attachment_URL__c.split('/', 0);
        if (urlSegments != null && urlSegments.size() > 0) {
            return urlSegments[urlSegments.size() - 1];
        } else return null;
         
     } catch (Exception e){
        System.debug('PubAuthorModelNoSharing::getLatestPubAuthorAttachmentId = '+e.getMessage());
        return null; 
     }
     
  }
  //End - Latest Draft-Share Attachment ID is returned by this method 
    
    
    
//======================
 // Appear Enhancment R3
 // ====================
  
  public id pubIdForAttachment{
    get; set; 
  }
  public void remoteSetPubIdForAttachment() {
        // a placeholder for apex:actionFunction to set pubIdForAttachment
        // side note:  The substitution of merge fields for their actual values only occurs on the rendering phase. 
        // Meaning that a controller variable's value will not be updated in javascript unless you rerender the script tag.
        System.debug('remoteSetPubIdForAttachment /  pubIdForAttachment = '+ pubIdForAttachment);
  }
  
  public id currentPubAuthorAttachmentId {
    get {
        // return the latest pub attachment for the pub in context. this is used for final approval
        return getLatestPubAuthorAttachmentId(pubIdForAttachment);
    }
  }
  
  
  public Document getDocumentById(Id docId){
        Document cv = [select id from Document Where id = :docId limit 1];
        return cv; 
  }
  
  public pagereference getInviteDisclaimerVersionPage(){            

        Id Cvid = null;
        if (PubAuthorRecord != null){
            Cvid = PubAuthorRecord.Disclaimer_ID__c; 
            pagereference pageref = new Pagereference((AppearURLModel.IsAuthorComm? '/PubAuthor': '')+ '/servlet/servlet.FileDownload?file='+Cvid);
            return pageref; 
        } else {
            return null; 
        }
   }     

  public string getApproveAttachmentURL(){

        Id Cvid = null;
        if (pPubAuthorRecord != null){
            Cvid = pPubAuthorRecord.Approval_Disclaimer_ID__c; // this is actually the attachment id; 
        }
        try {
            PubAttachmentDetails__c aPubDetail = [select id,Attachment_URL__c from PubAttachmentDetails__c where id = :Cvid limit 1 ]; 
            if (aPubDetail != null){
                return   aPubDetail.Attachment_URL__c;          
            } else {
                return ''; 
            }
        } catch (Exception e){
            return ''; 
        }
   }        
       
  public static pubAuthor__c findPubAuthorRecord(id aPubId, id aUserId) {       
         
        pubAuthor__c aPubAuthor = null;
        
        AppLogModel.LogDebug('PubAuthorModelNoSharing::findPubAuthorRecord','Started', aPubId);
                 
        Set<id> appearUserContactSet = findContactForAppearUser(aUserId);
        
        try {

            List<pubAuthor__c> pubAuthors = [
                    select   AuthorStatus__c, publication__c, author__c, author__r.name, author__r.email, AuthorOrder__c,
                    InviteSentDate__c, Disclaimer_ID__c, Approval_Disclaimer_ID__c, ApprovalSentDate__c
                     from pubAuthor__c where author__c in  :appearUserContactSet 
                     and Publication__c = :aPubId
                     and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
                ];
                
            if (pubAuthors.size() == 0) {
                    // no pubs, log this event
                    string msg = 'PubAuthorModelNoSharing::findPubAuthorRecord - cannot find Pub Author for = '+ aPubId ;
                    System.Debug(msg);
                    AppLogModel.LogInfo('PubAuthorModelNoSharing::findPubAuthorRecord', msg, aPubId);
                    aPubAuthor = null; 
            } else {
                // At this point, we should have 1 and only 1 Pub__c record
                aPubAuthor = pubAuthors[0]; 
            } 

        } catch(Exception ex){
            ApexPages.addMessages(ex);
            AppLogModel.LogError('PubAuthorModelNoSharing::findPubAuthorRecord', 'Exception'+ ex, aPubId);
            aPubAuthor = null; 
        }

        AppLogModel.flushLogs();
        return aPubAuthor; 
    
    }
    
    
    public static Set<Id> findContactForAppearUser(Id appearUserId) {
        
        if ( appearUserId == null) return null;     
        Set<id> userContactIdSet = new Set<id>();
        
        // Note: can't depend upon AppearUrlModel.IsAuthorComm. It won't work for mobile since URL in SF1 is not pointing to community
        
        if (ProfileModel.isAppearPortalPubAuthor || ProfileModel.isAppearFprOnlySubmitter) {
            List<User> users = [   
                Select id, ContactId
                from User
                where id = :appearUserId
            ];
    
            for(User u : users) {
                userContactIdSet.add(u.ContactId);
            }
        } else {
            List<Contact> contacts = [
                Select id
                from Contact
                where UserId__c = :appearUserId
            ];
            
            for(contact c : contacts){
                userContactIdSet.add(c.id);
            }
        }


/*
        List<User> users = [   // if (ProfileModel.isAppearPortalPubAuthor) 
            Select id, ContactId
            from User
            where id = :appearUserId
        ];
        
        if (users.size() >0 ) {  // always try to get contact from users record first. 
            for(User u : users) {
                userContactIdSet.add(u.ContactId);
            }
        } else {
            List<Contact> contacts = [
                Select id
                from Contact
                where UserId__c = :appearUserId
            ];
            
            for(contact c : contacts){
                userContactIdSet.add(c.id);
            }
        }
*/      
        return userContactIdSet;
    }

  
    private transient List<PubAuthor__c> pPubAuthorList = null;
    public List<PubAuthor__c> PubAuthorList {
        get {
            if (PubId == null) return null; 
            
            if (pPubAuthorList == null) {
                pPubAuthorList = getPubAuthors(this.PubId);
            }
            return pPubAuthorList;
            
        }  
    }
    
    public static List<PubAuthor__c> getPubAuthors(id PubId){
        List<PubAuthor__c> authors = [
            select publication__c, isSelected__c, author__r.firstName, author__r.lastName, AuthorCountry__c,
            author__c, author__r.name, author__r.email, 
            author__r.MailingStreet, author__r.MailingCity, author__r.MailingState, author__r.MailingPostalCode, author__r.MailingCountry,
            author__r.SponsoringDept__c, author__r.SponsoringDept__r.name, 
            author__r.SponsoringDept__r.OrganizationId__c,
            author__r.SponsoringDept__r.OrganizationId__r.name,
            Publication__r.Name,AuthorStatus__c,
            Publication__r.Publication_Title__c,
            AuthorOrder__c
            from PubAuthor__c
            where Publication__c = :PubId
            and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
            order by AuthorOrder__c, author__r.lastName
        ]; 
        return authors;
    }   

    public static List<Publication__c> checkPublicationId (Id pPubId){
            // used in BaseController 
            List<Publication__c> publist= [select id, isDeleted from Publication__c where id = :pPubId];
            return publist; 
    }

    private Publication__c pPubRecord = null;
    public Publication__c PubRecord {
        get {
                if (PubId == null) {
                        pPubRecord = null;
                        return null; 
                } else if (pPubRecord == null) {
    
                    List<Publication__c> pubs = [ 
                    Select Name, PubType__r.Name, Publication_Title__c,  Current_Status_FormulaField__c, Current_Target__c,
                    Target_Submission_Date__c, Authors__c,CommentsByAuthors__c, CommentsForAllAuthors__c, 
                    p.PubStatus__r.Status__c, p.PubStatus__r.Status__r.Name, p.PubStatus__r.Status__r.displayOrder__c, 
                    p.Current_SubmissionCycle_Id_Formula__c, p.Current_FPRCycle_Id_Formula__c, p.Product_Indication__c, p.Publication_Type__c
                    From Publication__c p
                    where Id = :PubId 
                ];
                    
                if (pubs.size() == 0) {
                    // wrong pub, log this event
                    string msg = 'PubAuthorModelNoSharing::constructor - cannot load PubId = '+PubId+' please check if user has access';
                    System.Debug(msg);
                    AppLogModel.LogInfo('PubAuthorModelNoSharing::constructor', msg, pubId);
                    pPubRecord = null; 
                } else {
                    // At this point, we have 1 and only 1 Pub__c record
                    pPubRecord = pubs[0];
                    
                }
            }
            return pPubRecord; 
        }
        
    }

 // *** accessors 
   public string CommentsByAuthors {
        get { 
            if ( pubRecord == null) {
                AppLogModel.LogError('PubAuthorModelNoSharing::CommentsByAuthors__c', 'Invalid Publication - please contact Support');
                return '';
            } else {
                return pubRecord.CommentsByAuthors__c;
            }
        }
        set {
            if ( pubRecord == null) {
                AppLogModel.LogError('PubAuthorModelNoSharing::CommentsByAuthors__c', 'Invalid Publication - please contact Support');
            } else {
                pubRecord.CommentsByAuthors__c = value;
            }
        }
    }


    public Id CurrentSubmissionCycleId {
        get {
            if (pubRecord == null || pubRecord.Current_FPRCycle_Id_Formula__c == null){
                return null;
            } else {
            return pubRecord.Current_SubmissionCycle_Id_Formula__c;
            }
        }
    }
    
    
    public Id CurrentFprCycleId {
        get {
            if (pubRecord == null || pubRecord.Current_FPRCycle_Id_Formula__c == null){
                return null;
            } else {
                return pubRecord.Current_FPRCycle_Id_Formula__c;
            }
        }
    }

    public integer CurrentFprCycleNum {
        get {
            if (pubRecord == null || pubRecord.Current_FPRCycle_Id_Formula__c == null){
                return 0;
            } else {
                return Integer.ValueOf(pubRecord.Current_FPR_Cycle_Num__c);
            }
        }
    }

   public List<SelectOption> getAuthorMyRequestOptions() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('all','All Publications'));
        options.add(new SelectOption('pending invites','Pending Invites'));
        options.add(new SelectOption('in progress publications','Publication Updates'));
        options.add(new SelectOption('pending approvals','Pending Approvals'));
        //options.add(new SelectOption('completed approvals','Completed Approvals'));
        //options.add(new SelectOption('closed publications','Closed Publications'));
        return options;
    }

    private static string pSelectedAuthorMyRequestOption;
    public string SelectedAuthorMyRequestOption{
        get{        
            return findSelectedAuthorMyRequestOption();
        }
        set{
            pSelectedAuthorMyRequestOption = value;
        }
    }
    
    private static string findSelectedAuthorMyRequestOption() {       
            if (pSelectedAuthorMyRequestOption == null) {
                pSelectedAuthorMyRequestOption = 'pending invites';
            }           
            return pSelectedAuthorMyRequestOption;
    } 

    public boolean IsSelectedAuthorRequestMainDetail{
        
        get {
            boolean result = true; 
            
            if (findSelectedAuthorMyRequestOption() == 'pending invites'){
                 result = true; 
            } else if (findSelectedAuthorMyRequestOption() == 'pending approvals'){
                 result = true; 
            } else if (findSelectedAuthorMyRequestOption() == 'closed publications'){
                 result = true; 
            } else if (findSelectedAuthorMyRequestOption() == 'in progress publications'){
                 result = false; 
            } else if (findSelectedAuthorMyRequestOption() == 'completed approvals'){
                 result = true; 
            } else  if (findSelectedAuthorMyRequestOption() == 'all'){
                 result = true; 
            }
            
            return result; 
        }   
    }

    
    public boolean IsSelectedAuthorRequestCollaboration{
        
        get {
            boolean result = false; 
            
            if (findSelectedAuthorMyRequestOption() == 'pending invites'){
                 result = false; 
            } else if (findSelectedAuthorMyRequestOption() == 'pending approvals'){
                 result = false; 
            } else if (findSelectedAuthorMyRequestOption() == 'closed publications'){
                 result = false; 
            } else if (findSelectedAuthorMyRequestOption() == 'in progress publications'){
                 result = true; 
            } else if (findSelectedAuthorMyRequestOption() == 'completed approvals'){
                 result = false; 
            } else  if (findSelectedAuthorMyRequestOption() == 'all'){
                 result = false; 
            }       
            return result; 
        }   
    }

    private transient List<pubAuthor__c> pMyAuthorPubStatusList = null;
    // don't use lazy loading to support form reload
    public List<pubAuthor__c> MyAuthorPubStatusList {
        get {
            pMyAuthorPubStatusList = findMyAuthorPubStatusList(UserInfo.getUserId(), false);
            return pMyAuthorPubStatusList;
        }
    } 
    

    private transient List<pubAuthor__c> pMyAuthorPubPendingAccessList = null;
    public List<pubAuthor__c> MyAuthorPubPendingAccessList {
        get {
            if (pMyAuthorPubPendingAccessList == null){
                pMyAuthorPubPendingAccessList = getMyAuthorPubStatusList(UserInfo.getUserId(), false, 'pending access');
            }
            return pMyAuthorPubPendingAccessList;
        }
    } 
    public decimal MyAuthorPubPendingAccessListCount{
        get {
            if (MyAuthorPubPendingAccessList != null){
                return  MyAuthorPubPendingAccessList.size();
            } else {
                return 0; 
            }
        }       
    }
    
    
    private transient List<pubAuthor__c> pMyAuthorPubInviteList = null;
    public List<pubAuthor__c> MyAuthorPubInviteList {
        get {
            if (pMyAuthorPubInviteList == null){
                pMyAuthorPubInviteList = getMyAuthorPubStatusList(UserInfo.getUserId(), false, 'Pending Invites');
            }
            return pMyAuthorPubInviteList;
        }
    } 
    public decimal MyAuthorPubInviteListCount{
        get {
            if (MyAuthorPubInviteList != null){
                return  MyAuthorPubInviteList.size();
            } else {
                return 0; 
            }
        }       
    }

    private transient List<pubAuthor__c> pMyAuthorPubApproveList = null;
    public List<pubAuthor__c> MyAuthorPubApproveList {
        get {
            if (pMyAuthorPubApproveList == null){
                pMyAuthorPubApproveList = getMyAuthorPubStatusList(UserInfo.getUserId(), false, 'Pending Approvals');
            }
            return pMyAuthorPubApproveList;
        }
    } 
    public decimal MyAuthorPubApproveListCount{
        get {
            if (MyAuthorPubApproveList != null){
                return  MyAuthorPubApproveList.size();
            } else {
                return 0; 
            }
        }       
    }
    
    private transient List<pubAuthor__c> pMyAuthorPubReviewList = null;
    public List<pubAuthor__c> MyAuthorPubReviewList {
        get {
            if (pMyAuthorPubReviewList == null){
                pMyAuthorPubReviewList = getMyAuthorPubStatusList(UserInfo.getUserId(), false, 'In Progress Publications');
            }
            return pMyAuthorPubReviewList;
        }
    } 
   public decimal MyAuthorPubReviewListCount{
        get {
            if (MyAuthorPubReviewList != null){
                return  MyAuthorPubReviewList.size();
            } else {
                return 0; 
            }
        }       
    }
    
    private List<pubAuthor__c> pMyAuthorPubStatusFullList = null;
    public List<pubAuthor__c> MyAuthorPubStatusFullList {
        get {
            if (pMyAuthorPubStatusFullList == null){
                // load all status, including empty to ensure that AuthorApprovedMap, pPendingAuthorApprovalMap always has a match
                pMyAuthorPubStatusFullList = getMyAuthorPubStatusList(UserInfo.getUserId(), true, 'all');
            }
            return pMyAuthorPubStatusFullList;
        }
    } 


   public static List<pubAuthor__c> getMyAuthorPubStatusList(Id userId, Boolean includeNullStatus, String statusList) {       
         
        AppLogModel.LogDebug('PubAuthorModelNoSharing::getMyAuthorPubStatusList','Started, UserId: ' + userId, userId);
        Set<id> appearUserContactSet = findContactForAppearUser(userId);
        AppLogModel.LogDebug('PubAuthorModelNoSharing::getMyAuthorPubStatusList','User Contact Set:' + appearUserContactSet.size(), userId);
        set<string> statusesToInclude = new set<string>();
        boolean grantAccessParam = false;
        boolean pendingAccessParam = false; 
        if (statusList== 'pending invites'){
            statusesToInclude.add(StatusModel.AuthorPendingInviteAcceptance);
        } else if (statusList== 'pending approvals'){
            statusesToInclude.add(StatusModel.AuthorPendingAuthorApproval);
        } else if (statusList== 'closed publications'){
            statusesToInclude.add(StatusModel.AuthorCompletedAuthorApproval);
            statusesToInclude.add(StatusModel.AuthorInviteCancelled);
            statusesToInclude.add(StatusModel.AuthorApprovalRejected);  
        } else if (statusList== 'in progress publications'){
            //statusesToInclude.add(StatusModel.AuthorPendingAuthorApproval);        
            statusesToInclude.add(StatusModel.AuthorPublicationReviewbyAuthors);
            grantAccessParam = true;
        } else if (statusList== 'completed approvals'){
            statusesToInclude.add(StatusModel.AuthorCompletedAuthorApproval);
        } else  if (statusList== 'all'){
            // return all by default
            statusesToInclude.add(StatusModel.AuthorPendingInviteDelivery);     
            statusesToInclude.add(StatusModel.AuthorPendingInviteAcceptance);
            statusesToInclude.add(StatusModel.AuthorPublicationReviewbyAuthors);
            statusesToInclude.add(StatusModel.AuthorPendingAuthorApproval);
            statusesToInclude.add(StatusModel.AuthorCompletedAuthorApproval);
            statusesToInclude.add(StatusModel.AuthorInviteCancelled);
            statusesToInclude.add(StatusModel.AuthorApprovalRejected);  
            if (includeNullStatus) statusesToInclude.add('');   // authorStatus field should not be empty normally 
        } else  if (statusList== 'pending access'){
            statusesToInclude.add(StatusModel.AuthorPublicationReviewbyAuthors);
            pendingAccessParam = true;
        }
        //Appear Enhancement R3 : isLogicallyDelete field added for Soft Delete Author functionality
        string queryStr = 'select id, Name, ApprovalAcceptedDate__c, ApprovalSentDate__c, AuthorStatus__c,  InviteAcceptedDate__c, InviteSentDate__c, '+ 
                                    'Publication__c,  Publication__r.Publication_Title__c,  Publication__r.Name, Publication__r.Current_Target__C, '+
                                    'Publication__r.CommentsForAllAuthors__c, Publication__r.Publication_Type__c, Approval_Disclaimer_ID__c, By_Date_Time__c, Please_respond_by_For_Approval__c '+
                                    'from pubAuthor__c '+ 
                                    'where author__c in  :appearUserContactSet '+
                                    'and authorStatus__c in :statusesToInclude '+
                                    'and isLogicallyDeleted__c = false '+
                                    (grantAccessParam ? 'and GrantDraftAccess__c =: grantAccessParam ' : '') + 
                                    (pendingAccessParam ? 'and GrantDraftAccess__c = false ' : '') +
                                    'order by By_Date_Time__c ASC, Please_respond_by_For_Approval__c ASC';
        
        List<pubAuthor__c> pubsAssignedToAuthor = Database.query(queryStr);

        AppLogModel.LogDebug('PubAuthorModelNoSharing::getMyAuthorPubStatusList','pubsAssignedToAuthor:' + pubsAssignedToAuthor.size(), userId);
                
        AppLogModel.flushLogs();
        return pubsAssignedToAuthor;
    }


   public static List<pubAuthor__c> findMyAuthorPubStatusList(Id userId, Boolean includeNullStatus) {       
         
        AppLogModel.LogDebug('PubAuthorModelNoSharing::findMyAuthorPubStatusList','Started, UserId: ' + userId, userId);
        Set<id> appearUserContactSet = findContactForAppearUser(userId);
        AppLogModel.LogDebug('PubAuthorModelNoSharing::findMyAuthorPubStatusList','User Contact Set:' + appearUserContactSet.size(), userId);
        set<string> statusesToInclude = new set<string>();
        boolean grantAccessParam = false;
        if (findSelectedAuthorMyRequestOption() == 'pending invites'){
            statusesToInclude.add(StatusModel.AuthorPendingInviteAcceptance);
        } else if (findSelectedAuthorMyRequestOption() == 'pending approvals'){
            statusesToInclude.add(StatusModel.AuthorPendingAuthorApproval);        
        } else if (findSelectedAuthorMyRequestOption() == 'closed publications'){
            statusesToInclude.add(StatusModel.AuthorCompletedAuthorApproval);
            statusesToInclude.add(StatusModel.AuthorInviteCancelled);
            statusesToInclude.add(StatusModel.AuthorApprovalRejected);  
        } else if (findSelectedAuthorMyRequestOption() == 'in progress publications'){
            //statusesToInclude.add(StatusModel.AuthorPendingAuthorApproval);        
            statusesToInclude.add(StatusModel.AuthorPublicationReviewbyAuthors);
            grantAccessParam = true;
        } else if (findSelectedAuthorMyRequestOption() == 'completed approvals'){
            statusesToInclude.add(StatusModel.AuthorCompletedAuthorApproval);
        } else  if (findSelectedAuthorMyRequestOption() == 'all'){
            // return all by default
            statusesToInclude.add(StatusModel.AuthorPendingInviteDelivery);     
            statusesToInclude.add(StatusModel.AuthorPendingInviteAcceptance);
            statusesToInclude.add(StatusModel.AuthorPublicationReviewbyAuthors);
            statusesToInclude.add(StatusModel.AuthorPendingAuthorApproval);
            statusesToInclude.add(StatusModel.AuthorCompletedAuthorApproval);
            statusesToInclude.add(StatusModel.AuthorInviteCancelled);
            statusesToInclude.add(StatusModel.AuthorApprovalRejected);  
            if (includeNullStatus) statusesToInclude.add('');   // authorStatus field should not be empty normally 
        }
        //Appear Enhancement R3 : isLogicallyDelete field added for Soft Delete Author functionality
        string queryStr = 'select id, Name, ApprovalAcceptedDate__c, ApprovalSentDate__c, AuthorStatus__c,  InviteAcceptedDate__c, InviteSentDate__c, '+ 
                                    'Publication__c,  Publication__r.Publication_Title__c,  Publication__r.Name, Publication__r.CommentsForAllAuthors__c, '+
                                    'Publication__r.Publication_Type__c, Approval_Disclaimer_ID__c, By_Date_Time__c, Please_respond_by_For_Approval__c '+
                                    'from pubAuthor__c '+
                                    'where author__c in  :appearUserContactSet '+ 
                                    'and authorStatus__c in :statusesToInclude '+
                                    'and isLogicallyDeleted__c = false '+
                                    (grantAccessParam ? 'and GrantDraftAccess__c =: grantAccessParam ' : '') +
                                    'order by By_Date_Time__c ASC, Please_respond_by_For_Approval__c ASC';
        
        List<pubAuthor__c> pubsAssignedToAuthor = Database.query(queryStr);
        
        AppLogModel.LogDebug('PubAuthorModelNoSharing::findMyAuthorPubStatusList','pubsAssignedToAuthor:' + pubsAssignedToAuthor.size(), userId);
                
        AppLogModel.flushLogs();
        return pubsAssignedToAuthor;
    }

    private transient Map<id, boolean > pPendingAuthorApprovalMap; 
    public Map<id, boolean> PendingAuthorApprovalMap{
        get 
        {if (pPendingAuthorApprovalMap == null){
            pPendingAuthorApprovalMap = new map<id, boolean>();
            for (pubAuthor__c myPubAuthor:  MyAuthorPubStatusFullList) { // use full status list to handle exceptional case 
                boolean isPendingAuthorApproval = myPubAuthor.AuthorStatus__c == sPendingAuthorApproval? true: false; 
                pPendingAuthorApprovalMap.put(myPubAuthor.id, isPendingAuthorApproval); 
            }
        }
        return pPendingAuthorApprovalMap; 
        }
    }

    private transient Map<id, boolean > pAuthorInviteAccepetedMap; 
    public Map<id, boolean> AuthorInviteAccepetedMap{
        get 
        {if (pAuthorInviteAccepetedMap == null){
            pAuthorInviteAccepetedMap = new map<id, boolean>();
            for (pubAuthor__c myPubAuthor:  MyAuthorPubStatusFullList) { // use full status list to handle exceptional case 
                boolean isAuthorAccepted = IsAuthorAcceptedInvite (myPubAuthor.AuthorStatus__c); 
                pAuthorInviteAccepetedMap.put(myPubAuthor.id, isAuthorAccepted); 
            }   
        }
        return pAuthorInviteAccepetedMap; 
        }
    }
    
    private Map<id, boolean > pAuthorApprovedMap; 
    public Map<id, boolean> AuthorApprovedMap{
        get 
        {if (pAuthorApprovedMap == null){
            pAuthorApprovedMap = new map<id, boolean>();
            for (pubAuthor__c myPubAuthor:  MyAuthorPubStatusFullList) { // use full status list to handle exceptional case 
                boolean IsApproved = IsAuthorApproved (myPubAuthor.AuthorStatus__c); 
                pAuthorApprovedMap.put(myPubAuthor.id, IsApproved); 
            }
        }
        return pAuthorApprovedMap; 
        }
    }


    
    public static boolean IsAuthorAcceptedInvite (string authorStatus) {
        boolean result = false;
        if (authorStatus == sPendingInviteDelivery || 
            authorStatus == sPendingInviteAcceptance || 
            authorStatus == sInviteCancelled) {
            result = false;
        
        } else if (authorStatus == sPublicationReviewByAuthors || 
                   authorStatus == sPendingAuthorApproval || 
                   authorStatus == sCompletedAuthorApproval ||
                   authorStatus == sApprovalRejected
                   )  {
            result = true;
        }   
        return result; 
    }
    
    
    public static boolean IsAuthorApproved (String authorStatus) {
        boolean result = false;
        if (authorStatus == sPendingInviteDelivery || 
            authorStatus == sPendingInviteAcceptance || 
            authorStatus == sInviteCancelled ||
            authorStatus == sPublicationReviewByAuthors || 
            authorStatus == sPendingAuthorApproval || 
            authorStatus == sApprovalRejected
            ) {
            result = false;
        
        } else if (
                   authorStatus == sCompletedAuthorApproval 
                   )  {
            result = true;
        }   
        return result; 
    }
            

    public PageReference saveCommentsByAuthors() { 
        AppLogModel.LogDebug('PubAuthorModelNoSharing::SaveAuthorComments','Started', PubId);
        
         if ( pubRecord == null) {
                AppLogModel.LogError('PubAuthorModelNoSharing::SaveAuthorComments', 'Invalid Publication - please contact Support');
         } else {
                try {
                // instead of pubRecord, use a smaller set to make sure only comment field is updated. 
                publication__c updPub = [
                    select CommentsByAuthors__c
                    from publication__c
                    where id = :pubId
                    for update
                ];
                
                updPub.CommentsByAuthors__c = pubRecord.CommentsByAuthors__c;
                update  updPub; 
                

                } catch(DMLException ex){
                    ApexPages.addMessages(ex);
                    AppLogModel.LogError('PubAuthorModelNoSharing::SaveAuthorComments', 'Exception'+ ex, pubRecord.id);
                    return null; 
                }
                AppLogModel.LogInfo('PubAuthorModelNoSharing::SaveAuthorComments', 
                    'updated CommentsByAuthors__c successful', pubRecord.id);
         }
        AppLogModel.LogDebug('PubAuthorModelNoSharing::SaveAuthorComments','Ended', PubId);
        AppLogModel.flushLogs();
        return new PageReference(AppearUrlModel.AppearAuthorMenuUrl(ActiveSubMenu, AppearConstants.AuthorPubDetailsTile, pubRecord.Id));
        
        
    }
 

     public string newRejectApprovalReason{
        get; 
        set;
      } 
      
      public PageReference authorRejectPub(){
        if (PubAuthorId == null ){
            return null; 
        } else  if ( updatePubAuthorStatus (this.PubAuthorId, sApprovalRejected)){
            return new PageReference(AppearUrlModel.AppearAuthorMenuUrl(ActiveSubMenu, AppearConstants.AuthorPubDetailsTile, pubRecord.Id));
        } else {
            return null; 
        }
     }
    
     public PageReference authorApprovePub(){
        if (PubAuthorId == null ){
            return null; 
        } else  if ( updatePubAuthorStatus (this.PubAuthorId, sCompletedAuthorApproval)){
            return new PageReference(AppearUrlModel.AppearAuthorMenuUrl(ActiveSubMenu, AppearConstants.AuthorPubDetailsTile, pubRecord.Id));
        } else {
            return null; 
        }
     }
     
     public PageReference authorAcceptInvitePub(){
        if (this.PubAuthorId == null ){
            return null; 
        } else if ( updatePubAuthorStatus (this.PubAuthorId, sPublicationReviewByAuthors)){
            return new PageReference(AppearUrlModel.AppearAuthorMenuUrl(ActiveSubMenu, AppearConstants.AuthorPubDetailsTile, pubRecord.Id));            
        } else {
            return new PageReference(AppearUrlModel.AppearAuthorMenuUrl(ActiveSubMenu, AppearConstants.AuthorPubDetailsTile, pubRecord.Id));
        }
     }


    public id pubAuthorIdForInviteAccept{ get; set;}
    public PageReference acceptInviteSF1() {
        
        if (pubAuthorIdForInviteAccept != null){
            updatePubAuthorStatus(pubAuthorIdForInviteAccept, sPublicationReviewByAuthors); 
            UserPrefModel.ActivePubAuthor = pubAuthorIdForInviteAccept;
            UserPrefModel.ActivePubAuthorOpSF1 = sOprInvite; 
        }
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl()+'&activeopr=update');
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    public Id urlPubId {get;set;} // Appear Enhancement R3 : Status Approve by All author Actual date population
    public id pubAuthorIdForApprove { get; set;}
    public PageReference approvePubSF1() {
        
       AppearPubModel appPubModel = new AppearPubModel(urlPubId); //Appear Enhancement R3: Status Approve by All author Actual date population  : AppearPubModel instance 
        
        if (pubAuthorIdForApprove != null){
            updatePubAuthorStatus(pubAuthorIdForApprove, sCompletedAuthorApproval); 
            UserPrefModel.ActivePubAuthor = pubAuthorIdForApprove;
            appPubModel.PubStatus.insertfinalApprovalresponse(urlPubId); //Appear Enhancement R3: Status Approve by All author Actual date population
            UserPrefModel.ActivePubAuthorOpSF1 = sOprApprove; 
        }
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    //Start - Appear Enhancement R3: Status Approve by All author Actual date population - Publication RT update method
    public void updatePubAfterApproval(Id pubId ){
    
        Publication__c pub = [
            select id, name, pubStatus__c, Publication_Title__c, RecordTypeId,
            Current_FPR_Cycle_Num__c, Current_FPRCycle_Id_Formula__c
            from Publication__c 
            where id = :pubId
            ];
        System.debug('@@@PubAuthorModelNoSharing :: @@@updateAfterApproval1'+'@@@pubId' + pubId + pub.id +'@@PUBLIST' + pub );  
   
        List<PubStatus__c> latestPubStatusList = [
            select id, name, Publication_id__c,  ActualDate__c,
            status__c, status__r.name,  status__r.displayOrder__c, 
            Submission_Cycle__c, submission_Cycle__r.Submission_Cycle_Num__c, 
            fpr_Cycle__c, fpr_Cycle__r.FPR_Cycle_Num__c,RecordTypeId
            from PubStatus__c
            where Publication_id__c = :pub.id
            and ActualDate__c <> null
            order by 
                Submission_Cycle_Num_Formula__c desc,
                FPR_Cycle_sort_num__c desc,
                Status__r.displayOrder__c desc,
                ActualDate__c desc
            limit 1
            ];
        System.debug('@@@PubAuthorModelNoSharing :: @@@updateAfterApproval2 :: latestPubStatusList' + latestPubStatusList );
    
        PubStatus__c latestPubStatus = latestPubStatusList[0];
        Status__c statusRec = StatusModel.StatusMapById.get(latestPubStatus.Status__c);
        RecordType pubRecType = RecordTypeModel.LookupRecordType('Publication__c', statusRec.PubRecordType__c);
        System.debug('@@@PubAuthorModelNoSharing :: @@@updateAfterApproval4 :: pubRecType'+ pubRecType);
        
        if (pub.pubStatus__c <> latestPubStatus.id){    
            Publication__c updatePub = new Publication__c();
            updatePub.id = pub.id;
            updatePub.pubStatus__c = latestPubStatus.id;
            updatePub.RecordTypeId = pubRecType.id;
            System.debug('@@@PubAuthorModelNoSharing :: @@@updateAfterApproval5 :: INSIDE'+ updatePub.pubStatus__c +updatePub.RecordTypeId  );
            withoutSharingUtil.UpdatePub(updatePub);
        }    

    }    
    //End - Appear Enhancement R3: Status Approve by All author Actual date population - Publication RT update method
    
    public Id rejectPubId {get;set;} //Appear Enhancement R3: Auto Populate PubStatus 
    public id pubAuthorIdForReject {get; set;}
    public PageReference authorRejectPubSF1() {
        
        AppearPubModel appPubModel = new AppearPubModel(rejectPubId); //Appear Enhancement R3: Auto Populate PubStatus 
        if (newRejectApprovalReason == null || newRejectApprovalReason == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR , 'Please provide reason to decline');
            ApexPages.addMessage(myMsg);
            return null; 
        }
        
        
        if (pubAuthorIdForReject != null){
            updatePubAuthorStatus(pubAuthorIdForReject, sApprovalRejected); 
            appPubModel.PubStatus.insertfinalApprovalresponse(rejectPubId);//Appear Enhancement R3: Auto Populate PubStatus 
            UserPrefModel.ActivePubAuthor = pubAuthorIdForReject;
            UserPrefModel.ActivePubAuthorOpSF1 = sOprApprove; 
        }
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef; 
    }
     
     public void updatePubAuthorStatusAndInvitedDate(id LandingPubAuthorId) { 
        
         if ( LandingPubAuthorId == null ) {
                AppLogModel.LogError('PubAuthorModelNoSharing::updatePubAuthorStatusAndInvitedDate', 'Invalid Publication Author - please contact Support');
         } else {
                try {
                    // instead of pubRecord, use a smaller set to make sure only comment field is updated. 
                    pubAuthor__c PubAuth = [select id,author__r.id,publication__r.id,AuthorStatus__c,publication__c,InviteAcceptedDate__c from pubAuthor__c where Id =:LandingPubAuthorId
                                           and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
                                           ];
                    //PubId = PubAuth.Publication__c;
                    if(PubAuth.InviteAcceptedDate__c == null) { //Update the Invite Acceptance Date ONLY if it is NULL
                        PubAuth.AuthorStatus__c ='Publication Review by Authors';
                        PubAuth.InviteAcceptedDate__c= system.today();
                        update  PubAuth; 
                    }
                }catch(DMLException ex){
                    ApexPages.addMessages(ex);
                    AppLogModel.LogError('PubAuthorModelNoSharing::updatePubAuthorStatusAndInvitedDate', 'Exception'+ ex, LandingPubAuthorId);
                    
                }
                
                AppLogModel.LogInfo('PubAuthorModelNoSharing::updatePubAuthorStatusAndInvitedDate', 
                    'updated AuthorStatus__c successful',LandingPubAuthorId);
         }
            AppLogModel.LogDebug('PubAuthorModelNoSharing::updatePubAuthorStatusAndInvitedDate','Ended', LandingPubAuthorId);
            AppLogModel.flushLogs();
            //return PubId;
            
    }
    
    public static List<FeedItem> GetFeedItems(Id userId, id PubId){
        List<FeedItem> relatedFeedItems = new List<FeedItem>();
        if(userId != null){ 
          //Appear Enhancement R3- Comment on behalf- query returns InsertedBy.name,InsertedById,SystemModstamp  
          relatedFeedItems = [select Body,CreatedDate,createdby.name,InsertedBy.name,InsertedById,SystemModstamp from FeedItem where ParentId in (Select id from PubAttachmentDetails__c where Publication__c =: PubId ) and CreatedById=:userId ];
        }
        
        return relatedFeedItems;
    }      
   
   // map of contact id, FeedItems
    public static Map< id, List<FeedItem>> GetFeedItemCountByAuthor( Set<id> contactIds, Id aPubId){
        
        Map< id, List<FeedItem>>  feedListbyContact = new   Map< id, List<FeedItem>>(); 
        Map <id, id > userToContact = AppearContactModel.findUserIdsForContactIds (contactIds); 
        Set<id> userIds  = userToContact.keySet(); 
        List <FeedItem> relatedFeedItems = [select Body, CreatedById, CreatedDate,createdby.name from FeedItem where ParentId in (Select id from PubAttachmentDetails__c where Publication__c = :aPubId ) and CreatedById in :userIds ];
        List <FeedItem > aList; 
        for (FeedItem aFeedItem : relatedFeedItems){
            if (feedListbyContact.containsKey( userToContact.get(aFeedItem.CreatedById) )) {
                aList = feedListbyContact.get(userToContact.get(aFeedItem.CreatedById));
                aList.add(aFeedItem); 
            } else {
                aList = new List <FeedItem> ();
                aList.add(aFeedItem);
            }
            feedListbyContact.put( userToContact.get(aFeedItem.CreatedById), aList  ); 
        }       
        
        // setting default value 
        for (id aKey: userToContact.keySet()){
            if (!feedListByContact.containsKey( userToContact.get(aKey)  )){
                aList = new List  <FeedItem> ();
                feedListByContact.put(userToContact.get(aKey), aList  ); 
            }
        }
        
       return feedListbyContact; 

        
    }
        
     
     public boolean updatePubAuthorStatus(id aPubAuthorId, string sStatus) { 


        boolean success = false; 
        AppLogModel.LogDebug('PubAuthorModelNoSharing::updatePubAuthorStatus','Started');
        
         if ( aPubAuthorId == null ) {
                AppLogModel.LogError('PubAuthorModelNoSharing::updatePubAuthorStatus', 'Invalid Publication Author - please contact Support');
         } else {
                try {
                // instead of pubRecord, use a smaller set to make sure only comment field is updated. 
                PubAuthor__c updPubAuthor = [
                    select AuthorStatus__c, ApprovalAcceptedDate__c, inviteAcceptedDate__c, ReasonToDeclineApproval__c
                    from PubAuthor__c
                    where id = :aPubAuthorId
                    and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
                    for update
                ];
                
                updPubAuthor.AuthorStatus__c = sStatus;
                if (sStatus == sCompletedAuthorApproval && updPubAuthor.ApprovalAcceptedDate__c == null ){
                    updPubAuthor.ApprovalAcceptedDate__c = System.today();
                } else if (sStatus == sPublicationReviewByAuthors && updPubAuthor.inviteAcceptedDate__c == null  ){
                    updPubAuthor.inviteAcceptedDate__c = System.today();
                } else if (sStatus == sApprovalRejected){
                    updPubAuthor.Approval_Rejected_Date__c = System.today();
                    updPubAuthor.ReasonToDeclineApproval__c = newRejectApprovalReason;
                }
                update  updPubAuthor; 
    

                } catch(DMLException ex){
                    ApexPages.addMessages(ex);
                    AppLogModel.LogError('PubAuthorModelNoSharing::updatePubAuthorStatus', 'Exception'+ ex, aPubAuthorId);
                    return success; 
                }
                success = true; 
                AppLogModel.LogInfo('PubAuthorModelNoSharing::updatePubAuthorStatus', 
                    'updated AuthorStatus__c successful',aPubAuthorId);
         }
        AppLogModel.LogDebug('PubAuthorModelNoSharing::updatePubAuthorStatus','Ended', aPubAuthorId);
        AppLogModel.flushLogs();
        return success; 
        
        
    }
    
    public id pubAuthorIdForViewProvision{get; set;}
    public void RemoteSetPubAuthorIdForViewProvision(){
        // a placeholder for apex:actionFunction to set pubAuthorIdForViewProvision
        System.debug('RemoteSetPubAuthorIdForViewProvision /  pubAuthorIdForViewProvision = '+ pubAuthorIdForViewProvision);
    }
    public string pubAuthorViewProvision{
        get{
            // display the stored provison doc for this pub author 
            if(pubAuthorIdForViewProvision != null){
                try {
                    List<PubAuthor__c> InvSentAut = [select id,Disclaimer_ID__c
                    from PubAuthor__c
                    where id =: pubAuthorIdForViewProvision
                    and isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality                                 
                    limit 1
                                                    ] ;
                    ProvisionDocumentVersion__c comp=[SELECT id, ProvisionDocumentContent__c, Name FROM ProvisionDocumentVersion__c Where Id =: InvSentAut[0].Disclaimer_ID__c]; 
                    return comp.ProvisionDocumentContent__c; 
                } catch (Exception e){
                    return '';                  
                }
            } else return ''; 
        }       
    }
    
    
    public String activeOpr{get; set;}
    public void RemoteSetActiveOpr(){
        if (activeOpr != null) {
            UserPrefModel.ActivePubAuthorOpSF1 = activeOpr;     
        }   
    }
    
    public id pubAuthorIdForComment {get; set;}
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
    
    public PageReference AddDraftComment() {
        /*
        insert NewDraftComment;
        //Appear Enhancement R3 - Commentreceived date population
        PubAttachmentDetails__c attachdetails= [select Publication__c,AttachmentType__c from PubAttachmentDetails__c where id=:NewDraftComment.ParentId ];
        Contact c = [select Id from Contact where userid__c =:UserInfo.getUserId() limit 1];
        PubAuthor__c pubAuthorRecord= [select commentReceivedDate__c,Publication__r.name,Id from PubAuthor__c where Author__c =: c.Id and Publication__c =: attachdetails.publication__c];
        If(attachdetails.AttachmentType__c == 'Draft - Share with Authors')
        {
        pubAuthorRecord.commentReceivedDate__c = System.now();
        update pubAuthorRecord;
        }
        //Appear Enhancement R3 - Commentreceived date population
        
        */
        
        //Appear Enhancement R5 - Commentreceived date population
        PubAttachmentDetails__c attachdetails= [select Publication__c,AttachmentType__c from PubAttachmentDetails__c where id=:NewDraftComment.ParentId ];
        Contact c = [select Id from Contact where userid__c =:UserInfo.getUserId() limit 1];
        List <PubAuthor__c> pubAuthorRecordList = [select commentReceivedDate__c,Publication__r.name,Id from PubAuthor__c where Author__c =: c.Id and Publication__c =: attachdetails.publication__c and isLogicallyDeleted__c = false];
        
        if(pubAuthorRecordList.size()>1){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate Pub Authors are present' ));
        	return null;
        }
        try{
        	insert NewDraftComment;
        }
        catch(DMLException e){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() ));
        }
        If(attachdetails.AttachmentType__c == 'Draft - Share with Authors'  && pubAuthorRecordList[0].commentReceivedDate__c == null )//Appear Enhancement R5 : Restriction to CommentRecievedDate updation
        {
        pubAuthorRecordList[0].commentReceivedDate__c = System.now();
        try{
        	
        	update pubAuthorRecordList[0];
        }
        catch(DMLException e){//Changed Appear Enhancement R5
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() ));
        	return null;
        }
        }
        //Appear Enhancement R5 - Commentreceived date population
        
        pNewDraftComment = null; 
        
        UserPrefModel.ActivePubAuthorOpSF1 = sOprUpdate; 
        UserPrefModel.ActivePubAuthor = pubAuthorIdForComment; 

        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;  

    }
    
   public pageReference AddDraftComment2() {
        // used in core app
        insert NewDraftComment;
        pNewDraftComment = null; 
        NewDraftComment = null; 
        pubAttachmentIdForComment = null;         

       pageReference del = ApexPages.currentPage(); 
       Id id = del.getParameters().get('Id');
       String tile = del.getParameters().get('tile');
       String sfdc_tabName = del.getParameters().get('sfdc.tabName');
       String submenu =  del.getParameters().get('submenu');
       String sfdc_override = del.getParameters().get('sfdc.override');
       del.getParameters().clear();  // clear view states assoicated with url
       del.getParameters().put('Id', id);  
       del.getParameters().put('tile', tile);  
       del.getParameters().put('sfdc.tabName', sfdc_tabName);  
       del.getParameters().put('sfdc.override', sfdc_override);         
       del.getParameters().put('submenu', submenu);  
       del.setRedirect(true);
       return del;  


    }
    

    public decimal activePubAuthorOprTabSF1 {
        
        get {
            string sOpr = UserPrefModel.ActivePubAuthorOpSF1;
            decimal result = 0; // the default tab in SF1 app
            if (sOpr == sOprInvite) {
                result = 0; 
            } else if (sOpr == sOprUpdate) {
                result = 1; 
            } else if (sOpr == sOprApprove) {
                result = 2; 
            }
            return result; 
        }
    }

    transient private Map<id, boolean > pActivePubAuthorMapSF1; 
    public Map<id, boolean> ActivePubAuthorMapSF1{
        get 
        {if (pActivePubAuthorMapSF1 == null){
            pActivePubAuthorMapSF1 = new map<id, boolean>();
            string aPubAuthorId = UserPrefModel.ActivePubAuthor;
            for (pubAuthor__c myPubAuthor:  MyAuthorPubStatusFullList) { 
                
                if (myPubAuthor.id == aPubAuthorId){    
                    pActivePubAuthorMapSF1.put(myPubAuthor.id, true); 
                } else {
                    pActivePubAuthorMapSF1.put(myPubAuthor.id, false);                  
                }
            }
        }
        return pActivePubAuthorMapSF1; 
        }
    }
        

   // map of   list<PubAuthorPubDTO> with attachment_detail_id 
    private transient Map<id, PubAuthorPubDTO > pPubAuthorPubMap;    
    public Map<id, PubAuthorPubDTO> PubAuthorPubMap{
        get {
            if (pPubAuthorPubMap == null){
                Map<id, List<PubAuthorPubDraftAttachCommentDTO>> aPubAuthorCommentMap = PubAuthorCommentMap;
            }
            return pPubAuthorPubMap; 
        }
    }    


    // map of list<PubAuthorPubDraftAttachCommentDTO> with attachment_detail_id 
    private transient Map<id, List<PubAuthorPubDraftAttachCommentDTO> > pPubAuthorCommentMap; 
    public Map<id, List<PubAuthorPubDraftAttachCommentDTO>> PubAuthorCommentMap{
        get 
        {if (pPubAuthorCommentMap == null){
            pPubAuthorCommentMap = new Map<id, List<PubAuthorPubDraftAttachCommentDTO>> ();
            pPubAuthorPubMap = new  Map<id, PubAuthorPubDTO > ();     
            List<PubAuthorPubDTO> PubAuthorPubPTOList = getPubAuthorPubsDraftsAttachments(PubAuthorList, true ); 
            for (PubAuthorPubDTO aPubAuthorPubDTO:  PubAuthorPubPTOList) { 
                List<PubAuthorPubDraftDTO> PubAuthorPubDraftList = aPubAuthorPubDTO.PubAuthorPubDrafts;
                for (PubAuthorPubDraftDTO aPubAuthorPubDraftDTO: PubAuthorPubDraftList ){
                    List<PubAuthorPubDraftAttachmentDTO> PubAuthorPubDraftAttachmentsList =  aPubAuthorPubDraftDTO.PubAuthorPubDraftAttachments;
                    for (PubAuthorPubDraftAttachmentDTO aPubAuthorPubDraftAttachmentDTO : PubAuthorPubDraftAttachmentsList){
                        List<PubAuthorPubDraftAttachCommentDTO>  CommentList = aPubAuthorPubDraftAttachmentDTO.CommentList;
                        pPubAuthorCommentMap.put(aPubAuthorPubDraftAttachmentDTO.AttachmentDetailId, CommentList);     
                        pPubAuthorPubMap.put(aPubAuthorPubDraftAttachmentDTO.AttachmentDetailId, aPubAuthorPubDTO );                  
                    }
                }
            }
        }
        return pPubAuthorCommentMap; 
        }
    }
 
    // map of number of comments with attachment_detail_id 
    private transient Map<id, decimal > pPubAuthorCommentCountMap; 
    public Map<id, decimal> PubAuthorCommentCountMap{    
        get{
            if (pPubAuthorCommentCountMap == null){
                pPubAuthorCommentCountMap = new Map<id, decimal>(); 
                 for (id aKey: PubAuthorCommentMap.keySet()  ){
                    pPubAuthorCommentCountMap.put(aKey, PubAuthorCommentMap.get(aKey).size() );         
                 }
            }
            
            if (pPubAuthorCommentCountMap.isEmpty()) { 
                return null;
            } else {
                return pPubAuthorCommentCountMap;
            } 
        }
    }

    public void RemoteSetPubAttachmentIdForComment(){
        // a placeholder for apex:actionFunction to set pubAttachmentIdForComment
        // side note:  The substitution of merge fields for their actual values only occurs on the rendering phase. 
        // Meaning that a controller variable's value will not be updated in javascript unless you rerender the script tag.
        // pubAttachmentIdForComment = apexpages.currentpage().getparameters().get('ExtCommentId');
        System.debug('RemoteSetPubAttachmentIdForComment /  pubAttachmentIdForComment = '+ pubAttachmentIdForComment);
    }
    
    public Transient id pubAttachmentIdForComment{ get; set;}
    public List<PubAuthorPubDraftAttachCommentDTO> AuthorCommentbyAttachment {
        get{        
                System.debug('AuthorCommentbyAttachment 1st pubAttachmentIdForComment = '+ pubAttachmentIdForComment);
                if (pubAttachmentIdForComment != null){
                    List<PubAuthorPubDraftAttachCommentDTO> commentList = PubAuthorCommentMap.get(pubAttachmentIdForComment);
                    return commentList;
                } else {
                    return null; 
                }
           }
    }
    
    
    Public id CommentIdForDelete {get;set;}
    Public string CommentAuthorNameForDelete {get;set;}
    Public string CommentAuthorStatusForDelete {get;set;}    
    public PAGEREFERENCE deletecomment() {
        String LoggedInUserName = userinfo.getName();
        
        if (CommentAuthorStatusForDelete == 'Approval Rejected' || CommentAuthorStatusForDelete == 'Completed Author Approval'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You can not delete a comment from the approved or rejected draft'));
            return null;            
        }
        try{
            FeedItem Comment = [select Body,CreatedDate,createdby.name from FeedItem where Id =:CommentIdForDelete];
            if(comment.createdby.name == LoggedInUserName){
                delete comment;
                pPubAuthorPubsDraftsAttachments = null; // force retrieval of comments
                return null; 
            } else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You can not delete a comment posted by some other user'));
                return null;
            }
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Mismatched comment id'));
            return null; 
        }
    }
    
    Public id CommentIdForDeleteCoreApp {get;set;}
    public Pagereference deletecommentCoreApp() {
        String LoggedInUserName = userinfo.getName();
        FeedItem Comment = [select Body,CreatedDate,createdby.name from FeedItem where Id =:CommentIdForDeleteCoreApp];
        delete comment;
        pageReference del = ApexPages.currentPage(); 
        Id id = del.getParameters().get('Id');
        String tile = del.getParameters().get('tile');
        String sfdc_tabName = del.getParameters().get('sfdc.tabName');
        String submenu =  del.getParameters().get('submenu');
        String sfdc_override = del.getParameters().get('sfdc.override');
        del.getParameters().clear();  // clear view states assoicated with url
        del.getParameters().put('Id', id);  
        del.getParameters().put('tile', tile);  
        del.getParameters().put('sfdc.tabName', sfdc_tabName);  
        del.getParameters().put('sfdc.override', sfdc_override);         
        del.getParameters().put('submenu', submenu);  
        del.setRedirect(true);
        return del;  
    }       
    
    ////// BL - change to get a list of pub / draft / attachements ////
    
    private transient List<PubAuthorPubDTO>  pPubAuthorPubsDraftsAttachments = null;
    public List<PubAuthorPubDTO>  PubAuthorPubsDraftsAttachments {
        get {
            if (pPubAuthorPubsDraftsAttachments == null) {
                pPubAuthorPubsDraftsAttachments = getPubAuthorPubsDraftsAttachments(MyAuthorPubReviewList, false); 
            } 
            return pPubAuthorPubsDraftsAttachments;
            
        }
    }
    
    
    private List<PubAuthorPubDTO> getPubAuthorPubsDraftsAttachments(List<PubAuthor__c> aPubAuthorList , boolean AllAttachmentType ) {
        
        List<PubAuthorPubDTO> result = new List<PubAuthorPubDTO>();
        Map<Id, PubAuthorPubDTO> pubMap = new Map<Id, PubAuthorPubDTO>();
        List<Id> pubIds = new List<Id>();
        
        //for the current PubAuthor - find out what publications he is also an author of
        for(PubAuthor__c pa : aPubAuthorList) {
            PubAuthorPubDTO pap = new PubAuthorPubDTO();
            pap.pubId = pa.Publication__c; 
            pap.pubName = pa.Publication__r.Name;
            pap.pubTitle = pa.Publication__r.Publication_Title__c;
            pap.pubAuthorId = pa.id; 
            pap.authorStatus = pa.AuthorStatus__c;
            pubIds.add(pa.Publication__c);
            result.add(pap);
            pubMap.put(pa.Publication__c, pap);
        }
        
        //then for each publication, get all attachment for the current FC or all FC
        List<PubAttachmentDetails__c> pubAttachments = null;
        
        if (AllAttachmentType) {
            pubAttachments = [
            select id,Publication__c, FPR_Cycle__c, AttachmentName__c, Attachment_URL__c, AttachmentType__c, AttachmentDate__c, Comment__c, Notes__c, Size__c
            from PubAttachmentDetails__c
            where Publication__c in :pubIds
            and isLogicallyDeleted__c = false 
            order by CreatedDate desc
            ];
        } else {
            
            Set <dateTime> attachDates = new Set<dateTime>();
            List<AggregateResult>  pubAttachDates = [
                select max(CreatedDate) MaxCreatedDate
                from PubAttachmentDetails__c 
                where Publication__c in :pubIds
                and isLogicallyDeleted__c = false
                and AttachmentType__c in ('Draft - Share with Authors', 'Final Attachment for Author Approval', 'Kick Off Meeting Minutes/Memo') 
                group by Publication__c
            ];      
            for (AggregateResult aAttach:pubAttachDates )    {
                attachDates.add((datetime) aAttach.get('MaxCreatedDate')); 
            }
             
            pubAttachments = [
            select id,Publication__c, FPR_Cycle__c, AttachmentName__c, Attachment_URL__c, AttachmentType__c, AttachmentDate__c, Comment__c, Notes__c, Size__c
            from PubAttachmentDetails__c
            where Publication__c in :pubIds
            and isLogicallyDeleted__c = false
            and AttachmentType__c in ('Draft - Share with Authors', 'Final Attachment for Author Approval', 'Kick Off Meeting Minutes/Memo') 
            and CreatedDate in :attachDates
            order by CreatedDate desc
            ];          
        }
       
        
        Set<id> pubAttachmentIds = new Set<id>();
        //find all FPR info based on Attachments
        List<id> FprCycleIds = new List<id>();
        for(PubAttachmentDetails__c pad : pubAttachments) {
            pubAttachmentIds.add(pad.Id);
            FprCycleIds.add(pad.id);
        }
        
        
        //now grab the FPR Cycle records for FPR Cycle #
        List<FPR_Cycle__c> fprCycles = [
            select id, Name, FPR_Cycle_Num__c, Publication__c
            from FPR_Cycle__c
            where id in :FprCycleIds
        ];
        
        Map<id, FPR_Cycle__c> fprCycleMapByFcId = new Map<id, FPR_Cycle__c>();
        for(FPR_Cycle__c fprCycle : fprCycles) {
            fprCycleMapByFcId.put(fprCycle.Id, fprCycle);
        }
          
        //Load bulkified comments in
        List<FeedItem> commentFeedItems = [select id,Body, ParentId, CreatedBy.Id, CreatedBy.Name, CreatedDate from FeedItem where ParentId in :pubAttachmentIds];
        Map<id,List<PubAuthorPubDraftAttachCommentDTO>> commentMap = new Map<id,List<PubAuthorPubDraftAttachCommentDTO>>();
        for(FeedItem commentFeedItem : commentFeedItems) {
            if (!commentMap.containsKey(commentFeedItem.ParentId)) {
                List<PubAuthorPubDraftAttachCommentDTO> innerComments = new List<PubAuthorPubDraftAttachCommentDTO>();              
                commentMap.put(commentFeedItem.ParentId, innerComments);
            }
            
            PubAuthorPubDraftAttachCommentDTO commentItem = new PubAuthorPubDraftAttachCommentDTO(commentFeedItem.Body, commentFeedItem.CreatedDate, commentFeedItem.CreatedBy.Name,commentFeedItem.Id,commentFeedItem.CreatedBy.Id );
            commentMap.get(commentFeedItem.ParentId).add(commentItem);
        }
        
        //now sort through the PubAttachmentRecords and link them into the DTOs
        for(PubAttachmentDetails__c pad : pubAttachments) {
            PubAuthorPubDTO pap = pubMap.get(pad.Publication__c);
            
            System.debug('PubAttachment id = '+pad.id+' publication_c '+pad.Publication__c);
            
            if ( pap == null) {
                System.Debug('Error : PAP ('+pad.id+') is null for PubId = '+pad.Publication__c);
            } else {
                //by default - assign it to FPR_cycle 0
                PubAuthorPubDraftDTO papd = null;
                
                if ( pad.FPR_Cycle__c <> null) {
                    if ( fprCycleMapByFcId.containsKey(pad.FPR_Cycle__c)) {
                        FPR_Cycle__c fprCycle = fprCycleMapByFcId.get(pad.FPR_Cycle__c);
                        papd = pap.getPubDraft(fprCycle.Id, fprCycle.FPR_Cycle_Num__c);
                    } else {
                        papd = pap.getPubDraft(null, 0.0);
                    }
                }
                else {
                    papd = pap.getPubDraft(null, 0.0);
                }
            
                System.debug('PubID is '+pap.pubId);
                System.debug('FC is '+pad.FPR_Cycle__c);
                System.debug('FC Num is '+papd.FPR_Cycle_Num);
                
                List<PubAuthorPubDraftAttachCommentDTO> commentItems = null;
                if (commentMap.containsKey(pad.Id)) {
                    commentItems = commentMap.get(pad.Id);
                } else {
                    commentItems = new List<PubAuthorPubDraftAttachCommentDTO>();
                }
                
                papd.createPubAuthorPubDraftAttachment(pad, commentItems);
            }            
        }
        return result;
    }
    
 
     

}