global class UserModel {
	public static Map<Id, User> getUserMap(List<id> pubUserOrGroupIds) {
		Map<Id, User> resultMap = new Map<Id, User>();
		for(User u : getUserList(pubUserOrGroupIds)) {
			resultMap.put(u.id, u);
		}
		return resultMap;
	}
	
	public static List<User> getUserList(List<id> pubUserOrGroupIds) {
		list<User> result = [ 
			select id, name 
			from User 
			where id in :pubUserOrGroupIds
		];
		return result;
	}
	
	public static User getUserByUserName(String userName) {
		list<User> result = [ 
			select id, name, userName, email
			from User 
			where userName = :userName
		];
		
		if ( result.size() == 1) {
			return result[0];
		} else {
			return null;
		}
	}
	
	private static User pTemporaryPoolUser = null;
	public static User TemporaryPoolUser {
		get {
			if ( pTemporaryPoolUser == null) {
				pTemporaryPoolUser = getTemporaryPoolUser(); 
			}
			return pTemporaryPoolUser;
		}
	}
	
	private static User getTemporaryPoolUser() {
		string userName = KeyValueSettingsModel.getValue('TemporaryPubOwner');
		
		List<User> userList = [select id, name from User where Username = :userName and IsActive = true];
		if (userList.size() == 0) {
			AppLogModel.LogError('UserModel::GetTemporaryPoolUser', 
			'No active user found with Username = "'+ userName +'"');	
			return null;
		}
		return userList[0];
	}
	
	public static Map<String, User> pUserNameMap = null;
   public static Map<String, User> UserNameMap{
     get {
       if (pUserNameMap == null){
         pUserNameMap = getUserMapByName();
       }
       return pUserNameMap;
     }
   }
   
   public static Map<String, User> getUserMapByName() {
    Map<String, User> result = new Map<String, User>();
    for(User pUser : UserList){
      result.put(pUser.username, pUser);
    }

    return result;
  }

    private static List<User> pUserList = null;
    public static List<User> UserList{
        get{
            if(pUserList == null){
              pUserList = getAllUserList();
            }               
        return pUserList;
        }
    }  
    
    public static List<User> getAllUserList(){
        List<User> result = [
          select id, UserName
          From User
          order by UserName  
           ];
        return result;
    }
	
}