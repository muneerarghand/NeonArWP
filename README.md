# Neon Ark Warden Onboarding System

## Overview
PostgreSQL database for managing wardens in the Neon Ark system.

---

## Deliverables

- neon_ark.sql → full database schema + data + trigger
- neon_ark_erd.png → ERD diagram

---

## How to Run

1. Create database:
   CREATE DATABASE neon_ark;

2. Run SQL file:
   psql -U postgres -d neon_ark -f neon_ark.sql

---

## Tables

- roles
- employment_statuses
- clearance_levels
- identifier_types
- wardens
- certifications