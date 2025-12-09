public class AppearUrlModel {

	private static string pOrgUrl = null;
	public static string OrgUrl {
		get {
			if ( pOrgUrl == null){
				pOrgUrl = URL.getSalesforceBaseURL().toExternalForm();
			}
			return pOrgUrl;
		}
	}
	
	public static string AppearHomePartialUrl = '/home/home.jsp';
	private static string pAppearHomeUrl = null;
	public static string AppearHomeUrl {
		get {
			if (pAppearHomeUrl == null ){
				pAppearHomeUrl = OrgUrl+AppearHomePartialUrl;
			}
			return pAppearHomeUrl;
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static string SearchTabId {	
		get {
			return 'sfdc.tabName=01ri00000004Oa0';
		}
	}

	public static string FprRequestTabId {
		get {
			return 'sfdc.tabName=01ri00000004R6p';
		}
	}
	
	private static string pAppearSearchUrl = null;
	public static string AppearSearchUrl {
		get {
			if (pAppearSearchUrl == null ){
				pAppearSearchUrl = VfUrl+'AppearSearch?'+SearchTabId;
			}
			return pAppearSearchUrl;
		}
	}
	public static string AppearSearchMenuUrl(string MenuName){
		return AppearSearchUrl
			+ '&'+ AppearConstants.SUBMENU +'='+MenuName;
	}
	public static string AppearSearchTileUrl(string MenuName,string TileName){
		return AppearSearchUrl
			+ '&'+ AppearConstants.SUBMENU +'='+MenuName
			+ '&'+ AppearConstants.TILE +'='+TileName;
	}
	
	  
	public static final string VfUrlKey = 'VrUrl';
	public static void refreshCustomSettingVfUrl() {
		KeyValueSettingsModel.SetKey(VfUrlKey, VfUrl);
	}
	

	private static boolean pIsPortal;
	public static boolean IsPortal {
		get {			
			if (pIsPortal == null) {
				pIsPortal = URL.getCurrentRequestUrl().toExternalForm().contains('/FprSubmitter/');
			}
			return pIsPortal;
		}
	}

	private static boolean pIsAuthorComm;
	public static boolean IsAuthorComm {
		get {			
			if (pIsAuthorComm == null) {
				pIsAuthorComm = URL.getCurrentRequestUrl().toExternalForm().contains('/PubAuthor/');
			}
			return pIsAuthorComm;
		}
	}

	private static string pVfUrl = null;
	public static string VfUrl {
		get {
			if ( pVfUrl == null){
				//portal condition.
				if (IsPortal) {
					pVfUrl = OrgUrl+'/FprSubmitter/apex/';
				} else if (IsAuthorComm){  // note: sf1 community user does not see the /PubAuthor in domain
					pVfUrl = OrgUrl+'/PubAuthor/apex/';  
				} else {
					pVfUrl = OrgUrl+'/apex/';
				}
			}
			return pVfUrl;
		}
	}
	
	private static string pAppearFprUrl = null;
	public static string AppearFprUrl {
		get {
			if (pAppearFprUrl == null ){
				pAppearFprUrl = VfUrl+'AppearFpr?'+PubTabId+'&sfdc.override=1';
			}
			return pAppearFprUrl;
		}
	}
	
	private static string pAppearPubUrl = null;
	public static string AppearPubUrl {
		get {
			if (pAppearPubUrl == null ){
				pAppearPubUrl = VfUrl+'AppearPub?'+PubTabId+'&sfdc.override=1';
			}
			return pAppearPubUrl;
		}
	}
	
	private static string pAppearFprSubmitterUrl = null;
	public static string AppearFprSubmitterUrl {
		get {
			if (pAppearFprSubmitterUrl == null ){
				pAppearFprSubmitterUrl = VfUrl+'AppearFprSubmitter?'+PubTabId+'&sfdc.override=1';
			}
			return pAppearFprSubmitterUrl;
		}
	}	
	
	private static string pAppearAuthorUrl = null;
	public static string AppearAuthorUrl {
		get {
			if (pAppearAuthorUrl == null ){
				pAppearAuthorUrl = VfUrl+'appearpubauthordashboard?'+PubTabId+'&sfdc.override=1';
			}
			return pAppearAuthorUrl;
		}
	}
	

	public static string PubTabId {
		get{
			return 'sfdc.tabName=01ri00000004OaA';
		}
	}
	

	public static string AppearPubMenuUrl(string MenuName, string TileName, string Id){
		string url =  AppearPubUrl
			+ '&'+ AppearConstants.SUBMENU +'='+MenuName
			+ '&'+ AppearConstants.TILE +'='+TileName;
		if (id != null) {
			url += '&Id='+Id;
		}			
		return url;
	}
	public static string AppearFprMenuUrl(string MenuName, string TileName, string Id){
		string url =  AppearFprUrl
			+ '&'+ AppearConstants.SUBMENU +'='+MenuName
			+ '&'+ AppearConstants.TILE +'='+TileName;
		if (id != null) {
			url += '&Id='+Id;
		}			
		return url;
	}
	public static string AppearFprSubmitterMenuUrl(string MenuName, string TileName, string Id){
		string url = AppearFprSubmitterUrl
			+ '&'+ AppearConstants.SUBMENU +'='+MenuName
			+ '&'+ AppearConstants.TILE +'='+TileName;
		if (id != null) {
			url += '&Id='+Id;
		}			
		return url;
	}
	public static string AppearAuthorMenuUrl(string MenuName, string TileName, string Id){
		string url = AppearAuthorUrl
			+ '&'+ AppearConstants.SUBMENU +'='+MenuName
			+ '&'+ AppearConstants.TILE +'='+TileName;
		if (id != null) {
			url += '&Id='+Id;
		}			
		return url;
	}

	public static string AppearPubMenuUrl(string MenuName, string TileName){
		return AppearPubUrl
			+ '&'+ AppearConstants.SUBMENU +'='+MenuName
			+ '&'+ AppearConstants.TILE +'='+TileName;
	}
	
	public static string AppearPubListUrl(){
		return OrgUrl+'/apex/AppearPubList?save_new=1&sfdc.override=1'; 
	}
	
	
	private static string pFprPortalPath = null;
	public static string GetFprPortalPathForPubId(id PubId) {
		if (pFprPortalPath == null) {
			List<Network> networks = [SELECT UrlPathPrefix FROM Network WHERE Name = 'FPR Submitter' limit 1];
			List<Domain> domains = [SELECT Domain FROM Domain WHERE DomainType = 'DNS' limit 1];
			
			if (networks.size() == 0 || domains.size() == 0) {
				AppLogModel.LogError('AppearUrlModel::GetFprPortalPathForPubId', 'Network + Domains are not properly configured to provide community url');
				AppLogModel.flushLogs();
				return null;
			}
			
			Network portalNetwork = networks[0];
			Domain portalDomain = domains[0];
			
			pFprPortalPath = 'https://' + portalDomain.Domain + '/' + portalNetwork.UrlPathPrefix + '/apex/AppearFprSubmitter?tile=Pub Details&Id=';
		}
		return pFprPortalPath + PubId;
	}
	
	/**
		Added this simple function to return the Sharepoint URL for the 
		FPR Submitters to access APPEAR via Emails
	*/
	public static string GetSimpleFprPortalPath() {
		return 'https://myteams.amgen.com/sites/SA_GMW/FPR/default.aspx';
	}
	
	public static string ChatterFeedIdToUrl(id chatterFeedId){
		string baseDomain;
		if (!IsPortal && !IsAuthorComm) {
			baseDomain = KeyValueSettingsModel.GetKey('ChatterFeedItem_BaseDomain', OrgUrl).value__c;
		} else {
			baseDomain = KeyValueSettingsModel.GetKey('ChatterFeedItem_BaseDomain').value__c;
		}
		//get the custom setting
		
		List<FeedItem> feedItems = [
			select id, ContentFileName, ContentSize, RelatedRecordId
			from FeedItem
			where id = :chatterFeedId
		];
		
		String result = '';
		if ( feedItems.size() == 1){
			result = baseDomain + '/'+feedItems[0].RelatedRecordId;
		} 
		AppLogModel.LogInfo('AppearUrlModel::ChatterFeedIdToUrl', 'URL = '+result+' for chatterFeedId '+ chatterFeedId);
		
		return result;
	}
}