# Security Policy

## Reporting Security Vulnerabilities

The security of this project is important to us. If you discover a security vulnerability, please follow these steps:

### DO NOT

- **Do not** open a public GitHub issue for security vulnerabilities
- **Do not** discuss the vulnerability publicly until it has been addressed

### DO

1. **Email** the maintainers privately with details of the vulnerability
2. **Include** the following information:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact
   - Suggested fix (if you have one)
3. **Wait** for a response before disclosing the vulnerability publicly

## Security Best Practices

When using this accelerator, please follow these security best practices:

### Salesforce Security

- **Field-Level Security (FLS)**: Review and configure FLS for all custom fields
- **Object Permissions**: Ensure proper CRUD permissions are set for all custom objects
- **Sharing Rules**: Configure appropriate sharing rules for your organization
- **Profile/Permission Sets**: Assign the minimum required permissions to users

### Code Security

This accelerator follows Salesforce security best practices:

- ✅ **CRUD/FLS Checks**: All Apex code includes proper security checks
- ✅ **With Sharing**: All Apex classes use `with sharing` keyword
- ✅ **Input Validation**: User inputs are validated before processing
- ✅ **SOQL Injection Prevention**: Dynamic SOQL uses bind variables
- ✅ **XSS Prevention**: LWC components properly escape user data

### Data Security

- **Sensitive Data**: Do not store sensitive data (passwords, API keys, PII) in custom fields without encryption
- **Audit Trail**: Enable field history tracking for sensitive objects
- **Data Access**: Regularly review who has access to records created by this accelerator

## Security Updates

We regularly scan this codebase using:
- **Salesforce Code Analyzer** (PMD, ESLint)
- **Salesforce Security Review** guidelines
- **OWASP Top 10** security principles

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| Older   | :x:                |

We recommend always using the latest version of this accelerator to ensure you have the most recent security updates.

## Disclaimer

This is an open-source community project and is not an official Salesforce product. While we strive to follow security best practices, users are responsible for:

- Testing the code in a sandbox environment before production deployment
- Conducting their own security reviews
- Ensuring compliance with their organization's security policies
- Maintaining and updating the code after deployment

## Contact

For security concerns, please contact the repository maintainers through GitHub.

---

Thank you for helping keep this project secure! 🔒
