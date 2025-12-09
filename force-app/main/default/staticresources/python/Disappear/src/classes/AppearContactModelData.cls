public class AppearContactModelData extends AppearBaseData {

    public static void createData() {
    
        integer dataCount = [select count() from Contact];
        if ( dataCount <> 0) return;
        
        List<Contact> ContactList = new List<Contact>();
        
        ContactList.add( new Contact(LastName= 'Dorner', FirstName='Michael', Country__c='United States', 
        	AccountId=AccountModelData.AmgenAccount.Id, 
            SponsoringDept__c=DepartmentModelData.GlobalHealthEconomicDept.Id,
            Emp_Type__c = 'Staff',
            Email='mike@amgen.com'));
        ContactList.add( new Contact(LastName= 'Weiss', FirstName='Solange', 
        	AccountId=AccountModelData.AmgenAccount.Id, 
            SponsoringDept__c=DepartmentModelData.GlobalMedicalWritingDept.Id,
            Emp_Type__c = 'Staff',
            Department='Global Medical Writing'));
        ContactList.add( new Contact(LastName= 'Maxwell', FirstName='Michelle', 
        	AccountId=AccountModelData.AmgenAccount.Id, 
            SponsoringDept__c=DepartmentModelData.GlobalMedicalWritingDept.Id,
            Emp_Type__c = 'Contigent',
            Department='Global Medical Writing'));
        ContactList.add( new Contact(LastName= 'Seal', FirstName='Melissa', 
        	AccountId=AccountModelData.AmgenAccount.Id, 
            SponsoringDept__c=DepartmentModelData.MedicalCommunicationsDept.Id,
            Emp_Type__c = 'Staff',
            Department='A new department'));
        ContactList.add( new Contact(LastName= 'Mahon', FirstName='Kelly', 
        	AccountId=AccountModelData.AmgenAccount.Id,
        	Emp_Type__c = 'Temp', 
            SponsoringDept__c=DepartmentModelData.MedicalCommunicationsDept.Id));
        
        insert ContactList;
                
     }
    
}