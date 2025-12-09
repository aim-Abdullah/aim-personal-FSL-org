global class BatchDataTest extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {
    public String SOQL = 'select id, name, PubStatus__c, Current_SubmissionCycle_Id_Formula__c, Current_FPRCycle_Id_Formula__c '+
                'from Publication__c ' +
                'where RecordTypeId in :recordIdsToInclude '+ 
                'AND Current_Status_Id_FormulaField__c NOT in :statusIdsToExclude '+ 
                'order by name';
    
    
    public BatchDataTest() { //find pubs routed or discussion required status with fpr date due today or 2 days ago
        super();
        
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
            AppLogModel.appLogSizeLimit = 5;
        }
        AddMessage(SOQL);
        system.debug(SOQL);
        
    }
    
    private static Set<id> recordIdsToInclude{
        get{
            return RecordTypeModel.LegacyInProgressPubRecordIdSet;
        }
    }
    
    private static Set<id> pStatusIdsToExclude = null;
    private static Set<id> statusIdsToExclude{
        get{
            if (pStatusIdsToExclude == null) {
                pStatusIdsToExclude = new Set<id>();
                
                pStatusIdsToExclude.add(StatusModel.PublishedPresented.id);
                pStatusIdsToExclude.add(StatusModel.StatusMap.get('Accepted').id);
            }
            return pStatusIdsToExclude;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchDataTest';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    
    global void execute(Database.BatchableContext BC, List<publication__c> pubs){
        AppearDataTest.checkPub(pubs);
        AppearDataTest.checkSubmissionCycle(pubs, true);
        AppearDataTest.checkFprCycle(pubs, true);
        
        for(integer x= 0; x<20;x++){
            AppLogModel.LogInfo('BatchDataTest::execute', 'This is message #'+x);
        }
        
        
        AppLogModel.flushLogs();
    }

    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
    }
    
    //BatchDataTest.runNow();
    public static void runNow(){
        BatchDataTest batch = new BatchDataTest();
        Database.executeBatch(batch, 500);
    }
    
    @IsTest
    public static void UnitTest() {
        StatusModelData.createData();
        BatchDataTest.runNow();
        Set<Id> Rec = new Set<Id>();
        BatchDataTest.recordIdsToInclude = rec;
        BatchDataTest.statusIdsToExclude = rec;
    }
       
}