trigger MeetingTrigger on Meeting__c (before insert, before update) {


    if (( Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore) {
        //trigger to make sure meeting Name is unique
        
        set<string> nameSet  = new set<string>();
        /*
        for(Meeting__c rec : MeetingModel.getAllMeetingList()){
        	//2013-07-10 - Brandon added Venue and Acronym to unique check
        	string concatName = String.ValueOf(rec.Starts__c )+ String.ValueOf(rec.Ends__c ) + rec.Venue__c + rec.Acronym__c + rec.Meeting_Name__c;
            nameSet.add(concatName);
        }
        */
        
        
        for(Meeting__c meeting : Trigger.new){
        	
        	if ( meeting.Meeting_Name__c == null && meeting.Legacy_Meeting__c <> null) {
        		meeting.Meeting_Name__c = meeting.Legacy_Meeting__c;
        	} else if ( meeting.Meeting_Name__c == null && meeting.Legacy_Meeting__c == null){
        		meeting.Meeting_Name__c = meeting.name;
        		meeting.Legacy_Meeting__c = meeting.name;
        	}
        	
            //string newName = String.ValueOf(meeting.Starts__c )+ String.ValueOf(meeting.Ends__c ) +  meeting.Legacy_Meeting__c;
            //Temeko Richardson 7/10/13 - revised to use the Meeting_Name__c field as per Data Migration Defect 59
            meeting.Unique_Meeting_Name__c = String.ValueOf(meeting.Starts__c )+ String.ValueOf(meeting.Ends__c ) + meeting.Venue__c + meeting.Acronym__c + meeting.Meeting_Name__c;
		   
		   
	       	if (  meeting.Meeting_name__c.length() < 255) {
				meeting.MeetingName255__c = meeting.Meeting_name__c;
			} else {
				meeting.MeetingName255__c = meeting.Meeting_name__c.subString(0,254);
			}

            /* use Unique_Meeting_Name field instead
            if (newName <> null && nameSet.contains(newName)){
                meeting.addError('Error : [' + newName +'] already exists as a Meeting');   
            } else {
            	//2013-07-10 - Benjamin removed code the reassign Meeting Name
                nameSet.add(newName); 
            }  
            */
        }       
    }   
}