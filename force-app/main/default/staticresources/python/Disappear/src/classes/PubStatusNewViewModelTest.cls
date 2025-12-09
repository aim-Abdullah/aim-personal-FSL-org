@IsTest
public class PubStatusNewViewModelTest {

	@IsTest
	public static void UnitTest() {
		System.assertNotEquals(null, PubStatusNewViewModel.findDeptStatusByName(''));
		
		
		JournalModelData.createData();
		MeetingModelData.createData();
		System.assertNotEquals(null, PubStatusNewViewModel.findTargetsByName('journal',''));
		System.assertNotEquals(null, PubStatusNewViewModel.findTargetsByName('meetings',''));
	}
}