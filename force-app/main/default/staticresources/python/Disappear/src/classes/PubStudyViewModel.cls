global class PubStudyViewModel {

    ///////////////  JS Remote support //////////////////
    @remoteAction
    global static List<IdStudyProjectDTO> findStudiesByNameTitle(string StudyType, string startWith){       
        List<IdStudyProjectDTO> results = new List<IdStudyProjectDTO>();
        
        String msg = 'StudyType is '+StudyType+' and startWith is '+startWith;
        System.debug(msg);
        
        if ( StudyType == 'study') {
            List<Study__c> journals = StudyModel.findStudyByName( startWith);
            for(Study__c j : journals) {
                results.add(new IdStudyProjectDTO((String)j.id, j.name,j.Title__c));
            }
        } else { //StudyType == 'project'
            List<Study__c> meetings = StudyModel.findProjectByName( startWith);
            for(Study__c m : meetings) {
                results.add(new IdStudyProjectDTO((String)m.id, m.name, m.Title__c));
            }
        }
         
        AppLogModel.LogInfo('PubStudyViewModel::findStudiesByName', 
        	msg +' found '+results.size()+' results'); 
        AppLogModel.flushLogs();
        return results;     
    }

 

}