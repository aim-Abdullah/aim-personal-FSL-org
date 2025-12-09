public class StudyNoteModel {
  
   private static Map<string,StudyNote__c> pStudyNoteMap = null;
   public static Map<string,StudyNote__c> StudyNoteMap {
    get {
      if ( pStudyNoteMap == null) {
        pStudyNoteMap = new Map<string,StudyNote__c>();
        for(StudyNote__c studyNote : StudyNoteList ) {
          pStudyNoteMap.put(studyNote.name, studyNote);
        }
      }
      return pStudyNoteMap;
    }
   }
    private static List<StudyNote__c> pStudyNoteList = null;
    public static List<StudyNote__c> StudyNoteList {
        get {
            if ( pStudyNoteList == null) {
                pStudyNoteList = getAllStudyNotes();
            }
            return pStudyNoteList;
        }
    }
    
    public static List<StudyNote__c> getAllStudyNotes() {
         List<StudyNote__c> studyNote= [
      Select Id, Name, StudyId__c, Note__c
      From StudyNote__c 
      order by Name
    ];
    return studyNote;
    
    }
 
}