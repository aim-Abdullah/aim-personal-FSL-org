@IsTest
public class AppearRoleModelTest {

    @IsTest
    public static void DataUnitTest() {
                
        RecordType pubTeamRoleRecType = RecordTypeModel.LookupRecordType('Appear_Role__c','PubTeamRole');
        RecordType reviewTeamRoleRecType = RecordTypeModel.LookupRecordType('Appear_Role__c','ReviewTeamRole');
        
        System.assertNotEquals(null, pubTeamRoleRecType);
        System.assertNotEquals(null, reviewTeamRoleRecType);
        
        AppearRoleModelData.createData();
        
        System.assertNotEquals(null, AppearRoleModel.AppearRoleList);
        AppearRoleModelData.deleteData();
    }

    @IsTest
    public static void UnitTest() {
        System.assertEquals(null, AppearRoleModel.WritingCoordinatorRoleId);
        AppearRoleModelData.createData();
        
        System.assertNotEquals(null, AppearRoleModel.AppearRoleList);   
        System.assertNotEquals(null, AppearRoleModel.AppearRoleMap);    
        System.assertNotEquals(null, AppearRoleModel.AppearRoleMapByName);  
        System.assertNotEquals(null, AppearRoleModel.WritingRoleSet);   
        
        System.assert(AppearRoleModel.WritingRoleSet.size() >= 3,  AppearRoleModel.WritingRoleSet.size());
        
        AppearRoleModelData.createData();
        
        Id wcId = AppearRoleModel.WritingCoordinatorRoleId;
        System.assertNotEquals(null, wcId);
        
        System.assert(AppearRoleModel.isWritingCoordinatorRole(wcId));
        
        // CR 247 03/19/2014 System.assertNotEquals(null, AppearRoleModel.ValidAppearRoles);

    }

}