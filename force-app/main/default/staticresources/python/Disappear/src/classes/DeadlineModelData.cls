public  class DeadlineModelData {

  /*@IsTest
    public static void UnitTest() {
        MeetingModelData.createData();
        DeadlineModelData.createData();
    }*/

    public static void createData() {
    
		integer dataCount = [select count() from Deadline__c];
		if ( dataCount <> 0) return;
		
		List<Deadline__c> DeadlineList = new List<Deadline__c>();
		 
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='2nd yr fellow Abst. Deadline',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual Viral Hepatitis Congress').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Abstract Notifications Mailed',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('World Conference on Lung Cancer').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Abstract Withdrawal Date',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('HIV Drug Therapy in the Americas').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Abstracts Available On-Line',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual World PGx Summit').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Abstracts and Programs Mailed',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual Leipzig Interventional Course').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Advance Registration Deadline',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual Human Amyloid Imaging').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Call For Abstracts Available',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual CNS Summit').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Corporate Symposia Deadline',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual Meeting of the Retina Society').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Electronic Abstract Deadline',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Biennial International Surgical Week').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Final Program Available',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual Meeting of the Macula Society').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Final Registration Deadline',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual EuroPCR').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Housing Deadline',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual EuroHeartCare').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Late Breaker Submission Opens',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual Endovascular Summit').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Other',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual SECO International').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Paper Abstract Deadline',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Biennial World Glaucoma Congress').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Abstract Deadline Online Close',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual Fall Managed Care Forum').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Abstract Deadline Notification',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual European Colorectal Congress').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Abstract Deadline Late Breaker',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('Annual European Colorectal Congress').Id));
		DeadlineList.add( new Deadline__c(DeadLine_Type__c='Preliminary Program Available',Date__c=null, Meeting__c=MeetingModel.MeetingNameMap.get('World Parkinson Congress').Id));
		           
		insert DeadlineList;
                
     }
    
}