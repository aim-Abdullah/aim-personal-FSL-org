import { LightningElement, track, api, wire } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import FullCalendarJS from '@salesforce/resourceUrl/FullCalendarJS';
import { NavigationMixin } from 'lightning/navigation';
import getResourceAvailability from '@salesforce/apex/FullCalendarService.getResourceAvailability';
import updateDummyRecord from '@salesforce/apex/FullCalendarService.updateDummyRecord';


/**
 * FullCalendarJs
 * @description Full Calendar JS - Lightning Web Components
 */
export default class FullCalendarJs extends NavigationMixin(LightningElement) {

  @api recordId;
  @track returnValue;
  @track errorValue;
  @track wrapperList;
  @track dummyRecord;
  @track displayRefreshMessage;
  @track refreshMessage;
  @track renderedCallbackOnce = false;
 
  
  
  
  connectedCallback() {
    this.recordId = this.recordId;
    this.displayRefreshMessage = false;
    console.log('ServiceResourceId value :: ' + this.recordId );

   
    updateDummyRecord().then(
      result => {

          if(result == 'Success'){
            
            this.dummyRecord  = result;
            console.log( 'Dummy Record Value :: ' + JSON.stringify(this.dummyRecord) );
          }
          else {
            console.log( 'No Dummy Record Value :: ' + result  );
            
          }
          
        }
      ).catch(
        error => {
          this.errorValue = error;
          this.dummyRecord = undefined;
          console.log (`No Dummy Record Found`);
        }
      );
    
    
}

//, {resourceId : this.recordId}

  @wire(getResourceAvailability, {resourceId : '$recordId'} )
  allgetCandidateSlots({error, data}){
    if(data){
        this.wrapperList = data;
        console.log('data value :: ' + JSON.stringify(data));
        console.log( 'data value Array Size :: ' +  data.length );
        this.renderedCallbackOnce = true;
        if(data.length === 0){
          this.displayRefreshMessage = true;
          this.refreshMessage = 'Please Refresh the Page once again to display the appointment';
          //window.location.reload();
        }
    }
    else if (error){
        this.errorValue  = error;
        console.log (`No Candidate Slots Found`);
    }
  }
   
  renderedCallback() {

    if(this.renderedCallbackOnce){

      console.log (`Rendered callback function Reloading once more`);
      this.renderedCallbackOnce = false;
      
    }
    
    
  }

  
  

  
}