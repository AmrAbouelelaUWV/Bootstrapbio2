# Copilot instructions

This repository is a Terraform stack.

The stack concept is Azure jumphost: workload network composition, Bastion
access stack composition, management VMs, access assignments, and PIM wiring.

- Compose modules with explicit inputs and outputs.
- Keep the module tree flat.
- Put glue resources in the stack.
- Do not create thin-wrapper modules inside this repository.
- Do not expose security baselines as variables.
- Use exact-pinned module sources.
- Use local relative module sources only before the first module release tags
  exist.
- Use tests to prove stack guarantees.
- Use policies to enforce architecture and governance.
- Document every complex object input with a copy-pasteable README example and
  matching test fixture.
- Run `make check` before proposing changes.
