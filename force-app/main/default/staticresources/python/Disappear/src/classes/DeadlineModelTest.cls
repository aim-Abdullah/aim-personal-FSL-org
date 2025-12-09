@IsTest
public class DeadlineModelTest{
    @IsTest
    public static void UnitTest() {
        MeetingModelData.createData();
        
        DeadlineModelData.createData();
		System.assertNotEquals(null, DeadlineModel.DeadlineList); 
		System.assertNotEquals(null, DeadlineModel.DeadlineNameMap); 
    }
    
}