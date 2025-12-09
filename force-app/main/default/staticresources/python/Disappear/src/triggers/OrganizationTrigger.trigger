trigger OrganizationTrigger on Organization__c (before insert, before update) {


	if ( Trigger.isInsert && Trigger.isBefore) {
		//trigger to make sure department Name is unique	
		set<string> NameSet  = new set<string>();
		for(Organization__c org : OrganizationModel.getAllOrganizationList()){
			NameSet.add(org.Name);
		}
		System.Debug('OrganizationTrigger nameset = '+ NameSet);
		for(Organization__c newOrg : Trigger.new){
			if ( NameSet.contains(newOrg.name)){
				string msg = 'Error : [' + newOrg.name +'] already exists as an Organization name';
				newOrg.addError(msg);
				System.Debug(msg);
			}
		}
	}


}