//Quick Action to downlaod all the related attachement of case. Quick action button will be created for this component
import { LightningElement, api, track } from 'lwc';
import getFiles from '@salesforce/apex/DownloadZip.getFiles';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DownloadZipQuickAction extends NavigationMixin(LightningElement) {
  
    @api recordId;
    @track fileIds = '';
    //@api invoke() {
    connectedCallback() {
        console.log('ConnectedCallaback');
        setTimeout(() => {
        getFiles({
            recordId:this.recordId
        }).then(result => { 
                console.log(result);

                let fileList = JSON.parse(JSON.stringify(result));
                console.log('fileList'+fileList);
                if(fileList==null){
                    console.log('inside toast');
                    this.showToast('No Attachments Found', 'There are no files or attachments associated with this record.', 'warning');
                    return;
                }

                if (fileList != '') { 
                    for (let i in fileList) { 
                        this.fileIds += fileList[i] + '/';
                    }
                }
                console.log('fileIds'+this.fileIds);
                
                if (this.fileIds.length > 0) { 
                    console.log('inside file ids');
                    this.fileIds = this.fileIds.replace(/.$/, "?");
                }
                console.log('fileIds after replacement'+this.fileIds);
                console.log('all file ids'+this.fileIds);

                const config = {
                    type: 'standard__webPage',
                    attributes: {
                        url: '/sfc/servlet.shepherd/version/download/' + this.fileIds
                    }
                };
                this[NavigationMixin.Navigate](config);

            })
            .catch(error => {
                console.log('### Error: ' + JSON.stringify(error));
             })
             }, 500);
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}