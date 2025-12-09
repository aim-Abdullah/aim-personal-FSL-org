public class RecordTypeModel {
	  
	/////////////////////////////////////////////////////////////////////////
	private static List<RecordType> pRecordTypeList = null;
	public static List<RecordType> RecordTypeList {
		get {
			if (pRecordTypeList == null) {
				pRecordTypeList = [
		            select id, SobjectType,  Name, DeveloperName
		            from RecordType where isActive = true]; 
			}
			return pRecordTypeList;
		} 
	}
	
	private static Map<Id, RecordType> pRecordTypeMapById = null;
	public static Map<Id, RecordType> RecordTypeMapById {
		get {
			if ( pRecordTypeMapById == null) {
				pRecordTypeMapById = new Map<Id, RecordType>();
				for(RecordType rt : RecordTypeList) {
					pRecordTypeMapById.put(rt.id, rt);
				}
			}
			return pRecordTypeMapById;			
		}
	}
	
	public static string findRecordTypeNameById(Id recordTypeId) {
		if (RecordTypeMapById.containsKey(recordTypeId) ) {
			return RecordTypeMapById.get(recordTypeId).DeveloperName;
		} else {
			return 'Unknown RecordTypeId : ' + recordTypeId;
		}
	}
	
	
	
	private static Map<String,RecordType> pRecordTypeMap = null;
	public static Map<String,RecordType> recordTypeMap {
		get {
			if ( pRecordTypeMap == null){
				pRecordTypeMap = new Map<String,RecordType>(); 
		
				for(RecordType rt : RecordTypeList){
					pRecordTypeMap.put(rt.SobjectType+':'+rt.Name, rt);
					//System.Debug(rt.SobjectType+':'+rt.Name);
					if ( rt.Name <> rt.DeveloperName){
						pRecordTypeMap.put(rt.SobjectType+':'+rt.DeveloperName, rt);
						//System.Debug(rt.SobjectType+':'+rt.DeveloperName);
					}
				} 
			}
			return pRecordTypeMap;
		}
	}
    
    public static RecordType LookupRecordType(string sObjectName, string RecordTypeName){
        if(recordTypeMap.containsKey(sObjectName+':'+RecordTypeName)){
        	
        	System.Debug(RecordTypeModel.LegacyPubStatusRecordIdSet);
        	
        	return recordTypeMap.get(sObjectName+':'+RecordTypeName);
        }else { 
            //unable to locate
            System.Debug('RecordTypeModel::LookupRecordType unable to locate '+sObjectName+':'+RecordTypeName);
            return null;
        }
        
        
    }
    
    private static Set<id> pLegacyPubRecordIdSet = null;
    public static Set<id> LegacyPubRecordIdSet {
    	get {
    		if ( pLegacyPubRecordIdSet == null) {
    			pLegacyPubRecordIdSet = new set<id>();
    			
    			pLegacyPubRecordIdSet.add(PublicationLegacyFPROnlyRecTypeId);
    			pLegacyPubRecordIdSet.add(PublicationLegacyFPROnlyInProgressRecTypeId);
    			pLegacyPubRecordIdSet.add(PublicationLegacyInProgressRecTypeId);
    			pLegacyPubRecordIdSet.add(PublicationLegacyPublicationRecTypeId);
    		}
    		return pLegacyPubRecordIdSet;
    	}
    }
    
    private static Set<id> pLegacyInProgressPubRecordIdSet = null;
    public static Set<id> LegacyInProgressPubRecordIdSet {
    	get {
    		if ( pLegacyInProgressPubRecordIdSet == null) {
    			pLegacyInProgressPubRecordIdSet = new set<id>();
    			
    			pLegacyInProgressPubRecordIdSet.add(PublicationLegacyFPROnlyInProgressRecTypeId);
    			pLegacyInProgressPubRecordIdSet.add(PublicationLegacyInProgressRecTypeId);
    		}
    		return pLegacyInProgressPubRecordIdSet;
    	}
    }

    private static Set<id> pLegacyPubStatusRecordIdSet = null;
    public static Set<id> LegacyPubStatusRecordIdSet {
    	get {
    		if ( pLegacyPubStatusRecordIdSet == null) {
    			pLegacyPubStatusRecordIdSet = new set<id>();
    			
    			pLegacyPubStatusRecordIdSet.add(PubStatusLegacyRecTypeId);
    		}
    		return pLegacyPubStatusRecordIdSet;
    	}
    } 
    
    private static Set<id> pLegacyPubReviewTeamRecordIdSet = null;
    public static Set<id> LegacyPubReviewTeamRecordIdSet {
    	get {
    		if ( pLegacyPubReviewTeamRecordIdSet == null) {
    			pLegacyPubReviewTeamRecordIdSet = new set<id>();
    			
    			pLegacyPubReviewTeamRecordIdSet.add(PubReviewTeamLegacyRecTypeId);
    		}
    		return pLegacyPubReviewTeamRecordIdSet;
    	}
    }
	public static Id LookupRecordTypeId(string sObjectName, string RecordTypeName){
        if(recordTypeMap.containsKey(sObjectName+':'+RecordTypeName)){
        	return recordTypeMap.get(sObjectName+':'+RecordTypeName).Id;
        } else { 
            //unable to locate
            System.Debug('RecordTypeModel::LookupRecordType unable to locate '+sObjectName+':'+RecordTypeName);
            return null;
        }
    }
    
    public static id PubReviewTeamLegacyRecTypeId {
    	get {
    		return LookupRecordTypeId('PubReviewTeam__c','LegacyPubReviewTeamMemberRecord');
    	}
    }
    
    
    public static id PubStatusLegacyRecTypeId {
    	get {
    		return LookupRecordTypeId('PubStatus__c','Legacy_Pub_Status');
    	}
    }
    
    public static id StatusDeptStatusRecTypeId {
    	get {
    		return LookupRecordTypeId('Status__c','Department_Status');
    	}
    }
    
    public static id PublicationPlanRecTypeId {
    	get {
    		return LookupRecordTypeId('Publication__c','Plan');
    	}
    }

    public static id PublicationFPROnlyRecTypeId {
    	get {
    		return LookupRecordTypeId('Publication__c','FPR Only');
    	}
    }
    
    public static id PublicationSuggestionRecTypeId {
    	get {
    		return LookupRecordTypeId('Publication__c','Suggestion');
    	}
    }

    public static id PublicationSubmitRecTypeId {
    	get {
    		return LookupRecordTypeId('Publication__c','Submit');
    	}
    }   

    public static id PublicationReviewRecTypeId {
    	get {
    		return LookupRecordTypeId('Publication__c','Review');
    	}
    }    

    public static id PublicationInFPRCTypeId {
    	get {
    		return LookupRecordTypeId('Publication__c','In_FPR');
    	}
    }      

    public static id PublicationAssignedToFPRCTypeId {
    	get {
    		return LookupRecordTypeId('Publication__c','Assigned_to_FPRC');
    	}
    }  

    public static id PublicationLegacyFPROnlyRecTypeId {
    	get {
    		return LookupRecordTypeId('Publication__c','LegacyFPROnly');
    	}
    } 

    public static id PublicationLegacyFPROnlyInProgressRecTypeId {
    	get {
    		return LookupRecordTypeId('Publication__c','LegacyFPROnlyInProgress');
    	}
    } 
    
	public static id PublicationLegacyInProgressRecTypeId {
    	get {
    		return LookupRecordTypeId('Publication__c','LegacyInProgress');
    	}
    } 
    
	public static id PublicationLegacyPublicationRecTypeId {
    	get {
    		return LookupRecordTypeId('Publication__c','Legacy_Publication');
    	}
    } 

}