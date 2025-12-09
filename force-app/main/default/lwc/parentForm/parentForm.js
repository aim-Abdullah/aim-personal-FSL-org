import { LightningElement, api, wire, track } from 'lwc';
//import { reduceErrors } from 'c/ldsUtils';
import { subscribe, unsubscribe, MessageContext} from 'lightning/messageService';
import { getRecord } from 'lightning/uiRecordApi';
import WORK_ORDER_OBJECT from "@salesforce/schema/WorkOrder";
import STATUS_FIELD from '@salesforce/schema/WorkOrder.Status';
import RECORDTYPEID_FIELD from '@salesforce/schema/WorkOrder.RecordTypeId';
import RECORDTYPENAME_FIELD from '@salesforce/schema/WorkOrder.RecordType.Name';
import WORKTYPENAME_FIELD from '@salesforce/schema/WorkOrder.WorkType.Name';
import OnlineStatus from '@salesforce/messageChannel/OnlineStatus__c';

export default class ParentForm extends LightningElement {

    @api recordId;

    /* annoying child variables */
    ctRecordTypeId;
    ctRecordTypeName;
    loadingComplete = false;

    subscription = null;
    loggedDevice;
    status;
    isOffline;
    workOrderRecord;
    recordTypeId;
    recordTypeName;
    workTypeName;
    isInprogress = false;

    async connectedCallback() {
        this.loadingComplete = true;
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        //this.unsubscribeToMessageChannel();
    }

    @wire(getRecord, { recordId: '$recordId', fields: [STATUS_FIELD, RECORDTYPEID_FIELD, RECORDTYPENAME_FIELD, WORKTYPENAME_FIELD ] })
    getWorkOrderRecord({ error, data }) {
        if (data) {
            this.workOrderRecord = data;
            this.ctRecordTypeName = 'Immigrant';
            /*if(data.fields.Status.value == 'In Progress'){
                this.isInprogress = true;
                this.ctRecordTypeId = '012J100000009cz';
                
                this.loadingComplete = true;
            }   */
        } else if (error) {
            console.error('Error fetching user profile Name', error);
        }
    }

    
    @wire(MessageContext)
    messageContext;// = createMessageContext()
    

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe( this.messageContext, OnlineStatus,  //{ scope: APPLICATION_SCOPE }
                                            (message) => this.handleMessage(message)
                                        );
        }
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleMessage(message) {
        this.status = message.status;
        this.loggedDevice = message.loggedDevice;
        console.log('You are ' + this.status + 'on ' + this.loggedDevice);
        //this.template.querySelector("c-offline-utility-bar").isOffline();
    }

    statusChangeHandler(event){
        //alert('You are' + event.detail);
    }
}