# Contributing to tailitium

Thanks for contributing.

`tailitium` is intentionally a small repository with a narrow purpose: build and publish a Docker image that combines Technitium DNS Server with Tailscale-related packaging and automation.

That means contributions are welcome, but they should stay aligned with the repository's scope.

## Good contribution areas

Examples of useful contributions:

- fixes to the `Dockerfile`
- improvements to `entrypoint.sh`
- safer or clearer GitHub Actions logic
- documentation fixes and clarifications
- release, tagging, and README consistency improvements
- small usability improvements that fit the current project direction

## Please avoid unsolicited scope expansion

Before proposing larger changes, open an issue first.

Examples of changes that should be discussed before implementation:

- adding unrelated services or daemons
- changing the project's versioning philosophy
- changing the publishing model or registry layout
- major changes to runtime behavior
- replacing upstream components with alternatives

## Contribution workflow

1. Fork the repository or create a branch.
2. Make focused changes.
3. Open a pull request against `main`.
4. Make sure CI passes.
5. Explain the change clearly, including why it belongs in this repository.

## Pull request expectations

A good pull request should:

- describe **what** changed
- explain **why** the change is useful
- mention any effect on image tags, release logic, or published artifacts
- mention whether the change affects build only, runtime behavior, or documentation only
- stay narrow in scope

## For workflow and release changes

Changes to `.github/workflows/`, tagging, release notes, or README automation should be especially careful.

Please include:

- expected trigger behavior
- expected tag behavior
- whether the change affects `latest`, semantic tags, or upstream-combination tags
- any GitHub permission changes

## Testing guidance

Where practical, please test at the level your change touches.

Examples:

- Docker/build changes: verify the image still builds
- workflow changes: explain how the workflow was tested
- documentation changes: ensure examples match actual published tags and behavior

## Security

If your change fixes a vulnerability or you found a security issue, do not open a public issue first.

Use the repository's private vulnerability reporting process described in `SECURITY.md`.

## Style

Keep changes simple, explicit, and easy to audit.

This repository is infrastructure-oriented, so clarity is preferred over cleverness.
