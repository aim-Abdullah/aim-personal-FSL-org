global class BatchSwitchPubMeCalcAndActual extends BatchBase 
    implements Database.Batchable<SObject>,Database.Stateful {

    public String SOQL = 'select ReasonForMEChange__c,Siebel_Actual__c, ActualME__c, CalculatedME__c, OverrideME__c from PubME__c where CreatedBy.Name = \'Amgen DataMigration\' and ActualME__c <> null';
    
    public BatchSwitchPubMeCalcAndActual() {
        super();
        if ( Test.isRunningTest()){
            SOQL = SOQL + ' limit 10';
        }
        AddMessage(SOQL);
        system.debug(SOQL);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        batchableContext = BC;
        batchName = 'BatchSwitchPubMeCalcAndActual';
        System.Debug(SOQL);
        return Database.getQueryLocator(SOQL);
    }
    

    global void execute(Database.BatchableContext BC, List<PubME__c> PubMeList){
        doIt(PubMeList);
    }
    
    global static void doIt(List<PubME__c> PubMeList) {
        List<PubME__c> updateList = new List<PubME__c>();
        for(PubME__c pubME : PubMeList) {
            if ( pubME.ActualME__c <> null) {
                pubME.CalculatedME__c = pubME.ActualME__c;
                pubME.OverrideME__c = pubME.ActualME__c;
                pubME.Siebel_Actual__c = pubME.ActualME__c;
                pubME.ReasonForMEChange__c = 'Adjusted ME of '+pubME.ActualME__c+ ' migrated from Siebel System';
                updateList.add(pubME);
            }
        }
        
        update updateList;

        AppLogModel.flushLogs();    
    }
    

    global void finish(Database.BatchableContext BC){
        SendBatchCompletionEmail();
    }
    
    //BatchSwitchPubMeCalcAndActual.runNow();
    public static void runNow(){
        BatchSwitchPubMeCalcAndActual batch = new BatchSwitchPubMeCalcAndActual();
        Database.executeBatch(batch, 1000);
    }
    
    //BatchSwitchPubMeCalcAndActual.runOne('Pub-Id-000019');
    public static void runOne(string PubId){
        if ( pubID == '')return;
        
        List<PubME__c> pubs = [
            Select ActualME__c, CalculatedME__c, OverrideME__c from PubME__c 
            where publication__r.name = :PubId
        ]; 
        doIt(pubs);
        
    }

//////////////////////////////////////////  unit test /////////////////////////////////////
    
    private static testMethod void unitTest() {
        Publication__c pub = CreateData();
        
        BatchSwitchPubMeCalcAndActual.runNow();
        
        // code changes as per CHG0049014: make APPEAR ROLE lookup field rquired in publication ME  
        List<Appear_Role__c> ARList=AppearRoleModel.AppearRoleList.clone();
        List<Appear_Role__c> RoleList=new List<Appear_Role__c>();
        
        for(Appear_Role__c AR:ARList){
            if(AR.isWritingRole__c==true){
               RoleList.add(AR);
            }
        }
       //CHG0049014: end
        
        PubME__c pme = new PubME__c();
        pme.ActualME__c = 1.0;
        pme.Publication__c = pub.Id;
        //pme.AppearRole__c = AppearRoleModel.AppearRoleList[0].id;
        pme.AppearRole__c=RoleList[0].id;
        insert pme;
        
        List<PubME__c> pubMeList = new List<PubME__c>();
        pubMeList.add(pme);
        System.assertEquals(1.0, pme.ActualME__c);
        System.assertEquals(null, pme.CalculatedME__c);
                
        BatchSwitchPubMeCalcAndActual.doIt(pubMeList);
        System.assertEquals(1.0, pme.ActualME__c);
        System.assertEquals(1.0, pme.CalculatedME__c);
    } 
    
    public static Publication__c CreateData() {
        AppearRoleModelData.createData();
        Publication__c pub = UnitTestData.PublicationNew('switchME');
        return pub;
    }
}