/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
global without sharing class CommunitiesSelfRegController {

    private string pfirstName = null;
    public string firstName{
        get {
            if (pfirstName == null){
                pfirstName = '';
            } 
            return pfirstName;
        }
        set { 
            pfirstName = value;
        }   
    }

    private string plastName = null;
    public string lastName{
        get {
            if (plastName == null){
                plastName = '';
            } 
            return plastName;
        }
        set { 
            plastName = value;
        }   
    }
    private string pEmail = null;
    public string Email{
        get {
            if (pEmail == null){
                pEmail = '';
            } 
            return pEmail;
        }
        set { 
            pEmail = value;
        }   
    }

    public String userId {get; set {userId = value == null ? value : value.trim(); } }
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public String createdUserId{get ; set;} // for debug

    private string pPubId = null;
    //Appear Enhancement R2, publicationId & conId variables are added which captures the page parameters from the URL
    public String publicationId{get ; set;} 
    public String conId{get ; set;} 
	
    public string pubId{
        get {
            if (pPubId == null){
                pPubId = '';
            } 
            return pPubId;
        }
        set { 
            pPubId = value;
        }   
    }

    private string pContactId = null;
    public string contactId{
        get {
            if (pContactId == null){
                pContactId = '';
            } 
            return pContactId;
        }
        set { 
            pContactId = value;
        }   
    }
    
    
    @RemoteAction
    global static Contact getContactInfo(String contactId) {
        Contact result = [SELECT Id, Name, FirstName, LastName, Phone, Email, MailingCity, MailingStreet, MailingState, MailingCountry, MailingPostalCode 
                   FROM Contact WHERE id = :contactId];
        return result;
    }

    //Appear Enhancement R2, CommunitiesSelfRegController is updated with the below two lines of code.
    public CommunitiesSelfRegController() {
    	publicationId = apexpages.currentpage().getparameters().get('Id');
    	conId = apexpages.currentpage().getparameters().get('ContactId');     
    }

    
    private boolean isPasswordMatched() {
        return password == confirmPassword;
    }

    private boolean isValidPassword() {
        // IY: to do - enhance password validation 
        boolean iResult = true;
        if (password == null || confirmPassword == null) return false;
        if (password.length() < 8 || confirmPassword.length() < 8  ){
            return false; 
        }
        return iResult; 
    }

    private boolean isValidUserId() {
        boolean iResult = true;
        if (userId == null || userId.length() < 8   ){
            return false; 
        } else if (!userId.contains('@')){
            return false;
        }
        return iResult; 
    }

    private boolean isDuplicatedUserId() {
        boolean iResult = false; 
        integer numUsers = [select count() from user where Username = :userId]; 
        if (numUsers > 0 ) iResult = true;
        return iResult; 
    }    
    
    //Appear Enhancement R2, checking valid contact or not
    public boolean isValidContactId(){
        return (conId == '' ? false: true); 
    }

    

    public PageReference registerUser() {
        
    
        // validation 
        if (!isPasswordMatched()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        } else if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Password');
            ApexPages.addMessage(msg);
            return null;
        } else if (!isValidUserId()){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid User Id format used. Please use "abc@abc.com" format.');
            ApexPages.addMessage(msg);
            return null;
        } else if (isDuplicatedUserId()){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,  'Sorry, it appears that there is already a registered user with "'+userId+'" account. If you have forgotten your password then please click on the "Forgot your password" link on the login page OR reach out to your Amgen contact.');
            ApexPages.addMessage(msg);
            return null;            
        } else if (!isValidContactId()){
            // in theory, the missing contact id shoudl have been deteced in ui
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Missing Contact Id');
            ApexPages.addMessage(msg);
            return null;     
        }
        //Appear Enhancement R2. The following line has been changed from ContactId to conId  
        else if (AppearContactModel.findUserIdForContactId(conId) != null ) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, it appears that there is an existing user with the same contact information. If you have forgotten your password then please click on the "Forgot your password" link on the login page OR reach out to your Amgen contact.');
            ApexPages.addMessage(msg);          
            return null;            
        }
                
        Profile p  = null; 
        String roleEnum = null; // To be filled in by customer.
        Account a = null; 
                
        try {
            p = [Select Id from Profile where name =: ProfileModel.AppearPortalPubAuthor limit 1 ]; 
        } catch (Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry we cannot identify a matching user profile at this time. Please contact Amgen\'s administrator');
            ApexPages.addMessage(msg);                      
           return null;                     
        }
        try {
             a = [Select Id from Account where name like '%AMGEN%' or name like '%amgen%' or name like '%Amgen%' limit 1 ];
        } catch (Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry we cannot identify a matching user account at this time. Please contact Amgen\'s administrator');
            ApexPages.addMessage(msg);              
            return null;                    
        }


        String accountId = a.id; // To be filled in by customer.
        User u = new User();
        u.Username = userId;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CommunityNickname = userId;
        u.ProfileId = p.Id;
        u.ContactId = conId; //Appear Enhancement R2
        
        String sCreatedUserId = Site.createPortalUser(u, accountId, password);
      
        if (sCreatedUserId != null) { 
            System.debug(System.LoggingLevel.DEBUG, '## DEBUG: User creation successful and password ok - returning site.login; user id: ' + createdUserId);
            createdUserId = sCreatedUserId;
            // redirect back to detailed page, which in turn will ask the user to login
            /*
            Appear Enhancement R2, the pubId has been changed to publicationId. Also the &activeopr=update has been removed
            so that the new user is redirected to the invitation tab. And publication id has been chaged to publicationId.
			*/
            return Site.login(userId, password, '/apex/appearpubauthordashboard?Id='+publicationId+'&sfdc.tabName=01ri00000004OaA&submenu=Plan&tile=Pub%20Details');   
        } else {

            System.debug(System.LoggingLevel.DEBUG, '## DEBUG: User creation failed');          
        
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, your user account cannot be created at this time. Please contact Amgen\'s administrator');
            ApexPages.addMessage(msg);          
            return null;            

 

        }
        return null;
    }
}