public class PubAuthorPubDraftAttachmentDTO {
	public Id pubId;
	public Id fcId;
	public Id AttachmentDetailId {get; set;}
	public Id ContentId {get; set;}
	public string AttachmentName  {get;set;}
	public string AttachmentType  {get;set;}
	public DateTime AttachmentDate  {get;set;}
	public string Comment  {get;set;}
	public string Notes  {get;set;}
	public Decimal Size  {get;set;}
	
	public List<PubAuthorPubDraftAttachCommentDTO> CommentList{get;set;}
	
	public Integer CommentListSize { 
		get{
			if (CommentList != null ){
				return CommentList.size();
			}
			return 0; 
		}
	}
	
	public PubAuthorPubDraftAttachmentDTO(id detailId, List<PubAuthorPubDraftAttachCommentDTO> comments) {
		system.debug('*****This draft has '+comments.size()+' comments.');
		CommentList = new List<PubAuthorPubDraftAttachCommentDTO>( comments);
		for(PubAuthorPubDraftAttachCommentDTO commentDTO : CommentList) {
			system.debug('*****Comment is '+commentDTO.Comment);
		}
		AttachmentDetailId = detailId;
	}
}