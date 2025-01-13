public without sharing class DownloadZip {
    @AuraEnabled(cacheable=true)
    public static String getUserProfileName() {
        // Fetch the Profile Name for the running user
        return [SELECT Id,Profile.name,Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.name;
    }
    @AuraEnabled
    public static List<Id> getFiles(String recordId) {
        Set<Id> contentDocIds = new Set<Id>();
        List<Id> contentVersionIds = new List<Id>();

        // Retrieve all ContentDocumentIds associated with the case (for direct uploads)
        System.debug('content Document Ids From direct Uploads ');
        for(ContentDocumentLink cdl: [SELECT ContentDocumentId FROM ContentDocumentLink
                                        WHERE LinkedEntityId = :recordId]) {
            contentDocIds.add(cdl.ContentDocumentId);
            System.debug(cdl.ContentDocumentId+' , ');
        }

        // Retrieve EmailMessage related to the case
        List<Id> emailMessageIds = new List<Id>();
        System.debug('all the EmailMessage Ids ');
        for (EmailMessage em : [SELECT Id FROM EmailMessage WHERE ParentId = :recordId]) {
            emailMessageIds.add(em.Id);
            System.debug(em.Id+' , ');
        }

        // Retrieve ContentDocumentIds for email attachments (files) from ContentDocumentLink using separate query
        System.debug('Content Document Ids from Email Email messages');
        if (!emailMessageIds.isEmpty()) {
            for (ContentDocumentLink cdl : [SELECT ContentDocumentId FROM ContentDocumentLink
                                            WHERE LinkedEntityId IN :emailMessageIds]) {
                contentDocIds.add(cdl.ContentDocumentId);
                System.debug(cdl.ContentDocumentId+' , ');
            }
        }

        // Retrieve legacy Attachments linked to EmailMessage (if any)
        if (!emailMessageIds.isEmpty()) {
            System.debug('Attachment Ids From EmailMessage Ids,added to ContentVersion list');
            List<Attachment> emailAttachments = [SELECT Id FROM Attachment WHERE ParentId IN :emailMessageIds];
            for (Attachment att : emailAttachments) {
                // If necessary, handle as needed (e.g., converting to ContentVersion if required)
                contentVersionIds.add(att.Id);  // If you're treating legacy attachments as separate
                System.debug(att.Id);
            }
        }

        // Retrieve ContentVersion IDs for both direct uploads and email attachments
        System.debug('content version in contentDoc Ids in Content version Ids list');
        if (!contentDocIds.isEmpty()) {
            for(ContentVersion cv: [SELECT Id FROM ContentVersion 
                                     WHERE ContentDocumentId IN :contentDocIds]) {
                contentVersionIds.add(cv.Id);
                System.debug(cv.Id+' , ');
            }
        }

        return contentVersionIds.isEmpty() ? null : contentVersionIds;
    }
}