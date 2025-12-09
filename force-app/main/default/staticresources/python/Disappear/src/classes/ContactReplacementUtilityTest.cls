@IsTest
public with sharing class ContactReplacementUtilityTest {
	
	@IsTest
	public static void unitTest(){
		
		
		//Creating Product
		AmgenProductModelData.createData();
		
		//Creating Indication		
		IndicationModelData.createData();
		
		TherapeuticAreaModelData.createData();
		
		//Creating Prod Indication	
		ProductIndicationModelData.createData();
		
		//Creating DataSource		
		DataSourceModelData.createData();
		
		//Creating Subgroup
		SubGroupModelData.createData();
		
		//Review team for Subgroup
		ReviewTeamModelData.createData();
		
		//Account
		AccountModelData.createData();
		
		//Contact
		List<Contact> ConList = new List<Contact>();
		
		ConList.add(new Contact(AccountId=AccountModelData.AmgenAccount.Id ,
			lastname='Ruesga',firstname='Cid',
			userid__c=UserModelData.cruesgaUser.Id));
		ConList.add(new Contact(AccountId=AccountModelData.AmgenAccount.Id ,
			lastname='Schoen',firstname='Brandon',
			userid__c=UserModelData.bschoenUser.Id));
		ConList.add(new Contact(AccountId=AccountModelData.AmgenAccount.Id ,
			lastname='Delegate',firstname='test',
			userid__c=UserModelData.bschoenUser.Id));
        insert ConList;
        
        //Contact Delegate
        List<ContactDelegate__c> conDelegate= new List<ContactDelegate__c>();
        conDelegate.add(new ContactDelegate__c(Contact__c=ConList[0].Id,Delegate__c=ConList[2].Id,End_Date__c=system.today(),IsActive__c=true,Start_Date__c=system.today()));
		insert conDelegate;
		
		//Appear Role
		RecordType reviewTeamRoleRecType = RecordTypeModel.LookupRecordType('Appear_Role__c','ReviewTeamRole');
		RecordType pubTeamRoleRecType = RecordTypeModel.LookupRecordType('Appear_Role__c','PubTeamRole');
		List<Appear_Role__c> roleList = new List<Appear_Role__c>();
        roleList.add( new Appear_Role__c(name= 'FPR Reviewer', isWritingRole__c = false, RecordTypeId = reviewTeamRoleRecType.id));
        roleList.add( new Appear_Role__c(name= 'Writer', isWritingRole__c = true,RecordTypeId = pubTeamRoleRecType.id));
		insert roleList;        
		
		Appear_Role__c FprReviewRole =AppearRoleModel.AppearRoleMapByName.get('FPR Reviewer');
		System.assertNotEquals(null, FprReviewRole);
		
		//Review Team Member
		List <ReviewTeamMember__c> ReviewTeamMemberList = new List <ReviewTeamMember__c> ();
		ReviewTeamMemberList.add(new ReviewTeamMember__c(Review_Team__c= ReviewTeamModelData.abarelixOncologyDevelopmentSmpReviewTeam.Id ,
			ReviewTeamMember__c=ConList[0].id, Appear_Role__c=FprReviewRole.Id,ReviewerType__c = 'Primary'));         
		       
		Insert ReviewTeamMemberList;
		
		Publication__c newPub = UnitTestData.PublicationNew('TestSaveProdInd');
		
		newPub.Assigned_FPRC__c=ConList[0].Id;
		newPub.First_Author__c=ConList[0].Id;
		newPub.FPR_Submitter__c=ConList[0].Id;
		newPub.RAE__c=ConList[0].Id;
		update newPub;
		
		set<string> prodIndicationStringSet = new set<string>();
        
        for(ProductIndication__c pi : ProductIndicationModel.ProductIndicationList) {
        	prodIndicationStringSet.add(pi.name);
        	if ( prodIndicationStringSet.size() > 5) break;
        }
		PubProdIndModel.insertPubProdInd(newPub.id, prodIndicationStringSet);
		
		List<ProdIndTeamMember__c> pubProdIndMember= new List<ProdIndTeamMember__c>();
		pubProdIndMember.add( new ProdIndTeamMember__c(Contact__c=ConList[0].Id,isLogicallyDeleted__c=false));
		insert pubProdIndMember;
		
		List<study__c> study= new List<Study__c>();
		study.add( new Study__c(Amgen_Ind__c=false,IsLogicallyDeleted__c=false,PASS__c=false,Posted_on_ClinTrials__c=false,StudySponsor__c=ConList[0].Id));
		insert study;
		
		List<PubME__c> pubMes= new List<PubME__c>();
		pubMes.add(new PubME__c(WritingRoleMember__c=ConList[0].Id,Publication__c=newPub.id,AppearRole__c=roleList[1].Id));
		insert pubMes;
		
		ContactReplacementUtility.ReplaceContact(ConList[0].Id, ConList[1].Id);
	
	}		
}