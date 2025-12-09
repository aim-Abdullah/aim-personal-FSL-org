public class HierarchySettingsModel {

	//http://help.salesforce.com/help/doc/en/cs_accessing.htm
	//formula field can read from hierarchy Custom setting
	//
	// 
	public static void updateOrgUrlCustomSetting() {
		//update the Org URL in custom settings to avoid hard code		
		OrgUrl__c orgUrl = OrgUrl__c.getOrgDefaults();
		if ( orgUrl.OrgURL__c == null) {
			orgUrl.OrgURL__c = AppearUrlModel.OrgUrl;
			upsert orgUrl;
		}
		if ( orgUrl.VfURL__c == null) {
			orgUrl.VfURL__c = AppearUrlModel.VfUrl;
			upsert orgUrl;
		}
	}


	@isTest
	public static void unitTest() {
		System.Debug( AppearUrlModel.VfUrl);
		//{!$Setup.OrgUrl__c.VfUrl__c}  should return http://cs9.salesforcec.com/apex/
		HierarchySettingsModel.updateOrgUrlCustomSetting();
		HierarchySettingsModel.updateOrgUrlCustomSetting();
		
		OrgUrl__c CS = OrgUrl__c.getInstance();
		System.Assert(CS.OrgUrl__c == AppearUrlModel.OrgUrl);
		System.assert(CS.VfUrl__c == AppearUrlModel.VfUrl);
		//System.assertEquals('http://cs9.salesforce.com/apex/',CS.VfUrl__c, 'http://cs9.salesforce.com/apex/');
		
	}
}