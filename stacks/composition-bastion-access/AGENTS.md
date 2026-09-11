# Repository instructions

Follow the CNF Terraform stack standard.

This repository contains the Azure Bastion access foundation stack.

## Rules

- This repository is a stack, not a low-level module or workload.
- Compose modules through explicit inputs and outputs.
- Keep the module tree flat.
- Put glue resources in the stack.
- Hardcode security baselines.
- This stack owns the dedicated Bastion VNet pattern, mandatory Bastion NSG
  rules, Bastion public IP, Bastion host, and peering to a target VNet.
- Use xx-azurerm-network for network primitives. Do not duplicate generic VNet,
  subnet, NSG, route, or peering mechanics.
- Do not expose public access, weak TLS, insecure auth, or disabled diagnostics as consumer toggles.
- Do not use `latest`, `main`, or floating module references.
- Workloads own backend configuration, state, tfvars, environment fan-out, and stack pins.
- Stack tests must prove golden-path guarantees.
- Stack policies must enforce architecture and governance guardrails.

## Validation loop

Run these before opening a pull request:

```bash
make fmt
make validate
make lint
make test
make policy
make scan
```
