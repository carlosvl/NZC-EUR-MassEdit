import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import getScope3PcmtSumrRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getScope3PcmtSumrRecords';
import getStnryAssetEnrgylRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetEnrgylRecords';
import getStnryAssetWaterARecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetWaterARecords';
import getStnryAssetEnvrSrRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetEnvrSrRecords';
import getGeneratedWasteRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getGeneratedWasteRecords';

const FIELDS = ['StnryAssetEnvrSr__c.Id', 'StnryAssetEnvrSr__c.Name'];

export default class StnryAssetEnvrSrRecords extends NavigationMixin(LightningElement) {
    @api recordId;
    
    scope3PcmtSumrRecords = [];
    stnryAssetEnrgylRecords = [];
    stnryAssetWaterARecords = [];
    stnryAssetEnvrSrRecords = [];
    generatedWasteRecords = [];
    
    isLoading = true;
    error;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            this.loadAllRecords();
        } else if (error) {
            this.error = error;
            this.isLoading = false;
        }
    }

    loadAllRecords() {
        this.isLoading = true;
        Promise.all([
            this.loadScope3PcmtSumrRecords(),
            this.loadStnryAssetEnrgylRecords(),
            this.loadStnryAssetWaterARecords(),
            this.loadStnryAssetEnvrSrRecords(),
            this.loadGeneratedWasteRecords()
        ]).finally(() => {
            this.isLoading = false;
        });
    }

    loadScope3PcmtSumrRecords() {
        return getScope3PcmtSumrRecords({ recordId: this.recordId })
            .then(result => {
                this.scope3PcmtSumrRecords = result || [];
            })
            .catch(error => {
                console.error('Error loading Scope3PcmtSumr records:', error);
                this.error = error;
            });
    }

    loadStnryAssetEnrgylRecords() {
        return getStnryAssetEnrgylRecords({ recordId: this.recordId })
            .then(result => {
                this.stnryAssetEnrgylRecords = result || [];
            })
            .catch(error => {
                console.error('Error loading StnryAssetEnrgyl records:', error);
                this.error = error;
            });
    }

    loadStnryAssetWaterARecords() {
        return getStnryAssetWaterARecords({ recordId: this.recordId })
            .then(result => {
                this.stnryAssetWaterARecords = result || [];
            })
            .catch(error => {
                console.error('Error loading StnryAssetWaterA records:', error);
                this.error = error;
            });
    }

    loadStnryAssetEnvrSrRecords() {
        return getStnryAssetEnvrSrRecords({ recordId: this.recordId })
            .then(result => {
                this.stnryAssetEnvrSrRecords = result || [];
            })
            .catch(error => {
                console.error('Error loading StnryAssetEnvrSr records:', error);
                this.error = error;
            });
    }

    loadGeneratedWasteRecords() {
        return getGeneratedWasteRecords({ recordId: this.recordId })
            .then(result => {
                this.generatedWasteRecords = result || [];
            })
            .catch(error => {
                console.error('Error loading GeneratedWaste records:', error);
                this.error = error;
            });
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
}

