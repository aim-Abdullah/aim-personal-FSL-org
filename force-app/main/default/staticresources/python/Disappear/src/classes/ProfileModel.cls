public class ProfileModel {

    public static final string AppearPubTeam = 'APPEAR Pub Team';
    public static final string AppearGPPL = 'APPEAR GPPL';
    public static final string AppearWriting = 'APPEAR Writing';
    public static final string AppearReviewers = 'APPEAR Reviewers';
    public static final string AppearFprOnlySubmitter = 'APPEAR FPR Only Submitter';
    public static final string AppearBusinessAdmin = 'APPEAR Business Admin';
    public static final string AppearFPRC = 'APPEAR FPRC';
    public static final string AppearIntFPRC = 'APPEAR International FPRC'; 
    public static final string SystemAdmin = 'System Administrator';
    public static final string Appear626 = 'APPEAR 626';
    public static final string AppearHyperCare = 'Appear HC';
    public static final string AppearPortalFprOnlySubmitter = 'APPEAR Portal FPR Only Submitter';
    public static final string AppearPortalPubAuthor = 'Appear Portal Pub Author Login';
    //Added for Appear Enhancement Release 1
    public static final string AppearExternalWriter = 'APPEAR External Writer';
    public static final string AppearFunctionalPubTeam = 'APPEAR Functional Pub Team';
    
    //DEFECT 475 Adding new profile for read-only users like Compliance, Legal, and APPEAR Sponsors
    public static final string AppearReadOnly = 'APPEAR Read-Only';

    public static boolean isAppearHyperCare{
        get {
            boolean result = CurrentProfileName == AppearHyperCare;
            
            AppLogModel.LogDebug('ProfileModel::isAppearHyperCare', 'User : ' +userinfo.getUserName() +'   '+ result);
            return result;
        }
    }
    
    public static boolean isAppearPortalPubAuthor{
        get {
            return CurrentProfileName == AppearPortalPubAuthor;
        }
    }

    public static boolean isAppear626{
        get {
            return CurrentProfileName == Appear626;
        }
    }
    
    public static boolean isAppearPubTeam{
        get {
            return CurrentProfileName == AppearPubTeam;
        }
    }
    public static boolean isAppearFPRC{
        get {
            return CurrentProfileName == AppearFPRC;
        }
    }
    public static boolean isAppearIntFPRC{
        get {
            return CurrentProfileName == AppearIntFPRC;
        }
    }
    public static boolean isAppearGPPL{
        get {
            return CurrentProfileName == AppearGPPL;
        }
    }
    public static boolean isAppearWriting{
        get {
            return CurrentProfileName == AppearWriting;
        }
    }
    public static boolean isAppearReviewers{
        get {
            return CurrentProfileName == AppearReviewers;
        }
    }
    public static boolean isAppearFprOnlySubmitter{
        get {
            return CurrentProfileName == AppearFprOnlySubmitter || CurrentProfileName == AppearPortalFprOnlySubmitter;
        }
    }
    public static boolean isAppearBusinessAdmin{
        get {
            return CurrentProfileName == AppearBusinessAdmin;
        }
    }
    public static boolean isAppearReadOnly{
        get {
            return CurrentProfileName == AppearReadOnly;
        }
    }
    public static boolean isSysAdmin{
        get {
            return CurrentProfileName == SystemAdmin;
        }
    }
    // Added for Appear Enhancement Release 1
    public static boolean isAppearExternalWriter{
        get {
            return CurrentProfileName == AppearExternalWriter;
        }
    }
    public static boolean isAppearFunctionalPubTeam {
        get {
            return CurrentProfileName == AppearFunctionalPubTeam;
        }
    }
    
    ///////////////////

    public static boolean ModifyFPRCPubList{
        get {
            if ( CurrentProfileName == AppearBusinessAdmin) return true;
            if ( CurrentProfileName == SystemAdmin) return true;
            if ( CurrentProfileName == AppearFPRC) return true;
            if ( CurrentProfileName == AppearIntFPRC) return true;
            
            return false;
        }
    }
        
    public static boolean showFPRCPubList{
        get {
            if ( CurrentProfileName == AppearBusinessAdmin) return true;
            if ( CurrentProfileName == SystemAdmin) return true;
            if ( CurrentProfileName == AppearFPRC) return true;
            if ( CurrentProfileName == AppearIntFPRC) return true;
            
            return false;
        }
    }
    
    public static boolean allowReviewTeamEdit{
        get{
            if (CurrentProfileName == AppearGPPL) return false;
            if (CurrentProfileName == AppearWriting) return false;
             if (CurrentProfileName == AppearExternalWriter ) return false; // Appear Enhancement Release 1, Restricted in FPR status
            if (CurrentProfileName == Appear626) return false;
            if (CurrentProfileName == AppearPubTeam) return false;
            
            return true;
        }
    }
    
    
    private static string pCurrentProfileId = null;
    public static string CurrentProfileId {
        get {
            if (pCurrentProfileId == null){
                pCurrentProfileId = UserInfo.getProfileId();
            }
            return pCurrentProfileId;
        }
    }
    
    
    private static string pCurrentProfileName = null;
    public static string CurrentProfileName {
        get {
             if (pCurrentProfileName == null) {
                for(Profile p : [
                    select Name 
                    from Profile 
                    where id = :CurrentProfileId
                ]) {                    
                    pCurrentProfileName = p.Name;
                    break;
                }
             }
             return pCurrentProfileName;
        }
    }

    private static Map<Id,Profile> pProfileMap = null;
    public static Map<Id,Profile> ProfileMap {
        get {
            if ( pProfileMap == null) {
                pProfileMap = new Map<Id,Profile>();
                for(Profile p : ProfileList) {
                    pProfileMap.put(p.Id,p);
                }
            }
            return pProfileMap;
        }
    }
    
    private static Map<string,Profile> pProfileNameMap = null;
    public static Map<string,Profile> ProfileNameMap {
        get {
            if ( pProfileNameMap == null) {
                pProfileNameMap = new Map<string,Profile>();
                for(Profile p : ProfileList) {
                    pProfileNameMap.put(p.name,p);
                }
            }
            return pProfileNameMap;
        }
    }
    
    private static List<Profile> pProfileList = null;
    public static List<Profile> ProfileList {
        get {
            if (pProfileList == null) {
                pProfileList = [select id, name from Profile];
            }
            return pProfileList;
        }
    }
    
    private static Profile pAppearFprOnlySubmitterProfile = null;
    public static Profile AppearFprOnlySubmitterProfile {
        get {
            if ( pAppearFprOnlySubmitterProfile == null) {
                pAppearFprOnlySubmitterProfile = ProfileNameMap.get(AppearFprOnlySubmitter);
            }
            return pAppearFprOnlySubmitterProfile;
        }
    }
    
    private static Profile pAppearPortalFprOnlySubmitterProfile = null;
    public static Profile AppearPortalFprOnlySubmitterProfile {
        get {
            if ( pAppearPortalFprOnlySubmitterProfile == null) {
                pAppearPortalFprOnlySubmitterProfile = ProfileNameMap.get(AppearPortalFprOnlySubmitter);
            }
            return pAppearPortalFprOnlySubmitterProfile;
        }
    }   
    
    private static Profile pAppearPubTeamProfile = null;
    public static Profile AppearPubTeamProfile {
        get {
            if ( pAppearPubTeamProfile == null) {
                pAppearPubTeamProfile = ProfileNameMap.get(AppearPubTeam);
            }
            return pAppearPubTeamProfile;
        }
    }  
    
    private static Profile pAppearReviewersProfile = null;
    public static Profile AppearReviewersProfile {
        get {
            if ( pAppearReviewersProfile == null) {
                pAppearReviewersProfile = ProfileNameMap.get(AppearReviewers);
            }
            return pAppearReviewersProfile;
        }
    }   
}