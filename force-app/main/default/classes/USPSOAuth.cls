public class USPSOAuth {
    // Define the endpoint and HTTP request
	public static FINAL String USPS_AUTH_URL = USPS_Metadata__mdt.getInstance('Authorization_Url').value__c;
	public static FINAL String USPS_ENDPOINT = USPS_Metadata__mdt.getInstance('Endpoint_Url').value__c;
	public static FINAL String USPS_ClIENTID = USPS_Metadata__mdt.getInstance('Client_Id').value__c;
	public static FINAL String USPS_SECRETKEY = USPS_Metadata__mdt.getInstance('Client_Secret').value__c;

    // Method to get the access token from USPS API
    public static string getAccessToken() {
		String accessToken;
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            
            // Set the endpoint, method, and headers
            request.setEndpoint(USPS_AUTH_URL);
            //request.setEndpoint('callout:USPS/oauth2/v3/token');
            request.setMethod('POST');

			request.setHeader('Content-Type', 'application/json');
            String json = '{"grant_type":"client_credentials",' + 
            '"client_id":"' + USPS_ClIENTID + '",' +
            '"client_secret":"' + USPS_SECRETKEY + '"}';
            request.setBody(json);
            HttpResponse response = http.send(request);
            System.debug(request.getBody());
            
            if (response.getStatusCode() == 200) {
				 System.debug('response.getBody()>>>>'+response.getBody());
				 Map<String, Object> jsonResponse = (Map<String, Object>) System.JSON.deserializeUntyped(response.getBody());
                 accessToken = response.getBody();
            } else {
                System.debug('Error: ' + response.getStatus());
				return '';
            }
        return accessToken;
        } catch (Exception e) {
            System.debug('Error during HTTP callout: ' + e.getMessage());
			return null;
        }
    }


	public static USPSAddressResponseWrapper getAddressInfo(String streetAddress, String secondaryAddress, String city, String state,String accessToken) {
        USPSAddressResponseWrapper addressResponse;
		try {
            System.debug('streetAddress>>'+streetAddress+city+state);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            
            // Construct the full URL with query parameters
            String url = USPS_ENDPOINT + '?streetAddress=' + EncodingUtil.urlEncode(streetAddress, 'UTF-8') +
				//+ EncodingUtil.urlEncode(secondaryAddress, 'UTF-8')
                '&city=' + EncodingUtil.urlEncode(city, 'UTF-8') +
                '&state=' + EncodingUtil.urlEncode(state, 'UTF-8') +
				'&secondaryAddress=';
            
            // Set the endpoint, method, and headers
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('accept', 'application/json');
            request.setHeader('authorization', 'Bearer '+AccessToken+'');

			System.debug('getBody Address Request>>>'+request);

            // Send the HTTP request and get the response
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                // Parse the JSON response using the wrapper class
                addressResponse = (USPSAddressResponseWrapper) JSON.deserialize(response.getBody(), USPSAddressResponseWrapper.class);
                
                // Return the address response
                return addressResponse;
            } else {
                System.debug('Error: ' + response.getStatus() + ' - ' + response.getStatusCode());
                return null;
            }
        } catch (Exception e) {
            System.debug('Error during HTTP callout: ' + e.getMessage());
            return null;
        }
    }

    // Define a wrapper class to parse the JSON response
    public class USPSAuthResponseWrapper {
        public String access_token;
        public Integer expires_in;
    }

}