@IsTest
public class AmgenProductModelTest {

    @IsTest
    public static void UnitTest() {
        
        AmgenProductModelData.createData();
        
        System.assertNotEquals(null, AmgenProductModel.AllProducts);
        System.assertNotEquals(null, AmgenProductModel.AllProductNames);

        System.assertNotEquals(null, AmgenProductModel.AmgenProductMapByName);
        System.assert(AmgenProductModel.AmgenProductMapByName.size() > 10);
        
        System.assertNotEquals(null, AmgenProductModel.getProductByName('ABP 215'));
        
        AmgenProduct__c enbrel = AmgenProductModel.getProductByName('Enbrel');
        System.assertNotEquals(null, enbrel);
        System.assert(enbrel.isEnbrel__c);
        
         
        System.assertEquals(null, AmgenProductModel.getProductByName('Not a product'));
        
        AmgenProduct__c product = AmgenProductModel.AmgenProductMapByName.get('ABP 215');
        System.assertNotEquals(null, product);
        System.assert('ABP 215' == product.name);
        
        System.assertNotEquals(null, AmgenProductModel.AmgenProductMap);
    
        Set<id> prodIdSet = new Set<Id>();
        prodIdSet.add(product.id);
        System.assertNotEquals(null, AmgenProductModel.getProductById(prodIdSet));
        
    
        System.assertNotEquals(null, AmgenProductModelData.amg103mt103);
    }

}