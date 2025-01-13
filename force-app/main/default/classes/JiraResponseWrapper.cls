public class JiraResponseWrapper {
    @AuraEnabled public String id;    //10004
    @AuraEnabled public String key;    //SFDCTEAM-5
    @AuraEnabled public String self; 
    @AuraEnabled public String error;
    @AuraEnabled public boolean success = false;
    @AuraEnabled public boolean alreadyExist = false;
    @AuraEnabled 
    public static JiraResponseWrapper parse(String json){
        return (JiraResponseWrapper) System.JSON.deserialize(json, JiraResponseWrapper.class);
    }
}