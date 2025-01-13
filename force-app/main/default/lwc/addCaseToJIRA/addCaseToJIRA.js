import { LightningElement, wire, api, track } from 'lwc';
import CreateJiraTicket2 from '@salesforce/apex/JiraController.CreateJiraTicket2';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class addCaseToJIRA extends LightningElement {
  @api recordId;
  isShowToastMessage = false;

  connectedCallback() {
    setTimeout(() => {
      CreateJiraTicket2({ caseRecordId: this.recordId })
        .then(result => {

          result.CaseRecordId = this.recordId;
          if (result.alreadyExist == true) {
            this.showToastMessage('error', 'Error', 'Issue is already present in jira.');
            this.dispatchEvent(new CloseActionScreenEvent());
            return;
          }
          else if (result.success == true) {
            console.log('Result.Success>>>'+result.success);
            this.isShowToastMessage = true;
            this.showToastMessage('success', 'Success', 'Your issue created in Jira.');
          } else {
            this.showToastMessage('error', 'Error', 'Some Error Occurs while creating isuue.');
          }
          this.dispatchEvent(new CloseActionScreenEvent());

        })
        .catch(error => {
          console.log('error' + JSON.stringify(error));
          this.showToastMessage('error', 'Error', JSON.stringify(error));
          this.dispatchEvent(new CloseActionScreenEvent());
        })
    }, 500);


  }

  

  showToastMessage(variant, title, message) {
    const event = new ShowToastEvent({
      variant: variant,
      title: title,
      message: message,
    });
    this.dispatchEvent(event);
  }

}