FROM tailscale/tailscale:v1.98.8 AS tailscale
FROM technitium/dns-server:15.4.0

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends dumb-init iproute2 iptables procps ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin/tailscale
COPY --from=tailscale /usr/local/bin/tailscaled /usr/local/bin/tailscaled

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && mkdir -p /var/run/tailscale /var/lib/tailscale

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/local/bin/entrypoint.sh"]
