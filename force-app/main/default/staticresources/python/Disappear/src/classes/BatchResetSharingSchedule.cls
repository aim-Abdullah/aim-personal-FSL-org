global class BatchResetSharingSchedule implements Schedulable{


	global void execute(SchedulableContext SC) {
 		BatchResetSharing.runNow();
	}
	
	public static string scheduleToken = 'BatchResetSharingSchedule';
	public static string AppearNightlyBatchScheduleString {
		get {			
			return KeyValueSettingsModel.GetKey(scheduleToken,  '0 0 19 * * ?').Value__c; 
			//run every night at 7pm
		}
	}
   
	//BatchResetSharingSchedule.scheduleResetSharing();
	global static void scheduleResetSharing() {
		try {
			BatchResetSharingSchedule resetSharingSchedule = New BatchResetSharingSchedule();
			Id Job_id = System.schedule('Batch Reset Sharing', AppearNightlyBatchScheduleString, resetSharingSchedule);
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