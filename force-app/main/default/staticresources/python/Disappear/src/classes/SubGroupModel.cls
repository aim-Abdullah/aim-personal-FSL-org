public class SubGroupModel {
    private id SubGroupId;
    
    public SubGroupModel( Id SubGroupId) {
        this.SubGroupId = SubGroupId;
    }
    
    
    private SubGroup__c pSubGroupRecord = null;
    public SubGroup__c SubGroupRecord  {
        get {
            if (pSubGroupRecord == null){
                if ( SubGroupMapById.containsKey(SubGroupId)) {
                    pSubGroupRecord = SubGroupMapById.get(SubGroupId);                  
                } else {
                    pSubGroupRecord = null;
                    AppLogModel.LogError('SubGroupModel::SubGroupRecord', 
                        'Cannot find SubGroup record with Id '+SubGroupId);
                }
            }
            return pSubGroupRecord;
        }
    }
    
    private Id pDataSourceId = null;
    public Id DataSourceId {
        get {
            if ( pDataSourceId == null) {
                if ( SubGroupRecord <> null) {
                    pDataSourceId = SubGroupRecord.Data_Source__c;
                } else {
                    pDataSourceId = null;
                    AppLogModel.LogError('SubGroupModel::DataSourceId', 
                            'Cannot find dataSource record. No valid subGroup');                
                }
            }
            return pDataSourceId;           
        }
    }
    
   public static string getSubGroupName(Id SubGroupId) {
		if (SubGroupMapById.containskey(SubGroupId) ) {
			return SubGroupMapById.get(SubGroupId).Name;
		} else {
			return null;
		}
	}
    
    private static Map<id, SubGroup__c> pSubGroupMapById = null;
    public static Map<id, SubGroup__c> SubGroupMapById {
        get {
            if (SubGroupMapById == null) {
                SubGroupMapById = new Map<id, SubGroup__c>();
                for(SubGroup__c subGroup : SubGroupList) {
                    SubGroupMapById.put(subGroup.id, subGroup);
                }
            }
            return SubGroupMapById;
        }
    }

    private static List<SubGroup__c> pSubGroupList = null;
    public static List<SubGroup__c> SubGroupList {
        get {
            if (pSubGroupList == null){
                pSubGroupList = getAllSubGroups();
            }
            return pSubGroupList;
        }
    }
    
    public static List<SubGroup__c> getAllSubGroups() {
        List<SubGroup__c> result = [
            Select s.SiebelRowId__c,
            s.Name, s.Id, s.Data_Source__c,
            isLogicallyDeleted__c  
            From SubGroup__c s
            where isLogicallyDeleted__c = false
            order by Name
        ];
        return result;
    }
     
     
   public static SubGroup__c lookUpSG(string Subgroup) {
        if (SubGroupNameMap.containsKey(Subgroup)) {
            return SubGroupNameMap.get(Subgroup);
        } else {
            return null;
        }   
    }
    
   private static Map<String, SubGroup__c> pSubGroupNameMap = null;
   public static Map<String, SubGroup__c> SubGroupNameMap{
     get {
       if (pSubGroupNameMap == null){
         pSubGroupNameMap = getSubGroupMapByName();
       }
       return pSubGroupNameMap;
     }
   }
   
   public static Map<String, SubGroup__c> getSubGroupMapByName() {
    Map<String, SubGroup__c> result = new Map<String, SubGroup__c>();
    for(SubGroup__c pSubGroup : SubGroupList){
      result.put(pSubGroup.Name, pSubGroup );
    }

    return result;
  }
      
   
    
    
}