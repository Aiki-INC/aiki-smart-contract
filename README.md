<p align="center">
  <img src="./assets/aiki-logo.png" alt="Aiki Logo" width="160" />
</p>

<h1 align="center">Aiki Smart Contracts</h1>

<p align="center">
  Smart contract infrastructure for Aiki's decentralized education platform, including courses, enrollment, certificates, platform deployment, and reward logic.
</p>

---

## Overview

Aiki is an open-source Web3 education platform for course creation, learner enrollment, progress tracking, verifiable certificates, and learning rewards.

This repository contains the smart contracts that power Aiki's decentralized learning infrastructure.

## Core Features

The contract system is designed to support:

- Instructor registration
- Course creation
- Course pricing
- Learner enrollment
- Learner progress tracking
- Course completion
- Certificate issuance
- Reward token logic
- Platform deployment through factory contracts

## Why Blockchain?

Aiki uses blockchain infrastructure to make learning records more transparent, portable, and verifiable.

This helps:

- Learners prove completed courses.
- Instructors maintain transparent course records.
- Institutions issue certificates that can be independently verified.
- Communities reward meaningful learning activity.

## Tech Stack

- Solidity
- Foundry
- OpenZeppelin

## Repository Structure

```text
aiki-smart-contract/
  src/        Smart contracts
  test/       Contract tests
  script/     Deployment scripts
  lib/        Dependencies
  foundry.toml Foundry configuration
```

## Getting Started

### 1. Install Foundry

Foundry works best on macOS, Linux, Git Bash, or WSL Ubuntu.

```bash
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup
```

Verify installation:

```bash
forge --version
cast --version
anvil --version
```

### 2. Clone the repository

```bash
git clone https://github.com/Aiki-INC/aiki-smart-contract.git
cd aiki-smart-contract
```

### 3. Install dependencies

```bash
git submodule update --init --recursive
```

If submodules are missing, install dependencies manually:

```bash
forge install foundry-rs/forge-std --no-commit
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

### 4. Create environment file

Copy the example environment file:

```bash
cp .env.example .env
```

Add your values:

```env
SEPOLIA_RPC_URL=
PRIVATE_KEY=
```

Never commit `.env` or private keys.

## Build

```bash
forge build
```

## Test

```bash
forge test
```

## Deploy

Example Sepolia deployment command:

```bash
forge script script/AikiDeploy.s.sol:AikiDeployScript --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

## Stellar/Soroban Roadmap

Aiki is preparing Stellar/Soroban support to make educational payments, certificate verification, and learning rewards cheaper and more accessible.

Planned contributor tasks include:

- Researching how Aiki course and certificate logic can be implemented with Soroban.
- Designing a Soroban certificate verification contract.
- Creating documentation comparing the existing EVM contract architecture with a Soroban architecture.
- Building a proof-of-concept Soroban certificate module.

## Contributing

We welcome contributors. Please read [`CONTRIBUTING.md`](./CONTRIBUTING.md), check the Issues tab, request assignment before working, and submit focused pull requests.

## License

MIT
