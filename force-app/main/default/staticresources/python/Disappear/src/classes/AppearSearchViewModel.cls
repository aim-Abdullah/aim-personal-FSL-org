global class AppearSearchViewModel {

	@RemoteAction
	global static List<AppearSimilarContactDO> GetSimilarContacts(string inputString)
	{
		System.Debug('AppearSearchContactController::GetSimilarContacts - '+inputString);
		return AppearContactModel.SimilarContacts(inputString, 10);
	}	
}