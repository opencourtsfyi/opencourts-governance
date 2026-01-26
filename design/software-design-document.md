### SDD Entry
- **Feature Name:**  
  FR-1: Create and manage datasets

- **Problem Statement:**  
  Implement FR-1 as specified in the SRS.

- **User Stories:**  
  - As an authorized user, I can create datasets with title, description, tags, jurisdiction (state, county), court level..

- **Acceptance Criteria:**  
  - Authorized users can create datasets with title, description, tags, jurisdiction (state, county), court level.
  - Source information (URLs, institution names).
  - Provenance metadata (see Section 4).
  - Upload of structured data files (CSV, JSON, XLSX) and documentation files (PDF, MD, HTML, etc.).
  - Linking to remote resources (e.g., files on court websites, APIs, or data lakes).

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-2: Dataset versions

- **Problem Statement:**  
  Implement FR-2 as specified in the SRS.

- **User Stories:**  
  - As a user, I can see when a dataset was last updated and, where possible, what changed..

- **Acceptance Criteria:**  
  - Support for dataset versioning (or equivalent metadata) when datasets are updated or re-ingested.
  - Users can see when a dataset was last updated and, where possible, what changed.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Data ingestion and processing

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-2A: Update / recrawl metadata

- **Problem Statement:**  
  Implement FR-2A as specified in the SRS.

- **User Stories:**  
  - As a user, I can Update / recrawl metadata.

- **Acceptance Criteria:**  
  - The system shall support recording per-dataset update/recrawl metadata including min_recrawl_interval_seconds.
  - Automated ingestion pipelines and schedulers shall respect min_recrawl_interval_seconds for a dataset’s configured source(s) and shall not recrawl more frequently than the specified minimum.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Data ingestion and processing

- **Target Repository:**  
  opencourts-etl

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-3: Dataset search and discovery

- **Problem Statement:**  
  Implement FR-3 as specified in the SRS.

- **User Stories:**  
  - As a user, I can search datasets by keywords, tags, jurisdiction, date ranges, court type, data type..

- **Acceptance Criteria:**  
  - Users can search datasets by keywords, tags, jurisdiction, date ranges, court type, data type.
  - Users can filter datasets using facets (state, county, court level, topic, reviewed/unreviewed).

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-4: CSV and JSON access

- **Problem Statement:**  
  Implement FR-4 as specified in the SRS.

- **User Stories:**  
  - As a user, I can CSV and JSON access.

- **Acceptance Criteria:**  
  - Endpoints that return CSV and JSON formatted data for each dataset (or selected resources).
  - Support for pagination and basic query/filter parameters where feasible.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-5: Machine-readable catalogues

- **Problem Statement:**  
  Implement FR-5 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Machine-readable catalogues.

- **Acceptance Criteria:**  
  - Expose machine-readable catalogues (e.g., DCAT-style or CKAN API endpoints) that list datasets, resources (files, APIs), and metadata (schemas, field descriptions, provenance fields).
  - Catalogues accessible to automated tools and AI agents without requiring authentication for public datasets.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-6: Schema / field metadata

- **Problem Statement:**  
  Implement FR-6 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Schema / field metadata.

- **Acceptance Criteria:**  
  - Allow maintainers to document field-level metadata (name, description, type, allowed values) for key datasets.
  - Field metadata accessible via UI and API for machine consumption.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-7: Provenance metadata

- **Problem Statement:**  
  Implement FR-7 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Provenance metadata.

- **Acceptance Criteria:**  
  - For each dataset derived from court sources, store at minimum: source URLs, source institution, date/time retrieved, file hash, description of transformations, terms of use or policy reference.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-8: Provenance display

- **Problem Statement:**  
  Implement FR-8 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Provenance display.

- **Acceptance Criteria:**  
  - Display a human-readable provenance summary on each dataset page.
  - Provenance metadata accessible via API for machine use.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-9: Court Terms of Use compliance notice

- **Problem Statement:**  
  Implement FR-9 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Court Terms of Use compliance notice.

- **Acceptance Criteria:**  
  - Indicate the relevant court Terms of Use on each dataset page.
  - Include a short statement that data is derived from court sources and not an official record.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-10: Automatic provenance logging for automated ingestion

- **Problem Statement:**  
  Implement FR-10 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Automatic provenance logging for automated ingestion.

- **Acceptance Criteria:**  
  - Ingest pipelines (e.g., serverless functions) automatically record source URLs, retrieval timestamps, file hashes, pipeline name/version.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Data ingestion and processing

- **Target Repository:**  
  opencourts-etl

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-10A: Bronze/Silver/Gold storage lineage

