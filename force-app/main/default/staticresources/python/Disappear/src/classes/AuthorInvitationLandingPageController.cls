public without sharing class AuthorInvitationLandingPageController  {
    // public Static Id PubId;
    public Boolean haserror{get;set;}
    public id PubAuthorId{get;set;}
    public pubAuthor__c PubAuth{get;set;}
    public Id AuthorId {get;set;}
    public ProvisionDocumentVersion__c comp{get;set;}
    public String compType{get;set;}
    public id docid{get;set;}
    public id publicationId {get;set;}
    public Boolean hasUserAssociated{get;set;} //Appear Enhancement R2
    //Constructor to get the required values from the page
    public AuthorInvitationLandingPageController(){
        PubAuthorId= ApexPages.currentpage().getParameters().get('PubAuthorId');
        if(PubAuthorId != null ){
            PubAuth = [select id,author__r.id,publication__r.id,AuthorStatus__c,publication__c,InviteAcceptedDate__c,Disclaimer_ID__c from pubAuthor__c where Id =:PubAuthorId
                      	AND isLogicallyDeleted__c = false //Appear Enhancement R3 : Soft Delete Author functionality
                      ];
            // Pubid = Pubauth.publication__c;
            publicationId = Pubauth.publication__c;
            AuthorId = PubAuth.author__r.Id; 
            DocId = PubAuth.Disclaimer_ID__c;
            
        }
        comp=[SELECT id, ProvisionDocumentContent__c, Name
                      FROM ProvisionDocumentVersion__c ORDER BY createddate Desc limit 1]; 
            System.debug('---------------'+comp); 
        //Appear Enhancement R2, Checking if user present for redirection logic 
        Contact con=[select UserId__c from contact where id=:AuthorId];
            //hasuser=false;
            hasUserAssociated = false;
        if(con.UserId__c!=null){
            hasUserAssociated = true;
        }
    }
    
    //Appear Enhancement R2
    Public Pagereference RedirecttoPage(){       
        if(hasUserAssociated==false) {
	        PageReference page = new pagereference('/apex/CommunitiesSelfReg?'+'&ContactId='+AuthorId+'&Id='+publicationId);
	        return page;  
        }
        else{
             PageReference page = new pagereference('/apex/appearpubauthordashboard?Id='+publicationId+'&sfdc.tabName=01ri00000004OaA&submenu=Plan&tile=Pub%20Details' + '&ContactId=' + AuthorId ); 
             return page;   
        }           
      
    }
    //logic if the author accepts the disclaimer
    Public Pagereference AppearPubAuthor(){
        AppearPubModel pubModel = new AppearPubModel(publicationId); // new AppearPubModel(pubid);
        PubAuthorModelNoSharing aPubAuthorNoSharing = pubModel.PubAuthorNoSharing; 
        aPubAuthorNoSharing.updatePubAuthorStatusAndInvitedDate(PubAuthorId);
        PageReference page = new pagereference('/apex/appearpubauthordashboard?Id='+publicationId+'&activeopr=update&sfdc.tabName=01ri00000004OaA&submenu=Plan&tile=Pub%20Details' + '&ContactId=' + AuthorId );
        return page;
    }
    //getting the disclaimer associated with the Pub Author record
    public pagereference getContentVersionPage(){
        if(docid!=null){
            // Document cv = [select id from Document Where id =: DocId ];
            Id Cvid =  docid; // cv.id;
            pagereference pageref = new Pagereference((AppearURLModel.IsAuthorComm? '/PubAuthor': '')+ '/servlet/servlet.FileDownload?file='+Cvid);
            return pageref;
        }
        else{
            return null;
        }
   } 
   public void setCompType(String s){
          compType = s;
      }
        
      public String getCompType(){
          return compType;
      }
   
   //Logic for cancel button
   Public PageReference CancelAppearPubAuthor(){
        Pagereference Pageref;
        list<user> users =[select id from user where contactid =: AuthorID];
        if(Users.Isempty()){
            haserror = false;   
        }
        else{
            haserror = true;
            Pageref = new pagereference('/apex/appearpubauthordashboard?sfdc.tabName=01rZ00000000bbN');
        }
        return Pageref;
        
    }
}