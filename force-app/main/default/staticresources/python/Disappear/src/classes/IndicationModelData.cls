public class IndicationModelData extends AppearBaseData {
    
    public static void deleteData() {
        AppearBaseData.purgeData('Indication__c');
    }
    
    public static Indication__c oncologyIndication {
    	get {
    		return IndicationModel.IndicationMapByName.get('Oncology');		
    	}
    }
    
    public static void createData() {
        
        integer dataCount = [select count() from Indication__c];
        if ( dataCount <> 0) return;
        
        List<Indication__c> IndicationList = new List<Indication__c>();

        IndicationList.add( new Indication__c(name= 'Not Applicable', Indication_Desc__c= 'Indication Not Applicable'   ));
        IndicationList.add( new Indication__c(name= 'Oncology', Indication_Desc__c= 'Oncology'  ));
        IndicationList.add( new Indication__c(name= 'Inflammation', Indication_Desc__c= 'Inflammation'  ));
        IndicationList.add( new Indication__c(name= 'T2 Diabetes', Indication_Desc__c= 'T2 Diabetes'   ));
        IndicationList.add( new Indication__c(name= 'Nephrology', Indication_Desc__c= 'Nephrology'    ));
        IndicationList.add( new Indication__c(name= 'Oral Mucositis', Indication_Desc__c= ''    ));
        IndicationList.add( new Indication__c(name= 'Cardiovascular', Indication_Desc__c= ''    ));
        IndicationList.add( new Indication__c(name= 'General Medicine', Indication_Desc__c= ''  ));
        IndicationList.add( new Indication__c(name= 'Nephrology/Metabolics', Indication_Desc__c= '' ));
        IndicationList.add( new Indication__c(name= 'Osteoporosis', Indication_Desc__c= ''  ));
        IndicationList.add( new Indication__c(name= 'Neurobiology', Indication_Desc__c= ''  ));
        IndicationList.add( new Indication__c(name= 'Cardio-Renal', Indication_Desc__c= ''  ));
        IndicationList.add( new Indication__c(name= 'Anemia of Inflammation', Indication_Desc__c= ''    ));
        IndicationList.add( new Indication__c(name= 'CKD Not Dialysis', Indication_Desc__c= ''  ));
        IndicationList.add( new Indication__c(name= 'Dialysis', Indication_Desc__c= ''  ));
        IndicationList.add( new Indication__c(name= 'Heart Failure', Indication_Desc__c= '' ));
        IndicationList.add( new Indication__c(name= 'Hospital/New indications', Indication_Desc__c= ''  ));
        IndicationList.add( new Indication__c(name= 'Oncology-unspecified', Indication_Desc__c= ''  ));
        IndicationList.add( new Indication__c(name= 'Rheumatology', Indication_Desc__c= ''  ));
        IndicationList.add( new Indication__c(name= 'Urology', Indication_Desc__c= ''   ));
        IndicationList.add( new Indication__c(name= 'Alt. Form. & Proc.', Indication_Desc__c= ''    ));
        IndicationList.add( new Indication__c(name= 'Dermatology', Indication_Desc__c= ''   ));
        IndicationList.add( new Indication__c(name= 'Psoriasis', Indication_Desc__c= '' ));
        IndicationList.add( new Indication__c(name= 'Psoriatic Arthritis', Indication_Desc__c= ''   ));
        IndicationList.add( new Indication__c(name= 'No indication', Indication_Desc__c= '' ));
        IndicationList.add( new Indication__c(name= 'Non Dialysis', Indication_Desc__c= ''  ));
        IndicationList.add( new Indication__c(name= 'Parkinsons Disease', Indication_Desc__c= ''    ));
        IndicationList.add( new Indication__c(name= 'Anemia', Indication_Desc__c= ''    ));
        IndicationList.add( new Indication__c(name= 'Neutropenia', Indication_Desc__c= ''   ));
        IndicationList.add( new Indication__c(name= 'Ankylosing Spondylitis', Indication_Desc__c= ''   ));        
        IndicationList.add( new Indication__c(name= 'ITP', Indication_Desc__c= 'Immune Thrombocytopenic Purpura'    ));
        IndicationList.add( new Indication__c(name= 'Secondary Hyperparathyroidism', Indication_Desc__c= '' ));     
        insert IndicationList;
    
    }

}