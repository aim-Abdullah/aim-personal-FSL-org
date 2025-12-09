/***************************************************************************************************
 * $Id$ : ReviewTeamTriggerLogic
 * $Created Date$ : 2014/04/03
 * $Author$ : Sudha
 * $Description$ : This class is used to replace logic from Trigger to Apex Class. 
 ***********************************************************************************************/
public class ReviewTeamTriggerLogic {
    public static void validateReviewTeam(List<Review_Team__c> reviewTeamList){
        Set<Id> SetProductIndicationId = New Set<Id>();
        List<Review_Team__c> ListReviewTeam = new List<Review_Team__c>();
        for(Review_Team__c rt : reviewTeamList){
            string ProductIndicationName = 
            ProductIndicationModel.getProductIndicationName(rt.Product_Indication__c);
            SetProductIndicationId.add(rt.Product_Indication__c);
            ListReviewTeam.add(rt);
            /*if (ProductIndicationName == null ) {
            string msg = 'Error : invalid Review Team - Production_Indication ['+
            rt.Product_Indication__c +'] is not valid.';
            rt.addError(msg); 
            AppLogModel.LogError('ReviewTeamTrigger', msg);
            }*/
            if(ProductIndicationName != null) {            
                string DataSourceName = DataSourceModel.getDataSourceName(rt.Data_Source__c);
                string SubGroupName = SubGroupModel.getSubGroupName(rt.SubGroup__c);
                
                if ( DataSourceName == null && SubGroupName == null) {
                    string msg = 'Error : invalid Review Team - need at least one of DataSource or SubGroup';
                    rt.addError(msg); 
                    AppLogModel.LogError('ReviewTeamTrigger', msg);                 
                } 
                else if (DataSourceName == null) {
                    rt.name = string.format('{0} - {1}',
                    new string[]{ProductIndicationName, SubGroupName});
                } 
                else if (SubGroupName == null) {
                    rt.name = string.format('{0} - {1}',
                    new string[]{ProductIndicationName, DataSourceName});
                } 
                else {
                    rt.name = string.format('{0} - {1} - {2}',
                    new string[]{ProductIndicationName, DataSourceName, SubGroupName});
                }
            }
        }
        //Code unit started for CR: #139
        //To show error message for expired product indication.
        Map<Id,String> MapExpiredProdIndication = ProductIndicationModel.getMapAllExpiredProductIndicationName(SetProductIndicationId);
        if(MapExpiredProdIndication.size()!=0){
            for(Review_Team__c rtAll: ListReviewTeam){
                if(MapExpiredProdIndication.containsKey(rtAll.Product_Indication__c)){
                    string msg = 'Invalid Review Team - Production_Indication ['+
                    MapExpiredProdIndication.get(rtAll.Product_Indication__r.Name) +'] has expired.';
                    rtAll.addError(msg); 
                    AppLogModel.LogError('ReviewTeamTrigger', msg); 
                }
            }
        }
        //Code unit Ended for CR: #139
    }
}