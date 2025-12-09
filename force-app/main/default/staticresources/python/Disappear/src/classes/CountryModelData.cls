public class CountryModelData{

    @IsTest
    public static void UnitTest() {
        RegionModelData.createData();
        CountryModelData.createData();
    }

    public static void createData() {
    
         integer dataCount = [select count() from Country__c];
        if ( dataCount <> 0) return;
        
        List<Country__c> CountryList = new List<Country__c>();
        
         CountryList.add( new Country__c(name= 'Australia' , RegionId__c=RegionModel.RegionNameMap.get('LACAN').id));
         CountryList.add( new Country__c(name= 'Austria' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Belgium' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Albania' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Argentina' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Brazil' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Canada' , RegionId__c=RegionModel.RegionNameMap.get('LACAN').id));
         CountryList.add( new Country__c(name= 'Chile' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'China' , RegionId__c=RegionModel.RegionNameMap.get('China').id));
         CountryList.add( new Country__c(name= 'Colombia' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Czech Republic' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Denmark' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Finland' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'France' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Germany' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Greece' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Guatemala' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Hong Kong' , RegionId__c=RegionModel.RegionNameMap.get('Asia Pacific').id));
         CountryList.add( new Country__c(name= 'Hungary' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Iceland' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'India' , RegionId__c=RegionModel.RegionNameMap.get('Asia Pacific').id));
         CountryList.add( new Country__c(name= 'Ireland' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Israel' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Italy' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Japan' , RegionId__c=RegionModel.RegionNameMap.get('Japan').id));
         CountryList.add( new Country__c(name= 'Korea' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Lithuania' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Luxembourg' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Mexico' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Morocco' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Netherlands' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'New Zealand' , RegionId__c=RegionModel.RegionNameMap.get('LACAN').id));
         CountryList.add( new Country__c(name= 'Norway' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Pakistan' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Philippines' , RegionId__c=RegionModel.RegionNameMap.get('Asia Pacific').id));
         CountryList.add( new Country__c(name= 'Portugal' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Romania' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Singapore' , RegionId__c=RegionModel.RegionNameMap.get('Asia Pacific').id));
         CountryList.add( new Country__c(name= 'South Africa' , RegionId__c=RegionModel.RegionNameMap.get('EEMEA').id));
         CountryList.add( new Country__c(name= 'Spain' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Sweden' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Switzerland' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Taiwan' , RegionId__c=RegionModel.RegionNameMap.get('Asia Pacific').id));
         CountryList.add( new Country__c(name= 'Thailand' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'Turkey' , RegionId__c=RegionModel.RegionNameMap.get('EEMEA').id));
         CountryList.add( new Country__c(name= 'United States' , RegionId__c=RegionModel.RegionNameMap.get('US').id));
         CountryList.add( new Country__c(name= 'United Kingdom' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Unknown' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id)); 
         CountryList.add( new Country__c(name= 'Uruguay' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id));
         CountryList.add( new Country__c(name= 'United Arab Emirates' , RegionId__c=RegionModel.RegionNameMap.get('EEMEA').id));
         CountryList.add( new Country__c(name= 'Russia' , RegionId__c=RegionModel.RegionNameMap.get('EEMEA').id)); 
         CountryList.add( new Country__c(name= 'Poland' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Bulgaria' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Slovakia' , RegionId__c=RegionModel.RegionNameMap.get('Europe').id));
         CountryList.add( new Country__c(name= 'Estonia' , RegionId__c=RegionModel.RegionNameMap.get('Unknown').id)); 
         CountryList.add( new Country__c(name= 'South Korea' , RegionId__c=RegionModel.RegionNameMap.get('Asia Pacific').id));
         
         insert CountryList;
    }

}