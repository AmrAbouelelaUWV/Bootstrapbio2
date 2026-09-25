# Repository instructions

Follow the CNF Terraform bootstrap standard.

This repository contains the Azure Terraform state bootstrap root.

## Rules

- This repository is a bootstrap root, not a reusable module or product stack.
- Do not add backend configuration here; this root runs before remote state exists.
- Do not consume company modules from this repository.
- Keep the resource graph small and auditable.
- Never put secrets in tfvars.
- Use OIDC federation for pipeline identity.
- Storage account names must be lowercase alphanumeric and at most 24 characters.
- All cloud resources must carry the `biv` tag.
- Run `make check` before proposing changes.
