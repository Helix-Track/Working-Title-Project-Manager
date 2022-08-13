![JIRA alternative for the free world!](Assets/Wide_Black.png)

# Core

The Core module for the Helix Track.

## Database

The system database

The `Definition.sqlite` represents the system database. 
It contains all the tables and initial data required for the system to work.

The DDL directory contains all major SQL scripts required to initialize the database.

Convention used for the SQl script is the following:

- The main version scripts:

`Definition.VX.sql` where X represnts the version of the database (1, 2, 3, etc).

- Migration scripts:

`Migration.VX.Y.sql` where X represnts the version of the database (1, 2, 3, etc) and Y the version of the patch (1, 2, 3, etc).

All SQL scripts are executed by the shell and the `Definition.sqlite` is created as a result.

## Scripts and tools

The system scripts and tools located in the `Scripts` directory.

All scripts and tools required for the system to intialize (database, generated code, etc.) are located here.


