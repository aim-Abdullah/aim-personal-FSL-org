trigger calcBusinessHours_Status on PubStatus__c (before insert, before update) {
// Author:  Temeko Richardson
// Description:  Ensures all dates for the publication status are associated to working days (including non-holidays) based on the AMGEN 
// company calendar.  This will also include other calendar verifications for the EU organization for their working hours and holidays
// to ensure deadlines are calculated properly.
// Note: Holiday calculations had to be done separately with SOQL because the diff function for BusinessHours does not take into account
// holidays - only weekends and business hours.

if ( !AppearTriggerActivationModel.isCalcBusinessHourStatusTriggerActive) {
    return;
}


BusinessHours stdBusinessHours = [select id from businesshours where isDefault = true];
Integer int_hdays = 0;

for (PubStatus__c ps : Trigger.new) {
        if (((ps.TargetDate__c !=NULL) || (ps.RevisedTargetDate__c !=NULL) || (ps.ActualDate__c != NULL)) && (stdBusinessHours != NULL)) 
        {
            if ((ps.TargetDate__c != NULL) && (ps.RevisedTargetDate__c != NULL))
            {
            
         
                
                //Convert the Target Date and the Revised Target Date to AMGEN working days
                Date dConvert = ps.TargetDate__c;
                Datetime dt = datetime.newInstance(dConvert.year(), dConvert.month(),dConvert.day());
                ps.TargetDate__c = date.newinstance(BusinessHours.add (stdBusinessHours.id, dt, 23 * 60 * 1000L).year(), BusinessHours.add (stdBusinessHours.id, dt, 23 * 60 * 1000L).month(),BusinessHours.add (stdBusinessHours.id, dt, 23 * 60 * 1000L).day());
                
                Date dConvertRTD = ps.RevisedTargetDate__c;
                Datetime dtRTD= datetime.newInstance(dConvertRTD.year(), dConvertRTD.month(),dConvertRTD.day());
                ps.RevisedTargetDate__c = date.newinstance(BusinessHours.add (stdBusinessHours.id, dtRTD, 23 * 60 * 1000L).year(), BusinessHours.add (stdBusinessHours.id, dtRTD, 23 * 60 * 1000L).month(),BusinessHours.add (stdBusinessHours.id, dtRTD, 23 * 60 * 1000L).day());       
                
                //Calculate the number of days before the Revised Target Date taking into account only AMGEN working days
                 if (System.Now() < ps.RevisedTargetDate__c)
                 {
                     int_hdays = [Select count() from Holiday where ActivityDate > Today and ActivityDate < :ps.RevisedTargetDate__c];
                     System.debug('rows: ' + int_hdays);
                     
                     Double timetoexpire = (BusinessHours.diff(stdBusinessHours.id, System.Now(), ps.RevisedTargetDate__c)/3600000.0)/9;
                     ps.Days_Before_Target__c = timetoexpire.intValue() - int_hdays;
                     ps.Days_Overdue__c = NULL;
                 }else if (ps.ActualDate__c == NULL)
                 //Calculate the number of days that the status is overdue taking into account only AMGEN Working days
                 {
                     int_hdays = [Select count() from Holiday where ActivityDate < Today and ActivityDate > :ps.RevisedTargetDate__c];
                     System.debug('rows: ' + int_hdays);
                    
                     Double timeoverdue = (BusinessHours.diff(stdBusinessHours.id, ps.RevisedTargetDate__c, System.Now())/3600000.0)/9;
                     ps.Days_Overdue__c = timeoverdue.intValue() - int_hdays;
                     ps.Days_Before_Target__c = NULL;
                 }
                 
                 //Calculate the number of days difference between the Target Date and the Revised Target Date
                 int_hdays = [Select count() from Holiday where ActivityDate > :ps.TargetDate__c and ActivityDate < :ps.RevisedTargetDate__c];
                 System.debug('rows: ' + int_hdays);
                 Double timeextended = (BusinessHours.diff(stdBusinessHours.id, ps.TargetDate__c, ps.RevisedTargetDate__c)/3600000.0)/9;
                 ps.Days_Extension__c = timeextended.intValue() - int_hdays;
                 
                 //Based on the actual date field being completed, calculate the number of days it took between the date of completion for the status
                 //and the Target Date as well as the Revised Target Date
                 if (ps.ActualDate__c !=NULL)
                 {
                     Date myDate = date.newinstance(ps.ActualDate__c.year(), ps.ActualDate__c.month(), ps.ActualDate__c.day());
                     int_hdays = [Select count() from Holiday where ActivityDate > :ps.TargetDate__c and ActivityDate < :myDate];
                     System.debug('rows: ' + int_hdays);
                     ps.Days_Before_Target__c = NULL;
                     Double timeorigtarget = (BusinessHours.diff(stdBusinessHours.id,ps.TargetDate__c, ps.ActualDate__c)/3600000.0)/9;
                     ps.Days_OrigTarget_Completion__c = timeorigtarget.intValue() - int_hdays;
               
                     int_hdays = [Select count() from Holiday where ActivityDate > :ps.RevisedTargetDate__c and ActivityDate < :mydate];
                     System.debug('rows: ' + int_hdays);
                     Double timeoverdue = (BusinessHours.diff(stdBusinessHours.id, ps.RevisedTargetDate__c, ps.ActualDate__c)/3600000.0)/9;
                     ps.Days_Overdue__c = timeoverdue.intValue() - int_hdays;    
                     ps.Days_RevTarget_Completion__c = ps.Days_Overdue__c;
                 }
                  
            }
            
            if ((ps.RevisedTargetDate__c == NULL) && (ps.TargetDate__c != NULL))
            {
                Date dConvert = ps.TargetDate__c;
                Datetime dt = datetime.newInstance(dConvert.year(), dConvert.month(),dConvert.day());
                ps.TargetDate__c = date.newinstance(BusinessHours.add (stdBusinessHours.id, dt, 23 * 60 * 1000L).year(), BusinessHours.add (stdBusinessHours.id, dt, 23 * 60 * 1000L).month(),BusinessHours.add (stdBusinessHours.id, dt, 23 * 60 * 1000L).day());
            
               if (System.Now() < ps.TargetDate__c)
                 {
                     int_hdays = [Select count() from Holiday where ActivityDate > Today and ActivityDate < :ps.TargetDate__c];
                     System.debug('rows: ' + int_hdays);
                     
                     Double timetoexpire = (BusinessHours.diff(stdBusinessHours.id, System.Now(), ps.TargetDate__c)/3600000.0)/9;
                     ps.Days_Before_Target__c = timetoexpire.intValue() - int_hdays;
                     ps.Days_Overdue__c = NULL;
                 }else if (ps.ActualDate__c == NULL)
                 {
                     int_hdays = [Select count() from Holiday where ActivityDate < Today and ActivityDate > :ps.TargetDate__c];
                     System.debug('rows: ' + int_hdays);
                  
                     Double timeoverdue = (BusinessHours.diff(stdBusinessHours.id, ps.TargetDate__c, System.Now())/3600000.0)/9;
                     ps.Days_Overdue__c = timeoverdue.intValue() - int_hdays;
                     ps.Days_Before_Target__c = NULL;
                 }
                ps.Days_Extension__c = NULL;
                
                if (ps.ActualDate__c !=NULL)
                { 
                   Date myDate = date.newinstance(ps.ActualDate__c.year(), ps.ActualDate__c.month(), ps.ActualDate__c.day());
                   int_hdays = [Select count() from Holiday where ActivityDate > :ps.TargetDate__c and ActivityDate < :mydate];
                   System.debug('rows: ' + int_hdays);
                   Double timeorigtarget = (BusinessHours.diff(stdBusinessHours.id, ps.TargetDate__c, ps.ActualDate__c)/3600000.0)/9;
                   ps.Days_OrigTarget_Completion__c = timeorigtarget.intValue() - int_hdays;
                   ps.Days_Overdue__c = ps.Days_OrigTarget_Completion__c;
                }
            }
        }
    }
}