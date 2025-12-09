@RestResource(urlMapping='/EchoWebService/v1/*')
global class EchoWebService {
	
	//login to get token with
	//https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9A2kN3Bn17hv5YztIw3lznbO.PNUVYF45rpDAMXQtym1z5pTcAQbe7OcHRhWOCwT.bYoW5mKD3fJMk63K&client_secret=2829144774400052224&username=blau@amgenpoc.com&password=P@ssw1rd
	
	//then post to 
	//https://na15.salesforce.com/services/apexrest/EchoWebService/v1/
	//
	//Authorization    OAuth 00Di0000000HHhd!ARwAQBGmh3kD925.bL6oMf4WuKWnbbIzsgbSMU63uRyvS6XHZLhxysZgEnTzYJAQbtL6jL29X971yMCMRaTqwZgr4aB286Sl
	//Content-Type     application/json		
 
 	//Sample parameter to invoke from postman
 	/*
	{
		"echo" : "what"
	}
	*/
	@httpPost
	global Static string post (string echo) {
		
		String msg = 'EchoWebService : '+ echo;
		System.Debug(msg);
		AppLogModel.LogInfo('EchoWebService::post', msg);
		AppLogModel.flushLogs();
		return echo;
	} 
}