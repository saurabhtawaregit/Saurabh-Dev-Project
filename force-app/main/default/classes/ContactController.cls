public without sharing class ContactController {
    @AuraEnabled
    public static Contact getContactByEmail(String email) {
        System.debug([SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Email = :email LIMIT 1]);
        return [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Email = :email LIMIT 1];
    }

    @AuraEnabled
    public static USPSAddressResponseWrapper getContactAddress(Id accountId) {
        // Query to get the Mailing Address of the Contact
        USPSAddressResponseWrapper resultWrapper;
        String accessTokenResult;
        Account accountRecord = [
            SELECT BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry 
            FROM Account 
            WHERE Id = :accountId
            LIMIT 1
        ];
        
        Boolean AccessTokenExpired = USPSOAuthService.CheckAccessTokenIsExpired();
        if(AccessTokenExpired){
            String accessTokenJson = USPSOAuth.getAccessToken();
            Map<String, Object> jsonResponse = (Map<String, Object>) System.JSON.deserializeUntyped(accessTokenJson);
            accessTokenResult = (String) jsonResponse.get('access_token');
            if(accessTokenResult!= ''){
                resultWrapper = USPSOAuth.getAddressInfo(accountRecord.BillingStreet,'',accountRecord.BillingCity,accountRecord.BillingState,accessTokenResult);
                System.debug('resultWrapper>>>'+resultWrapper);
            }
            USPSOAuthService.SaveAccessToken(accessTokenJson);
        } else{
            accessTokenResult = USPSOAuthService.GetAvailableAccessToken();
            if(accessTokenResult!= ''){
                resultWrapper = USPSOAuth.getAddressInfo(accountRecord.BillingStreet,'',accountRecord.BillingCity,accountRecord.BillingState,accessTokenResult);
                System.debug('resultWrapper>>>'+resultWrapper);
            }
        }
    
        return resultWrapper;
    }

}