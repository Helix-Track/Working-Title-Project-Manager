/*
    Version: 1
*/

/*
    Notes:

    - TODOs: https://github.com/orgs/red-elf/projects/2/views/1
    - Identifiers in the system are UUID strings.
    - Mapping tables are used for binding entities and defining relationships.
        Mapping tables are used as well to append properties to the entities.
*/

DROP TABLE IF EXISTS system_info;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS ticket_types;
DROP TABLE IF EXISTS ticket_statuses;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS ticket_relationship_types;
DROP TABLE IF EXISTS boards;
DROP TABLE IF EXISTS workflows;
DROP TABLE IF EXISTS assets;
DROP TABLE IF EXISTS labels;
DROP TABLE IF EXISTS label_categories;
DROP TABLE IF EXISTS repositories;
DROP TABLE IF EXISTS components;
DROP TABLE IF EXISTS organizations;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS permission_contexts;
DROP TABLE IF EXISTS workflow_steps;
DROP TABLE IF EXISTS audit;
DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS cycles;
DROP TABLE IF EXISTS extensions;
DROP TABLE IF EXISTS users_yandex_mappings;
DROP TABLE IF EXISTS users_google_mappings;
DROP TABLE IF EXISTS user_organization_mappings;
DROP TABLE IF EXISTS user_team_mappings;
DROP TABLE IF EXISTS permission_user_mappings;
DROP TABLE IF EXISTS project_organization_mappings;
DROP TABLE IF EXISTS ticket_relationships;
DROP TABLE IF EXISTS ticket_type_project_mappings;
DROP TABLE IF EXISTS audit_meta_data;
DROP TABLE IF EXISTS reports_meta_data;
DROP TABLE IF EXISTS boards_meta_data;
DROP TABLE IF EXISTS tickets_meta_data;
DROP TABLE IF EXISTS team_organization_mappings;
DROP TABLE IF EXISTS team_project_mappings;
DROP TABLE IF EXISTS repository_project_mappings;
DROP TABLE IF EXISTS repository_commit_ticket_mappings;
DROP TABLE IF EXISTS component_ticket_mappings;
DROP TABLE IF EXISTS components_meta_data;
DROP TABLE IF EXISTS asset_project_mappings;
DROP TABLE IF EXISTS asset_team_mappings;
DROP TABLE IF EXISTS asset_ticket_mappings;
DROP TABLE IF EXISTS asset_comment_mappings;
DROP TABLE IF EXISTS label_label_category_mappings;
DROP TABLE IF EXISTS label_project_mappings;
DROP TABLE IF EXISTS label_team_mappings;
DROP TABLE IF EXISTS label_ticket_mappings;
DROP TABLE IF EXISTS label_asset_mappings;
DROP TABLE IF EXISTS comment_ticket_mappings;
DROP TABLE IF EXISTS ticket_project_mappings;
DROP TABLE IF EXISTS cycle_project_mappings;
DROP TABLE IF EXISTS ticket_cycle_mappings;
DROP TABLE IF EXISTS ticket_board_mappings;
DROP TABLE IF EXISTS permission_team_mappings;
DROP TABLE IF EXISTS configuration_data_extension_mappings;
DROP TABLE IF EXISTS extensions_meta_data;

