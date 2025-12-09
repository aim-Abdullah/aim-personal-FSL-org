/* When a contact is inactivated, this trigger calls the class to deactivate user. 
There is a limitation in salesforce where a transaction
cannot occur simultaneously on set up object(User) and non-setup object(Contact).
Therefore a class was created with @future method to do the transaction.
*/
trigger UserDeactivate on Contact (after update) 
{
    List<Contact> ContactDeactivated =  Trigger.new;
    boolean callclass = false;
    
    List<Id> userIdlist = new List<Id>();
    
    //Appear Enhancement - backlog Item R1:2017 Release
    List<Id> conEmailChangedList = new List<Id>();
    boolean callEmailUpdateMethod = false;
    
    for(Contact contactloop : ContactDeactivated)
    {
        Contact oldcon = System.Trigger.oldMap.get(Contactloop.id);
        // Sesha: 09/19/2014 - Revamped the Logic for AMGEN Platform and Community Users. Included changes for External Authors as well.
        // Checking if a user is already associated and the active flag has been unchecked
        // EmploymentStatusCode__c = '3' means that the SAP Contact User is ACTIVE in Amgen
        // EmploymentStatusCode__c = '1' means that the SAP Contact User is on LEAVE OF ABSENCE (LOA) in Amgen
        // EmploymentStatusCode__c = '0' means that the SAP Contact User is no longer with Amgen
        // By default when a Contact is created (Interface/Manual),  Contact.IsActive__c is set to FALSE.
        //          IsActive__c check is for Manually Created Contact (For e.g. Authors/etc)
        if ((contactloop.EmploymentStatusCode__c == '0' || contactloop.EmploymentStatusCode__c == '1') && (contactloop.userid__c != NULL))      //Platform User (Amgen User)
        {
                userIdlist.add(contactloop.userId__c);
                callclass =  true;
        } else if ((oldcon.IsActive__c == false && oldcon.EmploymentStatusCode__c == NULL) 
            && (contactloop.IsActive__c == true && contactloop.EmploymentStatusCode__c == NULL) && (contactloop.userid__c != NULL))     //Community User like Publication Author (External User)
        {
                userIdlist.add(contactloop.id);
                callclass =  true;
        }
        /**
        if ((oldcon.IsActive__c == false && (oldcon.EmploymentStatusCode__c == '3' || oldcon.EmploymentStatusCode__c == '1')) 
            && (contactloop.EmploymentStatusCode__c == '0' || contactloop.EmploymentStatusCode__c == '1') 
            && (contactloop.userid__c != NULL))     //Platform User (Amgen User)
        {
                userIdlist.add(Contactloop.userId__c);
                callclass =  true;
        } else if ((oldcon.IsActive__c == false && oldcon.EmploymentStatusCode__c == '3') && (contactloop.EmploymentStatusCode__c == '0' || contactloop.EmploymentStatusCode__c == '1') 
            && (contactloop.userid__c == NULL))     //Community User like FPR Submitter or Publication Author (Amgen User) 
        {
                userIdlist.add(Contactloop.id);
                callclass =  true;
        } else if ((oldcon.IsActive__c == false && oldcon.EmploymentStatusCode__c == NULL) && (contactloop.IsActive__c == true && contactloop.EmploymentStatusCode__c == NULL) 
            && (contactloop.userid__c == NULL))     //Community User like Publication Author (External User)
        {
                userIdlist.add(Contactloop.id);
                callclass =  true;
        }
        **/
        //Appear Enhancement - backlog Item R1:2017 Release
        if((contactloop.Email != oldcon.Email) && contactloop.UserId__c != null){
        	conEmailChangedList.add(contactloop.Id);
        	callEmailUpdateMethod = true;
        }
    }
    
    
    //Appear Enhancement - backlog Item R1:2017 Release - Update Appear Contact User Email
    if(callEmailUpdateMethod){
    	UpdateContactUserId.UpdateUserEmail(conEmailChangedList);
    }
    
    if (callclass)
    {
        UpdateContactUserId.DeactivateUser(userIdlist);
    }
}