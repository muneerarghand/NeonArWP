-- =========================
-- CLEAN START (DROP TABLES)
-- =========================
DROP TABLE IF EXISTS certifications;
DROP TABLE IF EXISTS wardens;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS employment_statuses;
DROP TABLE IF EXISTS clearance_levels;
DROP TABLE IF EXISTS identifier_types;


-- =========================
-- LOOKUP TABLES
-- =========================
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

CREATE TABLE identifier_types (
                                  identifier_type_id SERIAL PRIMARY KEY,
                                  type_name VARCHAR(50) UNIQUE NOT NULL
);


-- =========================
-- INSERT LOOKUP VALUES
-- =========================
INSERT INTO roles (role_name) VALUES
                                  ('Admin'), ('Field'), ('Rift'), ('Trainer'), ('Astral');

INSERT INTO employment_statuses (status_name) VALUES
                                                  ('Active'), ('OnLeave'), ('Terminated');

INSERT INTO clearance_levels (clearance_name) VALUES
                                                  ('Alpha'), ('Omega'), ('Eclipse');

INSERT INTO identifier_types (type_name) VALUES
                                             ('Badge'), ('Passport'), ('Visa');


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

                                certification_name VARCHAR(100) NOT NULL,
                                date_earned DATE NOT NULL,
                                expiration_date DATE,

                                is_expired BOOLEAN DEFAULT FALSE,

                                FOREIGN KEY (warden_id)
                                    REFERENCES wardens(warden_id)
                                    ON DELETE CASCADE
);


-- =========================
-- INSERT WARDENS (10+)
-- =========================
INSERT INTO wardens
(first_name, last_name, identifier_type_id, identifier_value, email, role_id, status_id, clearance_id, start_date)
VALUES
    ('Ava', 'Stone', 1, 'B001', 'ava@ark.com', 1, 1, 1, '2024-01-01'),
    ('Liam', 'Reed', 2, 'P002', 'liam@ark.com', 2, 1, 2, '2024-02-01'),
    ('Noah', NULL, 3, 'V003', 'noah@ark.com', 3, 2, 3, '2024-03-01'),
    ('Emma', 'Blake', 1, 'B004', 'emma@ark.com', 4, 1, 1, '2024-04-01'),
    ('Olivia', 'Knight', 2, 'P005', 'olivia@ark.com', 5, 1, 2, '2024-05-01'),
    ('Elijah', NULL, 3, 'V006', 'elijah@ark.com', 2, 1, 3, '2024-06-01'),
    ('James', 'Fox', 1, 'B007', 'james@ark.com', 3, 2, 1, '2024-07-01'),
    ('Sophia', 'Ray', 2, 'P008', 'sophia@ark.com', 4, 1, 2, '2024-08-01'),
    ('Mason', NULL, 3, 'V009', 'mason@ark.com', 5, 1, 3, '2024-09-01'),
    ('Isabella', 'Cole', 1, 'B010', 'isabella@ark.com', 1, 1, 1, '2024-10-01');


-- =========================
-- INSERT CERTIFICATIONS
-- =========================
INSERT INTO certifications (warden_id, certification_name, date_earned)
VALUES
    (1, 'Containment Level 1', '2024-01-10'),
    (1, 'Hazard Protocol', '2024-02-15'),
    (2, 'Field Survival', '2024-03-20'),
    (3, 'Rift Stability', '2024-04-05');


-- =========================
-- BONUS: TRIGGER FUNCTION
-- =========================
CREATE OR REPLACE FUNCTION update_timestamp()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.created_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =========================
-- BONUS: TRIGGER
-- =========================
CREATE TRIGGER set_timestamp
    BEFORE INSERT ON wardens
    FOR EACH ROW
EXECUTE FUNCTION update_timestamp();


-- =========================
-- FINAL TEST
-- =========================
SELECT * FROM wardens;

CREATE TABLE roles (...);
CREATE TABLE employment_statuses (...);
CREATE TABLE clearance_levels (...);
CREATE TABLE identifier_types (...);
CREATE TABLE wardens (...);
CREATE TABLE certifications (...);


-- =========================
-- TABLE CREATION
-- =========================

CREATE TABLE roles (...);
CREATE TABLE employment_statuses (...);
CREATE TABLE clearance_levels (...);
CREATE TABLE identifier_types (...);
CREATE TABLE wardens (...);
CREATE TABLE certifications (...);

-- =========================
-- INSERT DATA
-- =========================

-- Roles
INSERT INTO roles (role_name) VALUES
                                  ('Admin'),
                                  ('Field'),
                                  ('Rift'),
                                  ('Trainer'),
                                  ('Astral');

-- Employment Status
INSERT INTO employment_statuses (status_name) VALUES
                                                  ('Active'),
                                                  ('OnLeave'),
                                                  ('Terminated');

-- Clearance Levels
INSERT INTO clearance_levels (level_name) VALUES
                                              ('Alpha'),
                                              ('Omega'),
                                              ('Eclipse');

-- Identifier Types
INSERT INTO identifier_types (type_name) VALUES
                                             ('Badge'),
                                             ('Passport'),
                                             ('Visa');

