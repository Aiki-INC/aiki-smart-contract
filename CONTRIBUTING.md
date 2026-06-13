# Contributing to Aiki Smart Contracts

Thank you for contributing to Aiki.

## How to Contribute

1. Check the Issues tab.
2. Comment on the issue you want to work on.
3. Fork the repository.
4. Create a branch for your work.
5. Make focused changes.
6. Run the checks before opening a pull request.

## Local Setup

```bash
git clone https://github.com/Aiki-INC/aiki-smart-contract.git
cd aiki-smart-contract
git submodule update --init --recursive
forge build
forge test
```

## Pull Request Checklist

Before submitting a PR, run:

```bash
forge fmt
forge build
forge test
```

Your PR should include:

- A clear description of what changed.
- The issue number it closes, if applicable.
- Tests for contract logic changes where possible.
- No private keys, RPC URLs, or secrets.

## Good Contribution Areas

- Contract tests
- Documentation
- Deployment scripts
- Soroban/Stellar research
- Certificate verification improvements
- Course payment flow improvements
