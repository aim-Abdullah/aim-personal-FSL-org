trigger CGT_ServiceAppointmentTrigger on ServiceAppointment (before delete) {


    for(ServiceAppointment sa: trigger.old){
        if(sa.Subject.contains('Please donot delete')){
             sa.addError('Reference data cannot be deleted.' + sa.Subject);
        
        }
    
    }

}