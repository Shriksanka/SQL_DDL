-- tables
-- Table: contact_information
CREATE TABLE contact_information (
    contactInfoID int NOT NULL,
    email varchar(50) NOT NULL UNIQUE, -- Email must be unique
    phone varchar(15) NOT NULL UNIQUE, -- Phone must be unique
    CONSTRAINT contact_information_pk PRIMARY KEY (contactInfoID)
);

-- Table: contribution
CREATE TABLE contribution (
    contributionID int NOT NULL,
    donorID int NOT NULL,
    financeID int NOT NULL,
    amount decimal(20,2) NOT NULL CHECK (amount >= 0), -- Check for non-negative value
    contributionDate date NOT NULL CHECK (contributionDate > '2000-01-01'), -- Check for date
    CONSTRAINT contribution_pk PRIMARY KEY (contributionID)
);

-- Table: donor
CREATE TABLE donor (
    donorID int  NOT NULL,
    typeDonorID int  NOT NULL,
    name varchar(50)  NULL,
    CONSTRAINT donor_pk PRIMARY KEY (donorID)
);

-- Table: event
CREATE TABLE event (
    eventID int NOT NULL,
    typeEventID int NOT NULL,
    eventDate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Using DEFAULT, if it didn't be in plan, let's say that it will be today
    location varchar(255) NOT NULL,
    CONSTRAINT event_pk PRIMARY KEY (eventID)
);

-- Table: event_issue
CREATE TABLE event_issue (
    eventIssueID int  NOT NULL,
    eventID int  NOT NULL,
    typeIssueEventID int  NOT NULL,
    description varchar(255)  NOT NULL,
    reportedDate date  NOT NULL CHECK (reportedDate > '2000-01-01'), -- Check if it later then 1st January 2000
    resolveDate date  NULL,
    CONSTRAINT event_issue_pk PRIMARY KEY (eventIssueID)
);

-- Table: finance
CREATE TABLE finance (
    financeID int  NOT NULL,
    accountDetails varchar(255)  NOT NULL,
    totalAmount decimal(20,2)  NOT NULL CHECK (totalAmount > 0), -- Cannot be negative
    financeDate date  NOT NULL CHECK (financeDate > '2000-01-01'), -- Check if it later then 1st January 2000
    CONSTRAINT finance_pk PRIMARY KEY (financeID)
);

-- Table: finance_event
CREATE TABLE finance_event (
    financeEventID int  NOT NULL,
    financeID int  NOT NULL,
    eventID int  NOT NULL,
    amountSpent decimal(20,2)  NOT NULL CHECK (amountSpent >= 0),
    details varchar(255)  NOT NULL,
    CONSTRAINT finance_event_pk PRIMARY KEY (financeEventID)
);

-- Table: finance_survey
CREATE TABLE finance_survey (
    financeSurveyID int  NOT NULL,
    financeID int  NOT NULL,
    surveyID int  NOT NULL,
    amountSpent decimal(20,2)  NOT NULL CHECK (amountSpent >= 0),
    details varchar(255)  NOT NULL,
    CONSTRAINT finance_survey_pk PRIMARY KEY (financeSurveyID)
);

-- Table: question
CREATE TABLE question (
    questionID int  NOT NULL,
    questionText varchar(255)  NOT NULL,
    surveyID int  NOT NULL,
    CONSTRAINT question_pk PRIMARY KEY (questionID)
);

-- Table: role
CREATE TABLE role (
    roleID int  NOT NULL,
    name varchar(50)  NOT NULL,
    CONSTRAINT role_pk PRIMARY KEY (roleID)
);

-- Table: survey
CREATE TABLE survey (
    surveyID int  NOT NULL,
    topic varchar(100)  NOT NULL,
    result varchar(255)  NULL,
    CONSTRAINT survey_pk PRIMARY KEY (surveyID)
);

-- Table: survey_issue
CREATE TABLE survey_issue (
    surveyID int  NOT NULL,
    typeIssueSurveyID int  NOT NULL,
    description varchar(255)  NOT NULL,
    reportedDate date  NOT NULL CHECK (reportedDate > '2000-01-01'), -- Check if it later then 1st January 2000
    resolveDate date  NULL,
    CONSTRAINT survey_issue_pk PRIMARY KEY (surveyID,typeIssueSurveyID)
);

-- Table: survey_voter_question
CREATE TABLE survey_voter_question (
    voterID int  NOT NULL,
    surveyID int  NOT NULL,
    questionID int  NOT NULL,
    answerText varchar(100)  NULL DEFAULT 'blank', -- Lets say, that question w/o answers will have blank answer
    CONSTRAINT survey_voter_question_pk PRIMARY KEY (voterID,surveyID,questionID)
);

