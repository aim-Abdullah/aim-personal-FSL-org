// apiPlatformEventComponent.js
import { LightningElement, track } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import callExternalApi from '@salesforce/apex/ApiController.callExternalApi';


export default class PlatformEventInLWC extends LightningElement {
    @track status = 'Ready';
    @track result = '';
    @track isLoading = false;
    @track error = '';
    subscription = {};
    channelName = '/event/API_Response__e'; // Platform Event API Name
    connectedCallback() {
        this.handleSubscribe();
        this.registerErrorListener();
    }
    disconnectedCallback() {
        this.handleUnsubscribe();
    }
    // Call REST API
    async handleApiCall() {
        this.isLoading = true;
        this.status = 'Calling API...';
        this.error = '';
        this.result = '';
        try {
            const response = await callExternalApi();
            this.status = 'API called successfully. Waiting for platform event...';
            console.log('API Response:', response);
        } catch (error) {
            this.error = 'API call failed: ' + error.body?.message || error.message;
            this.status = 'Error';
            this.isLoading = false;
            this.showToast('Error', this.error, 'error');
        }
    }
    // Subscribe to platform event
    handleSubscribe() {
        const messageCallback = (response) => {
            console.log('Platform Event received:', response);
            this.handlePlatformEvent(response);
        };
        subscribe(this.channelName, -1, messageCallback).then(response => {
            console.log('Subscription successful:', response);
            this.subscription = response;
        }).catch(error => {
            console.error('Subscription failed:', error);
            this.error = 'Failed to subscribe to platform event';
        });
    }
    // Handle platform event data
    handlePlatformEvent(response) {
        this.isLoading = false;
        const eventData = response.data.payload;
        // Assuming the platform event has fields like Status__c, Message__c, Data__c
        this.status = eventData.Status__c || 'Completed';
        this.result = eventData.Message__c || 'No message received';
        // Display additional data if available
        if (eventData.Data__c) {
            this.result += '\n\nData: ' + eventData.Data__c;
        }
        this.showToast('Success', 'Platform event received!', 'success');
    }
    // Unsubscribe from platform event
    handleUnsubscribe() {
        unsubscribe(this.subscription, response => {
            console.log('Unsubscribe successful:', response);
        });
    }
    // Register error listener
    registerErrorListener() {
        onError(error => {
            console.error('EMP API error:', error);
            this.error = 'Platform event error: ' + error.message;
        });
    }
    // Reset component state
    handleReset() {
        this.status = 'Ready';
        this.result = '';
        this.isLoading = false;
        this.error = '';
    }
    // Show toast notification
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
    // Getters for conditional rendering
    get hasError() {
        return this.error !== '';
    }
    get hasResult() {
        return this.result !== '';
    }
    get isReady() {
        return this.status === 'Ready';
    }
}