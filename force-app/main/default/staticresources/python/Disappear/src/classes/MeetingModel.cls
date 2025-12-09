global class MeetingModel extends AppearBaseModel{ 
    
   private static Map<String, Meeting__c> mMeetingNameMap = null;
   public static Map<String, Meeting__c> MeetingNameMap{
     get {
       if (mMeetingNameMap == null){
         mMeetingNameMap = getMeetingMapByName();
       }
       return mMeetingNameMap;
     }
   }
   
  	private static Map<id, Meeting__c> pMeetingMap = null;
	public static Map<id, Meeting__c> MeetingMap{
		get{
			if (pMeetingMap == null){
				pMeetingMap = new Map<id, Meeting__c> ();
				for(Meeting__c meeting : MeetingList) {
					pMeetingMap.put(meeting.id, meeting);
				}
			}
			return pMeetingMap;
		}
	}
	
	private static List<Meeting__c> pMeetingList = null;
	public static List<Meeting__c> MeetingList {
		get{
			if ( pMeetingList == null){
				pMeetingList = getAllMeetingList();
			}
			return pMeetingList;
		}
	}
   
   public static Map<String, Meeting__c> getMeetingMapByName() {
    Map<String, Meeting__c> result = new Map<String, Meeting__c>();
    for(Meeting__c mMeeting : MeetingList){
      result.put(mMeeting.MeetingName255__c, mMeeting );
    }

    return result;
  }
      
    public static List<Meeting__c> getAllMeetingList(){
        List<Meeting__c> result = [
          select id, Name, MeetingName255__c, Venue__c, Acronym__c, Ends__c, Starts__c, Meeting_Name__c
          From Meeting__c
          order by MeetingName255__c
           ];
        return result;
    }    
    
    ///////////////  JS Remote support //////////////////
    @remoteAction
    global static List<Meeting__c> findMeetingsByName(string searchPhrase){

    	string searchName = searchPhrase;
        
        //Def 152 - modification to search by Abbreviation or Meeting name
    	if ( !SearchName.startsWith('%')) {   //search by Meeting Name	
			SearchName = '%' + SearchName;    	
    	}
			//append tail % if necessary
	    if (!SearchName.endsWith('%')) {
	    	SearchName += '%';
	    	
	    }
        //Attempt to search by Acronym   
       	string searchAcronym = searchPhrase;
	    if (!searchAcronym.endsWith('%')) {
	    	searchAcronym += '%';
	    }
        boolean shouldCheckMeetings = (!ProfileModel.isSysAdmin && !ProfileModel.isAppearBusinessAdmin); //CR151- only return meeting with end date greater than todays date
        List<Meeting__c> Meetings;
        if (shouldCheckMeetings) {
        	 Meetings = [
	            select id, MeetingName255__c, Venue__c, Acronym__c, Ends__c, Starts__c
	            From Meeting__c 
	            where (MeetingName255__c like :SearchName OR Acronym__c like :searchAcronym) AND ((Ends__c = null) OR (Ends__c >= TODAY)) 
	            order by Ends__c ASC NULLS LAST, MeetingName255__c ASC
	            limit 50
	        ];
        } else {
	        Meetings = [
	            select id, MeetingName255__c, Venue__c, Acronym__c, Ends__c, Starts__c
	            From Meeting__c 
	            where MeetingName255__c like :SearchName OR Acronym__c like :searchAcronym
	            order by Ends__c ASC NULLS LAST, MeetingName255__c ASC
	            limit 50
	        ];
        }
        
        if ( Meetings.size() > 0) {
        	return Meetings;
        }
        
        
        /*
        List<Meeting__c> MeetingsByAcronym = [
            select id, MeetingName255__c, Venue__c, Acronym__c, Ends__c, Starts__c
            From Meeting__c 
            where Acronym__c like :searchAcronym
            order by MeetingName255__c
            limit 50
	    ]; 
        
        if ( MeetingsByAcronym.size() > 0) {
        	return MeetingsByAcronym;
        }*/
        
        
        //now - try to search by date
        Date searchDate = ScanDate(searchPhrase);
        if ( searchdate == null) {
        	return new List<Meeting__c>();
        	//not a date
        }
        
        //now search by startDate or enddate
        List<Meeting__c> MeetingsByStartEndDate;
        
        if (shouldCheckMeetings) {
	        	MeetingsByStartEndDate= [
	            select id, MeetingName255__c, Venue__c, Acronym__c, Ends__c, Starts__c
	            From Meeting__c 
	            where (Starts__c = :searchdate or Ends__c = :searchdate) AND ((Ends__c = null) OR (Ends__c >= TODAY)) 
	            order by Ends__c ASC NULLS LAST, MeetingName255__c ASC
	            limit 50
		    ];
        } else {
	        	MeetingsByStartEndDate= [
	            select id, MeetingName255__c, Venue__c, Acronym__c, Ends__c, Starts__c
	            From Meeting__c 
	            where Starts__c = :searchdate or Ends__c = :searchdate
	            order by Ends__c ASC NULLS LAST, MeetingName255__c ASC
	            limit 50
		    ];
        }
        
        if (MeetingsByStartEndDate.size() > 0 ) {
        	return MeetingsByStartEndDate;
        }
        
        //still not found - return an empty set
        return new List<Meeting__c>();        
    }
    
    public static Date ScanDate(string searchPhrase) {
    	Date foundDate = null;
    	try {
    		foundDate = Date.ValueOf(searchPhrase);
    		return foundDate;
    	} catch (Exception e) {
    		//nothing to do - just ignore it
    	}
    	try {
    		foundDate = Date.Parse(searchPhrase);
    		return foundDate;
    	} catch (Exception e) {
    		//nothing to do - just ignore it
    	}
    	
    	//Replace / with - and try again
    	searchPhrase = searchPhrase.replace('//','-');
    	
    	try {
    		foundDate = Date.Parse(searchPhrase);
    		return foundDate;
    	} catch (Exception e) {
    		//nothing to do - just ignore it
    	}
    	
    	try {
    		foundDate = Date.Parse(searchPhrase);
    		return foundDate;
    	} catch (Exception e) {
    		//nothing to do - just ignore it
    	}
    	
    	return null;
    	
    }
    
    //////  reset MeetingName255__c
    public static void resetMeetingName255() {
    	List<Meeting__c> meetings = [
    		select MeetingName255__c, Meeting_name__c
    		from Meeting__c
    	];
    	for(Meeting__c mtg : meetings ) {
    		if ( mtg.Meeting_name__c <> null ) {
    			
    			if (  mtg.Meeting_name__c.length() < 255) {
    				mtg.MeetingName255__c = mtg.Meeting_name__c;
    			} else {
    				mtg.MeetingName255__c = mtg.Meeting_name__c.subString(0,254);
    			}
    		}
    	}
    	database.update (meetings, false);
    }
    
    public static string uniqueMeetingName(String mtgName, Date startDate, Date endDate, String Acronym, String Venue) {
    	String uniqueMtgName = mtgName;
    	if (startDate <> null )	{
    		uniqueMtgName = uniqueMtgName + ' | ' + startDate.format();
    	}
    	if (endDate <> null )	{
    		uniqueMtgName = uniqueMtgName + ' | '+ endDate.format();
    	}
    	if (Acronym <> null )	{
    		uniqueMtgName = uniqueMtgName + ' | '+Acronym;
    	}
    	if (Venue <> null )	{
    		uniqueMtgName = uniqueMtgName + ' | '+Venue;
    	}
    	return uniqueMtgName;
    }
}