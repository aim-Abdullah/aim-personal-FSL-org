global class PubAuthorViewModel {

    @remoteAction
    global static List<IdAuthorDTO> findAuthorsByName( string startWith){      
        List<IdAuthorDTO> results = new List<IdAuthorDTO>();
        List<Contact_Address__c> ContAddresses = New List<Contact_Address__c>();
        List<contact> contacts = PubAuthorModel.findAuthorsByName(startWith);
        /***for(contact c : contacts) {
            results.add(new IdAuthorDTO((String)c.contact_name__c, c.contact_name__r.name,c.Street_Address__c,
                c.Address_Line_2__c, c.City__c, c.Email__c,c.Zip_Postal_Code__c,''));
        }***/
        set<id> contIds = New Set<id>();
        for(contact c: Contacts){
        	contIds.add(c.Id);
        }
        map<id,Contact_Address__c> conaddmap = new map<id,Contact_Address__c>();
        ContAddresses = [Select id, Street_Address__c,Address_Line_2__c, City__c, State_Province__c,Email__c, Primary_Address__c,Country__c,Zip_Postal_Code__c,Contact_Name__c From Contact_Address__c where Contact_Name__c In: contIds and Primary_address__c =: true];
        for(Contact_Address__c c: ContAddresses){
        	conaddmap.put(c.Contact_Name__c,c);
        }
        
        for(contact c : contacts) {
        	if(conaddmap.get(c.id)!=null)
            results.add(new IdAuthorDTO((String)c.id, c.name,conaddmap.get(c.id).Street_Address__c,
                conaddmap.get(c.id).Address_Line_2__c, conaddmap.get(c.id).City__c, conaddmap.get(c.id).Email__c,conaddmap.get(c.id).Zip_Postal_Code__c,''));
            else
            results.add(new IdAuthorDTO((String)c.id, c.name,'','', '', '','',''));
            
        }
        
        AppLogModel.flushLogs();
        
        return results;//results;     
    } 
}