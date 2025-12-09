@IsTest
public class PubStatusTriggerLogicTest {
    
    @IsTest
    public static void findLatestPubStatusTest() {
        CreateData();
        
        List<Publication__c> pubs = new List<Publication__c>();
        Publication__c pub1 = new Publication__c();
        pub1.Publication_Title__c = 'Pub1';
        pub1.gpp_type__c = 'SP';
//      pub1.Publication_Type__c = 'Manuscript';
        pubs.add(pub1);
        Publication__c pub2 = new Publication__c();
        pub2.Publication_Title__c = 'Pub2';
        pub2.gpp_type__c = 'SP';
//      Pub2.Publication_Title__c = 'Manuscript';
        pubs.add(pub2);
        
        insert pubs;
        List<PubStatus__c> pubst = new List<Pubstatus__c>();
        System.assertNotEquals(null, pub1.id);
        System.assertNotEquals(null, pub2.id);
        
        PubStatus__c ps1 = new PubStatus__c();
        
        ps1.Publication_id__c = pub1.id;
        ps1.Status__c = StatusModel.DepartmentStatusList[0].id;
        
        
        
        insert ps1;
       /***  
        PubStatus__c ps2 = new PubStatus__c();
        ps2.Publication_id__c = pub2.id;
        ps2.Status__c =  'a0iZ000000102tm'; 
            
        insert ps2;
        
        pubst.add(ps1);
        
        map<id,PubSTatus__c> newmap = new map<id,PubSTatus__c>();
        newmap.put(pub1.id,ps1);
        map<id,PubSTatus__c> oldmap = new map<id,PubSTatus__c>();
        newmap.put(pub2.id,ps2);
        
       
        boolean b1;
        PubstatusTriggerLogic.byPassForLegacyPubStatusType(pubst);
        PubstatusTriggerLogic.PubStatusTriggerBeforeInsert(pubst);
        PubstatusTriggerLogic.terminalStatus(pubst);
        PubstatusTriggerLogic.getPubCurrentFprCycleId(pub1.id);
        
        PubstatusTriggerLogic.PubStatusTriggerAFterUpsert(newmap,oldmap);
        ****/
    }
    
    public static void CreateData() {
        
        StatusModelData.createData();
        
        TherapeuticAreaModelData.createData();
        AmgenProductModelData.createData();
        IndicationModelData.createData();
        ProductIndicationModelData.createData();
        MEScopeOfWorkModelData.createData();
        //R1:2017 - max author count data
        KeyValueSettings__c kvs = new KeyValueSettings__c(Name='CSP Pub Author Count',Key__c='Max_Author_Count',Value__c='10');
        insert kvs;

    }
}