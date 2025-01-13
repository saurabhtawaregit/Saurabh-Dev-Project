/**
* @File Name : USPSOAuthService.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : September 5, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | September 5, 2024 |   | Initial Version
**/

public class USPSOAuthService {

    
	public static String GetAvailableAccessToken(){
        USPS__c setting = USPS__c.getOrgDefaults();
        List<String> accessTokenValues = new List<String>();
        if (!String.isBlank(setting.Access_Token1__c)) {
            accessTokenValues.add(setting.Access_Token1__c);
        }
        if (!String.isBlank(setting.Access_Token2__c)) {
            accessTokenValues.add(setting.Access_Token2__c);
        }
        if (!String.isBlank(setting.Access_Token3__c)) {
            accessTokenValues.add(setting.Access_Token3__c);
        }
        if (!String.isBlank(setting.Access_Token4__c)) {
            accessTokenValues.add(setting.Access_Token4__c);
        }
        /*if (!String.isBlank(setting.Access_Token5__c)) {
            accessTokenValues.add(setting.Access_Token5__c);
        }
        if (!String.isBlank(setting.Access_Token6__c)) {
            accessTokenValues.add(setting.Access_Token6__c);
        }
        if (!String.isBlank(setting.Access_Token7__c)) {
            accessTokenValues.add(setting.Access_Token7__c);
        }
        if (!String.isBlank(setting.Access_Token8__c)) {
            accessTokenValues.add(setting.Access_Token8__c);
        }
        if (!String.isBlank(setting.Access_Token9__c)) {
            accessTokenValues.add(setting.Access_Token9__c);
        }
        if (!String.isBlank(setting.Access_Token10__c)) {
            accessTokenValues.add(setting.Access_Token10__c);
        }
        if (!String.isBlank(setting.Access_Token11__c)) {
            accessTokenValues.add(setting.Access_Token11__c);
        }*/

        // Combine the non-empty access token field values into a single string
        String combinedAccessToken = String.join(accessTokenValues, '');
        System.debug('Old Access Token'+combinedAccessToken);
        System.debug('combinedAccessToken.size'+combinedAccessToken.length());

        return combinedAccessToken;
    }

    //@future
    public static void SaveAccessToken(String JsonString){
        USPS__c setting = USPS__c.getOrgDefaults();
		//setting.Access_Token11__c = '';
        //setting.Access_Token10__c = '';
        // Parse the JSON response
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(JsonString);
        String temporyaString ='';
        String temporaryAccessTokenLength ='';

        Integer expiresInSeconds = (Integer)jsonResponse.get('expires_in');
        Datetime currentDatetime = Datetime.now();
        Datetime expiryDatetime = currentDatetime.addSeconds(Integer.valueOf(expiresInSeconds - 600));

        // Extract access token and refresh token
        String accessToken = (String) jsonResponse.get('access_token');
       // String refreshToken = (String) jsonResponse.get('refresh_token');

        Integer chunkSize = 255; // Chunk size for each field
        Integer numberOfFields = (accessToken.length() + chunkSize - 1) / chunkSize; // Calculate number of fields needed
        System.debug('numberOfFields'+numberOfFields);

        for (Integer i = 0; i < numberOfFields; i++) {
            Integer startIndex = i * chunkSize;
            Integer endIndex = Math.min(startIndex + chunkSize, accessToken.length());
            String fieldName = 'Access_Token' + (i + 1) + '__c';
            temporaryAccessTokenLength += accessToken.substring(startIndex, endIndex);
            setting.put(fieldName, accessToken.substring(startIndex, endIndex));
        }

        /*numberOfFields = (refreshToken.length() + chunkSize - 1) / chunkSize; // Calculate number of fields needed

        for (Integer i = 0; i < numberOfFields; i++) {
           
            Integer startIndex = i * chunkSize;
            System.debug('Start Index'+startIndex);
            Integer endIndex = Math.min(startIndex + chunkSize, refreshToken.length());
            System.debug('endIndex'+endIndex);
            String fieldName = 'Refresh_Token' + (i + 1) + '__c';
            temporyaString += refreshToken.substring(startIndex, endIndex);
            setting.put(fieldName, refreshToken.substring(startIndex, endIndex));
        }
        System.debug('temporyaString'+temporyaString.length());*/
        
        setting.Expiry_Time__c = expiryDatetime;

        // Insert or update the custom setting record

        upsert setting;
    }


     public static Boolean CheckAccessTokenIsExpired(){
        USPS__c setting = USPS__c.getOrgDefaults();

        List<String> accessTokenValues = new List<String>();
        System.debug('setting.Expiry_Time__c'+setting.Expiry_Time__c);
        System.debug('Cureent Datetime.now()'+Datetime.now());
        // Check if the setting record exists and if the expiry datetime is in the past
        if (setting != null && setting.Expiry_Time__c != null && setting.Expiry_Time__c > Datetime.now()) {
            return false;
        } else{
            return true;
        }
    }
}