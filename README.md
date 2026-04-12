# tailitium

`tailitium` is a small wrapper image that keeps **Technitium DNS Server** as the base image and adds **Tailscale** on top.

The stack file is meant for Docker Swarm, but this repository is also set up so you can **build locally first** on your Mac with Docker Desktop and inspect the image before pushing anything anywhere.

## What this image does

- keeps `technitium/dns-server` as the base image
- copies in the official `tailscale` and `tailscaled` binaries
- starts `tailscaled`
- runs `tailscale up`
- then starts Technitium using the base image's inherited command

## Upstream architecture support

Technitium's official Docker image currently publishes `linux/amd64`, `linux/arm64`, and `linux/arm/v7` variants. The GitHub Actions workflow in this repo is configured to build exactly those same three Linux architectures. Tailscale's official Docker image also publishes at least `linux/amd64`, `linux/arm64`, and `linux/arm/v7` variants. citeturn464359search1turn543032search0turn543032search1

## Files in this repo

- `Dockerfile` - image definition
- `entrypoint.sh` - starts Tailscale first, then Technitium
- `stack.yml` - your Swarm stack example
- `.github/workflows/build.yml` - optional GitHub Actions build workflow for GHCR
- `.github/dependabot.yml` - updates Dockerfile and GitHub Actions dependencies
- `local-build.sh` - local build helper for Docker Desktop
- `local-run-example.sh` - example `docker run` command for a direct smoke test

## Local build first on your Mac

From the repo directory:

```bash
./local-build.sh tailitium:local
```

That uses `docker buildx build --load` so the built image lands in your local Docker Desktop image store.

### Important Mac note

Docker Desktop on Mac runs containers inside a lightweight Linux VM, not directly on macOS. That is fine for image builds, but low-level runtime details such as `NET_ADMIN`, `/dev/net/tun`, and privileged networking behavior are not a perfect stand-in for your real Linux Swarm hosts. Docker documents that containers run inside the Docker Desktop Linux VM on Mac, and Tailscale has separate Docker Desktop guidance as well. So: **local build = great**, **local Tailscale/TUN runtime validation = only partial confidence**. citeturn409739search0turn409739search5

## Practical local test advice

On your Mac, do this in two steps:

1. Build the image locally.
2. Inspect the image and maybe test the plain Technitium startup path.

For the full Tailscale + `/dev/net/tun` behavior, the real proof should happen on one of your Linux Swarm-capable test hosts.

## If you want to push later

When you are happy with the local image, you can tag and push manually:

```bash
docker tag tailitium:local ghcr.io/MK796/tailitium:latest
docker push ghcr.io/MK796/tailitium:latest
```

## Notes about the stack file

- The included `stack.yml` keeps your current design choices.
- Named volumes are auto-created by Docker, but with the default local driver they stay local to the node.
- For real failover with state continuity, you still need shared storage or a suitable distributed volume backend. citeturn543032search1turn464359search0

## Why the entrypoint order matters

The container starts in this order:

1. `tailscaled`
2. `tailscale up`
3. Technitium

That matters because Technitium should only come up after the Tailscale node identity and socket are ready. Tailscale documents the container parameters and the persistent state directory model that this relies on. citeturn543032search1
