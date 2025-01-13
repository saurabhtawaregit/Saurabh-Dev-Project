public class SWKS_AttachmentsToAtlassianBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{

    // Variables to store parameters
    /*private String endPointURL;
    private String accessToken;
    private String recordId;
    private String integrationType;
    private String link;
    
    // Constructor to initialize parameters
    public SWKS_AttachmentsToAtlassianBatch(String endPointURL, String accessToken, String recordId, String integrationType, String link) {
        this.endPointURL = endPointURL;
        this.accessToken = accessToken;
        this.recordId = recordId;
        this.integrationType = integrationType;
        this.link = link;
        System.debug('end: '+ endPointURL);
        System.debug('accessToken: '+ accessToken);
        System.debug('rec: '+ recordId);
    }*/

    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query records to process
        Database.QueryLocator caseRecord = Database.getQueryLocator([SELECT Id, subject 
                                                                     FROM Case 
                                                                     ]);
        return caseRecord;
    }

    public void execute(Database.BatchableContext bc, List<Case> scope) {
        /*System.debug('inside execute');
        //caseRecordId = scope[0];
        //System.debug('caseRecordId'+caseRecordId);
        Set<Id> contDocIds = new Set<Id>();
        List<ContentDocumentLink> contentLink = [SELECT Id, LinkedEntityId, ContentDocumentId
                                                 FROM ContentDocumentLink
                                                 WHERE LinkedEntityId =: this.recordId
                                                ];

        if(!contentLink.isEmpty()){
        for(ContentDocumentLink contRecord: contentLink){
            contDocIds.add(contRecord.ContentDocumentId) ;
          }
        }
        list<ContentVersion> contentVersionList =  [SELECT VersionData, Title, ContentDocumentId, FileExtension
                                                    FROM ContentVersion 
                                                    WHERE ContentDocumentId IN: contDocIds
                                                    ];
        System.debug('attch: '+contentVersionList);
        for(ContentVersion contentD:contentVersionList) {
            if(contentD != null && contentD.Title != null && contentD.VersionData != null){
                String file_name = contentD.Title;
                Blob file_body = contentD.VersionData;
        
                String url = this.endPointURL;
        
                String boundary = '----------------------------741e90d31eff';
        
                String header = '--' + boundary + '\n' +
        
                    'Content-Disposition: form-data; name="file"; filename="' + file_name + '";\n' +
        
                    'Content-Type: application/octet-stream';
        
                String footer = '--' + boundary + '--';
        
                String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));
        
                while (headerEncoded.endsWith('=')){
        
                    header += ' ';
        
                    headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        
                }
        
                String bodyEncoded = EncodingUtil.base64Encode(file_body);
        
                Blob bodyBlob = null;
        
                String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
        
                if (last4Bytes.endsWith('==')) {
        
                    last4Bytes = last4Bytes.substring(0, 2) + '0K';
        
                    bodyEncoded = bodyEncoded.substring(0, bodyEncoded.length() - 4) + last4Bytes;
        
                    String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        
                    bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);
        
                } else if (last4Bytes.endsWith('=')) {
        
                    last4Bytes = last4Bytes.substring(0, 3) + 'N';
        
                    bodyEncoded = bodyEncoded.substring(0, bodyEncoded.length()-4) + last4Bytes;
        
                    footer = '\n' + footer;
        
                    String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        
                    bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);              
        
                } else {
        
                    footer = '\r\n' + footer;
        
                    String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        
                    bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);  
        
                }
        
                HttpRequest req = new HttpRequest();
        
                req.setHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
        
                req.setHeader('Authorization', 'Bearer ' + accessToken);
        
                req.setHeader('X-Atlassian-Token', 'nocheck');
        
                req.setMethod('POST');
        
                req.setEndpoint(url);
        
                req.setBodyAsBlob(bodyBlob);
        
                req.setTimeout(120000);
        
                Http h = new Http();
        
                HTTPResponse res = h.send(req);
                System.debug('Attachemet Response'+res.getBody());
            }
        }*/
    }

    public void finish(Database.BatchableContext BC) {
        // Perform any post-processing tasks
        /*system.debug('inside finish: ');
        Case singleCaseRecord = new Case();
        if(this.recordId != null){
           singleCaseRecord = [Select id,CaseNumber FROM Case WHERE Id =: this.recordId LIMIT 1]; 
        }
        List<String> userEmail = new List<String>{UserInfo.getUserEmail()};
        OrgWideEmailAddress owa = SWKS_Utility.getOrgWideEmailAddress(SWKS_Constants.SKYWORKS_NO_REPLY_OWE_NAME);
        System.debug('singleCaseRecord'+singleCaseRecord);

        if(integrationType == 'conf'){
            System.debug('CaseRecord'+this.recordId);

            SWKS_EmailUtility.sendEmail(userEmail, SWKS_Utility.getEmailTemplate('SWKS_AttachmentToConfluence'),
                                        owa,singleCaseRecord, false, false, this.link);
        }
        else {
            SWKS_EmailUtility.sendEmail(userEmail, SWKS_Utility.getEmailTemplate('SWKS_AttachmentToJira'),
                                        owa, singleCaseRecord, false, false, this.link);
        }*/
    }
}