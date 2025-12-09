@isTest
public class AppLogModelTest {

    @isTest
    public static void unitTest() {
        AppLogModel.setLogLevelDebug();
        //reduce flushsize 
        AppLogModel.appLogSizeLimit = 3;
        String s;
        Id id1;
        ApplogModel.LogInfo(s,s,id1);
        ApplogModel.LogError(s,s,id1);
        ApplogModel.LogDebug(s,s,id1);
        
        insertAppLogData();
        
        List<AppLog__c> logs = AppLogModel.readAppLog('CreatePub', -1);
        
        System.assertNotEquals(null, logs);
        System.assertEquals(2, logs.size());
        
        System.assertNotEquals(null, logs[0].id);
        System.assertEquals('CreatePub', logs[0].MessageType__c);
        System.Debug(logs[0].Message__c);
        System.assert(logs[0].Message__c.contains('This is the error'));
        System.Debug(logs[0].Description__c);
        System.assert(logs[0].Description__c.contains('This is the source'));   
        AppLogmodel.SetLogLevelInfo();
        AppLogModel.SetLogLevelErrorOnly();
        Integer i ;
        String s1;
        String Msg1='test',msg2='test1',msg3='test2';
        ApplogModel.LogLevel = i;
        AppLogModel.CleanupAppLog(); 
        ApplogModel.SetLogLevel(msg3);  
        AppLogModel.LogInfo(msg1,msg2);
        AppLogModel.LogInfo(msg1,msg2,msg3);  
        AppLogModel.LogDebug(msg1,msg2,msg3);
        AppLogModel.LogDebug(msg1,msg2); 
        AppLogModel.LogError(msg1,msg2,msg3);
        AppLogModel.LogError(msg1,msg2); 
        AppLogModel.TruncateAppLog();
        
        ApplogModel.FlushLogs();
    }
    
    public static void insertAppLogData() {
        AppLogModel.LogInfo('CreatePub', 'Creating pub with title xyz', 'desc');
        
        List<string> messages = new List<string>();
        AppLogModel.LogInfo( 'CreatePub', messages);
        
        messages.add('1st message');
        
        AppLogModel.LogInfo('CreatePub', messages);
        messages.add('2nd message');
        AppLogModel.LogInfo( 'CreatePub', messages);
        
        Id anId = null;
        AppLogModel.LogInfo(
            'CreatePub', 
            strByLength('This is the error',275), 
            strByLength('This is the source',31000), anId );    
            
            
        AppLogModel.LogDebug('test 2 Parameters', 'a message');
        AppLogModel.LogDebug('test 3 Parameters', 'a message', 'a description', anId);  
        AppLogModel.flushLogs('AppLogModelTest::insertAppLogData');     
    }
    
    private static string strByLength(string source, integer length) {
        if ( source == null) {
            source = '';
        }
        while ( source.length() < length) {
            source +='a';
        }
        return source;
    }
}