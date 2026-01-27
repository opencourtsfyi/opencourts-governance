# OpenCourts.FYI — Project Milestones

As a Technical Program Manager for the opencourts.fyi initiative, I have organized the development process into six prioritized milestones. These milestones are sequenced to establish a secure, automated foundation before scaling to community governance and data normalization.

---

## Milestone 1: Secure Infrastructure & Local Development

**Priority:** Critical

Establish the core cloud environment and developer workflows to ensure all data and secrets are handled securely from the start.

**Acceptance Criteria:**
- Core infrastructure (compute, networking, storage, database) is defined and deployable via Terraform for both staging and production.
- All web traffic uses HTTPS, and data at rest is encrypted using platform-native tools.
- Secrets (API keys, database passwords) are stored in a secure manager like Key Vault, not in Git.
- A local development environment is available via Docker Compose, allowing developers to test portal features and mocked AI reviews.
- RBAC is implemented with roles for Anonymous, Contributor, Moderator, and Admin.

---

## Milestone 2: National Court Registry & State Seeding

**Priority:** High

Build the "source of truth" for court identities and seed the system with initial data from North and South Carolina.

**Acceptance Criteria:**
- A canonical Court Registry is established as a versioned, auditable source of truth for all court identities.
- Registry is seeded with official court directories for North Carolina and South Carolina.
- Implementation of multi-signal duplicate detection (name, jurisdiction, location identifiers) to resolve overlapping court records.
- Automated CKAN Bootstrap process creates and synchronizes "organization" entities in the portal based on the registry.
- A dry-run mode is functional for the sync process to preview changes before they hit production.

---

## Milestone 3: Discovery Portal & Dataset Management

**Priority:** High

Enable the primary discovery layer for users and AI agents to find and access court records.

**Acceptance Criteria:**
- Authorized users can create datasets with titles, descriptions, and mandatory provenance metadata (source URLs, hashes).
- Search and discovery features allow filtering by keywords, jurisdiction, court type, and review status.
- Machine-readable catalogues (API endpoints) are exposed for automated tools and AI agents.
- Every dataset page displays a human-readable provenance summary and a court Terms of Use compliance notice.

---

## Milestone 4: Automated Ingestion & Medallion Pipeline

**Priority:** Medium

Transition from manual linking to automated data processing and normalization for advanced analytics.

**Acceptance Criteria:**
- Implementation of the medallion storage model: Bronze (raw), Silver (standardized Parquet), and Gold (publication-ready artifacts).
- Lineage records are automatically generated, linking Gold datasets back to their original Bronze source files.
- Azure Data Factory (ADF) configurations are stored in GitHub as the source of truth for all pipelines.
- The system enforces a Source Preservation Policy, distinguishing between link-only resources and files copied to Azure Blob Storage for derivatives.
- Ingestion pipelines respect a min_recrawl_interval_seconds to avoid overloading official court websites.

---

## Milestone 5: Community Governance & AI Review

**Priority:** Medium

Establish the workflows required to scale the platform through volunteer contributions and automated quality control.

**Acceptance Criteria:**
- Community submission workflow is active; submissions remain in a "pending" state until moderated.
- AI-assisted review triggers on submission to flag PII, check metadata quality, and identify policy violations.
- Moderators have a human moderation dashboard to approve, reject, or request changes based on AI reports.
- Badges and review indicators (e.g., "AI-reviewed," "Provenance Verified") are visible on published datasets.
- A public governance decision log is maintained to document all major policy and publication changes.

---

## Milestone 6: Reliability & Long-term Operations

**Priority:** Low

Ensure the system is resilient, transparent, and maintainable by a distributed team.

**Acceptance Criteria:**
- Monitoring and health checks are configured for uptime, high error rates, and resource thresholds (CPU/Disk).
- Disaster recovery procedures are in place, including nightly backups with 30-day retention and quarterly restore testing.
- A public takedown request mechanism is functional with a documented workflow for handling sensitive data issues.
- The first Annual Review is published summarizing data coverage, improvements, and future plans.
- Documentation exists for administrative access recovery to ensure system continuity (the "bus factor").
