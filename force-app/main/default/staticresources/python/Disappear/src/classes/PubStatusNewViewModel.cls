global class PubStatusNewViewModel {


    ///////////////  JS Remote support //////////////////
    @remoteAction
    global static List<IdNameDTO> findTargetsByName(string targetType, string startWith){       
        List<IdNameDTO> results = new List<IdNameDTO>();
        
        System.debug('TargetType is '+targetType+' and startWith is '+startWith);
        
        if ( targetType == 'journal') {
            List<Journal__c> journals = JournalModel.findJournalsByName( startWith);
            for(Journal__c j : journals) {
                results.add(new IdNameDTO((String)j.id, j.JournalName255__c));
            }
        } else { //targetType == 'meeting'
            List<Meeting__c> meetings = MeetingModel.findMeetingsByName( startWith);
            //boolean shouldCheckMeetings = (!ProfileModel.isSysAdmin && !ProfileModel.isAppearBusinessAdmin);            
            for(Meeting__c m : meetings) {
            	/*if (shouldCheckMeetings && m.Ends__c != null && m.Ends__c < DateTime.now()) { //CR151- only return meeting with end date greater than todays date
        			continue;
            	}*/
            	String uniqueMtgName = MeetingModel.uniqueMeetingName(
            		m.MeetingName255__c,m.Starts__c, m.Ends__c,
            		m.Acronym__c,m.Venue__c );
            	
                results.add(new IdNameDTO((String)m.id, uniqueMtgName));
            }
        } 
        
        return results;     
    }

	@remoteAction
	global static List<IdNameDTO> findDeptStatusByName( string startWith){		
		List<IdNameDTO> results = new List<IdNameDTO>();
		
		List<Status__c> status = StatusModel.findStatusByTypeName(StatusModel.DeptStatus, startWith);
		for(Status__c s : status) {
			results.add(new IdNameDTO((String)s.id, s.name));
		}

		return results;		
	}

}