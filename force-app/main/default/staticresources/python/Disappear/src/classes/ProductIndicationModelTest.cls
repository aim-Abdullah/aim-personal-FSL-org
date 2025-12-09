@IsTest
public class ProductIndicationModelTest {

	@IsTest
	public static void UnitTest() {
		CreateData();
		
		System.assertNotEquals(null, ProductIndicationModel.ProductIndicationList);
		System.assert( ProductIndicationModel.ProductIndicationList.size() > 0);
		
		System.assertNotEquals(null, ProductIndicationModel.ProductIndicationNameMap);
		System.assert( ProductIndicationModel.ProductIndicationNameMap.size() > 0);
		ProductIndication__c prodInd = ProductIndicationModel.ProductIndicationNameMap.get('AMG 108 - Not Applicable');
		System.assertNotEquals(null, prodInd);
		
		System.assertNotEquals(null, ProductIndicationModel.ProductIndicationMap);
		System.assert( ProductIndicationModel.ProductIndicationMap.size() > 0);
		ProductIndication__c prodInd2 = ProductIndicationModel.ProductIndicationMap.get(prodInd.id);
		System.assertNotEquals(null, prodInd2);
		
		System.assert(prodInd.id == prodInd2.id);
		System.assert(prodInd.Name == prodInd2.Name);
		
		System.assertNotEquals(null, ProductIndicationModelData.abarelixOncologyProdInd);
		
		///
		//Enbrel
		
		for(ProductIndication__c pi : ProductIndicationModel.ProductIndicationList) {
			if ( pi.name.contains('Enbrel')){
				System.assert(pi.isEnbrel__c);			
			} else {
				System.assert(!pi.isEnbrel__c);			
			}
		}
		//////////
		System.assertNotEquals(null, IndicationModel.IndicationMapByName);
		System.assert(IndicationModel.IndicationMapByName.size() > 5);
		
		Set<id> indicationIds = new Set<id>();
		indicationIds.add(IndicationModel.IndicationMapByName.get('Oncology').id);
		indicationIds.add(IndicationModel.IndicationMapByName.get('Nephrology').id);
		
		
		Map<id, ProductIndication__c> amap = ProductIndicationModel.getProductIndicationByIndication(indicationIds);
		System.assertNotEquals(null, amap);
		System.assertNotEquals(null, amap.size() > 0);
    }
	
	private static void CreateData(){
	    TherapeuticAreaModelData.CreateData();
        AmgenProductModelData.createData();
        IndicationModelData.createData();
        
        ProductIndicationModelData.createData();	
	}
}