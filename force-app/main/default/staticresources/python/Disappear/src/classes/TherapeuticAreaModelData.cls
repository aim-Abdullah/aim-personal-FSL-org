public class TherapeuticAreaModelData {
    
	public static TherapeuticArea__c oncologyTA {
		get {
			return TherapeuticAreaModel.TaMap.get('Oncology');
		}
	}
    public static void createData() {
        
        integer dataCount = [select count() from TherapeuticArea__c];
        if ( dataCount <> 0) return;
        
        List<TherapeuticArea__c> taList = new List<TherapeuticArea__c>();
        
        taList.add(new TherapeuticArea__c(name ='Bone'));
        taList.add(new TherapeuticArea__c(name ='Cardiovascular'));
        taList.add(new TherapeuticArea__c(name ='Inflammation'));
        taList.add(new TherapeuticArea__c(name ='Nephrology/Metabolics'));
        taList.add(new TherapeuticArea__c(name ='Oncology'));
        taList.add(new TherapeuticArea__c(name ='Not Applicable'));
        
        insert taList;
        
    }
}