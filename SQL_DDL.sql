-- tables
-- Table: contact_information
CREATE table if not exists contact_information (
    contactInfo_ID int generated always as identity primary key,
    email varchar(50)  null unique,
    phone_number varchar(15) unique 
);

-- Table: department
CREATE table if not exists department (
    department_ID int  generated always as identity primary key,
    name varchar(30)  NOT NULL,
    facility_ID int  NOT NULL
);

-- Table: facility
CREATE table if not exists facility (
    facility_ID int  generated always as identity primary key,
    name varchar(100)  NOT NULL,
    contactInfo_ID int  NOT NULL,
    location_ID int  NOT null,
    capacity int not null check (capacity >= 0)
);

-- Table: location
CREATE table if not exists location (
    location_ID int  generated always as identity primary key,
    district varchar(50)  NOT NULL,
    address varchar(50)  NOT NULL,
    home_number varchar(5)  NOT NULL
);

-- Table: operation
CREATE table if not exists operation (
    operation_ID int  generated always as identity primary key,
    name varchar(50)  NOT NULL,
    description text  NOT NULL,
    department_ID int  NOT NULL
);

-- Table: operation_record
CREATE table if not exists operation_record (
    record_ID int  generated always as identity primary key,
    visit_ID int  NOT NULL,
    operation_ID int  NOT NULL,
    outcome varchar(255)  NOT NULL,
    operation_date date  NOT null default current_timestamp   -- if we are not have time for it, it will be by default this day
);

-- Table: operation_resource
CREATE table if not exists operation_resource (
    resource_ID int  NOT NULL,
    record_ID int  NOT NULL,
    quantity int not null default 1 check (quantity >= 0), 
    CONSTRAINT operation_resource_pk PRIMARY KEY (resource_ID,record_ID)
);

-- Table: patient
CREATE table if not exists patient (
    patient_ID int  generated always as identity primary key,
    name varchar(50)  NOT NULL,
    surname varchar(50)  NOT NULL,
    dob date  NOT NULL
);

-- Table: patient_visit
CREATE table if not exists patient_visit (
    visit_ID int generated always as identity primary key,
    visit_date date  NOT null check (visit_date > '2024-01-01'), -- by our requirements it should be in 3 months
    patient_ID int  NOT NULL,
    purporseType_ID int  NOT NULL,
    facility_ID int  NOT null,
    staff_ID int not null
);

-- Table: purporse_type
CREATE table if not exists purporse_type (
    purporseType_ID int  generated always as identity primary key,
    name varchar(50)  NOT NULL
);

-- Table: resource
CREATE table if not exists resource (
    resource_ID int  generated always as identity primary key,
    quantity int  NOT null check (quantity >= 0),
    resourceType int  NOT NULL,
    facility_ID int  NOT NULL
);

-- Table: resource_type
CREATE table if not exists resource_type (
    resourceType_ID int  generated always as identity primary key,
    name varchar(50)  NOT NULL
);

-- Table: role
CREATE table if not exists role (
    role_ID int  generated always as identity primary key,
    name varchar(50)  NOT NULL
);

-- Table: staff
CREATE table if not exists staff (
    staff_ID int  generated always as identity primary key,
    name varchar(30)  NOT NULL,
    surname varchar(30)  NOT NULL,
    employmentDate date  NOT NULL,
    role_ID int  NOT NULL
);

create table if not exists department_staff (
	staff_ID int not null,
	department_ID int not null,
	CONSTRAINT department_staff_pk PRIMARY KEY (staff_ID, department_ID)
);

-- Table: staff_operation
CREATE table if not exists staff_operation (
    staff_ID int  NOT NULL,
    record_ID int  NOT NULL,
    role_ID int  NOT NULL,
    CONSTRAINT staff_operation_pk PRIMARY KEY (staff_ID,record_ID,role_ID)
);

