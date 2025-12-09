public class SubGroupModelData {


    private static SubGroup__c pIRD = null;
	public static SubGroup__c DevelopmentIrdSubGroup {
		get {
			if ( pIrd == null) {
				pIrd =SubGroupModel.SubGroupNameMap.get('Global Dev - LACAN');  
			}
			return pIrd;  
		}	
	}
	
		
	private static SubGroup__c pSmpDevelopment = null;
	public static SubGroup__c DevelopmentSmpSubGroup {
		get {
			if ( pSmpDevelopment == null) {
				pSmpDevelopment =SubGroupModel.SubGroupNameMap.get('GRAAS');  
			}
			return pSmpDevelopment;  
		}	
	}
	
    public static void createData() {
        
        integer dataCount = [select count() from SubGroup__c];
        if ( dataCount <> 0) { 
        	return;
        }
        
        List<SubGroup__c> subGroupList = new List<SubGroup__c>();

		subGroupList.add( new SubGroup__c(name= 'Global Dev - Asia Pac', Data_Source__c=DataSourceModelData.Development.id));
		subGroupList.add( new SubGroup__c(name= 'Global Dev - China', Data_Source__c=DataSourceModelData.Development.id));
		subGroupList.add( new SubGroup__c(name= 'Global Dev - EEMEA', Data_Source__c=DataSourceModelData.Development.id));
		subGroupList.add( new SubGroup__c(name= 'Global Dev - Europe', Data_Source__c=DataSourceModelData.Development.id));
		subGroupList.add( new SubGroup__c(name= 'Global Dev - Japan', Data_Source__c=DataSourceModelData.Development.id));
		subGroupList.add( new SubGroup__c(name= 'Global Dev - LACAN', Data_Source__c=DataSourceModelData.Development.id));
		subGroupList.add( new SubGroup__c(name= 'Global Dev - Other', Data_Source__c=DataSourceModelData.Development.id));
		subGroupList.add( new SubGroup__c(name= 'Global Dev - US', Data_Source__c=DataSourceModelData.Development.id));
        
        subGroupList.add( new SubGroup__c(name= 'Ops - Comm Quality', Data_Source__c=DataSourceModelData.Operations.id));
        subGroupList.add( new SubGroup__c(name= 'Ops - DP&DD', Data_Source__c=DataSourceModelData.Operations.id));
        subGroupList.add( new SubGroup__c(name= 'Ops - Mfg Sciences & Tech', Data_Source__c=DataSourceModelData.Operations.id));
        subGroupList.add( new SubGroup__c(name= 'Ops - Other', Data_Source__c=DataSourceModelData.Operations.id));
        subGroupList.add( new SubGroup__c(name= 'Ops - Quality Admin', Data_Source__c=DataSourceModelData.Operations.id));
        
		subGroupList.add( new SubGroup__c(name= 'Research - CBSS', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - Early Dev', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - Genome Analysis', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - Hem & Onc', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - Inflammation', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - Met. Disorders', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - Neuroscience', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - Other', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - P&PD', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - Pharmaceutics', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - PKDM', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - SMP&PD', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - Therapeutic Discovery', Data_Source__c=DataSourceModelData.Research.id));
		subGroupList.add( new SubGroup__c(name= 'Research - Therapeutic Innovation', Data_Source__c=DataSourceModelData.Research.id));        
		
		subGroupList.add( new SubGroup__c(name= 'GRAAS', Data_Source__c=DataSourceModelData.GRAAS.id));
        
        insert subGroupList;
    }
    
}