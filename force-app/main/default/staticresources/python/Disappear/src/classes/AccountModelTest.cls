@IsTest
public class AccountModelTest {

    @IsTest
    public static void UnitTest() {
        AccountModelData.createData();
    
      System.assertNotEquals(null, AccountModel.AccountList);
      System.assert(AccountModel.AccountList.size() > 0);
      
      System.assertNotEquals(null, AccountModel.AccountNameMap);
      System.assert(AccountModel.AccountNameMap.size() > 0);
      
      
      System.assertNotEquals(null, AccountModel.AccountNameMap.get('AMGEN'));
      System.assertNotEquals(null, AccountModelData.AmgenAccount);
    }
    
    
}