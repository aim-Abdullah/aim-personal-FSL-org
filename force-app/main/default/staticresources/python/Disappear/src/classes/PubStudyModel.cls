public with sharing class PubStudyModel extends AppearBaseModel {
    private id PubId;
    private string ActiveTile;
    private string ActiveSubMenu;
    private boolean isFprSubmitter;
    public boolean hasEditAccess {get; private set;}
    
    
    private  List<PubStudy__c> pPubStudyList= null;
    public  List<PubStudy__c> PubStudyList{
        get{
            if(pPubStudyList== null){
              pPubStudyList= getAllPubStudyList(this.PubId);
            }               
        return pPubStudyList;
        }
    }  
    
    //constructor
    public PubStudyModel(Id PubId, string tile, string subMenu, boolean isFprOnly, boolean hasEditAccess) {
        this.PubId = PubId; 
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;
        this.isFprSubmitter = isFprOnly;
        this.hasEditAccess = hasEditAccess;
    }
     
    //Logical Delete  
    public PageReference deleteSelected() {
        Boolean recordHasDates = false;
        id PubId = pPubStudyList[0].Publication__c;
        List<PubStudy__c> itemsToDelete = new List<PubStudy__c>();
        for(PubStudy__c p : pPubStudyList){
            if (p.isSelected__c) {
                itemsToDelete.add(p);
            }
        }
        database.delete(itemsToDelete, false);  
        pPubStudyList = null;   
        setupMiscFromProdStudy(PubId);
        
        return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    }  

    private string pStudyProjectId = '';
    public string StudyProjectId{
        get {
            return pStudyProjectId;
        }
        set {
            pStudyProjectId = value;
        }
    }
    public string StudyProjectName{get;set;}
    
    public PageReference saveNewPubStudy() {
        AppLogModel.LogDebug('PubStudyModel::saveNewPubStudy', 'invoking saveNewPubStudy');

        if ( pStudyProjectId <> ''){
            Study__c study = StudyModel.findStudyById(pStudyProjectId);
            
            if ( study == null) {
                //invalid id for study - abort
                AppLogModel.LogError('PubStudyModel::saveNewPubStudy', 'Invalid id for study - abort for '+ pStudyProjectId);
                AppLogModel.flushLogs();
                return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
            }
            
            PubStudy__c pubStudy = new PubStudy__c();
            pubStudy.publication__c = pubId;
            pubStudy.Study__c = study.id;
            
            //insert pubStudy;  //Appear Enhancement R2: Historical Publication fix for Validation Rules
            try{
                insert pubStudy;
            }catch (DmlException err) {
                ApexPages.addMessages(err);
                return null;
            }
            
            /* //Moved logic to PubStudyTrigger+PubStudyTriggerLogic
           Publication__c pubCheckPass  = [select id, Pass__c from Publication__c where id =: pubId];

            
           boolean pstudy = Study.Pass__c;
            pubCheckPass.Pass__c = pstudy;
            update pubCheckPass  ;
         */
            setupMiscFromProdStudy(pubId);
           
            AppLogModel.LogDebug('PubStudyModel::saveNewPubStudy', 'Created new PubStudy record for '+PubId +' '+ study.id);

            AppLogModel.flushLogs();
            return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
        } else {
            AppLogModel.LogError('PubStudyModel::saveNewPubStudy', 'whats going on');
        }
        
        AppLogModel.flushLogs();
        return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    
    }
    
    public static void setupMiscFromProdStudy(id pubId) {
        list<PubStudy__c> Pubstudies = getAllPubStudyList(PubId);
        set<String> studyids = new set <String>();
        for(PubStudy__c pbs : Pubstudies){
            studyids.add(pbs.Study__r.Name);
        }
        String Projectstudystring='';
        for(String st: studyids){
            Projectstudystring  = (Projectstudystring <> '') ?  Projectstudystring + ', ':'';
            Projectstudystring = Projectstudystring + st;
        } 
        AppearPubModel activePub = new AppearPubModel(PubId);  
        activePub.UpdateProjectstudy(PubId, Projectstudystring);
    }
    
    public static boolean CheckDupStudyForPub(id PubId, Id studyId){
        list<pubStudy__c> ps = [
            select id
            from PubStudy__c
            where publication__c = :pubId 
            and id = :studyId
        ];
        if ( ps.size() == 0) {
            return false;
        } else {
            return true;
        }
    }
    
    public boolean canAddDelStudies {
        get{
            return !(ProfileModel.isAppearReviewers && !isFprSubmitter)  &&  hasEditAccess;
        }
    }
    
    public static List<PubStudy__c> getAllPubStudyList(Id PubId){
        if ( PubId == null) {
            return null;
        }
        List<PubStudy__c> result = [
            select id, Name, Publication__c, IsSelected__c,
            Study__c, Study__r.RecordTypeId, Study__r.Title__c,Study__r.Acronym__c,
            Study__r.Name,Study__r.Latest_Study_status__c,IsLogicallyDeleted__c,
            Study__r.Study_Type__c,Study__r.Study_Phase__c,Study__r.Posted_on_ClinTrials__c,
            Study__r.RecordType.Name
            From PubStudy__c
            where Publication__c = :PubId
            and isLogicallyDeleted__c = false
            order by Study__r.Title__c  
        ];
        return result;
    }
    //
    
    /////////////// clone ///////////////
    public static void clone(Id origPubId, Id destCloneId) {
        AppLogModel.LogInfo('PubStudyModel::clone', 'starting ' );

        
        List<PubStudy__c> origList = getAllPubStudyList(origPubId);
        
        List<PubStudy__c> destList = new List<PubStudy__c>();
        for(PubStudy__c record : origList){
            if ( record.IsLogicallyDeleted__c == false) {
                PubStudy__c clone = record.clone(false, true, false, false);
                clone.Publication__c = destCloneId;
                destList.add(clone); 
            }
        }
        
        insert destList;
    }
}