DROP INDEX IF EXISTS system_info_get_by_created;
DROP INDEX IF EXISTS system_info_get_by_description;
DROP INDEX IF EXISTS system_info_get_by_created_and_description;
DROP INDEX IF EXISTS users_get_by_created;
DROP INDEX IF EXISTS users_get_by_modified;
DROP INDEX IF EXISTS users_get_by_deleted;
DROP INDEX IF EXISTS users_get_by_created_and_modified;
DROP INDEX IF EXISTS projects_get_by_title;
DROP INDEX IF EXISTS projects_get_by_description;
DROP INDEX IF EXISTS projects_get_by_title_and_description;
DROP INDEX IF EXISTS projects_get_by_created;
DROP INDEX IF EXISTS projects_get_by_modified;
DROP INDEX IF EXISTS projects_get_by_created_and_modified;
DROP INDEX IF EXISTS projects_get_by_deleted;
DROP INDEX IF EXISTS projects_get_by_identifier;
DROP INDEX IF EXISTS projects_get_by_workflow_id;
DROP INDEX IF EXISTS ticket_types_get_by_title;
DROP INDEX IF EXISTS ticket_types_get_by_description;
DROP INDEX IF EXISTS ticket_types_get_by_title_and_description;
DROP INDEX IF EXISTS ticket_types_get_by_created;
DROP INDEX IF EXISTS ticket_types_get_by_modified;
DROP INDEX IF EXISTS ticket_types_get_by_deleted;
DROP INDEX IF EXISTS ticket_types_get_by_created_and_modified;
DROP INDEX IF EXISTS ticket_statuses_get_by_title;
DROP INDEX IF EXISTS ticket_statuses_get_by_description;
DROP INDEX IF EXISTS ticket_statuses_get_by_title_and_description;
DROP INDEX IF EXISTS ticket_statuses_get_by_deleted;
DROP INDEX IF EXISTS ticket_statuses_get_by_created;
DROP INDEX IF EXISTS ticket_statuses_get_by_modified;
DROP INDEX IF EXISTS ticket_statuses_get_by_created_and_modified;

/*
  Identifies the version of the database (system).
  After each SQL script execution the version will be increased and execution description provided.
*/
CREATE TABLE system_info
(

    id          INTEGER PRIMARY KEY UNIQUE,
    description TEXT    NOT NULL,
    created     INTEGER NOT NULL
);

CREATE INDEX system_info_get_by_created ON system_info (created);
CREATE INDEX system_info_get_by_description ON system_info (description);
CREATE INDEX system_info_get_by_created_and_description ON system_info (created, description);

/*
    The system entities:
*/

/*
     System's users.
     User is identified by the unique identifier (id).
     Since there may be different types of users, different kinds of data
     can be mapped (associated) with the user ID.
     For that purpose there are other mappings to the user ID such as Yandex OAuth2 mappings for example.
*/
CREATE TABLE users
(

    id       TEXT    NOT NULL PRIMARY KEY UNIQUE,
    created  INTEGER NOT NULL,
    modified INTEGER NOT NULL,
    deleted  BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

CREATE INDEX users_get_by_created ON users (created);
CREATE INDEX users_get_by_modified ON users (modified);
CREATE INDEX users_get_by_deleted ON users (deleted);
CREATE INDEX users_get_by_created_and_modified ON users (created, modified);

/*
    The basic project definition.

    Notes:
        - The 'workflow_id' represents the assigned workflow. Workflow is mandatory for the project.
        - The 'identifier' represents the human readable identifier for the project up to 4 characters,
            for example: MSF, KSS, etc.
*/
CREATE TABLE projects
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    identifier  TEXT    NOT NULL UNIQUE,
    title       TEXT    NOT NULL,
    description TEXT,
    workflow_id TEXT    NOT NULL,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1))
);

CREATE INDEX projects_get_by_identifier ON projects (identifier);
CREATE INDEX projects_get_by_title ON projects (title);
CREATE INDEX projects_get_by_description ON projects (description);
CREATE INDEX projects_get_by_title_and_description ON projects (title, description);
CREATE INDEX projects_get_by_workflow_id ON projects (workflow_id);
CREATE INDEX projects_get_by_created ON projects (created);
CREATE INDEX projects_get_by_modified ON projects (modified);
CREATE INDEX projects_get_by_deleted ON projects (deleted);
CREATE INDEX projects_get_by_created_and_modified ON projects (created, modified);

/*
    Ticket type definitions.
*/
CREATE TABLE ticket_types
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT    NOT NULL UNIQUE,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

CREATE INDEX ticket_types_get_by_title ON ticket_types (title);
CREATE INDEX ticket_types_get_by_description ON ticket_types (description);
CREATE INDEX ticket_types_get_by_title_and_description ON ticket_types (title, description);
CREATE INDEX ticket_types_get_by_created ON ticket_types (created);
CREATE INDEX ticket_types_get_by_modified ON ticket_types (modified);
CREATE INDEX ticket_types_get_by_deleted ON ticket_types (deleted);
CREATE INDEX ticket_types_get_by_created_and_modified ON ticket_types (created, modified);

