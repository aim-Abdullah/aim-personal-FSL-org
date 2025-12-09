trigger SubGroupTrigger on SubGroup__c (before insert) {

	if ( Trigger.isInsert  && Trigger.isBefore) {
		//trigger to make sure SubGroup Name is unique
		set<string> nameSet  = new set<string>();
		for(SubGroup__c sg : SubGroupModel.getAllSubGroups()){
			nameSet.add(sg.Name);
		}
		
		//SubGroup name should be unique - even if they have different Data Sources as parent
		for(SubGroup__c newSubGroup : Trigger.new){
			if ( nameSet.contains(newSubGroup.name)){
				newSubGroup.addError('Error : [' + newSubGroup.name +'] already exists as a SubGroup name');   
			}
		}		
	}	
}