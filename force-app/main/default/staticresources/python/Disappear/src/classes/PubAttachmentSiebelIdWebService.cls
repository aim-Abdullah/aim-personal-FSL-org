@RestResource(urlMapping='/PubAttachmentSiebelIdWebService/v1/*')
global class PubAttachmentSiebelIdWebService {

	@httpPost 
	global static Map<String, String>  post(List<string> pubSiebelIdList) {
		Map<String,String> result = new Map<String,String>();
		try {
			Long startTime = DateTime.now().getTime();
			
			Set<String> SiebelIdSet = new Set<String>();
			for(String siebelId : pubSiebelIdList) {
				SiebelIdSet.add(siebelId);
			}
	
			List<Publication__c> pubs = [
				select id, SiebelRowId__c //, name, publication_Title__c
				from publication__c
				where SiebelRowId__c in :SiebelIdSet
			];
	
			
			for(Publication__c pub : pubs) {
				result.put(pub.SiebelRowId__c, pub.id);
			}
			
			AppLogModel.LogInfo('PubAttachmentSiebelIdWebService', 'Completed processing for '+ pubSiebelIdList.size() + ' pubSiebelIdList records' );
		} catch ( Exception e ) {
			AppLogModel.LogError('PubAttachmentSiebelIdWebService', e.getMessage());
		} finally {
			AppLogModel.flushLogs();
		}
		return result;
	}
	
}