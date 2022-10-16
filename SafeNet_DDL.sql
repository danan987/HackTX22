------------------------------------------------------------------------------
--------- SAFENET DATA TABLE CREATION
------------------------------------------------------------------------------
-- COMMENTS:
--  ORDER -> (1) DROP tables, (2) CREATE Tables, (3) INDEX tables, (4) INSERT Data
--  build tables with foreign keys first - need to reference when building other tables later on
--  recommended -> create sequence after building table to better organize
--  FK are UNIQUE 
--  PK - don't need to specify NOT NULL for primary key columns, they are set automatically to NOT NULL.
------------------------------------------------------------------------------
---------DROP SEQUENCE/TABLE SECTION
-- dropping all tables/sequences in proper order 
------------------------------------------------------------------------------
DROP TABLE Clientele;
DROP TABLE Clientele_Date_Linking;
DROP TABLE Arrangement;
DROP TABLE Romantic_Interest;
DROP TABLE Clientele_Contact_Linking;
DROP TABLE Contact;
DROP TABLE Clientele_User_Address;
DROP TABLE Address; 

DROP SEQUENCE Clientele ;
DROP SEQUENCE Clientele_Date_Linking;
DROP SEQUENCE Arrangement;
DROP SEQUENCE Romantic_Interest;
DROP SEQUENCE Clientele_Contact_Linking;
DROP SEQUENCE Contact;
DROP SEQUENCE Clientele_User_Address;
DROP SEQUENCE Address; 

--DROP any sequences
BEGIN
  --Deletes all user created sequences
  FOR i IN (SELECT us.sequence_name FROM USER_SEQUENCES us) LOOP
    EXECUTE IMMEDIATE 'drop sequence '|| i.sequence_name ||'';
  END LOOP;

END;
/



--DROP ETL Tables
--Final reminder to check for remaining tables for manual dropping
SET SERVEROUT ON;
CLEAR SCREEN;

BEGIN
dbms_output.put_line ('Script is complete');
dbms_output.put_line ('NOTE: Refresh your left-hand menu to confirm all tables are gone.');
dbms_output.put_line ('If tables still exist...write statements to drop these manually');
END;



------------------------------------------------------------------------------
--DROP INDEX SECTION
--drops all indexes so remaking tables is possible 
drop index section_course_ix;
drop index section_instructor_ix;
drop index section_room_ix;
drop index student_last_ix;
drop index course_code_ix;


--DROP SEQUENCE SECTION
--drops all sequences so remaking tables is possible 
drop sequence address_id_sq;
drop sequence course_id_sq;
drop sequence room_id_sq;
drop sequence section_id_sq;


--DROP TABLE SECTION
--drops all tables so remaking is possible 
drop table clientele;
drop table enrollment;
drop table major_student_linking;
drop table student_address_linking;
drop table section;
drop table major;
drop table student;
drop table address;
drop table teacher;
drop table course;
drop table room;


--CREATE SEQUENCE SECTION
--creates sequences that start at 1 and increment by 1
CREATE SEQUENCE address_id_sq;
CREATE SEQUENCE course_id_sq;
CREATE SEQUENCE room_id_sq;
CREATE SEQUENCE section_id_sq;

------------------------------------------------------------------------------
---------CREATE SEQUENCE/TABLES SECTION
-- establishing tables from the ERD solution 
------------------------------------------------------------------------------
-- TABLE: CLIENTELE
-- UNIQUE = Email

CREATE TABLE Clientele (
    clientele_ID        VARCHAR(10)     PRIMARY KEY,
    first_name          VARCHAR(20)     NOT NULL,
    middle_name         VARCHAR(20),
    last_name           VARCHAR(20)     NOT NULL,
    date_of_birth       DATE            NOT NULL,
    email               VARCHAR(20)     NOT NULL    UNIQUE,
    phone               CHAR(12)        NOT NULL,
    CONSTRAINT email_length_check CHECK (LENGTH(email)>=7)
);

SELECT *
FROM clientele;

------------------------------------------------------------------------------
-- TABLE: CLIENTELE
-- UNIQUE = Email

--creates a table to contain major info
CREATE TABLE contact (
    contact_ID          VARCHAR(10)     PRIMARY KEY,
    first_name          VARCHAR(20)     NOT NULL,
    middle_name         VARCHAR(20),
    last_name           VARCHAR(20)     NOT NULL,
    date_of_birth       DATE            NOT NULL,
    phone               CHAR(12)        NOT NULL
);

SELECT *
FROM contact;


