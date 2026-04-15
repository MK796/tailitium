# Security Policy

## Supported scope

This repository contains the build, release, and packaging logic for the `tailitium` image.

Security reports are especially relevant for:

- the `Dockerfile`
- `entrypoint.sh`
- GitHub Actions workflows under `.github/workflows/`
- release automation, tagging, and publish logic
- any configuration that could expose secrets, credentials, or supply-chain risk

## What to report here

Please report issues such as:

- secrets accidentally exposed in the repository or workflow logs
- insecure workflow behavior, permission mistakes, or token misuse
- supply-chain risks in the build or release pipeline
- packaging mistakes that could weaken the resulting image
- vulnerabilities introduced by this repository's own glue logic or automation

## What usually belongs upstream instead

`tailitium` combines upstream components.

If the issue is clearly inside one of these upstream projects themselves, please consider reporting it to the upstream maintainers as well:

- Technitium DNS Server
- Tailscale
- any GitHub Action used by this repository

If you are unsure, report it here first and include your reasoning.

## How to report a vulnerability

Please use GitHub's private vulnerability reporting for this repository.

Do **not** open a public issue for a security problem.

Include as much of the following as possible:

- a short summary of the issue
- affected file(s), workflow(s), tag(s), or release(s)
- whether the problem affects source only, published images, or both
- exact steps to reproduce
- impact assessment
- suggested fix, if you have one

## Response expectations

I will review reports in good faith and try to:

- acknowledge the report reasonably quickly
- confirm whether I can reproduce it
- coordinate a fix or mitigation
- publish a patch or workflow correction when appropriate

## Disclosure

Please allow reasonable time for investigation and remediation before public disclosure.

For issues that are purely upstream, remediation timing may depend on the upstream project.
