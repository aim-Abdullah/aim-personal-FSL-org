import { LightningElement, api, wire, track } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import CITIZEN_OBJECT from "@salesforce/schema/Citizen__c";
import CATEGORY_FIELD from '@salesforce/schema/Citizen__c.Category__c';

export default class AnnoyingChild extends LightningElement {
    @api ctRecordTypeId //012J100000009cz
    @api ctRecordTypeName;
    @api recordId;
    fieldValueMap;

    async connectedCallback(){
        console.log('Connected :: ' + this.recordId);
        this.ctRecordTypeId = '012J100000009cz';
    }

    @wire(getObjectInfo, { objectApiName: CITIZEN_OBJECT })
    getCitizenObjectInfo({error,data}){
        if(data){
            //this.RecordTypes = data.recordTypeInfos;
            console.log('::recordtypename::' + this.ctRecordTypeName);
            console.log('::data::' + JSON.stringify(data));
            //console.log('::recordTypeInfos::' + JSON.stringify(data.recordTypeInfos));
        }else if(error){
        console.error(JSON.stringify(error)) ;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '012J100000009czIAA', fieldApiName: CATEGORY_FIELD })
    getCategoryPicklistValues({ error, data }) {
        if (data) {
            //console.log('::data::' + JSON.stringify(data));
        } else if (error) {
             console.error(error);
            this.byPassPicklistOptions = undefined;
        }
    }


    async handleSubmit(){
        this.fieldValueMap = new Map();

        this.template.querySelectorAll('[data-id]').forEach(input => {
                console.log('inside each :: dataId ::' + input.dataset.id);
                console.log('inside each :: value ::' + input.value);
                this.fieldValueMap.set(input.dataset.id,input.value || null);
        });

        console.log('check Map :: all Keys ::'+ JSON.stringify(this.fieldValueMap.keys()) );
        console.log('check Map :: all Values ::'+ JSON.stringify(this.fieldValueMap.values()) );


    }
}