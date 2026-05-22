# tailitium

`tailitium` is a custom container image that combines the official **Technitium DNS Server** image with **Tailscale** client binaries in a single container.

The purpose of this image is not to replace Technitium or Tailscale. Its purpose is to make a specific deployment pattern easier:

- run **Technitium DNS Server** as the actual DNS application
- join a **Tailscale tailnet** from the same container
- keep private DNS access and management simple, especially for homelab, lab, and remote-site scenarios

## Upstream projects

### Technitium DNS Server

Technitium DNS Server is the DNS software used in this image.

For DNS features, DNS behavior, zone handling, API behavior, recursion, authoritative DNS, DNSSEC, web UI behavior, or Technitium-specific bugs, please use the official upstream project:

- [Technitium DNS Server repository](https://github.com/TechnitiumSoftware/DnsServer)

### Tailscale

Tailscale provides the private network connectivity used by this image.

For advanced networking, ACLs, auth flows, subnet routers, exit nodes, policy design, and all Tailscale features beyond the scope of this image, please use the official documentation:

- [Tailscale documentation](https://tailscale.com/docs)

## What this image is for

This image is useful when you want a **single container** that:

- runs Technitium normally
- can join a tailnet directly
- can expose DNS and the Technitium web UI privately over Tailscale
- avoids the overhead of a second sidecar container just for Tailscale

Typical use cases:

- private Technitium administration over Tailscale
- private DNS service inside a tailnet
- DNS nodes for homelabs or remote infrastructure
- lab and test deployments where simplicity matters more than strict service separation

## What this image is not for

This image is probably not the best fit when:

- you want strict separation between DNS and overlay networking
- you already use a separate Tailscale sidecar pattern everywhere
- you need very complex routing logic around multiple containers
- you want to manage Tailscale completely independently from the DNS container lifecycle

## How the image is built

The image is built by:

1. starting from the official Technitium DNS Server image
2. copying the `tailscale` and `tailscaled` binaries from the official Tailscale image
3. adding a custom entrypoint
4. starting Tailscale first
5. starting Technitium afterwards

So the DNS server remains Technitium, while Tailscale acts as the private connectivity layer.

## Tailscale options relevant for this image

This README intentionally only explains the Tailscale options that are directly relevant for the typical `tailitium` use cases.

For deeper or more advanced Tailscale topics, please refer to the official Tailscale documentation.

### `TS_USERSPACE`

This setting decides whether Tailscale should run in **userspace networking mode** or use the normal kernel/TUN-based path.

#### Recommended: `TS_USERSPACE=true`

Use this when:

- you mainly want private access to the Technitium web UI
- you want other tailnet devices to query this DNS server directly
- you want the simplest and most portable container deployment
- performance is not the primary concern

Why it is often the best default here:

- it is easier to deploy
- it avoids extra kernel/TUN setup in many cases
- it is often fully sufficient for administration and standard DNS use

#### Consider `TS_USERSPACE=false`

Use this only when:

- you intentionally want kernel/TUN networking
- your runtime and host are prepared for that
- you need the more traditional network path
- you have a good reason not to use userspace mode

This is usually the more advanced option and should not be enabled just because it sounds "better".

### `TS_STATE_DIR`

This controls where Tailscale stores its local state.

Recommended when:

- you want the node identity to survive container restarts
- you want stable operation over time
- you do not want to re-authenticate repeatedly

In practice, this should normally point to a persistent volume path.

### `TS_AUTHKEY`

This is the auth key used for joining the tailnet automatically.

Recommended when:

- you want unattended or reproducible deployments
- you deploy through Compose, Swarm, or automation

Use caution when:

- you hardcode it in files that should not contain secrets
- you do not control who can read your deployment config

In real deployments, secrets handling is usually the better approach than storing the key directly in plain text.

### `TS_HOSTNAME`

This sets the Tailscale node name.

Recommended when:

- you want a clear and predictable node name in the tailnet
- you operate multiple DNS nodes
- you want easier troubleshooting and visibility

This is especially useful in homelab or multi-node environments.

### `TS_EXTRA_ARGS`

This is the main place for additional `tailscale up` flags.

For this image, the relevant question is usually not "which flags exist", but rather which flags make sense for the intended role of the container.

#### Good fit: no extra routing flags

This is recommended when:

- the container only needs to be reachable itself
- the container should provide DNS and/or web UI access over Tailscale
- the container is **not** supposed to route traffic for other subnets

This is the cleanest and most common `tailitium` use case.

#### `--advertise-routes`

Use this only when the container should also act as a **subnet router**.

Recommended when:

- devices in your tailnet should reach a private LAN subnet behind this node
- this container intentionally has a routing role in addition to running Technitium

Not recommended when:

- you only need access to the Technitium container itself
- you do not want this node to forward traffic for other networks
- you are not explicitly designing a routed topology

For many `tailitium` deployments, this should simply stay unused.

#### `--accept-routes`

Use this when the container should accept routes advertised by other Tailscale subnet routers.

Recommended when:

- this node should reach remote private subnets behind other Tailscale routers

Use caution when:

- the same node also advertises routes
- multiple nodes advertise identical or overlapping routes
- you are building HA or failover topologies

That combination can become tricky very quickly, so it should be used intentionally, not by default.

#### `--advertise-exit-node`

This is only relevant if you intentionally want this node to serve as an **exit node**.

For typical `tailitium` deployments, this is usually **not** needed.

If your main goal is private DNS access or private Technitium administration, this option is generally unnecessary.

### `TS_ACCEPT_DNS`

This controls whether the container should accept DNS settings pushed by Tailscale.

For this image, the typical recommendation is:

- leave it disabled unless you explicitly want Tailscale-managed DNS behavior inside the container itself

Why:

- this container already runs a DNS server
- many deployments want the container to provide DNS, not consume a different tailnet DNS configuration internally

This setting is therefore something to enable only deliberately.

## Recommended deployment patterns

### Pattern 1: private Technitium administration

Use this when:

- you want the Technitium web UI reachable privately over Tailscale
- you do not need subnet routing
- you want the simplest setup

Recommended direction:

- `TS_USERSPACE=true`
- persistent `TS_STATE_DIR`
- `TS_HOSTNAME` set
- no route advertisement
- no route acceptance unless really needed

### Pattern 2: DNS server reachable over the tailnet

Use this when:

- other tailnet devices should query this DNS server directly
- you want DNS reachable inside the tailnet
- the container itself is not acting as a subnet router

Recommended direction:

- `TS_USERSPACE=true` in many cases
- persistent `TS_STATE_DIR`
- clear `TS_HOSTNAME`
- normally no `--advertise-routes`
- normally no `--advertise-exit-node`

### Pattern 3: DNS server plus subnet-router role

Use this only when:

- this same node should run Technitium
- and also provide routed access to a private subnet behind it

Recommended direction:

- use routing flags only deliberately
- design the routing topology first
- be careful with `--accept-routes` in HA or overlapping-route scenarios

This is the most advanced and easiest pattern to misconfigure.

## Example image references

Use the newest published image:
```yaml
image: ghcr.io/MK796/tailitium:latest
```

Use a specific release tag:
```yaml
image: ghcr.io/MK796/tailitium:v1.0.7
```

Use an upstream-combination tag:
```yaml
image: ghcr.io/MK796/tailitium:t15.2.0-ts1.98.3
```

## Important notes

- DNS functionality comes from **Technitium DNS Server**
- private connectivity comes from **Tailscale**
- this repository mainly provides a **combined packaging and deployment approach**
- for Technitium-specific DNS questions, use the official Technitium project
- for deeper Tailscale networking questions, use the official Tailscale documentation

## Disclaimer

This is an independent packaging project.

It is not the official Technitium image and not the official Tailscale image.