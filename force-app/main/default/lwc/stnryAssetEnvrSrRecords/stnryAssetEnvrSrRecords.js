import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { registerRefreshHandler, unregisterRefreshHandler } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getScope3PcmtSumrRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getScope3PcmtSumrRecords';
import getStnryAssetEnrgylRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetEnrgylRecords';
import getStnryAssetWaterARecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetWaterARecords';
import getStnryAssetEnvrSrRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetEnvrSrRecords';
import getGeneratedWasteRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getGeneratedWasteRecords';
import createScope3PcmtSumrRecord from '@salesforce/apex/StnryAssetEnvrSrRecordsController.createScope3PcmtSumrRecord';
import createStnryAssetEnrgylRecord from '@salesforce/apex/StnryAssetEnvrSrRecordsController.createStnryAssetEnrgylRecord';
import createStnryAssetWaterARecord from '@salesforce/apex/StnryAssetEnvrSrRecordsController.createStnryAssetWaterARecord';
import createStnryAssetEnvrSrRecord from '@salesforce/apex/StnryAssetEnvrSrRecordsController.createStnryAssetEnvrSrRecord';
import createGeneratedWasteRecord from '@salesforce/apex/StnryAssetEnvrSrRecordsController.createGeneratedWasteRecord';
import getPicklistValues from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getPicklistValues';
import getDependentPicklistValues from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getDependentPicklistValues';

const FIELDS = ['StnryAssetEnvrSrc.Id', 'StnryAssetEnvrSrc.Name'];

export default class StnryAssetEnvrSrRecords extends NavigationMixin(LightningElement) {
    @api recordId;
    
    scope3PcmtSumrRecords = [];
    stnryAssetEnrgylRecords = [];
    stnryAssetWaterARecords = [];
    stnryAssetEnvrSrRecords = [];
    generatedWasteRecords = [];
    
    isLoading = true;
    error;
    refreshHandlerRegistered = false;

    // Modal state
    showModal = false;
    showRecordTypeSelection = true;
    selectedRecordType = '';
    formData = {};

    // Picklist options (will be dynamically loaded from Salesforce)
    fuelTypeOptions = [];
    unitOptions = [];
    activityTypeOptions = [];
    quantityUnitOptions = [];
    disposalTypeOptions = [];
    disposalSiteTypeOptions = [];
    wasteTypeOptions = [];

    // Computed properties for form visibility
    get isScope3PcmtSumr() {
        return this.selectedRecordType === 'Scope3PcmtSumr';
    }

    get isStnryAssetEnrgyl() {
        return this.selectedRecordType === 'StnryAssetEnrgyl';
    }

    get isStnryAssetWaterA() {
        return this.selectedRecordType === 'StnryAssetWaterA';
    }

    get isStnryAssetEnvrSr() {
        return this.selectedRecordType === 'StnryAssetEnvrSr';
    }

    get isGeneratedWaste() {
        return this.selectedRecordType === 'GeneratedWaste';
    }

    connectedCallback() {
        this.loadPicklistValues();
    }

    async loadPicklistValues() {
        try {
            const data = await getPicklistValues();
            this.fuelTypeOptions = data.FuelType || [];
            this.unitOptions = data.FuelConsumptionUnit || [];
            this.activityTypeOptions = data.ActivityType || [];
            this.quantityUnitOptions = data.QuantityUnit || [];
            this.disposalTypeOptions = data.DisposalType || [];
            this.disposalSiteTypeOptions = data.DisposalSiteType || [];
            this.wasteTypeOptions = data.WasteType || [];
        } catch (error) {
            console.error('Error loading picklist values:', error);
            this.setFallbackPicklistOptions();
        }
    }

    setFallbackPicklistOptions() {
        this.fuelTypeOptions = [
            { label: 'Electricity', value: 'Electricity' },
            { label: 'Natural Gas', value: 'Natural Gas' }
        ];
        this.unitOptions = [
            { label: 'kWh', value: 'kWh' },
            { label: 'MWh', value: 'MWh' }
        ];
        this.activityTypeOptions = [
            { label: 'Water Consumption', value: 'Water Consumption' },
            { label: 'Water Discharge', value: 'Water Discharge' }
        ];
        this.quantityUnitOptions = [
            { label: 'Liters', value: 'Liters' },
            { label: 'Gallons', value: 'Gallons' }
        ];
        this.disposalTypeOptions = [
            { label: 'Landfill', value: 'Landfill' },
            { label: 'Recycling', value: 'Recycling' }
        ];
        this.disposalSiteTypeOptions = [
            { label: 'Onsite', value: 'Onsite' },
            { label: 'Offsite', value: 'Offsite' }
        ];
        this.wasteTypeOptions = [
            { label: 'Municipal Solid Waste', value: 'Municipal Solid Waste' }
        ];
    }

    renderedCallback() {
        if (!this.refreshHandlerRegistered) {
            try {
                registerRefreshHandler(this, () => this.loadAllRecords());
                this.refreshHandlerRegistered = true;
            } catch (error) {
                console.error('Error registering refresh handler:', error);
            }
        }
    }

