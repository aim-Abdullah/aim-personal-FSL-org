public class SchemaModel {

	private static Map<string, string> pObjectPrefixMap = null;
	public static Map<string, string> objectPrefixMap{
		get {
			if ( pObjectPrefixMap == null) {
				pObjectPrefixMap = initSalesforceIdPrefix();
			}
			return pObjectPrefixMap;
		}
	}
		
	// Going through Salesforce Object and associate Object's name with its ID prefix
	public static Map<string, string> initSalesforceIdPrefix(){
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
		Map<string, string> keyPrefixMap = new Map<string, string>();
		for(String sObj : gd.keySet()){
		   Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
		   String tempName = r.getName();
		   String tempPrefix = r.getKeyPrefix();
		   //System.debug('Processing Object['+tempName + '] with Prefix ['+ tempPrefix+']');
		   keyPrefixMap.put(tempPrefix,tempName);
		}
		
		return keyPrefixMap;
	}
	
	@Istest
	public static void UnitTest(){
	
		System.assertNotEquals(null, SchemaModel.objectPrefixMap.get('00D'));
		System.debug(SchemaModel.objectPrefixMap.get('00D'));
	}
}