public with sharing class FprCycleModel {
    ////////  members ////////////////////////
    private id PubId;
    private PubStatus__c pubStatus;
    
    private FPR_Cycle__c pCurrentFprCycle = null;
    public FPR_Cycle__c CurrentFprCycle {
        get {
            if ( pCurrentFprCycle == null){
                pCurrentFprCycle = FindCurrentFprCycle();
            }
            return pCurrentFprCycle;
        }
        set {
            pCurrentFprCycle = value;
        }
    }
    private transient Map<Integer, FPR_Cycle__c> pFprCycleMap = null;
    public Map<integer, FPR_Cycle__c> FPR_CycleMap {
        get {
            if (pFprCycleMap == null) {
                pFprCycleMap = getFprCycleMap(this.PubId);
            }
            return pFprCycleMap;
        }
    }
    
    private transient Map<Id, FPR_Cycle__c> pFprCycleMapById = null;
    public Map<Id, FPR_Cycle__c> FPR_CycleMapById {
        get {
            if (pFprCycleMapById == null) {
                pFprCycleMapById = new Map<Id, FPR_Cycle__c> ();
                for(FPR_Cycle__c fc : FprList ) {
                	pFprCycleMapById.put(fc.id, fc);
                }
            }
            return pFprCycleMapById;
        }
    }
    
    private List<FPR_Cycle__c> pFprList = null;
    public List<FPR_Cycle__c> FprList {
    	get {
    		if (pFprList == null ) {
    			pFprList = [ 
		            Select s.FPR_Cycle_Num__c, s.Publication__c, s.Name, s.Id
		            From FPR_Cycle__c s
		            where Publication__c = :PubId
		            order by s.Name 
		       	];
    		}
    		return pFprList;
    	}
    }
    
    
    
    ////// constructor ////////////////////
    
    public FprCycleModel(Id PubId, PubStatus__c pubStatus){
        this.PubId = PubId;
        this.PubStatus = PubStatus;
    }
    
    ////// public methods ////////////////
    public FPR_Cycle__c FindCurrentFprCycle() {
        if (pubStatus == null || FPR_CycleMap.size() == 0){
            return getFprCycleByNum(1);
        } else {
        	Id currentFprCycleId = pubStatus.FPR_Cycle__c;
        	return FPR_CycleMapById.get(currentFprCycleId);
        }
    }
    
    public static Map<Integer,FPR_Cycle__c> getFprCycleMap (id PubId) {
        if ( PubId == null) {
            return new Map<Integer, FPR_Cycle__c> ();
        }
        
        List<FPR_Cycle__c> fprCycles = [ 
            Select s.FPR_Cycle_Num__c, s.Publication__c, s.Name, s.Id
            From FPR_Cycle__c s
            where Publication__c = :PubId
            order by s.Name ];
            
        //convert to map
        Map<Integer,FPR_Cycle__c> result = new Map<Integer,FPR_Cycle__c>();
        for(FPR_Cycle__c s : fprCycles){
            result.put(Integer.ValueOf(s.FPR_Cycle_num__c),s);
        }
        return result;
    }
    
    //return the FPR_Cycle__c record for the cycle requested
    //if the record does not exists - it will be created on the fly.
    public FPR_Cycle__c getFprCycleByNum( integer FprCycleNum){
    	return getFprCycleByNum(pubId, FprCycleNum);
    }
    
    public static FPR_Cycle__c getFprCycleByNum( id PubId, integer FprCycleNum){
    	Map<Integer,FPR_Cycle__c>  fprCycleMap = getFprCycleMap(PubId);
    	
        if ( !fprCycleMap.containsKey(FprCycleNum)) {
            FPR_Cycle__c fprCycle = new FPR_Cycle__c();
            fprCycle.FPR_Cycle_num__c = FprCycleNum;
            fprCycle.Publication__c = PubId;
            insert fprCycle;
            
            System.assertNotEquals(null, fprCycle.id);
            System.assertNotEquals(null, fprCycle.FPR_Cycle_num__c);
            fprCycleMap.put(FprCycleNum,fprCycle);
            return fprCycle;
        } else {
            return fprCycleMap.get(FprCycleNum);
        }
    }
 
 	public boolean FprCycleHasBeenReset(Id fprCycleRecId) {
		//find all PubStatus for this FprCycle
		
		Set<Id> ResetStatusSet = new Set<Id>();
		/*
		ResetStatusSet.add(StatusModel.StatusMap.get('FPR Withdrawn').id);
		ResetStatusSet.add(StatusModel.StatusMap.get('FPR Withheld').id);
		ResetStatusSet.add(StatusModel.StatusMap.get('Material Changes for Congress/Journal').id);
		ResetStatusSet.add(StatusModel.StatusMap.get('Material Changes for Authors').id);
		ResetStatusSet.add(StatusModel.StatusMap.get('Terminate FPR Cycle').id);
		*/
		
		//#686 S3 - benjamin replaced with better code
		ResetStatusSet.add(StatusModel.FprWithdrawn.id);
		ResetStatusSet.add(StatusModel.FprWithHeld.id);
		ResetStatusSet.add(StatusModel.MaterialChangesForCongressJournal.id);
		ResetStatusSet.add(StatusModel.MaterialChangesforAuthors.id);
		ResetStatusSet.add(StatusModel.TerminateFPRCycle.id);
	
		List<PubStatus__c> pubStatusList = [
			select id
			from PubStatus__c
			where Publication_id__c = :pubId
			and Fpr_Cycle__c = :fprCycleRecid
			and ActualDate__c <> NUll
			and Status__c in :ResetStatusSet
		];  
		
		if (pubStatusList.size() > 0){
			AppLogModel.LogInfo('FprCycleModel::FprCycleHasBeenReset', 
				'FprCycleHasBeenReset == true', pubId);
			return true;
		} else {
			AppLogModel.LogInfo('FprCycleModel::FprCycleHasBeenReset', 
				'FprCycleHasBeenReset == false', pubId);
			return false;
		}
		
	}
   
}