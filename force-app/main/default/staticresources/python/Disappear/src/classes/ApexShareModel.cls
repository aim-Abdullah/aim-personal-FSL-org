public without sharing class ApexShareModel {


	public static boolean persistApexShare(List<sObject> shareRecords, id parentId) {
		// Insert the sharing record and capture the save result. 
		// The false parameter allows for partial processing if multiple records passed 
		// into the operation.
		
		if ( shareRecords == null || shareRecords.size() == 0 ) {
			return false;
		}
		
		
		AppLogModel.LogInfo('AppearBaseModel::persistApexShare', 
			'persist '+shareRecords.size()+' share records',parentId );
		
		List<Database.Saveresult> srList = Database.Insert(shareRecords,false);
		//insert shareRecords;
		//return true;

		// Process the save results.
		for(Database.Saveresult sr : srList) {
			if(sr.isSuccess()){
				// Indicates success 
				//return true;
			} else {
				// Get first save result error.
				Database.Error err = sr.getErrors()[0];
	         
				// Check if the error is related to trival access level.
				// Access levels equal or more permissive than the object's default 
				// access level are not allowed. 
				// These sharing records are not required and thus an insert exception is acceptable. 
				if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  err.getMessage().contains('AccessLevel')){
						
					//AppLogModel.LogDebug('ApexShareModel::persistApexShare', err.getStatusCode() + ' '+ err.getMessage());  //nothing to worry about
	            	// Indicates success.
	            	//return true;
				} else{
					// Indicates failure.
					//return false;
					AppLogModel.LogError('ApexShareModel::persistApexShare', err.getStatusCode() + ' '+ err.getMessage(), parentId );
				}
			}
		}
		
		AppLogModel.flushLogs();
		return true;
		
	}
}