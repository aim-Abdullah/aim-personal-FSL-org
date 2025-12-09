@IsTest
public class DataSourceModelTest {

    @IsTest
    public static void UnitTest() {
        System.assertNotEquals(null, DataSourceModel.getAllDataSources());
        System.assertEquals(0, DataSourceModel.getAllDataSources().size());
        
        DataSourceModelData.createData();
        
        System.assertNotEquals(null, DataSourceModel.DataSourceList);
        System.assert(DataSourceModel.DataSourceList.size() > 0);
      
        System.assertNotEquals(null, DataSourceModel.DataSourceMapByName);
        System.assert(DataSourceModel.DataSourceMapByName.size() > 0);
      
        System.assertNotEquals(null, DataSourceModelData.Development);
        System.assertNotEquals(null, DataSourceModelData.Operations);
        System.assertNotEquals(null, DataSourceModelData.Research);      
        
        System.assertNotEquals(null, DataSourceModel.Development);
      
        boolean caughtDupError = false;
        try {
            DataSource__c dupDS = new DataSource__c();
            dupDS.name = 'Development';
            insert dupDS;           
        } catch ( DMLException e){
            System.Debug(e);
            System.assert( e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            caughtDupError = true;
        } finally {
            System.assert(caughtDupError);
        }
    }
    
    
     @IsTest public static void StatusModelSeeAllDataTest() {
       StatusModelSeeAllDataTest.checkAll();      
       StatusModelSeeAllDataTest.checkLegacyStatus();      
    }
}