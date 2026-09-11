# Copilot instructions

This repository is a Terraform bootstrap root.

The root concept is Azure Terraform state bootstrap before remote state exists.

- Do not add a backend block.
- Do not call company modules.
- Keep bootstrap resources concrete and minimal.
- Use Azure AD/OIDC authentication, not pipeline secrets.
- Do not store real credentials in examples or tests.
- Run `make check` before proposing changes.
