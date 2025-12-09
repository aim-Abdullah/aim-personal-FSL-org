public class AppearEnvSetup {
    //Setup Appear in a new Org with minimal Reference Data that cannot be migrated with ChangeSet
    
    //AppearEnvSetup.Initialize();
    public static void Initialize(){
    	
    	AppLogModel.setLogLevelDebug();
    	AppLogModelSchedule.SetAppearLogLeftOverItems(500);
    
    	AppLogModelSchedule.scheduleHourly();
    	BatchResetSharingSchedule.scheduleResetSharing();
    	AppearNightlyBatchSchedule.scheduleDaily1am();
    	
    	AppearTriggerActivationModel.activateTriggersAfterDataMigration();
    	
    	
    	//find the temp pub owner cloned from Prod
    	List<User> users = [select userName from User where userName like 'temporarypubowner@amgen.com%' ];
    	if (users.size() == 1) {
    		KeyValueSettingsModel.SetKey('TemporaryPubOwner', users[0].userName );  //'TemporaryPubOwner@amgen.com.dev11'
    	}
        
        StatusModelData.createData();
        PubTypeModelData.createData();
        
        RegionModelData.createData();
        CountryModelData.createData();
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        
        AccountModelData.createData();
        AppearContactModelData.createData();
        AppearRoleModelData.createData();
        
        TherapeuticAreaModelData.createData();
        AmgenProductModelData.createData();
        IndicationModelData.createData();  
        ProductIndicationModelData.createData();
        ProdIndiObjectiveModelData.createData();
        
 
        ProdIndObjSciStatementModelData.createData();
        
        DataSourceModelData.createData();
        SubGroupModelData.createData();
        //Categories
        //Plans
        //Studies
        
        MeetingModelData.createData();
        JournalModelData.createData();
        
        MEScopeOfWorkModelData.createData();   //ME -- not sure about this yet
        
        ProfileTabModelData.createData();
        ProfileTabTileModelData.createData();
    }
    
  
}