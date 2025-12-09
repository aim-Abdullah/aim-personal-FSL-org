public without sharing class AppearPubModelShare{

    private Id PubId;
    private String PubRecordTypeName;
    private boolean isEnbrel = false;

    public AppearPubModelShare(Id PubId) {
        this.PubId = PubId;
    }
    
    public AppearPubModelShare(Id PubId, Id PubRecordTypeId, boolean isEnbrel) {
        this.PubId = PubId;
        this.isEnbrel = isEnbrel;
        if ( PubRecordTypeId <> null) {
            this.PubRecordTypeName = RecordTypeModel.findRecordTypeNameById(PubRecordTypeId);
        }
    }
    
    //DEF# 770, 759, 748
    private static boolean ShouldExcludePubShareEdit(Status__c statusToCheck) {
        boolean shouldExclude = false;
        if ( statusToCheck == StatusModel.InFpr ||
            statusToCheck == StatusModel.AssignedToFPRC ||
            statusToCheck == StatusModel.Routed) {
                shouldExclude = true;
            }
            
        return shouldExclude;
    }

    //PubTeamMember
    public static boolean pubTeamShareEdit(Id PubId, List<Id> UserIds, Status__c currentPubStatus) {
        if (ShouldExcludePubShareEdit(currentPubStatus)) {
            AppLogModel.LogInfo('AppearPubModelShare::pubTeamShareEdit', 
            'Skipping pubteam edit for status: '+currentPubStatus.Name);
            return false;
        }
        
        List<Publication__Share> pubShareList = new List<Publication__Share>();
        
        AppLogModel.LogInfo('AppearPubModelShare::pubTeamShareEdit', 
            'enable edit share for '+UserIds, pubId);
        //AppLogModel.flushLogs();
        
        for(Id UserId : UserIds) {
            if (UserId <> Null){ 
                Publication__Share pubShare = new Publication__Share();
                pubShare.ParentId = PubId;
                pubShare.UserOrGroupId = UserId;
                pubShare.AccessLevel = 'Edit';
                pubShare.RowCause = Schema.Publication__Share.RowCause.PubTeamMember__c;
                pubShareList.add(pubShare);
            }
        }
        if (pubShareList.size() > 0 ) {
            return ApexShareModel.persistApexShare(pubShareList, PubId);
        } else {
            return true;
        }
    }
    //Appear Release 1 Checking Publication Status
	private static boolean ShouldExcludePubMeShareEdit(Status__c statusToCheck) {
		boolean shouldExclude = false;
		if ( statusToCheck == StatusModel.InFpr ||
		    statusToCheck == StatusModel.AssignedToFPRC ||
		    statusToCheck == StatusModel.Routed ) {
		    	shouldExclude = true;
		    }
		    
	    return shouldExclude;
	}
    
    /* Code Implement as part Of Appear Enhancment Release 1 for sharing the Pub Record to EW profile Users*/
    public static boolean pubMeShareEdit(Id PubId, List<Id> UserIds, Status__c currentPubStatus) {    
      List<Publication__Share> pubShareList = new List<Publication__Share>();  
      AppLogModel.LogInfo('AppearPubModelShare::pubMeShareEdit', 
       'enable edit share for '+UserIds, pubId);
      for(Id UserId : UserIds) {
       if (UserId <> Null){ 
        Publication__Share pubShare = new Publication__Share();
        pubShare.ParentId = PubId;
        pubShare.UserOrGroupId = UserId;
        if(ShouldExcludePubMeShareEdit(currentPubStatus)){
			pubShare.AccessLevel = 'Read';
		}
		else{
			pubShare.AccessLevel = 'Edit';
		}
        pubShare.RowCause = Schema.Publication__Share.RowCause.ExternalWriter__c;
        pubShareList.add(pubShare);
       }
      }
      if (pubShareList.size() > 0 ) {
       return ApexShareModel.persistApexShare(pubShareList, PubId);
      } else {
       return true;
      }
     }
 
    public boolean pubTeamShareRead(List<Id> UserIds) {
        List<Publication__Share> pubShareList = new List<Publication__Share>();
        
        AppLogModel.LogInfo('AppearPubModelShare::pubTeamShareRead', 
            'enable read share for '+UserIds, pubId);
        //AppLogModel.flushLogs();
        
        for(Id UserId : UserIds) {
            if (UserId <> Null){
                Publication__Share pubShare = new Publication__Share();
                pubShare.ParentId = PubId;
                pubShare.UserOrGroupId = UserId;
                pubShare.AccessLevel = 'Read';
                pubShare.RowCause = Schema.Publication__Share.RowCause.PubTeamMemberReadOnly__c;
                pubShareList.add(pubShare);  
            }
        }
        if (pubShareList.size() > 0 ) {
            return ApexShareModel.persistApexShare(pubShareList, PubId);
        } else {
            return true;
        }
    } 
    
    //PubReviewTeamMember
    public boolean pubReviewTeamShareEdit(List<Id> UserIds) { //currently changed to read access
        List<Publication__Share> pubShareList = new List<Publication__Share>();
        
        AppLogModel.LogInfo('AppearPubModelShare::pubReviewTeamShare', 
            'enable share for '+UserIds, pubId);
        
        for(Id UserId : UserIds) {
            if (UserId <> Null){
                Publication__Share pubShare = new Publication__Share();
                pubShare.ParentId = PubId;
                pubShare.UserOrGroupId = UserId;
                pubShare.AccessLevel = 'Read'; //currently changed to read access
                pubShare.RowCause = Schema.Publication__Share.RowCause.PubReviewTeamMember__c;
                pubShareList.add(pubShare);
            }
        }
        if (pubShareList.size() > 0 ) {
            return ApexShareModel.persistApexShare(pubShareList, PubId);
        } else {
            return true;
        }
    }
    
    private Set<string> pSystemSharingCause = null;
    public Set<string> SystemSharingCause{
        get {
            if (pSystemSharingCause == null) {
                pSystemSharingCause = new set<string>();
                pSystemSharingCause.add('Owner');
                pSystemSharingCause.add('Rule');
            }
            return pSystemSharingCause;
        }
    }
    
    public void resetAllApexSharing() {
        List<Publication__Share> delList = new List<Publication__Share>();
        for(Publication__Share ps : PubShareList) {
            if ( !SystemSharingCause.contains(ps.RowCause)) {
                delList.add(ps);
                System.Debug('**** deleteing '+ps.RowCause);
            }
        }
        try {
        delete delList;
        }
        catch (Exception ex) {}
        pPubShareList = null;
        pPubShareMap = null;
    }
    
    private Map<Id, Publication__Share> pPubShareMap = null;
    public Map<Id, Publication__Share> PubShareMap {
        get {
            if (pPubShareMap == null) {
                pPubShareMap = new Map<Id, Publication__Share> ();
                for(Publication__Share share : PubShareList) {
                    pPubShareMap.put(share.UserOrGroupId, share);
                }
            }
            return pPubShareMap;
        }
    }
    
    private List<Publication__Share> pPubShareList = null;
    public List<Publication__Share> PubShareList {
        get {
            if (pPubShareList == null) {
                pPubShareList = getPubShare(PubId);
            }
            return pPubShareList;
        }
    }
    
    public string pubOwnerShip {
        get {
            List<publication__c> pubs = [
                select owner.name, owner.profile.name
                from publication__c
                where id = :pubId
            ];
            
            if ( pubs.size() == 1)  {
                return 'Pub Owner = ' + pubs[0].owner.name + '<br/>Pub Owner Profile = '+pubs[0].owner.profile.name;
            } else {
                return 'cannot retrieve owner or owner profile for pub';
            }
            
            
        }
    }
    
    public static Publication__c getPublicationSCandFC(Id innerPubId) {
        List<Publication__c> pubs = [
            select Current_SubmissionCycle_Id_Formula__c, Current_FPRCycle_Id_Formula__c
            from Publication__c
            where id = :innerPubId
        ];
        
        if ( pubs.size() == 1)  {
            return pubs[0];
        } else {
            return null;
        }
    }
    
    
    private transient string pSharingDetails = null;
    public string sharingDetails {
        get {
            if (pSharingDetails == null){
                
                pSharingDetails = '<br/><br/>' + CurrentUserInfo + '<br/>'+ pubOwnerShip +  '<br/><br/>';
                List<Id> pubUserOrGroupIds = new List<id>(); 
                for(Publication__Share ps :  PubShareList) {
                    //collect all contact names
                    pubUserOrGroupIds.add(ps.UserOrGroupId);
                }
                
                Map<id, User> userMap = UserModel.getUserMap(pubUserOrGroupIds);
                //Map<id,Contact> contactMap = AppearContactModel.getContactMap(pubUserOrGroupIds);
                Map<id,Group> groupMap = GroupModel.getGroupMap(pubUserOrGroupIds);
                 
                for(Publication__Share ps :  PubShareList) {                    
                    pSharingDetails += shareDetailsToString(ps, userMap, groupMap) + '<br/>';
                }
                
                /*  no longer accurate - comment out as of Rel 2.0 rollout
                pSharingDetails +='<br/><br/>';
                pSharingDetails +='Criteria Based Sharing Rules [Role-based] in effects are :<br/>';
                pSharingDetails +='1. Plan Stage - GPPL Role has R/W access to Publications<br/>';
                pSharingDetails +='2. Execute Stage - Writing Role has R/W access to Publications<br/>';
                pSharingDetails +='3. Review Stage  - Writing Role & FPRC Role have R/W access to Publications<br/>';
                pSharingDetails +=htmlSpace(3);
                pSharingDetails +='   Review Stage includes the following recTypes [In FPR, Review, Assigned to FPRC]<br/>';
                pSharingDetails +='<br/><br/>';
                */
                
                if ( isEnbrel) {
                    pSharingDetails +='This pub has isEnbrel restriction <br/><br/>';
                }
            }
            return pSharingDetails; 
        }
    }
    
    private string pCurrentUserInfo = null;
    public string CurrentUserInfo{
        get {
            if ( pCurrentUserInfo == null) {
                pCurrentUserInfo = 'Current User : '+UserInfo.getUserName() + htmlSpace(10);

                pCurrentUserInfo += 'Profile : ' + ProfileModel.CurrentProfileName + htmlSpace(10);
                pCurrentUserInfo += 'Role : '+ UserRoleModel.CurrentRoleName + htmlSpace(10);
                
                //pCurrentUserInfo += ' Type : ' + UserInfo.getUserType()+ '<br/>';
                pCurrentUserInfo += 'RecordType : ' + PubRecordTypeName+ '<br/>';
                
            }
            return pCurrentUserInfo;
        }
    }
    
    //SELECT CreatedDate,DeveloperName,DoesSendEmailToMembers,Id,Name,RelatedId,Type FROM Group
    
    //use EA to setup the RoleSharingGroup Name
    //KeyValueSettingsModel.SetKey('Grp00GU0000000p2hl', 'Writinig Role Group');
    
    public string shareDetailsToString(Publication__Share ps, 
        Map<id,User> userMap,  Map<id,Group> groupMap) {
        string result = '';
        if ( userMap.containsKey(ps.UserOrGroupId)) {
            result = 'User : '+userMap.get(ps.UserOrGroupId).name;
        } else if (groupMap.containsKey(ps.UserOrGroupId)) {
            Group g = groupMap.get(ps.UserOrGroupId);
            string groupName = g.DeveloperName;

            if ( KeyValueSettingsModel.GetKey(groupName) <> null) {
                groupName = KeyValueSettingsModel.GetKey(groupName).Value__c;
            } 
            
            result = 'Group : '+groupName ;
        } else {
            string prefix = ps.UserOrGroupId;
            prefix = prefix.substring(0,3);
            string objectName = SchemaModel.objectPrefixMap.get(prefix);
            if(objectName == null) { 
                objectName = 'Unknown Object with Prefix ['+prefix+']';
            }
            result = objectName + ' : '+ps.UserOrGroupId ;
        }
        result += ' has '+ps.AccessLevel+' Access.  Sharing Cause = '+ ps.RowCause;
        return result;
    }
    
    private string htmlSpace(integer x){
        string result = '';
        for(integer i=0;i<x;i++) {
            result +='&nbsp;';
        }
        return result;
    }
    
    public static List<Publication__Share> getPubShare(Id PubId) {
        List<Publication__Share> result = [
            select Id, ParentId, UserOrGroupId, AccessLevel, RowCause
            from Publication__Share
            where ParentId = :PubId
        ];
        return result;
    }

    //AppearPubModelShare.SetGPPLRoleGroup('');
    public static void SetGPPLRoleGroup(string grpName ){
        KeyValueSettingsModel.SetKey(grpName, 'GPPL Role Group');
    }   
    
    //AppearPubModelShare.SetWritingRoleGroup('');
    public static void SetWritingRoleGroup(string grpName ){
        KeyValueSettingsModel.SetKey(grpName, 'Writing Role Group');
    }
    
    //AppearPubModelShare.SetFPRCRoleGroup('');
    public static void SetFPRCRoleGroup(string grpName ){
        KeyValueSettingsModel.SetKey(grpName, 'FPRC Role Group');
    }
}