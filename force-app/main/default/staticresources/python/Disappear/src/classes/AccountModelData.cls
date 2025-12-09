public  class AccountModelData {

	public static Account AmgenAccount {
		get {
			return AccountModel.AccountNameMap.get('AMGEN');
		}
	}

    public static void createData() {
    
         Integer dataCount = [select count() from Account];
         If ( dataCount <> 0) return;
        
         List<Account> AccountList = new List<Account>();   
         AccountList.add( new Account(name= 'AMGEN'));

     
         Insert AccountList;
                
     }
    
}