# Tokenized Healthcare Precision Public Health

A comprehensive blockchain-based system for managing precision public health initiatives using Clarity smart contracts on the Stacks blockchain.

## Overview

This system provides a decentralized platform for managing population health through five core smart contracts that work together to deliver precision public health interventions.

## Architecture

### Core Contracts

1. **Population Verification Contract** (`population-verification.clar`)
    - Validates and manages health populations
    - Tracks population members and verification status
    - Maintains population metadata and member risk scores

2. **Risk Stratification Contract** (`risk-stratification.clar`)
    - Identifies and categorizes high-risk groups
    - Calculates risk scores based on multiple factors
    - Provides population-level risk summaries

3. **Intervention Targeting Contract** (`intervention-targeting.clar`)
    - Personalizes public health measures
    - Manages intervention assignments and completion
    - Tracks intervention outcomes and effectiveness

4. **Outcome Tracking Contract** (`outcome-tracking.clar`)
    - Monitors population health improvements
    - Records baseline and current health metrics
    - Calculates improvement percentages and trends

5. **Resource Allocation Contract** (`resource-allocation.clar`)
    - Optimizes public health investments
    - Manages budget pools and resource allocation
    - Tracks efficiency metrics and ROI

## Features

### Population Management
- Create and verify health populations
- Add and manage population members
- Track verification status and risk profiles

### Risk Assessment
- Multi-factor risk scoring (age, health, social factors)
- Automated risk categorization (low, medium, high, critical)
- Population-level risk distribution tracking

### Intervention Management
- Create targeted health interventions
- Assign interventions based on risk profiles
- Track completion and outcome scores

### Health Monitoring
- Define custom health metrics
- Record baseline and follow-up measurements
- Calculate improvement trends

### Resource Optimization
- Create and manage budget pools
- Allocate resources based on priority scores
- Track spending and calculate efficiency metrics

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository
   \`\`\`bash
   git clone <repository-url>
   cd tokenized-healthcare-precision
   \`\`\`

2. Install dependencies
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks blockchain:

\`\`\`bash
clarinet deploy --network testnet
\`\`\`

## Usage Examples

### Creating a Population
\`\`\`clarity
(contract-call? .population-verification create-population "Diabetes Patients" u1000)
\`\`\`

### Assessing Risk
\`\`\`clarity
(contract-call? .risk-stratification assess-risk 'SP1234... u30 u60 u20)
\`\`\`

### Creating an Intervention
\`\`\`clarity
(contract-call? .intervention-targeting create-intervention "Blood Sugar Monitoring" u1 u3 u100 u85)
\`\`\`

### Recording Outcomes
\`\`\`clarity
(contract-call? .outcome-tracking record-baseline 'SP1234... u1 u150 u120)
\`\`\`

### Allocating Resources
\`\`\`clarity
(contract-call? .resource-allocation allocate-resources u1 u1 u1 u5000 u90)
\`\`\`

## Data Models

### Population
- ID, name, size, verification status
- Creation and update timestamps

### Risk Profile
- Age, health, and social risk scores
- Total risk and category classification
- Last assessment timestamp

### Intervention
- Name, type, target risk level
- Cost and effectiveness metrics
- Assignment and completion tracking

### Health Outcome
- Baseline and current values
- Improvement calculations
- Target value tracking

### Budget Pool
- Total budget, allocated, spent amounts
- Remaining budget and active status

## Security Considerations

- All write operations require contract owner authorization
- Input validation on all parameters
- Proper error handling with descriptive error codes
- Read-only functions for data access

## Testing

The system includes comprehensive tests using Vitest:

- Unit tests for each contract function
- Integration tests for cross-contract interactions
- Edge case and error condition testing

Run tests with:
\`\`\`bash
npm test
\`\`\`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions or support, please open an issue in the GitHub repository.

