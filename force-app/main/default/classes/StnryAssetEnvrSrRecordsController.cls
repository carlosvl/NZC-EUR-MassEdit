public with sharing class StnryAssetEnvrSrRecordsController {
    
    // Cache for relationship field names
    private static Map<String, String> relationshipFieldCache = new Map<String, String>();
    
    /**
     * Finds the relationship field name that references StnryAssetEnvrSr__c
     * @param sObjectType The SObjectType to inspect
     * @return The API name of the relationship field, or null if not found
     */
    private static String findRelationshipField(Schema.SObjectType sObjectType) {
        String sObjectName = sObjectType.getDescribe().getName();
        
        // Check cache first
        if (relationshipFieldCache.containsKey(sObjectName)) {
            return relationshipFieldCache.get(sObjectName);
        }
        
        // Describe all fields on the object
        Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
        
        for (String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
            
            // Check if this is a reference field pointing to StnryAssetEnvrSr__c
            if (fieldDescribe.getType() == Schema.DisplayType.REFERENCE) {
                List<Schema.SObjectType> references = fieldDescribe.getReferenceTo();
                for (Schema.SObjectType refType : references) {
                    if (refType.getDescribe().getName() == 'StnryAssetEnvrSrc') {
                        String apiName = fieldDescribe.getName();
                        relationshipFieldCache.put(sObjectName, apiName);
                        return apiName;
                    }
                }
            }
        }
        
        return null;
    }
    
    /**
     * Finds unit-related fields on an object
     * @param sObjectType The SObjectType to inspect
     * @return Comma-separated list of unit field names
     */
    private static String findUnitFields(Schema.SObjectType sObjectType) {
        List<String> unitFields = new List<String>();
        Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
        
        for (String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
            String label = fieldDescribe.getLabel().toLowerCase();
            String apiName = fieldDescribe.getName().toLowerCase();
            
            // Look for fields containing "unit", "qty", "quantity"
            if (label.contains('unit') || apiName.contains('unit') || 
                label.contains('quantity') || apiName.contains('quantity') ||
                label.contains('qty') || apiName.contains('qty')) {
                unitFields.add(fieldDescribe.getName());
            }
        }
        
        return String.join(unitFields, ', ');
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Scope3PcmtSummary> getScope3PcmtSumrRecords(Id recordId) {
        try {
            String relationshipField = findRelationshipField(Schema.Scope3PcmtSummary.SObjectType);
            
            if (relationshipField == null) {
                return new List<Scope3PcmtSummary>();
            }
            
            String query = 'SELECT Id, Name, TotalSpentAmount, Scope3CrbnFtprntId ' +
                          'FROM Scope3PcmtSummary ' +
                          'WHERE ' + relationshipField + ' = :recordId ' +
                          'ORDER BY Name LIMIT 1000';
            
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching Scope3PcmtSummary records: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<StnryAssetEnrgyUse> getStnryAssetEnrgylRecords(Id recordId) {
        try {
            String relationshipField = findRelationshipField(Schema.StnryAssetEnrgyUse.SObjectType);
            
            if (relationshipField == null) {
                return new List<StnryAssetEnrgyUse>();
            }
            
            String query = 'SELECT Id, Name, CreatedDate, FuelType, FuelConsumption, FuelConsumptionUnit ' +
                          'FROM StnryAssetEnrgyUse ' +
                          'WHERE ' + relationshipField + ' = :recordId ' +
                          'ORDER BY Name LIMIT 1000';
            
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching StnryAssetEnrgyUse records: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<StnryAssetWaterActvty> getStnryAssetWaterARecords(Id recordId) {
        try {
            String relationshipField = findRelationshipField(Schema.StnryAssetWaterActvty.SObjectType);
            
            if (relationshipField == null) {
                return new List<StnryAssetWaterActvty>();
            }
            
            String query = 'SELECT Id, Name, ActivityType, ActivitySourceType, TreatmentType, Quantity, QuantityUnit ' +
                          'FROM StnryAssetWaterActvty ' +
                          'WHERE ' + relationshipField + ' = :recordId ' +
                          'ORDER BY Name LIMIT 1000';
            
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching StnryAssetWaterActvty records: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<StnryAssetEnvrSrc> getStnryAssetEnvrSrRecords(Id recordId) {
        try {
            // Query related StnryAssetEnvrSrc records (if there's a parent-child relationship)
            // This might need adjustment based on your data model
            return [
                SELECT Id, Name, Country, City
                FROM StnryAssetEnvrSrc
                WHERE Id = :recordId
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching StnryAssetEnvrSrc records: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<GeneratedWaste> getGeneratedWasteRecords(Id recordId) {
        try {
            String relationshipField = findRelationshipField(Schema.GeneratedWaste.SObjectType);
            
            if (relationshipField == null) {
                return new List<GeneratedWaste>();
            }
            
            String query = 'SELECT Id, Name, DisposalType, DisposalSiteType, DisposedWasteQuantity, WasteType ' +
                          'FROM GeneratedWaste ' +
                          'WHERE ' + relationshipField + ' = :recordId ' +
                          'ORDER BY Name LIMIT 1000';
            
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching GeneratedWaste records: ' + e.getMessage());
        }
    }
}

