public class VF_AtlassionOauthComponentController {
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
    public static FINAL String JIRACLIENTID = Test.isRunningTest() ? 'JIRACLIENT' : SWKS_Metadata_Setting__mdt.getInstance('Jira_Client_Id').value__c;
    public static FINAL String JIRACLIENTSECRET = Test.isRunningTest() ? 'JIRASECRET' : SWKS_Metadata_Setting__mdt.getInstance('Jira_Client_Secret').value__c;
    public static FINAL String JIRASCOPE = Test.isRunningTest() ? 'JIRASCOPE' : SWKS_Metadata_Setting__mdt.getInstance('Jira_Scope').value__c;
    public static FINAL String CONFLUENCESCOPE = Test.isRunningTest() ? 'CONFLUENCESCOPE' : SWKS_Metadata_Setting__mdt.getInstance('Confluence_Scope').value__c;
    public static FINAL String AUTHURL = Test.isRunningTest() ? 'https://test.com/authorize' : SWKS_Metadata_Setting__mdt.getInstance('Authorization_Url').value__c;
    public static FINAL String REDIRECTURL = Test.isRunningTest() ? 'https://google.com' : SWKS_Metadata_Setting__mdt.getInstance('Redirect_Url').value__c;
    public static FINAL String TOKENURL = Test.isRunningTest() ? 'JIRATOKENURL' : SWKS_Metadata_Setting__mdt.getInstance('Jira_Token_Url').value__c;
    
    public PageReference genenateAuthorizeCodeForJira(){	
        try {
            system.debug('inside fjira auth: '+flag);
            String state = 'Sky123';
        
            // Construct the query parameters
            String authorizeSendURL = AUTHURL +
                                '&client_id=' + EncodingUtil.urlEncode(JIRACLIENTID, 'UTF-8') +
                                '&scope=' + EncodingUtil.urlEncode(JIRASCOPE, 'UTF-8') +
                                '&redirect_uri=' + EncodingUtil.urlEncode(REDIRECTURL, 'UTF-8') +
                                '&state=' + EncodingUtil.urlEncode(state, 'UTF-8') +
                                '&response_type=code' +
                                '&prompt=consent';
    
            System.debug('authorizeSendURL'+ authorizeSendURL);
            PageReference pageRef = new PageReference(authorizeSendURL);
            pageRef.setRedirect(true);
            system.debug(flag.First_Time_Integration_Type__c);
            flag.First_Time_Integration_Type__c = 'jira';
            upsert(flag);
            System.debug('pageRef>>>>'+pageRef);
            return pageRef;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public PageReference genenateAuthorizeCodeForConfluence(){	
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
            System.debug('auth_code>>>>'+auth_code);
        }

    }

    public void getAndSaveTheAccessTokenForJira()
    {
        //if(!String.isEmpty(auth_code)){
            
            System.debug('in Callout>>>');
            //auth_code = 'eyJraWQiOiJiOWY2OTVlZmM3MzgwN2QxNmNhNmNkMzQiLCJhbGciOiJSUzI1NiIsInR5cCI6Imp3dCJ9.eyJuYmYiOjE3MjEwNTAzMzMsImlzcyI6ImF1dGguYXRsYXNzaWFuLmNvbSIsImlhdCI6MTcyMTA1MDMzMywiZXhwIjoxNzIxMDUzOTMzLCJhdWQiOiJhcGkuYXRsYXNzaWFuLmNvbSIsInVzZXJfaWQiOiI3MTIwMjA6NmE5ZTkzNTktNGM4My00NmM2LWJjYTItYTdkYTYwNTY5YjllIiwicmVkaXJlY3RfdXJpIjoiL2F1dGhvcml6ZT9hdWRpZW5jZT1hcGkuYXRsYXNzaWFuLmNvbSZjbGllbnRfaWQ9UHpIVUtZRTZxNEZFZ1NNTVpYQTQ3eEFVSFAwYk44cXUmcHJvbXB0PWNvbnNlbnQmcmVkaXJlY3RfdXJpPWh0dHBzOi8vc3NzdC1lLWRldi1lZC5kZXZlbG9wLmxpZ2h0bmluZy5mb3JjZS5jb20vbGlnaHRuaW5nL24vQXV0aGVudGljYXRpb25fUHJvY2Vzc19WRiZyZXNwb25zZV90eXBlPWNvZGUmc3RhdGU9U2t5MTIzJnNjb3BlPW9mZmxpbmVfYWNjZXNzK3JlYWQ6amlyYS11c2VyK3JlYWQ6amlyYS13b3JrK3dyaXRlOmppcmEtd29yayZjc3JmX3Rva2VuPTA0ZDQ0Y2RiLTYzYjUtNDUwYi05Y2MwLTEzNjYxMzdiM2ZmZiIsImNsaWVudCI6eyJjbGllbnRfaWQiOiJQekhVS1lFNnE0RkVnU01NWlhBNDd4QVVIUDBiTjhxdSIsIm5hbWUiOiJTYXVyYWJoIFNGIiwibG9nb191cmkiOiJodHRwczovL2F2YXRhci1tYW5hZ2VtZW50LS1hdmF0YXJzLnVzLXdlc3QtMi5wcm9kLnB1YmxpYy5hdGwtcGFhcy5uZXQvZGVmYXVsdC1hdmF0YXIucG5nIn19.XA4xdRMceDWMexdz8FsdtQDRcq2BTXuW3Ad-gvjabMmzXUHkQCK3pKnqZEYYZf5PF8CGtLYabHYeTT8mXhuw_5NwVuIp2jgF-j3XX06qqTWXEkQBpJgIykI2GhGajGevzGH_C79xXTY0MD68JuH6Og2hNceXwmULgPmFuAtgTOvz9WQ6StWtn1PHqfibhJIQsgH8e6OB1Ft83FhIxH2Cw39amKKJ2HoXeQhe3OMOx28oPmsEAusyUHX8UFBERkM6y-u3Y9zNSQt8FGijILbinbixuOkbaLuIUIGmoZk_6IvQRXdizgv-dlXMb0rpKreNSbj7U6xt5sihTZspEcGiGg';
            // Send the HTTP request
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(TOKENURL);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            String json = '{"grant_type":"authorization_code",' + 
            '"client_id":"'+JIRACLIENTID+'",'+
            '"client_secret":"'+JIRACLIENTSECRET+'",'+
            '"code":"' + auth_code + '",' +
            '"redirect_uri":"' + REDIRECTURL + '"}';
            req.setBody(json);
            HttpResponse response = http.send(req);
            System.debug(req.getBody());
            
            // Process the response if nseeded
            if (response.getStatusCode() == 200) {
                Map<String, String> result = (Map<String, String>) System.JSON.deserialize(response.getBody(), Map<String, String>.class);
                // Handle successful response
                access_tokenJira = result.get('access_token');
                refresh_tokenJira = (String)result.get('refresh_token');
                expireTime = (String)result.get('expires_in');
                tokenJira = response.getBody();
                JiraCalloutService.SaveAccessToken(tokenJira);
                System.debug(responseBody);
            } else {
                // Handle error response
                System.debug('HTTP Request failed with status code: ' + response.getStatusCode());
            }
        }
        //dml to the custom setting
    //}
}