public class AccountModel {
    
    private static List<Account> pAccountList = null;
    public static List<Account> AccountList{
        get{
            if(pAccountList == null){
              pAccountList = getAllAccountList();
            }               
        return pAccountList;
        }
    }  
    
   private static Map<String, Account> pAccountNameMap = null;
   public static Map<String, Account> AccountNameMap{
     get {
       if (pAccountNameMap == null){
         pAccountNameMap = getAccountMapByName();
       }
       return pAccountNameMap;
     }
   }
   
   public static Map<String, Account> getAccountMapByName() {
    Map<String, Account> result = new Map<String, Account>();
    for(Account pAccount : AccountList){
      result.put(pAccount.Name, pAccount);
    }

    return result;
  }
      
    public static List<Account> getAllAccountList(){
        List<Account> result = [
          select id, Name
          From Account
          order by Name  
           ];
        return result;
    }


}