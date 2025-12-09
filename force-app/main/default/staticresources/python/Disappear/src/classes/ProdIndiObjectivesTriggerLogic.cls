/*******************************************************************************************************
 * $Id$ : ProdIndiObjectivesTriggerLogic
 * $Created Date$ : 2014/04/11
 * $Author$ : Sesha Kurmana
 * $Description$ : This class is used to incorporate logic for handling updates on ProdIndiObjective__c.
 *******************************************************************************************************/
public with sharing class ProdIndiObjectivesTriggerLogic {
	
	public static void handleAutomaticExpirationOfSS(List<ProdIndiObjective__c> prodIndObjList)
	{
    	if ( prodIndObjList == null || prodIndObjList.size() == 0) {
			return;
		}
        
        for (ProdIndiObjective__c prodIndObj : prodIndObjList)
		{
			if(prodIndObj.IsLogicallyDeleted__c) {
				List<ProdIndObjSciStatement__c> prodIndObjSS = [SELECT Id, Name, ScientificStatement__c 
																	FROM ProdIndObjSciStatement__c
																	where Product_Indication_Objective__c = :prodIndObj.Id];
				
				for (ProdIndObjSciStatement__c prodIndObjSSLoop : prodIndObjSS)
				{
					prodIndObjSSLoop.IsLogicallyDeleted__c = true;
				}
				
				update prodIndObjSS;
				
				AppLogModel.LogDebug('ProdIndiObjectivesTriggerLogic::AutomaticExpirationOfSS', 'Updated the isExpired Flag successfully on all the Scientific Statements for Objective:: '+ prodIndObj.Name);
        	}
		}
		
        AppLogModel.flushLogs();
    }
}