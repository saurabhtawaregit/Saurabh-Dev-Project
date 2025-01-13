public with sharing class AtlassionOauthComponentController {

    public String auth_code {get;set;}
    public String auth_code_Conf {get;set;}
    public String tokenJira {get;set;}
    public String tokenConfluence {get;set;}
    public String access_tokenJira {get;set;}
    public String refresh_tokenJira {get;set;}
    public String access_tokenConfluence {get;set;}
    public String refresh_tokenConfluence {get;set;}
    public String access_tokenafter {get;set;}
    public String refresh_tokenafter {get;set;}
    public String expireTime {get;set;}
    public String expireTimeConf {get;set;}
    public String expireTimeafter {get;set;}
    public String responseBody {get;set;}
    public Jira_Custom_Setting__c flag = Jira_Custom_Setting__c.getOrgDefaults();
    public static final String JIRACLIENTID = Test.isRunningTest() ? 'JIRACLIENT' : SWKS_Metadata_Setting__mdt.getInstance('Jira_Client_Id').value__c;
    public static final String JIRACLIENTSECRET = Test.isRunningTest() ? 'JIRASECRET' : SWKS_Metadata_Setting__mdt.getInstance('Jira_Client_Secret').value__c;
    public static final String JIRASCOPE = Test.isRunningTest() ? 'JIRASCOPE' : SWKS_Metadata_Setting__mdt.getInstance('Jira_Scope').value__c;
    public static final String CONFLUENCESCOPE = Test.isRunningTest() ? 'CONFLUENCESCOPE' : SWKS_Metadata_Setting__mdt.getInstance('Confluence_Scope').value__c;
    public static final String AUTHURL = Test.isRunningTest() ? 'https://test.com/authorize' : SWKS_Metadata_Setting__mdt.getInstance('Authorization_Url').value__c;
    public static final String REDIRECTURL = Test.isRunningTest() ? 'https://google.com' : SWKS_Metadata_Setting__mdt.getInstance('Redirect_Url').value__c;
    public static final String TOKENURL = Test.isRunningTest() ? 'JIRATOKENURL' : SWKS_Metadata_Setting__mdt.getInstance('Jira_Token_Url').value__c;

    @AuraEnabled
    public static String generateAuthorizeCodeForJira() {    
        try {
            Jira_Custom_Setting__c flag = Jira_Custom_Setting__c.getOrgDefaults();
            String state = 'Sky123';
        
            // Construct the query parameters
            String authorizeSendURL = AUTHURL +
                                '&client_id=' + EncodingUtil.urlEncode(JIRACLIENTID, 'UTF-8') +
                                '&scope=' + EncodingUtil.urlEncode(JIRASCOPE, 'UTF-8') +
                                '&redirect_uri=' + EncodingUtil.urlEncode(REDIRECTURL, 'UTF-8') +
                                '&state=' + EncodingUtil.urlEncode(state, 'UTF-8') +
                                '&response_type=code' +
                                '&prompt=consent';
            flag.First_Time_Integration_Type__c = 'jira';
            upsert(flag);
            return authorizeSendURL;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Map<String, String> getAndSaveTheAccessTokenForJira(String authCode) {
        Map<String, String> result = new Map<String, String>();
        if (!String.isEmpty(authCode)) {
            
            // Do the callout
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(TOKENURL);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            String json = '{"grant_type":"authorization_code",' + 
            '"client_id":"' + JIRACLIENTID + '",' +
            '"client_secret":"' + JIRACLIENTSECRET + '",' +
            '"code":"' + authCode + '",' +
            '"redirect_uri":"' + REDIRECTURL + '"}';
            req.setBody(json);
            HttpResponse response = http.send(req);
            System.debug(req.getBody());
            
            // Process the response if needed
            if (response.getStatusCode() == 200) {
                Map<String, Object> responseBody = (Map<String, Object>) System.JSON.deserializeUntyped(response.getBody());
                // Handle successful response
                result.put('access_token', (String)responseBody.get('access_token'));
                result.put('refresh_token', (String)responseBody.get('refresh_token'));
                result.put('expires_in', String.valueOf(responseBody.get('expires_in')));
                JiraCalloutService.SaveAccessToken(response.getBody());
                System.debug('Authentication Reseponse>>>>'+response.getBody());
            } else {
                // Handle error response
                System.debug('HTTP Request failed with status code: ' + response.getStatusCode());
                throw new AuraHandledException('HTTP Request failed with status code: ' + response.getStatusCode());
            }
        }
        return result;
    }
    
    
    /*public void getAndSaveTheAccessTokenForConfluence()
    {
        if(!String.isEmpty(auth_code_Conf)){
            //do the callout
                
            // Send the HTTP request
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(TOKENURL);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            String json = '{"grant_type":"authorization_code",' + 
            '"client_id":"'+JIRACLIENTID+'",'+
            '"client_secret":"'+JIRACLIENTSECRET+'",'+
            '"code":"' + auth_code_Conf + '",' +
            '"redirect_uri":"' + REDIRECTURL + '"}';
            req.setBody(json);
            HttpResponse response = http.send(req);
            System.debug(req.getBody());
            
            // Process the response if nseeded
            if (response.getStatusCode() == 200) {
                Map<String, String> result = (Map<String, String>) System.JSON.deserialize(response.getBody(), Map<String, String>.class);
                // Handle successful response
                access_tokenConfluence = result.get('access_token');
                refresh_tokenConfluence = (String)result.get('refresh_token');
                expireTimeConf = (String)result.get('expires_in');
                tokenConfluence = response.getBody();
                SWKS_ConfluenceService.updateCustomSetting(new List<String>{access_tokenConfluence, refresh_tokenConfluence, expireTimeConf});
                System.debug(responseBody);
            } else {
                // Handle error response
                System.debug('HTTP Request failed with status code: ' + response.getStatusCode());
            }
        }
        
    }*/
    
     /*public PageReference genenateAuthorizeCodeForConfluence(){	
        try {
            String state = 'Sky123';
        
            // Construct the query parameters
            String authorizeSendURL = AUTHURL +
                                '&client_id=' + EncodingUtil.urlEncode(JIRACLIENTID, 'UTF-8') +
                                '&scope=' + EncodingUtil.urlEncode(CONFLUENCESCOPE, 'UTF-8') +
                                '&redirect_uri=' + EncodingUtil.urlEncode(REDIRECTURL, 'UTF-8') +
                                '&state=' + EncodingUtil.urlEncode(state, 'UTF-8') +
                                '&response_type=code' +
                                '&prompt=consent';
    
            System.debug('authorizeSendURL'+ authorizeSendURL);
            PageReference pageRef = new PageReference(authorizeSendURL);
            pageRef.setRedirect(true);
            system.debug(flag.First_Time_Integration_Type__c);
            flag.First_Time_Integration_Type__c = 'conf';
            upsert(flag);
            return pageRef;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public void onLoad()
    {
        system.debug('inside on load'+flag.First_Time_Integration_Type__c);
        if(flag.First_Time_Integration_Type__c == 'jira'){
            system.debug('inside if'+flag.First_Time_Integration_Type__c);
        	auth_code =  ApexPages.currentPage().getParameters().get('code');
        }
        else if(flag.First_Time_Integration_Type__c == 'conf'){
            system.debug('inside else '+ flag.First_Time_Integration_Type__c);
            auth_code_Conf = ApexPages.currentPage().getParameters().get('code');
        }
        //callout

    }*/
}