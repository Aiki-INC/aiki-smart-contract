# How to Apply the Aiki Smart Contract Fix Kit

Copy these files into your `aiki-smart-contract` repo and replace the existing versions:

- `foundry.toml`
- `.gitignore`
- `.env.example`
- `src/AikiFactory.sol`
- `README.md`
- `CONTRIBUTING.md`

Then run:

```bash
git submodule update --init --recursive
forge fmt
forge build
forge test
```

If `forge` is not found, use Git Bash or WSL Ubuntu and install Foundry:

```bash
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup
forge --version
```

Then commit:

```bash
git checkout -b fix/smart-contract-build
git add .
git commit -m "Fix smart contract build setup and factory compile error"
git push -u origin fix/smart-contract-build
```
