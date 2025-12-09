@IsTest
public class ProfileTabModelTest {

    @IsTest
    public static void UnitTest() {
        ProfileTabModelData.createData();
        ProfileTabModelData.refreshProfilePermission();
    
      System.assertNotEquals(null, ProfileTabModel.ProfileTabList);
      System.assert(ProfileTabModel.ProfileTabList.size() > 0);
      
      System.assertNotEquals(null, ProfileTabModel.ProfileTabNameMap);
      System.assert(ProfileTabModel.ProfileTabNameMap.size() > 0);
      
      System.assertNotEquals(null, ProfileTabModel.ProfileTabNameMap.get('Publication Tab'));      
      System.assertNotEquals(null, ProfileTabModel.ProfileTabNameMap.get('FPR Tab'));
      set<string> test = new set<string>();
      list<ProfileTab__c> pt = new list<ProfileTab__c>();
      ProfileTab__c pt1 = new ProfileTab__c();
      Map<string,ProfileTab__c> ptc = new Map<String,ProfileTab__c>();
      ProfileTabModel.PubtileAccessList = test;
      ProfileTabModel.PreparePubtileAccessList();
      ProfileTabModel.ProfileTabList= pt;
      ProfileTabModel.ProfileTabNameMap= ptc ;
      
    }
    
    
}