- **Problem Statement:**  
  Implement FR-10A as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Bronze/Silver/Gold storage lineage.

- **Acceptance Criteria:**  
  - Automated ingestion pipelines shall support a medallion-style storage model with distinct stages for:
  - Bronze (ingest): raw ingested data preserved in its original format(s).
  - Silver (transform): cleaned/standardized datasets stored in Parquet format.
  - Gold (publish): publication-ready datasets stored in Parquet format and optionally rendered/exported as CSV and JSON.
  - For each published (gold) dataset/resource, the system shall record lineage that links the gold artifact(s) back to the specific silver artifact(s) and bronze artifact(s) from which they were produced.
  - Lineage records shall include, at minimum: storage location(s) (container/path or equivalent), file hash(es) for each stage artifact, timestamps, and the pipeline run identifier and pipeline name/version that produced each transformation.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Data ingestion and processing
  - AI review and governance layer

- **Target Repository:**  
  opencourts-etl

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-11: Community dataset submissions

- **Problem Statement:**  
  Implement FR-11 as specified in the SRS.

- **User Stories:**  
  - As a contributor, I can submit new datasets or resources (including links and visualizations)..

- **Acceptance Criteria:**  
  - Registered community contributors can submit new datasets or resources (including links and visualizations).
  - Submissions enter a pending or draft state and are not publicly visible until approved.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Visualization layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-12: Community visualization submissions

- **Problem Statement:**  
  Implement FR-12 as specified in the SRS.

- **User Stories:**  
  - As a contributor, I can submit embedded visualizations (excluding Power BI) as resources..

- **Acceptance Criteria:**  
  - Contributors can submit embedded visualizations (excluding Power BI) as resources.
  - Contributors must provide title, description, tags, source dataset(s) and links, and description of methodology.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Visualization layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-13: AI-assisted review

- **Problem Statement:**  
  Implement FR-13 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can AI-assisted review.

- **Acceptance Criteria:**  
  - On submission, the system triggers an AI review process that checks for presence and quality of provenance metadata, flags potential violations of court Terms of Use and portal policies, flags potential PII or sensitive content, and assesses metadata completeness and clarity.
  - The AI review produces a structured report (scores, flags, recommended actions) stored with the submission.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-14: Human moderation

- **Problem Statement:**  
  Implement FR-14 as specified in the SRS.

- **User Stories:**  
  - As a moderator, I can see submission details, AI review report, submission history, and user identity..

- **Acceptance Criteria:**  
  - A human moderator is required to approve, reject, or request changes on each community submission.
  - Moderators see submission details, AI review report, submission history, and user identity.
  - Only moderators (or higher) can change a submission from pending to published.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-15: Badges and review indicators

- **Problem Statement:**  
  Implement FR-15 as specified in the SRS.

- **User Stories:**  
  - As a contributor, I can Badges and review indicators.

- **Acceptance Criteria:**  
  - The system provides visible indicators on datasets: whether they have been AI-reviewed, human-reviewed/approved, and whether provenance has been verified.
  - Badges are driven from internal metadata fields and not directly editable by contributors.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-16: Takedown request handling

- **Problem Statement:**  
  Implement FR-16 as specified in the SRS.

- **User Stories:**  
  - As a moderator, I can Takedown request handling.

- **Acceptance Criteria:**  
  - The system provides a public takedown request mechanism (e.g., form or contact) that allows requesters to identify datasets or resources and state reasons (e.g., PII, legal risk, errors).
  - Moderators have a workflow to temporarily hide datasets/resources, review and decide on takedown, and document resolution (e.g., remove, redact, reject request).

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-17: Visualization linkage

- **Problem Statement:**  
  Implement FR-17 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Visualization linkage.

- **Acceptance Criteria:**  
  - Each embedded visualization shall be associated with one or more underlying datasets in the catalog.
  - Clear indication of whether the visualization is official or community-contributed.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Visualization layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-18: Local dev environment

- **Problem Statement:**  
  Implement FR-18 as specified in the SRS.

- **User Stories:**  
  - As a developer, I can Local dev environment.

- **Acceptance Criteria:**  
  - The system shall be runnable locally on developer machines with containerized services (e.g., Docker Compose) or documented setup scripts.
  - Local instances of portal (CKAN or equivalent), database, minimal storage.
  - Developers can create test datasets, test AI review integration using mocked or dev credentials, and run unit and integration tests.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-19: Staging and production environments

- **Problem Statement:**  
  Implement FR-19 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Staging and production environments.

- **Acceptance Criteria:**  
  - The system supports at least a staging environment for testing and a production environment for public access.
  - Configuration (URLs, credentials, feature flags) shall be environment-specific and not hard-coded.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-20: National Court Discovery as a Registry and Verification Pipeline

