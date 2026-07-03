# Security

- Keep `N8N_ENCRYPTION_KEY` stable after first deployment.
- Replace the self-signed certificate before production handover.
- Use internal DNS and firewall rules to restrict access.
- Keep PostgreSQL private to the backend network.
- Rotate credentials through your normal operational process.
- Review exported workflows before importing them into production.
