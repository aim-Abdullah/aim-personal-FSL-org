import { LightningElement } from 'lwc';
/*
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { refreshApex } from '@salesforce/apex';
import getResourceAvailability from '@salesforce/apex/CGT_BookAppointments_Controller.getResourceAvailability';
import initializeUserSetup from '@salesforce/apex/CGT_BookAppointments_Controller.initializeUserSetup';
import getAssignedStudyforSDL from '@salesforce/apex/CGT_BookAppointments_Controller.getAssignedStudyforSDL';
import getSubjectsforStudy from '@salesforce/apex/CGT_BookAppointments_Controller.getSubjectsforStudy';
import updateRefrencedServiceAppointment from '@salesforce/apex/CGT_BookAppointments_Controller.updateRefrencedServiceAppointment';
import createAppointments from '@salesforce/apex/CGT_BookAppointments_Controller.createAppointments';
import currentUserId from '@salesforce/user/Id';
import GSK_Support_Email_Id from '@salesforce/label/c.GSK_Support_Email_Id';

const DELAY = 300;
let i=0;
const months = ["JAN", "FEB", "MAR","APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];*/

export default class CodefromSandbox extends LightningElement {

    /*
    @api recordId;
    @track studylist =[];
    @track selectedValue = '';
    @track error;
    @track errorType;
    @track disablePicklist = false;
    isStudyAvailable = false;
    isSubjectSelected = false;
    noAppointmentSlot = false;

    @track wrapperList;
    @track isLoading =false;

    //variables for Patients list view
    @track selectedPatientValue = '';
    @track patientList = [];
    subjectSearchKey = ''; 

    @track selectedAppointment;
    currentUserId = currentUserId;

    currentPageNumber = 0;
    isInvokedfromNextPrevious = false;
    
    //ConnectedCallback :: STARTS
    connectedCallback() {
        this.isLoading = true;

        initializeUserSetup()
        .then( result => {
                if(result == 'User Setup Record Created' || result != null ){
                    this.isLoading = false;
                    console.log( `InitializeUserSetup :: ${result}` );
                }
                else{
                    isStudyAvailable = false;
                    this.error = 'User Setup Issue. Please report to your System Administrator';
                    
                }
            }
        ).catch( error => {
            this.error = error;
            this.isLoading = false;
            console.log (`No Dummy Record Found`);
            }
        );
    
    }//ConnectedCallback :: ENDS

    //@wire :: getAssignedStudyforSDL :: STARTS
    @wire(getAssignedStudyforSDL)
    assignedStudies({error, data}){
        if(data){

            if(data.length === 0){
                //console.log('assignedStudies :: No Study Available '  );
                this.errorType = 'warning';
                this.error = `No active Study is currently assigned to you.\n Please contact ${GSK_Support_Email_Id}`;
                this.isStudyAvailable = false;
            }
            else{
                this.isStudyAvailable = true;

                for(i=0; i<data.length; i++) {
                    //console.log('Study id=' + data[i].Study__c);
                    this.studylist = [...this.studylist ,{value: data[i].Id , label: data[i].Name}];                                   
                }                
                this.error = undefined;
            }

        }else if(error){
            this.error = error;
            this.isStudyAvailable = false;
        }
    }//@wire :: getAssignedStudyforSDL :: ENDS

    //@wire for Subject Search :: STARTS
    @wire(getSubjectsforStudy, {studyId: '$selectedValue' , subjectSearchKey: '$subjectSearchKey'})
    allSubjectsforStudy;
    handleKeyChange(event) {
        this.isSubjectSelected =false;
        if(event.target.value.length >= 3){
            this.template.querySelector('.subject_list').classList.remove('slds-hide');
        }else{
            this.template.querySelector('.subject_list').classList.add('slds-hide');
        }
        
        window.clearTimeout(this.delayTimeout);
        const subjectSearchKey = event.target.value;
        console.log('checkserarchKey :: ' + JSON.stringify(event.target.value) );
        if(subjectSearchKey === '' ){
            this.selectedPatientValue = '';
        }
        this.delayTimeout = setTimeout(() => {
            this.subjectSearchKey = subjectSearchKey;
        }, DELAY);
    }   
    handleSelectedPatient(event){ 
        console.log('handleSelectedPatient :: ' + JSON.stringify(event.currentTarget.dataset));
        this.selectedPatientValue = event.currentTarget.dataset.id;
        this.subjectSearchKey = event.currentTarget.dataset.item;
        this.isSubjectSelected = true;
        this.template.querySelector('.subject_list').classList.add('slds-hide');
    }    
    //@wire for Subject Search :: ENDS

    get studyAssignedList(){
        return this.studylist;
    }
    
    handleSelectedStudy(event) {
        const selectedOption = event.detail.value;
        this.selectedValue = selectedOption;
    }
*/
    /*get studyPatientList(){
        return this.patientList;
    }*/

/*    
    //JavaScript Method :: handleGetAppointments :: STARTS
    @wire (getResourceAvailability, {resourceId : '$recordId'} )     
    allAppointmentValues;  

    handleGetAppointments(event){

        if(this.selectedValue != ''){
            this.noAppointmentSlot = false;
            this.disablePicklist = true;
            this.isLoading = true;
            if(!this.isInvokedfromNextPrevious){
                console.log('handleGetAppointments :: called Main '  );
                this.currentPageNumber = 0;
            }

           updateRefrencedServiceAppointment(
                {
                    studyId : this.selectedValue,
                    serviceResourceId : this.recordId,
                    currentPageNumber : this.currentPageNumber
                }
            )
            .then(result =>{

                if(result === 'Success'){
                    refreshApex(this.allAppointmentValues)
                    .then(() => {
                        const studyName = this.studylist.find(item => item.value == this.selectedValue).label;
                        this.noAppointmentSlot = false;
                        this.wrapperList = this.allAppointmentValues.data;
                        this.isLoading = false;
                        if(this.wrapperList.length === 0){
                            this.noAppointmentSlot = true;
                            this.errorType = 'warning';
                            this.error = `No Apheresis slot is currenlty Available for Selected Study ${studyName} in the time period displayed.\n Please select another time period or contact ${GSK_Support_Email_Id}`;
                            this.disablePicklist = false;
                        }
                    });

                    

                }
                else if(result == 'Study Not Assigned'){
                    const studyName = this.studylist.find(item => item.value == this.selectedValue).label;
                    this.noAppointmentSlot = true;
                    this.errorType = 'warning';
                    this.error = `The selected Study ${studyName} is not assigned to this clinic.\nPlease select another study or contact ${GSK_Support_Email_Id}`;
                    this.disablePicklist = false;
                    this.isLoading = false;

                }

            })
            .catch(error =>{
                this.isLoading = false;
                this.error = error;
                this.disablePicklist = false;
                this.noAppointmentSlot = true;
            });    

*/           
            
