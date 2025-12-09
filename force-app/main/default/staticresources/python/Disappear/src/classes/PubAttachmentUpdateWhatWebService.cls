@RestResource(urlMapping='/PubAttachmentUpdateWhatWebService/v1/*')
global class PubAttachmentUpdateWhatWebService {

	@httpPost 
	global static string post(String pubId, String pubAttachemntSiebelId, String attachmentId, string fileName) {
		Long startTime = DateTime.now().getTime();
		
		AppLogModel.LogInfo('PubAttachmentUpdateWhatWebService::Post', 
			pubId+' : ' + pubAttachemntSiebelId + ' : '+ attachmentId+' : ' +fileName );
		
		List<PubAttachmentDetails__c> pubAttachDetails = [
			select publication__c, AttachmentName__c, Attachment_URL__c, What__c, size__c
			from PubAttachmentDetails__c
			where SiebelRowId__c = :pubAttachemntSiebelId
		];
		
		
		if ( pubAttachDetails.size() == 1) {
			PubAttachmentDetails__c pubAttch = pubAttachDetails[0];
			pubAttch.what__c = attachmentId;
			pubAttch.AttachmentName__c = fileName;
			pubAttch.Attachment_URL__c = AppearUrlModel.ChatterFeedIdToUrl(attachmentId);
			
			update pubAttch;
		} else {
			AppLogModel.LogInfo('PubAttachmentUpdateWhatWebService::Post', 
				'Cannot locate PubAttachementDetails with siebelId = '+ pubAttachemntSiebelId);
		}
							
		AppLogModel.flushLogs();  
		return 'done';
		

	}
}