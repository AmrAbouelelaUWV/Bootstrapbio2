# Copilot instructions

This repository is a Terraform module.

The module concept is hardened Azure management VMs. It is not a thin wrapper
around Azure VM resources.

- Do not add provider or backend configuration outside `terraform.tf`.
- Do not create thin wrappers around single resources.
- Do not expose security baselines as variables.
- Keep module inputs focused on common consumer choices.
- Document every complex object input with a copy-pasteable README example and
  matching test fixture.
- Use tests to prove naming, tags, secure defaults, validations, and outputs.
- Run `make check` before proposing changes.