/*
    Ticket statuses.
    For example:
        - To-do
        - Selected for development
        - In progress
        - Completed, etc.
*/
CREATE TABLE ticket_statuses
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT    NOT NULL UNIQUE,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

CREATE INDEX ticket_statuses_get_by_title ON ticket_statuses (title);
CREATE INDEX ticket_statuses_get_by_description ON ticket_statuses (description);
CREATE INDEX ticket_statuses_get_by_title_and_description ON ticket_statuses (title, description);
CREATE INDEX ticket_statuses_get_by_deleted ON ticket_statuses (deleted);
CREATE INDEX ticket_statuses_get_by_created ON ticket_statuses (created);
CREATE INDEX ticket_statuses_get_by_modified ON ticket_statuses (modified);
CREATE INDEX ticket_statuses_get_by_created_and_modified ON ticket_statuses (created, modified);

/*
    Tickets.
    Tickets belong to the project.
    Each ticket has its ticket type anf children if supported.
    The 'estimation' is the estimation value in man days.
    The 'story_points' represent the complexity of the ticket in story points (for example: 1, 3, 5, 8, 13).

    Notes:
        - The 'user_id' is the current owner of the ticket.
            It can be bull - the ticket is unassigned.
        - The 'creator' is the user id of the ticket creator.
        - The ticket number is human readable identifier of the ticket - the whole number.
            The ticket number is unique per project.
            In combination with 'project's 'identifier' field it can give the whole ticket numbers (identifiers),
            for example: MSF-112, BBP-222, etc.
*/
CREATE TABLE tickets
(

    id               TEXT    NOT NULL PRIMARY KEY UNIQUE,
    ticket_number    INTEGER NOT NULL DEFAULT 1,
    title            TEXT,
    description      TEXT,
    created          INTEGER NOT NULL,
    modified         INTEGER NOT NULL,
    ticket_type_id   TEXT    NOT NULL,
    ticket_status_id TEXT    NOT NULL,
    project_id       TEXT    NOT NULL,
    user_id          TEXT,
    estimation       REAL    NOT NULL DEFAULT 0,
    story_points     INTEGER NOT NULL DEFAULT 0,
    creator          TEXT    NOT NULL,
    deleted          BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (ticket_number, project_id) ON CONFLICT ABORT
);

/*
    Ticket relationship types.
    For example:
        - Blocked by
        - Blocks
        - Cloned by
        - Clones, etc.
*/
CREATE TABLE ticket_relationship_types
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
    Ticket boards.
    Tickets belong to the board.
    Ticket may belong or may not belong to certain board. It is not mandatory.

    Boards examples:
        - Backlog
        - Main board
*/
CREATE TABLE boards
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1))
);

/*
    Workflows.
    The workflow represents a ordered set of steps (statuses) for the tickets that are connected to each other.
*/
CREATE TABLE workflows
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1))
);

/*
    Images, attachments, etc.
    Defined by the identifier and the resource url.
*/
CREATE TABLE assets
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    url         TEXT    NOT NULL UNIQUE,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
    Labels.
    Label can be associated with the almost everything:
        - Project
        - Team
        - Ticket
        - Asset
*/
CREATE TABLE labels
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT    NOT NULL UNIQUE,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
    Labels can be divided into categories (which is optional).
*/
CREATE TABLE label_categories
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT    NOT NULL UNIQUE,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
      The code repositories - Identified by the identifier and the repository URL.
      Default repository type is Git repository.
*/
CREATE TABLE repositories
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    repository  TEXT    NOT NULL UNIQUE,
    description TEXT,

    type        TEXT CHECK ( type IN
                             ('Git', 'CVS', 'SVN', 'Mercurial',
                              'Perforce', 'Monotone', 'Bazaar',
                              'TFS', 'VSTS', 'IBM Rational ClearCase',
                              'Revision Control System', 'VSS',
                              'CA Harvest Software Change Manager',
                              'PVCS', 'darcs')
        )               NOT NULL DEFAULT 'Git',

    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1))
);

/*
    Components.
    Components are associated with the tickets.
    For example:
        - Backend
        - Android Client
        - Core Engine
        - Webapp, etc.
*/
CREATE TABLE components
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT    NOT NULL UNIQUE,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
    The organization definition. Organization is the owner of the project.