- **Problem Statement:**  
  Implement FR-20 as specified in the SRS.

- **User Stories:**  
  - As an admin, I can National Court Discovery as a Registry and Verification Pipeline.

- **Acceptance Criteria:**  
  - The system shall implement court discovery as a canonical registry and verification pipeline, not as a generalized web-crawling process.
  - The system shall maintain a single authoritative Court Registry as the source of truth for all courts in the United States.
  - Each court in the Court Registry shall have a stable, unique identifier that persists across URL changes, renaming, or restructuring.
  - The Court Registry shall store, at minimum: jurisdiction level, court type, state, county/locality identifiers, hierarchical relationships, official website URL(s), provenance source(s), and verification status.
  - The Court Registry shall be versioned, auditable, and human-reviewable, including the ability to view historical changes and the provenance/rationale for edits.
  - The system shall seed the Court Registry from authoritative, official judicial directories published by state judicial branches, administrative offices of the courts, or equivalent official entities.
  - Registry expansion shall proceed outward from authoritative sources; generalized web crawling shall not be used as a primary discovery mechanism.
  - When authoritative directories are incomplete, secondary aggregators may be used only as non-authoritative hints to identify potentially missing courts.
  - Secondary aggregator hints shall never be treated as canonical sources and shall require independent verification before a court is added to the Court Registry.
  - The system shall support modular, state-specific adapters that ingest court listings from official state sources and emit standardized Court Registry updates.
  - State adapters shall be independently maintainable, replaceable, and testable; changes in a state website’s structure shall be isolated to the corresponding adapter without affecting other states.
  - The system shall define a national taxonomy of court types and jurisdiction levels.
  - Each state shall map its court naming conventions and structures to the national taxonomy via explicit configuration.
  - Raw state-specific court names and labels shall be preserved alongside normalized national classifications.
  - The system shall support hierarchical court models that vary by state (e.g., multi-tier trial courts, specialty courts, and administrative divisions).
  - The system shall remain up-to-date via scheduled verification and event-driven signals.
  - Scheduled verification shall periodically validate court URLs, detect redirects or failures, and re-run state adapters when authoritative sources change.
  - Event-driven signals shall include user reports, partner notifications, and automated anomaly detection.
  - URL changes, court renaming, and structural reorganization shall be treated as expected events and shall result in versioned registry updates rather than being treated as errors.
  - The registry and adapters shall be maintainable by a distributed team of volunteers, with documentation sufficient to add or update courts without deep engineering expertise.
  - Registry updates shall follow a lightweight review and approval workflow with clear provenance requirements.
  - Validation rules shall prevent duplicate courts, missing required fields, and inconsistent hierarchy.
  - The Court Registry shall drive downstream systems, including CKAN organization creation, dataset ownership, and ingestion pipelines.
  - CKAN shall reflect the Court Registry but shall not serve as the canonical source of court identity or structure.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Data ingestion and processing
  - AI review and governance layer

- **Target Repository:**  
  opencourts-etl

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-21: CKAN Bootstrap and Registry Sync for North Carolina and South Carolina Courts

- **Problem Statement:**  
  Implement FR-21 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can CKAN Bootstrap and Registry Sync for North Carolina and South Carolina Courts.

- **Acceptance Criteria:**  
  - The system shall provide an automated, repeatable process to bootstrap and continuously synchronize CKAN court “organization” entities from the Court Registry.
  - The initial implementation shall support, at minimum, all courts enumerated by the authoritative official court directories for North Carolina and South Carolina as configured registry sources.
  - Each sync run shall produce a machine-readable coverage report for NC and SC that enumerates: authoritative source entries discovered, Court Registry entries created/updated, entries pending verification, entries excluded (with reasons), and the timestamp/version of the source inputs used.
  - The sync process shall be idempotent: running it multiple times with unchanged Court Registry input shall not create duplicates and shall result in no net CKAN changes.
  - The sync process shall support a dry-run mode that outputs a planned change set (create/update/deactivate) without modifying CKAN.
  - CKAN organizations created/managed by this process shall be keyed to the Court Registry’s stable court identifier, and the CKAN organization “name/slug” shall remain stable across court renames or URL changes.
  - The system shall represent court hierarchy in CKAN in a deterministic, queryable way (even if CKAN lacks native hierarchical orgs), at minimum by storing court_id and parent_court_id (and/or equivalent fields) in organization metadata (e.g., extras) and ensuring the UI/API can reconstruct hierarchy from those fields.
  - The sync process shall detect and report drift between CKAN and the derived state from the Court Registry (including manual edits), and shall either reconcile drift automatically or require explicit maintainer approval per documented policy.
  - The sync process shall not hard-delete CKAN organizations by default; when a court is merged, split, or deactivated in the Court Registry, the corresponding CKAN organization shall be marked inactive/archived in a reversible way while preserving auditability.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  FR-22: Court Registry Duplicate Detection and Canonical Identity Resolution

