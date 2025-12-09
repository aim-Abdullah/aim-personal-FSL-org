public class DataSourceModel {
	
	

    
	private static map<string, DataSource__c> pDataSourceMapByName = null;
	public static map<string, DataSource__c>  DataSourceMapByName {
		get {
			if (pDataSourceMapByName == null){
				pDataSourceMapByName = new map<string, DataSource__c>  ();
				for(DataSource__c ds : DataSourceList){
					pDataSourceMapByName.put(ds.name, ds);
				}
			}
			return pDataSourceMapByName;
		}
	}
	
	public static string getDataSourceName(Id DataSourceId) {
		if (DataSourceMap.containskey(DataSourceId) ) {
			return DataSourceMap.get(DataSourceId).Name;
		} else {
			return null;
		}
	}

	private static map<Id, DataSource__c> pDataSourceMap = null;
	public static map<Id, DataSource__c>  DataSourceMap {
		get {
			if (pDataSourceMap == null){
				pDataSourceMap = new map<Id, DataSource__c>  ();
				for(DataSource__c ds : DataSourceList){
					pDataSourceMap.put(ds.Id, ds);
				}
			}
			return pDataSourceMap;
		}
	}
	
	private static List<DataSource__c> pDataSourceList = null;
	public static List<DataSource__c> DataSourceList{
		get {
			if (pDataSourceList == null){
				pDataSourceList = getAllDataSources();
			}
			return pDataSourceList;
		}
	}
	
	 public static DataSource__c lookUpDataSource(string dataSource) {
        if (DataSourceMap.containsKey(dataSource)) {
            return DataSourceMap.get(dataSource);
        } else {
            return null;
        }   
    }
	
	public static List<DataSource__c> getAllDataSources() {
		List<DataSource__c> result = [
			Select d.Name, d.Id, d.isLogicallyDeleted__c
			From DataSource__c d
			where d.isLogicallyDeleted__c = false
			order by d.Name
		];
		
		return result;
	}
	
	private static DataSource__c pDevelopment = null;
	public static DataSource__c Development {
		get {
			if ( pDevelopment == null) {
				pDevelopment =DataSourceMapByName.get('Development');  
			}
			return pDevelopment;  
		}	
	}
}