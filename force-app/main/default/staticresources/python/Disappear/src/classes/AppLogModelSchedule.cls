global class AppLogModelSchedule implements Schedulable{

	global void execute(SchedulableContext SC) {
 		DelAppLog();
	}
	


	public static string token = 'AppearLogLeftOverItems';
	public static integer AppearLogLeftOverItems {
		get {
			if ( KeyValueSettingsModel.GetKey(token) == null) {
				KeyValueSettingsModel.SetKey(token, '100');
			} 
			return integer.valueOf(KeyValueSettingsModel.getValue(token));
		}
	}
	
	//AppLogModelSchedule.DelAppLog();
	global static void DelAppLog() {
		integer recCount = [select count() from AppLog__c limit 5000];
		integer leftOver = AppearLogLeftOverItems;
		if ( recCount > leftOver) {
			integer delCount = recCount - leftOver;  //keep this last 100 records

			List<sObject> delRecords = [
				select id from AppLog__c
				order by CreatedDate 
				limit :delCount
			];
			Delete delRecords;
			database.emptyRecycleBin(delRecords);
			
			string msg = 'Delete '+ delRecords.size() + ' AppearLog records at '+DateTime.now();
			AppLogModel.LogInfo('AppLogModelSchedule', msg);
			AppLogModel.flushLogs();
		}  		
	}
	
	public static string scheduleToken = 'AppearLogCleanUpSchedule';
	public static string AppearLogScheduleString {
		get {
			return KeyValueSettingsModel.GetKey(scheduleToken,  '0 15 * * * ?').Value__c; 
			//once an hour run at 15 after the hour. 
		}
	}
   
	//AppLogModelSchedule.scheduleHourly();
	global static void scheduleHourly() {
		
		try {
			AppLogModelSchedule appLogSchedule = New AppLogModelSchedule();
			Id Job_id = System.schedule('AppearLog CleanUp', AppearLogScheduleString, appLogSchedule);
		} catch (Asyncexception ae) {
			string message = ae.getMessage();
			if ( message.contains(' already scheduled for execution.')) {
				//save to ignore
			} else {
				throw ae;
			}
		}  
	}
   
	//AppLogModelSchedule.SetAppearLogLeftOverItems(500);
	global static void SetAppearLogLeftOverItems( integer leftOverItems) {
		KeyValueSettingsModel.SetKey(token, String.valueOf(leftOverItems));
	}
}