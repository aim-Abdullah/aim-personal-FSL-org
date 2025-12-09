@IsTest
global class BatchBaseTest extends BatchBase
	implements Database.Batchable<SObject>,Database.Stateful {

	public String SOQL = 'select id ' +
			'from User  ';

   	public BatchBaseTest() { 
		super();
		
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 50';
    	}
    	AddMessage(SOQL);
    	
    	for(integer x=0; x<10; x++){
    		AddMessage('message '+ x);
    	}
        system.debug(SOQL);
        
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchBaseTest';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> recs){
    	// BatchBaseTest.futureTest();
    	// Future method cannot be called from a future or batch Method
    }
    
    @future
    global static void futureTest(){
    	System.Debug('Print this is a future method');
    }
    
    global void finish(Database.BatchableContext BC){
		List<string> msgs = GetMessages();
		SendBatchCompletionEmail();
		
	}

    @Istest
    public static void UnitTestBatchBase() {
      	BatchBaseTest batch = new BatchBaseTest();	
    	batch.MsgLineLimit = 3;
    	batch.MsgLineLimit = 3000;
    	batch.MsgLineLimit = 200;     //unit test to exercise the limit setter   	
    	
    	Database.executeBatch(batch, 50);
    	
    }
}