# Design Document

By Larissa Rodrigues Ferreira de Oliveira

Video overview: [Career Learning Navigator](https://youtu.be/CAVm4_W6eQo)

## Scope

When exploring a new career, people may not know which skills to study first or where to find learning resources. This CS50 SQL database helps users build an initial learning path for three data careers: Data Analyst, Analytics Engineer, and Data Engineer. It presents a sample of introductory skills, suggests resources that address them, and indicates whether access to each resource is free or paid.

#### Included in the database’s scope are:

* Three careers (Data Analyst, Analytics Engineer, and Data Engineer) and a brief description of each;
* A selected sample of skills associated with each career;
* Learning resources, including their title, provider, type, page URL, and access cost;
* The relationships between careers and skills, resources and skills, and careers and suggested resources;

Out of scope are user accounts, personal information, stored skill profiles, and information about certificates. Users may specify skills they already know when running example queries, but the database does not store or assess their profiles.

## Functional Requirements

This database will support:

* Adding and updating careers, skills, learning resources, and the associations between them.
* Listing the skills associated with a selected career.
* Comparing the skills associated with two careers to identify overlaps and differences.
* Finding learning resources that address a selected skill and are recommended for a selected career.
* Identifying skills a person may want to study by excluding skills they say they already have from a career’s skill list.

## Representation

The database is implemented using SQLite and includes six tables, as described below.

### Entities

The database includes the following entities:

#### Careers

The `careers` table includes:

* `id`, an `INTEGER` that uniquely identifies each career and serves as the primary key.
* `name`, the career name, stored as `TEXT`. It must be unique and cannot be null.
* `description`, a brief description of the career, stored as `TEXT`. It cannot be null.

#### Skills

The `skills` table includes:

* `id`, an `INTEGER` that uniquely identifies each skill and serves as the primary key.
* `name`, the skill name, stored as `TEXT`. It must be unique and cannot be null.

#### Learning Resources

The `learning_resources` table includes:

* `id`, an `INTEGER` that uniquely identifies each resource and serves as the primary key.
* `title`, the resource title, stored as `TEXT`. It cannot be null.
* `provider`, the organization or person providing the resource, stored as `TEXT`. It cannot be null.
* `resource_type`, the type of resource, such as a course or tutorial, stored as `TEXT`.
* `url`, a link to the resource, stored as `TEXT`. It cannot be null.
* `access_cost`, whether access to the resource is free or paid, stored as `TEXT`. It cannot be null.

#### Career Skills

The `career_skills` table associates skills with careers. It includes:

* `id`, an `INTEGER` that uniquely identifies each association and serves as the primary key.
* `career_id`, an `INTEGER` that references `careers.id` and cannot be null.
* `skill_id`, an `INTEGER` that references `skills.id` and cannot be null.

#### Resource Skills

The `resource_skills` table associates learning resources with the skills they address. It includes:

* `id`, an `INTEGER` that uniquely identifies each association and serves as the primary key.
* `learning_resources_id`, an `INTEGER` that references `learning_resources.id` and cannot be null.
* `skill_id`, an `INTEGER` that references `skills.id` and cannot be null.

#### Career Resources

The `career_resources` table records which learning resources have been selected for each career. It includes:

* `id`, an `INTEGER` that uniquely identifies each association and serves as the primary key.
* `career_id`, an `INTEGER` that references `careers.id` and cannot be null.
* `learning_resources_id`, an `INTEGER` that references `learning_resources.id` and cannot be null.

### Relationships

The database includes three main entities: careers, skills, and learning resources. They are connected through three association tables:

* Careers and Skills: Each career can have multiple associated skills, and each skill can be associated with multiple careers. These relationships are recorded in career_skills.
* Learning Resources and Skills: Each resource can address multiple skills, and each skill can be addressed by multiple resources. These relationships are recorded in resource_skills.
* Careers and Learning Resources: Each career can have multiple suggested resources, and each resource can be selected for multiple careers. These relationships are recorded in career_resources.

The main entities have many-to-many relationships, represented by the association tables. These tables use foreign keys to link related records. Each main entity has a one-to-many relationship with its corresponding association tables.

![ER Diagram](image.png)

## Optimizations

#### Indexes
The queries in queries.sql frequently retrieve skills and learning resources associated with a particular career. Composite unique indexes are created on `career_skills` (career_id, skill_id), `resource_skills` (learning_resources_id, skill_id), and `career_resources` (career_id, learning_resources_id) to support these lookups and joins. These indexes also ensure that each pair of related records appears only once.
#### View
The `career_learning_paths` view brings together careers, skills, and the learning resources selected for each career. It makes the queries that display this information easier to write and read.

## Limitations

#### Skills
* The skills included in this project are a sample. Other skills may be relevant to Data Analyst, Analytics Engineer, and Data Engineer roles, and requirements vary between employers.
* Users identify the skills they believe they already have and use that information when running queries. The database does not assess proficiency or store user profiles. Results depend on the skills users report and the career–skill associations recorded in the database.
#### Learning Resources
* The database contains a sample of available learning resources, not a complete catalog.
* Resource–skill associations are based on the content described by providers. They do not indicate the depth of coverage or guarantee proficiency.
* Degree programs, such as associate and bachelor’s degrees, are outside the scope of this project.
#### Cost
* The Free and Paid categories describe access to learning materials.They do not necessarily indicate whether a certificate is included. Access terms may change, so users should verify current details with the course provider.
#### Collaboration
* The database structure can accommodate additional careers and learning resources, but this version does not provide an interface for users to submit contributions or a process for reviewing them.
