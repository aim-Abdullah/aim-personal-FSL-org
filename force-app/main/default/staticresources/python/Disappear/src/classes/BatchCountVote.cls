global class BatchCountVote extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {

    public String SOQL = 'select id,name from Publication__c ' +
    	' order by createddate';
    	//'where name in :nameSet';
    
    public set<string> nameSet = new set<String>();
    
    
    public BatchCountVote() {
		super();
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
        
        nameSet.add('Pub-Id-002157');
        nameSet.add('Pub-Id-008003');
        nameSet.add('Pub-Id-008204');
        nameSet.add('Pub-Id-008243');
        nameSet.add('Pub-Id-009398');
        nameSet.add('Pub-Id-040253');
        nameSet.add('Pub-Id-041881');
        nameSet.add('Pub-id-042154');        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchCountVote';  
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    

    global void execute(Database.BatchableContext BC, List<publication__c> pubs){
		for(publication__c pub : pubs) {
			PubReviewTeamTriggerLogic.ReCountVoteByPubId(pub.Id);
			PublicationTriggerLogic.UpdateLatestPubStatusById(pub.Id);
		} 

		AppLogModel.flushLogs();
    }
    
    
    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchCountVote.runNow();
	public static void runNow(){
    	BatchCountVote batch = new BatchCountVote();
        Database.executeBatch(batch, 20);
	}

//////////////////////////////////////////  unit test /////////////////////////////////////
	
	private static testMethod void unitTest() {
		CreateData();
		
		BatchCountVote.runNow();
	} 
	
	public static void CreateData() {
		
	}
}