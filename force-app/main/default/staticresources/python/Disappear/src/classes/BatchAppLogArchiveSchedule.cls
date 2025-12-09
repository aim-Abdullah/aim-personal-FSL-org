global class BatchAppLogArchiveSchedule implements Schedulable{
	
	global void execute(SchedulableContext SC) {
	    BatchAppLogArchive.runNow();   
	} 
	
	//BatchAppLogArchiveSchedule.hourly();
	global static void hourly() {
		System.schedule('BatchAppLogArchive', '0 10 * * * ?', new BatchAppLogArchiveSchedule());
	}

	
}