@IsTest
public class PubProdIndModelTest {

	public static void CreateData() {
		//Creating Product
		AmgenProductModelData.createData();
		System.assertNotEquals(null, AmgenProductModelData.amg103mt103);
		
		//Creating Indication		
		IndicationModelData.createData();
		System.assertNotEquals(null, IndicationModelData.oncologyIndication);
		
		TherapeuticAreaModelData.createData();
		System.assertNotEquals(null, TherapeuticAreaModelData.OncologyTA);
		
		//Creating Prod Indication	
		ProductIndicationModelData.createData();
		System.assertNotEquals(null, ProductIndicationModelData.abarelixOncologyProdInd);
		
		//Creating DataSource		
		DataSourceModelData.createData();
		
		//Creating Subgroup
		SubGroupModelData.createData();
		
		//Review team for Subgroup
		ReviewTeamModelData.createData();
		System.assertNotEquals(null, ReviewTeamModelData.abarelixOncologyDevelopmentSmpReviewTeam);
		
		//self init lazy load for UserModelData
		System.assertNotEquals(null, UserModelData.bschoenUser);
		System.assertNotEquals(null, UserModelData.cruesgaUser);
    	
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
        insert ConList;

		//Appear Role
		RecordType reviewTeamRoleRecType = RecordTypeModel.LookupRecordType('Appear_Role__c','ReviewTeamRole');
		List<Appear_Role__c> roleList = new List<Appear_Role__c>();
        roleList.add( new Appear_Role__c(name= 'FPR Reviewer', isWritingRole__c = false, RecordTypeId = reviewTeamRoleRecType.id));
		insert roleList;        
		
		Appear_Role__c FprReviewRole =AppearRoleModel.AppearRoleMapByName.get('FPR Reviewer');
		System.assertNotEquals(null, FprReviewRole);
		
		//Review Team Member
		Contact cid = AppearContactModel.findContactByName('Cid', 'Ruesga')[0];   
		Contact brandon = AppearContactModel.findContactByName('Brandon', 'Schoen')[0];
		System.assertNotEquals(null, cid);
		System.assertNotEquals(null, brandon);


		List <ReviewTeamMember__c> ReviewTeamMemberList = new List <ReviewTeamMember__c> ();
		ReviewTeamMemberList.add(new ReviewTeamMember__c(Review_Team__c= ReviewTeamModelData.abarelixOncologyDevelopmentSmpReviewTeam.Id ,
			ReviewTeamMember__c=Cid.id, Appear_Role__c=FprReviewRole.Id,ReviewerType__c = 'Primary'));         
		ReviewTeamMemberList.add(new ReviewTeamMember__c(Review_Team__c= ReviewTeamModelData.abarelixOncologyDevelopmentSmpReviewTeam.Id ,
			ReviewTeamMember__c=Brandon.id,ReviewerType__c = 'Notify'));         
		Insert ReviewTeamMemberList;
		
		//Creating Journal
        List<Journal__c> JournalList = new List<Journal__c>();
        JournalList.add( new Journal__c(Journal_Name__c= 'Annuals of Oncology')); 
		insert JournalList;
	}
	
	@IsTest
	public static Publication__c TestSaveProdInd() {
		CreateData();
 
		//Calling Unit test Data to create a Pub       
        Publication__c newPub = UnitTestData.PublicationNew('TestSaveProdInd');
		System.Test.startTest();
        
        
        System.assert(ProductIndicationModel.ProductIndicationList.size() > 0 );
        set<string> prodIndicationStringSet = new set<string>();
        
        for(ProductIndication__c pi : ProductIndicationModel.ProductIndicationList) {
        	prodIndicationStringSet.add(pi.name);
        	if ( prodIndicationStringSet.size() > 5) break;
        }
        
        
        PubProdIndModel.insertPubProdInd(newPub.id, prodIndicationStringSet);
        
        boolean isFprSubmitter = true; 
        PubProdIndModel indModel = new PubProdIndModel(newPub.id, 'menu','tile',isFprSubmitter);
        
        System.assert(indModel.ProdIndListForPub.size() > 0);
        System.assert(indModel.ProdIndIdListForPub.size() > 0);
        System.assert(indModel.PubProdIndicationList.size() > 0);
        System.assert(indModel.getProdIndicationMultiSelect().size() > 0);        
        System.assertNotEquals(indModel.KeyProdIndStr, null);
        System.assertNotEquals(indModel.KeyProdNameId, null);
        indModel.KeyProdIndStr = indModel.SelectedProductIndications[0];
        indModel.savePubProdInd();
        
        
        set<string> prodIndNames = new set<string>();
        for(ProductIndication__c indication : indModel.ProdIndListForPub) {
        	prodIndNames.add(indication.Name);
        } 
        PubProdIndModel.insertPubProdInd(newPub.Id, prodIndNames);
        PubProdIndModel.removePubProdInd(newPub.Id, prodIndNames);
        
        List<ProductIndication__c> prodIndList = ProductIndicationModel.ProductIndicationList;
        System.assert(prodIndList.size()>0); 
        System.Test.stopTest();
        
        pPubQueryId = null;
        
        AppearPubModel checkPub = new AppearPubModel(newPub.Id);
        
        System.assertEquals('Pending Suggestion', checkPub.pubRecord.Current_Status_FormulaField__c);
        System.assertNotEquals(null,  checkPub.pubRecord.Current_SubmissionCycle_Id_Formula__c);
        
        return newPub;
    }
    
    private static Publication__c pPubQuery = null;
    private static id pPubQueryId = null;
    public static Publication__c PubQuery(Id pubId){
    	
    	if ( pPubQueryId == pubId){
    		pPubQueryId = pubId;
			pPubQuery = [
	 			Select Id,
	 				Current_Status_FormulaField__c,
	 				Current_SubmissionCycle_Id_Formula__c,
	 				Current_FPRCycle_Id_Formula__c
				from Publication__c 
				where id =:pubid
			];
    	}
     	return pPubQuery;
    }


}