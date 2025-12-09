public class PubAuthorPubDraftAttachCommentDTO {
    public string Comment {get;set;}
    public DateTime CommentDate {get;set;}
    public string CommentDateText {get;set;}
    public string CommentAuthor {get;set;}
    public Id CommentId {get;set;}
    public Id CommentAuthorUserId {get;set;}
    
    public PubAuthorPubDraftAttachCommentDTO(String text, DateTime postDate, String name, id commId, id userId) {
        this.Comment = text;
        this.CommentDate = postDate;
        this.CommentDateText = postDate.format().trim();
        this.CommentAuthor = name;
        this.commentId = commId;
        this.CommentAuthorUserId = userId; 
    }
    
}