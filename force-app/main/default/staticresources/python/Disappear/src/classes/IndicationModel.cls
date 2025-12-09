public class IndicationModel {

	public static Indication__c getIndicationByName(string IndicationName) {
		if ( IndicationMapByName.containsKey(IndicationName)) {
			return IndicationMapByName.get(IndicationName);
		} else {
			AppLogModel.LogError('IndicationModel::getIndicationByName', 'Cannot find Indication : '+IndicationName);
			return null;
		}
	}
	
	private static List<Indication__c> pAllIndications = null;
	public static List<Indication__c> AllIndications {
		get {
			if (pAllIndications == null ){
				pAllIndications = getAllIndications();
			}
			return pAllIndications;
		}
	}
	
	private static List<string> pAllIndicationNames = null;
	public static List<string> AllIndicationNames {
		get {
			if (pAllIndicationNames ==null){
				pAllIndicationNames = new List<string>();
				for(Indication__c prod : AllIndications) {
					pAllIndicationNames.add(prod.Name);
				}
			}
			return pAllIndicationNames;
		}
		
	}
	
	private static Map<id,Indication__c> pAllIndicationMap = null;
	public static Map<id,Indication__c> IndicationMap {
		get {
			if (pAllIndicationMap == null ) {
				pAllIndicationMap =getAllIndicationMap();
			}
			return pAllIndicationMap;
		}
	}
	
	private static Map<String,Indication__c> pIndicationMapByName = null;
	public static Map<String,Indication__c> IndicationMapByName {
		get {
			if (pIndicationMapByName == null ) {
				pIndicationMapByName =getIndicationMapByName();
			}
			return pIndicationMapByName;
		}
	}
	
	public static list<Indication__c> getAllIndications() {
		list<Indication__c> indications = [
			Select id, Name, Indication_Desc__c, SiebelRowId__c
			From Indication__c
			where isLogicallyDeleted__c = false  // def #592 
			order by Name
		];
		return indications;
	}
	
	public static Map<id,Indication__c> getAllIndicationMap() {		
		Map<id,Indication__c> result = new Map<id,Indication__c>();
		for(Indication__c ind : AllIndications) {
			result.put(ind.id, ind);
		}
		return result;
	}
	
	public static Map<string,Indication__c> getIndicationMapByName() {		
		Map<string,Indication__c> result = new Map<string,Indication__c>();
		for(Indication__c ind : AllIndications) {
			result.put(ind.Name, ind);
		}
		return result;
	}	

}