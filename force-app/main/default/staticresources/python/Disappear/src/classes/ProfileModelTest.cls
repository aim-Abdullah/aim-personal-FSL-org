@IsTest
public class ProfileModelTest {

    @IsTest 
    public static void UnitTest() {
        System.assertNotEquals(0,ProfileModel.ProfileList.size());
        System.assertNotEquals(null,ProfileModel.CurrentProfileId);
        System.assertNotEquals(null,ProfileModel.CurrentProfileName);
        
        System.assertEquals(false, ProfileModel.isAppear626);
        System.assertEquals(false, ProfileModel.isAppearPubTeam);
        System.assertEquals(false, ProfileModel.isAppearFPRC);
        System.assertEquals(false, ProfileModel.isAppearIntFPRC);
        System.assertEquals(false, ProfileModel.isAppearGPPL);
        System.assertEquals(false, ProfileModel.isAppearWriting);
        System.assertEquals(false, ProfileModel.isAppearReviewers);
        System.assertEquals(false, ProfileModel.isAppearFprOnlySubmitter);
        System.assertEquals(false, ProfileModel.isAppearBusinessAdmin);
        System.assertEquals(false, ProfileModel.isAppearReadOnly);
        System.assertEquals(false, ProfileModel.isAppearHyperCare);
        System.assertEquals(false, ProfileModel.isAppearExternalWriter);// Added the new profile
        System.assertEquals(false, ProfileModel.isAppearFunctionalPubTeam);// Added the new profile
        Boolean Temp2; 
        String s1;
        ProfileModel.isAppearHyperCare= temp2;
        ProfileModel.isAppear626= temp2;
        ProfileModel.isAppearPubTeam= temp2;
        ProfileModel.isAppearFPRC= temp2;
        ProfileModel.isAppearIntFPRC= temp2;
        ProfileModel.isAppearGPPL= temp2;
        ProfileModel.isAppearWriting= temp2;
        ProfileModel.isAppearExternalWriter= temp2; // added the new profile
        ProfileModel.isAppearFunctionalPubTeam= temp2; //  added the new profile
        ProfileModel.isAppearReviewers= temp2;
        ProfileModel.isAppearFprOnlySubmitter= temp2;
        ProfileModel.isAppearBusinessAdmin= temp2;
        ProfileModel.isAppearReadOnly= temp2;
        ProfileModel.isSysAdmin= temp2;
        ProfileModel.ModifyFPRCPubList= temp2;
        ProfileModel.ShowFPRCPubList= temp2;
        ProfileModel.AllowReviewTeamEdit= temp2;
        ProfileModel.CurrentProfileId= s1;
        ProfileModel.CurrentProfileName= s1;
        Map<String,Profile> MapProf = New Map<String,Profile>();
        ProfileModel.ProfileNameMap = MapProf;
        List<Profile> Proflist = New List<Profile>();
        ProfileModel.ProfileList= ProfList;
        
        boolean temp = ProfileModel.isSysAdmin;
        temp = ProfileModel.ModifyFPRCPubList;
        temp = ProfileModel.showFPRCPubList;
        temp = ProfileModel.allowReviewTeamEdit;
        temp = ProfileModel.ModifyFPRCPubList;
        temp = ProfileModel.ModifyFPRCPubList;
        temp = ProfileModel.ModifyFPRCPubList;
        temp = ProfileModel.IsAppearHyperCare;
       
        
        
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.AppearPubTeam));
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.AppearGPPL));
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.AppearExternalWriter));// added the new profile
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.AppearFunctionalPubTeam));// added the new profile
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.AppearWriting));
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.AppearReviewers));
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.AppearFprOnlySubmitter));
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.AppearPortalFprOnlySubmitter));
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.AppearBusinessAdmin));
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.AppearFPRC));
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.AppearIntFPRC));
        System.Assert(ProfileModel.ProfileNameMap.containsKey(ProfileModel.SystemAdmin));
        
        System.assertNotEquals(null, ProfileModel.AppearPortalFprOnlySubmitterProfile);
        System.assertNotEquals(null, ProfileModel.AppearFprOnlySubmitterProfile);
        System.assertNotEquals(null, ProfileModel.ProfileMap);
        System.assertNotEquals(null, ProfileModel.AppearPubTeamProfile );
    }
}