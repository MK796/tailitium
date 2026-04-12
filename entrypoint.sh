#!/bin/sh
set -eu

log() {
  printf '%s %s\n' "[$(date '+%Y-%m-%d %H:%M:%S %Z')]" "$*"
}

TS_SOCKET="${TS_SOCKET:-/var/run/tailscale/tailscaled.sock}"
TS_STATE_DIR="${TS_STATE_DIR:-/var/lib/tailscale}"
TS_USERSPACE="${TS_USERSPACE:-false}"
TS_ACCEPT_DNS="${TS_ACCEPT_DNS:-false}"

mkdir -p "$(dirname "$TS_SOCKET")" "$TS_STATE_DIR"

TAILSCALED_TUN_MODE="tun"
if [ "$TS_USERSPACE" = "true" ]; then
  TAILSCALED_TUN_MODE="userspace-networking"
fi

TAILSCALED_ARGS="--socket=${TS_SOCKET} --state=${TS_STATE_DIR}/tailscaled.state --tun=${TAILSCALED_TUN_MODE}"
if [ -n "${TS_TAILSCALED_EXTRA_ARGS:-}" ]; then
  TAILSCALED_ARGS="$TAILSCALED_ARGS ${TS_TAILSCALED_EXTRA_ARGS}"
fi

log "Starting tailscaled with tun mode: ${TAILSCALED_TUN_MODE}"
# shellcheck disable=SC2086
/usr/local/bin/tailscaled $TAILSCALED_ARGS &
TAILSCALED_PID=$!

READY=0
for _ in $(seq 1 60); do
  if [ -S "$TS_SOCKET" ]; then
    READY=1
    break
  fi
  sleep 1
done

if [ "$READY" -ne 1 ]; then
  log "tailscaled socket did not become ready"
  exit 1
fi

UP_ARGS="--accept-dns=${TS_ACCEPT_DNS}"

if [ -n "${TS_HOSTNAME:-}" ]; then
  UP_ARGS="$UP_ARGS --hostname=${TS_HOSTNAME}"
fi
if [ -n "${TS_LOGIN_SERVER:-}" ]; then
  UP_ARGS="$UP_ARGS --login-server=${TS_LOGIN_SERVER}"
fi
if [ -n "${TS_EXTRA_ARGS:-}" ]; then
  UP_ARGS="$UP_ARGS ${TS_EXTRA_ARGS}"
fi
if [ -n "${TS_AUTHKEY:-}" ]; then
  UP_ARGS="$UP_ARGS --auth-key=${TS_AUTHKEY}"
fi

log "Running tailscale up"
# shellcheck disable=SC2086
/usr/local/bin/tailscale --socket="$TS_SOCKET" up $UP_ARGS

if [ -n "${TS_EXPECTED_TAILNET_IP4:-}" ]; then
  CURRENT_IP="$(/usr/local/bin/tailscale --socket="$TS_SOCKET" ip -4 2>/dev/null | head -n1 || true)"
  if [ "$CURRENT_IP" != "$TS_EXPECTED_TAILNET_IP4" ]; then
    log "Expected Tailnet IPv4 ${TS_EXPECTED_TAILNET_IP4} but got ${CURRENT_IP:-<none>}"
    exit 1
  fi
fi

log "Starting Technitium"

# wichtig: geerbte CMD-Argumente weiterreichen
# offizielles Image nutzt /etc/dns
if [ "$#" -eq 0 ]; then
  set -- /etc/dns
fi

exec dotnet /opt/technitium/dns/DnsServerApp.dll "$@"