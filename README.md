# Stationary Asset Environmental Records Manager

A Salesforce Lightning Web Component accelerator for managing environmental records related to Stationary Asset Environmental Sources. This solution streamlines the creation and visualization of environmental data including energy use, water activity, waste generation, and procurement summaries.

## 🎯 Business Problem

Organizations tracking environmental data for stationary assets often struggle with:
- **Manual data entry** across multiple related objects
- **Poor visibility** of related environmental records
- **Time-consuming navigation** between different record types
- **Inconsistent data collection** processes

This accelerator solves these problems by providing a unified interface to view and create all related environmental records from a single component.

## ✨ Features

- **Unified Dashboard**: View all related environmental records in one place
  - Scope 3 Procurement Summary
  - Stationary Asset Energy Use
  - Stationary Asset Water Activity
  - Generated Waste
- **Quick Record Creation**: Create new records with guided forms and validation
- **Smart Field Discovery**: Automatically detects relationship fields
- **Real-time Refresh**: Refresh data without leaving the page
- **Responsive Design**: Works seamlessly on desktop and mobile
- **Data Validation**: Client and server-side validation for data integrity
- **Security Built-in**: CRUD/FLS checks and proper sharing rules

## 🏗️ Technical Architecture

This accelerator contains:

### Lightning Web Components (1)
- **stnryAssetEnvrSrRecords**: Main component for displaying and managing related records
  - `stnryAssetEnvrSrRecords.js` - Component logic (338 lines)
  - `stnryAssetEnvrSrRecords.html` - Template (513 lines)
  - `stnryAssetEnvrSrRecords.css` - Styles
  - `stnryAssetEnvrSrRecords.js-meta.xml` - Metadata configuration

### Apex Classes (1)
- **StnryAssetEnvrSrRecordsController**: Backend controller with 10 public methods
  - Query methods for each related object type
  - Create methods with CRUD security checks
  - Picklist value retrieval (including dependent picklists)
  - Dynamic relationship field discovery

### Standard Objects Used
- `StnryAssetEnvrSrc` (Stationary Asset Environmental Source)
- `Scope3PcmtSummary` (Scope 3 Procurement Summary)
- `StnryAssetEnrgyUse` (Stationary Asset Energy Use)
- `StnryAssetWaterActvty` (Stationary Asset Water Activity)
- `GeneratedWaste`
- `WstDispoEmssnFctrSet` (Waste Disposal Emission Factor Set)

## 📦 Installation

### Option 1: Deploy to Salesforce (Recommended for Admins)

Click the button below to deploy directly to your Salesforce org:

[![Deploy to Salesforce](https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png)](https://githubsfdeploy.herokuapp.com/?owner=carlosvl&repo=NZC-EUR-MassEdit)

### Option 2: Salesforce CLI (Recommended for Developers)

```bash
# 1. Clone the repository
git clone https://github.com/carlosvl/NZC-EUR-MassEdit.git
cd NZC-EUR-MassEdit

# 2. Authorize your Salesforce org
sf org login web --alias my-org

# 3. Deploy the source code
sf project deploy start --target-org my-org

# 4. Verify deployment
sf project deploy report
```

### Option 3: Metadata ZIP File (Alternative for Admins)

1. Download the latest release ZIP file from the [Releases](https://github.com/carlosvl/NZC-EUR-MassEdit/releases) page
2. Use **Workbench** or **Salesforce Inspector** to deploy:
   - Navigate to: Setup → Deploy → Choose File
   - Select the downloaded ZIP file
   - Check "Run All Tests" if deploying to production
   - Click "Deploy"

## ⚙️ Post-Installation Steps

After deploying the code, complete these steps:

### 1. Add Component to Page Layout

1. Navigate to **Setup** → **Object Manager** → **Stationary Asset Environmental Source**
2. Select **Lightning Record Pages**
3. Edit the record page or create a new one
4. Drag the **stnryAssetEnvrSrRecords** component onto the page
5. Save and activate the page

### 2. Assign Permissions

Ensure users have the following permissions:

- **Read** access to:
  - `StnryAssetEnvrSrc`
  - `Scope3PcmtSummary`
  - `StnryAssetEnrgyUse`
  - `StnryAssetWaterActvty`
  - `GeneratedWaste`
  - `WstDispoEmssnFctrSet`

- **Create** access to:
  - `Scope3PcmtSummary`
  - `StnryAssetEnrgyUse`
  - `StnryAssetWaterActvty`
  - `GeneratedWaste`

### 3. Configure Field-Level Security

Review and configure FLS for all fields used by the component:
- Energy Use: `FuelType`, `FuelConsumption`, `FuelConsumptionUnit`
- Water Activity: `ActivityType`, `Quantity`, `QuantityUnit`
- Generated Waste: `DisposalType`, `WasteType`, `DisposedWasteQuantity`, `DisposedWasteQuantityUnit`, `StartDate`, `EndDate`, `WstDispoEmssnFctrId`

### 4. Test in Sandbox

Before deploying to production:
1. Create a test `StnryAssetEnvrSrc` record
2. Navigate to the record page
3. Verify all related lists display correctly
4. Test creating records of each type
5. Verify data validation and error handling

## 🚀 Usage

### Viewing Related Records

1. Navigate to any **Stationary Asset Environmental Source** record
2. The component displays four sections:
   - Scope 3 Procurement Summary
   - Stationary Asset Energy Use
   - Stationary Asset Water Activity
   - Generated Waste
3. Click any record name to navigate to its detail page
4. Click **Refresh Tab** to reload all data

### Creating New Records

1. Click the **New Record** button
2. Select the record type you want to create
3. Fill in the required fields:
   - **Energy Use**: Name, Fuel Type, Fuel Consumption, Fuel Consumption Unit
   - **Water Activity**: Name, Activity Type, Quantity
   - **Generated Waste**: Name, Disposal Type, Waste Type, Disposed Waste Quantity, Disposed Waste Quantity Unit
   - **Scope 3 Procurement Summary**: Name
4. Click **Save**
5. The new record appears in the appropriate list

### Field Dependencies

- **Waste Type** is dependent on **Disposal Type** selection
- The component automatically loads valid options based on your selection

## 🐛 Reporting Issues

Found a bug or have a feature request? Please create an issue on our [GitHub Issues](https://github.com/carlosvl/NZC-EUR-MassEdit/issues) page.

When reporting bugs, please include:
- Steps to reproduce
- Expected vs. actual behavior
- Salesforce org edition and API version
- Screenshots (if applicable)
- Error messages or logs

## 🤝 Contributing

We welcome contributions! Please see our [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines on:
- Reporting bugs
- Suggesting enhancements
- Submitting pull requests
- Coding standards

## 🔒 Security

For security concerns, please review our [SECURITY.md](SECURITY.md) file.

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This is an **open-source community project** and is **not an official Salesforce product**. It is provided "as-is" without warranty of any kind. Users are responsible for:

- Testing in a sandbox environment before production deployment
- Ensuring compliance with their organization's security and governance policies
- Maintaining and updating the code after deployment
- Conducting their own security reviews

Salesforce, Inc. does not provide support for this accelerator. For questions or issues, please use the GitHub Issues tab.

## 📊 Code Quality

This codebase has been scanned with **Salesforce Code Analyzer** and follows:
- ✅ Apex best practices
- ✅ LWC coding standards
- ✅ Security guidelines (CRUD/FLS checks)
- ✅ ApexDoc documentation
- ✅ Error handling patterns

## 🙏 Acknowledgments

Built with ❤️ for the Salesforce community.

---

**Questions?** Open an issue or start a discussion on GitHub!
