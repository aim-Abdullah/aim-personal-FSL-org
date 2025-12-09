public class FprRequestDetailController extends AppearBaseController {


	public boolean isCoordinator {
		get {
			//check role of current user in relation to this pub
			String profileId = UserInfo.getProfileId();
			
			//Todo
			return true;			
		}
	}

	public PageReference ExpeditFprRequest() {
		return null;
	}
	
	public PageReference WithdrawFprRequest() {
		return null;
	}
	
	public boolean isSubmitter {
		get {
			if ( ActivePub.pubRecord.createdById == UserInfo.getUserId()) {
				return true;			
			} else {
				return false;
			}
		}
	}

	public void AcceptFprRequest() {
		//ActivePub.pubRecord.RecordTypeId = RecordTypeModel.PUB_REVIEW.Id;
		System.Debug('FprRequestDetailController::AcceptFprRequest new Record Id = '+ ActivePub.pubRecord.RecordType);
		
		ActivePub.Persist();
		//return null;
	}
	
	public void RejectFprRequest() {
		//return null;
	}
}