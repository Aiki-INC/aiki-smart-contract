# Contract Issue Scoring Guide

Use this guide to assign consistent complexity scores to Aiki smart contract
issues before they are opened for contributors.

The goal is to make bounty size, labels, review expectations, and contributor
scope predictable.

---

## Complexity Levels

| Level | Suggested Points | Typical Scope |
| --- | ---: | --- |
| Trivial | 100 | Documentation, small examples, simple test additions, or clearly bounded cleanup. |
| Medium | 300 | Contract behavior changes, meaningful test coverage, deployment/script updates, or focused research with implementation guidance. |
| High | 600+ | New contract modules, protocol design, security-sensitive changes, cross-chain architecture, or changes that affect deployed flows. |

## Trivial Issues

Trivial issues should be easy to understand, easy to review, and unlikely to
change contract behavior.

Good Trivial candidates:

- Add or improve one documentation page.
- Add examples for an existing script or command.
- Add tests for an already implemented behavior.
- Clarify setup, deployment, or troubleshooting instructions.
- Fix typos, broken links, or inconsistent labels.

Examples:

- Create `docs/contract-issue-scoring.md`.
- Add README examples for `forge build` and `forge test`.
- Add a test that confirms a known revert reason.
- Document the difference between `Aiki`, `AikiFactory`, and `AikiToken`.

Avoid marking an issue Trivial if it requires contract redesign, new external
dependencies, security review, or open-ended research.

## Medium Issues

Medium issues should have a clear implementation path, but they usually require
code changes, tests, and careful review.

Good Medium candidates:

- Add tests for an important contract flow.
- Improve deployment scripts.
- Add a small contract feature with clear acceptance criteria.
- Refactor one contract area without changing public behavior.
- Produce focused research that includes concrete implementation steps.

Examples:

- Add tests for course enrollment payment failures and duplicate enrollment.
- Improve `AikiDeploy.s.sol` validation and deployment output.
- Add contract architecture documentation with a Mermaid or plain-text diagram.
- Research Stellar course payment flow and define required contract changes.

Medium issues should include:

- The files or contract areas likely to change.
- At least one verification command, usually `forge test`.
- Clear acceptance criteria.
- Any expected compatibility constraints.

## High Issues

High issues are broad, security-sensitive, or architecture-changing. They should
usually be discussed before implementation starts.

Good High candidates:

- Add a new contract module.
- Change certificate issuance or course payment semantics.
- Design a Soroban or cross-chain migration path.
- Add tokenomics, reward distribution, or governance logic.
- Modify access control, ownership, or upgrade assumptions.

Examples:

- Design Soroban certificate verification for Aiki credentials.
- Implement a new reward distribution module.
- Add cross-chain course payment support.
- Redesign certificate issuance around a new trust model.

High issues should include:

- A design section or linked design document.
- Security assumptions and risks.
- Migration or backward compatibility notes.
- Required tests and manual verification steps.
- Explicit maintainer approval before large implementation work begins.

## Scoring Checklist

Before assigning a score, check these questions:

1. Does the task change deployed contract behavior?
2. Does it touch payments, rewards, ownership, certificates, or permissions?
3. Does it require new dependencies or external services?
4. Can a reviewer verify it with a simple command?
5. Are the acceptance criteria specific enough for one pull request?
6. Is research needed before implementation can start?

If most answers are "no", the issue is probably Trivial.

If the task changes code but has a bounded implementation path, it is probably
Medium.

If the task affects protocol design, security, money movement, cross-chain
behavior, or contributor coordination, it is probably High.

## Upgrade And Downgrade Rules

Upgrade an issue by one level when it:

- Affects payment, reward, certificate, or access-control logic.
- Requires changes across multiple contracts.
- Needs new deployment or migration steps.
- Has unclear security assumptions.
- Requires integration with an external chain, oracle, bridge, or off-chain API.

Downgrade an issue by one level when it:

- Only changes documentation.
- Adds tests for existing behavior without changing contracts.
- Has exact files, expected output, and verification commands.
- Can be reviewed without domain-specific protocol decisions.

## Recommended Issue Template Fields

Each contract bounty should include:

- **Summary:** What the contributor should do.
- **Why this matters:** The user, maintainer, or protocol value.
- **Suggested complexity:** Trivial, Medium, or High.
- **Suggested points:** 100, 300, or 600+.
- **Likely files:** Example: `src/Aiki.sol`, `test/Aiki.t.sol`, `script/AikiDeploy.s.sol`.
- **Acceptance criteria:** Specific checkboxes.
- **Verification:** Example: `forge test`.
- **Risks:** Security, migration, or design concerns.

## Example Labels

Use labels consistently with the score:

- Trivial: `documentation`, `good first issue`, `trivial`, `developer-experience`
- Medium: `smart-contract`, `testing`, `enhancement`, `medium`
- High: `architecture`, `security`, `stellar`, `soroban`, `high`

Add `wave-ready` only when the issue is scoped, reviewable, and ready for an
external contributor to start.
