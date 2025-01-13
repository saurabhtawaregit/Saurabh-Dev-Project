public without sharing class JiraController {

    @AuraEnabled
    public static JiraResponseWrapper CreateJiraTicket2(String caseRecordId){
        JiraResponseWrapper responseWrapper = new JiraResponseWrapper();
            Case caseRecord = [SELECT Id, Subject, 
                                Description, ContactId,AccountId,
                                Contact.name, Priority,
                               Business_Unit__c,
                                Owner.Email,Jira_Link__c
                                FROM Case 
                                WHERE Id = :caseRecordId 
                                LIMIT 1];
        if(!String.isEmpty(caseRecord.Jira_Link__c)){
            JiraResponseWrapper responseWrapper2 = new JiraResponseWrapper();
            responseWrapper2.alreadyExist = true;
            return responseWrapper2;
        }
        Boolean AccessTokenExpired = JiraCalloutService.CheckAccessTokenIsExpired();

        if(AccessTokenExpired){
            String OldRefreshToken = JiraCalloutService.GetOldRefreshToken();

            String NewAccessToken = JiraCalloutService.GetRefreshToken(OldRefreshToken);
            if(NewAccessToken == null){
                responseWrapper.success = false;
                return responseWrapper;
            }
            Map<String, Object> JsonResponseString = (Map<String, Object>) System.JSON.deserializeUntyped(NewAccessToken);

            String StringAccessToken = (String) JsonResponseString.get('access_token');
            responseWrapper = JiraCalloutService.CreateJiraIsuue(caseRecord,StringAccessToken);
            JiraCalloutService.SaveAccessToken(NewAccessToken);
        } else{
            String result = JiraCalloutService.GetAvailableAccessToken();
            responseWrapper = JiraCalloutService.CreateJiraIsuue(caseRecord,result);
        }
        
        return responseWrapper; 
         
    } 

}