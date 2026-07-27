#!/bin/sh
# Map Railway env vars onto GoAlert config. All state lives in Postgres — no volume.
set -e

# Railway's Postgres service exposes DATABASE_URL; GoAlert wants GOALERT_DB_URL.
: "${GOALERT_DB_URL:=$DATABASE_URL}"
export GOALERT_DB_URL

# Bind the web UI/API to the Railway-injected PORT on all interfaces
# (default is localhost:8081, unreachable behind Railway's proxy).
export GOALERT_LISTEN=":${PORT:-8081}"

# Notification links and OAuth callbacks need the public URL.
if [ -z "$GOALERT_PUBLIC_URL" ] && [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
  export GOALERT_PUBLIC_URL="https://${RAILWAY_PUBLIC_DOMAIN}"
fi

# Migrations normally run on server startup; run them explicitly first so the
# admin bootstrap below works on the very first boot too.
goalert migrate --db-url "$GOALERT_DB_URL"

# Bootstrap the first admin. add-user fails once the user exists — that's the
# idempotency check, so ignore it on every boot after the first.
if [ -n "$ADMIN_USERNAME" ] && [ -n "$ADMIN_PASSWORD" ]; then
  goalert add-user --admin \
    --user "$ADMIN_USERNAME" \
    --pass "$ADMIN_PASSWORD" \
    --email "${ADMIN_EMAIL:-admin@localhost.localdomain}" \
    --db-url "$GOALERT_DB_URL" || true
fi

exec goalert
