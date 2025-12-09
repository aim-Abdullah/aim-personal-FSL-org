@IsTest
public class OrganizationModelTest {

    @IsTest
    public static void UnitTest() {
        OrganizationModelData.createData();
    
    	System.assertNotEquals(null, OrganizationModel.OrganizationList);
    	System.assert(OrganizationModel.OrganizationList.size() > 0);
    	System.assert(OrganizationModel.SponsoringOrganizationList.size() > 0);
    	
    	System.assertNotEquals(null, OrganizationModel.OrganizationNameMap);
    	System.assert(OrganizationModel.OrganizationNameMap.size() > 0);
    	
    	System.assertNotEquals(null, OrganizationModel.getOrganizationById(OrganizationModel.OrganizationList[0].Id));
    	
    	boolean caughtDupError = false;

    	try {
			Organization__c dupOrg = new Organization__c();
			dupOrg.name = 'Amgen';
			insert dupOrg;			
		} catch ( DMLException e){
			System.Debug(e);
			System.assert( e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
			caughtDupError = true;
		} finally {
			System.assert(caughtDupError);
		}
    	
    	
    	System.assertNotEquals(null, OrganizationModel.OrganizationNameMap.get('Amgen'));
    	System.assertNotEquals(null, OrganizationModel.OrganizationNameMap.get('Pfizer'));
    }
    
    
}