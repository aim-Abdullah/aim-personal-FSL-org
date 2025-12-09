import { LightningElement, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { publish, MessageContext } from 'lightning/messageService';
import OnlineStatus from '@salesforce/messageChannel/OnlineStatus__c';

export default class OfflineUtilityBar extends LightningElement {
    formFactor = FORM_FACTOR;
    isOffline = false;

    
    @wire(MessageContext)
    messageContext;
    


    connectedCallback(){

    //initial Status Check
    this.isOffline = !navigator.onLine; 
    console.log('utility ccb ' + this.isOffline );   

    this._handleOffline = this.handleOffline.bind(this);
    this._handleOnline = this.handleOnline.bind(this);

    //Register Listerners
    window.addEventListener('offline',this._handleOffline);
    window.addEventListener('online',this._handleOnline);

    setTimeout(() => {
        if(this.isOffline){
            this.handleOffline();
        }else{
            this.handleOnline();
        } 

    }, 1000);

   }

   disconnectedCallback(){

    window.removeEventListener('offline',this._handleOffline);
    window.removeEventListener('online',this._handleOnline);

   }

   handleOffline(){
    this.isOffline = true;
    console.log('Dispatch User is Offline');

    /*
    this.dispatchEvent(new CustomEvent('status', {
        detail: 'offline'
    }));*/
    
    
    const payload = {
        status : 'offline',
        loggedDevice : this.formFactor
    };
    publish(this.messageContext, OnlineStatus, payload);
    
   }

   handleOnline(){
    this.isOffline = false;
    console.log('Dispatch User is Online');
    /*
    this.dispatchEvent(new CustomEvent('status', {
        detail: 'online'
    }));*/

    const payload = {
        status : 'online',
        loggedDevice : this.formFactor
    };
    publish(this.messageContext, OnlineStatus, payload);

   }

   get checkMobileDevices(){
    return String(this.formFactor) !== 'Large';
   }
}