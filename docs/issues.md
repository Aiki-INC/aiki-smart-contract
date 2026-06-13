# Aiki Issue Backlog

Use these as the first campaign-ready issues. Each issue has a suggested repository, labels, and difficulty.

---

## 1. Improve frontend README with screenshots and setup verification

**Repository:** `aiki-frontend`  
**Labels:** `documentation`, `frontend`, `good first issue`, `trivial`, `grantfox`, `drips-wave`  
**Difficulty:** Trivial

### Summary

Improve the frontend README so new contributors can understand and run the project quickly.

### Tasks

- Confirm setup instructions are accurate.
- Add a screenshots section.
- Add short descriptions of the main pages/components.
- Add a troubleshooting section for common setup issues.

### Acceptance Criteria

- README has accurate setup steps.
- README explains the frontend purpose clearly.
- README includes at least one screenshot or a placeholder screenshot section.
- A new contributor can run the app using the README.

---

## 2. Add responsive screenshots to the frontend README

**Repository:** `aiki-frontend`  
**Labels:** `documentation`, `frontend`, `trivial`, `grantfox`, `drips-wave`  
**Difficulty:** Trivial

### Summary

Add screenshots that show the Aiki frontend on desktop and mobile.

### Tasks

- Capture the homepage on desktop.
- Capture the homepage or dashboard on mobile/responsive view.
- Save screenshots under `docs/images/`.
- Reference screenshots in README.

### Acceptance Criteria

- Screenshots are clear.
- README displays the screenshots correctly.
- Image files are optimized and not unnecessarily large.

---

## 3. Create a UI accessibility improvement pass

**Repository:** `aiki-frontend`  
**Labels:** `frontend`, `enhancement`, `accessibility`, `medium`, `grantfox`, `drips-wave`  
**Difficulty:** Medium

### Summary

Review the frontend UI and improve basic accessibility.

### Tasks

- Check buttons and links for clear labels.
- Confirm image alt text is meaningful.
- Improve keyboard navigation where needed.
- Check color contrast for major text elements.
- Fix obvious accessibility warnings.

### Acceptance Criteria

- Major interactive elements are keyboard accessible.
- Images have meaningful alt text or are marked decorative where appropriate.
- The app still passes lint, type-check, and build.

---

## 4. Improve wallet connection error handling

**Repository:** `aiki-frontend`  
**Labels:** `frontend`, `wallet`, `bug`, `medium`, `grantfox`, `drips-wave`  
**Difficulty:** Medium

### Summary

Improve the wallet connection experience when a user does not have a supported wallet installed or rejects a connection request.

### Tasks

- Review the current wallet connection hook and modal.
- Add clear user-facing error messages.
- Handle rejected connection requests gracefully.
- Prevent the app from crashing when a wallet provider is unavailable.

### Acceptance Criteria

- Wallet connection errors are shown clearly.
- The app does not crash when wallet connection fails.
- The change passes lint, type-check, and build.

---

## 5. Create Stellar wallet integration research document

**Repository:** `aiki-frontend`  
**Labels:** `documentation`, `stellar`, `frontend`, `high`, `grantfox`, `drips-wave`  
**Difficulty:** High

### Summary

Research how Aiki can support Stellar wallet connection in the frontend.

### Tasks

- Research available Stellar wallet connection approaches.
- Compare possible libraries/tools.
- Recommend a frontend integration path.
- Describe the expected user flow.
- List open technical questions.

### Acceptance Criteria

- Add `docs/stellar-wallet-integration.md`.
- The document explains at least two possible approaches.
- The document includes a recommended approach.
- The document includes next steps for implementation.

---

## 6. Document Stellar course payment flow

**Repository:** `aiki-frontend` or `aiki-smart-contract`  
**Labels:** `documentation`, `stellar`, `payments`, `high`, `grantfox`, `drips-wave`  
**Difficulty:** High

### Summary

Document how Aiki course payments could work using Stellar assets.

### Tasks

- Describe the current course enrollment/payment idea.
- Explain how Stellar assets could support low-cost course payments.
- Outline learner, instructor, and platform payment flows.
- Identify required frontend and backend pieces.
- List open technical questions.