--creates a table to contain addreses
CREATE TABLE address (
    address_id      NUMBER(10)      DEFAULT address_id_sq.NEXTVAL    PRIMARY KEY,
    address_line_1  VARCHAR(20)     NOT NULL,
    address_line_2  VARCHAR(20),
    city            VARCHAR(20)     NOT NULL,
    state_region    CHAR(2)         NOT NULL,
    zip_postal_code CHAR(5)         NOT NULL,
    country         VARCHAR(20)     NOT NULL
);


--creates a table to contain teacher info
CREATE TABLE romantic_interest (
    romantic_id             VARCHAR(10) PRIMARY KEY,
    first_name              VARCHAR(20) NOT NULL,
    last_name               VARCHAR(20) NOT NULL,
    dating_application      VARCHAR(20) NOT NULL,
    primary_title           VARCHAR(20) NOT NULL,
    romantic_phone          CHAR(12)    NOT NULL,
    email                   VARCHAR(20) NOT NULL UNIQUE,
    romantic_location       VARCHAR(20) NOT NULL,
    romantic_address_1      VARCHAR(20) NOT NULL,
    romantic_city           VARCHAR(20) NOT NULL,
    romantic_state          CHAR(2)     NOT NULL,
    romantic_zip            CHAR(5)     NOT NULL,
    campus_mail_code        CHAR(5)     NOT NULL
);


--creates a table to contain course info
CREATE TABLE course (
    course_id           NUMBER(10)  DEFAULT course_id_sq.NEXTVAL   PRIMARY KEY,
    course_code         VARCHAR(20) NOT NULL,
    course_name         VARCHAR(20) NOT NULL,
    course_description  VARCHAR(100) NOT NULL
);



--creates a table to contain room info 
CREATE TABLE room (
    room_id         NUMBER(10)  DEFAULT room_id_sq.NEXTVAL   PRIMARY KEY,
    building_code   CHAR(3)     NOT NULL,
    floor_number    VARCHAR(2)  NOT NULL,
    room_number     VARCHAR(5)  NOT NULL,
    max_seats       VARCHAR(5)  NOT NULL
);



--creates a table to link contact and clinetele tables
CREATE TABLE contact_clientele_linking (
    contact_id      VARCHAR(10)     REFERENCES contact(contact_id),
    clientele_id    VARCHAR(10)     REFERENCES clientele(clientele_id),
    date_declared   DATE            DEFAULT SYSDATE NOT NULL,
    CONSTRAINT contact_clientele_pk PRIMARY KEY (contact_id, clientele_id)
);



--creates a table to link clientele to addresses
CREATE TABLE clientele_address_linking (
    clientele_id            VARCHAR(10)     REFERENCES student(clientele_id),
    address_id              NUMBER(20)      REFERENCES
    address(address_id),
    address_type_code       CHAR(1)         NOT NULL,
    CONSTRAINT clientele_address_pk         PRIMARY KEY (clientele_id, address_id, address_type_code),
    CONSTRAINT address_ck   CHECK (address_type_code='H' 
                            OR address_type_code='L' 
                            OR address_type_code='O')
);



--creates a table for course arrangement 
CREATE TABLE arrangement (
    arrangement_id      NUMBER(30)   DEFAULT arrangement_id_sq.NEXTVAL  PRIMARY KEY,
    clientele_id        VARCHAR(10)  NOT NULL,
    semester_code       CHAR(4) NOT NULL,
    selected_days        VARCHAR(10),
    starting_hour       NUMBER(10),
    length_minutes      NUMBER(10),
    status              CHAR(1) DEFAULT 'O' NOT NULL,
    CONSTRAINT unique_semester_un UNIQUE (unique_number, semester_code),
    CONSTRAINT status_ck CHECK (status='O' OR status='W' OR
    status='C' OR status='X')
REFERENCES course(course_id),
    romantic_id         VARCHAR(10)
REFERENCES teacher(instructor_uteid),
    room_id             NUMBER(10)
);


--creates a table to link students to sections
CREATE TABLE enrollment (
    clientele_id        VARCHAR(10) REFERENCES student(uteid),
    arrangement_id      NUMBER(10) REFERENCES   arrangement(arrangement_id),
    grade_code          VARCHAR(5),
    CONSTRAINT enrollment_pk PRIMARY KEY (clientele_id, arrangement_id),
    CONSTRAINT grade_ck CHECK (grade_code='A' OR grade_code='A-' OR
    grade_code='B+' OR grade_code='B'   OR grade_code='B-'  OR
    grade_code='C+' OR grade_code='C'   OR
    grade_code='C-' OR grade_code='D+'  OR grade_code='D'   OR
    grade_code='D-' OR grade_code='F'   OR
    grade_code='P'  OR grade_code='W'   OR grade_code='Q'   OR grade_code='X')
);

