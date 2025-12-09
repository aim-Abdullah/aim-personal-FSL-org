import { LightningElement } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi'; // Optional for saving data

const COLUMNS = [
    { label: 'Account Name', fieldName: 'Name', type: 'text',editable: true },
    { label: 'Account Number', fieldName: 'AccountNumber', type: 'text', editable: true },
];

export default class MyDataEntry extends LightningElement {
    data = [];
    columns = COLUMNS;

    handleAddRow(){
        let tempRow = { Name: '', AccountNumber: '' };
        this.data = [...this.data, tempRow]; 
    }

    handleSave(event) {
        //const updatedData = event.detail.draftValues;
        const updatedData = this.template.querySelector('lightning-datatable').draftValues;
        console.log('check data' + JSON.stringify(updatedData));
        this.saveAccounts(updatedData);
    }

    // Save the Accounts via GraphQL (offline)
    saveAccounts(accounts) {
        // Simulating GraphQL mutation request (using offline mode for now)
        const isOffline = !navigator.onLine;
        if (isOffline) {
            // Use localStorage for offline storage (a simplified version of IndexedDB)
            let savedAccounts = JSON.parse(localStorage.getItem('accounts')) || [];
            savedAccounts = [...savedAccounts, ...accounts];
            localStorage.setItem('accounts', JSON.stringify(savedAccounts));
            alert('Data saved offline');
        } else {
            // Implement GraphQL Mutation to insert data when online
            this.insertAccountsUsingGraphQL(accounts);
        }
    }

    insertAccountsUsingGraphQL(accounts) {
        const mutation = `
            mutation {
                createAccounts(input: ${JSON.stringify(accounts)}) {
                    Name
                    AccountNumber
                }
            }
        `;

        fetch('/graphql', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ query: mutation }),
        })
            .then(response => response.json())
            .then(data => {
                alert('Accounts successfully created');
                console.log('Response Data:', data);
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }
}