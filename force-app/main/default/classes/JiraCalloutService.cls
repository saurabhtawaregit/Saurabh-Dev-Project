public class JiraCalloutService {
	public static FINAL String JIRACLIENTSECRET = SWKS_Metadata_Setting__mdt.getInstance('Jira_Client_Secret').value__c;
    public static FINAL String JIRACLIENTID = SWKS_Metadata_Setting__mdt.getInstance('Jira_Client_Id').value__c;
    public static FINAL String JIRATOKENURL = SWKS_Metadata_Setting__mdt.getInstance('Jira_Token_Url').value__c;
    public static FINAL String AUTHORIZATIONCODE = SWKS_Metadata_Setting__mdt.getInstance('Jira_Token_Url').value__c;
    public static FINAL String GETUSERENDPOINT = SWKS_Metadata_Setting__mdt.getInstance('Get_User_Jira').value__c;
    public static FINAL String JIRACLOUDID = SWKS_Metadata_Setting__mdt.getInstance('Jira_Cloud_Id').value__c;
	public static FINAL String jiraIssueLink = SWKS_Metadata_Setting__mdt.getInstance('Jira_Issue_Link').value__c;
    public static final String BROADCASTPROJECTKEY = SWKS_Metadata_Setting__mdt.getInstance('Jira_Project_BroadCaster_Key').value__c;
    public static final String POWERPROJECTKEY = SWKS_Metadata_Setting__mdt.getInstance('Jira_Project_Power_Apps_Key').value__c;
    public static final String TIMINGPROJECTKEY = SWKS_Metadata_Setting__mdt.getInstance('Timing_Project_Key').value__c;
    public static final String JIRADEFAULTUSER = SWKS_Metadata_Setting__mdt.getInstance('Jira_Default_User_Email').value__c;
    
    public static string GetRefreshToken(String refreshToken) {
        return CalloutService.doJiraRefreshTokenCallout(refreshToken);
    }

    @future
    public static void SaveAccessToken(String JsonString){
        Jira_Custom_Setting__c setting = Jira_Custom_Setting__c.getOrgDefaults();
		setting.Access_Token11__c = '';
        setting.Access_Token10__c = '';
        // Parse the JSON response
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(JsonString);
        String temporyaString ='';
        String temporaryAccessTokenLength ='';

        Long expiresInSeconds = (Long)jsonResponse.get('expires_in');
        Datetime currentDatetime = Datetime.now();
        Datetime expiryDatetime = currentDatetime.addSeconds(Integer.valueOf(expiresInSeconds - 600));

        // Extract access token and refresh token
        String accessToken = (String) jsonResponse.get('access_token');
        String refreshToken = (String) jsonResponse.get('refresh_token');

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

        numberOfFields = (refreshToken.length() + chunkSize - 1) / chunkSize; // Calculate number of fields needed

        for (Integer i = 0; i < numberOfFields; i++) {
           
            Integer startIndex = i * chunkSize;
            System.debug('Start Index'+startIndex);
            Integer endIndex = Math.min(startIndex + chunkSize, refreshToken.length());
            System.debug('endIndex'+endIndex);
            String fieldName = 'Refresh_Token' + (i + 1) + '__c';
            temporyaString += refreshToken.substring(startIndex, endIndex);
            setting.put(fieldName, refreshToken.substring(startIndex, endIndex));
        }
        System.debug('temporyaString'+temporyaString.length());
        
        setting.Expiry_Time__c = expiryDatetime;

        // Insert or update the custom setting record

        upsert setting;
    }

    
    
    public static JiraResponseWrapper CreateJiraIsuue(Case caseRecord,String BearerToken){
        System.debug('BearerToken>>>>'+BearerToken);
        return CalloutService.doCreateJiraIsuueCallout(caseRecord, BearerToken);
    }
	
    public static Boolean CheckAccessTokenIsExpired(){
        Jira_Custom_Setting__c setting = Jira_Custom_Setting__c.getOrgDefaults();

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


    public static String GetAvailableAccessToken(){
        Jira_Custom_Setting__c setting = Jira_Custom_Setting__c.getOrgDefaults();
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
        if (!String.isBlank(setting.Access_Token5__c)) {
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
        }

        // Combine the non-empty access token field values into a single string
        String combinedAccessToken = String.join(accessTokenValues, '');
        System.debug('Old Access Token'+combinedAccessToken);
        System.debug('combinedAccessToken.size'+combinedAccessToken.length());

        return combinedAccessToken;
    }

    public static String GetOldRefreshToken(){
        Jira_Custom_Setting__c setting = Jira_Custom_Setting__c.getOrgDefaults();
        List<String> accessTokenValues = new List<String>();
        if (!String.isBlank(setting.Refresh_Token1__c)) {
            accessTokenValues.add(setting.Refresh_Token1__c);
        }
        if (!String.isBlank(setting.Refresh_Token2__c)) {
            accessTokenValues.add(setting.Refresh_Token2__c);
        }
        if (!String.isBlank(setting.Refresh_Token3__c)) {
            accessTokenValues.add(setting.Refresh_Token3__c);
        }
        if (!String.isBlank(setting.Refresh_Token4__c)) {
            accessTokenValues.add(setting.Refresh_Token4__c);
        }
        if (!String.isBlank(setting.Refresh_Token5__c)) {
            accessTokenValues.add(setting.Refresh_Token5__c);
        }
        if (!String.isBlank(setting.Refresh_Token6__c)) {
            accessTokenValues.add(setting.Refresh_Token6__c);
        }
        if (!String.isBlank(setting.Refresh_Token7__c)) {
            accessTokenValues.add(setting.Refresh_Token7__c);
        }
        if (!String.isBlank(setting.Refresh_Token8__c)) {
            accessTokenValues.add(setting.Refresh_Token8__c);
        }

        String CombinedRefreshToken = String.join(accessTokenValues, '');
        System.debug('CombinedRefreshToken length'+CombinedRefreshToken.length());
        System.debug('CombinedRefreshToken'+CombinedRefreshToken);
        
        return CombinedRefreshToken;

    }


    public static string getProjectName(Case caseRecord){
        String projectKey = '';
            if(caseRecord.Business_Unit__c == 'Timing'){
                projectKey = TIMINGPROJECTKEY;
            } else if(caseRecord.Business_Unit__c == 'Broadcast'){
                projectKey = BROADCASTPROJECTKEY;
            } else{
                projectKey = POWERPROJECTKEY;
            }
        
        return projectKey;
    }

}