import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { registerRefreshHandler, unregisterRefreshHandler } from 'lightning/refresh';
import getScope3PcmtSumrRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getScope3PcmtSumrRecords';
import getStnryAssetEnrgylRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetEnrgylRecords';
import getStnryAssetWaterARecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetWaterARecords';
import getStnryAssetEnvrSrRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetEnvrSrRecords';
import getGeneratedWasteRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getGeneratedWasteRecords';

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

    connectedCallback() {
        console.log('🔵 Component Connected - recordId:', this.recordId);
    }

    renderedCallback() {
        // Register refresh handler only once after component is rendered
        if (!this.refreshHandlerRegistered) {
            try {
                registerRefreshHandler(this, () => {
                    console.log('🔄 Refresh button clicked - reloading data');
                    this.loadAllRecords();
                });
                this.refreshHandlerRegistered = true;
                console.log('✅ Refresh handler registered successfully');
            } catch (error) {
                console.error('❌ Error registering refresh handler:', error);
            }
        }
    }

    disconnectedCallback() {
        // Unregister refresh handler when component is destroyed
        if (this.refreshHandlerRegistered) {
            try {
                unregisterRefreshHandler(this);
                console.log('✅ Refresh handler unregistered');
            } catch (error) {
                console.error('❌ Error unregistering refresh handler:', error);
            }
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        console.log('🔵 Wire Method Called - recordId:', this.recordId);
        console.log('🔵 Wire Data:', data);
        console.log('🔵 Wire Error:', error);
        
        if (data) {
            console.log('✅ Record loaded successfully, calling loadAllRecords()');
            this.loadAllRecords();
        } else if (error) {
            console.error('❌ Error in wiredRecord:', error);
            this.error = error;
            this.isLoading = false;
        }
    }

    loadAllRecords() {
        console.log('🔵 Loading all records for recordId:', this.recordId);
        this.isLoading = true;
        Promise.all([
            this.loadScope3PcmtSumrRecords(),
            this.loadStnryAssetEnrgylRecords(),
            this.loadStnryAssetWaterARecords(),
            this.loadStnryAssetEnvrSrRecords(),
            this.loadGeneratedWasteRecords()
        ]).finally(() => {
            console.log('✅ All records loaded');
            console.log('📊 Scope3PcmtSumr Records:', this.scope3PcmtSumrRecords);
            console.log('📊 StnryAssetEnrgyl Records:', this.stnryAssetEnrgylRecords);
            console.log('📊 StnryAssetWaterA Records:', this.stnryAssetWaterARecords);
            console.log('📊 StnryAssetEnvrSr Records:', this.stnryAssetEnvrSrRecords);
            console.log('📊 GeneratedWaste Records:', this.generatedWasteRecords);
            this.isLoading = false;
        });
    }

    loadScope3PcmtSumrRecords() {
        console.log('📞 Calling getScope3PcmtSumrRecords with recordId:', this.recordId);
        return getScope3PcmtSumrRecords({ recordId: this.recordId })
            .then(result => {
                console.log('✅ Scope3PcmtSumr Response:', result);
                console.log('✅ Scope3PcmtSumr Record Count:', result?.length || 0);
                this.scope3PcmtSumrRecords = result || [];
            })
            .catch(error => {
                console.error('❌ Error loading Scope3PcmtSumr records:', error);
                console.error('❌ Error details:', JSON.stringify(error));
                this.error = error;
            });
    }

    loadStnryAssetEnrgylRecords() {
        console.log('📞 Calling getStnryAssetEnrgylRecords with recordId:', this.recordId);
        return getStnryAssetEnrgylRecords({ recordId: this.recordId })
            .then(result => {
                console.log('✅ StnryAssetEnrgyl Response:', result);
                console.log('✅ StnryAssetEnrgyl Record Count:', result?.length || 0);
                this.stnryAssetEnrgylRecords = result || [];
            })
            .catch(error => {
                console.error('❌ Error loading StnryAssetEnrgyl records:', error);
                console.error('❌ Error details:', JSON.stringify(error));
                this.error = error;
            });
    }

    loadStnryAssetWaterARecords() {
        console.log('📞 Calling getStnryAssetWaterARecords with recordId:', this.recordId);
        return getStnryAssetWaterARecords({ recordId: this.recordId })
            .then(result => {
                console.log('✅ StnryAssetWaterA Response:', result);
                console.log('✅ StnryAssetWaterA Record Count:', result?.length || 0);
                this.stnryAssetWaterARecords = result || [];
            })
            .catch(error => {
                console.error('❌ Error loading StnryAssetWaterA records:', error);
                console.error('❌ Error details:', JSON.stringify(error));
                this.error = error;
            });
    }

    loadStnryAssetEnvrSrRecords() {
        console.log('📞 Calling getStnryAssetEnvrSrRecords with recordId:', this.recordId);
        return getStnryAssetEnvrSrRecords({ recordId: this.recordId })
            .then(result => {
                console.log('✅ StnryAssetEnvrSr Response:', result);
                console.log('✅ StnryAssetEnvrSr Record Count:', result?.length || 0);
                this.stnryAssetEnvrSrRecords = result || [];
            })
            .catch(error => {
                console.error('❌ Error loading StnryAssetEnvrSr records:', error);
                console.error('❌ Error details:', JSON.stringify(error));
                this.error = error;
            });
    }

    loadGeneratedWasteRecords() {
        console.log('📞 Calling getGeneratedWasteRecords with recordId:', this.recordId);
        return getGeneratedWasteRecords({ recordId: this.recordId })
            .then(result => {
                console.log('✅ GeneratedWaste Response:', result);
                console.log('✅ GeneratedWaste Record Count:', result?.length || 0);
                this.generatedWasteRecords = result || [];
            })
            .catch(error => {
                console.error('❌ Error loading GeneratedWaste records:', error);
                console.error('❌ Error details:', JSON.stringify(error));
                this.error = error;
            });
    }

    navigateToRecord(event) {
        const recordId = event.currentTarget.dataset.id;
        console.log('🔗 Navigating to record:', recordId);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
    }
}

