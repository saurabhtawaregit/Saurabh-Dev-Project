import { LightningElement, track } from 'lwc';
import generateAuthorizeCodeForJira from '@salesforce/apex/AtlassionOauthComponentController.generateAuthorizeCodeForJira';
import getAndSaveTheAccessTokenForJira from '@salesforce/apex/AtlassionOauthComponentController.getAndSaveTheAccessTokenForJira';

export default class JiraAuth extends LightningElement {
    @track authCode;
    @track accessTokenJira;
    @track refreshTokenJira;
    @track expireTime;

    handleAuthorizeForJira() {
        generateAuthorizeCodeForJira()
            .then(result => {
                console.log('Authentication Code>>>',result);
                window.location.href = result;
            })
            .catch(error => {
                console.error('Error generating auth code: ', error);
            });
    }

    handleAuthenticateForJira() {
        console.log('AuthCode>>>',this.authCode)
        getAndSaveTheAccessTokenForJira({ authCode: this.authCode})
            .then(result => {
                this.accessTokenJira = result.access_token;
                console.log('this.accessTokenJira>>>',this.accessTokenJira);
                this.refreshTokenJira = result.refresh_token;
                this.expireTime = result.expires_in;
            })
            .catch(error => {
                console.error('Error authenticating: ', error);
            });
    }
}