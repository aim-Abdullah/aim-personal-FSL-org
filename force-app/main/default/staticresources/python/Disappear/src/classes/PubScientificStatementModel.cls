public with sharing class PubScientificStatementModel {

    private id PubId;
    private List<Id> PubObjectiveIdList;
    private Id PubKeyObjective;
    private string ActiveTile;
    private string ActiveSubMenu;
    
    private List<ProdIndiObjective__c> pAllPubObjectives = null;
    public List<ProdIndiObjective__c> AllPubObjectives {
        get {
            return pAllPubObjectives;
        }
    }
    
    private List<ProdIndObjSciStatement__c> ScientificStatementBySelectedObjectives() {
        //find all selected objective -> selectedObjectives
        List<ProdIndiObjective__c> selectedObjectives = new List<ProdIndiObjective__c>();
        for(ProdIndiObjective__c obj : AllPubObjectives){ 
            if (obj.isSelected__c ){
                selectedObjectives.add(obj);
            }
        }
        List<ProdIndObjSciStatement__c> SsList = ProdIndObjSciStatementModel.findScientificStatementByObjectives(selectedObjectives);           


        AppLogModel.LogDebug('PubScientificStatementModel::ScientificStatementBySelectedObjectives', 
             'PubScientificStatementIdSet = '+ PubScientificStatementIdSet, PubId);
        //reload if scientific statement changes
        for ( ProdIndObjSciStatement__c ss : SsList) {
            if ( PubScientificStatementIdSet.contains(ss.id)){
				ss.isSelected__c = true;
            } else {
                ss.isSelected__c = false;
            }
        }
            
        //now remove all expired Scientific Statement if not already selected
        List<ProdIndObjSciStatement__c> SsActiveList = new  List<ProdIndObjSciStatement__c> ();
        for(ProdIndObjSciStatement__c ss : SsList){
        	if ( ss.isSelected__c || !ss.islogicallyDeleted__c) {
        		SsActiveList.add(ss);
        	}
        }
        
        
        
        AppLogModel.LogDebug('PubScientificStatementModel::ScientificStatementBySelectedObjectives', 
             'SsActiveList = '+ SsActiveList, PubId);
        return SsActiveList;
    } 

    
    private transient List<ProdIndObjSciStatement__c> pAllPubScientificStatements = null;
    public List<ProdIndObjSciStatement__c> AllPubScientificStatements {
        get {
            pAllPubScientificStatements = ScientificStatementBySelectedObjectives();    
            return pAllPubScientificStatements;
        }

    }
    
    private transient Set<Id> pPubScientificStatementIdSet = null;
    public Set<Id> PubScientificStatementIdSet{
        get{
            if ( pPubScientificStatementIdSet == null){
                pPubScientificStatementIdSet = getPubScientificStatementIdSet(PubId);
            }
            return pPubScientificStatementIdSet;
        }
        set {
            pPubScientificStatementIdSet = value;
        }
    }
    
    //return a set of Scientific_Statement__c selected for the publication
    public static Set<id> getPubScientificStatementIdSet(Id PubId){
        List<PubScientificStatement__c> PubSSList = [
            select id, Scientific_Statement__c
            from PubScientificStatement__c
            where Publication__c = :PubId
        ];
        set<id> result = new set<id>();
        for(PubScientificStatement__c pubSS : PubSSList) {
            result.add(pubSS.Scientific_Statement__c);
        }   
        return result;
    }
    
    private List<PubScientificStatement__c> pPubScientificStatementList = null;
    public List<PubScientificStatement__c>  PubScientificStatementList {
        get {
            if ( pPubScientificStatementList == null) {
                pPubScientificStatementList = getPubScientificStatementList(PubId);
            }
            return pPubScientificStatementList;
        }
    }
   
    private static List<PubScientificStatement__c> pPubSciStmtList= null;
    public static List<PubScientificStatement__c> PubSciStmtList{
        get{
            if(pPubSciStmtList== null){
              pPubSciStmtList= getAllPubNoteList();
            }               
        return pPubSciStmtList;
        }
    }
     public static List<PubScientificStatement__c> getAllPubNoteList(){
        List<PubScientificStatement__c> result = [
          select id, Name
          From PubScientificStatement__c
          order by Name  
           ];
        return result;
    }
      
   private static Map<String, PubScientificStatement__c> pPubSciStmtNameMap = null;
   public static Map<String, PubScientificStatement__c> PubSciStmtNameMap{
     get {
       if (pPubSciStmtNameMap == null){
         pPubSciStmtNameMap = getPubSciStmtMapByName();
       }
       return pPubSciStmtNameMap;
     }
   }
   
   public static Map<String, PubScientificStatement__c> getPubSciStmtMapByName() {
    Map<String, PubScientificStatement__c> result = new Map<String, PubScientificStatement__c>();
    for(PubScientificStatement__c pPubSciStmt : PubSciStmtList){
      result.put(pPubSciStmt.Name, pPubSciStmt);
    }

    return result;
  }
   

    //constructor
    public PubScientificStatementModel(Id PubId, string tile, string subMenu, List<ProdIndiObjective__c> AllPubObjectiveList) {
        this.PubId = PubId; 
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;
                    
        pAllPubObjectives = updateSelectedObj(AllPubObjectiveList);
    }
    
    private List<ProdIndiObjective__c>  updateSelectedObj(List<ProdIndiObjective__c>  AllPubObjectiveList) {
        //turn the isSelected to true for all Objectives for this publication
        set<id> PubObjectiveIdSet = new Set<id>();
        for(PubScientificStatement__c pubSS : PubScientificStatementList){
            PubObjectiveIdSet.add(pubSS.Scientific_Statement__r.Product_Indication_Objective__c);
        }
        
        for ( ProdIndiObjective__c pubProdIndObj : AllPubObjectiveList) {
            if ( PubObjectiveIdSet.contains(pubProdIndObj.id)){
                pubProdIndObj.isSelected__c = true;
            } else {
                pubProdIndObj.isSelected__c = false;
            }
        }   
        
        //remove all expired Objectives that is not currently associated with the Pub
        List<ProdIndiObjective__c> activeProdIndObjectives = new List<ProdIndiObjective__c>();
        for (ProdIndiObjective__c  pubProdIndObj : AllPubObjectiveList) {
        	if ( pubProdIndObj.isSelected__c || !pubProdIndObj.isLogicallyDeleted__C) {
        		activeProdIndObjectives.add(pubProdIndObj);
        	}
        }
        
        return activeProdIndObjectives;
    }
    
    
    //to display on the main Scientific Statement Tile
    public static List<PubScientificStatement__c> getPubScientificStatementList(Id PubId) {
        List<PubScientificStatement__c> result = [
            select Name, isKey__c, Publication__c, isDeleted,
            Scientific_Statement__c, 
            Scientific_Statement__r.ScientificStatement__c,  
            Scientific_Statement__r.ScientificStatement_no__c,
            Scientific_Statement__r.Product_Indication_Objective__c,
            Scientific_Statement__r.Product_Indication_Objective__r.Name,
            Scientific_Statement__r.Product_Indication_Objective__r.Product_Indication__r.name
            from PubScientificStatement__c
            where Publication__c = :PubId
            order by isKey__c desc,Scientific_Statement__c
        ];
        
        return result;
    }

        
    //handle the saving of Pub Obj & Pub Scientific Statement from the modal dialog
    public void saveSelectedObjectivesSciStatements() {         
        //for each selected SS in the AllPubScientificStatements
        //save to PubScientificStatement__c
        
        //AllPubScientificStatements
        AppLogModel.LogInfo('PubScientificStatementModel::saveSelectedObjectivesSciStatements', 
            'Perisiting Pub Scientific Statement(s) : ', PubId);
            
        //find all selected Scientific Statements
        set<id> selectedPubSsIdSet = new set<id>();
        for( ProdIndObjSciStatement__c pubSS : pAllPubScientificStatements) {
            if (pubSS.isSelected__c){
                selectedPubSsIdSet.add(pubSS.id);
            }
        }
        List<PubScientificStatement__c> delPubSS = new List<PubScientificStatement__c>();
        set<id> leftOverPubSSid = new set<Id>();
        for(PubScientificStatement__c pubSS : PubScientificStatementList) {
            if (!selectedPubSsIdSet.contains(pubSS.id)){
                if ( !pubSS.isDeleted ) delPubSS.add(pubSS);
            } else {
                leftOverPubSSid.add(pubSS.id);
            }
        }
        delete delPubSS;
        if ( delPubSS.size() > 0) {
        	database.emptyRecycleBin(delPubSS);
        }
        
        List<PubScientificStatement__c> newPubSS = new List<PubScientificStatement__c>();
        for(id ssId : selectedPubSsIdSet){
            if ( !leftOverPubSSid.contains(ssid)){
                PubScientificStatement__c pubSS = new PubScientificStatement__c();
                pubSS.IsKey__c = false;
                pubSS.Publication__c = pubid;
                pubSS.Scientific_Statement__c = ssId;
                
                newPubSS.add(pubSS);
            }
        }
        insert newPubSS;

        AppLogModel.LogInfo('PubScientificStatementModel::saveSelectedObjectivesSciStatements', 
            'Inserted the following Pub Scientific Statement(s) : '+newPubSS, PubId);
        AppLogModel.flushLogs();
        
        pPubScientificStatementList = null;
        pAllPubScientificStatements = null;
        pPubScientificStatementIdSet = null;
        pAllPubObjectives = updateSelectedObj(pAllPubObjectives);
    }
    
    
    //used to change Key Scientific Statement 
    //this does not handle insert or delete
    public PageReference save() {
        
        //validation rule will check if more than one objective has been marked as key
        database.update(pPubScientificStatementList, true);
        
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    public PageReference cancel() {
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
    
    public PageReference deleteSelected() {
        
        database.update(pPubScientificStatementList, true); 
        pPubScientificStatementList = null; 

        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }
	/////////////// clone ///////////////
	public static void clone(Id origPubId, Id destCloneId) {
		List<PubScientificStatement__c> origList = getPubScientificStatementList(origPubId);
		
		List<PubScientificStatement__c> destList = new List<PubScientificStatement__c>();
		for(PubScientificStatement__c record : origList){
			PubScientificStatement__c clone = record.clone(false, true, false, false);
			clone.Publication__c = destCloneId;
			destList.add(clone); 
		}
		
		insert destList;
	}
}