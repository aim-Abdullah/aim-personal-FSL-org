public class UserRoleModel {

	public static id FPR_Only_SubmitterRoleId {
		get {
			UserRole FprOnlySubmitterRole = UserRoleByDevNameMap.get('FPR_Only_Submitter');
			if ( FprOnlySubmitterRole == null ) {
				return null;
			} else {
				return FprOnlySubmitterRole.Id;
			}
		}
	}

	private static string pCurrentRoleName = null;
	public static string CurrentRoleName {
		get {
			 if (pCurrentRoleName == null) {
			 	String UserRoleId = UserInfo.getUserRoleId(); 
			 	if (UserRoleMap.containsKey(UserRoleId)) {
			 		UserRole ur = UserRoleMap.get(UserRoleId);	
			 		pCurrentRoleName = ur.name;
			 	} else {
			 		pCurrentRoleName = 'UserRole id = '+UserRoleId;
			 	}
			 }
			 return pCurrentRoleName;
		}
	}
	
	private static Map<Id,UserRole> pUserRoleMap = null;
	public static Map<Id,UserRole> UserRoleMap{
		get {
			if (pUserRoleMap == null ){
				pUserRoleMap = new Map<Id, UserRole>();
				for(UserRole u : UserRoleList) {
					pUserRoleMap.put(u.id, u);
				}
			}
			return pUserRoleMap;			
		}
	}
	
	private static Map<string,UserRole> pUserRoleByDevNameMap = null;
	public static Map<string,UserRole> UserRoleByDevNameMap{
		get {
			if (pUserRoleByDevNameMap == null ){
				pUserRoleByDevNameMap = new Map<string, UserRole>();
				for(UserRole u : UserRoleList) {
					pUserRoleByDevNameMap.put(u.DeveloperName, u);
				}
			}
			return pUserRoleByDevNameMap;			
		}
	}
	
	
	private static List<UserRole> pUserRoleList = null;
	public static List<UserRole> UserRoleList {
		get {
			if (pUserRoleList == null) {
				pUserRoleList = [
					select id, name, DeveloperName, ParentRoleId
					from userRole
				];
			}
			return pUserRoleList;
		}
	}
}