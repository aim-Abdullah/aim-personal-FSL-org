@IsTest
public class AppLogModelScheduleTest {

	@IsTest
	public static void UnitTest() {
		
		CreateData();
		
		System.assertEquals('AppearLogCleanUpSchedule', AppLogModelSchedule.scheduleToken);
		System.assertEquals('0 15 * * * ?', AppLogModelSchedule.AppearLogScheduleString);
		
		AppLogModelSchedule.DelAppLog();
		AppLogModelSchedule.scheduleHourly();
	}
	
	public static void CreateData() {
		KeyValueSettingsModel.SetKey(AppLogModelSchedule.token, '10');
		
		for(integer x=0;x<20;x++){
			AppLogModel.LogDebug('test', 'test');
		}
		
		AppLogModel.flushLogs();
	}
}