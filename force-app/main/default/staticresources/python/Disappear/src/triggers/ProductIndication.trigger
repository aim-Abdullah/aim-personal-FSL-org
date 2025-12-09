trigger ProductIndication on ProductIndication__c (before insert, before update) {


	if (( Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore) {
		
		for(ProductIndication__c prodInd : trigger.new){
			
			AmgenProduct__c product = AmgenProductModel.AmgenProductMap.get(prodInd.Product__c);
			Indication__c indication = IndicationModel.IndicationMap.get(prodInd.Indication__c);
			
			if ( product <> null && indication <> null) {
				prodInd.Name = product.name + ' - '+ indication.name;
			} else {
				AppLogModel.LogError('ProductIndicationTrigger', 'Cannot find reference for prodInd');	
			}
			
			
			//ProductIndication__c.isEnbrel__c is a formula - based on product - no need to set
		}
		
		AppLogModel.flushLogs();
	}	
}