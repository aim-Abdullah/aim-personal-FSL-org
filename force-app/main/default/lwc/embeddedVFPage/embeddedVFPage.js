import { LightningElement, track, api } from 'lwc';
import FSL_Appointment_Booking_URL from '@salesforce/label/c.FSL_Appointment_Booking_URL';

export default class EmbeddedVFPage extends LightningElement {

    @api sarecordId;
    @track myDomainURL;

    get fullUrl(){

        //return `https://cts-1f8-dev-ed--fsl.visualforce.com/apex/AppointmentBookingVf?id=${this.sarecordId}`;
        return this.myDomainURL;
    }

    renderedCallback() {
        //this.myDomainURL = window.location.origin + FSL_Appointment_Booking_URL + this.sarecordId;
        this.myDomainURL = FSL_Appointment_Booking_URL + this.sarecordId;
    }
}