global class BatchUpdateAppearContactRecordType extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {

	public String SOQL = 'select Id,RecordTypeId,Email from Contact where  RecordTypeId =null ';

   	public BatchUpdateAppearContactRecordType() { //find pubs routed or discussion required status with fpr date due today or 2 days ago
		super();
		
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 10';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
        
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchUpdateAppearContactRecordType';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    
    global void execute(Database.BatchableContext BC, List<contact> con){
    	RecordType ac = [select Id from recordtype where Name = 'Appear Contact' limit 1];
		RecordType ic = [select Id from recordtype where Name = 'Internal Contact' limit 1];
		
		
    	AppearContactRecordType.UpdateConRecType(con, ac, ic);
    }
    
    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchUpdateAppearContactRecordType.runNow();
	public static void runNow(){
    	BatchUpdateAppearContactRecordType batch = new BatchUpdateAppearContactRecordType();
        Database.executeBatch(batch, 2000);
	}
	
	@IsTest
	public static void unitTest(){
        OrganizationModelData.createData();
        DepartmentModelData.createData();
        AccountModelData.createData();
        AppearContactModelData.createData();
        
        List<Contact> contacts = [
        	select recordtypeId from contact
        ];
        for(Contact c : contacts){
        	c.RecordTypeId = null;
        }
        update contacts;
        
		BatchUpdateAppearContactRecordType.runNow();
	}
   	  
}