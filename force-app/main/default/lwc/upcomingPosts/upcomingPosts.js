import { LightningElement } from 'lwc';
import { createMessageContext, releaseMessageContext, publish, subscribe } from 'lightning/messageService';
import DragDropChannel from "@salesforce/messageChannel/DragDrop__c";
export default class UpcomingPosts extends LightningElement {
    context = createMessageContext();
    subscription = null;
    constructor() {
        super();
        if (this.subscription) {
            return;
        }
        this.subscription = subscribe(this.context, DragDropChannel, (message) => {
            if(!message.upcomingToCompleted){
                this.template.querySelector('#' +message.itemId).style.display = 'none';
            }
        });
    }
    drag(event){
        const message = {
            draggedItem : event.target.textContent,
            itemId : event.target.id,
            upcomingToCompleted: true
        };
        publish(this.context, DragDropChannel, message);
    }
    disconnectedCallback() {
        releaseMessageContext(this.context);
    }
}