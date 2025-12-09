global class BatchMergeNotes extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {

    public String SOQL = 'select id,name from Publication__c ' +
        ' order by createddate';
    
    public BatchMergeNotes() {
        super();
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
        }
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchMergeNotes';  
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    

    global void execute(Database.BatchableContext BC, List<publication__c> pubs){
        for(publication__c pub : pubs) {

            list<PubNote__c> notesForPub = [
                select Notes__c
                from pubNote__c
                where publication__c = :pub.id
                order by SiebelRowId__c
            ];
    

            if ( notesForPub.size() > 0) {
                
                string mergedNotes = '';
                for(PubNote__c note : NotesForPub) {
                    mergedNotes += note.notes__c + '\r\n\r\n';
                }
                
                AppearPubModel activePub = New AppearPubModel(pub.id);
                
                activePub.pubRecord.Execution_Notes__c = mergedNotes ;
                activePub.pubRecord.Execution_Notes_Last_Mod__c = DateTime.Now();
                update activePub.pubRecord;

            }

        }

        AppLogModel.flushLogs();
    }
    
    
    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
    }
    
    //BatchMergeNotes.runNow();
    public static void runNow(){
        BatchMergeNotes batch = new BatchMergeNotes();
        Database.executeBatch(batch, 10);
    }

//////////////////////////////////////////  unit test /////////////////////////////////////
    
    private static testMethod void unitTest() {
        
        CreateData();
        BatchMergeNotes.runNow();
        
    } 
    
    public static void CreateData() {
        
    }
}