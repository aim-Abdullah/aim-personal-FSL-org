public class ProductIndicationModel {
	
	
	private static List<ProductIndication__c> pProductIndicationList = null;
	public static List<ProductIndication__c> ProductIndicationList{
		get {
			if ( pProductIndicationList == null){
				pProductIndicationList = getAllProductIndications();
			}
			return pProductIndicationList;
		}
	}

	public static string getProductIndicationName(Id ProductIndicationId) {
		if (ProductIndicationMap.containskey(ProductIndicationId) ) {
			return ProductIndicationMap.get(ProductIndicationId).Name;
		} else {
			return null;
		}
	}

	private static Map<Id, ProductIndication__c> pProductIndicationMap = null;
	public static Map<Id, ProductIndication__c> ProductIndicationMap {
		get {
			if (pProductIndicationMap == null){
				pProductIndicationMap = new Map<Id, ProductIndication__c> ();
				for(ProductIndication__c prodInd : ProductIndicationList) {
					pProductIndicationMap.put(prodInd.id, prodInd);
				}
			}
			return pProductIndicationMap;
		}
	}
	
	private static Map<String, ProductIndication__c> pProductIndicationNameMap = null;
	public static Map<String, ProductIndication__c> ProductIndicationNameMap {
		get {
			if (pProductIndicationNameMap == null){
				pProductIndicationNameMap = getProductIndicationMapByName();
			}
			return pProductIndicationNameMap;
		}
	}

	public static Map<Id, ProductIndication__c> getProductIndicationByIndication(set<id> indicationIds) {
		Map<Id, ProductIndication__c> result = new Map<ID, ProductIndication__c> ();
		for(ProductIndication__c prodInd : ProductIndicationList) {
			if ( indicationIds.contains(prodInd.id) ){
				result.put(prodInd.id, prodInd);
			}
		}
		return result;
	}  
	
	
	public static List<ProductIndication__c> getAllProductIndications() {
		 List<ProductIndication__c>  result = [
		 	select id, Name, Product__c, Indication__c, Therapeutic_Area__c, isEnbrel__c
		 	from ProductIndication__c
		 	where isLogicallyDeleted__c = false   //def #592
		 	order by Name
		 ];
		 return result;
	}
	//Code unit started for CR: #139
	//Return all expired product indication Id and Name Map as per argument
	public static Map<Id,String> getMapAllExpiredProductIndicationName(Set<Id> prodIndicationIdSet) {
		 List<ProductIndication__c>  ExpProdIndications = [
		 	select id, Name 
		 	from ProductIndication__c
		 	Where isLogicallyDeleted__c = true and
		 	Id IN:prodIndicationIdSet
		 ];
		 Map<Id,String> MapExpiredProdIndication = new Map<Id,String>();
		 if(ExpProdIndications.size()!= 0)
		 {
			 for(ProductIndication__c prodInd : ExpProdIndications)
				{
									
					MapExpiredProdIndication.put(prodInd.Id,prodInd.Name);
					
				}
		 }
		 return MapExpiredProdIndication;
	}
	//Code unit ended for CR: #139
	
	public static Map<String, ProductIndication__c> getProductIndicationMapByName() {
		Map<String, ProductIndication__c> result = new Map<String, ProductIndication__c>();
		for(ProductIndication__c prodInd : ProductIndicationList){
			result.put(prodInd.Name, prodInd);
		}
		AppLogModel.LogInfo('ProductIndicationModel::getProductIndicationMapByName', 
			'getProductIndicationMapByName found  ' + result.size() +' ProductIndicator');

		return result;
	}

	public static string toStringFromIdList(List<string> idList){
		string result = '';
		for(string idstr : idList){
			result +=toStringFromId(idStr);
		}
		
		//AppLogModel.LogInfo('ToStringFromIdList', result);
		return result;
	}
	public static string toStringFromId(string idstr){
		if ( idstr == null){
			return 'null';
		}
	
		if ( idstr == ''){
			return '<emptyString>';
		}
		string result = '';
		if (ProductIndicationMap.containskey(idstr)) {
			ProductIndication__c pi = ProductIndicationMap.get(idstr);
			result +=  ': ' + pi.name + ' ';
		} else {
			result += ' :  unknown Production Indication '+idstr;
		}
		return result;
	}

	
}