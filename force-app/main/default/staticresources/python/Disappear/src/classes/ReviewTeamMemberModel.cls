public class ReviewTeamMemberModel {

    public static List<ReviewTeamMember__c> findReviewTeamMembers(List<Review_Team__c> ReviewTeamList) {
        
        List<id> ReviewTeamIdList = new List<id>();
        for(Review_Team__c reviewteam : ReviewTeamList) {
            ReviewTeamIdList.add(reviewteam.id);
        }
        // r.Reviewer_Role__c has been added in below Code for ENHC0011636:- Enhancement 
        List<ReviewTeamMember__c> reviewTeamMembers = [
            select r.ReviewerType__c, r.Review_Team__c, 
            r.ReviewTeamMember__c, r.ReviewTeamMember__r.Name,
            r.Appear_Role__c,r.Reviewer_Role__c
            from ReviewTeamMember__c r
            where Review_Team__c in :ReviewTeamIdList
        ];
        
        return reviewTeamMembers;
    }
    
    private static List<ReviewTeamMember__c> pReviewTeamMemberList = null;
    public static List<ReviewTeamMember__c> ReviewTeamMemberList {
        get {
            if (pReviewTeamMemberList == null){
                pReviewTeamMemberList = getAllReviewTeamMembers();
            }
            return pReviewTeamMemberList;
        }
    }
    
    public static List<ReviewTeamMember__c> getAllReviewTeamMembers() {
        List<ReviewTeamMember__c> result = [
            Select Name, Review_Team__c, Appear_Role__c, Reviewer_Role__c,ReviewerType__c 
            From ReviewTeamMember__c 
            ];
        return result;
    }
     
    
   private static Map<String, ReviewTeamMember__c> pReviewTeamMemberNameMap = null;
   public static Map<String, ReviewTeamMember__c> ReviewTeamMemberNameMap{
     get {
       if (pReviewTeamMemberNameMap== null){
         pReviewTeamMemberNameMap = getReviewTeamMemberMapByName();
       }
       return pReviewTeamMemberNameMap;
     }
   }
   
   public static Map<String, ReviewTeamMember__c> getReviewTeamMemberMapByName() {
    Map<String, ReviewTeamMember__c> result = new Map<String, ReviewTeamMember__c>();
    for(ReviewTeamMember__c pReviewTeamMem : ReviewTeamMemberList){
      result.put(pReviewTeamMem.Name, pReviewTeamMem );
    }

    return result;
  }
}