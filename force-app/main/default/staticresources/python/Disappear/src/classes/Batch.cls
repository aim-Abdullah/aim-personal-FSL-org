public class Batch {
	public static void setup() {
		//BatchAppLogArchiveSchedule.hourly();   <-- not required. BatchAppLogPubIdSchedule will chain invoke it.
		BatchAppLogPubIdSchedule.hourly(); 
		BatchResetSharingSchedule.scheduleResetSharing();
		AppearNightlyBatchSchedule.scheduleDaily1am();
        TargetUpdate_SchedulerClass.schedule_Method(); // Appear Enhancement Backlog R2-2017: Target MissMatch Update 
	} 
}