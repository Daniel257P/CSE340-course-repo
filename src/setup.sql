-- Organization Table 
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

-- Insert sample data: Organizations
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

SELECT * FROM organization;

CREATE TABLE service_project (
  project_id SERIAL PRIMARY KEY,
  organization_id INT NOT NULL REFERENCES organization(organization_id),
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  location VARCHAR(255) NOT NULL,
  date DATE NOT NULL
);

SELECT * FROM service_project; 

INSERT INTO service_project (organization_id, title, description, location, date)
VALUES
(1, 'Community Playground Build', 'Constructing a safe and modern playground for local families.', 'Oakridge Neighborhood Park', '2026-08-12'),
(1, 'Youth Carpentry Workshop', 'Teaching teens basic carpentry and tool safety.', 'BrightFuture Training Center', '2026-09-03'),
(1, 'Neighborhood Home Repair Day', 'Providing free minor repairs for low-income households.', 'Eastwood Community', '2026-09-18'),
(1, 'Community Center Renovation', 'Renovating the old community center to support youth programs.', 'Riverside Community Center', '2026-10-02'),
(1, 'Shelter Bunk Construction', 'Building new bunk frames for the local homeless shelter.', 'Hope Haven Shelter', '2026-08-27');

INSERT INTO service_project (organization_id, title, description, location, date)
VALUES
(2, 'Urban Garden Expansion', 'Expanding the community garden to increase fresh produce availability.', 'Maple Street Garden', '2026-08-15'),
(2, 'Composting Education Day', 'Teaching residents how to compost and reduce waste.', 'GreenHarvest Farm Hub', '2026-09-07'),
(2, 'Farm-to-Family Produce Drive', 'Harvesting and distributing fresh vegetables to local families.', 'GreenHarvest Fields', '2026-09-21'),
(2, 'Pollinator Habitat Planting', 'Planting flowers and shrubs to support bees and butterflies.', 'Lakeside Nature Reserve', '2026-10-04'),
(2, 'Sustainable Irrigation Workshop', 'Training volunteers on water-efficient irrigation systems.', 'Community Agriculture Center', '2026-08-30');

INSERT INTO service_project (organization_id, title, description, location, date)
VALUES
(3, 'Back-to-School Supply Fair', 'Providing backpacks and supplies to students in need.', 'UnityServe Hall', '2026-08-20'),
(3, 'Warm Meals Outreach', 'Serving hot meals to unhoused community members.', 'Downtown Outreach Plaza', '2026-09-10'),
(3, 'Senior Companion Day', 'Spending time with seniors through games and conversation.', 'Golden Years Senior Home', '2026-09-25'),
(3, 'Community Wellness Expo', 'Offering free health screenings and wellness resources.', 'City Civic Center', '2026-10-06'),
(3, 'Emergency Relief Kit Assembly', 'Assembling emergency kits for families affected by disasters.', 'UnityServe Warehouse', '2026-08-28');

CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

SELECT * FROM category; 
CREATE TABLE project_category (
    project_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (project_id, category_id),
    FOREIGN KEY (project_id) REFERENCES service_project(project_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category(category_id) ON DELETE CASCADE
);

SELECT * FROM project_category; 
INSERT INTO category (category_name) VALUES
('Environmental'),
('Educational'),
('Community Service'),
('Health and Wellness');

INSERT INTO project_category (project_id, category_id) VALUES
(1, 1), -- Project 1 → Environmental
(2, 2), -- Project 2 → Educational
(3, 3), -- Project 3 → Community Service
(4, 4), -- Project 4 → Health and Wellness
(5, 3),  -- Shelter Bunk Construction → Community Service
(6, 1),  -- Urban Garden Expansion → Environmental
(7, 2),  -- Composting Education Day → Educational
(8, 3),  -- Farm-to-Family Produce Drive → Community Service
(9, 1),  -- Pollinator Habitat Planting → Environmental
(10, 2), -- Sustainable Irrigation Workshop → Educational
(11, 2), -- Back-to-School Supply Fair → Educational
(12, 3), -- Warm Meals Outreach → Community Service
(13, 4), -- Senior Companion Day → Health and Wellness
(14, 4), -- Community Wellness Expo → Health and Wellness
(15, 3); -- Emergency Relief Kit Assembly → Community Service

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT
);

INSERT INTO roles (role_name, role_description) VALUES 
    ('user', 'Standard user with basic access'),
    ('admin', 'Administrator with full system access');

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INTEGER REFERENCES roles(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert a test user
INSERT INTO users (name, email, password_hash, role_id) 
VALUES ('testuser', 'test@example.com', 'placeholder_hash', 1);

-- Join users and roles to see complete information
SELECT u.user_id, u.name, u.email, r.role_name, r.role_description
FROM users u
JOIN roles r ON u.role_id = r.role_id;

SELECT * FROM roles;
SELECT * FROM users;
-- Delete the test user
DELETE FROM users WHERE email = 'test@example.com';

-- Update the dedicated admin testing account to have admin role
UPDATE users SET role_id = (SELECT role_id FROM roles WHERE role_name = 'admin') WHERE email = 'admin@example.com';

-- Verify the update by listing all users and their roles
SELECT users.user_id, users.email, roles.role_name FROM users JOIN roles ON users.role_id = roles.role_id;

-- Volunteer Table: tracks which users have signed up for which service projects (many-to-many)
CREATE TABLE project_volunteer (
    project_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (project_id, user_id),
    FOREIGN KEY (project_id) REFERENCES service_project(project_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

SELECT * FROM project_volunteer;