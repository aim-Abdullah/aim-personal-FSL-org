trigger JournalTrigger on Journal__c (before insert, before update) {

	//not sure how to enforce unique Journal Name - no start  end dates
	if (( Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore) {
      
       
        for(Journal__c journal : Trigger.new){
     		if ( journal.Journal_Name__c == null && journal.Legacy_journal_name__c <> null) {
     			journal.Journal_Name__c = journal.Legacy_journal_name__c;
     		} else if (journal.Journal_Name__c == null && journal.Legacy_journal_name__c == null) {
     			journal.Journal_Name__c = journal.name; 
     			journal.Legacy_journal_name__c = journal.name;
     		}
     		
			if ( journal.Journal_name__c <> null ) {	
    			if (  journal.Journal_name__c.length() < 255) {
    				journal.JournalName255__c = journal.Journal_name__c;
    			} else {
    				journal.JournalName255__c = journal.Journal_name__c.subString(0,254);
    			}
	    	}
     		
        }       
    }  
}