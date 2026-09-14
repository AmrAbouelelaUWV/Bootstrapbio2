# Remote Management OTAP - Gap Plan en Uitvoering

## Huidige status (bevestigd)
- Bootstrap stack: succesvol deployed via workflow deploy.yml.
- Jumphost compositie: succesvol deployed via workflow deploy-jumphost.yml.
- Bastion access: onderdeel van jumphost compositie en daarmee deployed.

## Doel
Van de huidige basis naar volledig compliant remote-management volgens CNC-principes:
- Layers: Foundation -> Infrastructure -> Platform -> Application.
- Module -> Stack -> Workload als harde release-structuur.
- One state per deployable stack.
- OTAP promotie: o -> t -> a -> p.
- Mandatory naming/tagging en policy gates.

## Harde uitvoerregel
- Geen losse resources testen/deployen als einddoel.
- We bouwen eerst herbruikbare modules per capability.
- We deployen alleen via stacks die modules composeren.
- Workflows zijn stack-gericht (niet resource-gericht).

## Wat nog moet worden gebouwd (prioriteit)
1. NAT module + stack integratie
- Module: nat-gateway met public ip en subnet association.
- Stack: composition-jumphost gebruikt de NAT module als onderdeel van infrastructuur.

2. Private endpoint module + stack integratie
- Module: private-endpoint met dns zone group support.
- Stack: bootstrap/jumphost koppeling, start met Key Vault PE.

3. Encryptie modules + stack integratie
- Modules: key-vault key, disk-encryption-set, benodigde role assignments.
- Stack: VM stack activeert DES/CMK voor beheerde disks.

4. Governance en security
- Modules: policy-assignment, defender, activity-log, resource-lock.
- Stacks: foundation/platform stacks koppelen governance modules op juiste scope.

5. Operations hardening
- Modules: update-manager, backup (rsv + policy + protected vm).
- Stacks: operations/composition stack activeert deze voor de management VMs.

## Aanpak: in welke volgorde deployen
Fase 1 (Infrastructure hard requirements)
- NAT module bouwen -> opnemen in stack -> stack deployen.
- Private endpoint module bouwen -> opnemen in stack -> stack deployen (minimaal voor Key Vault).

Fase 2 (Encryption en platform security)
- DES/CMK modules bouwen -> opnemen in stack -> stack deployen.
- Governance modules (policy/defender) bouwen -> opnemen in stack -> stack deployen.

Fase 3 (Operations en protectie)
- Operations modules bouwen -> opnemen in stack -> stack deployen.
- Resource-lock module bouwen -> opnemen in stack -> stack deployen.

## OTAP uitvoeringsmodel per stack
Per stack exact dezelfde release flow:
1. PR checks: fmt, validate, test, tflint, checkov, conftest.
2. Handmatige deploy naar o.
3. Validatie in o (plan, smoke tests, policy checks).
4. Promote naar t, daarna a, daarna p met version pinning.
5. Per stack per omgeving eigen state (geen gedeelde state).

## Repository en bron-waarheid
Aanbevolen keuze:
- Houd deze repo als canonieke bron voor stacks en modules die nu al draaien.
- Verwijder functionele doublures stap voor stap uit parallelle AZLABS-cnc-* repo clones.
- Leg per module en stack vast: owner repo, state naam, workflow naam, OTAP promotieregels.

## Wel of geen aparte file?
Ja, apart bestand is nodig.
- Dit document is de functionele backlog + uitvoering.
- Voeg daarna een tweede document toe met technische runbooks per stack (inputs, secrets, smoke tests, rollback).

## Direct uitvoerbare next actions
1. Besluit vastleggen: deze repo is canonical source of truth.
2. NAT module toevoegen en in de juiste stack opnemen.
3. Nieuwe stack-workflow toevoegen (bijv. deploy-infrastructure.yml) met standaardinputs.
4. Stack in o succesvol deployen, dan t, a, p promoten.
5. Daarna private-endpoint module toevoegen in dezelfde stack-releaseflow.

## Definition of done per module/stack wijziging
- Terraform resources deployed in o/t/a/p.
- PR en deploy workflow groen.
- State artifact of remote state traceerbaar per stack.
- Security/policy checks groen.
- Documentatie bijgewerkt (inputs, outputs, runbook, rollback).
