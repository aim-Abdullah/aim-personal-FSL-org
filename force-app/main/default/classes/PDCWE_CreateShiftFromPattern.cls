public class PDCWE_CreateShiftFromPattern{

  @InvocableMethod(label='Create Shift Invocable')
  public static List<String> createShiftFromPatternMethod(List<ShiftVariablesWrapper> flowSelectedValues){
   
   List<String> returnValue = new List<String>();
   
   System.debug('PDCWE_CreateShiftFromPattern :: ' + flowSelectedValues);
  
   
       
   return returnValue;
  
  }
  
  
  public class ShiftVariablesWrapper{
  
   @InvocableVariable
   public Id shiftPatternId;
   
   @InvocableVariable
   public Date shiftStartDate;
      
   @InvocableVariable
   public String shiftEndType;
   
   @InvocableVariable
   public Date shiftEndDate;
   
   @InvocableVariable
   public Integer shiftEndNumberOfOccurence;
   
   @InvocableVariable
   public String shiftStatus;
   
   @InvocableVariable
   public Id shiftRecordSetFilterId;
   
   @InvocableVariable
   public Id serviceTerritoryId;
   
   @InvocableVariable
   public Id serviceResourceId;
   
   
  }


}