public  class ReviewTeamModelData {

	public static Review_Team__c abarelixOncologyDevelopmentSmpReviewTeam {
		get {
			return ReviewTeamModel.ReviewTeamNameMap.get('Epogen - Dialysis - GRAAS - GRAAS');
		}
	}

	public static Review_Team__c aranespCkdNotDialysisDevelopmentIrdReviewTeam {
		get {
			return ReviewTeamModel.ReviewTeamNameMap.get('Aranesp - CKD Not Dialysis - Development - Global Dev - LACAN');
		}
	}
	
	public static Review_Team__c aranespCkdNotDialysisOperationCommericalQualityReviewTeam {
		get {
			return ReviewTeamModel.ReviewTeamNameMap.get('Aranesp - CKD Not Dialysis - Operations - Ops - Comm Quality');
		}
	}
	 
	
    public static void createData() {
    
        integer dataCount = [select count() from Review_Team__c];
        if ( dataCount <> 0) {
        	return;
        }
        
        List<Review_Team__c> ReviewTeamList = new List<Review_Team__c>();
        
        
        	DataSource__c developmentDataSource = DataSourceModelData.Development;
        	System.assertNotEquals(null, developmentDataSource);
        	
        	ProductIndication__c abarelixOncologyProdInd = ProductIndicationModelData.abarelixOncologyProdInd; 
        	System.assertNotEquals(null, abarelixOncologyProdInd);

			//abarelixOncologyDevelopmentSmpReviewTeam
            ReviewTeamList.add( new Review_Team__c(Name='RT0', Data_Source__c=developmentDataSource.Id, 
            	subGroup__c=SubGroupModelData.DevelopmentSmpSubGroup.Id,
            	Product_Indication__c=ProductIndicationModelData.abarelixOncologyProdInd.Id));    
        
        	//aranespCkdNotDialysisDevelopmentIrdReviewTeam
            ReviewTeamList.add( new Review_Team__c(Name='RT1', Data_Source__c=developmentDataSource.Id, 
            	subGroup__c=SubGroupModelData.DevelopmentIrdSubGroup.Id,
            	Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - CKD Not Dialysis').Id));         
            	
            ReviewTeamList.add( new Review_Team__c(Name='RT2', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Development').Id, 
            	subGroup__c=SubGroupModel.SubGroupNameMap.get('Global Dev - LACAN').Id, 
            	Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - CKD Not Dialysis').Id));
            ReviewTeamList.add( new Review_Team__c(Name='RT3', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Development').Id, 
            	subGroup__c=SubGroupModel.SubGroupNameMap.get('Global Dev - US').Id, 
            	Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - CKD Not Dialysis').Id));       
            	  
            ReviewTeamList.add( new Review_Team__c(Name='RT4', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Operations').Id, 
            	subGroup__c=SubGroupModel.SubGroupNameMap.get('Ops - Comm Quality').Id, 
            	Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - CKD Not Dialysis').Id));         
            ReviewTeamList.add( new Review_Team__c(Name='RT5', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Operations').Id, 
            	subGroup__c=SubGroupModel.SubGroupNameMap.get('Ops - DP&DD').Id, 
            	Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - CKD Not Dialysis').Id));         
            ReviewTeamList.add( new Review_Team__c(Name='RT6', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Operations').Id, 
            	subGroup__c=SubGroupModel.SubGroupNameMap.get('Ops - Mfg Sciences & Tech').Id, 
            	Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - CKD Not Dialysis').Id));         
            ReviewTeamList.add( new Review_Team__c(Name='RT7', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Operations').Id, 
            	subGroup__c=SubGroupModel.SubGroupNameMap.get('Ops - Other').Id, 
            	Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - Dialysis').Id));         
            ReviewTeamList.add( new Review_Team__c(Name='RT8', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Operations').Id, 
            	subGroup__c=SubGroupModel.SubGroupNameMap.get('Ops - Quality Admin').Id, 
            	Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - Dialysis').Id));         
            	
            	
            ReviewTeamList.add( new Review_Team__c(Name='RT9', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - CBSS').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - Dialysis').Id));         
			ReviewTeamList.add( new Review_Team__c(Name='RT11', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - Early Dev').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - Dialysis').Id));         
			ReviewTeamList.add( new Review_Team__c(Name='RT10', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - Genome Analysis').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - Dialysis').Id));         
			ReviewTeamList.add( new Review_Team__c(Name='RT12', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - Hem & Onc').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - Dialysis').Id));         
			ReviewTeamList.add( new Review_Team__c(Name='RT13', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - Inflammation').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Aranesp - Dialysis').Id));         
			ReviewTeamList.add( new Review_Team__c(Name='RT14', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - Met. Disorders').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id));         
			ReviewTeamList.add( new Review_Team__c(Name='RT15', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - Neuroscience').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id));         
			ReviewTeamList.add( new Review_Team__c(Name='RT16', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - Other').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id));         
			ReviewTeamList.add( new Review_Team__c(Name='RT17', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - P&PD').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id));         
			ReviewTeamList.add( new Review_Team__c(Name='RT19', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - Pharmaceutics').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id));         
			ReviewTeamList.add( new Review_Team__c(Name='RT18', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - PKDM').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id));         
			ReviewTeamList.add( new Review_Team__c(Name='RT20', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - SMP&PD').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id));
			ReviewTeamList.add( new Review_Team__c(Name='RT21', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - Therapeutic Discovery').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id));
			ReviewTeamList.add( new Review_Team__c(Name='RT22', Data_Source__c= DataSourceModel.DataSourceMapByName.get('Research').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('Research - Therapeutic Innovation').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id));         
            
            
            ReviewTeamList.add( new Review_Team__c(Name='RT23', Data_Source__c= DataSourceModel.DataSourceMapByName.get('GRAAS').Id, 
				subGroup__c=SubGroupModel.SubGroupNameMap.get('GRAAS').Id, 
				Product_Indication__c=ProductIndicationModel.ProductIndicationNameMap.get('Epogen - Dialysis').Id));         
                    
         insert ReviewTeamList;
                
     }
    
}