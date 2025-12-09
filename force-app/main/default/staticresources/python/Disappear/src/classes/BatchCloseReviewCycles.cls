//BatchCloseReviewCycles 
global class BatchCloseReviewCycles extends BatchBase implements Database.Batchable<SObject>,Database.Stateful {
    public String SOQL = 'SELECT Id, Name, Reviewer__r.Name, Publication__c, Publication__r.Name FROM PubReviewTeam__c where HasVoted__c = FALSE '+
        'and Delivered__c != null and Returned__c = null and Type__c = \'Primary\' and Publication__c IN (select id from Publication__c where '+
        'IsComments_Only__c = TRUE and Current_Status_FormulaField__c = \'Routed\' and FPR_Due_Date__c < LAST_N_DAYS:0)';
    
    public BatchCloseReviewCycles() {
        super();
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
        }
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchCloseReviewCycles ';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<PubReviewTeam__c> pubReviewTeam){
        ActionforpubReviewTeam(pubReviewTeam);
        System.Debug('Here is the list of records to be updated' + pubReviewTeam);
    }

    global void finish(Database.BatchableContext BC){
        AppearTriggerActivationModel.activateTriggersAfterDataMigration();
    
        SendBatchCompletionEmail();
    }
    
    //BatchCloseReviewCycles.runNow();
    public static void runNow(){
        BatchCloseReviewCycles  batch = new BatchCloseReviewCycles ();
        Database.executeBatch(batch, 200);
    }
    
    public static void ActionforpubReviewTeam(List<PubReviewTeam__c> pubReviewTeam) {
            AppearTriggerActivationModel.deactivateTriggersForDataMigration();
            Set <Id> pubIds = new Set<Id>();
            
        for (PubReviewTeam__c pubRteam :  pubReviewTeam) {
            pubRteam.HasVoted__c = true;
			pubRteam.Reviewer_Status__c  = 'No Comments';
			pubRteam.Returned__c = Date.Today();
            pubRteam.Comments__c = 'No Response Received - system updated to "No Comments" on ' + DateTime.now();
            pubIds.add(pubRteam.publication__c);
        }
        
        AppLogModel.LogInfo('BatchCloseReviewCycles', 'updating Review Team '+pubReviewTeam.size());
        database.update(pubReviewTeam, true);
        
        //Code to Recount the Vote and Update the Current Status of the Publication 
        Iterator<Id> iteratorPub = pubIds.iterator();
	    while(iteratorPub.hasNext()) {
	        Id setPubId = iteratorPub.next();
	        PubReviewTeamTriggerLogic.ReCountVoteByPubId(setPubId);
	    }
        
        AppLogModel.flushLogs();        
    }
}