global class BatchDef542Action6 extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {
   	public String SOQL = 'select fpr_cycle__c, status__r.name ' +
		'from PubStatus__c '+
		'where Submission_Cycle_num_Formula__c = 1 ' +
		'and FPR_Cycle__c <> null ' +
		'and Status__r.displayOrder__c < '; // ':StatusModel.InFpr.displayOrder__c';
   	
	public BatchDef542Action6() {
		super();
		SOQL = SOQL + StatusModel.InFpr.displayOrder__c;
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
	}
	
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchDef542Action6';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<PubStatus__c> pubs){
		ActionSixforPubs(pubs);
    }

    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchDef542Action6.runNow();
	public static void runNow(){
    	BatchDef542Action6 batch = new BatchDef542Action6();
        Database.executeBatch(batch, 80);
	}
	
	public static void ActionSixforPubs(List<PubStatus__c> pubStatusList) {
		if ( pubStatusList == null) return;
		
		for(PubStatus__c ps : pubStatusList) {
			ps.Fpr_Cycle__c = null;
			System.Debug('ActionSixforPubs - pubStatus '+ps.status__r.name);
		}
		update pubStatusList;		
		//System.Debug('ActionSixforPubs - pubStatusList Size = '+ pubStatusList.size());	
	}
	
	/*
	BatchDef542Action6.ActionSixForOnePub('Pub-Id-043826');
	*/
	public static void ActionSixForOnePub(string pubName){
		List<PubStatus__c> pubStatusList = [
			select id,fpr_cycle__c,  status__r.name from PubStatus__c
			where publication_id__r.name = :pubName
			and Submission_Cycle_num_Formula__c = 1 
		    and FPR_Cycle__c <> null 
		    and Status__r.displayOrder__c < :StatusModel.InFpr.displayOrder__c
		];
		
		ActionSixforPubs(pubStatusList);
		
	}
	
	

//////////////////////////////////////////  unit test /////////////////////////////////////
	@isTest
	private static void unitTest() {
		CreateData();
		
		BatchDef542Action6.runNow();
	} 
	
	public static void CreateData() {
		
		Publication__c pub = UnitTestData.PublicationNew('BatchDef542Action6');
		
		AppearPubModel activePub = new AppearPubModel( pub.id);
		
		for(PubStatus__c pubStatus : activePub.pubstatus.pubStatusList) {
			pubStatus.FPR_Cycle__c = activePub.FprCycle.getFprCycleByNum(1).id;
		}
		
		update activePub.pubstatus.pubStatusList;
		
		return;
		
	}
}