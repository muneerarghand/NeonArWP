-- =========================
-- CLEAN START (DROP TABLES)
-- =========================
DROP TABLE IF EXISTS certifications CASCADE;
DROP TABLE IF EXISTS wardens CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS employment_statuses CASCADE;
DROP TABLE IF EXISTS clearance_levels CASCADE;
DROP TABLE IF EXISTS identifier_types CASCADE;

-- =========================
-- LOOKUP TABLES
-- =========================
CREATE TABLE identifier_types (
                                  identifier_type_id SERIAL PRIMARY KEY,
                                  type_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE roles (
                       role_id SERIAL PRIMARY KEY,
                       role_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE employment_statuses (
                                     status_id SERIAL PRIMARY KEY,
                                     status_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE clearance_levels (
                                  clearance_id SERIAL PRIMARY KEY,
                                  clearance_name VARCHAR(50) UNIQUE NOT NULL
);

-- =========================
-- INSERT LOOKUP VALUES
-- =========================
INSERT INTO identifier_types (type_name) VALUES
                                             ('Badge'), ('Passport'), ('Visa');

INSERT INTO roles (role_name) VALUES
                                  ('Admin'), ('Field'), ('Rift'), ('Trainer'), ('Astral');

INSERT INTO employment_statuses (status_name) VALUES
                                                  ('Active'), ('OnLeave'), ('Terminated');

INSERT INTO clearance_levels (clearance_name) VALUES
                                                  ('Alpha'), ('Omega'), ('Eclipse');

-- =========================
-- WARDENS TABLE
-- =========================
CREATE TABLE wardens (
                         warden_id SERIAL PRIMARY KEY,
                         first_name VARCHAR(100) NOT NULL,
                         last_name VARCHAR(100),
                         identifier_type_id INT NOT NULL,
                         identifier_value VARCHAR(100) NOT NULL,
                         email VARCHAR(150) UNIQUE NOT NULL,
                         role_id INT NOT NULL,
                         status_id INT NOT NULL,
                         clearance_id INT NOT NULL,
                         start_date DATE NOT NULL,
                         end_date DATE,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                         FOREIGN KEY (identifier_type_id) REFERENCES identifier_types(identifier_type_id),
                         FOREIGN KEY (role_id) REFERENCES roles(role_id),
                         FOREIGN KEY (status_id) REFERENCES employment_statuses(status_id),
                         FOREIGN KEY (clearance_id) REFERENCES clearance_levels(clearance_id),

                         UNIQUE (identifier_type_id, identifier_value)
);

-- =========================
-- CERTIFICATIONS TABLE
-- =========================
CREATE TABLE certifications (
                                certification_id SERIAL PRIMARY KEY,
                                warden_id INT NOT NULL,
                                certification_name VARCHAR(150) NOT NULL,
                                date_earned DATE NOT NULL,
                                expiration_date DATE,
                                is_expired BOOLEAN DEFAULT FALSE,

                                FOREIGN KEY (warden_id) REFERENCES wardens(warden_id) ON DELETE CASCADE
);

-- =========================
-- BONUS: Auto-update expiration flag + updated_at
-- =========================
CREATE OR REPLACE FUNCTION update_certification_expiry()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.expiration_date IS NOT NULL AND NEW.expiration_date < CURRENT_DATE THEN
        NEW.is_expired := TRUE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_cert_expiry
    BEFORE INSERT OR UPDATE ON certifications
    FOR EACH ROW EXECUTE FUNCTION update_certification_expiry();

CREATE OR REPLACE FUNCTION update_timestamp()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_warden_update
    BEFORE UPDATE ON wardens
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- =========================
-- INSERT WARDENS (10+ samples)
-- =========================
INSERT INTO wardens
(first_name, last_name, identifier_type_id, identifier_value, email, role_id, status_id, clearance_id, start_date)
VALUES
    ('Ava','Stone',1,'B001','ava@ark.com',1,1,1,'2024-01-01'),
    ('Liam','Reed',2,'P002','liam@ark.com',2,1,2,'2024-02-01'),
    ('Noah',NULL,3,'V003','noah@ark.com',3,2,3,'2024-03-01'),
    ('Emma','Blake',1,'B004','emma@ark.com',4,1,1,'2024-04-01'),
    ('Olivia','Knight',2,'P005','olivia@ark.com',5,1,2,'2024-05-01'),
    ('Elijah',NULL,3,'V006','elijah@ark.com',2,1,3,'2024-06-01'),
    ('James','Fox',1,'B007','james@ark.com',3,2,1,'2024-07-01'),
    ('Sophia','Ray',2,'P008','sophia@ark.com',4,1,2,'2024-08-01'),
    ('Mason',NULL,3,'V009','mason@ark.com',5,1,3,'2024-09-01'),
    ('Isabella','Cole',1,'B010','isabella@ark.com',1,1,1,'2024-10-01');

-- =========================
-- INSERT CERTIFICATIONS
-- =========================
INSERT INTO certifications (warden_id, certification_name, date_earned, expiration_date)
VALUES
    (1,'Containment Level 1','2024-01-10','2025-01-10'),
    (1,'Hazard Protocol','2024-02-15','2026-02-15'),
    (2,'Field Survival','2024-03-20','2025-03-20'),
    (3,'Rift Stability','2024-04-05',NULL),
    (4,'Emergency Response','2024-05-01','2025-05-01');

-- =========================
-- FINAL VERIFICATION QUERIES (for testing)
-- =========================
SELECT '=== WARDENS ===' as test;
SELECT warden_id, first_name, last_name, email, role_id, status_id, clearance_id FROM wardens ORDER BY warden_id;

SELECT '=== CERTIFICATIONS ===' as test;
SELECT * FROM certifications;