# Architecture

The stack is intentionally small:

- `caddy` exposes internal HTTP and HTTPS
- `n8n` runs the automation engine
- `postgres` stores workflow and execution data

The default flow is:

1. A user reaches Caddy on the HTTPS port.
2. Caddy forwards requests to n8n on the internal network.
3. n8n uses PostgreSQL for persistent state.

Persistent data is split across:

- `n8n_data` for n8n application state
- `postgres_data` for the database
- `caddy_data` and `caddy_config` for proxy state
