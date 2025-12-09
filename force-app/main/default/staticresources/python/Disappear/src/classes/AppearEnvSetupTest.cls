@IsTest
public class AppearEnvSetupTest {
	
	@IsTest
	public static void UnitTestBatchResetSharingSchedule() {
		System.assertEquals('BatchResetSharingSchedule', BatchResetSharingSchedule.scheduleToken);
		System.assertEquals('0 0 19 * * ?', BatchResetSharingSchedule.AppearNightlyBatchScheduleString);
	}
	
    @isTest
    public static void UnitTest() {
    	AppLogModel.setLogLevelInfo();
        AppearEnvSetup.Initialize();
    }
}