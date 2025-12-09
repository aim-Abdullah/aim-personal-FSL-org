public class StudyNoteModelData {
    
    public static void deleteData() {
        List<sObject> delRecords = [ select id from StudyNote__c ];
        delete delRecords;
    }

    public static void createData() {
        
        integer dataCount = [select count() from StudyNote__c];
        if ( dataCount <> 0) return;
                
        List<StudyNote__c> studyNoteList = new List<StudyNote__c>();
        
        String Note1 = 'Study Description:  To use a large dbase to evaluate: a) the prevalence of reduced renal function and associated anemia and ESP use in the ICU, and  b) ESP use and the pt characteristics for use  Priimary endpoint: to establish the prevalence of reduced renal function in the ICU. Secondary endpoint: to establish the prevalence of ESP use i the ICU and describe the characteristics (renal function and anemis) in this group.';
        String Note2 = 'Key metrics: Pt charts- 40,000  Sites - 50  Enrollment- NA  Treatment- NA Follow-up- NA';
        String Note3 = 'Data abstraction through April 2007';
        String Note4 = 'Objectives:Primary endpoint: QoL (FACIT-An) Secondary endpoint: Other QoL measures; efficacy; safety; ADLs; IADLs; Frailty, Caregiver stress; hospitalization; SNF admission. Filing IND ph2 filed in 2003';

        studyNoteList.add( new StudyNote__c(Name='StudyNote1', Note__c=Note1, 
            StudyId__c=StudyModel.StudyMapByTitle.get('Avanti Patient Use Study').Id));
        studyNoteList.add( new StudyNote__c(Name='StudyNote2', Note__c=Note2, 
            StudyId__c=StudyModel.StudyMapByTitle.get('Enbrel PsO Inflamm Joints Pilot Study').Id));        
        studyNoteList.add( new StudyNote__c(Name='StudyNote2', Note__c=Note3, 
            StudyId__c=StudyModel.StudyMapByTitle.get('Enbrel RA Remission Study').Id));   
        studyNoteList.add( new StudyNote__c(Name='StudyNote2', Note__c=Note4, 
            StudyId__c=StudyModel.StudyMapByTitle.get('Enbrel Pain Study - formulation buffer and needle impact').Id));   
        
                        
        insert studyNoteList;
    
    }

}