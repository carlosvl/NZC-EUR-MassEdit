public with sharing class StnryAssetEnvrSrRecordsController {
    
    private static Map<String, String> sObjectNameToRelationshipField = new Map<String, String>();
    
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
            
            insert newRecord;
            return newRecord.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating Scope3PcmtSummary record: ' + e.getMessage());
        }
    }
    
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
            
            insert newRecord;
            return newRecord.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating StnryAssetEnrgyUse record: ' + e.getMessage());
        }
    }
    
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
            
            insert newRecord;
            return newRecord.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating StnryAssetWaterActvty record: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Id createStnryAssetEnvrSrRecord(Map<String, Object> recordData) {
        try {
            StnryAssetEnvrSrc newRecord = new StnryAssetEnvrSrc();
            
            // Set fields from form data
            if (recordData.containsKey('Name')) {
                newRecord.Name = (String)recordData.get('Name');
            }
            if (recordData.containsKey('Country')) {
                newRecord.Country = (String)recordData.get('Country');
            }
            if (recordData.containsKey('City')) {
                newRecord.City = (String)recordData.get('City');
            }
            
            insert newRecord;
            return newRecord.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating StnryAssetEnvrSrc record: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Id createGeneratedWasteRecord(Map<String, Object> recordData) {
        try {
            GeneratedWaste newRecord = new GeneratedWaste();
            String relationshipField = findRelationshipField(Schema.GeneratedWaste.SObjectType);
            
            if (relationshipField != null && recordData.containsKey('StnryAssetEnvrSrcId')) {
                newRecord.put(relationshipField, (Id)recordData.get('StnryAssetEnvrSrcId'));
            }
            
            if (recordData.containsKey('Name')) {
                Object nameValue = recordData.get('Name');
                if (nameValue != null && String.isNotBlank(String.valueOf(nameValue))) {
                    newRecord.Name = String.valueOf(nameValue);
                }
            }
            
            if (recordData.containsKey('DisposalType')) {
                Object disposalTypeValue = recordData.get('DisposalType');
                if (disposalTypeValue != null && String.isNotBlank(String.valueOf(disposalTypeValue))) {
                    newRecord.DisposalType = String.valueOf(disposalTypeValue);
                }
            }
            
            if (recordData.containsKey('DisposalSiteType')) {
                Object disposalSiteTypeValue = recordData.get('DisposalSiteType');
                if (disposalSiteTypeValue != null && String.isNotBlank(String.valueOf(disposalSiteTypeValue))) {
                    newRecord.DisposalSiteType = String.valueOf(disposalSiteTypeValue);
                }
            }
            
            if (recordData.containsKey('DisposedWasteQuantity')) {
                Object disposedWasteQuantity = recordData.get('DisposedWasteQuantity');
                if (disposedWasteQuantity != null && String.isNotBlank(String.valueOf(disposedWasteQuantity))) {
                    newRecord.DisposedWasteQuantity = disposedWasteQuantity instanceof String ? 
                        Decimal.valueOf((String)disposedWasteQuantity) : 
                        (Decimal)disposedWasteQuantity;
                }
            }
            
            if (recordData.containsKey('WasteType')) {
                Object wasteTypeValue = recordData.get('WasteType');
                if (wasteTypeValue != null && String.isNotBlank(String.valueOf(wasteTypeValue))) {
                    newRecord.WasteType = String.valueOf(wasteTypeValue);
                }
            }
            
            insert newRecord;
            return newRecord.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating GeneratedWaste record: ' + e.getMessage());
        }
    }
    
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
            System.debug('Error getting picklist values: ' + e.getMessage());
        }
        
        return picklistMap;
    }
    
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
            System.debug('Error getting dependent picklist values: ' + e.getMessage());
        }
        
        return options;
    }
    
    private static String findRelationshipField(Schema.SObjectType sObjectType) {
        String sObjectName = sObjectType.getDescribe().getName();
        
        if (sObjectNameToRelationshipField.containsKey(sObjectName)) {
            return sObjectNameToRelationshipField.get(sObjectName);
        }
        
        Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
        
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

