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
                    if (refType.getDescribe().getName() == 'StnryAssetEnvrSr__c') {
                        String apiName = fieldDescribe.getName();
                        relationshipFieldCache.put(sObjectName, apiName);
                        return apiName;
                    }
                }
            }
        }
        
        return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Scope3PcmtSumr__c> getScope3PcmtSumrRecords(Id recordId) {
        try {
            String relationshipField = findRelationshipField(Schema.Scope3PcmtSumr__c.SObjectType);
            
            if (relationshipField == null) {
                return new List<Scope3PcmtSumr__c>();
            }
            
            String query = 'SELECT Id, Name, CalendarYear__c, CurrencyCode__c, IsComplete__c, ' +
                          'CarbonFootprintReportDate__c, Description__c, InflationRate__c ' +
                          'FROM Scope3PcmtSumr__c ' +
                          'WHERE ' + relationshipField + ' = :recordId ' +
                          'ORDER BY Name LIMIT 1000';
            
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching Scope3PcmtSumr records: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<StnryAssetEnrgyl__c> getStnryAssetEnrgylRecords(Id recordId) {
        try {
            String relationshipField = findRelationshipField(Schema.StnryAssetEnrgyl__c.SObjectType);
            
            if (relationshipField == null) {
                return new List<StnryAssetEnrgyl__c>();
            }
            
            String query = 'SELECT Id, Name, EndDate__c, FinalEnergyConsumption__c, Co2EmissionsInKg__c, ' +
                          'Ch4EmissionsInKg__c, FuelConsumption__c, CarbonFootprintReportDate__c ' +
                          'FROM StnryAssetEnrgyl__c ' +
                          'WHERE ' + relationshipField + ' = :recordId ' +
                          'ORDER BY Name LIMIT 1000';
            
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching StnryAssetEnrgyl records: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<StnryAssetWaterA__c> getStnryAssetWaterARecords(Id recordId) {
        try {
            String relationshipField = findRelationshipField(Schema.StnryAssetWaterA__c.SObjectType);
            
            if (relationshipField == null) {
                return new List<StnryAssetWaterA__c>();
            }
            
            String query = 'SELECT Id, Name, ActivityType__c, FinalWaterQuantity__c, QuantityUnit__c, ' +
                          'StartDate__c, EndDate__c, Quantity__c, ProposedWaterQuantity__c ' +
                          'FROM StnryAssetWaterA__c ' +
                          'WHERE ' + relationshipField + ' = :recordId ' +
                          'ORDER BY Name LIMIT 1000';
            
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching StnryAssetWaterA records: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<StnryAssetEnvrSr__c> getStnryAssetEnvrSrRecords(Id recordId) {
        try {
            // Query related StnryAssetEnvrSr records (if there's a parent-child relationship)
            // This might need adjustment based on your data model
            return [
                SELECT Id, Name, Country__c, City__c, BusinessRegion__c,
                       AccountName__c, OccupiedFloorArea__c
                FROM StnryAssetEnvrSr__c
                WHERE Id = :recordId
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching StnryAssetEnvrSr records: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<GeneratedWaste__c> getGeneratedWasteRecords(Id recordId) {
        try {
            String relationshipField = findRelationshipField(Schema.GeneratedWaste__c.SObjectType);
            
            if (relationshipField == null) {
                return new List<GeneratedWaste__c>();
            }
            
            String query = 'SELECT Id, Name, DisposalType__c, DisposedWasteQuantity__c, IsHazardous__c, ' +
                          'IsRadioactive__c, EndDate__c, DisposedWasteQuantityUnit__c, ' +
                          'Scope1EmissionsInTco2e__c ' +
                          'FROM GeneratedWaste__c ' +
                          'WHERE ' + relationshipField + ' = :recordId ' +
                          'ORDER BY Name LIMIT 1000';
            
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching GeneratedWaste records: ' + e.getMessage());
        }
    }
}

