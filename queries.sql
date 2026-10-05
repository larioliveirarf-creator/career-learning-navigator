-- Add the selected careers and their descriptions
INSERT INTO "careers" ("id", "name", "description")
VALUES (1, "Data Analyst", "Collects, cleans and analyzes data to answer business questions, and communicates insights through reports, dashboards and data storytelling" ),
       (2, "Analytics Engineer", "Bridges data engineering and analysis: transforms raw data into clean, tested and documented models (typically with SQL and dbt) that are ready for analysis"),
       (3, "Data Engineer", "Designs, builds and maintains the infrastructure and pipelines that ingest, store and process data reliably and at scale");

-- Import skills from a CSV file using the SQLite terminal
-- .import --csv --skip 1 skill.csv skills

-- Import learning resources from a CSV file using the SQLite terminal
-- .import --csv --skip 1 learning_resources.csv learning_resources

-- Import career–skill associations from a CSV file using the SQLite terminal
-- .import --csv --skip 1 career_skills.csv career_skills

-- Import resource–skill associations from a CSV file using the SQLite terminal
-- .import --csv --skip 1 resource_skills.csv resource_skills

-- Import career–resource associations from a CSV file using the SQLite terminal
-- .import --csv --skip 1 career_resources.csv career_resources

-- Scenario 1: If I already know Excel and SQL, which other skills associated with the Data Analyst role would I need to develop and which resources are suggested for studying them?
SELECT "skill", "resource_title", "url"
FROM "career_learning_paths"
WHERE "career" = 'Data Analyst'
      AND "skill" <> 'Excel'
      AND "skill" <> 'SQL';

-- Example queries demonstrating how to use the database in different scenarios
-- Scenario 2: If I have the skills listed for Data Analyst and want to explore a career in data engineering, which additional skills should I consider studying?
SELECT "skills"."name" FROM "skills"
JOIN "career_skills"
     ON "skills"."id" = "career_skills"."skill_id"
WHERE "career_skills"."career_id" IN (
         SELECT "id" FROM "careers"
         WHERE "name" = 'Data Engineer'
)

EXCEPT

SELECT "skills"."name" FROM "skills"
JOIN "career_skills"
     ON "skills"."id" = "career_skills"."skill_id"
WHERE "career_skills"."career_id" IN (
         SELECT "id" FROM "careers"
         WHERE "name" = 'Data Analyst'
);

-- Scenario 3: Which skills are associated with both the Data Engineer and Analytics Engineer roles?
SELECT "skills"."name" FROM "skills"
JOIN "career_skills"
     ON "skills"."id" = "career_skills"."skill_id"
WHERE "career_skills"."career_id" IN (
         SELECT "id" FROM "careers"
         WHERE "name" = 'Analytics Engineer'
)

INTERSECT

SELECT "skills"."name" FROM "skills"
JOIN "career_skills"
     ON "skills"."id" = "career_skills"."skill_id"
WHERE "career_skills"."career_id" IN (
         SELECT "id" FROM "careers"
         WHERE "name" = 'Data Engineer'
);


-- Scenario 4: Which resources address the most skills in this database??
SELECT
    "learning_resources"."title" AS "resources",
    COUNT(DISTINCT "resource_skills"."skill_id") AS "skills_addressed"
FROM "learning_resources"
JOIN "resource_skills"
    ON "learning_resources"."id" = "resource_skills"."learning_resources_id"
GROUP BY "learning_resources"."id"
ORDER BY "skills_addressed" DESC;

-- Scenario 5:
-- 5.1: Which resource addresses the most skills associated with the Data Analyst career?
SELECT "resource_title",
    COUNT(DISTINCT "skill") AS "skills_addressed"
FROM "career_learning_paths"
WHERE "career" = 'Data Analyst'
GROUP BY "resource_title"
ORDER BY "skills_addressed" DESC
LIMIT 1;

-- 5.2: For the selected career which skills does this resource address?
--      Sort the results alphabetically by skill.
SELECT DISTINCT "skill"
FROM "career_learning_paths"
WHERE "career" = 'Data Analyst'
  AND "resource_title" = 'Data Analytics Career Track'
ORDER BY "skill";
