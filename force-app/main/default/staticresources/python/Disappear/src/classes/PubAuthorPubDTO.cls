public class PubAuthorPubDTO {

	public Id pubId;
	public string pubName  {get;set;} 
	public string pubTitle {get;set;}
	public Id currentFcId;
	public Id pubAuthorId {get;set;}
	public string authorStatus {get;set;}
	
	
	public List<PubAuthorPubDraftDTO> PubAuthorPubDrafts {get;set;}
	public Map<Decimal, PubAuthorPubDraftDTO> PubAuthorPubDraftMap = null;
	
	public PubAuthorPubDTO() {
		PubAuthorPubDrafts = new List<PubAuthorPubDraftDTO>();
		PubAuthorPubDraftMap = new Map<Decimal, PubAuthorPubDraftDTO>();
	}
	
	public PubAuthorPubDraftDTO getPubDraft(Id FcId, Decimal fpr_cycle_num) {
		if ( PubAuthorPubDraftMap.containsKey(fpr_cycle_num))  {
			return PubAuthorPubDraftMap.get(fpr_cycle_num);
		} else {
			PubAuthorPubDraftDTO draft = new PubAuthorPubDraftDTO(fpr_cycle_num);
			PubAuthorPubDrafts.add(draft); 
			PubAuthorPubDraftMap.put(fpr_cycle_num, draft);
			 
			return draft;  
		}
	}
}