    disconnectedCallback() {
        if (this.refreshHandlerRegistered) {
            try {
                unregisterRefreshHandler(this);
            } catch (error) {
                console.error('Error unregistering refresh handler:', error);
            }
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            this.loadAllRecords();
        } else if (error) {
            this.error = error;
            this.isLoading = false;
        }
    }

    async loadAllRecords() {
        this.isLoading = true;
        try {
            await Promise.all([
                this.loadScope3PcmtSumrRecords(),
                this.loadStnryAssetEnrgylRecords(),
                this.loadStnryAssetWaterARecords(),
                this.loadStnryAssetEnvrSrRecords(),
                this.loadGeneratedWasteRecords()
            ]);
        } finally {
            this.isLoading = false;
        }
    }

    async loadScope3PcmtSumrRecords() {
        try {
            const result = await getScope3PcmtSumrRecords({ recordId: this.recordId });
            this.scope3PcmtSumrRecords = result || [];
        } catch (error) {
            console.error('Error loading Scope3PcmtSumr records:', error);
            this.error = error;
        }
    }

    async loadStnryAssetEnrgylRecords() {
        try {
            const result = await getStnryAssetEnrgylRecords({ recordId: this.recordId });
            this.stnryAssetEnrgylRecords = result || [];
        } catch (error) {
            console.error('Error loading StnryAssetEnrgyl records:', error);
            this.error = error;
        }
    }

    async loadStnryAssetWaterARecords() {
        try {
            const result = await getStnryAssetWaterARecords({ recordId: this.recordId });
            this.stnryAssetWaterARecords = result || [];
        } catch (error) {
            console.error('Error loading StnryAssetWaterA records:', error);
            this.error = error;
        }
    }

    async loadStnryAssetEnvrSrRecords() {
        try {
            const result = await getStnryAssetEnvrSrRecords({ recordId: this.recordId });
            this.stnryAssetEnvrSrRecords = result || [];
        } catch (error) {
            console.error('Error loading StnryAssetEnvrSr records:', error);
            this.error = error;
        }
    }

    async loadGeneratedWasteRecords() {
        try {
            const result = await getGeneratedWasteRecords({ recordId: this.recordId });
            this.generatedWasteRecords = result || [];
        } catch (error) {
            console.error('Error loading GeneratedWaste records:', error);
            this.error = error;
        }
    }

    navigateToRecord(event) {
        const recordId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
    }

    handleNewRecord() {
        this.showModal = true;
        this.showRecordTypeSelection = true;
        this.selectedRecordType = '';
        this.formData = {};
    }

    handleCloseModal() {
        this.showModal = false;
        this.showRecordTypeSelection = true;
        this.selectedRecordType = '';
        this.formData = {};
    }

    handleRecordTypeSelect(event) {
        const recordType = event.currentTarget.dataset.type;
        this.selectedRecordType = recordType;
        this.showRecordTypeSelection = false;
        this.initializeFormData();
    }

    handleBackToSelection() {
        this.showRecordTypeSelection = true;
        this.selectedRecordType = '';
        this.formData = {};
    }

    initializeFormData() {
        this.formData = {
            StnryAssetEnvrSrcId: this.recordId
        };
    }

    async handleInputChange(event) {
        const field = event.target.name;
        const value = event.target.value;
        this.formData = { ...this.formData, [field]: value };
        
        if (field === 'DisposalType' && value) {
            try {
                const data = await getDependentPicklistValues({ controllingValue: value });
                this.wasteTypeOptions = data;
                this.formData = { ...this.formData, WasteType: '' };
            } catch (error) {
                console.error('Error loading dependent picklist values:', error);
            }
        }
    }

    async handleSave() {
        const inputs = this.template.querySelectorAll('lightning-input[required], lightning-combobox[required]');
        const allValid = [...inputs].reduce((validSoFar, input) => {
            input.reportValidity();
            return validSoFar && input.checkValidity();
        }, true);

        if (!allValid) {
            return;
        }

        this.isLoading = true;
        try {
            let recordId;
            switch(this.selectedRecordType) {
                case 'Scope3PcmtSumr':
                    recordId = await createScope3PcmtSumrRecord({ recordData: this.formData });
                    break;
                case 'StnryAssetEnrgyl':
                    recordId = await createStnryAssetEnrgylRecord({ recordData: this.formData });
                    break;
                case 'StnryAssetWaterA':
                    recordId = await createStnryAssetWaterARecord({ recordData: this.formData });
                    break;
                case 'StnryAssetEnvrSr':
                    recordId = await createStnryAssetEnvrSrRecord({ recordData: this.formData });
                    break;
                case 'GeneratedWaste':
                    recordId = await createGeneratedWasteRecord({ recordData: this.formData });
                    break;
                default:
                    throw new Error('Unknown record type');
            }

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Record created successfully',
                    variant: 'success'
                })
            );
            
            this.handleCloseModal();
            await this.loadAllRecords();
        } catch (error) {
            console.error('Error creating record:', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: error.body?.message || error.message,
                    variant: 'error',
                    mode: 'sticky'
                })
            );
        } finally {
            this.isLoading = false;
        }
    }
}

