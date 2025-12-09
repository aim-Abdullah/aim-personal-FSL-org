public class AmgenProductModel {

	public static Map<id,AmgenProduct__c> getProductById(set<id> productIds) {
		
		Map<id,AmgenProduct__c> result = new Map<id,AmgenProduct__c> ();
		for(Id productId : productIds) {
			if (AmgenProductMap.containsKey(productId)) {
				result.put(productId, AmgenProductMap.get(productId));
			}
		}
		return result;
	}


	public static AmgenProduct__c getProductByName(string productName) {
		if ( AmgenProductMapByName.containsKey(productName)) {
			return AmgenProductMapByName.get(productName);
		} else {
			AppLogModel.LogError('AmgenProductModel::getProductByName', 'Cannot find product : '+productName);  //cannot add PubId to this log message
			return null;
		}
	}
	
	private static List<AmgenProduct__c> pAllProducts = null;
	public static List<AmgenProduct__c> AllProducts {
		get {
			if (pAllProducts == null ){
				pAllProducts = getAllAmgenProducts();
			}
			return pAllProducts;
		}
	}
	
	private static List<string> pAllProductNames = null;
	public static List<string> AllProductNames {
		get {
			if (pAllProductNames ==null){
				pAllProductNames = new List<string>();
				for(AmgenProduct__c prod : AllProducts) {
					pAllProductNames.add(prod.Name);
				}
			}
			return pAllProductNames;
		}
		
	}
	
	private static Map<id,AmgenProduct__c> pAmgenProductMap = null;
	public static Map<id,AmgenProduct__c> AmgenProductMap {
		get {
			if (pAmgenProductMap == null ) {
				pAmgenProductMap =getAllAmgenProductMap();
			}
			return pAmgenProductMap;
		}
	}

	private static Map<String,AmgenProduct__c> pAmgenProductMapByName = null;
	public static Map<String,AmgenProduct__c> AmgenProductMapByName {
		get {
			if (pAmgenProductMapByName == null ) {
				pAmgenProductMapByName =getAllAmgenProductMapByName();
			}
			return pAmgenProductMapByName;
		}
	}


	public static list<AmgenProduct__c> getAllAmgenProducts() {
		list<AmgenProduct__c> products = [
			Select id, SiebelRowId__c, Old_ProductName__c, Name,
			ODS_DrugId__c, Molecule_Name__c,isEnbrel__c,
			Product_Description__c
			From AmgenProduct__c 
			where isLogicallyDeleted__c = false   //Def 592
			order by Name
		];
		return products;
	}
	
	public static Map<id,AmgenProduct__c> getAllAmgenProductMap() {		
		Map<id,AmgenProduct__c> result = new Map<id,AmgenProduct__c>();
		for(AmgenProduct__c prod : AllProducts) {
			result.put(prod.id, prod);
		}
		return result;
	}
	

	public static Map<string,AmgenProduct__c> getAllAmgenProductMapByName() {		
		Map<string,AmgenProduct__c> result = new Map<string,AmgenProduct__c>();
		for(AmgenProduct__c prod : AllProducts) {
			result.put(prod.Name, prod);
		}
		return result;
	}
	
	
}