*/
CREATE TABLE organizations
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT    NOT NULL UNIQUE,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
    The team definition. Organization is the owner of the team.
*/
CREATE TABLE teams
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT    NOT NULL UNIQUE,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
    Permission definitions.
    Permissions are (for example):

        CREATE
        UPDATE
        DELETE
        etc.
*/
CREATE TABLE permissions
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT    NOT NULL UNIQUE,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);


/*
    Comments.
    Users can comment on:
        - Tickets
        - Tbd.
*/
CREATE TABLE comments
(

    id       TEXT    NOT NULL PRIMARY KEY UNIQUE,
    comment  TEXT    NOT NULL,
    created  INTEGER NOT NULL,
    modified INTEGER NOT NULL,
    deleted  BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
    Permission contexts.
    Each permission must assigned to the permission owner must have a valid context.
    Permission contexts are (for example):

        organization.project
        organization.team
*/
CREATE TABLE permission_contexts
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title       TEXT    NOT NULL UNIQUE,
    description TEXT,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
    Workflow steps.
    Steps for the workflow that are linked to each other.

    Notes:
        - The 'workflow_step_id' is the parent step. The root steps (for example: 'to-do') have no parents.
        - The 'ticket_status_id' represents the status (connection with it) that will be assigned to the ticket once
            the ticket gets to the workflow step.
*/
CREATE TABLE workflow_steps
(

    id               TEXT    NOT NULL PRIMARY KEY UNIQUE,
    title            TEXT    NOT NULL UNIQUE,
    description      TEXT,
    workflow_id      TEXT    NOT NULL,
    workflow_step_id TEXT,
    ticket_status_id TEXT    NOT NULL,
    created          INTEGER NOT NULL,
    modified         INTEGER NOT NULL,
    deleted          BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
    Reports, such as:
        - Time tracking reports
        - Progress status(es), etc.
*/
CREATE TABLE reports
(

    id          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    created     INTEGER NOT NULL,
    modified    INTEGER NOT NULL,
    title       TEXT,
    description TEXT,
    deleted     BOOLEAN NOT NULL CHECK (deleted IN (0, 1))
);


/*
    Contains the information about all work cycles in the system.
    Cycle belongs to the project. To only one project.
    Ticket belongs to the cycle. Ticket can belong to the multiple cycles.

    Work cycle types:
        - Release (top cycle category, not mandatory)
        - Milestone (middle cycle category, not mandatory)
        - Sprint (smaller cycle category, not mandatory)

    Milestones may or may not belong to the release.
    Sprints may or may not belong to milestones or releases.
    Releases may or may not have the version associated.
    Each cycle may have different meta data associated.

    Each cycle has the value:
        - Release       = 1000
        - Milestone     = 100
        - Sprint        = 10

    To illustrate its relationship.
    Based on this future custom cycle types could be supported.

    Cycle can belong to only one parent.
    Parent's type integer value mus be > than the type integer value of current cycle (this).
*/
CREATE TABLE cycles
(

    id          TEXT                                     NOT NULL PRIMARY KEY UNIQUE,
    created     INTEGER                                  NOT NULL,
    modified    INTEGER                                  NOT NULL,
    title       TEXT,
    description TEXT,
    /**
      Prent cycle id.
     */
    cycle_id    TEXT                                     NOT NULL UNIQUE,
    type        INTEGER CHECK ( type IN (1000, 100, 10)) NOT NULL,
    deleted     BOOLEAN                                  NOT NULL CHECK (deleted IN (0, 1))
);

/*
  The 3rd party extensions.
  Each extension is identified by the 'extension_key' which is properly verified by the system.
  Extension can be enabled or disabled - the 'enabled' field.
*/
CREATE TABLE extensions
(

    id            TEXT    NOT NULL PRIMARY KEY UNIQUE,
    created       INTEGER NOT NULL,
    modified      INTEGER NOT NULL,
    title         TEXT,
    description   TEXT,
    extension_key TEXT    NOT NULL UNIQUE,
    enabled       BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    deleted       BOOLEAN NOT NULL CHECK (deleted IN (0, 1))
);

/*
    Audit trail.
*/
CREATE TABLE audit
(

    id        TEXT    NOT NULL PRIMARY KEY UNIQUE,
    created   INTEGER NOT NULL,
    entity    TEXT,
    operation TEXT
);

/*
    Mappings:
*/

/*
    Project belongs to the organization. Multiple projects can belong to one organization.
*/
CREATE TABLE project_organization_mappings
(

    id              TEXT    NOT NULL PRIMARY KEY UNIQUE,
    project_id      TEXT    NOT NULL,
    organization_id TEXT    NOT NULL,
    created         INTEGER NOT NULL,
    modified        INTEGER NOT NULL,
    deleted         BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (project_id, organization_id) ON CONFLICT ABORT
);

/*
    Each project has the ticket types that it supports.
*/
CREATE TABLE ticket_type_project_mappings
(

    id             TEXT    NOT NULL PRIMARY KEY UNIQUE,
    ticket_type_id TEXT    NOT NULL,
    project_id     TEXT    NOT NULL,
    created        INTEGER NOT NULL,
    modified       INTEGER NOT NULL,
    deleted        BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (ticket_type_id, project_id) ON CONFLICT ABORT
);

/*
    Audit trail meta-data.
*/
CREATE TABLE audit_meta_data
(

    id       TEXT    NOT NULL PRIMARY KEY UNIQUE,
    audit_id TEXT    NOT NULL,
    property TEXT    NOT NULL,
    value    TEXT,
    created  INTEGER NOT NULL,
    modified INTEGER NOT NULL
);

/*
   Reports met-data: used to populate reports with the information.
*/
CREATE TABLE reports_meta_data
(

    id        TEXT    NOT NULL PRIMARY KEY UNIQUE,
    report_id TEXT    NOT NULL,
    property  TEXT    NOT NULL,
    value     TEXT,
    created   INTEGER NOT NULL,
    modified  INTEGER NOT NULL
);

/*
   Boards meta-data: additional data that can be associated with certain board.
*/
CREATE TABLE boards_meta_data
(

    id       TEXT    NOT NULL PRIMARY KEY UNIQUE,
    board_id TEXT    NOT NULL,
    property TEXT    NOT NULL,
    value    TEXT,
    created  INTEGER NOT NULL,
    modified INTEGER NOT NULL
);

/*
    Tickets meta-data.
*/
CREATE TABLE tickets_meta_data
(

    id        TEXT    NOT NULL PRIMARY KEY UNIQUE,
    ticket_id TEXT    NOT NULL,
    property  TEXT    NOT NULL,
    value     TEXT,
    created   INTEGER NOT NULL,
    modified  INTEGER NOT NULL,
    deleted   BOOLEAN NOT NULL CHECK (deleted IN (0, 1))
);

/*
    All relationships between the tickets.
*/
CREATE TABLE ticket_relationships
(

    id                          TEXT    NOT NULL PRIMARY KEY UNIQUE,
    ticket_relationship_type_id TEXT    NOT NULL,
    ticket_id                   TEXT    NOT NULL,
    child_ticket_id             TEXT    NOT NULL,
    created                     INTEGER NOT NULL,
    modified                    INTEGER NOT NULL,
    deleted                     BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (ticket_id, child_ticket_id) ON CONFLICT ABORT
);

/*
    Team belongs to the organization. Multiple teams can belong to one organization.
*/
CREATE TABLE team_organization_mappings
(

    id              TEXT    NOT NULL PRIMARY KEY UNIQUE,
    team_id         TEXT    NOT NULL,
    organization_id TEXT    NOT NULL,
    created         INTEGER NOT NULL,
    modified        INTEGER NOT NULL,
    deleted         BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (team_id, organization_id) ON CONFLICT ABORT
);

/*
    Team belongs to one or more projects. Multiple teams can work on multiple projects.
*/
CREATE TABLE team_project_mappings
(

    id         TEXT    NOT NULL PRIMARY KEY UNIQUE,
    team_id    TEXT    NOT NULL,
    project_id TEXT    NOT NULL,
    created    INTEGER NOT NULL,
    modified   INTEGER NOT NULL,
    deleted    BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (team_id, project_id) ON CONFLICT ABORT
);

/*
     Repository belongs to project. Multiple repositories can belong to multiple projects.
     So, two projects can actually have the same repository.
*/
CREATE TABLE repository_project_mappings
(

    id            TEXT    NOT NULL PRIMARY KEY UNIQUE,
    repository_id TEXT    NOT NULL,
    project_id    TEXT    NOT NULL,
    created       INTEGER NOT NULL,
    modified      INTEGER NOT NULL,
    deleted       BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (repository_id, project_id) ON CONFLICT ABORT
);

/*
     Mapping all commits to the corresponding tickets
*/
CREATE TABLE repository_commit_ticket_mappings
(

    id            TEXT    NOT NULL PRIMARY KEY UNIQUE,
    repository_id TEXT    NOT NULL,
    ticket_id     TEXT    NOT NULL,
    commit_hash   TEXT    NOT NULL UNIQUE,
    created       INTEGER NOT NULL,
    modified      INTEGER NOT NULL,
    deleted       BOOLEAN NOT NULL CHECK (deleted IN (0, 1))
);

/*
    Components to the tickets mappings.
    Component can be mapped to the multiple tickets.
*/
CREATE TABLE component_ticket_mappings
(

    id           TEXT    NOT NULL PRIMARY KEY UNIQUE,
    component_id TEXT    NOT NULL,
    ticket_id    TEXT    NOT NULL,
    created      INTEGER NOT NULL,
    modified     INTEGER NOT NULL,
    deleted      BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (component_id, ticket_id) ON CONFLICT ABORT
);

/*
    Components meta-data:
    Associate the various information with different components.
*/
CREATE TABLE components_meta_data
(

    id           TEXT    NOT NULL PRIMARY KEY UNIQUE,
    component_id TEXT    NOT NULL,
    property     TEXT    NOT NULL,
    value        TEXT,
    created      INTEGER NOT NULL,
    modified     INTEGER NOT NULL,
    deleted      BOOLEAN NOT NULL CHECK (deleted IN (0, 1))
);

/*
    Assets can belong to the multiple projects.
    One example of the image used in the context of the project is the project's avatar.
    Projects may have various other assets associated to itself.
    Various documentation for example.
*/
CREATE TABLE asset_project_mappings
(

    id         TEXT    NOT NULL PRIMARY KEY UNIQUE,
    asset_id   TEXT    NOT NULL,
    project_id TEXT    NOT NULL,
    created    INTEGER NOT NULL,
    modified   INTEGER NOT NULL,
    deleted    BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (asset_id, project_id) ON CONFLICT ABORT
);

/*
    Assets can belong to the multiple teams.
    The image used in the context of the team is the team's avatar, for example.
    Teams may have other additions associated to itself. Various documents for example,
*/
CREATE TABLE asset_team_mappings
(

    id       TEXT    NOT NULL PRIMARY KEY UNIQUE,
    asset_id TEXT    NOT NULL,
    team_id  TEXT    NOT NULL,
    created  INTEGER NOT NULL,
    modified INTEGER NOT NULL,
    deleted  BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0,
    UNIQUE (asset_id, team_id) ON CONFLICT ABORT
);

/*
    Assets (attachments for example) can belong to the multiple tickets.
*/
CREATE TABLE asset_ticket_mappings
(

    id        TEXT    NOT NULL PRIMARY KEY UNIQUE,
    asset_id  TEXT    NOT NULL,
    ticket_id TEXT    NOT NULL,
    created   INTEGER NOT NULL,
    modified  INTEGER NOT NULL,
    deleted   BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (asset_id, ticket_id) ON CONFLICT ABORT
);

/*
    Assets (attachments for example) can belong to the multiple comments.
*/
CREATE TABLE asset_comment_mappings
(

    id         TEXT    NOT NULL PRIMARY KEY UNIQUE,
    asset_id   TEXT    NOT NULL,
    comment_id TEXT    NOT NULL,
    created    INTEGER NOT NULL,
    modified   INTEGER NOT NULL,
    deleted    BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (asset_id, comment_id) ON CONFLICT ABORT
);

/*
    Labels can belong to the label category.
    One single asset can belong to multiple categories.
*/
CREATE TABLE label_label_category_mappings
(

    id                TEXT    NOT NULL PRIMARY KEY UNIQUE,
    label_id          TEXT    NOT NULL,
    label_category_id TEXT    NOT NULL,
    created           INTEGER NOT NULL,
    modified          INTEGER NOT NULL,
    deleted           BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (label_id, label_category_id) ON CONFLICT ABORT
);

/*
    Label can be associated with one or more projects.
*/
CREATE TABLE label_project_mappings
(

    id         TEXT    NOT NULL PRIMARY KEY UNIQUE,
    label_id   TEXT    NOT NULL,
    project_id TEXT    NOT NULL,
    created    INTEGER NOT NULL,
    modified   INTEGER NOT NULL,
    deleted    BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (label_id, project_id) ON CONFLICT ABORT
);

/*
    Label can be associated with one or more teams.
*/
CREATE TABLE label_team_mappings
(

    id       TEXT    NOT NULL PRIMARY KEY UNIQUE,
    label_id TEXT    NOT NULL,
    team_id  TEXT    NOT NULL,
    created  INTEGER NOT NULL,
    modified INTEGER NOT NULL,
    deleted  BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0,
    UNIQUE (label_id, team_id) ON CONFLICT ABORT
);

/*
    Label can be associated with one or more tickets.
*/
CREATE TABLE label_ticket_mappings
(

    id        TEXT    NOT NULL PRIMARY KEY UNIQUE,
    label_id  TEXT    NOT NULL,
    ticket_id TEXT    NOT NULL,
    created   INTEGER NOT NULL,
    modified  INTEGER NOT NULL,
    deleted   BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (label_id, ticket_id) ON CONFLICT ABORT
);

/*
    Label can be associated with one or more assets.
*/
CREATE TABLE label_asset_mappings
(

    id       TEXT    NOT NULL PRIMARY KEY UNIQUE,
    label_id TEXT    NOT NULL,
    asset_id TEXT    NOT NULL,
    created  INTEGER NOT NULL,
    modified INTEGER NOT NULL,
    deleted  BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0,
    UNIQUE (label_id, asset_id) ON CONFLICT ABORT
);

/*
    Comments are usually associated with project tickets:
*/
CREATE TABLE comment_ticket_mappings
(

    id         TEXT    NOT NULL PRIMARY KEY UNIQUE,
    comment_id TEXT    NOT NULL,
    ticket_id  TEXT    NOT NULL,
    created    INTEGER NOT NULL,
    modified   INTEGER NOT NULL,
    deleted    BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (comment_id, ticket_id) ON CONFLICT ABORT
);

/*
    Tickets belong to the project:
*/
CREATE TABLE ticket_project_mappings
(

    id         TEXT    NOT NULL PRIMARY KEY UNIQUE,
    ticket_id  TEXT    NOT NULL,
    project_id TEXT    NOT NULL,
    created    INTEGER NOT NULL,
    modified   INTEGER NOT NULL,
    deleted    BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (ticket_id, project_id) ON CONFLICT ABORT
);

/*
    Cycles belong to the projects.
    Cycle can belong to exactly one project.
*/
CREATE TABLE cycle_project_mappings
(

    id         TEXT    NOT NULL PRIMARY KEY UNIQUE,
    cycle_id   TEXT    NOT NULL UNIQUE,
    project_id TEXT    NOT NULL,
    created    INTEGER NOT NULL,
    modified   INTEGER NOT NULL,
    deleted    BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (cycle_id, project_id) ON CONFLICT ABORT
);

/*
    Tickets can belong to cycles:
*/
CREATE TABLE ticket_cycle_mappings
(

    id        TEXT    NOT NULL PRIMARY KEY UNIQUE,
    ticket_id TEXT    NOT NULL,
    cycle_id  TEXT    NOT NULL,
    created   INTEGER NOT NULL,
    modified  INTEGER NOT NULL,
    deleted   BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (ticket_id, cycle_id) ON CONFLICT ABORT
);

/*
    Tickets can belong to one or more boards:
*/
CREATE TABLE ticket_board_mappings
(

    id        TEXT    NOT NULL PRIMARY KEY UNIQUE,
    ticket_id TEXT    NOT NULL,
    board_id  TEXT    NOT NULL,
    created   INTEGER NOT NULL,
    modified  INTEGER NOT NULL,
    deleted   BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (ticket_id, board_id) ON CONFLICT ABORT
);

/*
    OAuth2 mappings:
*/

/*
    Users can be Yandex OAuth2 account users:
*/
CREATE TABLE users_yandex_mappings
(

    id       TEXT    NOT NULL PRIMARY KEY UNIQUE,
    user_id  TEXT    NOT NULL UNIQUE,
    username TEXT    NOT NULL UNIQUE,
    created  INTEGER NOT NULL,
    modified INTEGER NOT NULL,
    deleted  BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
    Users can be Google OAuth2 account users:
*/
CREATE TABLE users_google_mappings
(

    id       TEXT    NOT NULL PRIMARY KEY UNIQUE,
    user_id  TEXT    NOT NULL UNIQUE,
    username TEXT    NOT NULL UNIQUE,
    created  INTEGER NOT NULL,
    modified INTEGER NOT NULL,
    deleted  BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0
);

/*
    User access rights:
*/

/*
    User belongs to organizations:
*/
CREATE TABLE user_organization_mappings
(

    id              TEXT    NOT NULL PRIMARY KEY UNIQUE,
    user_id         TEXT    NOT NULL,
    organization_id TEXT    NOT NULL,
    created         INTEGER NOT NULL,
    modified        INTEGER NOT NULL,
    deleted         BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (user_id, organization_id) ON CONFLICT ABORT
);

/*
    User belongs to the organization's teams:
*/
CREATE TABLE user_team_mappings
(

    id       TEXT    NOT NULL PRIMARY KEY UNIQUE,
    user_id  TEXT    NOT NULL,
    team_id  TEXT    NOT NULL,
    created  INTEGER NOT NULL,
    modified INTEGER NOT NULL,
    deleted  BOOLEAN NOT NULL CHECK (deleted IN (0, 1)) DEFAULT 0,
    UNIQUE (user_id, team_id) ON CONFLICT ABORT
);

/*
    User has the permissions.
    Each permission has be associated to the proper permission context.
*/
CREATE TABLE permission_user_mappings
(

    id                    TEXT    NOT NULL PRIMARY KEY UNIQUE,
    permission_id         TEXT    NOT NULL,
    user_id               TEXT    NOT NULL,
    permission_context_id TEXT    NOT NULL,
    created               INTEGER NOT NULL,
    modified              INTEGER NOT NULL,
    deleted               BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (user_id, permission_id, permission_context_id) ON CONFLICT ABORT
);


/*
    Team has the permissions.
    Each team permission has be associated to the proper permission context.
    All team members (users) will inherit team's permissions.
*/
CREATE TABLE permission_team_mappings
(

    id                    TEXT    NOT NULL PRIMARY KEY UNIQUE,
    permission_id         TEXT    NOT NULL,
    team_id               TEXT    NOT NULL,
    permission_context_id TEXT    NOT NULL,
    created               INTEGER NOT NULL,
    modified              INTEGER NOT NULL,
    deleted               BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    UNIQUE (team_id, permission_id, permission_context_id) ON CONFLICT ABORT
);

/*
    The configuration data for the extension.
    Basically it represents the meta-data associated with each extension.
    Each configuration property can be enabled or disabled.
*/
CREATE TABLE configuration_data_extension_mappings
(

    id           TEXT    NOT NULL PRIMARY KEY UNIQUE,
    extension_id TEXT    NOT NULL,
    created      INTEGER NOT NULL,
    modified     INTEGER NOT NULL,
    property     TEXT    NOT NULL,
    value        TEXT,
    enabled      BOOLEAN NOT NULL CHECK (deleted IN (0, 1)),
    deleted      BOOLEAN NOT NULL CHECK (deleted IN (0, 1))
);

/*
    Extensions meta-data:
    Associate the various information with different extension.
    Meta-data information are the extension specific.
*/
CREATE TABLE extensions_meta_data
(

    id           TEXT    NOT NULL PRIMARY KEY UNIQUE,
    extension_id TEXT    NOT NULL,
    property     TEXT    NOT NULL,
    value        TEXT,
    created      INTEGER NOT NULL,
    modified     INTEGER NOT NULL,
    deleted      BOOLEAN NOT NULL CHECK (deleted IN (0, 1))
);