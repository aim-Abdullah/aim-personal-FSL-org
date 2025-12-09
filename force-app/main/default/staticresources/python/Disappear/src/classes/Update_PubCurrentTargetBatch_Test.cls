@IsTest
public class Update_PubCurrentTargetBatch_Test{
 
    public static testMethod void testMethod_1(){
     Test.startTest();
        
       Publication__c pub1 = UnitTestData.PublicationNew('TestPub ABC');
        
       Meeting__c testMeeting = new Meeting__c(MeetingName255__c = 'testMeetingABC', Meeting_name__c = 'testMeetingABC');
       insert  testMeeting;
       System.assertEquals('testMeetingABC', testMeeting.MeetingName255__c);
        
       PubStatus__c pubStatus = [SELECT Id,Submission_Cycle__c,IsCurrentSubmissionCycleForPub__c  from PubStatus__c WHERE Publication_id__c=:pub1.Id AND IsCurrentSubmissionCycleForPub__c =true limit 1];
       pubStatus.Meeting__c =testMeeting.Id;
       update  pubStatus;
        
       pub1.PubStatus__c = pubStatus.id;
       pub1.Meeting__c =  testMeeting.Id;
       pub1.Current_Target__c =  testMeeting.MeetingName255__c;
       pub1.Target_Type__c = 'Meeting';
       update pub1;
       System.assertEquals('testMeetingABC', pub1.Current_Target__c); 
       
       SubmissionCycle__c subCycle = [SELECT Id FROM SubmissionCycle__c WHERE Id=: pubStatus.Submission_Cycle__c] ;
       subCycle.Target_Type__c = 'Meeting';
       subCycle.Publication__c = pub1.Id;
       subCycle.Meeting__c = testMeeting.Id;
       update subCycle;
        
       testMeeting.Meeting_Name__c = 'abcdeftrt';
       update testMeeting;
       System.assertEquals('abcdeftrt', testMeeting.Meeting_Name__c); 
       
       targetUpdate_SchedulerClass.schedule_Method();
            
    Test.stopTest();
    }
    
    
    public static testMethod void testMethod_2(){
     Test.startTest();
        
       Publication__c pub2 = UnitTestData.PublicationNew('TestPub ABC2'); 
        
       Journal__c testJournal = new Journal__c(Journal_Name__c = 'testJournalABC', JournalName255__c = 'testJournalABC');
       insert  testJournal;
       System.assertEquals('testJournalABC', testJournal.JournalName255__c); 
        
       PubStatus__c pubStatus = [SELECT Id,Submission_Cycle__c,IsCurrentSubmissionCycleForPub__c  from PubStatus__c WHERE Publication_id__c=:pub2.Id AND IsCurrentSubmissionCycleForPub__c =true limit 1];
       pubStatus.Journal__c =testJournal.Id;
       update  pubStatus;
        
       pub2.PubStatus__c = pubStatus.id;
       pub2.Journal__c =  testJournal.Id;
       pub2.Current_Target__c =  testJournal.JournalName255__c;
       pub2.Target_Type__c = 'Journal';
       update pub2;
       System.assertEquals('testJournalABC', pub2.Current_Target__c); 
       
       SubmissionCycle__c subCycle = [SELECT Id FROM SubmissionCycle__c WHERE Id=: pubStatus.Submission_Cycle__c] ;
       subCycle.Target_Type__c = 'Journal';
       subCycle.Publication__c = pub2.Id;
       subCycle.Journal__c = testJournal.Id;
       update subCycle;
        
       testJournal.Journal_Name__c = 'abcdeftrt';
       update testJournal;
       System.assertEquals('abcdeftrt', testJournal.Journal_Name__c); 
       
       targetUpdate_SchedulerClass.schedule_Method();
            
    Test.stopTest();
    }
}