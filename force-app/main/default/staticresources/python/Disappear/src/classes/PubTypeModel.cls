public class PubTypeModel {

    /////////////////////////////////////////////////////////////////////////
    private static list<PubType__c> pPubTypeList = null;
    public static list<PubType__c> PubTypeList {
        get{
            if (pPubTypeList==null){
                pPubTypeList = getAllPubTypes();
            }
            return pPubTypeList;
        }
    }

    private static Map<String,PubType__c> pPubTypeMap = null;
    public static Map<String,PubType__c> PubTypeMap {
        get {
            if ( pPubTypeMap == null){
                pPubTypeMap = new Map<String,PubType__c>();     
                for(PubType__c pubType : PubTypeList){
                    pPubTypeMap.put(pubType.Name, pubType);
                } 
            }
            return pPubTypeMap;
        }
    }
    
    private static Map<Id,PubType__c> pPubTypeMapById = null;
    public static Map<Id,PubType__c> PubTypeMapById{
        get {
            if ( pPubTypeMapById == null){
                pPubTypeMapById = new Map<Id,PubType__c>();     
                for(PubType__c pubType : PubTypeList){
                    pPubTypeMapById.put(pubType.Id, pubType);
                } 
            }
            return pPubTypeMapById;
        }
    }
    
    
    public static Decimal findPubTypeMe(Id PubTypeId){
    	if ( PubTypeId == null){
    		return 0.0;
    	}
    	
    	Decimal pubTypeMe = PubTypeMeById.get(pubTypeId);
    	if ( pubTypeMe == null) {
    		pubTypeMe = 0.0;
    	}
    	return pubTypeMe;
    
    }

    public static Decimal findPubTypeMePlus(Id PubTypeId){
    	if ( PubTypeId == null){
    		return 0.0;
    	}
    	Decimal pubTypeMePlus = PubTypeMePlusById.get(pubTypeId);
    	if ( pubTypeMePlus == null) {
    		pubTypeMePlus = 0.0;
    	}
    	return pubTypeMePlus;
    }
    
    
    private static Map<Id,Decimal> pPubTypeMeById = null;
    public static Map<Id,Decimal> PubTypeMeById{
        get {
            if ( pPubTypeMeById == null){
                pPubTypeMeById = new Map<Id,Decimal>();     
                for(PubType__c pubType : PubTypeList){
                    pPubTypeMeById.put(pubType.Id, pubType.MePoint__c);
                } 
            }
            return pPubTypeMeById;
        }
    }
    
    private static Map<Id,Decimal> pPubTypeMePlusById = null;
    public static Map<Id,Decimal> PubTypeMePlusById{
        get {
            if ( pPubTypeMePlusById == null){
                pPubTypeMePlusById = new Map<Id,Decimal>();     
                for(PubType__c pubType : PubTypeList){
                    pPubTypeMePlusById.put(pubType.Id, pubType.ME_plus__c);
                } 
            }
            return pPubTypeMePlusById;
        }
    }
    
    
    public static PubType__c LookupPubType(string PubTypeName){
        if(PubTypeMap.containsKey(PubTypeName)){
            return PubTypeMap.get(PubTypeName);
        }else { 
            //unable to locate
            return null;
        }
    }
    
    public static List<PubType__c> getAllPubTypes() {
        List<PubType__c> PubTypes = [
            select id, Name, displayOrder__c, DefaultTargetType__c, MePoint__c, ME_plus__c, isLogicallyDeleted__c, isInitalStatusSuggested__c
            from PubType__c
            where isLogicallyDeleted__c = false
            order by displayOrder__c
        ];
        return PubTypes; 
    }


	public static Set<id> PubTypeInitialStatusSuggested {
		get {
			set<id> result = new set<id>();
			for(PubType__c pt : PubTypeList) {
				if ( pt.isInitalStatusSuggested__c)  {
					result.add(pt.id);
				}
			}
			return result;
		}
	}

}