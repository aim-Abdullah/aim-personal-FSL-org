public class PubAuthorPubDraftDTO {
	
	public Decimal fpr_cycle_num  {get;set;}
	public string fpr_cycle_numStr  {get;set;}
	public List<PubAuthorPubDraftAttachmentDTO> PubAuthorPubDraftAttachments {get;set;}
	
	public PubAuthorPubDraftDTO(Decimal fpr_cycle_num) {
		PubAuthorPubDraftAttachments = new List<PubAuthorPubDraftAttachmentDTO>();
		this.fpr_cycle_num = fpr_cycle_num;
		if (this.fpr_cycle_num == 0.0) {
			fpr_cycle_numStr = '';
		} else {
			fpr_cycle_numStr = string.valueOf(integer.valueOf(fpr_cycle_num));
		}
	}
	
	public PubAuthorPubDraftAttachmentDTO createPubAuthorPubDraftAttachment(PubAttachmentDetails__c pad, List<PubAuthorPubDraftAttachCommentDTO> comments) {
		
		PubAuthorPubDraftAttachmentDTO papda = new PubAuthorPubDraftAttachmentDTO(pad.id, comments);
		PubAuthorPubDraftAttachments.add(papda);
		

		papda.ContentId = null;
		if ( pad.Attachment_URL__c != null) {   
			string[] urlSegments= pad.Attachment_URL__c.split('/', 0);
			papda.ContentId = urlSegments[urlSegments.size() - 1];
		}
						
		papda.pubId = pad.Publication__c;
		papda.fcId = pad.FPR_Cycle__c;
		papda.AttachmentName = pad.AttachmentName__c;
		papda.AttachmentType = pad.AttachmentType__c;
		papda.AttachmentDate = pad.AttachmentDate__c;
		papda.Notes = pad.Notes__c; 
		papda.Size = pad.Size__c;
		 
		return papda;
	}
}