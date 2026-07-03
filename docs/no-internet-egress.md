# No Internet Egress

This repository does not download dependencies during install.

The remaining egress control must be enforced outside the repo:

- host firewall
- network ACLs
- proxy allow-lists
- route filtering

Only the internal services required by your deployment should be reachable.
