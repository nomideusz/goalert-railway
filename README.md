# Deploy and Host GoAlert on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/goalert?utm_medium=integration&utm_source=button&utm_campaign=goalert)

[GoAlert](https://goalert.me/) is open-source on-call scheduling, automated escalations, and notifications — built and battle-tested by Target. Rotations, escalation policies, and alerts that reach the right person by SMS, voice call, Slack, email, or web push, so you never miss a critical page. A self-hosted alternative to PagerDuty and the sunsetting Opsgenie, with no per-user pricing.

## About Hosting GoAlert

This template runs GoAlert as a single service next to a Postgres database — that's the whole stack. All state (schedules, policies, alerts, users) lives in Postgres, so the app service needs no volume and restarts cleanly. Database migrations run automatically on every deploy, and your first admin account is created from the `ADMIN_USERNAME` / `ADMIN_PASSWORD` template variables on first boot. Alert data is encrypted at rest with the generated `GOALERT_DATA_ENCRYPTION_KEY`.

## Common Use Cases

- On-call rotations and escalation chains for an engineering team — without PagerDuty's per-user bill
- A landing spot for Opsgenie migrations before Atlassian's end-of-support deadline
- Alert routing for existing monitoring (Prometheus Alertmanager, Grafana, Zabbix, healthchecks) via GoAlert's integration keys and email ingestion

## Dependencies for GoAlert Hosting

- PostgreSQL (included in this template — GoAlert enables the `pgcrypto` extension itself)

### Deployment Dependencies

- [GoAlert documentation](https://goalert.me/docs/)
- [Template source on GitHub](https://github.com/nomideusz/goalert-railway)

### Implementation Details

**Your GoAlert lives at the service's Railway domain.** Sign in with the `ADMIN_USERNAME` / `ADMIN_PASSWORD` values from your template variables.

To actually page people, connect notification channels in the admin UI (Admin → Config):

1. **SMS and voice calls** — add Twilio credentials (Account SID, auth token, a Twilio number). This is the classic pager experience; a $10/month Twilio number covers a small team.
2. **Slack** — create a Slack app with the manifest GoAlert generates for you and paste the tokens.
3. **Email** — add SMTP credentials to send alert emails.

Notes:

- Migrations run automatically; upgrading is just a redeploy.
- The admin bootstrap is idempotent — the "duplicate key" log line on later boots is expected and harmless.
- `GOALERT_PUBLIC_URL` is derived from your Railway domain automatically; set it manually if you put GoAlert behind your own domain.

## Why Deploy GoAlert on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying GoAlert on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
