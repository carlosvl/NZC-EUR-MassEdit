import { createElement } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import StnryAssetEnvrSrRecords from 'c/stnryAssetEnvrSrRecords';
import getScope3PcmtSumrRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getScope3PcmtSumrRecords';
import getStnryAssetEnrgylRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetEnrgylRecords';
import getStnryAssetWaterARecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetWaterARecords';
import getStnryAssetEnvrSrRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetEnvrSrRecords';
import getGeneratedWasteRecords from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getGeneratedWasteRecords';
import getPicklistValues from '@salesforce/apex/StnryAssetEnvrSrRecordsController.getPicklistValues';

jest.mock(
    '@salesforce/apex/StnryAssetEnvrSrRecordsController.getScope3PcmtSumrRecords',
    () => ({ default: jest.fn() }),
    { virtual: true }
);
jest.mock(
    '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetEnrgylRecords',
    () => ({ default: jest.fn() }),
    { virtual: true }
);
jest.mock(
    '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetWaterARecords',
    () => ({ default: jest.fn() }),
    { virtual: true }
);
jest.mock(
    '@salesforce/apex/StnryAssetEnvrSrRecordsController.getStnryAssetEnvrSrRecords',
    () => ({ default: jest.fn() }),
    { virtual: true }
);
jest.mock(
    '@salesforce/apex/StnryAssetEnvrSrRecordsController.getGeneratedWasteRecords',
    () => ({ default: jest.fn() }),
    { virtual: true }
);
jest.mock(
    '@salesforce/apex/StnryAssetEnvrSrRecordsController.getPicklistValues',
    () => ({ default: jest.fn() }),
    { virtual: true }
);

const MOCK_RECORD_ID = '0ph1Q000000CaR7QAK';
const MOCK_PICKLIST_DATA = {
    FuelType: [
        { label: 'Electricity', value: 'Electricity' },
        { label: 'Natural Gas', value: 'Natural Gas' }
    ],
    FuelConsumptionUnit: [
        { label: 'kWh', value: 'kWh' },
        { label: 'MWh', value: 'MWh' }
    ]
};

const MOCK_ENERGY_RECORDS = [
    {
        Id: '001',
        Name: 'Energy Record 1',
        FuelType: 'Electricity',
        FuelConsumption: 100,
        FuelConsumptionUnit: 'kWh',
        CreatedDate: '2024-01-01T00:00:00Z'
    }
];

