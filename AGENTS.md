# Repository instructions

Follow the CNF Terraform stack standard.

This repository contains the Azure jumphost golden path stack.

## Rules

- This repository is a stack, not a low-level module or workload.
- Compose modules through explicit inputs and outputs.
- Keep the module tree flat.
- Put glue resources in the stack.
- Hardcode security baselines.
- This stack owns company naming, VM access assignments, and PIM eligible
  assignments.
- Bastion composition is delegated to xx-azurerm-stack-bastion-access.
- The network and VM modules must stay generic.
- Do not expose public access, weak TLS, insecure auth, or disabled diagnostics as consumer toggles.
- Do not use `latest`, `main`, or floating module references.
- Workloads own backend configuration, state, tfvars, environment fan-out, and stack pins.
- Stack tests must prove golden-path guarantees.
- Stack policies must enforce architecture and governance guardrails.
- Complex object inputs must have copy-pasteable README examples and matching
  terraform test fixtures.

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
