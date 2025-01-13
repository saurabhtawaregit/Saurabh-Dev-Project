public class LableToContentMapService {
    
    public static Map<String, String> getMappingFromMetadataByPage(Set<String> pageTypes) {
        Map<String, String> labelToContentMap = new Map<String, String>();
        
        List<LabelToContentMap__mdt> metadataRecords = [
            SELECT Label, Content__c, Page_Type__c 
            FROM LabelToContentMap__mdt 
            WHERE Page_Type__c IN :pageTypes
        ];
        
        for (LabelToContentMap__mdt record : metadataRecords) {
            labelToContentMap.put(record.Label, record.Content__c);
        }
        
        return labelToContentMap;
    }
}