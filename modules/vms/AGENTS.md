# Repository instructions

Follow the CNF Terraform module standard.

This repository contains the Azure hardened management VMs module.

## Rules

- This repository is a module, not a stack or workload.
- Do not create thin wrappers around single resources.
- This module must remain the hardened management VM concept: Linux and Windows
  VM resources, private NICs, managed identity, boot diagnostics, Entra login,
  source image inputs, and required tags.
- PIM, RBAC, Bastion, naming policy, subnet selection, and customer-specific
  access wiring belong in stacks.
- Keep provider configuration out of this module.
- Keep backend configuration out of this module.
- Use provider-specific Terraform resources.
- Use exact provider version constraints.
- Use `this` as the resource identifier when there is only one resource of a type.
- Use snake_case for Terraform identifiers.
- Use `for_each` over `count` for named resources.
- Every variable and output must have a useful description.
- Complex object inputs must have copy-pasteable README examples and matching
  terraform test fixtures.
- Required governance tags must be applied by the module contract.
- Do not expose security baselines as toggles.
- Do not put secrets in variables intended for tfvars.

## Validation loop

Run these before opening a pull request:

```bash
make fmt
make validate
make lint
make test
make scan
```
