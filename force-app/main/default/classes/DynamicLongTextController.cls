public with sharing class DynamicLongTextController {
    
    public static final String DYNAMIC_LONG_TEXT_FIELD_API_NAME = 'DynamicLongTextField__c';

    @AuraEnabled(cacheable=true)
    public static List<LongTextWrapper> getValues(String recordId) {
        String objectAPIName = getObjectAPIName(recordId);
        String fieldAPIName = getDynamicFieldForObject(objectAPIName);
        if (!String.isBlank(fieldAPIName)) {
            Map<String, Schema.SObjectField> fieldsMap = getSObjectFieldMap(objectAPIName);
            if (hasDynamicLongTextField(objectAPIName, fieldsMap, fieldAPIName)) {
                String query = buildQuery(fieldAPIName, objectAPIName, recordId);
                SObject returningObject = Database.query(query);
                List<LongTextWrapper> wrappers = buildLongTextWrapper((String)returningObject.get(fieldAPIName));
                return wrappers;
            }
            return new List<LongTextWrapper>();
        } else {
            throw new DynamicFieldException('No field mapping found');
        }
        
    }

    @AuraEnabled
    public static void saveValues(String recordId, String wrapperText) {
        Id properRecordId = Id.valueOf(recordId);
        SObject sObj = properRecordId.getSObjectType().newSObject(properRecordId);
        sObj.put(DYNAMIC_LONG_TEXT_FIELD_API_NAME, wrapperText);
        update sObj;
    }

    public class LongTextWrapper {
        
        private final String WRAPPER_IDENTIFIER_PREFIX = 'WrapperIdentifier';

        @AuraEnabled
        public String name;
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String wrapperIdentifier;
        
        public LongTextWrapper(String name, String value, Integer index) {
            this.name = name;
            this.value = value;
            this.wrapperIdentifier = WRAPPER_IDENTIFIER_PREFIX + index;
        }
    }

    private static List<LongTextWrapper> buildLongTextWrapper(String longTextFieldString) {
        Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(longTextFieldString);

        List<LongTextWrapper> wrapperList = new List<LongTextWrapper>();
        Integer index = 1;
        for (String key : jsonMap.keySet()) {
            wrapperList.add(new LongTextWrapper(key, (String)jsonMap.get(key), index));
            index++;
        }
        return wrapperList;
    }


    public static String getDynamicFieldForObject(String objectName) {
        for (Dynamic_Field_Mapping__mdt dfm : Dynamic_Field_Mapping__mdt.getAll().values()) {
            System.debug('DFM ' + dfm);
       
            if (dfm.DeveloperName == objectName) {
                return dfm.Field_API_Name__c;
            }   
        }
        return '';
    }

    private static String buildQuery(String fieldName, String objectAPIName, String recordId) {
        return 'SELECT ' + fieldName + ' FROM ' + objectAPIName + ' WHERE Id = \''+recordId + '\'';
    }

    public static String getObjectAPIName(Id recordId) {
        return recordId.getSObjectType().getDescribe().getName();
    }

    public static Map<String, Schema.SObjectField> getSObjectFieldMap(String objectAPIName) {
        SObjectType sobjectType = Schema.getGlobalDescribe().get(objectAPIName);
        return sobjectType.getDescribe().fields.getMap();
    }

    public static boolean hasDynamicLongTextField(String objectAPIName, Map<String, Schema.SObjectField> fieldsMap, String fieldAPIName) {
        return fieldsMap.containsKey(fieldAPIName);
    }

    public class DynamicFieldException extends Exception {}
}