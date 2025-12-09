public  class MeetingModelData extends appearBaseData {

    public static void deleteData() {
        AppearBaseData.purgeData('Meeting__c');
    }
     
    public static void createData() {
    
         integer dataCount = [select count() from Meeting__c];
         if ( dataCount <> 0) return;
        
        List<Meeting__c> MeetingList = new List<Meeting__c>();
        
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual Viral Hepatitis Congress'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'World Conference on Lung Cancer'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'HIV Drug Therapy in the Americas'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual World PGx Summit'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual Leipzig Interventional Course'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual Human Amyloid Imaging'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual CNS Summit'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual Meeting of the Retina Society'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Biennial International Surgical Week'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual Meeting of the Macula Society'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual EuroPCR'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual EuroHeartCare'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual Hawaii Dermatology Seminar'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual Endovascular Summit'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual SECO International'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Biennial World Glaucoma Congress'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual Fall Managed Care Forum'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual European Colorectal Congress'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'World Parkinson Congress'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual Euroanaesthesia'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Vascular Annual Meeting'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual Digestive Disease Week'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'Annual Meeting of the American Society of Clinical Oncology'));
         MeetingList.add( new Meeting__c(Legacy_Meeting__c= 'American Society of Hematology (ASH); 55th Annual Meeting'));         
         
         insert MeetingList;
                
     }    
     
 
     
}