-- foreign keys
-- Reference: department_facility (table: department)
ALTER TABLE department ADD CONSTRAINT department_facility
    FOREIGN KEY (facility_ID)
    REFERENCES facility (facility_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: facility_contact_information (table: facility)
ALTER TABLE facility ADD CONSTRAINT facility_contact_information
    FOREIGN KEY (contactInfo_ID)
    REFERENCES contact_information (contactInfo_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: facility_location (table: facility)
ALTER TABLE facility ADD CONSTRAINT facility_location
    FOREIGN KEY (location_ID)
    REFERENCES location (location_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: operation_department (table: operation)
ALTER TABLE operation ADD CONSTRAINT operation_department
    FOREIGN KEY (department_ID)
    REFERENCES department (department_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: operation_record_operation (table: operation_record)
ALTER TABLE operation_record ADD CONSTRAINT operation_record_operation
    FOREIGN KEY (operation_ID)
    REFERENCES operation (operation_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: operation_record_patient_visit (table: operation_record)
ALTER TABLE operation_record ADD CONSTRAINT operation_record_patient_visit
    FOREIGN KEY (visit_ID)
    REFERENCES patient_visit (visit_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: operation_resource_operation_record (table: operation_resource)
ALTER TABLE operation_resource ADD CONSTRAINT operation_resource_operation_record
    FOREIGN KEY (record_ID)
    REFERENCES operation_record (record_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: operation_resource_resource (table: operation_resource)
ALTER TABLE operation_resource ADD CONSTRAINT operation_resource_resource
    FOREIGN KEY (resource_ID)
    REFERENCES resource (resource_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: patient_visit_facility (table: patient_visit)
ALTER TABLE patient_visit ADD CONSTRAINT patient_visit_facility
    FOREIGN KEY (facility_ID)
    REFERENCES facility (facility_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: patient_visit_patient (table: patient_visit)
ALTER TABLE patient_visit ADD CONSTRAINT patient_visit_patient
    FOREIGN KEY (patient_ID)
    REFERENCES patient (patient_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: patient_visit_purporse_type (table: patient_visit)
ALTER TABLE patient_visit ADD CONSTRAINT patient_visit_purporse_type
    FOREIGN KEY (purporseType_ID)
    REFERENCES purporse_type (purporseType_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE patient_visit ADD CONSTRAINT patient_visit_staff
    FOREIGN KEY (staff_ID)
    REFERENCES staff (staff_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: resource_facility (table: resource)
ALTER TABLE resource ADD CONSTRAINT resource_facility
    FOREIGN KEY (facility_ID)
    REFERENCES facility (facility_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: resource_resource_type (table: resource)
ALTER TABLE resource ADD CONSTRAINT resource_resource_type
    FOREIGN KEY (resourceType)
    REFERENCES resource_type (resourceType_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: staff_operation_operation_record (table: staff_operation)
ALTER TABLE staff_operation ADD CONSTRAINT staff_operation_operation_record
    FOREIGN KEY (record_ID)
    REFERENCES operation_record (record_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: staff_operation_role (table: staff_operation)
ALTER TABLE staff_operation ADD CONSTRAINT staff_operation_role
    FOREIGN KEY (role_ID)
    REFERENCES role (role_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: staff_operation_staff (table: staff_operation)
ALTER TABLE staff_operation ADD CONSTRAINT staff_operation_staff
    FOREIGN KEY (staff_ID)
    REFERENCES staff (staff_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: staff_role (table: staff)
ALTER TABLE staff ADD CONSTRAINT staff_role
    FOREIGN KEY (role_ID)
    REFERENCES role (role_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: department_staff_department (table: department_staff)
ALTER TABLE department_staff ADD CONSTRAINT department_staff_department
    FOREIGN KEY (department_ID)
    REFERENCES department (department_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: department_staff_staff (table: department_staff)
ALTER TABLE department_staff ADD CONSTRAINT department_staff_staff
    FOREIGN KEY (staff_ID)
    REFERENCES staff (staff_ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

----------------------------------------------------------------------

insert into contact_information (email, phone_number) values
('andelosa@example.com', '(+48)228305425'),
('institue@example.com', '(+48)225690500'),
('sekretariat@brodnowski.pl', '(+48)223265226'),
('dn@bielanski.med.pl', '(+48)5022000'),
('szpitalbanacha@spcsk.pl', '(+48)225098412')
returning *;

insert into location (district, address, home_number) values
('Bielany', 'Kopernika', '42'),
('Ursus', 'Ceglowska', '52'),
('Bemowo', 'Kondratowicza', '33'),
('Ulrychow', 'Lindeleya', '2A'),
('Bielany', 'Banacha', '141')
returning *;

insert into purporse_type (name) values
('Surgery'),
('Physical Therapy'),
('Dental Care'),
('Emergency Care'),
('General Checkup')
returning *;

insert into resource_type (name) values
('Bed'),
('X-Ray Machine'),
('MRI Machine'),
('Ventilator')
returning *;

insert into role (name) values
('Doctor'), ('Nurse'), ('Technician'), ('Janitor'), ('Receptionist')
returning *;

insert into patient (name, surname, dob) values
('John', 'Doe', '1980-02-15'),
('Jane', 'Smith', '1990-03-22'),
('Michael', 'Brown', '1975-07-08'),
('Linda', 'White', '1965-11-01'),
('James', 'Jones', '1985-05-19')
returning *;

insert into facility (name, contactInfo_ID, location_ID, capacity) values
('Warsaw Hospital for Children', 1, 1, 100),
('Pediatric Hospital “Niekłańska”', 2, 2, 50),
('Pediatric Clinical Hospital in Warsaw', 3, 3, 75),
('Samodzielny Publiczny Centralny Szpital Kliniczny', 4, 4, 200),
('Szpital Kliniczny Dzieciątka Jezus w Warszawie', 5, 5, 60)
returning *;

insert into staff (name, surname, employmentDate, role_ID) values
('Alice', 'Johnson', '2024-02-01', 1),
('Bob', 'Williams', '2024-02-15', 2),
('Carol', 'Miller', '2024-03-01', 3),
('Dave', 'Davis', '2024-03-15', 4),
('Eve', 'Wilson', '2024-04-01', 5)
returning *;

insert into resource (quantity, resourceType, facility_ID) values
(20, 1, 1),
(5, 2, 1),
(2, 3, 2),
(3, 4, 3),
(4, 4, 4)
returning *;

insert into department (name, facility_id) values
('Cardiology', 1),
('Orthopedics', 2),
('Neurology', 3),
('Pediatrics', 4),
('General Surgery', 5)
returning *;

insert into operation (name, description, department_ID) values
('Heart Bypass Surgery', 'Surgical procedure to improve blood flow to the heart.', 1),
('Knee Replacement', 'Replacing the knee joint with a prosthetic.', 2),
('Brain MRI', 'Magnetic resonance imaging of the brain.', 3),
('Pediatric Checkup', 'Routine health checkup for children.', 4),
('Appendectomy', 'Surgical removal of the appendix.', 5)
returning *;

insert into patient_visit (visit_date, patient_ID, purporseType_ID, facility_ID, staff_ID) values
('2024-02-05', 1, 1, 1, 1),
('2024-02-15', 2, 2, 1, 1),
('2024-03-01', 3, 3, 2, 1),
('2024-03-15', 4, 4, 3, 1),
('2024-04-01', 5, 5, 4, 2)
returning *;

insert into operation_record (visit_ID, operation_ID, outcome, operation_date) values
(1, 1, 'Successful, but with further observation', '2024-02-06'),
(2, 2, 'Successful', '2024-02-16'),
(3, 3, 'Pending', '2024-03-02'),
(4, 4, 'Successful, but was some problems - next step observatory', '2024-03-16'),
(5, 5, 'Completed', '2024-04-02')
returning *;


insert into operation_resource (resource_ID, record_ID, quantity) values 
(1, 1, 2),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1)
returning *;

insert into staff_operation (staff_ID, record_ID, role_ID) values
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5)
returning *;

insert into department_staff (staff_ID, department_ID) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)
returning *;


select s.staff_ID, s.name, s.surname, count(distinct pv.patient_ID) as patient_count
from staff s
inner join patient_visit pv ON s.staff_ID = pv.staff_ID
inner join role r ON s.role_ID = r.role_ID
where r.name = 'Doctor' and pv.visit_date >= date_trunc('month', current_date) - interval '1 month' -- extract month and use interval to make interval in 2 month for our requirement
group by s.staff_ID, s.name, s.surname, EXTRACT(MONTH FROM pv.visit_date)
having count(distinct pv.patient_ID) < 5;


