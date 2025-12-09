public class UserPrefModel {

	public static void clearMyPubIdPref() {
		string key = 'ActivePub::'+	UserId;
		KeyValueSettingsModel.ClearKey(key);
	}


	private static string pUserId = null;
	public static string UserId {
		get {
			if ( pUserId == null) {
				pUserId = UserInfo.getUserId();
			}
			return pUserId;
		}
	}

	private static string pUserName = null;
	public static string UserName {
		get {
			if ( pUserName == null) {
				pUserName = UserInfo.getUserName();
			}
			return pUserName;
		}
	}

	private static string pActivePub = null;
	public static string ActivePub {
		get {
			if (pActivePub == null){
				string key = 'ActivePub::'+	UserId;
				pActivePub = KeyValueSettingsModel.getValue(key);
			}
			return pActivePub;
				
		}
		set {
			string key = 'ActivePub::'+	UserId;
			pActivePub = value;
			if ( pActivePub == null){
				KeyValueSettingsModel.ClearKey(key);
			} else {
				KeyValueSettingsModel.SetKey(key, pActivePub);
			}
		}
	}

	private static string pActivePubAuthor = null;
	public static string ActivePubAuthor {
		get {
			if (pActivePubAuthor == null){
				string key = 'ActivePubAuthor::'+	UserId;
				pActivePubAuthor = KeyValueSettingsModel.getValue(key);
			}
			return pActivePubAuthor;
				
		}
		set {
			string key = 'ActivePubAuthor::'+	UserId;
			pActivePubAuthor = value;
			if ( pActivePubAuthor == null){
				KeyValueSettingsModel.ClearKey(key);
			} else {
				KeyValueSettingsModel.SetKey(key, pActivePubAuthor);
			}
		}
	}
	
	// save the last operation in Pub Author SF1 app
	private static string pActivePubAuthorOpSF1 = null;
	public static string ActivePubAuthorOpSF1 {
		get {
			if (pActivePubAuthorOpSF1 == null){
				string key = 'PubAuthorOpSF1::'+	UserId;
				pActivePubAuthorOpSF1 = KeyValueSettingsModel.getValue(key);
			}
			return pActivePubAuthorOpSF1;
				
		}
		set {
			string key = 'PubAuthorOpSF1::'+	UserId;
			pActivePubAuthorOpSF1 = value;
			if ( pActivePubAuthorOpSF1 == null){
				KeyValueSettingsModel.ClearKey(key);
			} else {
				KeyValueSettingsModel.SetKey(key, pActivePubAuthorOpSF1);
			}
		}
	}
	
	

}