-- Table: task
CREATE TABLE task (
    taskID int  NOT NULL,
    eventID int  NOT NULL,
    taskDescription varchar(255)  NOT NULL,
    deadline date  NOT NULL CHECK (deadline > '2000-01-01'),
    CONSTRAINT task_pk PRIMARY KEY (taskID)
);

-- Table: task_issue
CREATE TABLE task_issue (
    taskIssueID int  NOT NULL,
    taskID int  NOT NULL,
    typeIssueTaskID int  NOT NULL,
    description varchar(255)  NOT NULL,
    reportedDate date  NOT NULL CHECK (reportedDate > '2000-01-01'), -- Check if it later then 1st January 2000
    resolveDate date  NULL,
    CONSTRAINT task_issue_pk PRIMARY KEY (taskIssueID)
);

-- Table: type_of_donor
CREATE TABLE type_of_donor (
    typeDonorID int  NOT NULL,
    name varchar(50)  NOT NULL,
    CONSTRAINT type_of_donor_pk PRIMARY KEY (typeDonorID)
);

-- Table: type_of_event
CREATE TABLE type_of_event (
    typeEventID int  NOT NULL,
    name varchar(50)  NOT NULL,
    CONSTRAINT type_of_event_pk PRIMARY KEY (typeEventID)
);

-- Table: type_of_issue_event
CREATE TABLE type_of_issue_event (
    typeIssueEventID int  NOT NULL,
    name varchar(50)  NOT NULL,
    CONSTRAINT type_of_issue_event_pk PRIMARY KEY (typeIssueEventID)
);

-- Table: type_of_issue_survey
CREATE TABLE type_of_issue_survey (
    typeIssueSurveyID int  NOT NULL,
    name varchar(50)  NOT NULL,
    CONSTRAINT type_of_issue_survey_pk PRIMARY KEY (typeIssueSurveyID)
);

-- Table: type_of_issue_task
CREATE TABLE type_of_issue_task (
    typeIssueTaskID int  NOT NULL,
    name varchar(50)  NOT NULL,
    CONSTRAINT type_of_issue_task_pk PRIMARY KEY (typeIssueTaskID)
);

-- Table: volunteer
CREATE TABLE volunteer (
    volunteerID int  NOT NULL,
    name varchar(50)  NOT NULL,
    surname varchar(50)  NOT NULL,
    contacInfoID int  NOT NULL,
    CONSTRAINT volunteer_pk PRIMARY KEY (volunteerID)
);

-- Table: volunteer_task
CREATE TABLE volunteer_task (
    volunteerID int  NOT NULL,
    taskID int  NOT NULL,
    roleID int  NOT NULL,
    CONSTRAINT volunteer_task_pk PRIMARY KEY (volunteerID,taskID,roleID)
);

-- Table: voter
CREATE TABLE voter (
    voterID int NOT NULL,
    name varchar(50) NOT NULL,
    surname varchar(50) NULL, -- Can be null, maybe someone don't want to give such information
    sex char(1) CHECK (sex IN ('M', 'F', 'O')), -- Check for specific values (M, F, O)
    age int DEFAULT 18 NOT NULL CHECK (age > 0), -- Check for non-negative value, and default by 18
    CONSTRAINT voter_pk PRIMARY KEY (voterID)
);

