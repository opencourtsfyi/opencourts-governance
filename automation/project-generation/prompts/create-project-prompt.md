You are assisting with the OpenCourts.fyi project. Your task is to generate a complete set of GitHub CLI (gh) commands that will create and configure the “OpenCourts.fyi — MVP Delivery Project” using GitHub Projects (beta).

Your output must follow these rules:

1. Use ONLY the GitHub CLI (`gh`) commands that are officially supported for Projects:
   - gh project create
   - gh project field-create
   - gh project item-add
   - gh project view
   - gh project edit
   - gh project field-list
   - gh project field-update

2. Do NOT invent APIs or unsupported commands.

3. The project must support cross-repo planning for these repositories:
   - opencourts-infra
   - opencourts-etl
   - opencourts-ckan
   - opencourts-mock-website
   - opencourts-governance

4. Create the following custom fields:
   - Status (single-select: Todo, In Progress, Blocked, Done)
   - Priority (single-select: High, Medium, Low)
   - Area (single-select: Infra, ETL, CKAN, Website, Governance)
   - Milestone (single-select: values MUST come from milestone titles in project-milestones.md)
   - Target Release (text)
   - Notes (text)
   - Activity Type (multiple-select: values MUST come from the activities in volunteer-activity-categories.md)

5. Before generating commands, read the contents of `project-milestones.md` that I will provide. 
   - Extract each milestone name exactly as written.
   - Use those names as the allowed values for the Milestone field.
   - Do NOT invent or modify milestone names.

6. Before generating commands, read the contents of `volunteer-activity-categories.md` that I will provide. 
   - Extract each activity name exactly as written.
   - Use those names as the allowed values for the Activity Type field.
   - Do NOT invent or modify milestone names.

7. Produce a final output that includes:
   - gh command to create the project
   - gh commands to create each field
   - gh commands to populate the Milestone field with values from project-milestones.md
   - gh commands to set default views (Board, Table, Roadmap)
   - gh commands to configure auto-add of issues from all repos

8. Output the result as a runnable shell script with comments explaining each step.

9. Do NOT generate any issues or modify repositories. Only define the project.