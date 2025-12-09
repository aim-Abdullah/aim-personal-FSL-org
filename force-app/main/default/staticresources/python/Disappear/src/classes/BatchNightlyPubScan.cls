global class BatchNightlyPubScan extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {
   	public String SOQL = 'select id, name, Assigned_FPRC__c, FPR_Submitter__c from Publication__c where PubStatus__c IN ';
   	
   	private static Set<id> pStatusIdsToInclude = null;
   	private static Set<id> statusIdsToInclude{
   		get{
   			if (pStatusIdsToInclude == null) {
   				pStatusIdsToInclude = new Set<Id>();
				pStatusIdsToInclude.add(StatusModel.Routed.Id);
				pStatusIdsToInclude.add(StatusModel.DiscussionRequired.Id);
   			}
   			
   			return pStatusIdsToInclude; 
   		}
   	}
   	
	public BatchNightlyPubScan() { //find pubs routed or discussion required status with fpr date due today or 2 days ago
		super();
		
		SOQL = SOQL + ':statusIdsToInclude and (FPR_Due_Date__c = TODAY OR FPR_Due_Date__c =  LAST_N_DAYS:2) order by name desc';
		
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
	}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchNightlyPubScan';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<publication__c> pubs){
    	
    	/*
    	Friendly_Reminder_Email not part of 14 emails provided
    	
    	
    	EmailTemplate template = AppearSendEmailUtil.emailTemplateMap.get('Friendly_Reminder_Email');
    	if (template <> null) {
	    	Set<id> pubIds = new Set<id>();    	
	    	   	
	    	for(Publication__c pub : pubs) {  
	    		AppearSendEmailUtil.SendEmail(pub.Fpr_Submitter__c, pub.Id, template.Id, pub.id); //send email to fprc  
				AppearSendEmailUtil.SendEmail(pub.Assigned_FPRC__c, pub.Id , template.Id, pub.id); //send email to fpr submitter				
				
				pubIds.add(pub.Id);	
	    	}
	    	
	    	List<PubReviewTeam__c> ReviewersToEmail = [
	    		select id, Reviewer__c, publication__c 
	    		from PubReviewTeam__c 
	    		where HasVoted__c = False 
	    		AND Type__c = 'Primary' AND IsCurrentFPRCycleForPub__c = True AND publication__c in :pubIds
	    	]; 
	    	for(PubReviewTeam__c reviewer : ReviewersToEmail) { //send email to reviewer
	    		AppearSendEmailUtil.SendEmail(reviewer.Reviewer__c, reviewer.publication__c, template.Id, reviewer.publication__c);
	    	}
    	}
    	
    	*/
		AppLogModel.flushLogs();
    } 

    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchNightlyPubScan.runNow();
	public static void runNow(){
    	BatchNightlyPubScan batch = new BatchNightlyPubScan();
        Database.executeBatch(batch, 200);
	}

//////////////////////////////////////////  unit test /////////////////////////////////////
	@isTest
	private static void unitTest() {
		CreateData();
		
		BatchNightlyPubScan.runNow();
	} 
	
	public static void CreateData() {
		StatusModelData.CreateData();
	}
}