-- Wardens (AT LEAST 10)
INSERT INTO wardens
(first_name, last_name, email, identifier_type_id, identifier_value, role_id, employment_status_id, clearance_level_id, start_date)
VALUES
    ('John', 'Doe', 'john1@email.com', 1, 'ID001', 1, 1, 1, '2024-01-01'),
    ('Jane', 'Smith', 'jane2@email.com', 2, 'ID002', 2, 1, 2, '2024-02-01'),
    ('Mike', 'Lee', 'mike3@email.com', 3, 'ID003', 3, 2, 3, '2024-03-01'),
    ('Sara', 'Ali', 'sara4@email.com', 1, 'ID004', 4, 1, 1, '2024-04-01'),
    ('Tom', 'Ray', 'tom5@email.com', 2, 'ID005', 5, 3, 2, '2024-05-01'),
    ('Lina', 'Khan', 'lina6@email.com', 3, 'ID006', 2, 1, 3, '2024-06-01'),
    ('Omar', 'Zed', 'omar7@email.com', 1, 'ID007', 3, 2, 1, '2024-07-01'),
    ('Nina', 'Fox', 'nina8@email.com', 2, 'ID008', 4, 1, 2, '2024-08-01'),
    ('Adam', 'West', 'adam9@email.com', 3, 'ID009', 5, 1, 3, '2024-09-01'),
    ('Eve', 'Stone', 'eve10@email.com', 1, 'ID010', 1, 2, 1, '2024-10-01');

-- Certifications
INSERT INTO certifications (warden_id, certification_name, date_earned)
VALUES
    (1, 'Hazard Containment', '2024-01-10'),
    (2, 'Rift Navigation', '2023-06-15'),
    (3, 'Astral Safety', '2024-03-20');


-- =========================
-- CLEAN START (DROP TABLES)
-- =========================
DROP TABLE IF EXISTS certifications;
DROP TABLE IF EXISTS wardens;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS employment_statuses;
DROP TABLE IF EXISTS clearance_levels;
DROP TABLE IF EXISTS identifier_types;


-- =========================
-- LOOKUP TABLES
-- =========================
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

CREATE TABLE identifier_types (
                                  identifier_type_id SERIAL PRIMARY KEY,
                                  type_name VARCHAR(50) UNIQUE NOT NULL
);


-- =========================
-- INSERT LOOKUP VALUES
-- =========================
INSERT INTO roles (role_name) VALUES
                                  ('Admin'), ('Field'), ('Rift'), ('Trainer'), ('Astral');

INSERT INTO employment_statuses (status_name) VALUES
                                                  ('Active'), ('OnLeave'), ('Terminated');

INSERT INTO clearance_levels (clearance_name) VALUES
                                                  ('Alpha'), ('Omega'), ('Eclipse');

INSERT INTO identifier_types (type_name) VALUES
                                             ('Badge'), ('Passport'), ('Visa');


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

                         FOREIGN KEY (identifier_type_id)
                             REFERENCES identifier_types(identifier_type_id),

                         FOREIGN KEY (role_id)
                             REFERENCES roles(role_id),

                         FOREIGN KEY (status_id)
                             REFERENCES employment_statuses(status_id),

                         FOREIGN KEY (clearance_id)
                             REFERENCES clearance_levels(clearance_id),

    -- Prevent duplicate identities
                         UNIQUE (identifier_type_id, identifier_value)
);


-- =========================
-- CERTIFICATIONS TABLE
-- =========================
CREATE TABLE certifications (
                                certification_id SERIAL PRIMARY KEY,
                                warden_id INT NOT NULL,

                                certification_name VARCHAR(100) NOT NULL,
                                date_earned DATE NOT NULL,
                                expiration_date DATE,

                                is_expired BOOLEAN DEFAULT FALSE,

                                FOREIGN KEY (warden_id)
                                    REFERENCES wardens(warden_id)
                                    ON DELETE CASCADE
);


-- =========================
-- INSERT WARDENS (10+)
-- =========================
INSERT INTO wardens
(first_name, last_name, identifier_type_id, identifier_value, email, role_id, status_id, clearance_id, start_date)
VALUES
    ('Ava', 'Stone', 1, 'B001', 'ava@ark.com', 1, 1, 1, '2024-01-01'),
    ('Liam', 'Reed', 2, 'P002', 'liam@ark.com', 2, 1, 2, '2024-02-01'),
    ('Noah', NULL, 3, 'V003', 'noah@ark.com', 3, 2, 3, '2024-03-01'),
    ('Emma', 'Blake', 1, 'B004', 'emma@ark.com', 4, 1, 1, '2024-04-01'),
    ('Olivia', 'Knight', 2, 'P005', 'olivia@ark.com', 5, 1, 2, '2024-05-01'),
    ('Elijah', NULL, 3, 'V006', 'elijah@ark.com', 2, 1, 3, '2024-06-01'),
    ('James', 'Fox', 1, 'B007', 'james@ark.com', 3, 2, 1, '2024-07-01'),
    ('Sophia', 'Ray', 2, 'P008', 'sophia@ark.com', 4, 1, 2, '2024-08-01'),
    ('Mason', NULL, 3, 'V009', 'mason@ark.com', 5, 1, 3, '2024-09-01'),
    ('Isabella', 'Cole', 1, 'B010', 'isabella@ark.com', 1, 1, 1, '2024-10-01');


-- =========================
-- INSERT CERTIFICATIONS
-- =========================
INSERT INTO certifications (warden_id, certification_name, date_earned, expiration_date)
VALUES
    (1, 'Containment Level 1', '2024-01-10', '2025-01-10'),
    (1, 'Hazard Protocol', '2024-02-15', NULL),
    (2, 'Field Survival', '2024-03-20', '2025-03-20'),
    (3, 'Rift Stability', '2024-04-05', NULL);


-- =========================
-- FINAL TEST
-- =========================
SELECT * FROM wardens;
SELECT * FROM certifications;


