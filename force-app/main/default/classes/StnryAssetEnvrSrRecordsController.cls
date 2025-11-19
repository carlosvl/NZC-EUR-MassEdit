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
            
            if (recordData.containsKey('Name') && recordData.get('Name') != null) {
                newRecord.Name = String.valueOf(recordData.get('Name'));
            }
            
            if (recordData.containsKey('WasteType') && recordData.get('WasteType') != null) {
                String wasteType = String.valueOf(recordData.get('WasteType'));
                if (String.isNotBlank(wasteType)) {
                    newRecord.WasteType = wasteType;
                }
            }
            
            if (recordData.containsKey('DisposalType') && recordData.get('DisposalType') != null) {
                String disposalType = String.valueOf(recordData.get('DisposalType'));
                if (String.isNotBlank(disposalType)) {
                    newRecord.DisposalType = disposalType;
                }
            }
            
            if (recordData.containsKey('DisposalSiteType') && recordData.get('DisposalSiteType') != null) {
                String disposalSiteType = String.valueOf(recordData.get('DisposalSiteType'));
                if (String.isNotBlank(disposalSiteType)) {
                    newRecord.DisposalSiteType = disposalSiteType;
                }
            }
            
            if (recordData.containsKey('DisposedWasteQuantity') && recordData.get('DisposedWasteQuantity') != null) {
                Object quantity = recordData.get('DisposedWasteQuantity');
                String quantityStr = String.valueOf(quantity);
                if (String.isNotBlank(quantityStr)) {
                    newRecord.DisposedWasteQuantity = quantity instanceof Decimal ? 
                        (Decimal)quantity : Decimal.valueOf(quantityStr);
                }
            }
            
            if (recordData.containsKey('DisposedWasteQuantityUnit') && recordData.get('DisposedWasteQuantityUnit') != null) {
                String unit = String.valueOf(recordData.get('DisposedWasteQuantityUnit'));
                if (String.isNotBlank(unit)) {
                    newRecord.DisposedWasteQuantityUnit = unit;
                }
            }
            
            if (recordData.containsKey('StartDate') && recordData.get('StartDate') != null) {
                Object startDateValue = recordData.get('StartDate');
                if (startDateValue instanceof Date) {
                    newRecord.StartDate = (Date)startDateValue;
                } else if (startDateValue instanceof String && String.isNotBlank((String)startDateValue)) {
                    newRecord.StartDate = Date.valueOf((String)startDateValue);
                }
            }
            
            if (recordData.containsKey('EndDate') && recordData.get('EndDate') != null) {
                Object endDateValue = recordData.get('EndDate');
                if (endDateValue instanceof Date) {
                    newRecord.EndDate = (Date)endDateValue;
                } else if (endDateValue instanceof String && String.isNotBlank((String)endDateValue)) {
                    newRecord.EndDate = Date.valueOf((String)endDateValue);
                }
            }
            
            if (recordData.containsKey('WstDispoEmssnFctrId') && recordData.get('WstDispoEmssnFctrId') != null) {
                String lookupId = String.valueOf(recordData.get('WstDispoEmssnFctrId'));
                if (String.isNotBlank(lookupId)) {
                    newRecord.WstDispoEmssnFctrId = (Id)recordData.get('WstDispoEmssnFctrId');
                }
            }
            
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
}

