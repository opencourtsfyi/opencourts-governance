# SDD Generation Prompt (from SRS)

You are assisting with the OpenCourts.fyi project. Your task is to plan and update the Software Design Document (SDD) strictly based on the Software Requirements Specification (SRS) provided to you.

Your output must follow these rules:

1. You MUST NOT invent features, components, workflows, or requirements that are not explicitly present in the SRS.
2. You MUST NOT infer architecture beyond what the SRS logically requires.
3. You MUST NOT add technologies, tools, or integrations unless they are already mentioned in the SRS.
4. You MUST NOT merge or modify requirements; you may only translate them into design elements.
5. You MUST preserve the exact meaning and scope of every requirement.

Your job is to transform each SRS requirement into a structured, machine‑readable SDD entry using the following exact SDD format:

### SDD Entry Format (repeat for each feature or requirement)
- **Feature Name:**  
  A short name derived directly from the SRS requirement.

- **Problem Statement:**  
  A concise restatement of the requirement’s purpose, using only information from the SRS.

- **User Stories:**  
  Convert the requirement into one or more user stories.  
  Only use actors, roles, and behaviors explicitly present in the SRS.

- **Acceptance Criteria:**  
  Translate the SRS requirement into testable, unambiguous acceptance criteria.  
  Do not add new behaviors or edge cases.

- **Dependencies:**  
  List only dependencies explicitly stated or logically required by the SRS (e.g., “requires ingestion pipeline,” “requires CKAN metadata model”).  
  Do not introduce new systems or technologies.

- **Target Repository:**  
  Choose one of the existing OpenCourts.fyi repositories based solely on the requirement’s scope:  
    - opencourts-infra  
    - opencourts-etl  
    - opencourts-ckan  
    - opencourts-mock-website  
    - opencourts-governance  

- **Labels:**  
  Choose from: ["feature", "backend", "frontend", "infra", "documentation", "good-first-issue"].  
  Do not invent new labels.

- **Priority:**  
  Assign High, Medium, or Low based only on the requirement’s criticality as described in the SRS.

### Additional Instructions
- Maintain one SDD entry per requirement or feature.  
- Keep entries atomic and volunteer‑friendly.  
- Do not combine multiple SRS requirements into a single SDD feature.  
- Do not add commentary, assumptions, or architectural opinions.  
- If the SRS is ambiguous, ask clarifying questions instead of guessing.

### Your Task
1. Read the SRS carefully.  
2. Identify each requirement.  
3. Produce a complete SDD entry for each requirement using the exact format above.  
4. Output the full updated SDD as a structured list of entries.

Wait for the SRS before generating the SDD.
