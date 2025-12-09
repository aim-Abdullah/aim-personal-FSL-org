global class KeyValueSettingsModel {

	//All custom settings data is exposed in the application cache, which enables efficient access without the cost of repeated 
	//queries to the database. However, querying custom settings data using Standard Object Query Language (SOQL) 
	//doesn't make use of the application cache and is similar to querying a custom object. 
	//
	//To benefit from caching, use other methods for accessing custom settings data such as the Apex Custom Settings methods.

	//keyPattern should include the '%' wild card
	global static List<KeyValueSettings__c> GetKeyByPattern(string keyPattern){
		if ( keyPattern == null) return new List<KeyValueSettings__c>() ;
		  
		 
		try {
			List<KeyValueSettings__c> result = [ 
				select key__c, value__c, createdDate__c
				from KeyValueSettings__c 
				where key__c like :keyPattern
			];
			return result;
		} catch (Exception e) {
			return new List<KeyValueSettings__c>();
		}
	}

	global static KeyValueSettings__c GetKey(string key){
		return GetKey(key, null);
	}
	global static KeyValueSettings__c GetKey(string key, string defaultValue){
		if ( key == null) {
			KeyValueSettings__c result = new KeyValueSettings__c();
			result.key__c = key;
			result.value__c = defaultValue;
			result.Name = key;
			return result;
		}
		
		List<KeyValueSettings__c> result = [ 
				select key__c, value__c, createdDate__c
				from KeyValueSettings__c 
				where key__c = :key
		];
		
		if ( result.size() == 1) {
			return result[0];
		} else {
			KeyValueSettings__c defResult = new KeyValueSettings__c();
			defResult.key__c = key;
			defResult.value__c = defaultValue;
			defResult.Name = key;
			if (defaultValue != null) { //Brandon to review with ben avoiding DML error on constructor
				insert defResult;
			}
			
			return defResult;		
		}
	}
	
	global static string getValue(string key){
		if ( key == null) return null;
		KeyValueSettings__c result = GetKey(key);
		if ( result == null) return null;
		
		return result.Value__c;
	}

	
	global static KeyValueSettings__c SetKey(string key, string value) {
		if ( key == null) {
			return null;
		}
		
		KeyValueSettings__c result = GetKey(key);
		if (result == null){
			result = new KeyValueSettings__c();
			result.key__c = key;
			result.Name = key;
		}
		result.value__c = value;
		upsert result;
		
		return result;
	}
	
	global static void ClearKey(string key){
		if ( key == null) {
			return;
		}
		
		KeyValueSettings__c result = GetKey(key);
		if (result != null && result.id <> null){
			delete result;
		}
		return;
	}
	

	

}