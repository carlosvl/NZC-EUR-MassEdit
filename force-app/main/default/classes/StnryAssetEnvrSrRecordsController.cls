/**
 * @description Controller class for managing related environmental records for Stationary Asset Environmental Source
 * Provides methods to query and create related records including Scope3PcmtSummary, StnryAssetEnrgyUse,
 * StnryAssetWaterActvty, and GeneratedWaste records
 */
public with sharing class StnryAssetEnvrSrRecordsController {
    
    private static Map<String, String> sObjectNameToRelationshipField = new Map<String, String>();
    
    /**
     * @description Retrieves Scope3PcmtSummary records related to the specified Stationary Asset Environmental Source
     * @param recordId The ID of the StnryAssetEnvrSrc record
     * @return List of Scope3PcmtSummary records related to the specified record
     */
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
    
    /**
     * @description Retrieves StnryAssetEnrgyUse records related to the specified Stationary Asset Environmental Source
     * @param recordId The ID of the StnryAssetEnvrSrc record
     * @return List of StnryAssetEnrgyUse records related to the specified record
     */
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
    
    /**
     * @description Retrieves StnryAssetWaterActvty records related to the specified Stationary Asset Environmental Source
     * @param recordId The ID of the StnryAssetEnvrSrc record
     * @return List of StnryAssetWaterActvty records related to the specified record
     */
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
    
    /**
     * @description Retrieves GeneratedWaste records related to the specified Stationary Asset Environmental Source
     * @param recordId The ID of the StnryAssetEnvrSrc record
     * @return List of GeneratedWaste records related to the specified record
     */
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
    
    /**
     * @description Creates a new Scope3PcmtSummary record with the provided data
     * @param recordData Map containing field values for the new record
     * @return ID of the newly created Scope3PcmtSummary record
     */
    @AuraEnabled
    public static Id createScope3PcmtSumrRecord(Map<String, Object> recordData) {
        try {
            Scope3PcmtSummary newRecord = new Scope3PcmtSummary();
            
            // Set the parent relationship
            String relationshipField = findRelationshipField(Schema.Scope3PcmtSummary.SObjectType);
            if (relationshipField != null && recordData.containsKey('StnryAssetEnvrSrcId')) {
                newRecord.put(relationshipField, (Id)recordData.get('StnryAssetEnvrSrcId'));
            }
            
            // Set fields from form data
            if (recordData.containsKey('Name')) {
                newRecord.Name = (String)recordData.get('Name');
            }
            // Note: TotalSpentAmount is read-only (formula/rollup field)
            if (recordData.containsKey('Scope3CrbnFtprntId')) {
                newRecord.Scope3CrbnFtprntId = (String)recordData.get('Scope3CrbnFtprntId');
            }
            
            if (!Schema.sObjectType.Scope3PcmtSummary.isCreateable()) {
                throw new AuraHandledException('Insufficient permissions to create Scope3PcmtSummary records');
            }
            
            insert newRecord;
            return newRecord.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating Scope3PcmtSummary record: ' + e.getMessage());
        }
    }
    
    /**
     * @description Creates a new StnryAssetEnrgyUse record with the provided data
     * @param recordData Map containing field values for the new record
     * @return ID of the newly created StnryAssetEnrgyUse record
     */
    @AuraEnabled
    public static Id createStnryAssetEnrgylRecord(Map<String, Object> recordData) {
        try {
            StnryAssetEnrgyUse newRecord = new StnryAssetEnrgyUse();
            
            // Set the parent relationship
            String relationshipField = findRelationshipField(Schema.StnryAssetEnrgyUse.SObjectType);
            if (relationshipField != null && recordData.containsKey('StnryAssetEnvrSrcId')) {
                newRecord.put(relationshipField, (Id)recordData.get('StnryAssetEnvrSrcId'));
            }
            
            // Set fields from form data
            if (recordData.containsKey('Name')) {
                newRecord.Name = (String)recordData.get('Name');
            }
            if (recordData.containsKey('FuelType')) {
                newRecord.FuelType = (String)recordData.get('FuelType');
            }
            if (recordData.containsKey('FuelConsumption')) {
                Object fuelConsumption = recordData.get('FuelConsumption');
                if (fuelConsumption != null) {
                    newRecord.FuelConsumption = fuelConsumption instanceof String ? 
                        Decimal.valueOf((String)fuelConsumption) : 
                        (Decimal)fuelConsumption;
                }
            }
            if (recordData.containsKey('FuelConsumptionUnit')) {
                newRecord.FuelConsumptionUnit = (String)recordData.get('FuelConsumptionUnit');
            }
            
            if (!Schema.sObjectType.StnryAssetEnrgyUse.isCreateable()) {
                throw new AuraHandledException('Insufficient permissions to create StnryAssetEnrgyUse records');
            }
            
            insert newRecord;
            return newRecord.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating StnryAssetEnrgyUse record: ' + e.getMessage());
        }
    }
    
    /**
     * @description Creates a new StnryAssetWaterActvty record with the provided data
     * @param recordData Map containing field values for the new record
     * @return ID of the newly created StnryAssetWaterActvty record
     */
    @AuraEnabled
    public static Id createStnryAssetWaterARecord(Map<String, Object> recordData) {
        try {
            StnryAssetWaterActvty newRecord = new StnryAssetWaterActvty();
            
            // Set the parent relationship
            String relationshipField = findRelationshipField(Schema.StnryAssetWaterActvty.SObjectType);
            if (relationshipField != null && recordData.containsKey('StnryAssetEnvrSrcId')) {
                newRecord.put(relationshipField, (Id)recordData.get('StnryAssetEnvrSrcId'));
            }
            
            // Set fields from form data
            if (recordData.containsKey('Name')) {
                newRecord.Name = (String)recordData.get('Name');
            }
            if (recordData.containsKey('ActivityType')) {
                newRecord.ActivityType = (String)recordData.get('ActivityType');
            }
            if (recordData.containsKey('ActivitySourceType')) {
                newRecord.ActivitySourceType = (String)recordData.get('ActivitySourceType');
            }
            if (recordData.containsKey('TreatmentType')) {
                newRecord.TreatmentType = (String)recordData.get('TreatmentType');
            }
            if (recordData.containsKey('Quantity')) {
                Object quantity = recordData.get('Quantity');
                if (quantity != null) {
                    newRecord.Quantity = quantity instanceof String ? 
                        Decimal.valueOf((String)quantity) : 
                        (Decimal)quantity;
                }
            }
            if (recordData.containsKey('QuantityUnit')) {
                newRecord.QuantityUnit = (String)recordData.get('QuantityUnit');
            }
            
            if (!Schema.sObjectType.StnryAssetWaterActvty.isCreateable()) {
                throw new AuraHandledException('Insufficient permissions to create StnryAssetWaterActvty records');
            }
            
            insert newRecord;
            return newRecord.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating StnryAssetWaterActvty record: ' + e.getMessage());
        }
    }
    
    /**
     * @description Creates a new GeneratedWaste record with the provided data
     * @param recordData Map containing field values for the new record including WasteType (required)
     * @return ID of the newly created GeneratedWaste record
     */
    @AuraEnabled
    public static Id createGeneratedWasteRecord(Map<String, Object> recordData) {
        try {
            // Validate required fields
            if (!recordData.containsKey('WasteType') || 
                recordData.get('WasteType') == null || 
                String.isBlank(String.valueOf(recordData.get('WasteType')))) {
                throw new AuraHandledException('Waste Type is required. Please select a value.');
            }
            
            GeneratedWaste newRecord = new GeneratedWaste();
            String relationshipField = findRelationshipField(Schema.GeneratedWaste.SObjectType);
            
            if (relationshipField != null && recordData.containsKey('StnryAssetEnvrSrcId')) {
                newRecord.put(relationshipField, (Id)recordData.get('StnryAssetEnvrSrcId'));
            }
            
            // Set field values using helper methods
            setStringField(newRecord, 'Name', recordData);
            setStringField(newRecord, 'WasteType', recordData);
            setStringField(newRecord, 'DisposalType', recordData);
            setStringField(newRecord, 'DisposalSiteType', recordData);
            setStringField(newRecord, 'DisposedWasteQuantityUnit', recordData);
            setDecimalField(newRecord, 'DisposedWasteQuantity', recordData);
            setDateField(newRecord, 'StartDate', recordData);
            setDateField(newRecord, 'EndDate', recordData);
            setIdField(newRecord, 'WstDispoEmssnFctrId', recordData);
            
            if (!Schema.sObjectType.GeneratedWaste.isCreateable()) {
                throw new AuraHandledException('Insufficient permissions to create GeneratedWaste records');
            }

            insert newRecord;
            return newRecord.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating GeneratedWaste record: ' + e.getMessage());
        }
    }
    
    /**
     * @description Retrieves picklist values for various fields used in the related record forms
     * @return Map of field names to their picklist options (label and value pairs)
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, List<Map<String, String>>> getPicklistValues() {
        Map<String, List<Map<String, String>>> picklistMap = new Map<String, List<Map<String, String>>>();
        
        try {
            // Get GeneratedWaste picklist values
            Schema.DescribeSObjectResult wasteDescribe = Schema.SObjectType.GeneratedWaste;
            Map<String, Schema.SObjectField> wasteFields = wasteDescribe.fields.getMap();
            
            // DisposalType
            if (wasteFields.containsKey('DisposalType')) {
                picklistMap.put('DisposalType', getPicklistOptions(wasteFields.get('DisposalType')));
            }
            
            // DisposalSiteType
            if (wasteFields.containsKey('DisposalSiteType')) {
                picklistMap.put('DisposalSiteType', getPicklistOptions(wasteFields.get('DisposalSiteType')));
            }
            
            // WasteType
            if (wasteFields.containsKey('WasteType')) {
                picklistMap.put('WasteType', getPicklistOptions(wasteFields.get('WasteType')));
            }
            
            // DisposedWasteQuantityUnit
            if (wasteFields.containsKey('DisposedWasteQuantityUnit')) {
                picklistMap.put('DisposedWasteQuantityUnit', getPicklistOptions(wasteFields.get('DisposedWasteQuantityUnit')));
            }
            
            // Get StnryAssetEnrgyUse picklist values
            Schema.DescribeSObjectResult energyDescribe = Schema.SObjectType.StnryAssetEnrgyUse;
            Map<String, Schema.SObjectField> energyFields = energyDescribe.fields.getMap();
            
            // FuelType
            if (energyFields.containsKey('FuelType')) {
                picklistMap.put('FuelType', getPicklistOptions(energyFields.get('FuelType')));
            }
            
            // FuelConsumptionUnit
            if (energyFields.containsKey('FuelConsumptionUnit')) {
                picklistMap.put('FuelConsumptionUnit', getPicklistOptions(energyFields.get('FuelConsumptionUnit')));
            }
            
            // Get StnryAssetWaterActvty picklist values
            Schema.DescribeSObjectResult waterDescribe = Schema.SObjectType.StnryAssetWaterActvty;
            Map<String, Schema.SObjectField> waterFields = waterDescribe.fields.getMap();
            
            // ActivityType
            if (waterFields.containsKey('ActivityType')) {
                picklistMap.put('ActivityType', getPicklistOptions(waterFields.get('ActivityType')));
            }
            
            // QuantityUnit
            if (waterFields.containsKey('QuantityUnit')) {
                picklistMap.put('QuantityUnit', getPicklistOptions(waterFields.get('QuantityUnit')));
            }
            
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error getting picklist values: ' + e.getMessage());
        }
        
        return picklistMap;
    }
    
    /**
     * @description Retrieves dependent picklist values for WasteType based on the controlling field value
     * @param controllingValue The value of the controlling field (DisposalType)
     * @return List of picklist options (label and value pairs) for the dependent field
     */
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getDependentPicklistValues(String controllingValue) {
        List<Map<String, String>> options = new List<Map<String, String>>();
        
        try {
            Schema.DescribeFieldResult wasteTypeField = GeneratedWaste.WasteType.getDescribe();
            List<Schema.PicklistEntry> wasteTypeEntries = wasteTypeField.getPicklistValues();
            
            for (Schema.PicklistEntry entry : wasteTypeEntries) {
                if (entry.isActive()) {
                    Map<String, String> option = new Map<String, String>();
                    option.put('label', entry.getLabel());
                    option.put('value', entry.getValue());
                    options.add(option);
                }
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error getting dependent picklist values: ' + e.getMessage());
        }
        
        return options;
    }
    
    private static String findRelationshipField(Schema.SObjectType sObjectType) {
        Schema.DescribeSObjectResult objectDescribe = sObjectType.getDescribe();
        String sObjectName = objectDescribe.getName();
        
        if (sObjectNameToRelationshipField.containsKey(sObjectName)) {
            return sObjectNameToRelationshipField.get(sObjectName);
        }
        
        Map<String, Schema.SObjectField> fieldMap = objectDescribe.fields.getMap();
        
        for (String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
            
            if (fieldDescribe.getType() == Schema.DisplayType.REFERENCE) {
                List<Schema.SObjectType> references = fieldDescribe.getReferenceTo();
                for (Schema.SObjectType refType : references) {
                    if (refType.getDescribe().getName() == 'StnryAssetEnvrSrc') {
                        String apiName = fieldDescribe.getName();
                        sObjectNameToRelationshipField.put(sObjectName, apiName);
                        return apiName;
                    }
                }
            }
        }
        
        return null;
    }
    
    private static List<Map<String, String>> getPicklistOptions(Schema.SObjectField field) {
        List<Map<String, String>> options = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
        
        for (Schema.PicklistEntry entry : picklistValues) {
            if (entry.isActive()) {
                Map<String, String> option = new Map<String, String>();
                option.put('label', entry.getLabel());
                option.put('value', entry.getValue());
                options.add(option);
            }
        }
        
        return options;
    }
    
    /**
     * @description Helper method to safely set a String field value from recordData
     * @param record The SObject to update
     * @param fieldName The API name of the field to set
     * @param recordData The map containing field values
     */
    private static void setStringField(SObject record, String fieldName, Map<String, Object> recordData) {
        if (recordData.containsKey(fieldName) && recordData.get(fieldName) != null) {
            String value = String.valueOf(recordData.get(fieldName));
            if (String.isNotBlank(value)) {
                record.put(fieldName, value);
            }
        }
    }
    
    /**
     * @description Helper method to safely set a Date field value from recordData
     * @param record The SObject to update
     * @param fieldName The API name of the field to set
     * @param recordData The map containing field values
     */
    private static void setDateField(SObject record, String fieldName, Map<String, Object> recordData) {
        if (recordData.containsKey(fieldName) && recordData.get(fieldName) != null) {
            Object dateValue = recordData.get(fieldName);
            if (dateValue instanceof Date) {
                record.put(fieldName, (Date)dateValue);
            } else if (dateValue instanceof String && String.isNotBlank((String)dateValue)) {
                record.put(fieldName, Date.valueOf((String)dateValue));
            }
        }
    }
    
    /**
     * @description Helper method to safely set a Decimal field value from recordData
     * @param record The SObject to update
     * @param fieldName The API name of the field to set
     * @param recordData The map containing field values
     */
    private static void setDecimalField(SObject record, String fieldName, Map<String, Object> recordData) {
        if (recordData.containsKey(fieldName) && recordData.get(fieldName) != null) {
            Object value = recordData.get(fieldName);
            String valueStr = String.valueOf(value);
            if (String.isNotBlank(valueStr)) {
                record.put(fieldName, value instanceof Decimal ? (Decimal)value : Decimal.valueOf(valueStr));
            }
        }
    }
    
    /**
     * @description Helper method to safely set an Id field value from recordData
     * @param record The SObject to update
     * @param fieldName The API name of the field to set
     * @param recordData The map containing field values
     */
    private static void setIdField(SObject record, String fieldName, Map<String, Object> recordData) {
        if (recordData.containsKey(fieldName) && recordData.get(fieldName) != null) {
            String idValue = String.valueOf(recordData.get(fieldName));
            if (String.isNotBlank(idValue)) {
                record.put(fieldName, (Id)recordData.get(fieldName));
            }
        }
    }
}

