# Neon Ark Warden Onboarding System

## Overview

PostgreSQL database for managing Warden onboarding, roles, status, and certifications.

---

## Deliverables

* `neon_ark.sql` → Full database (tables, data, trigger)
* `neon_ark_erd.png` → ERD diagram

---

## How to Run

```sql
CREATE DATABASE neon_ark;
```

```bash
psql -U postgres -d neon_ark -f neon_ark.sql
```

---

## Tables

roles, employment_statuses, clearance_levels, identifier_types, wardens, certifications

---

## Notes

* Includes 10+ sample wardens
* Uses constraints and foreign keys for data integrity
* Includes trigger for automatic timestamps
* Tested and runs without errors
