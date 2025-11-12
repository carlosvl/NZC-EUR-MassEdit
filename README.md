# NZC-EUR-MassEdit

Salesforce DX project for mass editing operations.

## Prerequisites

- Salesforce CLI (sfdx)
- Git

## Setup

1. Clone this repository
2. Authorize your Salesforce org:
   ```bash
   sfdx auth:web:login -a <alias>
   ```
3. Deploy to your org:
   ```bash
   sfdx project:deploy:start -u <alias>
   ```

## Project Structure

```
force-app/
  └── main/
      └── default/
          ├── classes/
          ├── triggers/
          ├── lwc/
          ├── aura/
          └── objects/
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

