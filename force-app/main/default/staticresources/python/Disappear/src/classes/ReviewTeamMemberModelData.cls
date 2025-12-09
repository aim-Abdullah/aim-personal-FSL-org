public  class ReviewTeamMemberModelData {

    /*public static void createData() {
    
        integer dataCount = [select count() from ReviewTeamMember__c];
        if ( dataCount <> 0) return;
        
        List<ReviewTeamMember__c> ReviewTeamMemberList = new List<ReviewTeamMember__c>();
                   
                   
            string RT1 = 'Aranesp - CKD Not Dialysis - Global Dev - LACAN';
            string RT2 = 'Aranesp - CKD Not Dialysis - Development - NAMT';
            string RT3 = 'Aranesp - CKD Not Dialysis - Development - GRAAS';       
            
           	Contact solange = AppearContactModel.findContactByName('Solange', 'Weiss')[0];    
			Contact melissa = AppearContactModel.findContactByName('Melissa', 'Seal')[0]; 
                   
            ReviewTeamMemberList.add(new ReviewTeamMember__c(Review_Team__c= ReviewTeamModel.ReviewTeamNameMap.get(RT1).Id ,
            	ReviewTeamMember__c=solange.id, Appear_Role__c=AppearRoleModel.AppearRoleMapByName.get('GPPL').Id));         
            ReviewTeamMemberList.add(new ReviewTeamMember__c(Review_Team__c= ReviewTeamModel.ReviewTeamNameMap.get(RT2).Id ,
            	ReviewTeamMember__c=melissa.id, Appear_Role__c=AppearRoleModel.AppearRoleMapByName.get('Medical Writer').Id));         
            ReviewTeamMemberList.add(new ReviewTeamMember__c(Review_Team__c= ReviewTeamModel.ReviewTeamNameMap.get(RT3).Id ,
            	ReviewTeamMember__c=solange.id, Appear_Role__c=AppearRoleModel.AppearRoleMapByName.get('GPPL').Id));         
            ReviewTeamMemberList.add(new ReviewTeamMember__c(Review_Team__c= ReviewTeamModel.ReviewTeamNameMap.get(RT3).Id ,
            	ReviewTeamMember__c=melissa.id, Appear_Role__c=AppearRoleModel.AppearRoleMapByName.get('Medical Writer').Id));         
      
            Insert ReviewTeamMemberList;
                
     }*/
    
}