public class AppearDataScriptController {
	
	public string dataScriptValues { get; private set; }
	
	RecordType departmentStatusRecType = RecordTypeModel.LookupRecordType('Status__c','Department_Status');
	RecordType globalStatusRecType = RecordTypeModel.LookupRecordType('Status__c','Global Status');
	RecordType autoInsertRecType = RecordTypeModel.LookupRecordType('Status__c','AutoInsert');
	
	public void StatusDataScript() {
		string result = '';
		for( Status__c status : StatusModel.StatusList) {
			result = result + genStatus(status) + '<br/>';
		}
		
		dataScriptValues = result;
	}
	
	private string genStatus(Status__c status){
		string result = 'statusList.add( new status__c(' +
			'name= \''+status.Name+'\', '+
			'displayOrder__c='+status.displayOrder__c+', '+
			'Stage__c = \''+status.Stage__c+'\', ';
			
			
		if ( status.RecordTypeId == departmentStatusRecType.id ) {	
			result += 'RecordTypeId = departmentStatusRecType.id));';		
		} else if ( status.RecordTypeId == globalStatusRecType.id ) {	
			result += 'RecordTypeId = globalStatusRecType.id));';	
		} else if ( status.RecordTypeId == autoInsertRecType.id ) {	
			result += 'RecordTypeId = autoInsertRecType.id));';	
		}
		
		return result;
	}

}