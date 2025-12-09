public with sharing class SubmissionCycleModel {
    ////////  members ////////////////////////
    private Id PubId;
    private PubStatus__c pubStatus;
    
    public void reloadCurrentSubmissionCycle() {
        pCurrentSubmissionCycle = null;
    }
    private SubmissionCycle__c pCurrentSubmissionCycle = null;
    public SubmissionCycle__c CurrentSubmissionCycle{
        get {
            if ( pCurrentSubmissionCycle == null){
                pCurrentSubmissionCycle = FindCurrentSubmissionCycle();
            }
            return pCurrentSubmissionCycle;
        }
        set {
            pCurrentSubmissionCycle = value;
        }
    }
    
    private transient Map<Id, SubmissionCycle__c> pSubmissionCycleMapeById = null;
    public Map<Id, SubmissionCycle__c> SubmissionCycleMapeById {
        get {
            if (pSubmissionCycleMapeById == null){
                pSubmissionCycleMapeById = new Map<Id, SubmissionCycle__c>();
                for(SubmissionCycle__c cycle : SubmissionCycleList) {
                    pSubmissionCycleMapeById.put(cycle.id, cycle);
                }
            }
            return pSubmissionCycleMapeById;
        }
    }
    
    private transient Map<Integer, SubmissionCycle__c> pSubmissionCycleMap = null;
    public Map<integer, SubmissionCycle__c> SubmissionCycleMap {
        get {
            if (pSubmissionCycleMap == null) {
                pSubmissionCycleMap = new Map<Integer,SubmissionCycle__c>();
                for(SubmissionCycle__c s : SubmissionCycleList){
                    pSubmissionCycleMap.put(Integer.ValueOf(s.Submission_Cycle_Num__c),s);
                }
            }
            return pSubmissionCycleMap;
        }
    }

    
    private List<SubmissionCycle__c> pSubmissionCycleList = null;
    public  List<SubmissionCycle__c> SubmissionCycleList {
        get {
            if ( pSubmissionCycleList == null ){
                pSubmissionCycleList = getSubmissionCycleList(PubId);
            }
            return pSubmissionCycleList;
        }
    }
    
   
     public List<SelectOption> SubmissionCycleOptions {
        get {
            List<SelectOption> result = new List<SelectOption>();
            for( SubmissionCycle__c cycle : SubmissionCycleList) {
                result.add(new selectOption(cycle.id, String.ValueOf(cycle.Submission_Cycle_Num__c)));
            }
            return result;
        }
    } 
    
    private string pTargetLabel = null;
    public string TargetLabel {
        get {
            if (pTargetLabel == null) {
                pTargetLabel = getCurrentTargetLabel();
            }
            return pTargetLabel;
        }
    }
    
    public string getCurrentTargetLabel () {
    	if (CurrentSubmissionCycle == null || CurrentSubmissionCycle.Target_Type__c == null) {
    		return '';
    	} else if ( CurrentSubmissionCycle.Target_Type__c == 'Meeting' )  {
            return CurrentSubmissionCycle.Meeting__r.Meeting_Name__c;
        } else if ( CurrentSubmissionCycle.Target_Type__c == 'Journal' )  {
            return CurrentSubmissionCycle.Journal__r.Journal_Name__c;
        } else {
            return 'unknown target for targetType : '+ CurrentSubmissionCycle.Target_Type__c;
        }
    }
    
    /*
        		String uniqueMeetingName = MeetingModel.uniqueMeetingName(
            		CurrentSubmissionCycle.Meeting__r.MeetingName255__c,
            		CurrentSubmissionCycle.Meeting__r.Starts__c, 
            		CurrentSubmissionCycle.Meeting__r.Ends__c,
            		CurrentSubmissionCycle.Meeting__r.Acronym__c,
            		CurrentSubmissionCycle.Meeting__r.Venue__c );
    */
    
    
    ////// constructor ////////////////////

    public SubmissionCycleModel(Id PubId, PubStatus__c pubStatus){
        this.PubId = PubId;
        this.PubStatus = pubStatus;
    }   
    
    ////// public methods ////////////////
    
    public SubmissionCycle__c FindCurrentSubmissionCycle() {
        if ( pubStatus == null || SubmissionCycleList.size() == 0){
            return getSubmissionCycleByNum(1);
        } else {
        	Id currentSubCycleId = pubStatus.Submission_Cycle__c;
        	return SubmissionCycleMapeById.get(currentSubCycleId);
        }
    }
    
    
    public static List<SubmissionCycle__c> getSubmissionCycleList(id PubId){
        List<SubmissionCycle__c> scs = [
            Select s.Submission_Cycle_Num__c, s.Publication__c, s.Name, s.Id,
            target_Type__c, journal__c, journal__r.Journal_Name__c,
            meeting__c, meeting__r.MeetingName255__c, 
            meeting__r.meeting_name__c,
            meeting__r.Starts__c, meeting__r.Ends__c, 
            meeting__r.Acronym__c, meeting__r.Venue__c
            From SubmissionCycle__c s
            where Publication__c = :PubId
            order by s.Name 
        ];
        return scs;
    }
      
    public static Map<id, SubmissionCycle__c> getSubmissionCycleMap(id PubId){
         Map<id, SubmissionCycle__c> submissionCycleMap = new Map<id, SubmissionCycle__c>();
         for(SubmissionCycle__c scs : getSubmissionCycleList(pubId)) {
         	submissionCycleMap.put(scs.id, scs);
         }
         return submissionCycleMap;
    }
    
    //return the SubmissionCycle__c record for the cycle requested
    //if the record does not exists - it will be created on the fly.
    public SubmissionCycle__c getSubmissionCycleByNum( integer SubmissionCycleNum){
        if ( !SubmissionCycleMap.containsKey(SubmissionCycleNum)) {
            SubmissionCycle__c subCycle = new SubmissionCycle__c();
            subCycle.Submission_Cycle_num__c = SubmissionCycleNum;
            subCycle.Publication__c = PubId;
            insert SubCycle;
            
            System.assertNotEquals(null, SubCycle.id);
            System.assertNotEquals(null, SubCycle.Submission_Cycle_Num__c);
            pSubmissionCycleMap.put(SubmissionCycleNum,subCycle);
            return subCycle;
        } else {
            return SubmissionCycleMap.get(SubmissionCycleNum);
        }
    }
 
}