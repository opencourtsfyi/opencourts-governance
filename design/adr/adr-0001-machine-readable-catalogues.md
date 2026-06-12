---
status: proposed
date: 2026-06-12
decision-maker(s): [James Tasse]
---

# Machine-readable catalogues (FR-5)

## Context and Problem Statement

OpenCourts must expose machine-readable catalogues so automated tools and AI agents can discover datasets, resources, and metadata without authentication for public data (SRS FR-5). The metadata portal is CKAN (`opencourts-ckan`).

## Decision Drivers

- Align with CKAN as the existing portal (low volunteer burden)
- Standards-based discovery where practical (DCAT)
- Anonymous read for public datasets
- Avoid operating a separate catalogue service

## Considered Options

1. **CKAN Action API + ckanext-dcat** — use CKAN’s native JSON API and DCAT RDF feeds
2. **Custom catalogue API** — bespoke REST/GraphQL service in front of CKAN
3. **DCAT only** — RDF feeds without documenting the Action API as primary

## Decision Outcome

Chosen option: **CKAN Action API (primary) + ckanext-dcat (secondary)**, implemented in `opencourts-ckan`.

Rationale: FR-5 maps directly onto CKAN’s built-in capabilities; a custom service adds ops and duplication. The Action API is the most practical surface for agents and scripts; DCAT supports standards-based federation.

### Consequences

- **Good:** No new service to deploy; familiar CKAN patterns; documented in repo `ARCHITECTURE.md`
- **Bad:** Rich schema/provenance field metadata (FR-6/7/8) is not fully addressed by catalogue exposure alone
- **Follow-on:** CI smoke tests ([opencourts-infra#23](https://github.com/opencourtsfyi/opencourts-infra/issues/23)); agent discovery (`llms.txt`, MCP) deferred

## Confirmation

Local verification via `scripts/verify_catalog.py` in `opencourts-ckan` (anonymous checks against seeded `test-package` / `test-org`).

## More Information

- Implementation: [opencourts-ckan#5](https://github.com/opencourtsfyi/opencourts-ckan/issues/5)
- Repo docs: `ARCHITECTURE.md` in `opencourts-ckan` (link to PR once open)
- SRS: `design/software-requirements-specification.md` §3.2 FR-5