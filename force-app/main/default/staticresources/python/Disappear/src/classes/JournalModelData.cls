public  class JournalModelData{

    public static void createData() {
    
         integer dataCount = [select count() from Journal__c];
         if ( dataCount <> 0) {
            return;
         }
         List<Journal__c> JournalList = new List<Journal__c>();

         JournalList.add( new Journal__c(JournalName255__c= 'Cutis', Journal_Abbreviation__c='AA'));
         JournalList.add( new Journal__c(JournalName255__c= 'The Oncologist', Journal_Abbreviation__c='AB'));
         JournalList.add( new Journal__c(JournalName255__c= 'Journal of Clinical Epidemiology', Journal_Abbreviation__c='AC'));
         JournalList.add( new Journal__c(JournalName255__c= 'Journal of Bone and Mineral Research', Journal_Abbreviation__c='AD'));
         JournalList.add( new Journal__c(JournalName255__c= 'Journal of General Internal Medicine', Journal_Abbreviation__c='AE'));
         JournalList.add( new Journal__c(JournalName255__c= 'Lancet', Journal_Abbreviation__c='AF'));
         JournalList.add( new Journal__c(JournalName255__c= 'New England Journal of Medicine'));
         JournalList.add( new Journal__c(JournalName255__c= 'European Journal of Haematology'));
         JournalList.add( new Journal__c(JournalName255__c= 'Bone Marrow Transplantation'));
         JournalList.add( new Journal__c(JournalName255__c= 'The Breast'));
         JournalList.add( new Journal__c(JournalName255__c= 'Neoplasia'));
         JournalList.add( new Journal__c(JournalName255__c= 'Medicina Clínica'));
         JournalList.add( new Journal__c(JournalName255__c= 'Blood Reviews'));
         JournalList.add( new Journal__c(JournalName255__c= 'American Journal of Medicine'));
         JournalList.add( new Journal__c(JournalName255__c= 'European Journal of Hospital Pharmacy'));
         JournalList.add( new Journal__c(JournalName255__c= 'Applied Health Economics and Health Policy'));
         JournalList.add( new Journal__c(JournalName255__c= 'NDT Plus'));
         JournalList.add( new Journal__c(JournalName255__c= 'Clinical Medicine: Therapeutics'));
         JournalList.add( new Journal__c(JournalName255__c= 'PLoS One Journal'));
         JournalList.add( new Journal__c(JournalName255__c= 'Medical Care Research and Review'));
         JournalList.add( new Journal__c(JournalName255__c= 'journal of clinical D*'));
         JournalList.add( new Journal__c(JournalName255__c= 'European Journal of Health Economics'));
         JournalList.add( new Journal__c(JournalName255__c= 'Renal Business Today'));
         JournalList.add( new Journal__c(JournalName255__c= 'Journal of Supportive Care in Cancer'));
         JournalList.add( new Journal__c(JournalName255__c= 'Lancet Oncology'));
         JournalList.add( new Journal__c(JournalName255__c= 'Drugs and Aging'));
         JournalList.add( new Journal__c(JournalName255__c= 'BMC Health Services Research'));
         JournalList.add( new Journal__c(JournalName255__c= 'Journal of Advanced Nursing'));
         JournalList.add( new Journal__c(JournalName255__c= 'Clinical Journal of the American Society of Nephrology'));
         JournalList.add( new Journal__c(JournalName255__c= 'Annuals of Hematology'));
         JournalList.add( new Journal__c(JournalName255__c= 'American Journal of Physiology Endocrinology and Metabolism'));
         JournalList.add( new Journal__c(JournalName255__c= 'Arthritis Care and Research'));
         JournalList.add( new Journal__c(JournalName255__c= 'Journal of Rheumatology'));
         JournalList.add( new Journal__c(JournalName255__c= 'Journal of Clinical Pharmacology'));
         JournalList.add( new Journal__c(JournalName255__c= 'European Heart Journal'));
         JournalList.add( new Journal__c(JournalName255__c= 'Annals of Internal Medicine'));
         JournalList.add( new Journal__c(JournalName255__c= 'Cancer Treatment Reviews'));
         JournalList.add( new Journal__c(JournalName255__c= 'Archives of Internal Medicine'));
         JournalList.add( new Journal__c(JournalName255__c= 'Hospital Pharmacy'));
         JournalList.add( new Journal__c(JournalName255__c= 'European Journal of Clinical Pharmacology'));
         JournalList.add( new Journal__c(JournalName255__c= 'Pharmacotherapy'));
         JournalList.add( new Journal__c(JournalName255__c= 'Clinical Rheumatology'));
         JournalList.add( new Journal__c(JournalName255__c= 'Annals of the Rheumatic Diseases'));         
         JournalList.add( new Journal__c(JournalName255__c= 'British Journal of Dermatology'));
         JournalList.add( new Journal__c(JournalName255__c= 'Molecular Cancer Therapeutics'));
         JournalList.add( new Journal__c(JournalName255__c= 'Clinical Therapeutics'));
         JournalList.add( new Journal__c(JournalName255__c= 'Archives of Dermatology'));
         JournalList.add( new Journal__c(JournalName255__c= 'Nephrology Dialysis Transplantation'));
         JournalList.add( new Journal__c(JournalName255__c= 'PharmacoEconomics'));
         JournalList.add( new Journal__c(JournalName255__c= 'Supportive Care in Cancer'));
         JournalList.add( new Journal__c(JournalName255__c= 'American Journal of Clinical Dermatology'));
         JournalList.add( new Journal__c(JournalName255__c= 'BMC Molecular Biologye')); 
         JournalList.add( new Journal__c(JournalName255__c= 'Journal of the National Cancer Institute (JNCI)')); 
         JournalList.add( new Journal__c(JournalName255__c= 'Journal of Clinical Oncology'));                                    
         JournalList.add( new Journal__c(JournalName255__c= 'Annals of Oncology')); 
         JournalList.add( new Journal__c(JournalName255__c= Null,Journal_name__c='Test' ));
         insert JournalList;
                
     }
     
     public static void deleteData() {
        List<Journal__c> journals = [select id from Journal__c];
        
        delete journals;
     }
    
}