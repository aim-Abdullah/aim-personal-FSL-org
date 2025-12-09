public class CheckUserAccessModel {


	public static boolean CheckReadAccess(id recordId) {
		return CheckReadAccess(Userinfo.getUserId(), recordId);
	}
	
	public static boolean CheckReadAccess(Id UserId, id recordId) {
		UserRecordAccess recordAccess = getUserRecord(userId, recordId);
		
		//process the record
		if ( recordAccess == null) {
			return false;
		} else if ( recordAccess.HasReadAccess) {
			return true;
		} else {
			return false;
		}
		
	}
	
	
	// CheckUserAccessModel.CheckAccess('Todd.okamoto@amgen.com', 'Pub-Id-005719');
	public static boolean CheckAccess(string userLoginName, string pubName) {
		List<Publication__c> pubs = [
			select id, Publication_Title__c
			from publication__c
			where name = :pubName
		];
		
		if ( pubs.size() == 0) {
			AppLogModel.LogError('CheckUserAccessModel::CheckEditAccess', 'Cannot find pub ' + pubName+'  abort now');
			return false;
		}
		
		Id pubId = pubs[0].id;
		String pubTitle = pubs[0].Publication_Title__c;
		
		
		//now look for userid
		
		List<User> users = [
			select id, username
			from user
			where username = :userLoginName
		];
		
		if ( users.size() == 0) {
			AppLogModel.LogError('CheckUserAccessModel::CheckEditAccess', 'Cannot find User ' + userLoginName+'  abort now', pubId);
			return false;
		}
		
		Id userId = users[0].id;
		
		boolean result = CheckEditAccess(userId, pubId);
		
		if ( result) {
			AppLogModel.LogInfo('CheckUserAccessModel::CheckEditAccess',  userLoginName + ' has edit access to pub : '+pubName, pubId );
		} else {
			AppLogModel.LogInfo('CheckUserAccessModel::CheckEditAccess',  userLoginName + ' does not have edit access to pub : '+pubName, pubId );
		}
		
		AppLogModel.flushLogs();
		
		return result;
	}
	
	public static boolean CheckEditAccess(id recordId) {
		return CheckEditAccess(Userinfo.getUserId(), recordId);
	}
	
	public static boolean CheckEditAccess(Id UserId, Id recordId) {
		UserRecordAccess recordAccess = getUserRecord(userId, recordId);
		
		boolean result = false;
		//process the record
		if ( recordAccess == null) {
			result =  false;
		} else if ( recordAccess.HasEditAccess) {
			result =  true;
		} else {
			result =  false;
		}
		
		AppLogModel.LogInfo('CheckUserAccessModel::CheckEditAccess', 'For UserId ='+userId+' on RecordId ='+recordId+' '+ result, recordId);
		return result;
	}
	
	public static UserRecordAccess getUserRecord(Id UserId, Id RecordId) {
		string mapKey = getMapKey(UserId, RecordId);
		
		if ( !UserAccessMap.containsKey(mapKey)) {
			//get from DB
			List<UserRecordAccess> records = [
				SELECT RecordId, HasReadAccess, HasEditAccess, HasTransferAccess, MaxAccessLevel
     			FROM UserRecordAccess
     			WHERE UserId = :UserId
     			AND RecordId = :RecordId
     		];
					
			UserRecordAccess result = null;
			if (records.size() == 1){
				result = records[0];
			} 
			
			//store result in map
			UserAccessMap.put(mapKey, result);
			
			return result;
			
		} else {
			//get from Map
			return UserAccessMap.get(mapKey);
		}
	}
		

	// not implemented yet
	/*
	public boolean CheckReadAccess(Id UserId, List<id> records) {
		return false;
	}
	
	public boolean CheckEditAccess(Id UserId, List<Id> records) {
		return false;
	}
	*/
	
	private static string getMapKey(Id UserId, Id RecordId){
		return RecordId+'-'+UserId; 
	}


	//http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_objects_userrecordaccess.htm
	//Map of RecordId+UserId / UserRecordAccess
	private static Map<String, UserRecordAccess> pUserAccessMap = null;
	public static Map<String, UserRecordAccess> UserAccessMap{
		get {
			if(pUserAccessMap == null) {
				pUserAccessMap = new Map<String, UserRecordAccess>();
			}
			return pUserAccessMap;
		}
	}
}