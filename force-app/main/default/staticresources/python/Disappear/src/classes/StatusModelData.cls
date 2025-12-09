public class StatusModelData {

	public static void createData() {
		
		integer dataCount = [select count() from Status__c];
		if ( dataCount <> 0) return;
		
		RecordType departmentStatusRecType = RecordTypeModel.LookupRecordType('Status__c','Department_Status');
		RecordType globalStatusRecType = RecordTypeModel.LookupRecordType('Status__c','Global Status');
		RecordType autoInsertRecType = RecordTypeModel.LookupRecordType('Status__c','AutoInsert');
		RecordType legacyStatusRecType = RecordTypeModel.LookupRecordType('Status__c','Legacy Status');
		
		List<Status__c> statusList = new List<Status__c>();

	//	statusList.add( new status__c(name= 'Pending Suggestion', displayOrder__c=5, Stage__c = 'Suggest', RecordTypeId = autoInsertRecType.id,PubRecordType__c='Suggestion'));
	
		statusList.add( new status__c(name= 'Unknown', displayOrder__c=5, Stage__c = 'Unknown', RecordTypeId=legacyStatusRecType.id, PubRecordType__c='Legacy'));
		statusList.add( new status__c(name= 'Pending Suggestion', displayOrder__c=10, Stage__c = 'Suggest', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Suggestion'));
		statusList.add( new status__c(name= 'Pending FPR Submission', displayOrder__c=20, Stage__c = 'FPR Only', RecordTypeId=autoInsertRecType.id, PubRecordType__c='FPR Only'));
		statusList.add( new status__c(name= 'Suggested', displayOrder__c=30, Stage__c = 'Suggest', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Suggested'));
		statusList.add( new status__c(name= 'Suggestion Rejected', displayOrder__c=40, Stage__c = 'Suggest', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Suggestion'));
		statusList.add( new status__c(name= 'Concept', displayOrder__c=50, Stage__c = 'Plan', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Plan'));
		statusList.add( new status__c(name= 'Proposal Complete', displayOrder__c=50, Stage__c = 'Execute', RecordTypeId=globalStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= 'Created', displayOrder__c=50, Stage__c = 'Execute', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= 'Started', displayOrder__c=60, Stage__c = 'Execute', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= 'Data Analysis Available', displayOrder__c=70, Stage__c = 'Execute', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= 'Author Agreements Sent', displayOrder__c=80, Stage__c = 'Execute', RecordTypeId=globalStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= 'Kick-Off Meeting Minutes / Memo', displayOrder__c=90, Stage__c = 'Execute', RecordTypeId=globalStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= 'Outline', displayOrder__c=100, Stage__c = 'Execute', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= 'Material Changes for New Target', displayOrder__c=110, Stage__c = 'Submit', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= 'Non-Material Changes for New Target', displayOrder__c=110, Stage__c = 'Submit', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= 'Draft', displayOrder__c=120, Stage__c = 'Execute', RecordTypeId=globalStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= '1st Draft Circulated', displayOrder__c=130, Stage__c = 'Execute', RecordTypeId=globalStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= '1st Draft Reviewed', displayOrder__c=140, Stage__c = 'Execute', RecordTypeId=globalStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= 'In FPR', displayOrder__c=150, Stage__c = 'Review', RecordTypeId=autoInsertRecType.id, PubRecordType__c='In FPR'));
		statusList.add( new status__c(name= 'Assigned to FPRC', displayOrder__c=160, Stage__c = 'Review', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Assigned to FPRC'));
		statusList.add( new status__c(name= 'Routed', displayOrder__c=170, Stage__c = 'Review', RecordTypeId=autoInsertRecType.id, PubRecordType__c='In FPR'));
		statusList.add( new status__c(name= 'FPR Withdrawn', displayOrder__c=180, Stage__c = 'Review', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Resubmit to FPR'));
		statusList.add( new status__c(name= 'Withheld', displayOrder__c=190, Stage__c = 'Review', RecordTypeId=legacyStatusRecType.id, PubRecordType__c='Legacy'));
		statusList.add( new status__c(name= 'FPR Withheld', displayOrder__c=200, Stage__c = 'Review', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Resubmit to FPR'));
		statusList.add( new status__c(name= 'Discussion Required', displayOrder__c=210, Stage__c = 'Review', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Review'));
		statusList.add( new status__c(name= 'Courtesy FPR Completed', displayOrder__c=220, Stage__c = 'Review', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Review'));
		statusList.add( new status__c(name= 'Courtesy FPR Completed with Comments', displayOrder__c=230, Stage__c = 'Review', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Review'));
		statusList.add( new status__c(name= 'FPR Completed', displayOrder__c=240, Stage__c = 'Review', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Review'));
		statusList.add( new status__c(name= 'FPR Completed with Comments', displayOrder__c=250, Stage__c = 'Review', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Review'));
		statusList.add( new status__c(name= 'Approved', displayOrder__c=260, Stage__c = 'Review', RecordTypeId=legacyStatusRecType.id, PubRecordType__c='Legacy'));
		statusList.add( new status__c(name= 'Not Approved by all Authors', displayOrder__c=270, Stage__c = 'Review', RecordTypeId=legacyStatusRecType.id, PubRecordType__c='Review'));
		statusList.add( new status__c(name= 'Material Changes for Authors', displayOrder__c=280, Stage__c = 'Submit', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Resubmit to FPR'));
		statusList.add( new status__c(name= 'Terminate FPR Cycle', displayOrder__c=290, Stage__c = 'Review', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Assigned to FPRC'));
		statusList.add( new status__c(name= 'Approved by all Authors', displayOrder__c=300, Stage__c = 'Review', RecordTypeId=globalStatusRecType.id, PubRecordType__c='Review'));
		statusList.add( new status__c(name= 'Submitted/Completed', displayOrder__c=310, Stage__c = 'Submit', RecordTypeId=globalStatusRecType.id, PubRecordType__c='Submit'));
		statusList.add( new status__c(name= 'Non-Material Change', displayOrder__c=330, Stage__c = 'Submit', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Submit'));
		statusList.add( new status__c(name= 'Resent', displayOrder__c=330, Stage__c = 'Submit', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Submit'));
		statusList.add( new status__c(name= 'Material Changes for Congress/Journal', displayOrder__c=330, Stage__c = 'Submit', RecordTypeId=autoInsertRecType.id, PubRecordType__c='Submit'));
		statusList.add( new status__c(name= 'Withdrawn from Target', displayOrder__c=340, Stage__c = 'Submit', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Submit'));
		statusList.add( new status__c(name= 'Accepted', displayOrder__c=340, Stage__c = 'Submit', RecordTypeId=globalStatusRecType.id, PubRecordType__c='Accepted Version'));
		statusList.add( new status__c(name= 'Online Early Release', displayOrder__c=350, Stage__c = 'Submit', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Accepted Version'));
		statusList.add( new status__c(name= 'Published/Presented', displayOrder__c=360, Stage__c = 'Submit', RecordTypeId=globalStatusRecType.id, PubRecordType__c='Accepted Version'));
		statusList.add( new status__c(name= 'Rejected', displayOrder__c=370, Stage__c = 'Submit', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Plan'));
		statusList.add( new status__c(name= 'On Hold', displayOrder__c=380, Stage__c = 'Execute', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Execute'));
		statusList.add( new status__c(name= 'Cancelled', displayOrder__c=390, Stage__c = 'Plan', RecordTypeId=departmentStatusRecType.id, PubRecordType__c='Plan'));
			
		database.insert (statusList, true);
	}
}