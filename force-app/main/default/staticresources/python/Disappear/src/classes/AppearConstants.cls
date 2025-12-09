public class AppearConstants {
/////////////////////////////////////////////////////////
// Url Parameter
    
    public static final string SUBMENU = 'submenu';
    public static final string TILE = 'tile';
    public static final string PUBID = 'id';
    public static final string PUBAUTHORID = 'PubAuthorId';
    
//////////////////////////////////////////////////////////////////
// SubMenu names   

    //Search
    public final static string SearchSubMenuSuggestions = 'Suggestions';
    public final static string SearchSubMenuFprRequests = 'FPR_Request';
    public final static string SearchSubMenuPublications = 'Publications';
    public final static string SearchSubMenuContacts = 'Contacts';
    public final static string SearchSubMenuUsers = 'Users';
    
    //FprRequest
    public final static string FprRequestSubMenuNew = 'New_FPR_Request';
    public final static string FprRequestSubMenuMy = 'My_FPR_Requests';
    public final static string FprRequestSubMenuLatest = 'Latest_FPR_Requests';
    public final static string FprRequestSubMenuView = 'View_FPR_Request';
    public final static string FprRequestSubMenuEdit = 'Edit_FPR_Request';
    
    //Pub - SubMenu == chevron
    //public final static string PubSubMenuNewSuggestion = 'Create New Suggestion';
    //public final static string PubSubMenuNewConcept = 'Create New Concept';
    
    public final static string PubSubMenuSuggest = 'Suggest';
    public final static string PubSubMenuPlan = 'Plan';
    public final static string PubSubMenuExecute = 'Execute';
    public final static string PubSubMenuReview = 'Review'; 
    public final static string PubSubMenuSubmit = 'Submit'; 
    public final static string PubSubMenuFprOnly = 'FPR Only'; // dont show chevron for FPR Only
        
//////////////////////////////////////////////////////////////////
// tile names

    //search tile names
    public final static string SearchFilterTile = 'Filter';
    public final static string SearchRecentTile = 'Recent';
    public final static string SearchMyFavTile = 'My_Fav';
    public final static string SearchMyTeamTile = 'My_Team';
    public final static string SearchMyDeptTile = 'My_Dept';
    
    //publication tile names
    public final static string PubDetailsTile = 'Details';
    public final static string PubStudiesTile = 'Studies/Projects';    
    public final static string PubStatementsTile = 'Scientific Statements';    
    public final static string PubTeamTile = 'Publication Team';
    public final static string PubAttachmentsTile = 'Attachments';
    public final static string PubRolesTile = 'Writing Roles';
    public final static string PubStatusTile = 'Statuses';
    public final static string PubPreFPRReviewersTile = 'Pre-FPR Reviewers';
    public final static string PubReviewersTile = 'Reviewer Activity';
    public final static string PubAuthors = 'Authors';  
    public final static string PubRelatedTile = 'Related Pubs';
    public final static string PubEventsTile = 'Events';
    public final static string PubActionTile = 'Action';
    public final static string PubFprcQueue = 'Publications Queue';
    public final static string PubTOVTile = 'Transfer of Value';

    //fpr tile names
    public final static string FprDetailsTile = 'Pub Details';
    public final static string FprOtherDetailsTile = 'Reviewer Activity';
    public final static string FprAttachmentsTile = 'Publication Content';
    public final static string FprPreFprTile = 'Pre-FPR Reviewers';
    public final static string FprPubsForReviewTile = 'Publications For Review';
    
    //fpr submitter tile names
    public final static string FprOnlyNewPub = 'New FPR Request';
    public final static string FprMyRequests = 'My FPR Requests';
    
    // Release 4 - Author tile names
    public final static string AuthorMyPubTile = 'My Publications';
    public final static string AuthorPubDetailsTile = 'Pub Details';
    public final static string AuthorActivityTile = 'Author Activity';
    public final static string AuthorPubContentTile = 'Publication Content';
   
    
    public static void SupportUnitTest() {
		System.Debug(AppearConstants.SUBMENU);
		System.Debug(AppearConstants.TILE);
		System.Debug(AppearConstants.PUBID);
		System.Debug(AppearConstants.SearchSubMenuSuggestions);
		System.Debug(AppearConstants.SearchSubMenuFprRequests);
		System.Debug(AppearConstants.SearchSubMenuPublications);
		System.Debug(AppearConstants.SearchSubMenuContacts);
		System.Debug(AppearConstants.SearchSubMenuUsers);    	
    }
        
}