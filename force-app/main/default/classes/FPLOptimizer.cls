public class FPLOptimizer {
  @InvocableMethod(label='FPL Schedule Optimizer' description='Action to Optimize appointments in a given territory')
  public static void optimizerActionCall(List<Id> lstServiceTerritoryIds) {
    
    DateTime start=Datetime.now();
    DateTime finish=Datetime.now().addDays(3);
    
    System.debug('Param Val :: ' + lstServiceTerritoryIds );
    
    List<Id> lstServiceTerritories = new List<Id>();
    //lstServiceTerritories.add('0Hh0b000000cIwsCAE');
    lstServiceTerritories = lstServiceTerritoryIds.clone();
    
    System.debug('Cloned Val :: ' + lstServiceTerritories );
    
    FSL.OAASRequest oaasRequest = new FSL.OAASRequest();
    oaasRequest.allTasksMode = true;
    oaasRequest.filterFieldAPIName = null;
    oaasRequest.start = start;
    oaasRequest.finish = finish;
    oaasRequest.includeServicesWithEmptyLocation = false;
    oaasRequest.locations = lstServiceTerritories;
    oaasRequest.schedulingPolicyID = 'a0Y5g0000008a2nEAA';
    
    FSL.OAAS oaas = new FSL.OAAS();
    id optRequest = oaas.optimize(oaasRequest);
    
    System.debug('Confirm Request Id :: ' + optRequest );
    
  }
}