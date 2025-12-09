global class BatchRelease20Migration extends BatchBase 
	implements Database.Batchable<SObject>,Database.Stateful {

	public boolean isMigrationToPortal = false;
	public boolean isMigrationToPlatform = false;
	public boolean isStep2 = false;
	
    public static String SOQL = 'select id, Action__c, FromProfile__c,  FromUser__c, FromUser__r.ProfileId, isSelected__c, fromContact__c, toContact__c, toContactFedId__c, ToFederationId__c, ' +
                	'ToFprPortalUser__c, ToProfile__c, ToUser__c, ToUser__r.profileId  ' +
                	'from r20mig__c where isSelected__c = true ' ;
    
    public BatchRelease20Migration(boolean isMigrationToPortal, boolean isStep2, 
    	boolean isMigrationToPlatform) {
		super();
		
		this.isMigrationToPortal = isMigrationToPortal;
		this.isStep2 = isStep2;
		this.isMigrationToPlatform = isMigrationToPlatform;
		
    	if ( Test.isRunningTest()){
    		SOQL = SOQL + ' limit 1';
    	}
    	AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchRelease20Migration';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    

    global void execute(Database.BatchableContext BC, List<r20mig__c> migList){
		if (isMigrationToPortal) {
			executeToPortal(migList, isStep2);
		} else if (isMigrationToPlatform) {
			executeToPlatform(migList, isStep2);
		}
    }
    
    global static void executeToPortal(List<r20mig__c> migList, boolean isMigrationToPortalStep2) {
    	AppLogModel.LogDebug('BatchRelease20Migration::executeToPortal', 'miglist has '+migList.size()+' record(s)');
    	Profile fprSubmitterPortalProfile = ProfileModel.AppearPortalFprOnlySubmitterProfile;
    	
    	for(r20mig__c m : migList) {
    		if (m.ToFprPortalUser__c == true) {
    			
    			if (m.fromContact__c <> null ) {
					if ( isMigrationToPortalStep2 == false) {
						//create FPR Portal User
						User portalUser = PortalUserModel.CreatePortalUser(m.fromContact__c, fprSubmitterPortalProfile);  
						MigratePubOwnershipUtil.migratePubAndJunctionOwnership(m.FromUser__c, portalUser.Id);
						AppLogModel.flushLogs();
					}
					if ( isMigrationToPortalStep2) {
						Rel20MigrationModel.DeactivateUser(m.FromUser__c);
					}
					
    			} else {
    				AppLogModel.LogError('BatchRelease20Migration::executeToPortal', 'from_contact__c == null');
    			}
			}
    	}	
    	
    }
    
    //BatchRelease20Migration.RunSingleStep1();
    global static void RunSingleStep1() {
    	List<r20mig__c> migList = Database.query(SOQL);
    	executeToPortal(migList, false);
    }

	//BatchRelease20Migration.RunSingleStep2();
    global static void RunSingleStep2() {
    	List<r20mig__c> migList = Database.query(SOQL);
    	executeToPortal(migList, true);
    }
        
    global static void executeToPlatform(List<r20mig__c> migList, boolean isStep2) {
    	for(r20mig__c m : migList) {
    		if ( m.ToFprPortalUser__c == false && m.isSelected__c && m.toContactFedId__c <> '0' && m.ToFederationId__c <> '' ) {
    			if ( !isStep2) {
	    			MigratePubOwnershipUtil.migratePubAndJunctionOwnership(m.FromUser__c, m.ToUser__c);
					ContactReplacementUtility.ReplaceContact(m.fromContact__c, m.toContact__c);
					Rel20MigrationModel.FlagContactForDelete(m.fromContact__c);
    			}
				if ( isStep2) {
					Rel20MigrationModel.DeactivateUser(m.FromUser__c);
				}
    		}
		} 
    }
    

    global void finish(Database.BatchableContext BC){
		SendBatchCompletionEmail();
	}
	
	//BatchRelease20Migration.runMigrationToPortalStep1(); 
	public static void runMigrationToPortalStep1(){
		boolean isMigrationToPortal = true;
		boolean isStep2 = false;
		boolean isMigrationToPlatform = false;
		 
    	BatchRelease20Migration batch = new BatchRelease20Migration(isMigrationToPortal, isStep2, isMigrationToPlatform);
        Database.executeBatch(batch, 1);
	}
 
 	//BatchRelease20Migration.runMigrationToPortalStep2(); 
	public static void runMigrationToPortalStep2(){
		boolean isMigrationToPortal = true;
		boolean isStep2 = true;
		boolean isMigrationToPlatform = false;
		 
    	BatchRelease20Migration batch = new BatchRelease20Migration(isMigrationToPortal, isStep2, isMigrationToPlatform);
        Database.executeBatch(batch, 1);
	}
 
	//BatchRelease20Migration.runMigrationToPlatformStep1();
	public static void runMigrationToPlatformStep1(){
		boolean isMigrationToPortal = false;
		boolean isMigrationToPlatform = true;
		boolean isStep2 = false;
		
    	BatchRelease20Migration batch = new BatchRelease20Migration(isMigrationToPortal, isStep2, isMigrationToPlatform);
        Database.executeBatch(batch, 1);
	}

	//BatchRelease20Migration.runMigrationToPlatformStep2();
	public static void runMigrationToPlatformStep2(){
		boolean isMigrationToPortal = false;
		boolean isMigrationToPlatform = true;
		boolean isStep2 = true;
		
    	BatchRelease20Migration batch = new BatchRelease20Migration(isMigrationToPortal, isStep2, isMigrationToPlatform);
        Database.executeBatch(batch, 1);
	}

//////////////////////////////////////////  unit test /////////////////////////////////////
	
	private static testMethod void unitTest() {
		CreateData();
		
		BatchRelease20Migration.runMigrationToPortalStep1();
	}   
	
	public static void CreateData() {
		
	}
}