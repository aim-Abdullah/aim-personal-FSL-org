@IsTest
public class UserRoleModelTest {

    @IsTest
    public static void UnitTest() {
        System.assertNotEquals(null, UserRoleModel.CurrentRoleName);
        System.assertNotEquals(null, UserRoleModel.UserRoleList);
        System.assertNotEquals(null, UserRoleModel.UserRoleMap);
        System.assertNotEquals(null, UserRoleModel.UserRoleByDevNameMap);
        System.assertNotEquals(null, UserRoleModel.FPR_Only_SubmitterRoleId); 
        id Id1 ;
        String rn;
        map<id,Userrole> m1 = new Map<id,Userrole>();
        map<String,Userrole> m2 = new Map<String,Userrole>();
        list<userrole> ur = new list<userrole>();
        UserRoleModel.FPR_Only_SubmitterRoleId = Id1 ; 
        UserRoleModel.CurrentRoleName = rn ;
        UserRoleModel.UserRoleMap = m1 ;
        UserRoleModel.UserRoleList = ur ;
        UserRoleModel.UserRoleByDevNameMap = m2 ;
    }

}