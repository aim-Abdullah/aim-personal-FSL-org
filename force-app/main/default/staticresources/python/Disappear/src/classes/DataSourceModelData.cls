public class DataSourceModelData {

    public static void createData() {
        
        integer dataCount = [select count() from DataSource__c];
        if ( dataCount <> 0) return;
        
        List<DataSource__c> dataSourceList = new List<DataSource__c>();


        dataSourceList.add( new DataSource__c(name= 'Development'));
        dataSourceList.add( new DataSource__c(name= 'GRAAS'));
        dataSourceList.add( new DataSource__c(name= 'Operations'));
        dataSourceList.add( new DataSource__c(name= 'Research'));        
        insert dataSourceList;
    }
    
    public static DataSource__c Development {
    	get {
    		return DataSourceModel.DataSourceMapByName.get('Development');		
    	}
    }

    public static DataSource__c Operations {
    	get {
    		return DataSourceModel.DataSourceMapByName.get('Operations');		
    	}
    }

    public static DataSource__c Research {
    	get {
    		return DataSourceModel.DataSourceMapByName.get('Research');		
    	}
    }
    
    public static DataSource__c GRAAS {
    	get {
    		return DataSourceModel.DataSourceMapByName.get('GRAAS');		
    	}
    }    
}