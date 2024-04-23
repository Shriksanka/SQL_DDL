# DVD Rental Database Schema and Functions

## Overview

This repository contains the database schema (DDL) scripts and utility functions for the sample DVD Rental database, commonly used for practicing PostgreSQL. It also includes the Entity-Relationship Diagram (ERD) for visual representation of the database structure.

## Contents

- `SQL_DDL.sql` - SQL script for creating tables and relationships in the DVD rental database.
- `SQL_DDL_Func.sql` - SQL script that includes functions and stored procedures for the DVD rental database.
- `SQL_DDL_1.sql` - Additional SQL script for modifying or extending the database schema.
- `SQL_DDL_Func_1.sql` - Additional SQL script for more functions and stored procedures.
- `dvdrental` - A backup file for the DVD rental database.
- `dvd-rental-sample-database-diagram.png` - The ERD for the DVD rental database.

## Instructions

### Setting up the Database

To set up the database, you will need to restore the `dvdrental` backup file into your PostgreSQL instance. 

1. Restore the database using pg_restore or through the PostgreSQL interface.
2. Execute the `SQL_DDL.sql` script to set up the initial database schema.
3. Run `SQL_DDL_Func.sql` to create necessary functions and stored procedures.

### Modifying the Schema

If you need to make changes or extend the database:

1. Use `SQL_DDL_1.sql` for additional schema changes.
2. `SQL_DDL_Func_1.sql` includes supplementary functions and procedures that can be applied.

### Using the ERD

Refer to `dvd-rental-sample-database-diagram.png` to understand the database's structure. It will help you visualize how tables are related and assist you in formulating queries or making schema changes.

## Contributions

Contributions are welcome. If you notice any issues or have improvements for the database scripts or the ERD, please submit a pull request or open an issue.
