global class AppearNightlyBatchSchedule implements Schedulable{

	global void execute(SchedulableContext SC) {  //can add more jobs here as required
 		BatchNightlyPubScan.runNow();
 		BatchResetEnbrel.runNow();
 		BatchCloseReviewCycles.runNow();
	}
	
	private static string scheduleToken = 'AppearNightlyBatchSchedule';
	private static string AppearNightlyBatchScheduleString {
		get {
			return KeyValueSettingsModel.GetKey(scheduleToken, '0 0 1 * * ?').value__c;
		}
	}
    
	//AppearNightlyBatchSchedule.scheduleDaily1am();
	global static void scheduleDaily1am() {
		try {
			AppearNightlyBatchSchedule nightlySchedule = New AppearNightlyBatchSchedule();
			Id Job_id = System.schedule('Nightly Pub Scan', AppearNightlyBatchScheduleString, nightlySchedule);
		} catch (Asyncexception ae) {  
			string message = ae.getMessage();
			if ( message.contains(' already scheduled for execution.')) {
				//save to ignore
			} else {
				throw ae;  
			}
		}
	}
}