@IsTest
public class AppearTriggerActivationModelTest {

	@IsTest
	public static void UnitTest() {
		System.assert(AppearTriggerActivationModel.isPublicationTriggerActive);
		System.assert(AppearTriggerActivationModel.isPubStatusTriggerActive);
		System.assert(AppearTriggerActivationModel.isCalcBusinessHourStatusTriggerActive);
		System.assert(AppearTriggerActivationModel.isCalcBusinessHourTriggerActive);
		
		
		AppearTriggerActivationModel.activateTriggersAfterDataMigration();
		System.assert(AppearTriggerActivationModel.isPublicationTriggerActive);
		System.assert(AppearTriggerActivationModel.isPubStatusTriggerActive);
		System.assert(AppearTriggerActivationModel.isCalcBusinessHourStatusTriggerActive);
		System.assert(AppearTriggerActivationModel.isCalcBusinessHourTriggerActive);
				
		AppearTriggerActivationModel.deactivateTriggersForDataMigration();
		System.assert(!AppearTriggerActivationModel.isPublicationTriggerActive);
		System.assert(!AppearTriggerActivationModel.isPubStatusTriggerActive);
		System.assert(!AppearTriggerActivationModel.isCalcBusinessHourStatusTriggerActive);
		System.assert(!AppearTriggerActivationModel.isCalcBusinessHourTriggerActive);
				
	}

}