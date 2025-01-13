public with sharing class JiraServiceHelper {
    public static FINAL String JiraIssueLink = SWKS_Metadata_Setting__mdt.getInstance('Jira_Issue_Link').value__c;
    
    public static void UpdateCaseWithJiraLink(JiraResponseWrapper resWrapper,Case CaseRecord){
            String jiraLink = JiraIssueLink + resWrapper.key;
            caseRecord.Jira_Link__c = jiraLink;
            System.debug('caseRecord.Jira_Link__c'+caseRecord.Jira_Link__c);
            Database.Update(caseRecord,false);
    }
}