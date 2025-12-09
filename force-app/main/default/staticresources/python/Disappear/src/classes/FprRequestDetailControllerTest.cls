@IsTest
public class FprRequestDetailControllerTest {

	@IsTest
	public static void UnitTest() {
		FprRequestDetailController fprReqCtrl = New FprRequestDetailController();
	
		System.assert(fprReqCtrl.isCoordinator);	
		System.assert(!fprReqCtrl.isSubmitter);
		
		fprReqCtrl.ExpeditFprRequest();
		fprReqCtrl.WithdrawFprRequest();
		fprReqCtrl.AcceptFprRequest();
	}
}