-- Designing tables
-- 1 - Careers included in the learning navigator
CREATE TABLE "careers" (
    "id" INTEGER,
    "name" TEXT UNIQUE NOT NULL,
    "description" TEXT NOT NULL,
    PRIMARY KEY ("id")
    );

-- 2 - Skills included in the database
CREATE TABLE "skills" (
    "id" INTEGER,
    "name" TEXT UNIQUE NOT NULL,
    PRIMARY KEY ("id")
);

-- 3 - Learning resources, such as courses, tutorials, and videos
CREATE TABLE "learning_resources" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "resource_type" TEXT,
    "url" TEXT NOT NULL,
    "access_cost" TEXT NOT NULL,
    PRIMARY KEY ("id")
 );

-- 4 - Skills associated with each career
CREATE TABLE "career_skills" (
    "id" INTEGER,
    "career_id" INTEGER NOT NULL,
    "skill_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("career_id") REFERENCES "careers" ("id"),
    FOREIGN KEY ("skill_id") REFERENCES "skills" ("id")
);

-- 5 - Skills addressed by each learning resource
CREATE TABLE "resource_skills" (
    "id" INTEGER,
    "learning_resources_id" INTEGER NOT NULL,
    "skill_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("learning_resources_id") REFERENCES "learning_resources" ("id"),
    FOREIGN KEY ("skill_id") REFERENCES "skills" ("id")
);

-- 6 - Learning resources selected for each career
 CREATE TABLE "career_resources" (
    "id" INTEGER,
    "career_id" INTEGER NOT NULL,
    "learning_resources_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("career_id") REFERENCES "careers" ("id"),
    FOREIGN KEY ("learning_resources_id") REFERENCES "learning_resources" ("id")
);

-- Creating a view
-- Big picture of career -> skill -> indicated resource
CREATE VIEW "career_learning_paths" AS
SELECT
    "careers"."name" AS "career",
    "skills"."name" AS "skill",
    "learning_resources"."title" AS "resource_title",
    "learning_resources"."access_cost" AS "access_cost",
    "learning_resources"."url" AS "url"
FROM "careers"
JOIN "career_skills"
    ON "careers"."id" = "career_skills"."career_id"
JOIN "skills"
    ON "career_skills"."skill_id" = "skills"."id"
JOIN "resource_skills"
    ON "skills"."id" = "resource_skills"."skill_id"
JOIN "learning_resources"
    ON "resource_skills"."learning_resources_id" = "learning_resources"."id"
JOIN "career_resources"
    ON "careers"."id" = "career_resources"."career_id"
    AND "learning_resources"."id" = "career_resources"."learning_resources_id";

-- Optimizations

CREATE UNIQUE INDEX "unique_career_skill"
ON "career_skills" ("career_id", "skill_id");

CREATE UNIQUE INDEX "unique_resource_skill"
ON "resource_skills" ("learning_resources_id", "skill_id");

CREATE UNIQUE INDEX "unique_career_resource"
ON "career_resources" ("career_id", "learning_resources_id");

