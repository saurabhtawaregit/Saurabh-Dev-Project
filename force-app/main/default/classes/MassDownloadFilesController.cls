//https://www.infallibletechie.com/2022/07/download-all-the-the-files-for-a-record-in-salesforce-using-lightning-web-component.html
public without sharing class MassDownloadFilesController {
    
    @AuraEnabled
    public static List < Id > fetchRelatedFiles( Id strRecordId ) {

        List < Id > listFileIds = new List < Id >();

        for ( ContentDocumentLink objCDL: [ 
            SELECT ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId =: strRecordId 
        ] ) {

            listFileIds.add( objCDL.ContentDocument.LatestPublishedVersionId );

        }

        return listFileIds;        
        
    }

}