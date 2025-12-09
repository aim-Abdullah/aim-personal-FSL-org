trigger calcBusinessHours on Publication__c (before insert, before update) {
// Author:  Temeko Richardson
// Description:  Ensures all dates on the publication are associated to working days (including non-holidays) based on the AMGEN 
// company calendar.  This will also include other calendar verifications for the EU organization for their working hours and holidays
// to ensure deadlines are calculated properly.

if ( !AppearTriggerActivationModel.isCalcBusinessHourTriggerActive) {
    return;
}

BusinessHours stdBusinessHours = [select id from businesshours where isDefault = true];

for (Publication__c p : Trigger.new) {
        if (((p.PST_Approval_Submission_Date__c != NULL) || (p.FPR_Due_Date__c != NULL)) && (stdBusinessHours != NULL) && (p.Publication_Title__c != NULL)) 
        {
            if (p.PST_Approval_Submission_Date__c != NULL)
            {
                Date dConvert = p.PST_Approval_Submission_Date__c;
                Datetime dt = datetime.newInstance(dConvert.year(), dConvert.month(),dConvert.day());

                // Work should be expected to be completed normally work Monday - Friday except holidays according to the Company Hours.  
                p.PST_Approval_Submission_Date__c = date.newinstance(BusinessHours.add (stdBusinessHours.id, dt, 23 * 60 * 1000L).year(), BusinessHours.add (stdBusinessHours.id, dt, 23 * 60 * 1000L).month(),BusinessHours.add (stdBusinessHours.id, dt, 23 * 60 * 1000L).day());
            }
            if (p.FPR_Due_Date__c != NULL)
            {
                Date dConvertFPR = p.FPR_Due_Date__c;
                Datetime dtFPR = datetime.newInstance(dConvertFPR.year(), dConvertFPR.month(),dConvertFPR.day());

                // Work should be expected to be completed normally work Monday - Friday except holidays according to the Company Hours.  
                p.FPR_Due_Date__c = date.newinstance(BusinessHours.add (stdBusinessHours.id, dtFPR, 23 * 60 * 1000L).year(), BusinessHours.add (stdBusinessHours.id, dtFPR, 23 * 60 * 1000L).month(),BusinessHours.add (stdBusinessHours.id, dtFPR, 23 * 60 * 1000L).day());       
            }
        }
    }
}