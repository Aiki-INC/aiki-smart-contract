# Contributing to Aiki

Thank you for your interest in contributing to Aiki.

Aiki is an open-source Web3 education platform for course creation, learner dashboards, verifiable certificates, and learning rewards. We welcome contributions from developers, designers, technical writers, product thinkers, and Web3/Stellar ecosystem contributors.

## How to Contribute

### 1. Find an Issue

Start by checking the repository Issues tab.

Look for labels such as:

- `good first issue`
- `documentation`
- `frontend`
- `stellar`
- `soroban`
- `trivial`
- `medium`
- `high`

If the issue is part of a GrantFox or Drips Wave campaign, please follow the campaign rules before starting.

### 2. Request Assignment

Before working on an issue:

1. Comment on the issue.
2. Briefly explain how you plan to solve it.
3. Wait for a maintainer to confirm or assign it.

This avoids duplicated work.

### 3. Fork and Clone

Fork the repository, then clone your fork:

```bash
git clone https://github.com/YOUR_USERNAME/aiki-frontend.git
cd aiki-frontend
```

### 4. Create a Branch

Use a clear branch name:

```bash
git checkout -b fix/navbar-responsive-layout
```

Examples:

```text
fix/wallet-modal-error
feat/dashboard-course-card
docs/stellar-payment-flow
chore/readme-cleanup
```

### 5. Install and Run Locally

```bash
npm install
cp .env.example .env.local
npm run dev
```

Open:

```text
http://localhost:3000
```

### 6. Run Checks Before Submitting

Before opening a pull request, run:

```bash
npm run lint
npm run type-check
npm run build
```

Your pull request is easier to review if all checks pass.

## Pull Request Guidelines

Please keep pull requests focused.

A good pull request should:

- Solve one issue or one clear task.
- Include a short explanation of the change.
- Include screenshots for UI changes when possible.
- Avoid unrelated formatting or large rewrites.
- Reference the issue it solves, for example: `Closes #12`.

## Code Style

Please follow the existing project style:

- Use TypeScript.
- Prefer clear component names.
- Keep components focused and reusable.
- Avoid unnecessary `any` types.
- Keep UI responsive.
- Use existing utilities and components where possible.

## Documentation Contributions

Documentation improvements are welcome.

Useful documentation contributions include:

- Setup instructions
- Screenshots
- Architecture notes
- Wallet integration notes
- Stellar/Soroban research
- Contributor onboarding improvements

## Stellar/Soroban Contributions

Aiki is preparing a Stellar ecosystem roadmap. Strong contribution areas include:

- Stellar wallet connection research
- Stellar payment flow documentation
- Soroban certificate verification design
- Course reward logic research
- Comparing EVM and Soroban contract architecture

## Maintainer Review Process

Maintainers will review pull requests based on:

- Correctness
- Scope control
- Code quality
- Documentation quality
- Alignment with the issue requirements
- Whether the implementation is easy to test and maintain

## Community Expectations

Please be respectful, patient, and constructive.

We want Aiki to be welcoming to both experienced contributors and first-time open-source contributors.