describe('c-stnry-asset-envr-sr-records', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    async function flushPromises() {
        return new Promise(resolve => setTimeout(resolve, 0));
    }

    it('should render the component with title', () => {
        const stnryAssetEnvrSrRecords = createElement('c-stnry-asset-envr-sr-records', {
            is: StnryAssetEnvrSrRecords
        });
        document.body.appendChild(stnryAssetEnvrSrRecords);

        const card = stnryAssetEnvrSrRecords.shadowRoot.querySelector('lightning-card');
        expect(card).toBeTruthy();
        expect(card.title).toBe('Related Records');
    });

    it('should show loading spinner initially', () => {
        const stnryAssetEnvrSrRecords = createElement('c-stnry-asset-envr-sr-records', {
            is: StnryAssetEnvrSrRecords
        });
        document.body.appendChild(stnryAssetEnvrSrRecords);

        const spinner = stnryAssetEnvrSrRecords.shadowRoot.querySelector('lightning-spinner');
        expect(spinner).toBeTruthy();
    });

    it('should load and display energy records when data is available', async () => {
        getPicklistValues.mockResolvedValue(MOCK_PICKLIST_DATA);
        getStnryAssetEnrgylRecords.mockResolvedValue(MOCK_ENERGY_RECORDS);
        getScope3PcmtSumrRecords.mockResolvedValue([]);
        getStnryAssetWaterARecords.mockResolvedValue([]);
        getStnryAssetEnvrSrRecords.mockResolvedValue([]);
        getGeneratedWasteRecords.mockResolvedValue([]);

        const stnryAssetEnvrSrRecords = createElement('c-stnry-asset-envr-sr-records', {
            is: StnryAssetEnvrSrRecords
        });
        stnryAssetEnvrSrRecords.recordId = MOCK_RECORD_ID;
        document.body.appendChild(stnryAssetEnvrSrRecords);

        getRecord.emit({
            Id: MOCK_RECORD_ID,
            Name: 'Test Record'
        });

        await flushPromises();

        const tables = stnryAssetEnvrSrRecords.shadowRoot.querySelectorAll('table');
        expect(tables.length).toBeGreaterThan(0);

        const links = stnryAssetEnvrSrRecords.shadowRoot.querySelectorAll('a.slds-text-link');
        expect(links.length).toBe(1);
        expect(links[0].textContent).toBe('Energy Record 1');
    });

    it('should display "No records found" when no data is returned', async () => {
        getPicklistValues.mockResolvedValue(MOCK_PICKLIST_DATA);
        getStnryAssetEnrgylRecords.mockResolvedValue([]);
        getScope3PcmtSumrRecords.mockResolvedValue([]);
        getStnryAssetWaterARecords.mockResolvedValue([]);
        getStnryAssetEnvrSrRecords.mockResolvedValue([]);
        getGeneratedWasteRecords.mockResolvedValue([]);

        const stnryAssetEnvrSrRecords = createElement('c-stnry-asset-envr-sr-records', {
            is: StnryAssetEnvrSrRecords
        });
        stnryAssetEnvrSrRecords.recordId = MOCK_RECORD_ID;
        document.body.appendChild(stnryAssetEnvrSrRecords);

        getRecord.emit({
            Id: MOCK_RECORD_ID,
            Name: 'Test Record'
        });

        await flushPromises();

        const noRecordsMessages = stnryAssetEnvrSrRecords.shadowRoot.querySelectorAll(
            'p.slds-text-body_regular.slds-text-color_weak'
        );
        expect(noRecordsMessages.length).toBeGreaterThan(0);
    });

    it('should open modal when New Record button is clicked', () => {
        const stnryAssetEnvrSrRecords = createElement('c-stnry-asset-envr-sr-records', {
            is: StnryAssetEnvrSrRecords
        });
        document.body.appendChild(stnryAssetEnvrSrRecords);

        const newRecordButton = stnryAssetEnvrSrRecords.shadowRoot.querySelector(
            'lightning-button[label="New Record"]'
        );
        expect(newRecordButton).toBeTruthy();

        newRecordButton.click();

        const modal = stnryAssetEnvrSrRecords.shadowRoot.querySelector('.slds-modal');
        expect(modal).toBeTruthy();
    });

    it('should close modal when close button is clicked', () => {
        const stnryAssetEnvrSrRecords = createElement('c-stnry-asset-envr-sr-records', {
            is: StnryAssetEnvrSrRecords
        });
        document.body.appendChild(stnryAssetEnvrSrRecords);

        const newRecordButton = stnryAssetEnvrSrRecords.shadowRoot.querySelector(
            'lightning-button[label="New Record"]'
        );
        newRecordButton.click();

        let modal = stnryAssetEnvrSrRecords.shadowRoot.querySelector('.slds-modal');
        expect(modal).toBeTruthy();

        const closeButton = stnryAssetEnvrSrRecords.shadowRoot.querySelector(
            '.slds-modal__close'
        );
        closeButton.click();

        modal = stnryAssetEnvrSrRecords.shadowRoot.querySelector('.slds-modal');
        expect(modal).toBeFalsy();
    });

    it('should handle error when loading records fails', async () => {
        const errorMessage = 'Failed to fetch records';
        getPicklistValues.mockResolvedValue(MOCK_PICKLIST_DATA);
        getStnryAssetEnrgylRecords.mockRejectedValue(new Error(errorMessage));
        getScope3PcmtSumrRecords.mockResolvedValue([]);
        getStnryAssetWaterARecords.mockResolvedValue([]);
        getStnryAssetEnvrSrRecords.mockResolvedValue([]);
        getGeneratedWasteRecords.mockResolvedValue([]);

        const stnryAssetEnvrSrRecords = createElement('c-stnry-asset-envr-sr-records', {
            is: StnryAssetEnvrSrRecords
        });
        stnryAssetEnvrSrRecords.recordId = MOCK_RECORD_ID;
        document.body.appendChild(stnryAssetEnvrSrRecords);

        getRecord.emit({
            Id: MOCK_RECORD_ID,
            Name: 'Test Record'
        });

        await flushPromises();

        const spinner = stnryAssetEnvrSrRecords.shadowRoot.querySelector('lightning-spinner');
        expect(spinner).toBeFalsy();
    });

    it('should show record type selection in modal', () => {
        const stnryAssetEnvrSrRecords = createElement('c-stnry-asset-envr-sr-records', {
            is: StnryAssetEnvrSrRecords
        });
        document.body.appendChild(stnryAssetEnvrSrRecords);

        const newRecordButton = stnryAssetEnvrSrRecords.shadowRoot.querySelector(
            'lightning-button[label="New Record"]'
        );
        newRecordButton.click();

        const recordTypeButtons = stnryAssetEnvrSrRecords.shadowRoot.querySelectorAll(
            '.record-type-button'
        );
        expect(recordTypeButtons.length).toBe(5);
    });
});

