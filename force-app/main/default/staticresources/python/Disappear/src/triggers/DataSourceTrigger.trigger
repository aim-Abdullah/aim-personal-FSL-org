trigger DataSourceTrigger on DataSource__c (before insert, before update) {

	if ( Trigger.isInsert  && Trigger.isBefore) {
		//trigger to make sure DataSource Name is unique

		set<string> nameSet  = new set<string>();
		for(DataSource__c rec : DataSourceModel.getAllDataSources()){
			nameSet.add(rec.Name);
		}
		
		for(DataSource__c newDataSource : Trigger.new){
			if ( nameSet.contains(newDataSource.name)){
				newDataSource.addError('Error : [' + newDataSource.name +'] already exists as a DataSource');   
			}
		}		
	}
}