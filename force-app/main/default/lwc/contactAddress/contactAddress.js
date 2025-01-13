import { LightningElement, api,track } from 'lwc';
import getContactAddress from '@salesforce/apex/ContactController.getContactAddress';

export default class ContactAddress extends LightningElement {
    @api recordId; // Record ID of the contact passed from the Lightning Record Page
    @track address = {};
    @track isSpinner = true;
    @track showData = false;

    @track uspsAddressResponse ;//= {};


    connectedCallback() {
        console.log('Connected');
        
        setTimeout(() => {
            if (this.recordId) {
                this.fetchContactAddress();
            } else {
                console.error('recordId is not available');
            }
        }, 500); 
    }

    fetchContactAddress() {
        getContactAddress({ accountId: this.recordId })
            .then((address) => {
                console.log('Address List from:',address); 
                this.isSpinner = false;
                this.uspsAddressResponse = address;
                console.log('this.uspsAddressResponse>>>',this.uspsAddressResponse);
                this.showData = true;
            })
            .catch((error) => {
                console.error('Error fetching address:', error);
            });
    }
}