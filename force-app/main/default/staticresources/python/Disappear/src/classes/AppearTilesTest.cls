@IsTest
public class AppearTilesTest {

	@IsTest
	public static void UnitTest() {
		PcTile separatorTile =  AppearTiles.AppearSeparator();
		System.assertNotEquals(null,separatorTile);
		
		PcTile testPubTile =  AppearTiles.GetPubTile('menuName','tileName','pubId');
		System.assertNotEquals(null,separatorTile);
		
		//Test PubTiles
		ProfileTabModelData.createData();
		
		List<PcTile> tiles = AppearTiles.pubTiles('Publication Tab','activePubId');
	}

}