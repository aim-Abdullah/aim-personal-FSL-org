public  class OrganizationModelData {

    public static void createData() {
    
        integer dataCount = [select count() from Organization__c];
        if ( dataCount <> 0) return;
        
        List<Organization__c> OrganizationList = new List<Organization__c>();
        
        OrganizationList.add( new Organization__c(name= 'Amgen', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Amgen Internal', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'Astellas', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Vendor', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'AstraZeneca/MedImmune', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Vendor', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'Cytokinetics', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Amgen Internal', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'Daiichi-Sankyo', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Amgen Internal', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'Genentech, Inc.', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Amgen Internal', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'GlaxoSmithKline (GSK)', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Partner', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'Kirin', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Partner', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'Novartis', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Partner', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'Pfizer', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Partner', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'Servier', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Partner', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'Takeda', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Vendor', URL__c=null, SponsorOrg__c= true));
		OrganizationList.add( new Organization__c(name= 'UCB Pharma', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Vendor', URL__c=null, SponsorOrg__c= true));
        OrganizationList.add( new Organization__c(name= 'ANC Study Group [Expired]', ParentOrgId__c = null, SiebelRowId__c=null, Type__c='Vendor', URL__c=null, SponsorOrg__c= true, IsLogicallyDeleted__c = true));
        
        insert OrganizationList;
     }
    
}