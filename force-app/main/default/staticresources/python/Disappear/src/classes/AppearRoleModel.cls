public class AppearRoleModel {

    public static void resetCache() {
        pWritingCoordinatorRoleId = null;
        pWritingRoleSet = null;
        pAppearRoleMapByName = null;
        pAppearRoleMap = null;
        pAppearRoleList = null;
    }
    
    private Static id pWritingCoordinatorRoleId = null;
    public static Id WritingCoordinatorRoleId {
        get {
            if ( pWritingCoordinatorRoleId == null){
                Appear_Role__c role = AppearRoleMapByName.get('Writing Coordinator');
                if ( role == null) {
                    pWritingCoordinatorRoleId = null;
                } else {
                    pWritingCoordinatorRoleId = role.id;
                }
            }
            return pWritingCoordinatorRoleId;
        }
    }
    public static boolean isWritingCoordinatorRole(id roleId) {
        if(WritingCoordinatorRoleId == roleId) {
            return true;
        } else {
            return false;
        }
    }

    private static Set<Id> pWritingRoleSet = null;
    public static Set<Id> WritingRoleSet {
        get {
            if (pWritingRoleSet == null){
                pWritingRoleSet = new set<id>();
                for(Appear_Role__c appearRole : AppearRoleList) {
                    if ( appearRole.isWritingRole__c){
                        pWritingRoleSet.add(appearRole.id);
                    }
                }
            }
            return pWritingRoleSet;
        }
    }

    private static Map<string, Appear_Role__c> pAppearRoleMapByName = null;
    public static Map<string, Appear_Role__c> AppearRoleMapByName {
        get {
            if (pAppearRoleMapByName == null ){
                pAppearRoleMapByName = new  Map<string, Appear_Role__c> ();
                for(Appear_Role__c role :AppearRoleList ){
                    pAppearRoleMapByName.put(role.name, role);
                }
            }
            return pAppearRoleMapByName;            
        }
    }
    
    private static Map<Id, Appear_Role__c> pAppearRoleMap = null;
    public static Map<Id, Appear_Role__c> AppearRoleMap {
        get {
            if (pAppearRoleMap == null ){
                pAppearRoleMap = new  Map<Id, Appear_Role__c> ();
                for(Appear_Role__c role :AppearRoleList ){
                    pAppearRoleMap.put(role.id, role);
                }
            }
            return pAppearRoleMap; 
        }
    }
    
    private static List<Appear_Role__c> pAppearRoleList = null;
    public static List<Appear_Role__c> AppearRoleList {
        get {
            if ( pAppearRoleList == null) {
                pAppearRoleList = getAppearRoles();
            }
            return pAppearRoleList;
        }
    }
    
    public static List<Appear_Role__c> getAppearRoles() {
        List<Appear_Role__c> result = [
            select Name, RecordTypeId, RecordType.Name, isWritingRole__c, isLogicallyDeleted__c
            from Appear_Role__c
            where isLogicallyDeleted__c = false 
            order by Name
        ];
        
        return result;
    }
    /***CR 247 03/19/2014
    private static string pValidAppearRoles = null;
    public static string ValidAppearRoles {
        get {
            if ( pValidAppearRoles == null) {
                pValidAppearRoles = 'Valid Appear Roles are : <br/><br/>';
                integer lineLen = 0;
                for(Appear_Role__c appearRole : AppearRoleModel.AppearRoleList) {
                	
                	if ( !appearRole.isWritingRole__c) //Writing Roles need not be displayed in the Publication Team
                	{ 
                        pValidAppearRoles += appearRole.Name +', ';
	                
	                    //Defect 466 - TR 08/13/13 To remove the number from the listing of Appear Roles
	                    //pValidAppearRoles += appearRole.Name.length() + 3;
	                    if ( lineLen > 100 ) {
	                        pValidAppearRoles += '<br/>';
	                        lineLen = 0;
	                    }
                	}
                }
            }
            return pValidAppearRoles;
        }
    }**/
    
}