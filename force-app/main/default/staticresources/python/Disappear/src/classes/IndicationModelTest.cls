@IsTest
public class IndicationModelTest {

    @IsTest
    public static void UnitTest() {
    
        IndicationModelData.CreateData();
        
        IndicationModel.getIndicationByName('Does not exists');
        System.Assert(IndicationModel.AllIndicationNames.size() > 0);
        
		System.assertNotEquals(null,IndicationModelData.oncologyIndication);
        
	}


}