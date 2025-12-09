global class BatchAppLogPubIdSchedule implements Schedulable{
	
	global void execute(SchedulableContext SC) {
	    BatchAppLogPubId.runNow();   
		//ScheduleNextJob(5);
	} 
	
	//BatchAppLogPubIdSchedule.hourly();
	global static void hourly() {
		System.schedule('BatchAppLogPubId', '0 50 * * * ?', new BatchAppLogPubIdSchedule());
	}
}