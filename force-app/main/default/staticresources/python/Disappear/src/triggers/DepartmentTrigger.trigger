trigger DepartmentTrigger on Department__c (before insert) {

	
	if ( Trigger.isInsert && Trigger.isBefore) {
		//trigger to make sure department Name is unique
		set<string> deptNameSet  = new set<string>();
		for(Department__c dept : DepartmentModel.getAllDepartmentList()){
			deptNameSet.add(dept.Name);
		}
		for(Department__c newDept : Trigger.new){
			if ( deptNameSet.contains(newDept.name)){
				string msg = 'Error : [' + newDept.name +'] already exists as a department name';
				newDept.addError(msg);
				System.Debug(msg);
			}
		}
	}	
	
}