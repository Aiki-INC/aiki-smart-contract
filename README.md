# Aiki Smart Contracts

Aiki is an open-source Web3 education platform for course creation, learner enrollment, progress tracking, verifiable certificates, and learning rewards.

This repository contains the Solidity smart contracts that power Aiki's decentralized learning infrastructure.

## Core Features

- Instructor registration
- Course creation and course pricing
- Learner enrollment
- Learner progress tracking
- Course completion
- NFT-based certificate issuance
- Reward token logic
- Factory deployment for new Aiki platform contracts

## Why Blockchain?

Aiki uses blockchain infrastructure to make learning records transparent, portable, and verifiable.

This helps learners prove completed courses, instructors maintain transparent course records, institutions issue independently verifiable certificates, and communities reward meaningful learning activity.

## Tech Stack

- Solidity
- Foundry
- OpenZeppelin Contracts

## Repository Structure

```text
src/        Smart contracts
test/       Contract tests
script/     Deployment scripts
lib/        Foundry dependencies
```

## Getting Started

### 1. Install Foundry

Foundry works best in Git Bash, WSL Ubuntu, macOS, or Linux.

```bash
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup
forge --version
```

### 2. Clone the repository

```bash
git clone https://github.com/Aiki-INC/aiki-smart-contract.git
cd aiki-smart-contract
```

### 3. Install dependencies

If dependencies are configured as git submodules, run:

```bash
git submodule update --init --recursive
```

If the `lib` folder is missing, run:

```bash
forge install foundry-rs/forge-std --no-commit
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

### 4. Create environment file

```bash
cp .env.example .env
```

Fill in your values:

```env
SEPOLIA_RPC_URL=
PRIVATE_KEY=
ETHERSCAN_API_KEY=
```

Never commit `.env` or private keys.

### 5. Build contracts

```bash
forge build
```

### 6. Run tests

```bash
forge test
```

### 7. Format contracts

```bash
forge fmt
```

## Deployment

Example Sepolia deployment command:

```bash
source .env
forge script script/AikiDeploy.s.sol:AikiDeployScript --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

## Main Contracts

- `Aiki.sol` — main educational platform contract for courses, enrollment, progress, and certificates.
- `AikiFactory.sol` — deploys new Aiki platform contracts.
- `AikiToken.sol` — ERC20 learning reward token.

## Stellar/Soroban Roadmap

Aiki is preparing Stellar/Soroban support. Planned work includes:

- Researching Soroban certificate verification architecture.
- Designing Stellar-based course payment flows.
- Creating a Soroban proof-of-concept certificate module.
- Documenting the migration path from EVM contracts to Soroban contracts.

## Contributing

We welcome contributors. Please check open issues, comment before working, and submit focused pull requests.

## License

MIT
