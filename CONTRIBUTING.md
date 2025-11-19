# Contributing to NZC-EUR-MassEdit

Thank you for your interest in contributing to this Salesforce accelerator! This document provides guidelines for contributing to the project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and collaborative environment for all contributors.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue on GitHub with the following information:

- **Clear title and description** of the issue
- **Steps to reproduce** the problem
- **Expected behavior** vs. **actual behavior**
- **Salesforce org edition** and **API version**
- **Screenshots** (if applicable)
- **Error messages** or logs

### Suggesting Enhancements

We welcome suggestions for new features or improvements! Please create an issue with:

- **Clear description** of the enhancement
- **Use case** explaining why this would be valuable
- **Proposed implementation** (if you have ideas)

### Pull Requests

1. **Fork the repository** and create your branch from `master`
2. **Make your changes** following the coding standards below
3. **Test your changes** thoroughly in a Salesforce scratch org
4. **Run Salesforce Code Analyzer** to ensure code quality
5. **Update documentation** if needed (README.md, code comments)
6. **Submit a pull request** with a clear description of your changes

## Coding Standards

### Apex Code

- Follow [Salesforce Apex Best Practices](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_best_practices.htm)
- Include ApexDoc comments for all public methods and classes
- Maintain test coverage above 85%
- Use meaningful variable and method names
- Include CRUD/FLS security checks

### Lightning Web Components

- Follow [LWC Best Practices](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.best_practices)
- Use Lightning Design System (SLDS) for styling
- Include JSDoc comments for complex methods
- Write Jest unit tests for all components
- Ensure accessibility (ARIA labels, keyboard navigation)

### Code Quality

All contributions must pass:
- **Salesforce Code Analyzer** with no critical issues
- **Unit tests** with >85% coverage
- **Peer review** by project maintainers

## Development Setup

1. Install Salesforce CLI: `npm install -g @salesforce/cli`
2. Clone the repository: `git clone https://github.com/carlosvl/NZC-EUR-MassEdit.git`
3. Create a scratch org: `sf org create scratch -f config/project-scratch-def.json -a my-scratch`
4. Deploy the code: `sf project deploy start`
5. Run tests: `sf apex run test --test-level RunLocalTests`

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.

## Questions?

If you have questions about contributing, please create an issue with the label "question" and we'll be happy to help!

---

Thank you for helping make this accelerator better! 🚀
