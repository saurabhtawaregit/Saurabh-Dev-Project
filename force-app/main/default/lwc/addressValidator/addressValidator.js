import { LightningElement, track } from 'lwc';

export default class AddressValidator extends LightningElement {
    @track isGivenAddressSelected = true;
    @track isValidatedAddressSelected = false;
    @track addressWrapper = {
        city : '',
        street : '',
        zipcode : '',
        country : ''
    };

    // Dummy data for Given Address
    givenStreet = '123 Main St';
    givenCity = 'Anytown';
    givenZipcode = '12345';
    givenCountry = 'USA';

    // Dummy data for Validated Address
    validatedStreet = '567 Main Street';
    validatedCity = 'NoTown';
    validatedZipcode = '12345678899';
    validatedCountry = 'India';

    connectedCallback() {
        this.addressWrapper.city = this.givenCity;
        this.addressWrapper.street = this.givenStreet;
        this.addressWrapper.zipcode = this.givenZipcode;
        this.addressWrapper.country = this.givenCountry;
        console.log('This.address in connected Callback>>>',this.addressWrapper);
    }

    handleRadioChange(event) {
        console.log('In handle radio Change');
        const selectedValue = event.target.value;
        this.isGivenAddressSelected = selectedValue === 'given';
        this.isValidatedAddressSelected = selectedValue === 'validated';
        console.log('isGivenAddressSelected>>>',this.isGivenAddressSelected);
        console.log('isValidatedAddressSelected>>>',this.isValidatedAddressSelected);
        if(this.isGivenAddressSelected){
            this.addressWrapper.city = this.givenCity;
            this.addressWrapper.street = this.givenStreet;
            this.addressWrapper.zipcode = this.givenZipcode;
            this.addressWrapper.country = this.givenCountry;
        } else{
            this.addressWrapper.city = this.validatedCity;
            this.addressWrapper.street = this.validatedStreet;
            this.addressWrapper.zipcode = this.validatedZipcode;
            this.addressWrapper.country = this.validatedCountry;
        }

        console.log('This.address>>>',this.addressWrapper);
    }
}