### Acceptance Criteria

- Add `docs/stellar-payment-flow.md`.
- The payment flow is clear and realistic.
- The document identifies implementation steps and open questions.

---

## 7. Add smart contract architecture documentation

**Repository:** `aiki-smart-contract`  
**Labels:** `documentation`, `smart-contract`, `medium`, `grantfox`, `drips-wave`  
**Difficulty:** Medium

### Summary

Add documentation explaining how Aiki smart contracts work.

### Tasks

- Explain the purpose of each contract.
- Describe course creation flow.
- Describe enrollment flow.
- Describe certificate issuance flow.
- Add a simple architecture diagram using Mermaid or plain text.

### Acceptance Criteria

- Add `docs/architecture.md` or expand README.
- A new contributor can understand the contract flow.
- The documentation matches the current contracts.

---

## 8. Add more tests for course enrollment behavior

**Repository:** `aiki-smart-contract`  
**Labels:** `smart-contract`, `testing`, `medium`, `grantfox`, `drips-wave`  
**Difficulty:** Medium

### Summary

Improve test coverage around course enrollment.

### Tasks

- Test successful enrollment.
- Test failure when payment is incorrect.
- Test failure when the course does not exist.
- Test duplicate enrollment behavior.
- Confirm tests pass with `forge test`.

### Acceptance Criteria

- New tests are added under `test/`.
- All tests pass.
- Edge cases are covered clearly.

---

## 9. Research Soroban certificate verification design

**Repository:** `aiki-smart-contract`  
**Labels:** `documentation`, `soroban`, `stellar`, `smart-contract`, `high`, `grantfox`, `drips-wave`  
**Difficulty:** High

### Summary

Research how Aiki certificate verification could be implemented using Stellar Soroban.

### Tasks

- Review the existing certificate logic.
- Propose Soroban storage structures.
- Propose contract functions for issuing and verifying certificates.
- Compare the proposed Soroban approach with the current EVM approach.
- List implementation steps.

### Acceptance Criteria

- Add `docs/soroban-certificate-verification.md`.
- The document includes proposed storage, functions, and flow.
- The document includes open questions and next steps.

---

## 10. Build a proof-of-concept Soroban certificate contract

**Repository:** `aiki-smart-contract` or a new `aiki-soroban-contracts` repo  
**Labels:** `soroban`, `stellar`, `smart-contract`, `high`, `grantfox`, `drips-wave`  
**Difficulty:** High

### Summary

Create a minimal Soroban proof-of-concept for issuing and verifying learning certificates.

### Tasks

- Create a minimal Soroban contract.
- Add certificate issuance function.
- Add certificate verification function.
- Add basic tests.
- Add setup instructions.

### Acceptance Criteria

- Contract builds successfully.
- Tests pass.
- README explains how to run the proof of concept.

---

## 11. Add GitHub issue templates and PR template

**Repository:** `aiki-smart-contract`  
**Labels:** `documentation`, `maintainer`, `trivial`, `grantfox`, `drips-wave`  
**Difficulty:** Trivial

### Summary

Add issue templates and a pull request template to improve contributor workflow.

### Tasks

- Add bug report template.
- Add feature request template.
- Add documentation task template.
- Add pull request template.

### Acceptance Criteria

- Templates exist under `.github/`.
- Templates are clear and easy to use.

---

## 12. Add setup troubleshooting guide for Windows users

**Repository:** `aiki-smart-contract`  
**Labels:** `documentation`, `foundry`, `smart-contract`, `medium`, `grantfox`, `drips-wave`  
**Difficulty:** Medium

### Summary

Add troubleshooting notes for Windows users who have issues installing or running Foundry.

### Tasks

- Explain that Git Bash or WSL is recommended.
- Add Foundry installation commands.
- Add common `foundryup` troubleshooting steps.
- Add commands for `forge build` and `forge test`.

### Acceptance Criteria

- Add `docs/windows-foundry-troubleshooting.md`.
- Instructions are clear for new contributors.
- The guide helps avoid common setup blockers.
