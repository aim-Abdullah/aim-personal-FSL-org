public  class ProfileTabTileModelData {

    public static void createData() {
    
        integer dataCount = [select count() from ProfileTabTile__c];
        if ( dataCount <> 0) return;
        
        List<ProfileTabTile__c> ProfileTabTileList = new List<ProfileTabTile__c>();
        
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Details',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=True,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=True,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Studies/Projects',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=True,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=True,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Scientific Statements',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=True,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Publication Team',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=True,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Attachments',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=True,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=True,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Writing Roles',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=True,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Statuses',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=True,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Pre-FPR Reviewers',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=False,APPEAR_GPPL__c=False,APPEAR_Writing__c=False,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=True,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Reviewer Activity',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=True,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=True,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Authors',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=True,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=True,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Related Pubs',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=True,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Publications Queue',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=False,APPEAR_GPPL__c=False,APPEAR_Writing__c=False,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Transfer of Value',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('Publication Tab').Id,
             APPEAR_Pub_Team__c=False,APPEAR_GPPL__c=False,APPEAR_Writing__c=False,APPEAR_Reviewers__c=False,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));                 

         ProfileTabTileList.add( new ProfileTabTile__c(Name='Pub Details',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('FPR Tab').Id,
             APPEAR_Pub_Team__c=False,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=True,APPEAR_FPR_Only_Submitters__c=True,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name=AppearConstants.FprOtherDetailsTile,Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('FPR Tab').Id,
             APPEAR_Pub_Team__c=False,APPEAR_GPPL__c=False,APPEAR_Writing__c=False,APPEAR_Reviewers__c=True,APPEAR_FPR_Only_Submitters__c=True,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Publication Content',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('FPR Tab').Id,
             APPEAR_Pub_Team__c=False,APPEAR_GPPL__c=True,APPEAR_Writing__c=True,APPEAR_Reviewers__c=True,APPEAR_FPR_Only_Submitters__c=True,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Publications For Review',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('FPR Tab').Id,
             APPEAR_Pub_Team__c=False,APPEAR_GPPL__c=False,APPEAR_Writing__c=False,APPEAR_Reviewers__c=True,APPEAR_FPR_Only_Submitters__c=False,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));         
         ProfileTabTileList.add( new ProfileTabTile__c(Name='Pre-FPR Reviewers',Profile_Tab__c=ProfileTabModel.ProfileTabNameMap.get('FPR Tab').Id,
             APPEAR_Pub_Team__c=False,APPEAR_GPPL__c=False,APPEAR_Writing__c=False,APPEAR_Reviewers__c=True,APPEAR_FPR_Only_Submitters__c=True,
             APPEAR_626__c=False,APPEAR_FPRC__c=True,APPEAR_International_FPRC__c=True,APPEAR_Business_Admin__c=True,System_Admin__c=True));                 

               
        insert ProfileTabTileList;
                
     }
    
}