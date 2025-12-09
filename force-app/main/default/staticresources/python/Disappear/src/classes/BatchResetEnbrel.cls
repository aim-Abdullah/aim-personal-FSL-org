global class BatchResetEnbrel extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {

    public String SOQL = 'select id,name from Publication__c ' +
        ' order by name desc';
    
    public BatchResetEnbrel() {
        super();
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
        }
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchResetEnbrel';  
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    

    global void execute(Database.BatchableContext BC, List<publication__c> pubs){
        for(publication__c pub : pubs) {
            resetEnbrel(pub.id);
        }

        AppLogModel.flushLogs();
    }
    
    
    public static void resetEnbrel(id PubId) {
        boolean isEnbrelSelected = false;
        for(Pub_Prod_Ind__c pubProdInd : PubProdIndModel.getPubProductIndication(PubId)) {
            
            if (pubProdInd.isLogicallyDeleted__c == false) {
                
                        
                if (pubProdInd.isEnbrel__c) {
                    AppLogModel.LogDebug('BatchResetEnbrel::resetEnbrel', 
                            'product Indication- '+pubProdInd.Product_Indication__r.name +' isEnbrel = '+ pubProdInd.Product_Indication__r.isEnbrel__c, pubProdInd.Product_Indication__r.id);   
                    
                    AppLogModel.LogDebug('BatchResetEnbrel::resetEnbrel', 
                            'pub Prod Indication- '+pubProdInd.name +':'+ pubProdInd.Product_Indication__r.name +' isEnbrel = '+ pubProdInd.isEnbrel__c, pubProdInd.id);    


                    isEnbrelSelected = true;
                } 
            }
        }       
        if (isEnbrelSelected) {
            AppearPubModel activePub = New AppearPubModel(pubId);
            activePub.pubRecord.isEnbrel__c = true;
            update activePub.pubRecord;
        }
    }

    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
    }
    
    //BatchResetEnbrel.runNow();
    public static void runNow(){
        BatchResetEnbrel batch = new BatchResetEnbrel();
        Database.executeBatch(batch, 20);
    }

//////////////////////////////////////////  unit test /////////////////////////////////////
    
    private static testMethod void unitTest() {
        CreateData();
        
        BatchResetEnbrel.runNow();
        Publication__c  newPub = UnitTestData.PublicationNew('Fpr Controller Pub');
        BatchResetEnbrel.ResetEnbrel(newPub.Id);
        
    } 
    
    public static void CreateData() {
        
    }
}