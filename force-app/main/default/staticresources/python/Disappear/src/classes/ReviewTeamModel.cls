public class ReviewTeamModel {


    public static List<Review_Team__c> findReviewTeamsBySubGroupProdInd(id SubGroupId, Set<Id> ProdIndList) {
    
        List<Review_Team__c> result = [
            select Name, Data_Source__c, Data_Source__r.name, subGroup__c, subGroup__r.Name
            from Review_Team__c
            where SubGroup__c = :SubGroupId
            and Product_Indication__c in :ProdIndList
        ];
        return result;
        
    }

    public static List<Review_Team__c> findReviewTeamsByDataSourceProdInd(id DataSourceId, Set<Id> ProdIndList) {

        List<Review_Team__c> result = [
            select Name, Data_Source__c, Data_Source__r.name, subGroup__c, subGroup__r.Name
            from Review_Team__c
            where SubGroup__c = :DataSourceId
            and Product_Indication__c in :ProdIndList
        ];
        return result;
        
    }
    
    private static List<Review_Team__c> pReviewTeamList = null;
    public static List<Review_Team__c> ReviewTeamList {
        get {
            if (pReviewTeamList == null){
                pReviewTeamList = getAllReviewTeams();
            }
            return pReviewTeamList;
        }
    }
    
    public static List<Review_Team__c> getAllReviewTeams() {
        List<Review_Team__c> result = [
            Select Name, Data_Source__c, Data_Source__r.name, subGroup__c, subGroup__r.Name, Product_Indication__c 
            From Review_Team__c 
            ];
        return result;
    }
     
    
   private static Map<String, Review_Team__c> pReviewTeamNameMap = null;
   public static Map<String, Review_Team__c> ReviewTeamNameMap{
     get {
       if (pReviewTeamNameMap == null){
         pReviewTeamNameMap = getReviewTeamMapByName();
       }
       return pReviewTeamNameMap;
     }
   }
   
   public static Map<String, Review_Team__c> getReviewTeamMapByName() {
    Map<String, Review_Team__c> result = new Map<String, Review_Team__c>();
    for(Review_Team__c pReviewTeam : ReviewTeamList){
      result.put(pReviewTeam.Name, pReviewTeam );
    }

    return result;
  }
    
   private static Map<Id, Review_Team__c> pReviewTeamMap = null;
   public static Map<Id, Review_Team__c> ReviewTeamMap{
     get {
       if (pReviewTeamMap == null){
         pReviewTeamMap = getReviewTeamMap();
       }
       return pReviewTeamMap;
     }
   }
   
   public static Map<Id, Review_Team__c> getReviewTeamMap() {
    Map<Id, Review_Team__c> result = new Map<Id, Review_Team__c>();
    for(Review_Team__c pReviewTeam : ReviewTeamList){
      result.put(pReviewTeam.Id, pReviewTeam );
    }

    return result;
  }


}