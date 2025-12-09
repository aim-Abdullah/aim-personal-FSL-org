public with sharing class UserSearchController {
 //9-4-13: Controller used to search for the user with first name or last name or email and return results in a separate part of the screen
 //allows the VF Page called AppearUserAdmin to display the results and edit certain values.
 
  private String soql {get;set;}
  
  private List<User> pUsers = null;
  public List<User> Users {
    get{
        parseURL();
        runQuery();
        return Users;
    }
    set;
  }
 
  // Default the current sort to ascending
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'lastName'; } return sortField;  }
    set;
  }
  
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }
 
  // init the controller and display some sample data when the page loads
  public UserSearchController() {
    //soql = 'select firstname, lastname, email, alias, username, isActive, FederationIdentifier, userroleid, profileid from User where username != null';
  }
 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
 
  public void parseURL() {
    String firstName = Apexpages.currentPage().getParameters().get('firstname');
    String lastName = Apexpages.currentPage().getParameters().get('lastname');
    String email = Apexpages.currentPage().getParameters().get('email');
    String alias = Apexpages.currentPage().getParameters().get('alias');
    String username = Apexpages.currentPage().getParameters().get('username');
    String isactive = Apexpages.currentPage().getParameters().get('isactive');
    String userRoleID = Apexpages.currentPage().getParameters().get('userRoleID');
    String profileID = Apexpages.currentPage().getParameters().get('profileID');
    String federationidentifier = Apexpages.currentPage().getParameters().get('federationidentifier');
    
    soql = 'select firstname, lastname, email, alias, username, isActive, IsPortalEnabled, FederationIdentifier, userRoleId, ProfileId, Delegate_Admin_Federation_ID__c, Delegate_Admin_Profile__c from User where Profile.name <> \''
        +ProfileModel.SystemAdmin+'\'';
    

    if (firstName <> null && !firstName.equals(''))
      soql += ' and firstname LIKE \''+String.escapeSingleQuotes(firstName)+'%\'';
    if (lastName <> null && !lastName.equals(''))
      soql += ' and lastname LIKE \''+String.escapeSingleQuotes(lastName)+'%\'';
    if (email <> null && !email.equals(''))
      soql += ' and email LIKE \''+String.escapeSingleQuotes(email)+'%\'';  
    if (username <> null && !username.equals(''))
      soql += ' and username LIKE \''+String.escapeSingleQuotes(username)+'%\'';  
    if (alias <> null && !alias.equals(''))
      soql += ' and alias LIKE \''+String.escapeSingleQuotes(alias)+'%\'';  
    if (userRoleID <> null && !userRoleID.equals(''))
      soql += ' and userRoleID LIKE \''+String.escapeSingleQuotes(userRoleID)+'%\''; 
    if (userRoleID <> null && !userRoleID.equals(''))
      soql += ' and profileID LIKE \''+String.escapeSingleQuotes(profileID)+'%\''; 
    if (profileID <> null && !profileID.equals(''))
      soql += ' and federationidentifier LIKE \''+String.escapeSingleQuotes(federationidentifier)+'%\'';        
  }
  
  // runs the actual query
  public void runQuery() {
 
    string soqlFinal = soql + ' order by ' + sortField + ' ' + sortDir + ' limit 10';
    //AppLogModel.LogInfo('UserSearchController::runQuery', soqlFinal);
    try {
      pUsers = Database.query(soqlFinal);
      Users = pUsers;
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! '+e.getMessage() + ' '+ soqlFinal));
    }
    //AppLogModel.flushLogs();
  }
 
    public string firstName{get;set;}
    public string lastName{get;set;}
    public string email{get;set;}
    public string alias{get;set;}
    public string username{get;set;}
    public string userRoleID{get;set;}
    public string profileID{get;set;}
    public string federationidentifier{get;set;}
  // runSearch will redirect to the AppearUserAdmin page with search parameter
  public PageReference runSearch() {
 
    PageReference pageRef = ApexPages.currentPage();
    
    if (firstName <> null) {
        pageRef.getParameters().put('firstname',firstName);
    }
    if (lastName <> null) {
        pageRef.getParameters().put('lastname',lastName);
    }
    if (email <> null) {
        pageRef.getParameters().put('email',email);
    }
    if (alias <> null) {
        pageRef.getParameters().put('alias',alias);
    }
    if (username <> null) {
        pageRef.getParameters().put('username',username);
    }
    if (userRoleID <> null) {
        pageRef.getParameters().put('userRoleID',userRoleID);
    }
    if (profileID <> null) {
        pageRef.getParameters().put('profileID',profileID);
    }
    if (federationidentifier <> null) {
        pageRef.getParameters().put('federationidentifier',federationidentifier);
    }
      
    return pageRef;
  }
 
    public PageReference saveChanges() {
        id sysAdminProfileId = ProfileModel.ProfileNameMap.get(ProfileModel.SystemAdmin).id; 
        
        for(user u : pUsers) {
            if (u.Delegate_Admin_Federation_ID__c <> null ) {
				u.FederationIdentifier = u.Delegate_Admin_Federation_ID__c;
				u.Delegate_Admin_Federation_ID__c = null;
            }
            
            //user.ProfileID
            
            if (u.Delegate_Admin_Profile__c <> null) {
            	Profile newProfile = ProfileModel.ProfileNameMap.get(u.Delegate_Admin_Profile__c);
            	if ( newProfile <> null) {
            		u.ProfileID = newProfile.id;
            		u.Delegate_Admin_Profile__c = null;
            	}
            }
        }
        update pUsers;
        return null; 
    }
  
 
}