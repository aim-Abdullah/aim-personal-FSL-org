public class AppearDataTest {

    public static void checkPub(List<Publication__c> pubListBatch) {
        //find all pub without a pubStatus or  submission Cycle
        For(Publication__c p : pubListBatch) {
            if ( p.PubStatus__c == null) {
                AppLogModel.LogError('AppearDataTest::checkPub', 'Pub - '+p.name+' missing PubStatus__c');
            }
            if ( p.Current_SubmissionCycle_Id_Formula__c == null) {
                AppLogModel.LogError('AppearDataTest::checkPub', 'Pub - '+p.name+' missing Current_SubmissionCycle_Id_Formula__c');
            }
        }
        
        AppLogModel.flushLogs();
    }


    public static void checkPubStatus(List<Publication__c> pubListBatch, boolean reportCorrectlyLinked) {
        //find all pubStatus that does not belong to a publication
        
        //find all pub that links to PubStatus with wrong pub id
    
    }
        
    

    public static void checkSubmissionCycle(List<Publication__c> pubListBatch, boolean reportCorrectlyLinked) {
        //find all submission Cycle that does not belong to a publication
        
        //find all pub that links to SubmissionCycle with wrong pub id      
        
        //1 find a set of id for Current_SubmissionCycle_Id_Formula__c
        Set<id> subIds = new set<id>();
        for(Publication__c p : pubListBatch) {
            subIds.add(p.Current_SubmissionCycle_Id_Formula__c);
        }
        
        List<SubmissionCycle__c> subCycles = [
            select id, publication__c 
            from SubmissionCycle__c
            where id in :subIds
            order by name
        ];
        
        map<id,SubmissionCycle__c> SubPubIdMap = new map<id,SubmissionCycle__c>();
        for(SubmissionCycle__c sc : subCycles){
            SubPubIdMap.put(sc.id, sc);
        }
        
        for(publication__c p : pubListBatch){
            if ( SubPubIdMap.containsKey(p.Current_SubmissionCycle_Id_Formula__c)) {
                SubmissionCycle__c sc = SubPubIdMap.get(p.Current_SubmissionCycle_Id_Formula__c);
                Id subPubId = sc.publication__c;
                if ( subPubId == p.id) {
                    if ( reportCorrectlyLinked) {
                        AppLogModel.LogInfo('AppearDataTest::checkSubmissionCycle', 'Pub - '+p.name+' ['+p.id+'] links to Current_SubmissionCycle_Id_Formula__c ['+p.Current_SubmissionCycle_Id_Formula__c+'] correctly.',
                            p.id);
                    } 
                } else {
                    AppLogModel.LogError('AppearDataTest::checkSubmissionCycle', 'Pub - '+p.name+' ['+p.id+'] Current_SubmissionCycle_Id_Formula__c ['+p.Current_SubmissionCycle_Id_Formula__c+'] in SubmissionCycle__c link to another pub  ' +subPubId,
                        p.id);
                }
                
            } else {
                AppLogModel.LogError('AppearDataTest::checkSubmissionCycle', 'Pub - '+p.name+' ['+p.id+'] Current_SubmissionCycle_Id_Formula__c ['+p.Current_SubmissionCycle_Id_Formula__c+'] does not exists in SubmissionCycle__c');
            }
        }
        
        AppLogModel.flushLogs();
        
    }

    public static void checkFprCycle(List<Publication__c> pubListBatch, boolean reportCorrectlyLinked) {
        //find all FPR Cycle that does not belong to a publication  
        
        //find all pub that links to FPR Cycle with wrong pub id    
        
        //1 find a set of id for Current_FPRCycle_Id_Formula__c
        Set<id> FcIds = new set<id>();
        for(Publication__c p : pubListBatch) {
            FcIds.add(p.Current_FPRCycle_Id_Formula__c);
        }
        
        List<FPR_Cycle__c> fcCycles = [
            select id, publication__c 
            from FPR_Cycle__c
            where id in :FcIds
            order by Name
        ];  
        
        map<id,FPR_Cycle__c> FcPubIdMap = new map<id,FPR_Cycle__c>();
        for(FPR_Cycle__c fc : fcCycles){
            FcPubIdMap.put(fc.id, fc);
        }
        
        for(publication__c p : pubListBatch){
            if (  p.Current_FPRCycle_Id_Formula__c <> null  && FcPubIdMap.containsKey(p.Current_FPRCycle_Id_Formula__c)) {
                
                FPR_Cycle__c fc = FcPubIdMap.get(p.Current_FPRCycle_Id_Formula__c);
                Id fcPubId = fc.publication__c;

                if ( fcPubId == p.id) {
                    if ( reportCorrectlyLinked){
                        AppLogModel.LogInfo('AppearDataTest::checkFprCycle', 'Pub - '+p.name+' ['+p.id+'] links to Current_FPRCycle_Id_Formula__c ['+p.Current_FPRCycle_Id_Formula__c+'] correctly.');
                    }
                } else {
                    AppLogModel.LogError('AppearDataTest::checkFprCycle', 'Pub - '+p.name+' ['+p.id+'] Current_FPRCycle_Id_Formula__c ['+p.Current_FPRCycle_Id_Formula__c+'] in FPR_Cycle__c link to another pub  ' +fcPubId);
                }
                
            } else if (p.Current_FPRCycle_Id_Formula__c <> null) {
                AppLogModel.LogError('AppearDataTest::checkFprCycle', 'Pub - '+p.name+' ['+p.id+'] Current_FPRCycle_Id_Formula__c ['+p.Current_FPRCycle_Id_Formula__c+'] does not exists in FPR_Cycle__c');
            }
        }
        
        AppLogModel.flushLogs();    
    }
    
    private static set<Id> pPubIds = null;
    public static set<id> PubIds {
        get {
            if ( pPubIds == null) {
                pPubIds = new Set<id>();
                for(Publication__c p : PubList) {
                    pPubIds.add(p.id);
                }
            }
            return pPubIds;
        }
    }
    
    private static List<Publication__c>  pPubList = null;
    public static List<Publication__c> PubList {
        get {
            
            if (pPubList == null) {
        
                pPubList = [
                    select id, name, PubStatus__c, Current_SubmissionCycle_Id_Formula__c, Current_FPRCycle_Id_Formula__c
                    
                    from Publication__c
                    order by name
                    limit 500
                ];
            }
            return pPubList;
        }
    }
    
    public static void cleanDataTestLog() {
        List<AppLog__c> logs = [
            select id 
            from AppLog__c
            where MessageType__c like 'AppearDataTest::%'
        ];
        
        Delete logs;        
    }   
    
    
    public static void RunAll() {
        AppearDataTest.cleanDataTestLog();
        
        AppearDataTest.checkPub(PubList);
        AppearDataTest.checkSubmissionCycle(PubList, true);
        AppearDataTest.checkFprCycle(PubList, true);
    }
    
    
    @IsTest
    public static void UnitTest() {
        
        AppearDataTest.RunAll();
        Set<Id> PubId = new Set<Id>();
        Publication__c  newPub = UnitTestData.PublicationNew('Fpr Controller Pub');
        pubId.add(newPub.Id);
        //AppearDataTest.PubIds = pubId;
        
    }
    
}