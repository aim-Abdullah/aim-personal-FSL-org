@IsTest
public class MeetingModelTest {

	@IsTest
	public static void UnitTest(){
		
		System.assertNotEquals(null, MeetingModel.getAllMeetingList());
    	System.assertEquals(0, MeetingModel.getAllMeetingList().size());
    	
		MeetingModelData.createData();
		
		System.assertNotEquals(null, MeetingModel.MeetingList);
		System.assert(MeetingModel.MeetingList.size() > 0);
		
		
		System.assertNotEquals(null, MeetingModel.MeetingNameMap);
		Meeting__c meeting = MeetingModel.MeetingNameMap.get('Annual World PGx Summit');
		System.assertNotEquals(null, meeting);
		
		System.assertNotEquals(null, MeetingModel.MeetingMap);
		Meeting__c meeting2 = MeetingModel.MeetingMap.get(meeting.id);
		System.assertNotEquals(null, meeting2);
		System.assertEquals(meeting.name, meeting2.name);
		
		List<Meeting__c> meetings = MeetingModel.findMeetingsByName('Annual World');
		System.assertNotEquals(null, meetings);
		System.assert(meetings.size() > 0);
		
		MeetingModel.resetMeetingName255();
		
		MeetingModelData.deleteData();
		integer cnt = [select count() from Meeting__c];
		System.assertEquals(0, cnt);
		
		MeetingModelData.createData();
		
		
		string uniqueMtgName = MeetingModel.uniqueMeetingName('a',Date.today(), Date.Today().addDays(2),'ac','venue');
		
	}  

	@IsTest
	public static void UnitTestParseDate() {
		System.assertEquals(Date.ValueOf('2014-01-22'), MeetingModel.ScanDate('2014-01-22'));  
		System.assertEquals(Date.ValueOf('2014-01-22'), MeetingModel.ScanDate('01/22/2014'));  
		System.assertEquals(Date.ValueOf('2016-02-29'), MeetingModel.ScanDate('02/29/2016'));  
		System.assertEquals(null, MeetingModel.ScanDate('2014/02/29'));  
		System.assertEquals(null, MeetingModel.ScanDate('sdfasdfasdfasd'));  
		System.assertEquals(null, MeetingModel.ScanDate('20140229'));  
		System.assertEquals(null, MeetingModel.ScanDate(''));  
		//System.assertEquals(Date.ValueOf('2014-01-22'), MeetingModel.ScanDate('2014/01/22'));  
	}
	
}