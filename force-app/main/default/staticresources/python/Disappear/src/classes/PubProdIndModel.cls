public with sharing class PubProdIndModel extends AppearBaseModel {
    ////////  members ////////////////////////
    private id PubId;
    private string ActiveTile;
    private string ActiveSubMenu;
    private boolean isFprSubmitter;
    
    public List<SelectOption> PubProductNameOptions {
        get {
            List<SelectOption> result = new List<SelectOption>();
            for( Pub_Prod_Ind__c product : PubProdIndicationList) {
            	result.add(new selectOption(product.Product_Indication__r.Product__c, product.Product_Indication__r.Product__r.Name));
            }
            return result;
        }
    }
    
    //return a list of Production Indication for Pub
    private List<ProductIndication__c> pProdIndListForPub = null;
    public List<ProductIndication__c> ProdIndListForPub {
        get {
            if (pProdIndListForPub == null) {
                pProdIndListForPub = ProdIndicationMapForPub.values();
            }
            return pProdIndListForPub;
        }
    }
    
    //return a list of Active Prod Indication Id for this Pub
    private Set<Id> pProdIndIdListForPub = null;
    public Set<Id> ProdIndIdListForPub {
        get {
            if (pProdIndIdListForPub == null) {
                pProdIndIdListForPub = ProdIndicationMapForPub.keyset();
            }
            return pProdIndIdListForPub;
        }
    }
    
    private Map<id, ProductIndication__c> pProdIndicationMapForPub = null;
    public Map<id, ProductIndication__c> ProdIndicationMapForPub {
        get {
            if (pProdIndicationMapForPub == null) {
                pProdIndicationMapForPub = getProdIndicationMapForPub();
            }
            return pProdIndicationMapForPub;
        } 
    }
    
    private List<Pub_Prod_Ind__c> pPubProdIndicationList = null;
    public List<Pub_Prod_Ind__c> PubProdIndicationList {
    	get {
	        if ( pPubProdIndicationList == null) {
	            pPubProdIndicationList = getPubProductIndication(PubId);
	            
	        }
        	return pPubProdIndicationList;
    	}
    }
    
    public Map<id, Pub_Prod_Ind__c> pAllPubProdIndicationMapByProdIndId = null;
    public Map<id, Pub_Prod_Ind__c> AllPubProdIndicationMapByProdIndId{
        get {
            if ( pAllPubProdIndicationMapByProdIndId == null){
                pAllPubProdIndicationMapByProdIndId = new Map<id, Pub_Prod_Ind__c> ();
                for(Pub_Prod_Ind__c pubProdInd : getAllPubProductIndication(PubId)){
                    pAllPubProdIndicationMapByProdIndId.put(pubProdInd.product_indication__c, pubProdInd);
                }
            }
            return pAllPubProdIndicationMapByProdIndId;         
        }

    }
    
    
    //////// Constructor //////////////////// 
    
    public PubProdIndModel(Id PubId,  string tile, string subMenu, boolean isFprSubmitter) {
        this.PubId = PubId; 
        this.ActiveTile = tile;
        this.ActiveSubMenu = subMenu;
        this.isFprSubmitter = isFprSubmitter;
    }
      
    //////// functions /////////////////////
    public Map<id, ProductIndication__c> getProdIndicationMapForPub() {
        List<Pub_Prod_Ind__c> ppis= getPubProductIndication(PubId);
        
        set<id> ProdIndIds = new set<id>();
        for(Pub_Prod_Ind__c ppi : ppis){
            ProdIndIds.add(ppi.Product_Indication__c);
        }
        
        return ProductIndicationModel.getProductIndicationByIndication(ProdIndIds);
        
    }
    
    
    //return active PubProdIndication Records
    public static List<Pub_Prod_Ind__c>  getPubProductIndication(id PubId){
        List<Pub_Prod_Ind__c> ppis= [
            select Publication__c, Product_Indication__c, Product_Indication__r.name, Product_Indication__r.IsEnbrel__c,
            name, isKey__c, isLogicallyDeleted__c, IsEnbrel__c, Product_Indication__r.Product__c, Product_Indication__r.Product__r.Name
            from Pub_Prod_Ind__c
            where Publication__c = :PubId
            and isLogicallyDeleted__c = false
        ]; 
        return ppis;
    }

    //return all PubProdIndication Records including logically deleted
    public static List<Pub_Prod_Ind__c>  getAllPubProductIndication(id PubId){
        List<Pub_Prod_Ind__c> ppis= [
            select Publication__c, Product_Indication__c, Product_Indication__r.name, Product_Indication__r.IsEnbrel__c,
            name, isKey__c, isLogicallyDeleted__c, IsEnbrel__c, Product_Indication__r.Product__c, Product_Indication__r.Product__r.Name
            from Pub_Prod_Ind__c
            where Publication__c = :PubId
        ];
        return ppis;
    }   
    
        //return active non-expired PubProdIndication Records
    public static List<Pub_Prod_Ind__c>  getUEPubProductIndication(id PubId){
        List<Pub_Prod_Ind__c> ppis= [
            select Publication__c, Product_Indication__c, Product_Indication__r.name, Product_Indication__r.IsEnbrel__c,
            name, isKey__c, isLogicallyDeleted__c, IsEnbrel__c, Product_Indication__r.Product__c, Product_Indication__r.Product__r.Name
            from Pub_Prod_Ind__c
            where Publication__c = :PubId
            and isLogicallyDeleted__c = false 
            and Product_Indication__r.isLogicallyDeleted__c = false
        ]; 
        return ppis;
    }

    
    /////////////////////////////////////////////////////////////////////////
    //  support new Model dialog on Publication Details
    
    private list<string> pSelectedProductIndications = null;
    public list<string> SelectedProductIndications{ 
        get {
            
            //return the current list of Product Indication Id selected for the Pub as String 
            if (pSelectedProductIndications == null){
                pSelectedProductIndications = new list<string>();
                for(Pub_Prod_Ind__c pubProdInd : getPubProductIndication(PubId)) {
                    pSelectedProductIndications.add(pubProdInd.Product_Indication__c);
                }
            }
            return pSelectedProductIndications;
        }
        set {
            pSelectedProductIndications = value;
        }
    }   
    
    //return all Product Indications in Appear for the multiselect list
    public list<SelectOption> getProdIndicationMultiSelect() {
        List<SelectOption> options = new List<SelectOption>();
        for(ProductIndication__c prodInd : ProductIndicationModel.ProductIndicationList){
            options.add(new SelectOption(prodInd.id, prodInd.name));
        }
        return options;
    }
    
    //can't use id for type 
    //if user pick none - then id will break - have to start with string first
    private string pKeyProdIndStr = null;
    public string KeyProdIndStr {
        get {
            if ( pKeyProdIndStr == null){
                for (Pub_Prod_Ind__c pubProdInd : AllPubProdIndicationMapByProdIndId.values()  ) {
                    if (pubProdInd.isKey__c == true) {
                        pKeyProdIndStr = pubProdInd.Product_Indication__c;
                        AppLogModel.LogInfo('PubProdIndModel::KeyProdIndId', 
                            'Initialize Getter to : ' + pKeyProdIndStr + ' '+pubProdInd.Product_Indication__r.name, PubId);
                    }
                }               
            }   
            return pKeyProdIndStr;      
        }
        set {
            pKeyProdIndStr = value;
        }

    }
    
    private string pKeyProdNameId= null;
    public Id KeyProdNameId {
        get {
            if ( pKeyProdNameId == null){
                for (Pub_Prod_Ind__c pubProdInd : AllPubProdIndicationMapByProdIndId.values()  ) {
                    if (pubProdInd.isKey__c == true) {
                        pKeyProdNameId = pubProdInd.Product_Indication__r.Product__c;
                    }
                }               
            }   
            return pKeyProdNameId;      
        }
        set {
            pKeyProdNameId = value;
        }
    }
    
    //Iterate over the 
    //convert to PubProdInd records
    //set the isKey for 1 records.
    public PageReference savePubProdInd() {
        AppLogModel.LogInfo('PubProdIndModel::savePubProdInd', 
            'Selected Production Indications are : ' + 
            ProductIndicationModel.toStringFromIdList(SelectedProductIndications), PubId);
            
        AppLogModel.LogInfo('PubProdIndModel::savePubProdInd', 
            'Selected Key Production Indication is : ' +
            ProductIndicationModel.toStringFromId(KeyProdIndStr), PubId);       
        AppLogModel.flushLogs(); 
    
 
         
        //find a list of selected ProductIndication
        Set<id> selectedProdInds = new Set<id>();
        for(string selectedProdIndication : SelectedProductIndications){
            selectedProdInds.add(selectedProdIndication);
        }    
         
        
        if ( selectedProdInds.size() == 0){
            AppearAddErrorMessage(AppearErrorMessages.ProductIndicationIsMandatory);    
            AppLogModel.LogError('PubProdIndModel::savePubProdInd', 
                AppearErrorMessages.ProductIndicationIsMandatory, PubId);   
            AppLogModel.flushLogs();
            return null;
            //return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
        }
        

        Id KeyProdIndId=null;       
        
        //if we only have only 1 Prod Indication selected
        //make it the key.
        if ( selectedProdInds.size() == 1){
            KeyProdIndStr = SelectedProductIndications[0];
            AppLogModel.LogInfo('PubProdIndModel::savePubProdInd', 
                'only 1 production Indication - key default to ' + ProductIndicationModel.toStringFromId(KeyProdIndStr), PubId);        
        }
        
        //make sure only 1 has been selected as key
        if ( KeyProdIndStr == '' ){
            AppLogModel.LogError('PubProdIndModel::savePubProdInd', 
                AppearErrorMessages.SelectValidPrimaryProductIndication, PubId);                    
            AppearAddErrorMessage(AppearErrorMessages.SelectValidPrimaryProductIndication); 
            AppLogModel.flushLogs();
            return null;
            //return new PageReference(AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId));
        }

        KeyProdIndId = KeyProdIndStr;
        System.Debug('***   PubProdIndModel::KeyProdIndId = '+KeyProdIndId);
        ProductIndication__c KeyProdInd =  ProductIndicationModel.ProductIndicationMap.get(KeyProdIndId);
    
        
        //Error checking done
         
        
        ///////
        //start cleanup previous PubProdInd & PubTeamMembers
        
        //1 - delete all current PubTeamMembers created from Product Indicatior - leave the Adhoc
        PubTeamMemberModel.deletePubProdIndTeamMembers(PubId);
         
        //2 - delete all current PubProdIndicator
        list<Pub_Prod_Ind__c> allPubProdInd = PubProdIndModel.getAllPubProductIndication(PubId);
        AppLogModel.LogInfo('PubProdIndModel::savePubProdInd', 
            'Current Pub Prod Indicationsto be deleted : ' + PubProdIndModel.toString(allPubProdInd));  
        //delete allPubProdInd;
        withoutSharingUtil.DelRecords(allPubProdInd, true);
        
        
        //3. insert new product Indication selected
        List<Pub_Prod_Ind__c> pubProdIndList = new List<Pub_Prod_Ind__c>();
        for(String selProdInd : SelectedProductIndications) {
            Pub_Prod_Ind__c newPubProdInd = new Pub_Prod_Ind__c();
            newPubProdInd.Publication__c = PubId;
            newPubProdInd.Product_Indication__c = selProdInd;
            newPubProdInd.isLogicallyDeleted__c = false;
            if ( newPubProdInd.Product_Indication__c == KeyProdIndId) {
                newPubProdInd.isKey__c = true;
            } else {
                newPubProdInd.isKey__c = false;
            }
            
            pubProdIndList.add(newPubProdInd);
        }
        
        //Insert all Pub Product Indicators
        Insert pubProdIndList; 
         
        AppLogModel.LogInfo('PubProdIndModel::savePubProdInd', 
            'Inserted : ' + PubProdIndModel.toString(pubProdIndList), pubId);       
        
        //4. Create PubTeamMembers and reset sharing - only for Planned Pub / NOT For FPR Only [ Def 281 ]
        if ( !isFprSubmitter ) {
            PubTeamMemberModel.createPubTeamMembers(PubId, pubProdIndList, KeyProdIndId);       
        }   
        
        //5. Misc Enbrel & Product Ind String + TA
        //Appear Enhancement R3: Try catch added as a part of Historical Data Fix
        try{
        	setupMiscFromProdInd(PubId, KeyProdIndId, pubProdIndList);
        }catch(DMLException ae){
        	ApexPages.addMessages(ae);
        	return null;
        }
        
        AppLogModel.flushLogs();
        return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
    }
    

    private static void setupMiscFromProdInd(id PubId, Id KeyProdIndId, List<Pub_Prod_Ind__c> pubProdIndList) {
        //5. create a string for the Publication Record - Product_Indication__c & TA field 
        
        AppLogModel.LogInfo('PubProdIndModel::setupMiscFromProdInd', 
            'Inserted : ' + PubProdIndModel.toString(pubProdIndList), pubId);
        
        string KeyProdIndName = '';
        ProductIndication__c keyProductIndication = ProductIndicationModel.ProductIndicationMap.get(KeyProdIndId);
        if ( keyProductIndication <> null) {
            KeyProdIndName = keyProductIndication.name;
        }
    
        string prodIndString = KeyProdIndName;
        
        boolean isEnbrelSelected = false;
        for(Pub_Prod_Ind__c pubProdInd : getPubProductIndication(PubId)) {
            
            if (pubProdInd.isLogicallyDeleted__c == false) {
                
                AppLogModel.LogDebug('PubProdIndModel::setupMiscFromProdInd', 
                        'product Indication- '+pubProdInd.Product_Indication__r.name +' isEnbrel = '+ pubProdInd.Product_Indication__r.isEnbrel__c, pubProdInd.Product_Indication__r.id);   
                
                AppLogModel.LogDebug('PubProdIndModel::setupMiscFromProdInd', 
                        'pub Prod Indication- '+pubProdInd.name +':'+ pubProdInd.Product_Indication__r.name +' isEnbrel = '+ pubProdInd.isEnbrel__c, pubProdInd.id);    
                        
                if (pubProdInd.isEnbrel__c) {
                    isEnbrelSelected = true;
                } 
                
                if ( pubProdInd.iskey__c == false) {
                    prodIndString += '; '+ ProductIndicationModel.ProductIndicationMap.get(pubProdInd.product_indication__c).name;
                }
            }
        }

        AppLogModel.LogInfo('PubProdIndModel::setupMiscFromProdInd', 'Pub ProdIndication String : ' + prodIndString, pubId);
        Id TAid = null;
        if ( keyProductIndication <> null) {
            KeyProdIndName = keyProductIndication.name;
            TAid = keyProductIndication.Therapeutic_Area__c;    
        }
        AppearPubModel.UpdateProductIndicationForPub(PubId, ProdIndString, isEnbrelSelected, TAid);         
    }
    
    
    
    public static string toString(List<Pub_Prod_Ind__c> pubProdIndList) {
        string result = '[name:isKey:isLogicallyDeleted]  => ';
        
        for( Pub_Prod_Ind__c pubProdInd : pubProdIndList){
            result += toString(pubProdInd) + '\r\n';
        }
        
        return result;
    }
    
    public static string toString(Pub_Prod_Ind__c pubProdInd) { 
        
        ProductIndication__c prodInd = ProductIndicationModel.ProductIndicationMap.get(pubProdInd.Product_Indication__c);
        string pubProdName = pubProdInd.Product_Indication__c;
        if (prodInd <> null ) pubProdName = prodInd.name;
        return '['+ pubProdName + ':' + pubProdInd.isKey__c + ':'+ pubProdInd.isLogicallyDeleted__c+']';
    }
    
    
 
    public PageReference cancel() {
        return new PageReference(isFprSubmitter ? AppearUrlModel.AppearFprSubmitterMenuUrl(ActiveSubMenu, ActiveTile, PubId) : AppearUrlModel.AppearPubMenuUrl(ActiveSubMenu, ActiveTile, PubId)) ;
    }
    //discussed with Brandon - we will not have DeleteSelected  
    
    ////////////////////Static //////////////
    public static void insertPubProdInd(Id PubId, Set<string> ProdIndNames){
        List<Pub_Prod_Ind__c> insertList = new List<Pub_Prod_Ind__c>();
        for(string ProdIndName : ProdIndNames ){
            if ( ProductIndicationModel.ProductIndicationNameMap.containsKey(ProdIndName)){
                Pub_Prod_Ind__c newPubProdInd = new Pub_Prod_Ind__c();
                newPubProdInd.Publication__c = PubId;
                newPubProdInd.isLogicallyDeleted__c = false;
                newPubProdInd.Product_Indication__c = ProductIndicationModel.ProductIndicationNameMap.get(ProdIndName).id;
                newPubProdInd.isKey__c = true; 
                
                insertList.add(newPubProdInd);
            } else {
                AppLogModel.LogError('PubProdIndModel::insertPubProdInd', 'ProductIndicationNameMap missing - ' + ProdIndName);
            }
        }
        insert insertList;
        AppLogModel.LogInfo('PubProdIndModel::insertPubProdInd', 'insertList = ' + insertList);
        
    }
    
    //cannot remove with Scientific Statement or Team Members
    public static void removePubProdInd(Id PubId, Set<string> ProdIndNames){
        set<Id> removeSet = new set<Id>();
        
        for(string ProdIndName : ProdIndNames ){
            if ( ProductIndicationModel.ProductIndicationNameMap.containsKey(ProdIndName)){
                removeSet.add(ProductIndicationModel.ProductIndicationNameMap.get(ProdIndName).id);
            }
        }
        /*
        List<Pub_Prod_Ind__c> logicaldelList = [
        //not ready - need to talk about how to treat delete with team member.
        
        ];
        */
        
    }
    
    
    /////////////// clone ///////////////
    public static void clone(Id origPubId, Id destCloneId) {
        List<Pub_Prod_Ind__c> origList = getUEPubProductIndication(origPubId);
        
        List<Pub_Prod_Ind__c> destList = new List<Pub_Prod_Ind__c>();
        for(Pub_Prod_Ind__c record : origList){
            Pub_Prod_Ind__c clone = record.clone(false, true, false, false);
            clone.Publication__c = destCloneId;
            destList.add(clone); 
        }
        
        insert destList;
        
        id KeyProdIndId = null;
        for(Pub_Prod_Ind__c ppi : destList){
            if (ppi.isKey__c) {
                //KeyProdIndId = ppi.id;
                KeyProdIndId = ppi.Product_Indication__c;
            }
        }
        
        if ( KeyProdIndId == null) {
            AppLogModel.LogError('PubProdIndModel::clone', 'Cannot find Key Product Indication in cloned Pub');
        }
        
        // 2013-07-25 - refactor to use the same code to create PubTeamMember
        PubTeamMemberModel.createPubTeamMembers(destCloneId, destList, KeyProdIndId);   
        setupMiscFromProdInd(destCloneId, KeyProdIndId, destList);
        
        AppLogModel.LogInfo('PubProdIndModel::Clone', 'Cloned Pub Product Indication inserted '+destList.size()+' records');
        
    }
}