- **Problem Statement:**  
  Implement FR-22 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Court Registry Duplicate Detection and Canonical Identity Resolution.

- **Acceptance Criteria:**  
  - The system shall support ingesting court listings from multiple authoritative registries (e.g., statewide and circuit-level directories) even when those sources contain overlapping/duplicate references to the same real-world court.
  - The Court Registry shall assign and maintain a stable, unique court identifier for each real-world court.
  - The system shall detect potential duplicates using a multi-signal approach including, at minimum: normalized court name(s), jurisdiction level, court type, state, county/locality identifiers, hierarchical relationships (parent/child), and authoritative source identifiers/codes when available.
  - Official website URL(s) shall be treated as a supporting signal for duplicate detection and verification; the system shall explicitly forbid URL-only duplicate detection and shall not assume that equal or unequal URLs imply the same or different courts.
  - When a potential duplicate is detected, the system shall record a structured, human-reviewable match report that includes the matching signals used, confidence/score (if applicable), and a recommended action (e.g., merge, keep separate, request more evidence).
  - If court identity resolution results in a merge, split, or re-parenting, the system shall preserve provenance and versioned change history, including the rationale and any affected authoritative source references.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Data ingestion and processing
  - AI review and governance layer

- **Target Repository:**  
  opencourts-etl

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  DG-1: Public, non-confidential data

- **Problem Statement:**  
  Implement DG-1 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Public, non-confidential data.

- **Acceptance Criteria:**  
  - The platform focuses on public, non-confidential data; it shall not intentionally store or publish sealed records, confidential information, or PII beyond what is already publicly published by courts.

- **Dependencies:**  
  - Data ingestion and processing
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  DG-2: Minimal PII

- **Problem Statement:**  
  Implement DG-2 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Minimal PII.

- **Acceptance Criteria:**  
  - Where court data inherently contains names or identifiers, the portal shall document that the data is sourced from public records and consider redaction policies for particularly sensitive content if practical.

- **Dependencies:**  
  - Data ingestion and processing
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  DG-3: Clear distinction between official and derived data

- **Problem Statement:**  
  Implement DG-3 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Clear distinction between official and derived data.

- **Acceptance Criteria:**  
  - The system shall clearly differentiate between official court publications (linked to original sources) and derived datasets processed by opencourts.fyi or community members.

- **Dependencies:**  
  - Data ingestion and processing
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  DG-4: Contributor terms

- **Problem Statement:**  
  Implement DG-4 as specified in the SRS.

- **User Stories:**  
  - As a contributor, I can Contributor terms.

- **Acceptance Criteria:**  
  - Contributors shall agree to terms stating that they have rights to publish the data/visualizations, their submissions comply with applicable court Terms of Use and law, and they will not upload malicious, discriminatory, or privacy-violating content.

- **Dependencies:**  
  - Data ingestion and processing
  - Storage layer
  - AI review and governance layer
  - Visualization layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  DG-5: Provenance requirement

- **Problem Statement:**  
  Implement DG-5 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Provenance requirement.

- **Acceptance Criteria:**  
  - Community submissions shall be required to provide data sources and URLs, and indicate whether data is original, derived, or repackaged.

- **Dependencies:**  
  - Data ingestion and processing
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  DG-6: Auditability

- **Problem Statement:**  
  Implement DG-6 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Auditability.

- **Acceptance Criteria:**  
  - For each dataset and community submission, the system shall log who submitted it, who approved it, AI review results, and timestamps of all key actions.

- **Dependencies:**  
  - Data ingestion and processing
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  DG-7: Takedown workflow

- **Problem Statement:**  
  Implement DG-7 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Takedown workflow.

- **Acceptance Criteria:**  
  - The system shall implement a documented process for handling requests, including time frame for acknowledgment, temporary hide while under review (for serious issues), and escalation path (e.g., to legal partners or court liaisons) where needed.

- **Dependencies:**  
  - Data ingestion and processing
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-governance

