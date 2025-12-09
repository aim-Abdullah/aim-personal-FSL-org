import { LightningElement,track,wire, api } from 'lwc';
import getAllFieldsSchema from '@salesforce/apex/SobjectSchema_Controller.getAllFieldsSchema';

export default class SobjectSchema extends LightningElement {

    @track mapAllFields = [];
    @track mapFieldsType = [];
    @wire(getAllFieldsSchema)
    schemaAllFields({error, data}){
        if(data){
            for(let key in data){
                this.mapAllFields.push({ value:data[key], key:key});
                //this.mapFieldsType.push({value:JSON.stringify(data[key]).split(',')[1] , key:key});
            }
            //console.log('**final data**' + JSON.stringify(this.mapAllFields) );
        }else if(error){
            console.log('**myerror**' +error);
            
        }

    }

    taskDragStart(){

    }

    taskDragEnd(){
        
    }
}