import { LightningElement, api, wire, track } from 'lwc';
import IMAGES from '@salesforce/resourceUrl/Offline_Form';

export default class ChildForm extends LightningElement {

   //isOffline = false;
   @api workOrderId ;
   @api woliType;
   offlineGif = IMAGES + '/Offline_Form/Offlinegif.gif';
   @api status;
   @api loggedDevice;

   studyId;

   get inputVariables() {
    return [
                {
                    name: 'woliType',
                    type: 'String',
                    value: this.woliType
                },
                {
                    name: 'recordId',
                    type: 'String',
                    value: this.workOrderId
                }
            ];
    }

     get isOffline(){
        return this.status === 'offline' || this.status === undefined;
     }

     handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        this.template.querySelector(`[data-id="childFormOffline"]`).submit(fields);
     }
     
     handleSuccess(event){
        this.studyId = event.detail.Id;
        this.showGrandChild = true;
     }

     handleGCSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        this.template.querySelector(`[data-id="grandChildForm"]`).submit(fields);
     }
   

    /*
    connectedCallback(){

    console.log('Child are ' + this.status + 'on ' + this.loggedDevice);
    
    this._handleOffline = this.handleOffline.bind(this);
    this._handleOnline = this.handleOnline.bind(this);

    //Register Listerners
    window.addEventListener('offline',this._handleOffline);
    window.addEventListener('online',this._handleOnline);

    //initial Status Check
    this.isOffline = !navigator.onLine;

   }

   disconnectedCallback(){

    //window.removeEventListener('offline',this._handleOffline);
    //window.removeEventListener('online',this._handleOnline);

   }

   /*
   _isOffline;
    @api
    get isOffline(){
        console.log('isOffline' + this.status + 'on ' + this.loggedDevice);
        return this._isOffline ;
    }

    set isOffline(value){
        this._isOffline = this.status === 'offline';
    }
   
   handleOffline(){
    this.isOffline = true;
    console.log('User is Offline');
   }

   handleOnline(){
    this.isOffline = false;
    console.log('User is Online');
   }*/

}