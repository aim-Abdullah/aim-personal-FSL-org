global class BatchUpdateUsBasedAuthor extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {
   	public String SOQL = 'select id, Project_Ids__c ,SponsoringDept__c,SponsorDept_Pick__c,SponsoringDept__r.Name,SponsoringOrg__c,SponsorOrg_Pick__c,SponsoringOrg__r.Name from Publication__c ';
   	

   	
	public BatchUpdateUsBasedAuthor() {
		super();
		
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 5';
    	} 
    	AddMessage(SOQL);
        system.debug(SOQL);
	}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchContactUpdateCountry';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<Publication__c> pubs){
    	
    	Set<Id> pubIdSet = new Set<Id>();
    	List<Publication__c> Publications = new List<Publication__c>();
    	for(Publication__c pub : pubs) {
    		pubIdSet.add(pub.id);
    		Publications.add(pub);
    	} 
    	
    	List<PubAuthor__c> pubAuthorList = [
    		select id, Publication__c
    		from PubAuthor__c
    		where publication__c in :pubIdSet
            AND isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
    	];
    	 
    	PubAuthorTriggerLogic.PubAuthorTriggerInsertOrDeleteLogic(pubAuthorList);
    	
    	List<PubStudy__c> PubStudies = [ select id, Name, Publication__c, Study__c, Study__r.Name,IsLogicallyDeleted__c,Study__r.RecordType.Name From PubStudy__c
            where Publication__c in :pubIdSet and isLogicallyDeleted__c = false  
        ];
        PubAuthorTriggerLogic.PubProjectStudyUpdate(PubStudies,publications);
    	
		AppLogModel.flushLogs();
    } 

    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchUpdateUsBasedAuthor.runNow();
	public static void runNow(){
    	BatchUpdateUsBasedAuthor batch = new BatchUpdateUsBasedAuthor();
        Database.executeBatch(batch, 10);
	}

//////////////////////////////////////////  unit test /////////////////////////////////////
	@isTest
	private static void unitTest() {
		CreateData();
		
		BatchUpdateUsBasedAuthor.runNow();
	} 
	
	public static void CreateData() {

	}
}