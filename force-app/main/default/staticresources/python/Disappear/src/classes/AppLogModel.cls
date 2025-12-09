global class AppLogModel {
	
	global static string TypeError = 'Error';
	global static string TypeWarning = 'Warning';
	global static string TypeInfo = 'Info';
	global static string TypeDebug = 'Debug';
	
	private static string LogLevelKey = 'LogLevel';
	
	//AppLogModel.setLogLevelDebug();
	public static void setLogLevelDebug(){
		setLogLevel('Debug');
	}

	public static void setLogLevelInfo(){
		setLogLevel('Info');
	}
	
	public static void setLogLevelErrorOnly(){
		setLogLevel('Error');
	}
	
	public static void setLogLevel(string LogLevel){
		if ( LogLevel == 'Error') {
			KeyValueSettingsModel.SetKey(LogLevelKey, '1');
		} else if ( LogLevel == 'Warning') {
			KeyValueSettingsModel.SetKey(LogLevelKey, '2');
		} else if ( LogLevel == 'Info') {
			KeyValueSettingsModel.SetKey(LogLevelKey, '3');
		} else if ( LogLevel == 'Debug') {
			KeyValueSettingsModel.SetKey(LogLevelKey, '4');
		} else {
			string msg =  ' invalid logging level '+LogLevel;
			System.Debug('AppLogModel::setLogLevel ' + msg);
			AppLogModel.LogError('AppLogModel::setLogLevel', msg);
			AppLogModel.flushLogs();
		}
	}
	
	private static integer pLogLevel = 100;  //by default log everything
	public static integer LogLevel {
		get {
			if ( pLogLevel == 100) {
				 string logLevelValue = KeyValueSettingsModel.getValue(LogLevelKey);
				 if ( logLevelValue == null){
				 	KeyValueSettingsModel.SetKey(LogLevelKey, '4');
				 	pLogLevel = 4;
				 } else {
				 	pLogLevel = Integer.ValueOf(logLevelValue);
				 }
			}  
			return pLogLevel;
		}
	}

	/////////////  Static ///////////////////
	public static integer appLogSizeLimit = 50;
	private static List<AppLog__c> applogs = new List<AppLog__c> ();
	
	global static void LogInfo(string messageType, List<string> messages){
		addLogs( AppLogModel.TypeInfo, messageType, messages);
	}	  
	
	global static void addLogs(string logType, string messageType, List<string> messages ){
		id anId = null;
		for(string msg : messages) {
			addLog(logType, null, null, messageType, msg, anId);
		}
	}

	global static void LogInfo(string messageType, string message,Id PubId){
		if ( LogLevel >= 3) {
			System.Debug('*** '+messageType+'  '+message);
			LogInfo( messageType, message,'', PubId);
		}
	}
	global static void LogInfo(string messageType, string message){
		if ( LogLevel >= 3) {
			System.Debug('*** '+messageType+'  '+message);
			LogInfo( messageType, message,'', null);    
		}
	}	 
	
	//to be deprecated with Rel 1.2
	global static void LogInfo(string messageType, string message, string description){
		if ( LogLevel >= 3) {
			System.Debug('*** '+messageType+'  '+message);
			LogInfo( messageType, message,description, null);
		}
	}
	
	global static void LogDebug(string messageType, string message){
		if ( LogLevel >= 4) {
			System.Debug('*** '+messageType+'  '+message);
			LogDebug( messageType, message,'', null);
		}
	}
	
	global static void LogDebug(string messageType, string message, Id PubId ){
		if ( LogLevel >= 4) {
			System.Debug('*** '+messageType+'  '+message);
			LogDebug( messageType, message,'', PubId);
		}
	}

	//to be deprecated with Rel 1.2
	global static void LogDebug(string messageType, string message, string description){
		if ( LogLevel >= 4) {
			System.Debug('*** '+messageType+'  '+message);
			LogDebug( messageType, message,'', null);
		}
	}

	global static void LogError(string messageType, string message){
		System.Debug('*** '+messageType+'  '+message);
		LogError( messageType, message,'', null);   //always log error
	}
	
	
	//to be deprecated with Rel 1.2
	global static void LogError(string messageType, string message, string description){
		System.Debug('*** '+messageType+'  '+message);
		LogError( messageType, message,description, null);   //always log error
	}
	
	global static void LogError(string messageType, string message, id PubId){
		System.Debug('*** '+messageType+'  '+message);
		LogError( messageType, message,'', PubId);   //always log error
	}

	global static void LogInfo(string messageType, string message, string description, Id PubId ){
		if ( LogLevel >= 3) addLog(AppLogModel.TypeInfo,null, messageType, message,description, PubId);
	}

	global static void LogDebug(string messageType, string message, string description, Id PubId ){
		if ( LogLevel >= 4) addLog(AppLogModel.TypeDebug,null, messageType, message,description, PubId);
	}	

	global static void LogError(string messageType, string message, string description, Id PubId ){
		addLog(AppLogModel.TypeError,null, messageType, message,description, PubId);
	}	
	
	private static string pOrgUrl = null;
	private static string OrgUrl {
		get {
			if ( pOrgUrl == null) {
				pOrgUrl = AppearUrlModel.OrgUrl;
			}
			return pOrgUrl;
		}
	}
	
	global static void addLog(string logType, string RecordName, string messageType, string message, string description, id PubId ){

		if ( logType <> null && logType.length() > 10 ) {
			logType = logType.substring(0, 9);
		}
		if ( messageType <> null && messageType.length() > 100 ) {
			messageType = messageType.substring(0, 99);
		}
		if ( message <> null && message.length() > 255 ){
			message = message.substring(0,254);
		}
		if ( description <> null && description.length() > 32768){
			description = description.substring(0,32767);
		}

		AppLog__c entry = new AppLog__c();
 
		entry.logType__c = logType;
		entry.messageType__c = messageType;
		entry.message__c = message;
		entry.createdTime__c = DateTime.Now();
		entry.description__c = description;
		entry.RecordName__c = RecordName;
		
		if ( PubId <> null ) {  
			entry.logSubjectId__c = PubId;
			entry.RecordURL__c = OrgUrl+'//'+PubId;
		}
		applogs.add(entry);		   
		
		if ( appLogs.size() > appLogSizeLimit ){
			flushLogs('AppLogModel::AutoFlush');
		}
	}  
	
	global static void flushLogs(){
		flushLogs('No Label - should add a label to trace');
	}
	
	global static void flushLogs(string label){	
		if ( appLogs <> null && appLogs.size() > 0 ){
			insertLogs();
			appLogs.clear();
		}
	}
	
	private static void insertLogs() {
		integer successCount = 0;
		integer failureCount = 0;
		
		List<Database.SaveResult> mySaveResults = Database.insert(applogs, false);
		
		for(Database.SaveResult sr : mySaveResults){
                    
            if(sr.isSuccess()){
                successCount = successCount + 1;
            } else {
                failureCount = failureCount + 1;
                Database.Error err = sr.getErrors()[0];
                System.Debug('Save error for '+sr.getId()+ ':'+err);
            }
        }
        
        System.Debug('AppLogModel::flushLogs - success = '+successCount + '  failure = '+ failureCount);
	}
	
	global static List<AppLog__c> readAppLog(string messageType, integer limitCount) {
		if ( (limitCount <= 0) || (limitCount > 100)) {
			limitCount = 100;
		}

		List<AppLog__c> Logs = [
			select id, name, logType__c, messageType__c, message__c, description__c 
			from AppLog__c 
			where messageType__c = :messageType
			order by Name desc
			limit :limitCount ];
		return Logs;
	}
	
	
	////////////////////////  cleanup ///////////////////////
	// AppLogModel.CleanupAppLog();
	public static void CleanupAppLog() {
		List<sObject> records = [
			select id from AppLog__c
			limit 5000
		];
		
		if ( records.size() > 500) {
			integer delCount = records.size() - 500;
			List<sObject> delRecords = [
				select id from AppLog__c
				order by CreatedDate 
				limit :delCount
			];
			Delete delRecords;
			database.emptyRecycleBin(delRecords);
		}   
	}
	
	//AppLogModel.TruncateAppLog();
	public static void TruncateAppLog() {
		delete [select id from AppLog__c order by CreatedDate limit 10000];
	}

}