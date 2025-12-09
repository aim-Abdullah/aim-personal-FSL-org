@IsTest
public class PcSubMenuTest {

	@isTest
	public static void unitTest() {
		System.assertNotEquals(null, PcSubMenu.SearchSubMenu(true, false, false, false, false));
		System.assertNotEquals(null, PcSubMenu.PubSubMenu(true, false, false, false, false));
	}

}