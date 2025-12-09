/*ContactIdentifierTriggerLogic class is getting called from Contact_Identifier Trigger to check the 
Has Active US license flag in contact depending on associated Contact Identifiers*/
public with sharing class ContactIdentifierTriggerLogic {
    
    public static void contactIdentifierAfterInsertTriggerLogic(List<Author_Identity__c> contactidentifier){
            
            set<Id> contactIdSetToTrue = new set<Id>();
            List<Contact> contactListUpdatetoTrue = new List<Contact>();
                                    
            for(Author_Identity__c cI:contactidentifier)
            {
                 if(cI.Identity_Type__c == 'National Provider Identifier (NPI)'&& cI.Identity_Number__c != null)
                 {
                    contactIdSetToTrue.add(cI.Author_Contact__c);
                    
                 }
            }
            for(Id conId:contactIdSetToTrue)
            {
                Contact conToUpdate = new Contact(Id=conId,Has_Active_US_license__c=true);
                contactListUpdatetoTrue.add(conToUpdate);
            }
            system.debug('####contactListUpdatetoTrue-->'+contactListUpdatetoTrue);           
            try{ 
                database.update(contactListUpdatetoTrue);
            }
            catch(Exception e){
                AppLogModel.LogError('Invalid Update Operation', e.getMessage());
            }
            
    }

        public static void contactIdentifierAfterUpdateTriggerLogic(List<Author_Identity__c> newcontactidentifierList,List<Author_Identity__c> oldcontactidentifierList){
                   
            set<Id> contactIdSet = new set<Id>();
            List<Author_Identity__c> ConIdentAll = new List<Author_Identity__c>();
            List<Author_Identity__c> ConIdentDerived = new List<Author_Identity__c>();
            Map<id,List<Author_Identity__c>> contactIdVsContactIdentifierMapAll = new Map<id,List<Author_Identity__c>>();
            set<Id> contactIdSetTrue = new set<Id>();
            set<Id> contactIdSetFalse = new set<Id>();
            List<Contact> contactListUpdate = new List<Contact>();
            
            for(Author_Identity__c contactIdent:newcontactidentifierList)
            {
                contactIdSet.add(contactIdent.Author_Contact__c);
            }
                        List<Contact> allContactsOfUpdatedCI = [Select id,Has_Active_US_license__c from Contact where id=:contactIdSet];
            
            ConIdentAll =  [Select id,Name,Author_Contact__c,Author_Contact__r.Has_Active_US_license__c,Identity_Type__c,Identity_Number__c from Author_Identity__c 
            where Author_Contact__c=:contactIdSet];
            
            for(Author_Identity__c conIdentAllRec : ConIdentAll)
            {
                if(contactIdVsContactIdentifierMapAll.containsKey(conIdentAllRec.Author_Contact__c))
                {
                    contactIdVsContactIdentifierMapAll.get(conIdentAllRec.Author_Contact__c).add(conIdentAllRec);
                }
                else
                {
                    contactIdVsContactIdentifierMapAll.put(conIdentAllRec.Author_Contact__c,new List<Author_Identity__c>{conIdentAllRec});
                    
                }
                
                
            }
                                   
            for(Contact conRec:allContactsOfUpdatedCI)
            {
                
                Boolean setFalseFlag = false;
                Boolean checkFalseReadyOwnFlag = false;
                for(Integer i = 0 ; i< newcontactidentifierList.size();i++)
                {
                    if((newcontactidentifierList.get(i).Identity_Number__c != oldcontactidentifierList.get(i).Identity_Number__c || newcontactidentifierList.get(i).Identity_Type__c != oldcontactidentifierList.get(i).Identity_Type__c) && newcontactidentifierList.get(i).Author_Contact__c == conRec.Id)
                    {
                        if((newcontactidentifierList.get(i).Identity_Number__c != oldcontactidentifierList.get(i).Identity_Number__c || newcontactidentifierList.get(i).Identity_Type__c != oldcontactidentifierList.get(i).Identity_Type__c) 
                            && newcontactidentifierList.get(i).Identity_Type__c == 'National Provider Identifier (NPI)' && newcontactidentifierList.get(i).Identity_Number__c != null
                            && conRec.Has_Active_US_license__c == false)
                            {
                                contactIdSetTrue.add(conRec.Id);
                            }
                            
                        else
                        {
                            if(oldcontactidentifierList.get(i).Identity_Type__c != 'National Provider Identifier (NPI)' || oldcontactidentifierList.get(i).Identity_Number__c == null)
                            {
                                checkFalseReadyOwnFlag = true;
                            }
                            List<Author_Identity__c> allCIforContact = new List<Author_Identity__c>();
                            allCIforContact = contactIdVsContactIdentifierMapAll.get(conRec.Id);
                                for(Author_Identity__c allCIforConRec : allCIforContact)
                                {
                                    System.debug('For##'+allCIforConRec);
                                    
                                    if(allCIforConRec.Identity_Type__c == 'National Provider Identifier (NPI)' 
                                        && (allCIforConRec.Identity_Number__c != null))
                                    {
                                        
                                        setFalseFlag = true;
                                       
                                        System.debug('==SetTrue%%%'+setFalseFlag+'---'+allCIforConRec.Identity_Number__c+'---'+allCIforConRec.Identity_Type__c);
                                    }
                                    
                                
                                }
                               
                            if(checkFalseReadyOwnFlag == false && setFalseFlag == false && conRec.Has_Active_US_license__c == true)
                            {
                                System.debug('----      ------@@@'+conRec.Id+'----      ------@@@'+newcontactidentifierList.get(i).Author_Contact__c);
                                contactIdSetFalse.add(conRec.Id);
                            }
                           
                            setFalseFlag = false;
                            checkFalseReadyOwnFlag = false;
                        }
                    }
                }
            
            }
                       
            for(Id cId:contactIdSetTrue)
            {
                Contact conToUpdate = new Contact(Id=cId,Has_Active_US_license__c=true);
                contactListUpdate.add(conToUpdate);
            }
            for(Id cId:contactIdSetFalse)
            {
                Contact conToUpdate = new Contact(Id=cId,Has_Active_US_license__c=false);
                contactListUpdate.add(conToUpdate);
            }
            
            system.debug('####contactListUpdate-->'+contactListUpdate);     
            try{       
                database.update(contactListUpdate);
            }
            catch(Exception e){
                AppLogModel.LogError('Invalid Update Operation', e.getMessage());
            }
            
       }   
   
    public static void contactIdentifierAfterDeleteTriggerLogic(List<Author_Identity__c> newcontactidentifierList){

            set<Id> contactIdSet = new set<Id>();
            Set<id> conSet =new Set<id>();
            List<Author_Identity__c> ConIdentDerived = new List<Author_Identity__c>();
            Map<id,List<Author_Identity__c>> contactIdVsContactIdentifierMapAll = new Map<id,List<Author_Identity__c>>();
            set<Id> contactIdSetTrue = new set<Id>();
            set<Id> contactIdSetFalse = new set<Id>();
            List<Contact> contactListUpdate = new List<Contact>();
            
            for(Author_Identity__c contactIdent : newcontactidentifierList)
            {
                contactIdSet.add(contactIdent.Author_Contact__c);
            }

            List<Contact> allContactsOfUpdatedCI = [Select id,Has_Active_US_license__c from Contact where id=:contactIdSet];

            List<Author_Identity__c> conIdentAll = [Select id,Name,Author_Contact__c,Identity_Type__c,Identity_Number__c from Author_Identity__c where author_contact__c =: contactIdSet];
 
            if(conIdentAll!=null){
                for(Author_Identity__c conIdentAllRec : ConIdentAll)
                {
                    if(contactIdVsContactIdentifierMapAll.containsKey(conIdentAllRec.Author_Contact__c))
                    {
                        contactIdVsContactIdentifierMapAll.get(conIdentAllRec.Author_Contact__c).add(conIdentAllRec);
    
                    }
                    else
                    {
                        ConIdentDerived.add(conIdentAllRec);
                        contactIdVsContactIdentifierMapAll.put(conIdentAllRec.Author_Contact__c,new List<Author_Identity__c>{conIdentAllRec});
                    }
                    
                    
                }
            }
            
            List<Author_Identity__c> allCIforContact = new List<Author_Identity__c>();
            for(Contact conRec:allContactsOfUpdatedCI)
            {
                Boolean setFalseFlag1=false;
                Boolean setFalseFlag2=false;
                
                
                allCIforContact = contactIdVsContactIdentifierMapAll.get(conRec.Id);
                
                if(allCIforContact!=null){
                
                    for(Author_Identity__c allCI:allCIforContact ){
                        if(allCI.Identity_Type__c =='National Provider Identifier (NPI)' && allCI.Identity_Number__c != null){
                            setFalseFlag1=true;
                        }
                    }

                for(Author_Identity__c newContactIdent:newcontactidentifierList){
                    if(newContactIdent.Identity_Type__c =='National Provider Identifier (NPI)' && newContactIdent.Identity_Number__c != null){
                        setFalseFlag2=true;
                    
                }
                if(setFalseFlag1==false && setFalseFlag2==true && conRec.Has_Active_US_license__c == true){
                    contactIdSetFalse.add(conRec.Id);
                    
                 }
                }
             }
            else{
            
                contactIdSetFalse.add(conRec.Id);
            }
            for(Id cId:contactIdSetFalse)
                {
                    Contact conToUpdate = new Contact(Id=cId,Has_Active_US_license__c=false);
                    contactListUpdate.add(conToUpdate);
                }
        
        }
        try{
            database.update(contactListUpdate);
        }
        catch(Exception e){
            AppLogModel.LogError('Invalid Update Operation', e.getMessage());
        }
    
    }

}