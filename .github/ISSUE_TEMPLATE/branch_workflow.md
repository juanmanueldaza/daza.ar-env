---
name: Branch Workflow Proposal
about: Propose a branch workflow for developing features and improvements in the daza.ar-env project
labels: documentation
assignees: ''
---

# Feature/Improvement Request

## Summary
Propose and document a branch workflow for developing, reviewing, and merging features and improvements in the daza.ar-env project. This workflow should help maintain code quality, encourage collaboration, and align with open source best practices.

## Motivation
A clear and consistent branch workflow ensures that all contributors follow the same process, reduces merge conflicts, and makes it easier to review and track changes. It also helps enforce KISS, SOLID, and CLEAN principles throughout the development lifecycle.

## Detailed Description
- Use the `main` branch as the stable, production-ready branch (already renamed from `master`).
- Use the `develop` branch as the main integration branch for ongoing development.
- For each new feature or improvement, create a new branch from `develop` named `feature/<short-description>` or `improvement/<short-description>`.
- Use the [feature_improvement.md](.github/ISSUE_TEMPLATE/feature_improvement.md) template to create a detailed issue describing the change.
- Link the branch to the corresponding issue (e.g., by referencing the issue number in the branch name or pull request).
- Make atomic, well-documented commits that align with KISS, SOLID, and CLEAN principles.
- Open a pull request (PR) to merge the feature branch into `develop`.
- Use the PR description to reference the issue and summarize the changes.
- Request review from at least one other contributor before merging.
- Only merge PRs that pass all checks and reviews.
- After sufficient testing and review, merge `develop` into `main` for releases.
- Delete the feature branch after merging.

## Design Principles
- [x] KISS (Keep It Simple, Stupid): Workflow should be as simple as possible, avoiding unnecessary complexity.
- [x] SOLID: Encourage code and process that follow SOLID principles.
- [x] CLEAN: Workflow should promote readable, maintainable, and well-structured code and history.
- [x] Minimal dependencies: Workflow should not require extra tools beyond git and GitHub unless absolutely necessary.

## Acceptance Criteria
- [ ] Branch workflow is documented in the repository (e.g., in CONTRIBUTING.md or a dedicated doc)
- [ ] All contributors follow the workflow for new features and improvements
- [ ] Issues and PRs are linked and use the feature_improvement.md template
- [ ] Workflow is reviewed and agreed upon by project maintainers
- [ ] All development is done in `develop` and only stable, tested code is merged into `main`

## Additional Context
- See [feature_improvement.md](.github/ISSUE_TEMPLATE/feature_improvement.md) for the issue template to use as a starting point for all new work.
- Consider adding a short summary of the workflow to the README or a CONTRIBUTING.md file.
- This workflow aligns with the current repository setup: `main` and `develop` branches, feature branches from `develop`, and a strong focus on code quality and simplicity.
