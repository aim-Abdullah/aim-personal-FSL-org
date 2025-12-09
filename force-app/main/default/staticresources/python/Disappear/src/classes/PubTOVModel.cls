public with sharing class PubTOVModel extends AppearBaseModel {

    private id PubId;
    private string ActiveTile;
    private string ActiveSubMenu;
    private AppearPubModel pubModel; 
    public boolean hasEditAccess {get; private set;}
    
    // property for new record creation
    private transient PubTOV__c pNewPubTOV = null;
    public PubTOV__c newPubTOV { //insert from model
        get {
            if (pNewPubTOV == null) {                
                pNewPubTOV = new PubTOV__c();
                pNewPubTOV.Publication__c = PubId;
                pNewPubTOV.PublicationStatus__c  = pubModel.pubRecord.PubStatus__c; 
                pNewPubTOV.SubmissionCycle__c  = pubModel.pubRecord.Current_SubmissionCycle_Id_Formula__c; 
                pNewPubTOV.Product_Name__c  = pubModel.PubProdIndication.KeyProdNameId;
            }
            return pNewPubTOV;
        }
        set {
            pNewPubTOV = value;
        }
    }
    
	// wrapper is used for selection tracking
    public class TOVWrapper{
    	public PubTOV__c pTOV {get;set;}
    	public boolean IsSelected {get;set;}
    	TOVWrapper(PubTOV__c aTov){
    		pTOV = aTOV;
    		IsSelected = false; 
    	}
    	
    }
        
    //constructor
    public PubTOVModel(Id PubId, AppearPubModel pubModel, string tile, string subMenu, boolean hasEditAccess ) {
        this.PubId = PubId; 
        this.PubModel =  pubModel; 
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;
        this.hasEditAccess = hasEditAccess;
    }
     
    //Logical Delete  
    public PageReference deleteSelected() {
        Boolean recordHasDates = false;

        List<PubTOV__c> itemsToDelete = new List<PubTOV__c>();
        for(TOVWrapper p : PubTOVListWrapper){
            if (p.IsSelected) {
                itemsToDelete.add(p.pTOV);
            }
        }
        if (itemsToDelete.size() > 0){
	        database.delete(itemsToDelete, false);  
    	    pPubTOVListWrapper = null;   // force to refresh 		  
        	return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, itemsToDelete[0].publication__c));
        } else {
        	return null;
        }
    }  



    
    public PageReference saveNewPubTOV() {
	       
	       AppLogModel.LogDebug('PubTOVModel::saveNewPubTOV', 'invoking saveNewPubTOV');

		   PubTOV__c aPubTOV = new PubTOV__c();
		   aPubTOV.Publication__c = PubId;
		   aPubTOV.ContractNumber__c = newPubTOV.ContractNumber__c ;
		   aPubTOV.Description__c = newPubTOV.Description__c;  
		   aPubTOV.FormOfPayment__c =  newPubTOV.FormOfPayment__c;
		   aPubTOV.InvoiceNumber__c = newPubTOV.InvoiceNumber__c;
		   aPubTOV.NatureOfPayment__c = newPubTOV.NatureOfPayment__c;
		   aPubTOV.PaymentAmount__c = newPubTOV.PaymentAmount__c;		   
		   aPubTOV.PaymentDate__c = newPubTOV.PaymentDate__c;
		   
		   // to do: get the publication status and submission cycle from active pub
		   aPubTOV.PublicationStatus__c = newPubTOV.PublicationStatus__c;
		   aPubTOV.SubmissionCycle__c = pubModel.PubStatus.PubStatusMap.get(newPubTOV.PublicationStatus__c).Submission_Cycle__c;
		   aPubTOV.Product_Name__c = newPubTOV.Product_Name__c;
		   
		try {
		        insert aPubTOV;
		                   
		        AppLogModel.LogDebug('PubTOVModel::saveNewPubTOV', 'Created new PubTOV record for '+PubId );
		        AppLogModel.flushLogs();
		        return new PageReference( AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
		 } catch (DMLException e) {
		        AppLogModel.LogError('PubTOVModel::saveNewPubTOV', 'Faile to save: ' + e);
		        AppLogModel.flushLogs();
		}
        
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
    
    }
    
    
    public boolean canAddDelTOVs {
        get{
            return  hasEditAccess;
        }
    }

    public PageReference saveTOVList() {
                
        database.update(PubTOVList, true);
        pPubTOVListWrapper = null;  //force refresh of new sort order
        
        AppLogModel.flushLogs();
        
        return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
        
    }


    public  List<PubTOV__c> PubTOVList{
        get{
			 List<PubTOV__c> aPubTOVList = new   List<PubTOV__c> ();
			 for (TOVWrapper aTOVWrapper: PubTOVListWrapper){
			 	aPubTOVList.add(aTOVWrapper.pTOV);
			 }
			 return aPubTOVList;
        }
    }  

    private  List<TOVWrapper> pPubTOVListWrapper= null;
    public  List<TOVWrapper> PubTOVListWrapper{
        get{
            if(pPubTOVListWrapper== null){
            	pPubTOVListWrapper = new List<TOVWrapper>() ; 
              List <PubTOV__c> aTOVList = getAllPubTOVList(this.PubId);
              for (PubTOV__c aTOV :aTOVList ){
              	pPubTOVListWrapper.add(new TOVWrapper(aTOV)); 
              }
            }               
	        return pPubTOVListWrapper;
        }
        set {
        	pPubTOVListWrapper = value; 
        }
    }  


    
    public static List<PubTOV__c> getAllPubTOVList(Id PubId){
        if ( PubId == null) {
            return null;
        }
        List<PubTOV__c> result = [
            select id, Name, Publication__c, 
            ContractNumber__c, Description__c, FormOfPayment__c, InvoiceNumber__c, 
            NatureOfPayment__c, PaymentAmount__c, PaymentDate__c, 
            PublicationStatus__c,PublicationStatus__r.Status__r.name , 
            SubmissionCycle__c, SubmissionCycle__r.name, SubmissionCycle__r.Submission_Cycle_Num__c, 
            Product_Name__c, Product_Name__r.name
            From PubTOV__c
            where Publication__c = :PubId
            and isLogicallyDeleted__c = false
            order by PaymentDate__c desc 
        ];
        return result;
    }

    
    /////////////// clone ///////////////
/*
    public static void clone(Id origPubId, Id destCloneId) {
        AppLogModel.LogInfo('PubTOVModel::clone', 'starting ' );

        
        List<PubTOV__c> origList = getAllPubTOVList(origPubId);
 
        List<PubTOV__c> destList = new List<PubTOV__c>();
        for(PubTOV__c record : origList){
            if ( record.IsLogicallyDeleted__c == false) {
                PubTOV__c clone = record.clone(false, true, false, false);
                clone.Publication__c = destCloneId;
                destList.add(clone); 
            }
        }
        
        insert destList;
    }

*/

}