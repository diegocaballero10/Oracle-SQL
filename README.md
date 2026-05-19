# DB_world — Complex SQL Queries (Oracle)

First practical assignment for the Databases course at Pontificia Universidad Javeriana. The practice uses the classic DB_world schema (countries, cities, and languages) on Oracle Database to exercise complex SQL queries: string searching, numeric aggregations, subqueries with `ROWNUM`, and multi-table joins.

---

# Table of contents

- [Overview](#overview)
- [Database schema](#database-schema)
- [How to run](#how-to-run)
- [Query catalog](#query-catalog)
- [Repository structure](#repository-structure)
- [Author](#author)

---

# Overview

The assignment is organized in four sections of increasing difficulty:

## 1. Initial setup and verification
Create tables, load data, and confirm the relationships between them.

## 2. Basic queries
Use of `DISTINCT`, `WHERE`, `ORDER BY`, and basic filters.

## 3. String searching
Use of `LIKE`, `LENGTH`, `LOWER`, `UPPER`, `CONCAT`, `RTRIM`, and combinations using `AND`, `OR`, and `NOT`.

## 4. Numeric conditions and joins
Use of aggregate functions (`AVG`, `MIN`, `MAX`, `SUM`, `COUNT`), `GROUP BY`, subqueries with `ROWNUM`, and joins (both implicit and explicit `JOIN` syntax).

All queries are written for Oracle Database (the script uses `ROWNUM`, `EXECUTE IMMEDIATE`, and Oracle check constraint syntax).

---

# Database schema

The schema contains three tables related through `CountryCode`:

```text
country (Code PK)  <----  city (CountryCode FK)
country (Code PK)  <----  countrylanguage (CountryCode FK)