-- foreign keys
-- Reference: Table_36_event (table: event_issue)
ALTER TABLE event_issue ADD CONSTRAINT Table_36_event
    FOREIGN KEY (eventID)
    REFERENCES event (eventID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Table_36_type_of_issue_event (table: event_issue)
ALTER TABLE event_issue ADD CONSTRAINT Table_36_type_of_issue_event
    FOREIGN KEY (typeIssueEventID)
    REFERENCES type_of_issue_event (typeIssueEventID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: contribution_donor (table: contribution)
ALTER TABLE contribution ADD CONSTRAINT contribution_donor
    FOREIGN KEY (donorID)
    REFERENCES donor (donorID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: contribution_finance (table: contribution)
ALTER TABLE contribution ADD CONSTRAINT contribution_finance
    FOREIGN KEY (financeID)
    REFERENCES finance (financeID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: donor_type_of_donor (table: donor)
ALTER TABLE donor ADD CONSTRAINT donor_type_of_donor
    FOREIGN KEY (typeDonorID)
    REFERENCES type_of_donor (typeDonorID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: event_type_of_event (table: event)
ALTER TABLE event ADD CONSTRAINT event_type_of_event
    FOREIGN KEY (typeEventID)
    REFERENCES type_of_event (typeEventID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: finance_event_event (table: finance_event)
ALTER TABLE finance_event ADD CONSTRAINT finance_event_event
    FOREIGN KEY (eventID)
    REFERENCES event (eventID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: finance_event_finance (table: finance_event)
ALTER TABLE finance_event ADD CONSTRAINT finance_event_finance
    FOREIGN KEY (financeID)
    REFERENCES finance (financeID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: finance_survey_finance (table: finance_survey)
ALTER TABLE finance_survey ADD CONSTRAINT finance_survey_finance
    FOREIGN KEY (financeID)
    REFERENCES finance (financeID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: finance_survey_survey (table: finance_survey)
ALTER TABLE finance_survey ADD CONSTRAINT finance_survey_survey
    FOREIGN KEY (surveyID)
    REFERENCES survey (surveyID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: question_survey (table: question)
ALTER TABLE question ADD CONSTRAINT question_survey
    FOREIGN KEY (surveyID)
    REFERENCES survey (surveyID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: survey_issue_survey (table: survey_issue)
ALTER TABLE survey_issue ADD CONSTRAINT survey_issue_survey
    FOREIGN KEY (surveyID)
    REFERENCES survey (surveyID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: survey_issue_type_of_issue_survey (table: survey_issue)
ALTER TABLE survey_issue ADD CONSTRAINT survey_issue_type_of_issue_survey
    FOREIGN KEY (typeIssueSurveyID)
    REFERENCES type_of_issue_survey (typeIssueSurveyID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: survey_voter_question (table: survey_voter_question)
ALTER TABLE survey_voter_question ADD CONSTRAINT survey_voter_question
    FOREIGN KEY (questionID)
    REFERENCES question (questionID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: survey_voter_survey (table: survey_voter_question)
ALTER TABLE survey_voter_question ADD CONSTRAINT survey_voter_survey
    FOREIGN KEY (surveyID)
    REFERENCES survey (surveyID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: survey_voter_voter (table: survey_voter_question)
ALTER TABLE survey_voter_question ADD CONSTRAINT survey_voter_voter
    FOREIGN KEY (voterID)
    REFERENCES voter (voterID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: task_event (table: task)
ALTER TABLE task ADD CONSTRAINT task_event
    FOREIGN KEY (eventID)
    REFERENCES event (eventID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: task_issue_task (table: task_issue)
ALTER TABLE task_issue ADD CONSTRAINT task_issue_task
    FOREIGN KEY (taskID)
    REFERENCES task (taskID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: task_issue_type_of_issue_task (table: task_issue)
ALTER TABLE task_issue ADD CONSTRAINT task_issue_type_of_issue_task
    FOREIGN KEY (typeIssueTaskID)
    REFERENCES type_of_issue_task (typeIssueTaskID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: volunteer_contact_information (table: volunteer)
ALTER TABLE volunteer ADD CONSTRAINT volunteer_contact_information
    FOREIGN KEY (contacInfoID)
    REFERENCES contact_information (contactInfoID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: volunteer_task_role (table: volunteer_task)
ALTER TABLE volunteer_task ADD CONSTRAINT volunteer_task_role
    FOREIGN KEY (roleID)
    REFERENCES role (roleID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: volunteer_task_task (table: volunteer_task)
ALTER TABLE volunteer_task ADD CONSTRAINT volunteer_task_task
    FOREIGN KEY (taskID)
    REFERENCES task (taskID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: volunteer_task_volunteer (table: volunteer_task)
ALTER TABLE volunteer_task ADD CONSTRAINT volunteer_task_volunteer
    FOREIGN KEY (volunteerID)
    REFERENCES volunteer (volunteerID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Script above was made by Vertabelo with a lot of corrections by me. Like constraints, and changes with data_types
---------------------------------------------------------------------------------------------------
-- Inserts:
INSERT INTO type_of_donor (typedonorid, name)
VALUES (1, 'Organization'), (2, 'Individual')

INSERT INTO type_of_event (typeeventid, name)
VALUES (1, 'Online Meetings'), (2, 'Celebration')

INSERT INTO type_of_issue_event (typeissueeventid, name)
VALUES (1, 'Financial'), (2, 'Organizational')

INSERT INTO type_of_issue_survey (typeissuesurveyid, name)
VALUES (1, 'Network'), (2, 'Complaint')

INSERT INTO type_of_issue_task (typeissuetaskid, name)
VALUES (1, 'Human Resources'), (2, 'Inventory')

INSERT INTO contact_information (contactinfoid, email, phone)
VALUES (1, 'shriksanka@gmail.com', '+48111232333'), (2, 'political_campaign22@gmail.com', '+1234221342')

INSERT INTO role (roleid, name)
VALUES (1, 'Manager'), (2, 'Organizator')

INSERT INTO voter (voterid, name, surname, sex, age)
VALUES (1, 'Valerii', 'Andriushchenko', 'M', 19), (2, 'Maria', 'Lewandowska', 'F', 20)

INSERT INTO donor (donorid, typeDonorID, name)
VALUES (1, 1, 'EPAM'), (2, 2, 'Alek')

INSERT INTO finance (financeid, accountDetails, totalAmount, financeDate)
VALUES (1, 'PL125778494146014794411', 2500, '2024-03-03'), (2, 'PL41891981989846468', 10000, '2023-02-01')

INSERT INTO survey (surveyid, topic)
VALUES (1, 'What a dream the best'), (2, 'We are going to the USA!')

INSERT INTO question (questionid, questionText, surveyID)
VALUES (1, 'What is your Dream?', 1), (2, 'Do you want to go to the USA?', 2)

INSERT INTO event (eventid, typeEventID, eventDate, location)
VALUES (1, 1, '2024-02-26', 'Zoom, Code: 151155sSAa'), (2, 2, '2025-01-01', 'Warsaw, Koszykowa 86')

INSERT INTO task (taskid, eventID, taskDescription, deadline)
VALUES (1, 1, 'Make a good connection with all of volunteers', '2024-02-23'), (2, 2, 'Make a book in this restaurant for 2025-01-01', '2024-12-12')

INSERT INTO volunteer (volunteerid, name, surname, contacInfoID)
VALUES (1, 'Valerii', 'Andriushchenko', 1), (2, 'Maksim', 'Ivanov', 2)

INSERT INTO survey_issue (surveyid, typeIssueSurveyID, description, reportedDate)
VALUES (1, 1, 'We have a bad network tonight - and thats why we cannot prepare for survey!', '2024-02-02'), (2, 2, 'There some problems with humans, near us, can we have a guardians', '2024-02-02')

INSERT INTO survey_voter_question (voterID, surveyID, questionID)
VALUES (1, 1, 1), (2, 1, 2)

INSERT INTO contribution (contributionid, donorID, financeID, amount, contributionDate)
VALUES (1, 1, 1, 100, '2024-02-02'), (2, 2, 1, 2000, '2024-03-03')

INSERT INTO finance_survey (financesurveyid, financeID, surveyID, amountSpent, details)
VALUES (1, 1, 1, 100, 'Bought a provider'), (2, 2, 2, 200, 'Spent all money on psycholog')

INSERT INTO finance_event (financeeventid, financeID, eventID, amountSpent, details)
VALUES (1, 1, 1, 2000, 'On alcohol'), (2, 2, 2, 120, 'Take a taxi')

INSERT INTO event_issue (eventissueid, eventID, typeIssueEventID, description, reportedDate)
VALUES (1, 1, 1, 'We didnt have access to our payment cards', '2024-01-02'), (2, 2, 1, 'There was no money on our cards!', '2024-01-12')

INSERT INTO task_issue (taskissueid, taskID, typeIssueTaskID, description, reportedDate)
VALUES (1, 1, 1, 'Some of errors were showed, when we tried to repair it', '2024-01-08'), (2, 2, 1, 'There was no option, to resolve such problem', '2024-01-02')

INSERT INTO volunteer_task (volunteerID, taskID, roleID)
VALUES (1, 1, 1), (2, 2, 2)

-------------------------------------------------------------------------------------------------
-- Task 7th:
ALTER TABLE contact_information
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE contact_information
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE contribution
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE contribution
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE donor
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE donor
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE event
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE event
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE event_issue
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE event_issue
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE finance
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE finance
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE finance_event
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE finance_event
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE finance_survey
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE finance_survey
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE question
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE question
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE role
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE role
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE survey
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE survey
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE survey_issue
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE survey_issue
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE survey_voter_question
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE survey_voter_question
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE task
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE task
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE task_issue
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE task_issue
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE type_of_donor
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE type_of_donor
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE type_of_event
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE type_of_event
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE type_of_issue_survey
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE type_of_issue_survey
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE type_of_issue_task
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE type_of_issue_task
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE volunteer
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE volunteer
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE volunteer_task
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE volunteer_task
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;

ALTER TABLE voter
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

UPDATE voter
SET record_ts = CURRENT_DATE
WHERE record_ts IS NULL;
