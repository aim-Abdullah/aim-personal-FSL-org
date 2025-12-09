public class ProductIndicationModelData {
    
    
	public static ProductIndication__c abarelixOncologyProdInd {
    	get {
    		return ProductIndicationModel.ProductIndicationNameMap.get('Abarelix - Oncology');		
    	}
    }

    public static void createData() {
        
        integer dataCount = [select count() from ProductIndication__c];
        if ( dataCount <> 0) return;
        
        List<ProductIndication__c> ProductIndicationList = new List<ProductIndication__c>();

        ProductIndicationList.add( new ProductIndication__c(name= 'ABP 215 - Not Applicable' , Product__c=AmgenProductModel.getProductByName('ABP 215').id, 
            Indication__c=IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = null ));
            
        ProductIndicationList.add( new ProductIndication__c(name= 'ABP 494 - Not Applicable' , Product__c=AmgenProductModel.getProductByName('ABP 494').id,
            Indication__c=IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = NULL  ));        
        ProductIndicationList.add( new ProductIndication__c(name= 'ABP 501 - Not Applicable' , Product__c=AmgenProductModel.getProductByName('ABP 501').id, 
            Indication__c=IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = NULL ));    
        ProductIndicationList.add( new ProductIndication__c(name= 'ABP 710 - Not Applicable' , Product__c=AmgenProductModel.getProductByName('ABP 710').id, 
            Indication__c=IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = NULL ));    
        ProductIndicationList.add( new ProductIndication__c(name= 'ABP 798 - Not Applicable' , Product__c=AmgenProductModel.getProductByName('ABP 798').id, 
            Indication__c=IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = NULL  ));    
        ProductIndicationList.add( new ProductIndication__c(name= 'ABP 980 - Not Applicable' , Product__c=AmgenProductModel.getProductByName('ABP 980').id,
            Indication__c=IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = NULL  ));
        
        
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 103 (MT103) - Oncology' , 
       	   Product__c=AmgenProductModelData.amg103mt103.id, 
           Indication__c=IndicationModelData.oncologyIndication.id, StartDate__c = null, EndDate__c = null,
           Therapeutic_Area__c= TherapeuticAreaModelData.OncologyTA.Id   ));    
                  
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 108 - Not Applicable' , Product__c=AmgenProductModel.getProductByName('AMG 108').id, 
            Indication__c=IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = datetime.newInstance(2009, 22, 1) ));         
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 108 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 108').id, 
            Indication__c=IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id ));  
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 108 - T2 Diabetes' , Product__c=AmgenProductModel.getProductByName('AMG 108').id, 
            Indication__c=IndicationModel.getIndicationByName('T2 Diabetes').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id ));     
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 110 (MT110) - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 110 (MT110)').id, 
            Indication__c=IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null    ));     
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 112 (MT112) - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 112 (MT112)').id, 
            Indication__c=IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null    ));     
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 114 - Nephrology' , Product__c=AmgenProductModel.getProductByName('AMG 114').id, 
            Indication__c=IndicationModel.getIndicationByName('Nephrology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));    
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 114 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 114').id, 
            Indication__c=IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null, Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id    ));     
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 131 - Oral Mucositis' , Product__c=AmgenProductModel.getProductByName('AMG 131').id, 
            Indication__c=IndicationModel.getIndicationByName('Oral Mucositis').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));    
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 139 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 139').id, 
            Indication__c=IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null    ));     
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 145 - Cardiovascular' , Product__c=AmgenProductModel.getProductByName('AMG 145').id, 
            Indication__c=IndicationModel.getIndicationByName('Cardiovascular').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));        
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 151 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 151').id, 
            Indication__c=IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = datetime.newInstance(2013, 13, 2),Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id  ));     
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 151 - Nephrology/Metabolics' , Product__c=AmgenProductModel.getProductByName('AMG 151').id, 
            Indication__c=IndicationModel.getIndicationByName('Nephrology/Metabolics').id, StartDate__c = null, EndDate__c = null   ));     
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 157 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 157').id, 
            Indication__c=IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = date.newInstance(2008, 12, 6), EndDate__c = null   ));     
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 167 - Osteoporosis' , Product__c=AmgenProductModel.getProductByName('AMG 167').id, 
            Indication__c=IndicationModel.getIndicationByName('Osteoporosis').id, StartDate__c = date.newInstance(2009, 26, 1), EndDate__c = null   ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 172 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 172').id, 
            Indication__c=IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 181 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 181').id, 
            Indication__c=IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 191 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 191').id, 
            Indication__c=IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id ));
            
        
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 195 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 195').id, 
            Indication__c=IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 203 (MT203) - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 203 (MT203)').id, 
            Indication__c=IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null    ));
        
        
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 208 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 208').id,
            Indication__c=IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 211 (MT111) - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 211 (MT111)').id,
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));       
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 212 (MT212) - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 212 (MT212)').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 218 (MT118) - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 218 (MT118)').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 221 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 221').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 222 - General Medicine', Product__c=AmgenProductModel.getProductByName('AMG 222').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 223 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 223').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 232 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 232').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 245 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 245').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 247 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 247').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 273 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 273').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 277 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 277').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 282 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 282').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 287 - T2 Diabetes' , Product__c=AmgenProductModel.getProductByName('AMG 287').id, 
            Indication__c= IndicationModel.getIndicationByName('T2 Diabetes').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c=NULL    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 303 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 303').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 317 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 317').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 319 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 319').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 330 (MT114) - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 330 (MT114)').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 331 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 331').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 333 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 333').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 334 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 334').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 337 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 337').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 357 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 357').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 379 - Neurobiology' , Product__c=AmgenProductModel.getProductByName('AMG 379').id, 
            Indication__c= IndicationModel.getIndicationByName('Neurobiology').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 401 (MT201) - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 401 (MT201)').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 403 - Neurobiology' , Product__c=AmgenProductModel.getProductByName('AMG 403').id, 
            Indication__c= IndicationModel.getIndicationByName('Neurobiology').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 416 - Nephrology' , Product__c=AmgenProductModel.getProductByName('AMG 416').id, 
            Indication__c= IndicationModel.getIndicationByName('Nephrology').id, StartDate__c = null, EndDate__c = NULL));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 420 (MT120) - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 420 (MT120)').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 429 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 429').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 434 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 434').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 458 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 458').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 477 - T2 Diabetes' , Product__c=AmgenProductModel.getProductByName('AMG 477').id, 
            Indication__c= IndicationModel.getIndicationByName('T2 Diabetes').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= NULL ));
        
        ProductIndicationList.add( new ProductIndication__c(name= 'Aranesp - CKD Not Dialysis' , Product__c=AmgenProductModel.getProductByName('Aranesp').id, 
            Indication__c= IndicationModel.getIndicationByName('CKD Not Dialysis').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Aranesp - Dialysis' , Product__c=AmgenProductModel.getProductByName('Aranesp').id, 
            Indication__c= IndicationModel.getIndicationByName('Dialysis').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Epogen - Dialysis' , Product__c=AmgenProductModel.getProductByName('Epogen').id, 
            Indication__c= IndicationModel.getIndicationByName('Dialysis').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id    ));
        
        //Enbrel
        
        ProductIndicationList.add( new ProductIndication__c(name= 'Enbrel - Dermatology' , Product__c=AmgenProductModel.getProductByName('Enbrel').id, 
            Indication__c= IndicationModel.getIndicationByName('Dermatology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Enbrel - Psoriasis' , Product__c=AmgenProductModel.getProductByName('Enbrel').id, 
            Indication__c= IndicationModel.getIndicationByName('Psoriasis').id, StartDate__c = null, EndDate__c = dateTime.newInstance(2006, 22, 3),Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Enbrel - Psoriatic Arthritis' , Product__c=AmgenProductModel.getProductByName('Enbrel').id, 
            Indication__c= IndicationModel.getIndicationByName('Psoriatic Arthritis').id, StartDate__c = null, EndDate__c = dateTime.newInstance(2006, 22, 3),Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Enbrel - Rheumatology' , Product__c=AmgenProductModel.getProductByName('Enbrel').id, 
            Indication__c= IndicationModel.getIndicationByName('Rheumatology').id, StartDate__c = null, EndDate__c = null, Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id )); 
         
        ProductIndicationList.add( new ProductIndication__c(name= 'Abarelix - Oncology' , Product__c=AmgenProductModel.getProductByName('Abarelix').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null    ));
            
        /*   
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 492 - Bone' , Product__c=AmgenProductModel.getProductByName('AMG 429').id, 
            Indication__c= IndicationModel.getIndicationByName('Bone').id, StartDate__c = null, EndDate__c = null ));
           
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 511 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 511').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 517 - Neurobiology' , Product__c=AmgenProductModel.getProductByName('AMG 517').id, 
            Indication__c= IndicationModel.getIndicationByName('Neurobiology').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 548 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 548').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 557 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 557').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 575 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 575').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 579 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 579').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 580 - Neurobiology' , Product__c=AmgenProductModel.getProductByName('AMG 580').id, 
            Indication__c= IndicationModel.getIndicationByName('Neurobiology').id, StartDate__c = null, EndDate__c = NULL  ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 581 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 581').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 595 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 595').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 601 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 601').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 623 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 623').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 641 - Nephrology' , Product__c=AmgenProductModel.getProductByName('AMG 641').id, 
            Indication__c= IndicationModel.getIndicationByName('Nephrology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));   
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 655 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 655').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 706 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 706').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 714 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 714').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 719 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 719').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 725 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 725').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 729 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 729').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 745 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 745').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 747 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 747').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 753 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 753').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 761 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 761').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 763 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 763').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 777 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 777').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 780 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 780').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 811 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 811').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 819 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 819').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = dateTime.newInstance(2006, 27, 3) ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 819 - Neurobiology' , Product__c=AmgenProductModel.getProductByName('AMG 819').id, 
            Indication__c= IndicationModel.getIndicationByName('Neurobiology').id, StartDate__c = date.newInstance(2006, 27, 3), EndDate__c = null ));        
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 820 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 820').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 827 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 827').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 847 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 847').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 853 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 853').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 864 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 864').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 876 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 876').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 888 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 888').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 891 - Anemia of Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 891').id, 
            Indication__c= IndicationModel.getIndicationByName('Anemia of Inflammation').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 900 - General Medicine' , Product__c=AmgenProductModel.getProductByName('AMG 900').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 900 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 900').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 947 - Inflammation' , Product__c=AmgenProductModel.getProductByName('AMG 947').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 949 - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 949').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'AMG 951 (Apo2L/TRAIL) - Oncology' , Product__c=AmgenProductModel.getProductByName('AMG 951 (Apo2L/TRAIL)').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));

        ProductIndicationList.add( new ProductIndication__c(name= 'Alfimeprase - General Medicine' , Product__c=AmgenProductModel.getProductByName('Alfimeprase').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Aranesp - Heart Failure' , Product__c=AmgenProductModel.getProductByName('Aranesp').id, 
            Indication__c= IndicationModel.getIndicationByName('Heart Failure').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id));
        ProductIndicationList.add( new ProductIndication__c(name= 'Aranesp - Hospital/New indications' , Product__c=AmgenProductModel.getProductByName('Aranesp').id, 
            Indication__c= IndicationModel.getIndicationByName('Hospital/New indications').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id));
        ProductIndicationList.add( new ProductIndication__c(name= 'Aranesp - Oncology' , Product__c=AmgenProductModel.getProductByName('Aranesp').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Avrend/Mobista - Oncology' , Product__c=AmgenProductModel.getProductByName('Avrend/Mobista').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'BDNF - Neurobiology' , Product__c=AmgenProductModel.getProductByName('BDNF').id, 
            Indication__c= IndicationModel.getIndicationByName('Neurobiology').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Biosimilars GPPT - Not Applicable' , Product__c=AmgenProductModel.getProductByName('Biosimilars GPPT').id, 
            Indication__c= IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Biosimilars Teams - Not Applicable' , Product__c=AmgenProductModel.getProductByName('Biosimilars Teams').id, 
            Indication__c= IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = NULL));
        ProductIndicationList.add( new ProductIndication__c(name= 'CD40 Ligand - Inflammation' , Product__c=AmgenProductModel.getProductByName('CD40 Ligand').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Denosumab - Oncology' , Product__c=AmgenProductModel.getProductByName('Denosumab').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Denosumab - Oncology-unspecified' , Product__c=AmgenProductModel.getProductByName('Denosumab').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology-unspecified').id, StartDate__c = date.newInstance(2011, 6, 8), EndDate__c = dateTime.newInstance(2012, 31, 1),Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Denosumab - Rheumatology' , Product__c=AmgenProductModel.getProductByName('Denosumab').id, 
            Indication__c= IndicationModel.getIndicationByName('Rheumatology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Denosumab - Urology' , Product__c=AmgenProductModel.getProductByName('Denosumab').id, 
            Indication__c= IndicationModel.getIndicationByName('Urology').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id));
        ProductIndicationList.add( new ProductIndication__c(name= 'Enbrel - Alt. Form. & Proc.' , Product__c=AmgenProductModel.getProductByName('Enbrel').id, 
            Indication__c= IndicationModel.getIndicationByName('Alt. Form. & Proc.').id, StartDate__c = null, EndDate__c = dateTime.newInstance(2007, 23, 7),Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id   ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Epogen - Nephrology' , Product__c=AmgenProductModel.getProductByName('Epogen').id, 
            Indication__c= IndicationModel.getIndicationByName('Nephrology').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Epogen - No indication' , Product__c=AmgenProductModel.getProductByName('Epogen').id, 
            Indication__c= IndicationModel.getIndicationByName('No indication').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Epogen - Non Dialysis' , Product__c=AmgenProductModel.getProductByName('Epogen').id, 
            Indication__c= IndicationModel.getIndicationByName('Non Dialysis').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Epratuzumab - Oncology' , Product__c=AmgenProductModel.getProductByName('Epratuzumab').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'GDNF - Parkinsons Disease' , Product__c=AmgenProductModel.getProductByName('GDNF').id, 
            Indication__c= IndicationModel.getIndicationByName('Parkinsons Disease').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id   ));
        ProductIndicationList.add( new ProductIndication__c(name= 'GM-CSF - Inflammation' , Product__c=AmgenProductModel.getProductByName('GM-CSF').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Ganitumab (AMG 479) - Oncology' , Product__c=AmgenProductModel.getProductByName('Ganitumab (AMG 479)').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'H010 - Anemia' , Product__c=AmgenProductModel.getProductByName('H010').id, 
            Indication__c= IndicationModel.getIndicationByName('Anemia').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'IL-15 - Inflammation' , Product__c=AmgenProductModel.getProductByName('IL-15').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'IL-33 - Inflammation' , Product__c=AmgenProductModel.getProductByName('IL-33').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Infergen - General Medicine' , Product__c=AmgenProductModel.getProductByName('Infergen').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Kepivance - Oral Mucositis' , Product__c=AmgenProductModel.getProductByName('Kepivance').id, 
            Indication__c= IndicationModel.getIndicationByName('Oral Mucositis').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Kineret - Rheumatology' , Product__c=AmgenProductModel.getProductByName('Kineret').id, 
            Indication__c= IndicationModel.getIndicationByName('Rheumatology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Inflammation').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Leptin - General Medicine' , Product__c=AmgenProductModel.getProductByName('Leptin').id, 
            Indication__c= IndicationModel.getIndicationByName('General Medicine').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'MGDF - Oncology' , Product__c=AmgenProductModel.getProductByName('MGDF').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'NABT (FPA Admin Use Only) - Not Applicable' , Product__c=AmgenProductModel.getProductByName('NABT (FPA Admin Use Only)').id, 
            Indication__c= IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = dateTime.newInstance(2012, 18, 6) ));
        ProductIndicationList.add( new ProductIndication__c(name= 'NABT Non Pubs - Not Applicable' , Product__c=AmgenProductModel.getProductByName('NABT Non Pubs').id, 
            Indication__c= IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c=dateTime.newInstance(2012, 8, 5)    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'NOVANTRONE - Inflammation' , Product__c=AmgenProductModel.getProductByName('NOVANTRONE').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Neulasta - Neutropenia' , Product__c=AmgenProductModel.getProductByName('Neulasta').id, 
            Indication__c= IndicationModel.getIndicationByName('Neutropenia').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Neupogen - Neutropenia' , Product__c=AmgenProductModel.getProductByName('Neupogen').id, 
            Indication__c= IndicationModel.getIndicationByName('Neutropenia').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Not Applicable - Not Applicable' , Product__c=AmgenProductModel.getProductByName('Not Applicable').id, 
            Indication__c= IndicationModel.getIndicationByName('Not Applicable').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Nplate - ITP' , Product__c=AmgenProductModel.getProductByName('Nplate').id, 
            Indication__c= IndicationModel.getIndicationByName('ITP').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Nuvance - Inflammation' , Product__c=AmgenProductModel.getProductByName('Nuvance').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'PEG sTNFRI - Inflammation' , Product__c=AmgenProductModel.getProductByName('PEG sTNFRI').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Prolia - Osteoporosis' , Product__c=AmgenProductModel.getProductByName('Prolia').id, 
            Indication__c= IndicationModel.getIndicationByName('Osteoporosis').id, StartDate__c = null, EndDate__c = null, Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'RANK-Fc/OPG-Fc/OPG - Oncology' , Product__c=AmgenProductModel.getProductByName('RANK-Fc/OPG-Fc/OPG').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null, Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id     ));
        ProductIndicationList.add( new ProductIndication__c(name= 'RANK-Fc/OPG-Fc/OPG - Osteoporosis' , Product__c=AmgenProductModel.getProductByName('RANK-Fc/OPG-Fc/OPG').id, 
            Indication__c= IndicationModel.getIndicationByName('Osteoporosis').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'RANK-Fc/OPG-Fc/OPG - Rheumatology' , Product__c=AmgenProductModel.getProductByName('RANK-Fc/OPG-Fc/OPG').id, 
            Indication__c= IndicationModel.getIndicationByName('Rheumatology').id, StartDate__c = null, EndDate__c = null, Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Romosozumab (AMG 785) - Osteoporosis' , Product__c=AmgenProductModel.getProductByName('Romosozumab (AMG 785)').id, 
            Indication__c= IndicationModel.getIndicationByName('Osteoporosis').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'SLPI - Inflammation' , Product__c=AmgenProductModel.getProductByName('SLPI').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Sensipar - Nephrology' , Product__c=AmgenProductModel.getProductByName('Sensipar').id, 
            Indication__c= IndicationModel.getIndicationByName('Nephrology').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id));
        ProductIndicationList.add( new ProductIndication__c(name= 'Sensipar - Secondary Hyperparathyroidism' , Product__c=AmgenProductModel.getProductByName('Sensipar').id, 
            Indication__c= IndicationModel.getIndicationByName('Secondary Hyperparathyroidism').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Stemgen - Oncology' , Product__c=AmgenProductModel.getProductByName('Stemgen').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= NULL ));
        ProductIndicationList.add( new ProductIndication__c(name= 'T-VEC - Oncology' , Product__c=AmgenProductModel.getProductByName('T-VEC').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'TIMP-3 - Inflammation' , Product__c=AmgenProductModel.getProductByName('TIMP-3').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'TSLP - Inflammation' , Product__c=AmgenProductModel.getProductByName('TSLP').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Thioplex - Inflammation' , Product__c=AmgenProductModel.getProductByName('Thioplex').id, 
            Indication__c= IndicationModel.getIndicationByName('Inflammation').id, StartDate__c = null, EndDate__c = null    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Trebananib (AMG 386) - Oncology' , Product__c=AmgenProductModel.getProductByName('Trebananib (AMG 386)').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id    ));
        ProductIndicationList.add( new ProductIndication__c(name= 'Vectibix - Oncology' , Product__c=AmgenProductModel.getProductByName('Vectibix').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null, Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id  ));
        ProductIndicationList.add( new ProductIndication__c(name= 'omecamtivmecarbil (AMG 423) - Cardiovascular' , Product__c=AmgenProductModel.getProductByName('omecamtivmecarbil (AMG 423)').id, 
            Indication__c= IndicationModel.getIndicationByName('Cardiovascular').id, StartDate__c = null, EndDate__c = NULL , Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Bone').Id ));
        ProductIndicationList.add( new ProductIndication__c(name= 'rilotumumab(AMG 102) - Oncology' , Product__c=AmgenProductModel.getProductByName('rilotumumab(AMG 102)').id, 
            Indication__c= IndicationModel.getIndicationByName('Oncology').id, StartDate__c = null, EndDate__c = null,Therapeutic_Area__c= TherapeuticAreaModel.TaMap.get('Oncology').Id    ));
                       
        */
        insert ProductIndicationList;
    
    }

}