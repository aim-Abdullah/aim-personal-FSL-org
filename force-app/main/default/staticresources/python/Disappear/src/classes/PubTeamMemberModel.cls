public with sharing class PubTeamMemberModel {
    ////////  members ////////////////////////
    private id PubId;
    private string ActiveTile;
    private string ActiveSubMenu;
    private AppearPubModel activePub;  
    private boolean isFprSubmitter;
    
    public void flushCache() {
        pPubTeamMembers = null;
    }
    
    private List<PublicationTeamMember__c> pPubTeamMembers = null;
    public List<PublicationTeamMember__c> PubTeamMembers {
        get {
            if (pPubTeamMembers == null) { 
                pPubTeamMembers = getPubTeamMembers(this.PubId);
            } 
            return pPubTeamMembers; 
        }
    }
    
    private List<PublicationTeamMember__c> pActivePubTeamMemberList = null;
    public List<PublicationTeamMember__c> PubActiveTeamMemberList {
        get {
            if (pActivePubTeamMemberList == null) {
                pActivePubTeamMemberList = new List<PublicationTeamMember__c>();
                for(PublicationTeamMember__c ptm : PubTeamMembers) {
                    if ( !ptm.islogicallyDeleted__c  && ptm.member__r.UserId__c <> null) {
            
                        System.assertNotEquals(null, ptm.member__r.UserId__c);
                        pActivePubTeamMemberList.add(ptm);
                    }
                }
            }
            return pActivePubTeamMemberList;    
        } 
    }
    
    private List<PublicationTeamMember__c> pPubTeamMembersWritingRole = null;
    public List<PublicationTeamMember__c> PubTeamMembersWritingRole {
        get {
            if (pPubTeamMembersWritingRole == null) {
                pPubTeamMembersWritingRole = getPubTeamMembersWritingRole();
            }
            return pPubTeamMembersWritingRole;
        }
    }
    
    public string newRoleId{get;set;}
    public string newMemberId{get;set;}

    public PubTeamMemberModel(Id PubId,  string tile, string subMenu, Boolean isFprSubmitter, AppearPubModel activePub) {
        this.PubId = PubId; 
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;
        this.activePub = activePub;
        this.isFprSubmitter = isFprSubmitter;
        check();
    }
    
    private void check() {
        if ( PubTeamMembers <> null) {
            AppLogModel.LogInfo('PubTeamMemberModel::check', 
                'Loading Publication team members for PubId:'+PubId+' found '+ PubTeamMembers.size()+ ' records', pubId);
        } else {
            AppLogModel.LogError('PubTeamMemberModel::check', 
                'Loading Publication team member for PubId:'+PubId+' PubTeamMembers is NULL', PubId);
        }       
    }
        //this is for update of list of PubStatus
    public PageReference save() {       
        //clear checkbox before persisting
        for(PublicationTeamMember__c p : PubTeamMembers){
            p.IsLogicallyDeleted__c = false;
        }
        database.update(pPubTeamMembers, true);
        pPubTeamMembers = null;  //clear cache
        
        activePub.resetSharing();
        
        return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    //Logical Delete
    public PageReference deleteSelected() {
        Boolean recordHasDates = false;
          
        List<PublicationTeamMember__c> itemsToLogicallyDelete = new List<PublicationTeamMember__c>();
        for(PublicationTeamMember__c p : PubTeamMembers){
            if (p.IsLogicallyDeleted__c) {
                itemsToLogicallyDelete.add(p);
            }
        }
        database.update(itemsToLogicallyDelete, true);  
        pPubTeamMembers = null; 
        activePub.resetSharing();
        
        return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }  
    
    //////////////////
    private transient PublicationTeamMember__c pNewPubTeamMember = null;
    public PublicationTeamMember__c NewPubTeamMember { //insert from model
        get {
            if (pNewPubTeamMember == null) {                
                pNewPubTeamMember = new PublicationTeamMember__c();
                pNewPubTeamMember.Publication__c = PubId;
            }
            return pNewPubTeamMember;
        }
        set {
            pNewPubTeamMember = value;
        }
    }
    
    public PageReference saveNewTeamMember() {
        //if ( pNewPubTeamMember.Member__c == null || (!isFprSubmitter )){// CR 247 03/19/2014 && pNewPubTeamMember.Appear_Role__c == null) ){
            if ( pNewPubTeamMember.Member__c == null){
                //error do not save
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                    AppearErrorMessages.NeedNewPublicationTeamMember);
 
                ApexPages.addMessage(myMsg);    
                 AppLogModel.LogError('PubteamMemberModel::saveNewTeamMember', 
                    AppearErrorMessages.NeedNewPublicationTeamMember);
            
            /***if ( !isFprSubmitter && pNewPubTeamMember.Appear_Role__c == null){
                //error do not save
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 
                    AppearErrorMessages.NeedRoleForNewPublicationTeamMember);
                ApexPages.addMessage(myMsg);
                
                AppLogModel.LogError('PubteamMemberModel::saveNewTeamMember', 
                    AppearErrorMessages.NeedNewPublicationTeamMember);
            }***/
            AppLogModel.flushLogs();
            //return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
            return null; //to show error
        }
        insert pNewPubTeamMember;         
       
        pPubTeamMembers = null;
        activePub.resetSharing();
        return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    
    }
    
    public static List<PublicationTeamMember__c> getPubTeamMembers(Id PubId) {
        if ( PubId == null) {
            return null;
        }
        
        List<PublicationTeamMember__c> pubTeamList = [ 
            select id, 
                Publication__c, IsLogicallyDeleted__c, 
                Product_Indication__c, Product_Indication__r.Name,
                Member__c, Member__r.Name, Member__r.UserId__c,fromKeyProdInd__c,
                Appear_Role__c, Appear_Role__r.Name, Appear_Role__r.isWritingRole__c   
            from PublicationTeamMember__c
            where Publication__c = :PubId 
            and IsLogicallyDeleted__c = false
            order by fromKeyProdInd__c desc, Appear_Role__r.Name, Product_Indication__r.Name,Member__r.Name
        ];
        
        string msg = 'PublicationTeamMember__c retrieved ' + pubTeamList.size()+' records for PubId = '+PubId;
        System.Debug(msg);
        
        
        return pubTeamList;
    }
    
    public List<PublicationTeamMember__c> getPubTeamMembersWritingRole() {
        
        List<PublicationTeamMember__c> pubTeamWritingRoleList = new List<PublicationTeamMember__c> ();
        for (PublicationTeamMember__c ptm : PubTeamMembers) {
            if ( ptm.Appear_Role__r.isWritingRole__c){
                pubTeamWritingRoleList.add(ptm);
            }
        }
        
        return pubTeamWritingRoleList;
    }
     /*** CR 247 03/19/2014
    public string ValidAppearRoles {
        get {
            return AppearRoleModel.ValidAppearRoles;
        }
    }**/
    
    
    ////////////// static ///////////////////
    public static void deletePubProdIndTeamMembers(Id PubId) {

        List<PublicationTeamMember__c> pubTeamMembersFromProdInd = new List<PublicationTeamMember__c>();
        for(PublicationTeamMember__c ptm : getPubTeamMembers(PubId)) {
            if (ptm.Product_Indication__c <> null) {
                pubTeamMembersFromProdInd.add(ptm);
            }
        }
        //delete pubTeamMembersFromProdInd;     
        withoutSharingUtil.DelRecords(pubTeamMembersFromProdInd, true);
    }
    
    
    public static void createPubTeamMembers(Id PubId, List<Pub_Prod_Ind__c> pubProdIndList, Id KeyProdIndId) {
        AppLogModel.LogDebug('PubTeamMemberModel::createPubTeamMembers', 'start');
        
        //insert the ProductIndicationTeam members to the Publication
        set<id> ProdIndIds = new set<id>();
        for(Pub_Prod_Ind__c ppi : pubProdIndList){
            ProdIndIds.add(ppi.Product_Indication__c);
        }
          
          
        //find all team members [ active ] for these Prod Ind team
        List<ProdIndTeamMember__c> teamMembers = [
            select Contact__c, Product_Indication__c
            from ProdIndTeamMember__c
            where Product_Indication__c in :ProdIndIds
              and isLogicallyDeleted__c = false
        ];
        
        //De-dup Team Member in case one belong to multiple Prod Indicators
        Map<Id, ProdIndTeamMember__c> teamMemberMap = new Map<Id, ProdIndTeamMember__c>();
        
        //priority to KeyProdIndicator
        for(ProdIndTeamMember__c pitm : teamMembers) {
            if ( pitm.Product_Indication__c == KeyProdIndId && !teamMemberMap.containsKey(pitm.Contact__c)) {
                teamMemberMap.put(pitm.Contact__c,pitm);
            }
        }
        //then the rest         
        for(ProdIndTeamMember__c pitm : teamMembers) {
            if ( pitm.Product_Indication__c <> KeyProdIndId && !teamMemberMap.containsKey(pitm.Contact__c)) {
                teamMemberMap.put(pitm.Contact__c,pitm);
            }
        }
        
        createPubTeamMembers2(pubId, teamMemberMap.values(), KeyProdIndId); 
    }
    
    
    public static void createPubTeamMembers2(Id PubId, List<ProdIndTeamMember__c> teamMembers, id KeyProdIndId) {
        AppLogModel.LogDebug('PubTeamMemberModel::createPubTeamMembers2', 'start');
        
        List<PublicationTeamMember__c> insertMembers = new List<PublicationTeamMember__c>();
        
        for(ProdIndTeamMember__c tm : teamMembers){
            PublicationTeamMember__c ptm = new PublicationTeamMember__c();
            ContactDelegate__c delegate = ContactDelegateModel.pubfindPubReviewDelegate(tm.Contact__c, DateTime.now().date());
            if (delegate != null) {
                ptm.Member__c = delegate.Contact__c;
            } else {
                Contact proxy = AppearContactModel.findProxyForContactId(tm.Contact__c);
                if (proxy != null) {
                    ptm.Member__c = proxy.Proxy__c;
                } else {
                    ptm.Member__c = tm.Contact__c;
                }
            }
            
            ptm.Publication__c = PubId;
            ptm.Product_Indication__c = tm.Product_Indication__c;
            if ( ptm.Product_Indication__c == KeyProdIndId) {
                ptm.fromKeyProdInd__c = true;
            } else {
                ptm.fromKeyProdInd__c = false;
            }
            insertMembers.add(ptm);
        }
        insert insertMembers;        
        
        AppLogModel.LogDebug('PubTeamMemberModel::createPubTeamMembers2', 'InsertedMembers = '+ insertMembers.size());
        
        AppearPubModel.resetSharing(PubId);
        
        AppLogModel.LogInfo('PubTeamMemberModel::createPubTeamMembers', 'Created : ' + insertMembers);
    }
    
    //Defect 701 - Include the PubTeamMembers for the cloning operation
    //Need to get the final list first because of previous de-duping members
    ////////////////////  static ///////////////////////
  public static List<PublicationTeamMember__c> getPublicationTeamMembers(id PubId){
     List<PublicationTeamMember__c> pubTeamListFinal = [ 
            select id, 
                Publication__c, IsLogicallyDeleted__c, 
                Product_Indication__c, Product_Indication__r.Name,
                Member__c, Member__r.Name, Member__r.UserId__c,fromKeyProdInd__c,
                Appear_Role__c, Appear_Role__r.Name, Appear_Role__r.isWritingRole__c   
            from PublicationTeamMember__c
            where Publication__c = :PubId 
            and IsLogicallyDeleted__c = false
            order by fromKeyProdInd__c desc, Appear_Role__r.Name, Product_Indication__r.Name,Member__r.Name
        ];
     return pubTeamListFinal;
     }
     
 	private PublicationTeamMember__c pLoggedInTeamMember;
	public PublicationTeamMember__c LoggedInTeamMember {
		get {
			if (pLoggedInTeamMember == null) {
				pLoggedInTeamMember = getLoggedInTeamMemberForPub(PubId);
			}			
			return pLoggedInTeamMember;
		}
	}
     
     public static PublicationTeamMember__c getLoggedInTeamMemberForPub(Id pubId) {
   		if (pubId == null) {
   			return null;
   		}
   		
   		Set<Id> AppearUserContactIdSet = AppearContactModel.findContactForAppearUser(userInfo.getUserId());
   		
   		if (AppearUserContactIdSet.size() > 0) {
   			//Id loggedInContactId = contacts[0].Id;
   		
	   		List<PublicationTeamMember__c> teamMembers = [
	   			Select Publication__c, IsLogicallyDeleted__c, 
                Product_Indication__c, Product_Indication__r.Name,
                Member__c, Member__r.Name, Member__r.UserId__c,fromKeyProdInd__c,
                Appear_Role__c, Appear_Role__r.Name, Appear_Role__r.isWritingRole__c  
	   			From PublicationTeamMember__c
	   			Where Publication__c = :pubId 
	   			And Member__c in :AppearUserContactIdSet 
	   			And IsLogicallyDeleted__c = false
	   		];
	   			
   			if (teamMembers.size() > 0) {
   				return teamMembers[0];
   			} else {
   				AppLogModel.LogError('PubTeamMemberModel::getLoggedInTeamMemberForPub', 
   					'PublicationTeamMember record fround for CurrentUser['+userInfo.getUserName()+'] for this publication['+ pubId +'] ', pubId);
   			}
   		} else {
   			AppLogModel.LogError('PubTeamMemberModel::getLoggedInTeamMemberForPub', 
   				'CurrentUser['+userInfo.getUserName()+'] is not a member of the pub team of this publication['+ pubId +'] ', pubId);
   		}
		return null;
	}
     
     /////////////// clone ///////////////
  public static void clone(Id origPubId, Id destCloneId) {
    List<PublicationTeamMember__c> origList = getPublicationTeamMembers(origPubId);
    
    List<PublicationTeamMember__c> destList = new List<PublicationTeamMember__c>();
    for(PublicationTeamMember__c record : origList){
    	if (record.Product_Indication__c != null) { //defect 701 - only clone adhocs. Set of indication will always grab new team from product indication
    		continue;
    	}
      PublicationTeamMember__c clone = record.clone(false, true, false, false);
      clone.Publication__c = destCloneId;
      destList.add(clone); 
    }
    
    insert destList;
  }
}