- **Labels:**  
  ["documentation"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  DG-8: Corrections and annotations

- **Problem Statement:**  
  Implement DG-8 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Corrections and annotations.

- **Acceptance Criteria:**  
  - The system shall allow maintainers to add correction notes to datasets and point to updated versions or official corrections from courts.

- **Dependencies:**  
  - Data ingestion and processing
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  GC-1: Public governance decision log

- **Problem Statement:**  
  Implement GC-1 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Public governance decision log.

- **Acceptance Criteria:**  
  - The project shall maintain a public, linkable log of governance decisions (e.g., GitHub issues/discussions/PRs) including the decision, rationale, and date.
  - Decisions related to publication status, takedowns, major schema changes, and policy changes shall be logged.

- **Dependencies:**  
  - AI review and governance layer
  - Web portal and API layer

- **Target Repository:**  
  opencourts-governance

- **Labels:**  
  ["documentation"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  GC-2: Truthiness evaluation metadata

- **Problem Statement:**  
  Implement GC-2 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Truthiness evaluation metadata.

- **Acceptance Criteria:**  
  - For each published dataset, the system shall support recording and displaying a “truthiness evaluation” summary that includes:
  - What the dataset claims to represent (scope/coverage)
  - Verification steps taken (if any) against official sources
  - Known limitations, uncertainty, and potential biases
  - Provenance links and timestamps

- **Dependencies:**  
  - AI review and governance layer
  - Web portal and API layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  GC-3: Community challenge and re-evaluation workflow

- **Problem Statement:**  
  Implement GC-3 as specified in the SRS.

- **User Stories:**  
  - As a moderator, I can Community challenge and re-evaluation workflow.

- **Acceptance Criteria:**  
  - Any user shall be able to challenge a dataset’s accuracy, provenance, or interpretation via a public issue.
  - Maintainers/moderators shall be able to attach an outcome (e.g., acknowledged, corrected, disputed, withdrawn) and link to resulting changes.

- **Dependencies:**  
  - AI review and governance layer
  - Web portal and API layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  GC-4: Public moderation outcomes (with safe redactions)

- **Problem Statement:**  
  Implement GC-4 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Public moderation outcomes (with safe redactions).

- **Acceptance Criteria:**  
  - For community submissions and takedown requests, the system shall publish the outcome and a brief rationale.
  - The system shall support redaction of sensitive details in public rationales when necessary (e.g., to avoid amplifying PII), while still preserving an auditable record for maintainers.

- **Dependencies:**  
  - AI review and governance layer
  - Web portal and API layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  GC-5: Low-friction participation

- **Problem Statement:**  
  Implement GC-5 as specified in the SRS.

- **User Stories:**  
  - As a contributor, I can Low-friction participation.

- **Acceptance Criteria:**  
  - Contributor registration (if required) shall be open and lightweight.
  - The project shall provide a non-authenticated contribution path for reporting issues and suggesting improvements (e.g., GitHub issues or a public contact method).

- **Dependencies:**  
  - AI review and governance layer
  - Web portal and API layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  GC-6: Independence and “bus factor” resilience

- **Problem Statement:**  
  Implement GC-6 as specified in the SRS.

- **User Stories:**  
  - As an admin, I can Independence and “bus factor” resilience.

- **Acceptance Criteria:**  
  - No critical workflow (publishing, takedowns, schema releases) shall depend on a single individual.
  - The project shall maintain at least two administrators/maintainers with the ability to operate and recover core systems.
  - Administrative access recovery (e.g., credential rotation, access handoff, break-glass procedure) shall be documented.

- **Dependencies:**  
  - AI review and governance layer
  - Web portal and API layer

- **Target Repository:**  
  opencourts-governance

- **Labels:**  
  ["documentation"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  GC-7: Annual review publication

- **Problem Statement:**  
  Implement GC-7 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Annual review publication.

- **Acceptance Criteria:**  
  - At least once per year, maintainers shall publish a brief public review summarizing:
  - Data coverage and major changes
  - Key improvements
  - Known issues and limitations
  - High-level plans for the coming year

- **Dependencies:**  
  - AI review and governance layer
  - Web portal and API layer

- **Target Repository:**  
  opencourts-governance

- **Labels:**  
  ["documentation"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  GC-8: AI self-identification and labeling

- **Problem Statement:**  
  Implement GC-8 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can AI self-identification and labeling.

- **Acceptance Criteria:**  
  - Any automated agent (including AI systems) interacting with humans on behalf of the project shall clearly self-identify as automated at the start of each interaction.
  - AI-generated outputs used in review, moderation, or publication decisions shall be labeled as AI-generated in the UI and in any exported artifacts (e.g., JSON reports).
  - The system shall prevent AI-generated content from being displayed in a way that could reasonably be interpreted as a human-authored statement (e.g., by including an “AI-generated” label adjacent to the content).

- **Dependencies:**  
  - AI review and governance layer
  - Web portal and API layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  GC-9: National Court Discovery as a Registry and Verification Pipeline

- **Problem Statement:**  
  Implement GC-9 as specified in the SRS.

- **User Stories:**  
  - As a maintainer, I can produce a public, reviewable change log and periodic audit artifacts (e.g., diffs/reports) showing registry additions, removals, merges/splits, URL changes, and verification status changes..

- **Acceptance Criteria:**  
  - Court identity, hierarchy, and official URLs shall be governed through a versioned, auditable Court Registry with a lightweight human review/approval workflow for changes.
  - The governance process shall require provenance for registry entries and updates, including whether a change originated from an authoritative directory, a state adapter run, a verified partner report, or a user-submitted issue.
  - The governance process shall explicitly prohibit treating non-authoritative aggregators or generalized web crawling as canonical sources of court identity.
  - Maintainers shall be able to produce a public, reviewable change log and periodic audit artifacts (e.g., diffs/reports) showing registry additions, removals, merges/splits, URL changes, and verification status changes.
  - Governance decisions and implementation choices for the registry and adapters shall prioritize durability, auditability, low operational cost, and long-term scalability to all 50 U.S. states.

- **Dependencies:**  
  - AI review and governance layer
  - Web portal and API layer
  - Data ingestion and processing

- **Target Repository:**  
  opencourts-etl

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  GC-10: CKAN Bootstrap and Registry Sync Auditability

- **Problem Statement:**  
  Implement GC-10 as specified in the SRS.

- **User Stories:**  
  - As a user, I can CKAN Bootstrap and Registry Sync Auditability.

- **Acceptance Criteria:**  
  - CKAN court-organization state derived from the Court Registry shall be reproducible from versioned inputs, including the registry version and the sync tool/script version.
  - Each sync run shall produce a public, reviewable artifact (e.g., JSON/CSV report or diff summary) describing proposed/applied changes, including counts of created/updated/deactivated organizations and any drift detected.
  - Manual edits to CKAN court-organization metadata that is designated as registry-derived shall be discouraged; if performed, the governance process shall require either (a) backporting the change to the Court Registry or (b) documenting an explicit override rule so the next sync run is predictable and auditable.

- **Dependencies:**  
  - AI review and governance layer
  - Web portal and API layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  SEC-1: Roles and permissions

- **Problem Statement:**  
  Implement SEC-1 as specified in the SRS.

- **User Stories:**  
  - As a contributor, I can Roles and permissions.

- **Acceptance Criteria:**  
  - Roles include at least: Anonymous (read-only access to public data), Contributor (can submit datasets/resources for review), Moderator (can approve/reject submissions and manage content), Admin (full system configuration and user management).
  - Only moderators/admins can change review status, set or override review badges, and publish to production.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  SEC-2: Authentication

- **Problem Statement:**  
  Implement SEC-2 as specified in the SRS.

- **User Stories:**  
  - As a contributor, I can Authentication.

- **Acceptance Criteria:**  
  - Admins and moderators shall use strong authentication, ideally via federated identity (e.g., SSO with MFA).
  - Contributor accounts shall require strong passwords and rate-limited login attempts.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  SEC-3: Encryption

- **Problem Statement:**  
  Implement SEC-3 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Encryption.

- **Acceptance Criteria:**  
  - All web traffic shall use HTTPS.
  - Data at rest (databases and storage) shall be encrypted using platform-native encryption.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  SEC-4: Network controls

- **Problem Statement:**  
  Implement SEC-4 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Network controls.

- **Acceptance Criteria:**  
  - Databases shall not be directly publicly accessible from the internet.
  - Only the web application and authorized backend services shall access the database and storage.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  SEC-5: Secret management

- **Problem Statement:**  
  Implement SEC-5 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Secret management.

- **Acceptance Criteria:**  
  - Secrets (DB passwords, API keys, AI credentials) shall be stored in a secure secret manager (e.g., Key Vault), not in Git.
  - Terraform and CI/CD pipelines shall reference secrets from secure stores.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code
  - Data ingestion and processing
  - AI review and governance layer

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  SEC-6: Input validation & sanitization

- **Problem Statement:**  
  Implement SEC-6 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Input validation & sanitization.

- **Acceptance Criteria:**  
  - User-submitted content (titles, descriptions, HTML, embeds) shall be sanitized to prevent XSS and injection.
  - Embed support shall be restricted to safe patterns (e.g., whitelisted domains).

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  SEC-7: Dependency management

- **Problem Statement:**  
  Implement SEC-7 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Dependency management.

- **Acceptance Criteria:**  
  - The system shall track dependencies and apply security patches regularly.
  - Only vetted CKAN extensions or libraries shall be used.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  SEC-8: Logging & anomaly detection

- **Problem Statement:**  
  Implement SEC-8 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Logging & anomaly detection.

- **Acceptance Criteria:**  
  - Authentication failures, unexpected errors, and unusual submission patterns shall be logged.
  - Alerts shall be configured for suspicious patterns (e.g., spikes in failed logins or AI-detected PII).

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code
  - AI review and governance layer

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  MON-1: Uptime and health checks

- **Problem Statement:**  
  Implement MON-1 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Uptime and health checks.

- **Acceptance Criteria:**  
  - The system shall expose a basic health endpoint and be monitored by an external uptime service.
  - Alerts shall be configured for site unavailability and high error rates (5xx).

- **Dependencies:**  
  - Web portal and API layer
  - Data ingestion and processing
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  MON-2: Resource monitoring

- **Problem Statement:**  
  Implement MON-2 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Resource monitoring.

- **Acceptance Criteria:**  
  - CPU, memory, disk usage, and database health shall be monitored.
  - Alerts shall be configured for threshold breaches that risk downtime or data loss.

- **Dependencies:**  
  - Web portal and API layer
  - Data ingestion and processing
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  MON-3: Centralized logging

- **Problem Statement:**  
  Implement MON-3 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Centralized logging.

- **Acceptance Criteria:**  
  - Application logs (portal, API) and system logs (web server, DB) shall be centralized in a logging system for analysis and incident response.

- **Dependencies:**  
  - Web portal and API layer
  - Data ingestion and processing
  - Storage layer
  - AI review and governance layer

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  DR-1: Regular backups

- **Problem Statement:**  
  Implement DR-1 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Regular backups.

- **Acceptance Criteria:**  
  - Databases shall be backed up regularly (e.g., nightly), with retention appropriate for reconstruction and audit.
  - Backups shall be stored in a separate, secure storage location.
  - At least 30 days of backups shall be retained.

- **Dependencies:**  
  - Storage layer
  - Infrastructure-as-code
  - AI review and governance layer

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  DR-2: Restore testing

- **Problem Statement:**  
  Implement DR-2 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Restore testing.

- **Acceptance Criteria:**  
  - Procedures to restore from backup shall be documented and tested at least quarterly.

- **Dependencies:**  
  - Storage layer
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  DR-3: Infrastructure rebuild

- **Problem Statement:**  
  Implement DR-3 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Infrastructure rebuild.

- **Acceptance Criteria:**  
  - Terraform definitions shall support recreating the infrastructure in staging and production from scratch if needed.

- **Dependencies:**  
  - Storage layer
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  INF-1: Terraform-managed resources

- **Problem Statement:**  
  Implement INF-1 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Terraform-managed resources.

- **Acceptance Criteria:**  
  - Core infrastructure (compute, networking, storage, database, monitoring) shall be defined in Terraform.
  - Both staging and production environments shall be defined using Terraform with environment-specific variables.

- **Dependencies:**  
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  INF-2: Git-based workflows

- **Problem Statement:**  
  Implement INF-2 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Git-based workflows.

- **Acceptance Criteria:**  
  - Infrastructure configuration shall be stored in Git.
  - Changes shall go through pull requests and review before being applied.
  - Volunteers shall be able to edit Terraform files and submit changes under review.

- **Dependencies:**  
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  INF-3: Automated deployment

- **Problem Statement:**  
  Implement INF-3 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Automated deployment.

- **Acceptance Criteria:**  
  - The system shall support automated deployment workflows for applying Terraform changes and deploying application updates.
  - Staging deployments shall be tested before promoting to production.

- **Dependencies:**  
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  INF-3A: Data pipeline configuration in GitHub

- **Problem Statement:**  
  Implement INF-3A as specified in the SRS.

- **User Stories:**  
  - As a user, I can Data pipeline configuration in GitHub.

- **Acceptance Criteria:**  
  - Azure Data Factory (ADF) pipeline configurations (pipelines, datasets, linked services, triggers, and related artifacts) shall be stored in a GitHub repository using ADF Git integration.
  - GitHub shall be the source of truth for ADF pipeline configurations; changes shall be made in Git and promoted via pull requests and review before being published/deployed to ADF environments.

- **Dependencies:**  
  - Infrastructure-as-code
  - Data ingestion and processing

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  INF-4: Local environment parity

- **Problem Statement:**  
  Implement INF-4 as specified in the SRS.

- **User Stories:**  
  - As a developer, I can Local environment parity.

- **Acceptance Criteria:**  
  - Developers shall be able to run a local stack (portal + DB + minimal storage) with a small sample dataset and mocked or configurable AI review endpoints.
  - Documentation shall exist for setup, running tests, and contributing via Git.

- **Dependencies:**  
  - Infrastructure-as-code
  - AI review and governance layer

- **Target Repository:**  
  opencourts-infra

- **Labels:**  
  ["infra", "feature"]

- **Priority:**  
  High


### SDD Entry
- **Feature Name:**  
  NFR-1: Availability

- **Problem Statement:**  
  Implement NFR-1 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Availability.

- **Acceptance Criteria:**  
  - Target availability for the public portal: 99%+ (no strict SLA, but practical reliability).

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  NFR-2: Performance

- **Problem Statement:**  
  Implement NFR-2 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Performance.

- **Acceptance Criteria:**  
  - Typical dataset search and page loads shall complete within a few seconds under normal load.
  - CSV/JSON API responses shall be reasonably responsive for moderate dataset sizes (tens to hundreds of thousands of rows).

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  NFR-3: Usability

- **Problem Statement:**  
  Implement NFR-3 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Usability.

- **Acceptance Criteria:**  
  - The UI shall be accessible and usable by non-technical users.
  - Data catalog and documentation shall be understandable by journalists and policymakers without technical training.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code
  - AI review and governance layer

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  NFR-4: Accessibility

- **Problem Statement:**  
  Implement NFR-4 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Accessibility.

- **Acceptance Criteria:**  
  - The site shall follow accessibility best practices (e.g., WCAG-inspired) where feasible.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  NFR-5: Transparency & trust

- **Problem Statement:**  
  Implement NFR-5 as specified in the SRS.

- **User Stories:**  
  - As a user, I can Transparency & trust.

- **Acceptance Criteria:**  
  - The system shall prioritize clear messaging on data sources, limitations and caveats, and review and governance processes.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code

- **Target Repository:**  
  opencourts-ckan

- **Labels:**  
  ["backend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  NFR-6: Court Record Custody and Source Preservation Policy

- **Problem Statement:**  
  Implement NFR-6 as specified in the SRS.

- **User Stories:**  
  - As an AI agent, I can Court Record Custody and Source Preservation Policy.

- **Acceptance Criteria:**  
  - The system shall distinguish between (a) records stored in Azure Blob Storage (copied/preserved artifacts) and (b) records referenced via external URLs (link-only resources), and shall expose this distinction in dataset/resource metadata.
  - When the platform performs or publishes derivative works, analytics products, versioned datasets, or long-term citations that depend on a source file, the system shall copy the source file into Azure Blob Storage and treat that copy as the preserved input artifact for reproducibility.
  - When the platform is acting solely as a discovery/catalog layer (i.e., no derivatives, analytics, versioning, or long-term citation requirements), the system shall link to the original court-hosted file(s) rather than copying them.
  - For every copied/preserved file in Azure Blob Storage, the system shall support provenance tracking, hashing, and versioning at minimum including: original source URL, retrieval timestamp, cryptographic hash (e.g., SHA-256), size, content type, and a version identifier that links derivatives back to the specific preserved source artifact.
  - The system shall apply this policy uniformly across all court types and all record formats supported by the portal (e.g., CSV, JSON, PDF, HTML, images, and other downloadable artifacts).
  - The system shall document the custody decision for each dataset and each resource as metadata (e.g., custody_mode = link_only | copied_to_blob, with associated fields such as external_url and/or blob_uri, plus a rationale/category such as discovery_only | derivative_required | analytics_required | versioning_required | long_term_citation_required).
  - The system shall make this policy enforceable and auditable by ensuring (a) custody metadata is required at publish time, (b) custody decisions and changes are logged with actor and timestamp, and (c) maintainers can generate an audit report enumerating all datasets/resources and their custody mode, hashes (for copied files), and version lineage.
  - The implementation shall align with cost-effective, volunteer-operated infrastructure by minimizing unnecessary copying, enabling retention/lifecycle controls for preserved artifacts, and supporting link-only operation where appropriate without sacrificing provenance transparency.

- **Dependencies:**  
  - Web portal and API layer
  - Storage layer
  - Infrastructure-as-code
  - AI review and governance layer

- **Target Repository:**  
  opencourts-etl

- **Labels:**  
  ["frontend", "feature"]

- **Priority:**  
  Medium


### SDD Entry
- **Feature Name:**  
  Nice to Have: MCP tools to manage and query the data resources.

- **Problem Statement:**  
  Implement the Nice to Have item as described in the SRS.

- **User Stories:**  
  - As an AI agent, I can MCP tools to manage and query the data resources.

- **Acceptance Criteria:**  
  - MCP tools to manage and query the data resources.

- **Dependencies:**  
  - Web portal and API layer

- **Target Repository:**  
  opencourts-governance

- **Labels:**  
  ["documentation"]

- **Priority:**  
  Low
