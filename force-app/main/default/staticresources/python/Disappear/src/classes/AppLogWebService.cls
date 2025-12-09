@RestResource(urlMapping='/AppLogWebService/v1/*')
global class AppLogWebService {

	@httpPost
	global Static void post (string LogType, string MessageType, string Message, string Description) {
		
		if ( LogType == 'Info') {
			AppLogModel.LogInfo(messageType, Message, Description);
		} else if ( LogType == 'Debug'){
			AppLogModel.LogDebug(messageType, Message, Description);
		} else {
			AppLogModel.LogError(messageType, Message, Description);
		}
		
		AppLogModel.flushLogs();
		return;
	} 	
}