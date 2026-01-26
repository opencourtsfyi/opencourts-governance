# Repo Routing Rules (OpenCourts.fyi)

## 🎯 Purpose

The goal of these routing rules is to:

- Ensure every SDD entry maps deterministically to a single repository
- Prevent AI from guessing or inventing repositories
- Keep tasks small, atomic, and aligned with the architecture
- Maintain a clean separation of concerns across the OpenCourts.fyi ecosystem

These rules apply to all automated or semi‑automated issue generation workflows.

## 🗂️ OpenCourts.fyi Repositories and Their Scopes

### 1. opencourts-infra

**Scope:**
Infrastructure, cloud resources, CI/CD, deployment automation, environment configuration, secrets management, monitoring, logging, and IaC.

**Route issues here when the SDD feature involves:**

- Azure, AWS, or cloud provisioning
- Terraform, Bicep, Pulumi, or IaC modules
- CI/CD pipelines
- Containerization, orchestration, or runtime environments
- Infrastructure security or networking
- Observability (metrics, logs, alerts)

### 2. opencourts-etl

**Scope:**
Data ingestion, parsing, normalization, validation, lineage, and pipeline orchestration.

**Route issues here when the SDD feature involves:**

- Court data ingestion
- Scrapers, loaders, or extractors
- Data cleaning, transformation, or validation
- Schema mapping
- Pipeline scheduling or orchestration
- Error handling or retry logic
- Data lineage or provenance

### 3. opencourts-ckan

**Scope:**
Metadata publication, CKAN extensions, dataset schemas, API exposure, and search/discovery.

**Route issues here when the SDD feature involves:**

- CKAN plugin development
- Metadata models or dataset schemas
- CKAN API endpoints
- Dataset publishing workflows
- Search, filtering, or faceted navigation
- CKAN theming or UI extensions
- Permissions or dataset access rules

### 4. opencourts-mock-website

**Scope:**
Frontend prototypes, UI/UX, public‑facing pages, and user interaction flows.

**Route issues here when the SDD feature involves:**

- HTML/CSS/JS prototypes
- React/Vue/Svelte components
- Mockups or wireframes
- User interaction flows
- Public‑facing pages
- Accessibility or responsive design
- Frontend-only logic

### 5. opencourts-governance

**Scope:**
Documentation, policies, charters, SRS/SDD, ADRs, governance workflows, and automation prompts.

**Route issues here when the SDD feature involves:**

- Updating the SRS or SDD
- Creating or modifying ADRs
- Governance processes
- Contribution guidelines
- AI prompts, automation scripts, or GitHub Actions
- Documentation improvements
- Volunteer onboarding materials

## 🧭 Routing Decision Tree

Use this decision tree to determine the correct repository:

Does the task involve infrastructure, cloud, CI/CD, or IaC?
→ Route to opencourts-infra

Does the task involve data ingestion, parsing, validation, or pipelines?
→ Route to opencourts-etl

Does the task involve CKAN, metadata, datasets, or publication?
→ Route to opencourts-ckan

Does the task involve frontend UI/UX or public‑facing pages?
→ Route to opencourts-mock-website

Does the task involve governance, documentation, or automation?
→ Route to opencourts-governance

If none of the above apply:
→ Ask for clarification. Do not guess.

## 🧩 Rules for AI Systems Using This Document

AI systems generating GitHub issues MUST:

- Use the Target Repository field from the SDD when present
- If missing, apply the decision tree above
- Never invent new repositories
- Never route to multiple repositories
- Never infer architecture beyond what the SDD states
- Ask clarifying questions when routing is ambiguous

## 📌 Examples

**Example 1**
SDD Feature: “Normalize county docket CSVs into unified schema”
→ opencourts-etl

**Example 2**
SDD Feature: “Provision Azure Storage for raw ingestion”
→ opencourts-infra

**Example 3**
SDD Feature: “Expose dataset metadata via CKAN API”
→ opencourts-ckan

**Example 4**
SDD Feature: “Add volunteer onboarding documentation”
→ opencourts-governance

**Example 5**
SDD Feature: “Create prototype search UI for court cases”
→ opencourts-mock-website
