global class JournalModel extends AppearBaseModel{

    private static List<Journal__c> pJournalList = null;
    public static List<Journal__c> JournalList{
        get{
            if(pJournalList == null){
              pJournalList = getAllJournalList();
            }               
        return pJournalList;
        }
    }  
    
	private static Map<String, Journal__c> pJournalNameMap = null;
	public static Map<String, Journal__c> JournalNameMap{
		get {
			if (pJournalNameMap == null){
				pJournalNameMap =  new Map<String, Journal__c>();
				for(Journal__c j : JournalList){
					pJournalNameMap.put(j.JournalName255__c, j );
				}
			}
			return pJournalNameMap;
		}
	}
   
  	private static Map<id, Journal__c> pJournalMap = null;
	public static Map<id, Journal__c> JournalMap{
		get{
			if (pJournalMap == null){
				pJournalMap = new Map<id, Journal__c> ();
				for(Journal__c journal : JournalList) {
					pJournalMap.put(journal.id, journal);
				}
			}
			return pJournalMap;
		}
	} 
      
    public static List<Journal__c> getAllJournalList(){
        List<Journal__c> result = [
			Select j.Legacy_journal_name__c, j.Id, j.JournalName255__c, j.Journal_Abbreviation__c
			From Journal__c j 
			order by j.JournalName255__c
		];
        return result;
    }    
    
    ///////////////  JS Remote support //////////////////
    @remoteAction
    global static List<Journal__c> findJournalsByName(string searchPhrase){
    	
    	string searchName = searchPhrase;
    	
     	//Def 152 - modification to search by Abbreviation or Journal name
    	if ( !SearchName.startsWith('%')) {   //search by Journal Name	
			SearchName = '%' + SearchName;    	
    	}
			//append tail % if necessary
	    if (!SearchName.endsWith('%')) {
	    	SearchName += '%';	    	
	    }
	    
	    //Attempt to search by Abbreviation   
	    string searchAbb = searchPhrase;
	    if (!searchAbb.endsWith('%')) {
	    	searchAbb += '%';
	    }

		//search by Journal name and abbreviation
        List<Journal__c> journals = [
            select id,JournalName255__c, Journal_Abbreviation__c
            From Journal__c 
            where JournalName255__c like :SearchName OR Journal_Abbreviation__c like :searchAbb
            order by JournalName255__c
            limit 50
        ];
        
        return journals;
    }
    
    //////  reset JournalName255__c
    public static void resetJournalName255() {
    	List<Journal__c> Journals = [
    		select JournalName255__c, Journal_name__c
    		from Journal__c
    		where JournalName255__c = null
    		limit 9000
    	];
    	for(Journal__c j : Journals ) {
    		if ( j.Journal_name__c <> null ) {
    			
    			if (  j.Journal_name__c.length() < 255) {
    				j.JournalName255__c = j.Journal_name__c;
    			} else {
    				j.JournalName255__c = j.Journal_name__c.subString(0,254);
    			}
    		}
    	}
    	database.update (Journals, false);
    }
    
}