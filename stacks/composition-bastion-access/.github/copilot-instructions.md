# Copilot instructions

This repository is a Terraform stack.

The stack concept is Azure Bastion access foundation.

- Compose modules with explicit inputs and outputs.
- Keep the module tree flat.
- Put glue resources in the stack.
- Do not create thin-wrapper modules inside this repository.
- Do not expose security baselines as variables.
- Use exact-pinned module sources.
- Use tests to prove stack guarantees.
- Use policies to enforce architecture and governance.
- Run `make check` before proposing changes.
