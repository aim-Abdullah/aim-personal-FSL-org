global class BatchInflightPubStatusAdj2 extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {
    public String SOQL = 'select Publication__c, Publication__r.name from InflightPubsAtGoLive__c where Publication__r.name <> \'Pub-Id-033625\'  '; 
    
    public BatchInflightPubStatusAdj2() {
        super();
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 1';
        }
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchInflightPubStatusAdj2';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext BC, List<InflightPubsAtGoLive__c> pubs){
        InflightPubAdj2(pubs);
    }

    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
    }
    
    //BatchInflightPubStatusAdj1.runNow();
    public static void runNow(){
        BatchInflightPubStatusAdj2 batch = new BatchInflightPubStatusAdj2();
        Database.executeBatch(batch, 2);
    }
    
    public static void InflightPubAdj2(List<InflightPubsAtGoLive__c> inflightPubList) {
        for(InflightPubsAtGoLive__c inflightPub : inflightPubList) {
            InflightPubAdj2OnePub(inflightPub.Publication__c);
        }
    }
    

    public static void InflightPubAdj2OnePub(Id pubId){
        AppearPubModel activePub = new AppearPubModel(pubId);
        
        List<PubReviewTeam__c> reviewers = activePub.PubReviewTeam.PubReviewTeamMembers;
        
        List<PubReviewTeam__c> reviewersToUpdate = new List<PubReviewTeam__c> ();
        
        for(PubReviewTeam__c reviewer : reviewers) {
            if ( reviewer.Type__c == 'Primary') {
                if ( reviewer.Reviewer_Status__c == 'Approved') {
                    reviewer.Reviewer_Status__c = 'Reviewed';
                    reviewersToUpdate.add(reviewer);
                } else if ( reviewer.Reviewer_Status__c == 'Approved with Comments') {
                    reviewer.Reviewer_Status__c = 'Reviewed With Comments';
                    reviewersToUpdate.add(reviewer);
                }                   
            }
        }
        if (reviewersToUpdate.size() > 0 ) {
            update reviewersToUpdate;
        }

        
        AppLogModel.flushLogs();
    }
    
     

//////////////////////////////////////////  unit test /////////////////////////////////////
    @isTest(seeAllData=true)
    private static void unitTest() {
        list<InflightPubsAtGoLive__c> ifpb = new list<InflightPubsAtGoLive__c>();
        id pub;
        BatchInflightPubStatusAdj2.InflightPubAdj2(ifpb);
        BatchInflightPubStatusAdj2.InflightPubAdj2onePub(pub);
        BatchInflightPubStatusAdj2.runNow();
        
        
        
        
    } 
    

}