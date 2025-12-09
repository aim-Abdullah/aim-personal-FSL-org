public  class ProdStudyModelData {

    public static void createData() {
    
        integer dataCount = [select count() from ProdStudy__c];
        if ( dataCount <> 0) return;
        
        List<ProdStudy__c> ProdStudyList = new List<ProdStudy__c>();
        
        ProdStudyList.add( new ProdStudy__c(Name='ProdStudy01', Prod_id__c=AmgenProductModel.getProductByName('Enbrel').id, 
            Study_id__c=StudyModel.StudyMapByTitle.get('Avanti Patient Use Study').Id));         
        ProdStudyList.add( new ProdStudy__c(Name='ProdStudy02', Prod_id__c=AmgenProductModel.getProductByName('Enbrel').id, 
            Study_id__c=StudyModel.StudyMapByTitle.get('Enbrel PsO Inflamm Joints Pilot Study').Id));         
        ProdStudyList.add( new ProdStudy__c(Name='ProdStudy02', Prod_id__c=AmgenProductModel.getProductByName('Enbrel').id, 
            Study_id__c=StudyModel.StudyMapByTitle.get('Enbrel RA Remission Study').Id));         
        ProdStudyList.add( new ProdStudy__c(Name='ProdStudy02', Prod_id__c=AmgenProductModel.getProductByName('Enbrel').id, 
            Study_id__c=StudyModel.StudyMapByTitle.get('Enbrel Pain Study - formulation buffer and needle impact').Id));         
            
        insert ProdStudyList;
                
     }
    
}