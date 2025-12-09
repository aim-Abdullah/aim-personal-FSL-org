public class MEScopeOfWorkModelData{

    public static void createData() {
    
        integer dataCount = [select count() from MEScopeOfWork__c];
        if ( dataCount <> 0) return;
        
        List<MEScopeOfWork__c> MMEScopeOfWorkModelList = new List<MEScopeOfWork__c>();
        
        MMEScopeOfWorkModelList.add( new MEScopeOfWork__c(name= 'Encore',Scaling_Factor__c=0.5));
        MMEScopeOfWorkModelList.add( new MEScopeOfWork__c(name= 'Editing/Formatting',Scaling_Factor__c=0.5));
        MMEScopeOfWorkModelList.add( new MEScopeOfWork__c(name= 'Writing',Scaling_Factor__c=1));
        MMEScopeOfWorkModelList.add( new MEScopeOfWork__c(name= 'Not Available',Scaling_Factor__c=1));  
        
        insert MMEScopeOfWorkModelList;
      
		MEScopeOfWorkModel.resetCache();          
     }
    
}