--SEED DATA SECTION
--creates two students 
INSERT INTO clientele
VALUES ('nyl243', 'dana', 'kim', 'nguyen-phan', '04-FEB-2002', '2',
'dananp@utexas.edu', '281-827-2217', 'B', 'N', 3.97);
INSERT INTO clientele
VALUES ('oop123', 'oop', 'ooq', 'oo', '10-OCT-2010', '1',
'oop123@utexas.edu', '000-111-0000', 'B', 'Y', 4.00);
COMMIT;

--creates four addresses - 
INSERT INTO address
VALUES (1, '17826 Hillegeist', '', 'Tomball', 'TX', '77377', 'USA');
INSERT INTO address
VALUES (2, '2008 San Ant', '#204', 'Austin', 'TX', '77377', 'USA');
INSERT INTO address
VALUES (3, '1001 Oopy', '', 'Austin', 'TX', '78705', 'USA');
INSERT INTO address
VALUES (4, '2001 Ooqy', '#201', 'Austin', 'TX', '78705', 'USA');
COMMIT;


--assigns addresses to students - 
INSERT INTO student_address_linking
VALUES ('nyl243', 1, 'H');
INSERT INTO student_address_linking
VALUES ('nyl243', 2, 'L');
INSERT INTO student_address_linking
VALUES ('oop123', 3, 'H');
INSERT INTO student_address_linking
VALUES ('oop123', 4, 'L');
COMMIT;


--creates three majors
INSERT INTO major
VALUES (1, 'ACC', 'Accounting');
INSERT INTO major
VALUES (2, 'FIN', 'Finance');
INSERT INTO major
VALUES (3, 'ECO', 'Economics');
COMMIT;

--assigns majors to students
INSERT INTO major_student_linking (major_id, uteid)
VALUES (1, 'nyl243');
INSERT INTO major_student_linking (major_id, uteid)
VALUES (2, 'oop123');
INSERT INTO major_student_linking (major_id, uteid)
VALUES (3, 'oop123');
COMMIT;


--creates two courses 
INSERT INTO course
VALUES (1, 'MIS301', 'INTRO TO MIS', 'Beginner steps into MIS');
INSERT INTO course
VALUES (2, 'MIS325', 'INTRO TO DATABASE', 'Beginner steps into managing
databases');
COMMIT;


--creates two teachers
INSERT INTO romantic_interest
VALUES ('prof101', 'jane', 'doe', 'MIS', 'Associate Prof', '101-101-1001',
'jane@utexas.edu', 'Speedway', '101 Speedway', '', 'Austin', 'TX',
'78705', 'S1001');
INSERT INTO romantic_interest
VALUES ('prof102', 'john', 'doe', 'MIS', 'Professor', '102-102-1002',
'john@utexas.edu', 'McCombs', '101 McCombs', '', 'Austin', 'TX', '78705',
'M1002');
COMMIT;


--creates two rooms 
INSERT INTO room
VALUES (1, 'CBA', '2', '2.01', '50');
INSERT INTO room
VALUES (2, 'GSB', '3', '3.02', '40');
COMMIT;


--creates three sections for each course
INSERT INTO arrangement
VALUES (1, 1, 'prof101', 1, 10005, 'FA22', 'MW', 0930, 60, 'F', 30, 'O');
INSERT INTO arrangement
VALUES (2, 1, 'prof101', 1, 10006, 'FA22', 'MW', 1030, 60, 'F', 30, 'O');
INSERT INTO section

VALUES (3, 1, 'prof102', 1, 10007, 'FA22', 'MWF', 1130, 90, 'F', 45, 'O');
INSERT INTO arrangement
VALUES (4, 2, 'prof102', 1, 10008, 'FA22', 'TTH', 0800, 90, 'H', 25, 'O');
INSERT INTO arrangement
VALUES (5, 2, NULL, NULL, 10009, 'FA22', NULL, NULL, NULL, 'O', 100, 'O');
INSERT INTO arrangement
VALUES (6, 2, NULL, NULL, 10010, 'FA22', NULL, NULL, NULL, 'O', 105, 'O');
COMMIT;


--enrolls students into diff sections of two courses 
INSERT INTO enrollment
VALUES ('nyl243', 1, NULL);
INSERT INTO enrollment
VALUES ('nyl243', 4, NULL);
INSERT INTO enrollment
VALUES ('oop123', 2, NULL);
INSERT INTO enrollment
VALUES ('oop123', 5, NULL);
COMMIT;


--CREATE INDEX SECTION
--creates indexes on foreign keys
CREATE INDEX section_course_ix      ON section(course_id);
CREATE INDEX section_instructor_ix  ON section(instructor_uteid);
CREATE INDEX section_room_ix        ON section(room_id);

--creates indexes on columns frequently used in searches
CREATE INDEX student_last_ix        ON student(last_name);
CREATE INDEX course_code_ix         ON course(course_code);
COMMIT;