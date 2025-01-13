import { LightningElement, track, api } from 'lwc';
import getContactByEmail from '@salesforce/apex/ContactController.getContactByEmail';

export default class ContactSearch extends LightningElement {
    @track contactEmail = '';
    @track contact;

    handleEmailChange(event) {
        this.contactEmail = event.target.value;
    }

    searchContact() {
        getContactByEmail({ email: this.contactEmail })
            .then(result => {
                this.contact = result;
            })
            .catch(error => {
                console.error('Error retrieving contact', error);
            });
    }
}