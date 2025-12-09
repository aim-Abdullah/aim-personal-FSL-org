public class UnitTestData {
	public static void PubTypeTestData() {
		integer pubTypeCount = [select count() from PubType__c ];
		if (pubTypeCount == 0) {
			PubTypeModelData.createData();
			pubTypeCount = [select count() from PubType__c ];
			System.assertNotEquals(0, pubTypeCount);
		}	
	}

	// refence tables
	
	public static void StatusTestData() {
		integer statusCount = [select count() from Status__c ];
		if (statusCount == 0) {
			StatusModelData.createData();
			
			statusCount = [select count() from Status__c ];
			System.assertNotEquals(0, statusCount);
		}
		
	}
	
	// junction tables
	
	
	// transaction tables
	
	public static Publication__c PublicationNew(string title){
		AppLogModel.LogInfo('UnitTestData::PublicationNew', 'Creating pub with title '+title);
			
		StatusTestData();
		Status__c FprOnlyStatus = StatusModel.LookUpStatus('Pending FPR Submission'); 
		System.assertNotEquals(null, FprOnlyStatus,' missing Pending FPR Submission');
		
//		PubTypeTestData();
		List<PubType__c> pubtypes = new List<PubType__c>();
		pubTypes.add( new PubType__c(name='Manuscript', displayOrder__c=120, DefaultTargetType__c= 'Journal',
            MePoint__c = 1.00, ME_plus__c=0.25));
                insert PubTypes;    
		//Appear Enhancement R2
		List<Contact> con= new List<Contact>();
		con.add(new contact(FirstName='Test', LastName='Contact', Email='testcontact@con.com', country__c='United States'));
		insert con;
		//Appear Enhancement R2
		List<Region__c> RegionList = new List<Region__c>();
		RegionList.add( new Region__c(name= 'US'));
		insert RegionList;
		//Appear Enhancement R2
		List<Country__c> CountryList = new List<Country__c>();
		CountryList.add( new Country__c(name= 'United States' , RegionId__c=RegionModel.RegionNameMap.get('US').id));
		insert CountryList;
		
		MEScopeOfWorkModelData.createData();
		DataSourceModelData.createData();
		SubGroupModelData.createData();
		
		Publication__c pub = new Publication__c();
		pub.Publication_Title__c = title; 
		PubType__c ManuscriptType = PubTypeModel.LookupPubType('Manuscript');
		System.assertNotEquals(null, ManuscriptType, ' missing Manuscript PubType');
		pub.Publication_Type__c = 'Manuscript';
		pub.FPR_Due_Date__c = System.today().addDays(30);
		pub.Product_Indication__c = 'Product Indication 1;Product Indication 2';
		pub.Data_Source__c = 'Development';  
		pub.SubGroup_pick__c = 'Development - GRAAS';
		pub.SubGroup__c = SubGroupModelData.DevelopmentSmpSubGroup.Id;
	    pub.Execution_Notes__c = 'this is execution notes test case scenario';
		pub.Execution_Notes_Last_Mod__c = DateTime.valueOf('2014-09-09 20:57:00');
		pub.SponsorDept_Pick__c='Clinical Development';//Appear Enhancement R2
		pub.SponsorOrg_Pick__c='Amgen';//Appear Enhancement R2
		pub.Country_pick__c='United States';//Appear Enhancement R2
		pub.RAE__c=con[0].id;//Appear Enhancement R2
		pub.GPP_Type__c='SP';//Appear Enhancement R3
		
		AppLogModel.LogInfo('UnitTestData::PublicationNew', 'insert new pub records');
		insert pub;

		System.assertNotEquals(null, pub);
		System.assertNotEquals(null, pub.id);
		System.assertNotEquals(null, pub.Data_Source__c);
		System.assertNotEquals(null, pub.SubGroup__c);
		
		Publication__c pubupdated = [Select Id,PubStatus__c from Publication__c where id =:pub.id];
		System.assertNotEquals(null,pubupdated.PubStatus__c );
		
		return pub;
	}
	
	public static Publication__c newPublication(string title){
		AppLogModel.LogInfo('UnitTestData::PublicationNew', 'Creating pub with title '+title);
			
		StatusTestData();
		Status__c FprOnlyStatus = StatusModel.LookUpStatus('Pending FPR Submission'); 
		System.assertNotEquals(null, FprOnlyStatus,' missing Pending FPR Submission');
		
//		PubTypeTestData();
		List<PubType__c> pubtypes = new List<PubType__c>();
		pubTypes.add( new PubType__c(name='Manuscript', displayOrder__c=120, DefaultTargetType__c= 'Journal',
            MePoint__c = 1.00, ME_plus__c=0.25));
                insert PubTypes;    
		//Appear Enhancement R2
		List<Contact> con= new List<Contact>();
		con.add(new contact(FirstName='Test', LastName='Contact', Email='secondcontact@con.com', country__c='United States'));
		insert con;
		//Appear Enhancement R2
		List<Region__c> RegionList = new List<Region__c>();
		RegionList.add( new Region__c(name= 'US'));
		insert RegionList;
		//Appear Enhancement R2
		List<Country__c> CountryList = new List<Country__c>();
		CountryList.add( new Country__c(name= 'United States' , RegionId__c=RegionModel.RegionNameMap.get('US').id));
		insert CountryList;
		
		MEScopeOfWorkModelData.createData();
		DataSourceModelData.createData();
		SubGroupModelData.createData();
		
		Publication__c pub = new Publication__c();
		pub.Publication_Title__c = title; 
		PubType__c ManuscriptType = PubTypeModel.LookupPubType('Manuscript');
		System.assertNotEquals(null, ManuscriptType, ' missing Manuscript PubType');
		pub.Publication_Type__c = 'Manuscript';
		pub.FPR_Due_Date__c = System.today().addDays(30);
		pub.Product_Indication__c = 'Product Indication 1;Product Indication 2';
		pub.Data_Source__c = 'Development';  
		pub.SubGroup_pick__c = 'Development - GRAAS';
		pub.SubGroup__c = SubGroupModelData.DevelopmentSmpSubGroup.Id;
	    pub.Execution_Notes__c = 'this is execution notes test case scenario';
		pub.Execution_Notes_Last_Mod__c = DateTime.valueOf('2014-09-09 20:57:00');
		pub.SponsorDept_Pick__c='Clinical Development';//Appear Enhancement R2
		pub.SponsorOrg_Pick__c='Amgen';//Appear Enhancement R2
		pub.Country_pick__c='United States';//Appear Enhancement R2
		pub.RAE__c=con[0].id;//Appear Enhancement R2
		pub.GPP_Type__c='SP';//Appear Enhancement R3
		
		AppLogModel.LogInfo('UnitTestData::PublicationNew', 'insert new pub records');
		insert pub;

		System.assertNotEquals(null, pub);
		System.assertNotEquals(null, pub.id);
		System.assertNotEquals(null, pub.Data_Source__c);
		System.assertNotEquals(null, pub.SubGroup__c);
		
		Publication__c pubupdated = [Select Id,PubStatus__c from Publication__c where id =:pub.id];
		System.assertNotEquals(null,pubupdated.PubStatus__c );
		
		return pub;
	}
	
	// transaction junction tables
	
	// attachments

}