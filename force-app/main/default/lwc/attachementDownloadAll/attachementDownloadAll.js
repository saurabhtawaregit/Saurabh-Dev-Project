//Component to download all attachements related to case.Component will be place in ralated list of case aboove the attachement ralted component
import { LightningElement, api, track } from 'lwc';
import getFiles from '@salesforce/apex/DownloadZip.getFiles';
import getUserProfileName from '@salesforce/apex/DownloadZip.getUserProfileName'; // Import the Apex method
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AttachementDownloadAll extends NavigationMixin(LightningElement) {

    @api recordId;
    @track fileIds = '';
    @track isSysAdmin = false;
    
    // Connected callback to fetch the user profile name
    connectedCallback() {
        // Fetch the current user's profile name
        getUserProfileName()
            .then(result => {
                console.log('my profile name '+result);
                if (result === 'System Administrator') { // You can change this to match your profile name
                    this.isSysAdmin = true;
                }
            })
            .catch(error => {
                console.error('Error fetching user profile: ' + JSON.stringify(error));
            });
    }

    // Button click handler
    handleClick() {
        console.log('### Button clicked!');

        getFiles({
            recordId: this.recordId
        })
        .then(result => {
            let fileList = JSON.parse(JSON.stringify(result));
            console.log('content version id fetched : '+fileList);
            if (fileList == null) {
                this.showToast('No Attachments Found', 'There are no files or attachments associated with this record.', 'warning');
                return;
            }

            if (fileList != '') { 
                for (let i in fileList) { 
                    this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            url: '/sfc/servlet.shepherd/version/download/' + fileList[i]+'?'
                        }
                    }, false 
                );
                   // this.fileIds += fileList[i] + '/';
                }
            }

        })
        .catch(error => {
            console.error('### Error: ' + JSON.stringify(error));
        });
    }

    // Show toast notifications
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}