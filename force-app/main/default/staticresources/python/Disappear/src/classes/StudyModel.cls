public class StudyModel {
    
    private static RecordType pStudyRecType = null;
    public static RecordType StudyRecType {
        get {
            if (pStudyRecType == null){
                pStudyRecType = RecordTypeModel.LookupRecordType('Study__c', 'Study');
                System.AssertNotEquals(null, pStudyRecType);
            }
            return pStudyRecType;
        }
    }

    private static RecordType pProjectRecType = null;
    public static RecordType ProjectRecType {
        get {
            if (pProjectRecType == null){
                pProjectRecType = RecordTypeModel.LookupRecordType('Study__c', 'Project');
                System.AssertNotEquals(null, pProjectRecType);
            }
            return pProjectRecType;
        }
    }


    private static Map<string, Study__c> pProjectMapByTitle = null;
    public static Map<string, Study__c> ProjectMapByTitle {
        get {
            if ( pProjectMapByTitle == null){
                pProjectMapByTitle = new Map<string, Study__c>();
                for(Study__c study : ProjectStudyList){
                    pProjectMapByTitle.put(study.title__c, study);
                }
            }
            return pProjectMapByTitle;
        }
    }
    
    private static List<Study__c> pProjectStudyList = null;
    public static List<Study__c> ProjectStudyList {
        get {
            if ( pProjectStudyList == null) {
                pProjectStudyList = getStudyByRecordType('Project');
            }
            return pProjectStudyList;
        }
    }


    private static Map<string, Study__c> pStudyMapByName = null;
    public static Map<string, Study__c> StudyMapByName {
        get {
            if ( pStudyMapByName == null){
                pStudyMapByName = new Map<string, Study__c>();
                for(Study__c study : StudyStudyList){
                    pStudyMapByName.put(study.name, study);
                }
            }
            return pStudyMapByName;
        }
    }    
    
    private static Map<string, Study__c> pStudyMapByTitle = null;
    public static Map<string, Study__c> StudyMapByTitle {
        get {
            if ( pStudyMapByTitle == null){
                pStudyMapByTitle = new Map<string, Study__c>();
                for(Study__c study : StudyStudyList){
                    pStudyMapByTitle.put(study.title__c, study);
                }
            }
            return pStudyMapByTitle;
        }
    }
    
    private static List<Study__c> pStudyStudyList = null;
    public static List<Study__c> StudyStudyList {
        get {
            if ( pStudyStudyList == null) {
                pStudyStudyList = getStudyByRecordType('Study');
            }
            return pStudyStudyList;
        }
    }

    
    public static List<Study__c> getStudyByRecordType(string recordTypeName) {
        RecordType recType = RecordTypeModel.LookupRecordType('Study__c', recordTypeName);
        if(recType == null){
            return new List<Study__c>();
        }
        
        List<Study__c> study = [
              Select Id, Name, RecordTypeId, RecordType.Name, Acronym__c,
               Amgen_Ind__c, Description__c, Investigator__c, 
              Latest_Study_status__c, N__c, NCT__c,
              Posted_on_ClinTrials__c, Project_Sponsor__c,
              Published_Date__c, SiebelRowId__c, StudySponsor__c,
              Study_Phase__c, Study_TA__c, Study_Type__c, Title__c, isLogicallyDeleted__c
              From Study__c 
              where RecordTypeId = :recType.id
              and isLogicallyDeleted__c = false
              order by Name
        ];
        return study;
    }
    
    //
    
    public static Study__c findStudyById(string studyId){
        list<study__c> studies = [
            select id, Pass__c 
            from Study__c
            where id = :studyId
        ];
        if ( studies.size() == 1){
            return studies[0];
        } else {
            return null;
        }
    }
    

    
    
    ///////////////  JS Remote support //////////////////
    public static List<Study__c> findStudyByName(string startWith){
        
        string startWithParam = startWith + '%';
        
        List<Study__c> nameResults = [
            select id, name, Title__c
            From Study__c 
            where Name like :startWithParam 
            and RecordTypeId = :StudyRecType.id
            order by Name
            limit 25
        ];
        List<Study__c> titleResults = [
            select id, name, Title__c
            From Study__c 
            where Title__c like :startWithParam
            and RecordTypeId = :StudyRecType.id
            order by Title__c
            limit 25
        ];
        titleResults.addAll(nameResults);     
        return titleResults;   
    }
    
    public static List<Study__c> findProjectByName(string startWith){
        
        string startWithParam = startWith + '%';
        
        List<Study__c> nameResults = [
            select id, name, Title__c
            From Study__c 
            where Name like :startWithParam 
            and RecordTypeId = :ProjectRecType.id
            order by Name
            limit 25
        ];
        List<Study__c> titleResults = [
            select id, name, Title__c
            From Study__c 
            where Title__c like :startWithParam
            and RecordTypeId = :ProjectRecType.id
            order by Title__c
            limit 25
        ];
        titleResults.addAll(nameResults);     
        return titleResults;        
    }
}