public  class DepartmentModelData {

	public static Department__c GlobalHealthEconomicDept {
		get {
			return DepartmentModel.DepartmentNameMap.get('Global Health Economics (GHE)');
		}
	}

	public static Department__c GlobalMedicalWritingDept {
		get {
			return DepartmentModel.DepartmentNameMap.get('Medical Writing');
		}
	}
	
	public static Department__c MedicalCommunicationsDept {
		get {
			return DepartmentModel.DepartmentNameMap.get('Global Value, Access, and Policy');
		}
	}


    public static void createData() {
    
        integer dataCount = [select count() from Department__c];
        if ( dataCount <> 0) return;
        
        List<Department__c> DepartmentList = new List<Department__c>();
        
        DepartmentList.add( new Department__c(name= 'Center for Observational Research (CfOR)', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
            		SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
		DepartmentList.add( new Department__c(name= 'Clinical Development', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
		DepartmentList.add( new Department__c(name= 'Discovery Research', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
		DepartmentList.add( new Department__c(name= 'Global Government Affairs', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
		DepartmentList.add( new Department__c(name= 'Global Health Economics (GHE)', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
		DepartmentList.add( new Department__c(name= 'Global Regulatory Affairs', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
		DepartmentList.add( new Department__c(name= 'Global Safety', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
		DepartmentList.add( new Department__c(name= 'Global Scientific Affairs', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
		DepartmentList.add( new Department__c(name= 'Global Value, Access, and Policy', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
		DepartmentList.add( new Department__c(name= 'Manufacturing', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
		DepartmentList.add( new Department__c(name= 'Medical Writing', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
            		SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null));     
		DepartmentList.add( new Department__c(name= 'Translational Sciences', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
        DepartmentList.add( new Department__c(name= 'Abgenix [Expired]', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, IsLogicallyDeleted__c=true)); 
        DepartmentList.add( new Department__c(name= 'Medical Research (Phase III-b, IV)', OrganizationId__c= OrganizationModel.OrganizationNameMap.get('Amgen').Id, 
		            SiebelRowId__c=null,Acronym__c=null, Type__c=null, URL__c=null, SponsorDept__c=true));
        insert DepartmentList;
                
     }
    
}