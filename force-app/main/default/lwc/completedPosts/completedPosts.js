import { LightningElement, track } from 'lwc';
import { createMessageContext, releaseMessageContext, publish, subscribe, unsubscribe } from 'lightning/messageService';
import DragDropChannel from "@salesforce/messageChannel/DragDrop__c";
export default class CompletedPosts extends LightningElement {
    draggedItem;
    draggedItemId;
    context = createMessageContext();
    subscription = null;
    @track lstPosts = [];
    constructor() {
        super();
        this.lstPosts.push('Create Dynamic Apex Instance using Type.forName()');
        if (this.subscription) {
            return;
        }
        this.subscription = subscribe(this.context, DragDropChannel, (message) => {
            if(message.upcomingToCompleted){
                this.handleMessage(message);
            }
        });
     }
    handleMessage(message) {
        this.draggedItem = message.draggedItem;
        this.draggedItemId = message.itemId;
    }
    allowDrop(event){
        event.preventDefault();
    }
    drop(event){
        event.preventDefault();
        this.lstPosts.push(this.draggedItem);
        const message = {
            draggedItem : null,
            itemId : this.draggedItemId,
            upcomingToCompleted: false
        };
        publish(this.context, DragDropChannel, message);
    }
    disconnectedCallback() {
        releaseMessageContext(this.context);
    }
}