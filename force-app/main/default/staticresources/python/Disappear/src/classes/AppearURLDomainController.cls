public without sharing class AppearURLDomainController {

    private static string pDomainURL = null;    
    public static string DomainURL{
        get {
            if (pDomainURL == null) {
            	
				try {
					for (Domain d:  [SELECT Domain,DomainType FROM Domain where Domain like '%appearportal%' or Domain like '%authorcollaboration%' order by Domain desc ]  ){
						String dDomainUFL = d.Domain;
					if (dDomainUFL.indexOf('authorcollaboration') >=0  ){ // R4 authorcollaboration.amgen.com	 take priority
							pDomainURL = dDomainUFL; 				
							break; 	
					} else if (dDomainUFL.indexOf('-appearportal') >=0  ){  // if there are duplciated entires, the one with sandboxname-appearportal will take priority
							pDomainURL = dDomainUFL; 				
							break; 									
						} else if (dDomainUFL.indexOf('appearportal') >=0 ){
							pDomainURL = dDomainUFL; 
							break; 
						}					
					}					
				} catch (Exception e){
					pDomainURL = null; 
				}
                                
                if (pDomainURL == null) {
                    pDomainURL = '';
                }
            }
            return pDomainURL;
        }
    }
    
    private static string pBaseURL = null;
    public static string BaseURL {
        get {
            if ( pBaseURL == null){
                pBaseURL = URL.getSalesforceBaseURL().toExternalForm();
            }
            return pBaseURL;
        }
    }

}