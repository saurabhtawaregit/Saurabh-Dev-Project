public with sharing class CalloutService
{
    
    /*public static SWKS_ConfluenceService.refreshTokenWrapper doConfluenceRefreshTokenCallout(String refreshToken){
        try {
            //do the callout
            String redirectUri = '';
            
            SWKS_ConfluenceService.refreshTokenWrapper tokenWrapper = new SWKS_ConfluenceService.refreshTokenWrapper();
            // Send the HTTP request
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(SWKS_Constants.ATLASSIAN_COMMON_ENDPOINT);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            String json = '{"grant_type":"refresh_token",' + 
            '"client_id":"'+SWKS_ConfluenceService.CLIENT_ID+'",'+
            '"client_secret":"'+SWKS_ConfluenceService.CLIENT_SECRET+'",'+
            '"refresh_token":"' + refreshToken + '",' +
            '"redirect_uri":"' + SWKS_Constants.ATLASSIAN_REDIRECT_URI + '"}';
            req.setBody(json);
            HttpResponse response = http.send(req);
            System.debug(response.getBody());
            String accessTokenAfter = '';
            String refreshTokenAfter = '';
            // Process the response if nseeded
            if (response.getStatusCode() == 200) {
                Map<String, String> result = (Map<String, String>) System.JSON.deserialize(response.getBody(), Map<String, String>.class);
                // Handle successful response
                accessTokenAfter = result.get('access_token');
                refreshTokenAfter = (String)result.get('refresh_token');
                tokenWrapper.expiresIn =  (String)result.get('expires_in');
                tokenWrapper.accessToken = accessTokenAfter;
                tokenWrapper.refreshToken = refreshTokenAfter;
                
                system.debug('Body'+response.getBody());
            } else {
                // Handle error response
                SWKS_ErrorLogService.createError(new List<String>{response.getBody(), '', '140', '', 'doConfluenceRefreshTokenCallout', 'SWKS_CalloutService'});
                System.debug('HTTP Request failed with status code: ' + response.getStatusCode());
                tokenWrapper.error = true;
                return tokenWrapper;
            }
            return tokenWrapper;      
        } 
        catch (Exception e) {
            SWKS_ErrorLogService.CreateErrorLogRecord(e);
            SWKS_ConfluenceService.refreshTokenWrapper tokenWrapper = new SWKS_ConfluenceService.refreshTokenWrapper();
            tokenWrapper.error = true;
            return tokenWrapper;
            //throw new AuraHandledException(e.getMessage());
        }
    }
     // Method to create a new page in Confluence
    public static SWKS_ConfluenceResponseWrapper doCreateConfluencePageCallOut(Case Caseobj, List<CaseComment> commentObj, 
                                                                      List<EmailMessage> emailMssg, List<Knowledge_Article__c> knowledge,
                                                                      String spaceKey, String accessToken) {
        try {
            String currentUrl = URL.getOrgDomainURL().toExternalForm() ;

            HttpRequest request = new HttpRequest();
            // request.setEndpoint('callout:SWKS_Confluence_Credential/wiki/rest/api/content');
            request.setEndpoint(SWKS_ConfluenceService.CONFLUENCE_END_POINT+'rest/api/content/');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            // request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(USERNAME + ':' + PASSWORD)));
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            String caseDescription = Caseobj.Description.replaceAll('\\n\\r', ' ');
            caseDescription = caseDescription.replaceAll('\\n', ' ');
            caseDescription = caseDescription.replaceAll('\\r', ' ');
            caseDescription = caseDescription.normalizeSpace();
            //caseDescription = json.serialize(caseDescription);
            System.debug(caseDescription);
            String jsonBody = '{' +
                                '"type": "page",' +
                                '"title": "' +Caseobj.Subject+ '",' +
                                '"space": {' +
                                    '"key": "'+spaceKey+'"' +
                                '},' +
                                '"body": {' +
                                    '"storage": {' +
                                        '"value": " <body >'+   
                                        '    <h3><b>Case Description: </b>'+caseDescription+'</h3>'+
                                        '    <h3><b>FEED Section:</b></h3>'+
                                        '    <table>'+
                                        '        <tr>'+
                                        '            <th>Comment</th>'+
                                        '        </tr>';

                                        
                                        for(CaseComment cc: commentObj){
                                            String temp = cc.CommentBody.replaceAll('\n', '');
                                            temp = temp.replaceAll('\r', '');
                                            temp = temp.replaceAll('&', '');
                                            temp = temp.replaceAll('<', '');
                                            temp = temp.replaceAll('>', '');
                                            system.debug('Comment: '+temp);
                                            jsonBody += '        <tr>'+
                                        '            <td>'+temp+'</td>'+
                                        '        </tr>';
                                        }

                                    jsonBody +=    '    </table>'+
                                        '    <h3> <b>Account Information: </b> '+Caseobj.Account.Name+' </h3>'+
                                        '    <h3> <b>Contact Information: </b>'+Caseobj.Contact.Name+' </h3>'+
                                        '    <h3> <b>EMAILS: </b></h3>'+
                                        '    <table>'+
                                        '        <tr>'+
                                        '            <th>Subject</th>'+
                                        '            <th>Body</th>'+
                                        '        </tr>';
                                        for(EmailMessage em: emailMssg){
                                            // String temp = json.serialize(em.TextBody);
                                            String temp = em.TextBody.replaceAll('\n', '');
                                            temp = temp.replaceAll('\r', '');
                                            temp = temp.replaceAll('&', '');
                                            temp = temp.replaceAll('<', '');
                                            temp = temp.replaceAll('>', '');
                                            system.debug('emailBody: '+temp);
                                            jsonBody+='        <tr>'+
                                            '            <td>'+em.Subject+'</td>'+
                                            '            <td>'+temp+'</td>'+
                                            '        </tr>';
                                        }
                                        jsonBody += '    </table>'+
                                        '    <table>'+
                                        '        <tr>'+
                                        '            <th>Knowledge Article Name</th>'+
                                        '        </tr>';
                                        for(Knowledge_Article__c ka: knowledge){
                                            System.debug('URL'+ka.SWKS_Url_for_Knowledge_Article__c);
                                            jsonBody+='        <tr>'+
                                            //'            <td> <a href=\\"https://' + ka.SWKS_Url_for_Knowledge_Article__c + '\\">' +ka.Name+ '</a>'+'</td>'+
                                            '            <td> <a href=\\"' +currentUrl+'/'+ ka.SWKS_Knowledge__c + '\\">' +ka.Name+ '</a>'+'</td>'+
                                            '        </tr>';
                                        }
                                        jsonBody += '    </table>'+
                                        '<h3><b>Case Link: </b> <a href=\\"' + currentUrl+'/'+Caseobj.Id + '\\">' + 'please click here' + '</a></h3>'+ 
                                        '</body>",' +
                                        '"representation": "storage"' +
                                    '}' +
                                '}' +
                            '}';
            
            // request.setBody(jsonBody1+jsonBody2+jsonBody3+jsonBody4);
            request.setBody(jsonBody);
            // system.debug(request.getBody());
            Http http = new Http();
            HttpResponse response = http.send(request);
            SWKS_ConfluenceResponseWrapper responseWrapper2 = new SWKS_ConfluenceResponseWrapper();
            if (response.getStatusCode() == 200) {
                System.debug('Page created successfully in Confluence.');
                System.debug('Response body: ' + response.getBody());
                SWKS_ConfluenceResponseWrapper responseWrapper = SWKS_ConfluenceResponseWrapper.parse(response.getBody());
                responseWrapper.statusCode = response.getStatusCode();
                responseWrapper.spaceKey = spaceKey;
                responseWrapper.BaseUrl = SWKS_ConfluenceService.BASE_URL;
                System.debug('wrapper==>'+responseWrapper);
                responseWrapper2 = responseWrapper;
            } else {
                SWKS_ErrorLogService.createError(new List<String>{response.getBody(), '', '264', '', 'doCreateConfluencePageCallOut', 'SWKS_CalloutService'});
                System.debug('Failed to create page in Confluence. Status code: ' + response.getStatusCode());
                System.debug('Response body: ' + response.getBody());
                
                Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                
                // Retrieve the message field
                String message = (String) jsonMap.get('message');
                if(message.contains(SWKS_Constants.CONFLUENCE_DUP_TITLE_PAGE)){
                    responseWrapper2.errorReason = 'exist';
                }
                responseWrapper2.error = true;
                return responseWrapper2;
            }
            return responseWrapper2;
        }
        catch (Exception e) {
            SWKS_ErrorLogService.CreateErrorLogRecord(e);
            SWKS_ConfluenceResponseWrapper responseWrapper = new SWKS_ConfluenceResponseWrapper();
            responseWrapper.error = true;
            return responseWrapper;
            //throw new AuraHandledException(e.getMessage());
        }
    }*/
    
        public static string doJiraRefreshTokenCallout(String refreshToken) {
        try {
            string ResponseBody = '';
            Map<String, String> requestBody = new Map<String, String>();
            requestBody.put('grant_type', 'refresh_token');
            requestBody.put('client_id', JiraCalloutService.JIRACLIENTID);
            requestBody.put('client_secret', JiraCalloutService.JIRACLIENTSECRET);
            requestBody.put('refresh_token', refreshToken);
            String requestBodyJson = JSON.serialize(requestBody);

            HttpRequest req = new HttpRequest();
            req.setEndpoint(JiraCalloutService.JIRATOKENURL);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(requestBodyJson);

            Http http = new Http();
            HttpResponse res = http.send(req);

            // Check the response
            if (res.getStatusCode() == 200) {
                ResponseBody = res.getBody();
            } 
			return ResponseBody;
        } catch (Exception e){
            return null;
        }
    }

    public static JiraResponseWrapper doCreateJiraIsuueCallout(Case caseRecord,String BearerToken){

        HttpResponse res = new HttpResponse();
        JiraResponseWrapper responseWrapper = new JiraResponseWrapper();
        try {

            String projectKey = JiraCalloutService.getProjectName(CaseRecord);

            String jsonStringBody = createBugIssueJson(projectKey,CaseRecord,BearerToken);//callout

            HttpRequest req = new HttpRequest();
            req.setEndpoint(JiraCalloutService.JIRACLOUDID+'/issue');
            req.setMethod('POST');
            req.setHeader('Authorization', 'Bearer '+BearerToken);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-type','application/json');
            req.setBody(jsonStringBody);

            Http http = new Http();
            res = http.send(req);


            if (res.getStatusCode() == 201) {
                responseWrapper = JiraResponseWrapper.parse(res.getBody());
                responseWrapper.success = true;
                JiraServiceHelper.UpdateCaseWithJiraLink(responseWrapper,CaseRecord);

            }
            return responseWrapper;
        } 
        catch (Exception e) {
            responseWrapper.success = false;
        }
        
        return responseWrapper;
    }
    
    public static String GetJiraUserAccountIdByEmail(String BearerToken,String userEmailSearch){
        try{

            HttpRequest req = new HttpRequest();
            req.setEndpoint(JiraCalloutService.JIRACLOUDID+'/user/search?query='+userEmailSearch);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer '+BearerToken);
            Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug('User Returned'+res.getBody());
            list<JiraUserWrapper> userListWrapper = JiraUserWrapper.parse(res.getBody());

            if(!userListWrapper.isEmpty()){
                System.debug('Account Id from user wrapper'+userListWrapper[0].accountId);
                String jiraUserId =  userListWrapper[0].accountId;
                System.debug('users'+userListWrapper[0].accountId);
                return jiraUserId;
            } else {
                return '';
            }
            
         
        } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
        }
    }
    
    public static String createBugIssueJson(String projectKey, Case caseRecord,String accessBearerToken) {
        
        String salesforceLink = URL.getOrgDomainURL().toExternalForm();
        String caseOwnerEmail = caseRecord.owner.email;
        String JiraIssueCreatorEmail = userInfo.getUserEmail();
        String JiraAssigneId;
        String JiraOwnerId; 

        if(caseOwnerEmail!=''){
            System.debug('caseOwnerEmail>>>>'+caseOwnerEmail);
            JiraAssigneId = GetJiraUserAccountIdByEmail(accessBearerToken,caseOwnerEmail);
        }
        
         
         if(CalloutService.GetJiraUserAccountIdByEmail(accessBearerToken,JiraIssueCreatorEmail)!=''){
             JiraOwnerId = GetJiraUserAccountIdByEmail(accessBearerToken,JiraIssueCreatorEmail);
         }else{
             JiraOwnerId = GetJiraUserAccountIdByEmail(accessBearerToken,JiraCalloutService.JIRADEFAULTUSER);
         }
         
        System.debug('JiraAssigneId>>>'+JiraAssigneId);
        System.debug('JiraOwnerId>>>'+JiraOwnerId);
        String recordlink =  URL.getOrgDomainURL().toExternalForm()+'/'+CaseRecord.Id;
        String caseDescription = CaseRecord.Description.replaceAll('\\n\\r', ' ');
        caseDescription = caseDescription.replaceAll('\\n', ' ');
        caseDescription = caseDescription.replaceAll('\\r', ' ');
        caseDescription = caseDescription.normalizeSpace();
        String description = 'Salesforce case: '+recordlink + '\\n' +
                     'Contact Name: ' + caseRecord.Contact.Name+'\\n' +
                     'Description: '+ caseDescription ;
		System.debug('description>>>');
        String assigneeField = (JiraAssigneId.length() > 2 ) ?  
                     '"assignee": {"id": "' + JiraAssigneId+ '"}, ' : '"assignee": {"id": '+null+'}, ';
		System.debug('assigneeField>>>');
        String reporterField = (JiraOwnerId.length() > 2) ? 
                      '"reporter":{"accountId": "' + JiraOwnerId + '"}, ' : '';

		System.debug('reporterField>>>');
        String jsonBody = '{"fields": {' + 
                          '"project": {"key": "' + projectKey + '"}, ' + 
                          '"summary": "' + caseRecord.Subject + '", ' + 
                          '"description": "' + description +'", ' +
                          '"priority": {"name": "'+caseRecord.priority+'"}, '+
                          '"issuetype": {"name": "Task"},' +
                          assigneeField +
                          //'"components": [{"name": "'+caseRecord.Business_Unit__c+'"}],'+
                          reporterField +
                          '"labels":["Salesforce","'+caseRecord.Business_Unit__c+'"] '+
                          '}}';

        System.debug('jsonBody'+jsonBody);
        return jsonBody;
    }
    
}