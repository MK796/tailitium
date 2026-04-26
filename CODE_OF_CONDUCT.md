# Code of Conduct

## Purpose

`tailitium` is an infrastructure-oriented packaging project. Its purpose is to build and publish a Docker image that combines the official Technitium DNS Server image with Tailscale client binaries and a small amount of project-specific automation.

This project works best when discussion stays practical, respectful, reproducible, and focused on the repository's actual scope.

## Expected behavior

Everyone participating in this project is expected to:

- be respectful and constructive, even when disagreeing;
- focus on technical facts, reproducible behavior, and clear reasoning;
- assume good intent, but also accept corrections when something is wrong;
- keep issues and pull requests aligned with the project scope;
- explain changes clearly, especially when they affect image behavior, release automation, tags, or published artifacts;
- avoid posting secrets, tokens, auth keys, TSIG keys, private DNS data, private network details, or other sensitive information.

## Unacceptable behavior

The following behavior is not acceptable in this project:

- harassment, insults, threats, or personal attacks;
- discriminatory, sexualized, or otherwise hostile language;
- trolling, spam, deliberate derailment, or repeated off-topic comments;
- publishing someone else's private information without permission;
- knowingly encouraging unsafe handling of secrets, credentials, or private infrastructure details;
- opening public issues for security vulnerabilities that should be reported privately.

## Scope of technical discussions

This repository is mainly responsible for:

- the Docker image packaging;
- the `Dockerfile`;
- the project entrypoint and startup behavior;
- Tailscale binary integration inside this image;
- GitHub Actions build, tagging, release, and README automation;
- documentation for this specific combined image.

This repository is not the correct place for general Technitium DNS Server bugs, DNS protocol behavior, DNSSEC behavior, zone management bugs, Tailscale ACL design, Tailscale account policy, or general Tailscale routing questions unless the issue is caused by this image's packaging or startup behavior.

## Security issues

Do not report security vulnerabilities in public issues.

If you found a vulnerability in this image, its build process, its release process, or its packaging, use the private vulnerability reporting process described in `SECURITY.md`.

If the issue belongs to an upstream project, report it to the appropriate upstream project instead.

## Enforcement

Maintainers may take action to keep the project healthy and safe. This can include:

- asking for clarification or changes;
- editing, hiding, or deleting comments;
- closing, locking, or moving discussions;
- blocking abusive users;
- reporting serious abuse through the platform's moderation tools.

Enforcement decisions should be proportional to the situation and focused on protecting the project and its contributors.

## Maintainer responsibility

Maintainers should apply this Code of Conduct consistently and fairly. They should also keep technical decisions grounded in the project's documented purpose and avoid expanding the project scope through unrelated feature requests without discussion.