            /*getPateintsforStudy :: Starts
            getPatientsforStudy(
                {studyId : this.selectedValue }
            )
            .then( result=>{
                //console.log('Patient dats value :: ' + JSON.stringify(result));
                for(i=0; i<result.length; i++) {
                    this.patientList = [...this.patientList ,{value: result[i].PersonContactId , label: result[i].Name}];                                   
                }   
                //console.log('Patient dats value :: after ::  ' + JSON.stringify(this.patientList));
                this.error = undefined;
            })
            .catch(error =>{
                this.error = error;
            });
            //getPateintsforStudy :: ends */
/*
        }else{

            alert('No Study Selected');
            console.log('No Study Value Selected');
            
        }

    }//JavaScript Method :: handleGetAppointments :: ENDS


    //JavaScript Method :: handleConfirmSlotAction :: STARTS
    handleConfirmSlotAction(event){

        if(this.selectedPatientValue === '' || this.selectedPatientValue === undefined){
            alert(`You haven't selected any Patient`);
        }
        else{

            var selectedKey =  event.currentTarget.dataset.key;
            this.selectedAppointment = this.wrapperList.find(wrapperValue => wrapperValue.wrapperKey == selectedKey );
            console.log('Your selected Appointment is ' + JSON.stringify(this.selectedAppointment) );

            const studyName = this.studylist.find(item => item.value == this.selectedValue).label;
            var confirmMessage = `Your have selected ${this.getformattedDate(new Date(this.selectedAppointment.qtc_StartTime))} as your Apheresis Booking date for patient ${this.subjectSearchKey} in ${studyName} at ${this.selectedAppointment.qtc_resourceName}.\n An approval request will be sent to ${GSK_Support_Email_Id}.\n Please confirm to proceed.`;
            var successMessage = `Your appointment on ${this.getformattedDate(new Date(this.selectedAppointment.qtc_StartTime))} for patient ${this.subjectSearchKey} at ${this.selectedAppointment.qtc_resourceName} has been requested. \n You will receive a confirmation once the appointment has been approved.`;
            
            if(this.isWeekend(new Date(this.selectedAppointment.qtc_StartTime)) ){
                alert('You have selected Sunday for your appointment at Clinical Site');
            }else{

            

            if(!confirm(confirmMessage)){
                console.log('Appointment Not Confirmed');
            }else{

                this.isLoading = true;
                //createAppointments :: STARTS
                console.log('Test Create Appointment');
                
                createAppointments(
                    {   selectedAppointment : this.selectedAppointment,
                        selectedPatientValue : this.selectedPatientValue,
                        selectedValue : this.selectedValue
                    }
                )
                .then(result =>{

                    console.log('Return Check' + JSON.stringify(result) );

                    if(result === "Return Check" ){

                        const showSuccess = new ShowToastEvent({
                            title: 'Appointment Slot Booked',
                            variant : 'success',
                            mode : 'sticky',
                            message: successMessage
                        });
                        
                        this.dispatchEvent(showSuccess);
                        
                    }else if(result === "Already Booked"){

                        const showError = new ShowToastEvent({
                            title: 'OOps..!! Slots Already Booked',
                            variant : 'error',
                            mode : 'sticky',
                            message: 'Your selected appointment slot is already booked. Please use the refresh button before booking the slot'
                        });
                        this.dispatchEvent(showError);
                    }

                    refreshApex(this.allAppointmentValues)
                    .then(() => {
                        this.noAppointmentSlot = false;
                        this.wrapperList = this.allAppointmentValues.data;
                        if(this.wrapperList.length === 0){
                            this.noAppointmentSlot = true;
                            this.errorType = 'warning';
                            const studyName = this.studylist.find(item => item.value == this.selectedValue).label;
                            this.error = `No Apheresis slot is currenlty Available for Selected Study ${studyName} in the time period displayed.\n Please select another time period or contact ${GSK_Support_Email_Id}`;
                            this.disablePicklist = false;
                        }
                    });
                    
                    this.isLoading = false;
                    
                })
                .catch(error =>{
                    this.isLoading = false;
                    this.error = error;

                });//createAppointments :: ENDS

                 
                
            }//else ends :: Appointment Not Confirmed
            
            }//alert: Weekend Selected
            
        }//else ends :: Subject Not selected
        
    }//JavaScript Method :: handleConfirmSlotAction :: ENDS
    

    get errorMessageCSS(){
        if(this.errorType === 'warning'){
            return 'warningCSS';
        }else{
            return 'errorCSS';
        }
    }

    //Appointment Naviagtion ::STARTS
    previousHandler(event){
        this.currentPageNumber = event.detail;
        this.isInvokedfromNextPrevious = true;
        this.handleGetAppointments();
        this.isInvokedfromNextPrevious = false;

    }
    nextHandler(event){
        this.currentPageNumber = event.detail;
        this.isInvokedfromNextPrevious = true;
        this.handleGetAppointments();
        this.isInvokedfromNextPrevious = false;

    }
    //Appointment Navigation :: ENDS

    refreshList(){
        this.handleGetAppointments();
    }

    get isRefreshEnable(){

        
        if(this.wrapperList != undefined && this.wrapperList.length > 0 && this.wrapperList.length != undefined ){
            return true;
        }
        else{
            return false;
        }
    }

    getformattedDate(dateValue){
        return  dateValue != null ? dateValue.getDate() + "-" + months[dateValue.getMonth()] + "-" + dateValue.getFullYear() : null;
    }

    
    isWeekend(dateValue){
        if(dateValue.getDay() === 0 ){ //dateValue.getDay() === 6 || 
            return true;
        }else{
            return false;
        }
    }*/


}