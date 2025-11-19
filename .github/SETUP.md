# GitHub Repository Setup Guide

This guide will help you complete the setup of your GitHub repository for public release.

## 1. Enable GitHub Issues

1. Go to your repository on GitHub: https://github.com/carlosvl/NZC-EUR-MassEdit
2. Click on **Settings** tab
3. Scroll down to the **Features** section
4. Ensure **Issues** checkbox is checked ✅
5. Click **Save** if you made changes

## 2. Add Repository Topics

Topics help users discover your repository. Add these recommended topics:

1. Go to your repository homepage
2. Click on the ⚙️ gear icon next to "About" (top right)
3. Add the following topics (comma-separated):
   - `salesforce`
   - `salesforce-accelerator`
   - `lightning-web-components`
   - `lwc`
   - `apex`
   - `net-zero-cloud`
   - `environmental-data`
   - `sustainability`
   - `carbon-footprint`
   - `open-source`

4. Add a description:
   ```
   Salesforce LWC accelerator for managing environmental records related to Stationary Asset Environmental Sources
   ```

5. Add website (optional): Link to your documentation or demo
6. Click **Save changes**

## 3. Create a GitHub Release

1. Go to your repository on GitHub
2. Click on **Releases** (right sidebar)
3. Click **Create a new release**
4. Fill in the release information:
   - **Tag version**: `v1.0.0`
   - **Release title**: `v1.0.0 - Initial Release`
   - **Description**:
     ```markdown
     ## 🎉 Initial Release

     First public release of the Stationary Asset Environmental Records Manager.

     ### Features
     - View all related environmental records in one unified dashboard
     - Create new records with guided forms and validation
     - Support for Scope 3 Procurement Summary, Energy Use, Water Activity, and Generated Waste
     - Real-time refresh functionality
     - CRUD/FLS security checks
     - Responsive design for desktop and mobile

     ### Installation
     Download the `NZC-EUR-MassEdit-v1.0.0.zip` file below and deploy using Workbench or Salesforce CLI.

     See the [README](https://github.com/carlosvl/NZC-EUR-MassEdit#readme) for detailed installation instructions.

     ### Requirements
     - Salesforce API Version 60.0 or higher
     - Net Zero Cloud or equivalent environmental data objects

     ### Documentation
     - [Installation Guide](https://github.com/carlosvl/NZC-EUR-MassEdit#-installation)
     - [Usage Guide](https://github.com/carlosvl/NZC-EUR-MassEdit#-usage)
     - [Contributing Guidelines](https://github.com/carlosvl/NZC-EUR-MassEdit/blob/main/CONTRIBUTING.md)
     - [Security Policy](https://github.com/carlosvl/NZC-EUR-MassEdit/blob/main/SECURITY.md)
     ```

5. **Attach the release ZIP**:
   - Click **Attach binaries by dropping them here or selecting them**
   - Upload: `releases/NZC-EUR-MassEdit-v1.0.0.zip`

6. Check **Set as the latest release**
7. Click **Publish release**

## 4. Configure Repository Settings

### Branch Protection (Recommended for Production)

1. Go to **Settings** → **Branches**
2. Click **Add rule** under "Branch protection rules"
3. Branch name pattern: `main` or `master`
4. Enable:
   - ✅ Require a pull request before merging
   - ✅ Require approvals (at least 1)
   - ✅ Require status checks to pass before merging
   - ✅ Require conversation resolution before merging

### Collaborators & Teams

1. Go to **Settings** → **Collaborators and teams**
2. Add team members or collaborators as needed
3. Set appropriate permission levels

## 5. Add Repository Labels

GitHub will automatically create some labels, but you can add custom ones:

1. Go to **Issues** → **Labels**
2. Add these custom labels:
   - `good first issue` (green) - Good for newcomers
   - `help wanted` (green) - Extra attention is needed
   - `question` (purple) - Further information is requested
   - `wontfix` (white) - This will not be worked on
   - `apex` (blue) - Related to Apex code
   - `lwc` (blue) - Related to Lightning Web Components
   - `documentation` (blue) - Improvements or additions to documentation
   - `security` (red) - Security-related issue

## 6. Enable Discussions (Optional)

For community Q&A and discussions:

1. Go to **Settings** → **Features**
2. Check **Discussions**
3. Click **Set up discussions**
4. Create categories:
   - General
   - Q&A
   - Ideas
   - Show and Tell

## 7. Add Social Preview Image (Optional)

Create a custom social preview image (1280x640px) that appears when sharing your repo:

1. Go to **Settings**
2. Scroll to **Social preview**
3. Click **Edit**
4. Upload your image

## 8. Verify Everything

- [ ] Issues are enabled
- [ ] Topics are added
- [ ] Release v1.0.0 is published with ZIP file
- [ ] README.md displays correctly
- [ ] CONTRIBUTING.md is accessible
- [ ] SECURITY.md is accessible
- [ ] Issue templates work
- [ ] Deploy to Salesforce button works (test in a sandbox)

## 9. Announce Your Release

Once everything is set up, consider announcing your accelerator:

- Salesforce Trailblazer Community
- LinkedIn
- Twitter/X
- Internal company channels
- Salesforce Developer Forums

## Need Help?

If you encounter any issues during setup, please refer to:
- [GitHub Docs - Managing Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)
- [GitHub Docs - About Issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/about-issues)

---

**Congratulations!** 🎉 Your repository is now ready for the Salesforce community!
