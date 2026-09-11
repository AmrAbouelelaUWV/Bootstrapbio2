# Copilot instructions

This repository is a Terraform module.

The module concept is Azure network foundation. It is not a thin wrapper around
`azurerm_virtual_network`.

- Do not add provider or backend configuration outside `terraform.tf`.
- Do not create thin wrappers around single resources.
- Do not expose security baselines as variables.
- Keep module inputs focused on common consumer choices.
- Use tests to prove naming, tags, secure defaults, validations, and outputs.
- Run `make check` before proposing changes.
