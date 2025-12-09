public virtual class AppearBaseData {


	private static boolean isPurgeMode() {
		return true;		
	}

	public static boolean purgeData(String objectName){
		if ( isPurgeMode()) {
			string queryStr = 'select id from '+objectName;
			
			list<sObject> records = Database.query(queryStr);
     		delete records;
     		return true;
		} else {
			return false;
		}

	}
}