-- MUSEUM DATABASE
DROP DATABASE IF EXISTS MUSEUM;
CREATE DATABASE MUSEUM;
USE MUSEUM;

-- ARTIST TABLE --
DROP TABLE IF EXISTS ARTIST;
CREATE TABLE ARTIST (
    A_name			    varchar(50)     not null,
    Date_born           date,
	Date_died           date,
    Country_of_origin   varchar(60)     not null,
    Epoch			    varchar(50)     not null,
    Style               varchar(50)     not null,
    Artist_Descr        varchar(150),

	PRIMARY KEY (A_name),
    CHECK (Date_born >= Date_born)
);

INSERT INTO ARTIST (A_name, Date_born, Date_died, Country_of_origin, Epoch, Style, Artist_Descr)
VALUES
('Quentin Metsys the Younger', '1543-01-01', '1589-01-01', 'London', 'Renaissance', 'Oil', NULL),
('Benedetto da Rovezzano', '1474-01-01', '1552-01-01', 'Florence', 'Renaissance', 'Sculpting with Marble', NULL);
-- end artist

-- COLLECTIONS TABLE --
DROP TABLE IF EXISTS COLLECTIONS;
CREATE TABLE COLLECTIONS (
    C_name			    varchar(50)     not null,
    C_type              varchar(20)     not null,
	C_descr             varchar(150)    not null,
    C_address           varchar(30)     not null,
    Phone			    varchar(15)     not null,
    Contact_Person      varchar(30)     not null,

	PRIMARY KEY (C_name)
);

INSERT INTO COLLECTIONS (C_name, C_type, C_descr, C_address, Phone, Contact_Person)
VALUES
('Special', 'Old', 'Old artifacts from Europe', '100 alley way NW', '302-403-4005','Micheal Vore'),
('Nice antiquity', 'Renaissance', 'Old artifacts from italian artists', '200 alley way NW', '304-403-4005','Horice Kind'),
('Out of the Ordinary', 'King', 'Old artifacts from Kings in Europe', '400 alley way NW', '302-203-4005','George King');
-- end collections

-- EXHIBITIONS TABLE --
DROP TABLE IF EXISTS EXHIBITIONS;
CREATE TABLE EXHIBITIONS (
    E_name			    varchar(50)     not null,
    E_start_date        date,
	E_end_date          date,

	PRIMARY KEY (E_name),
    CHECK(E_end_date >= E_start_date)
);

INSERT INTO EXHIBITIONS (E_name, E_start_date, E_end_Date)
VALUES
('King George Memorial', '2022-01-10','2022-01-20'),
('Britains Celebration', '2022-01-29','2022-02-3');
-- end exhibitions

-- ART OBJECT TABLE --
DROP TABLE IF EXISTS ART_OBJECT;
CREATE TABLE ART_OBJECT (
	Id_no			    varchar(10)     not null,
    Artist_name         varchar(50),
    Year_created        integer,
	Title			    varchar(50)     not null,
    Art_descr           varchar(150)    not null,
    Origin              varchar(60)     not null,
    Epoch			    varchar(50)     not null,
    Art_type            varchar(50),
    Collection_type     varchar(9)      not null,
    Style               varchar(50)     not null,

	PRIMARY KEY (Id_no),
    FOREIGN KEY (Artist_name) REFERENCES ARTIST (A_name),
                ON DELETE SET NULL  ON UPDATE CASCADE
);

INSERT INTO ART_OBJECT (Id_no, Artist_name, Year_created, Title, Art_descr, Origin, Epoch, Art_type, Collection_type, Style)
VALUES
('T2022_001', NULL, 1505, 'On view at The Met Fifth Avenue', 'Henry VII',  'Netherlandish', 'Late Middle Age', 'painting', 'permanent', 'Oil on canvas'),
('T2022_002', 'Benedetto da Rovezzano', 1583, 'Elizabeth I ("The Sieve Portrait")', ' ', 'British', 'Medieval', 'painting', 'borrowed', 'Oil on paper'),
('T2022_003', 'Quentin Metsys the Younger', 1524, 'Angel Bearing Candlestick', 'A great piece of art made a long time ago', 'European', 'Medieval', 'sculpture', 'permanent', 'Statue Style'),
('T2022_004', NULL,  1505, 'John the Evangelist', 'Statue covered rusted and worn out', 'European', 'Medieval', 'statue', 'borrowed', 'Statue style'),
('T2022_005', 'Quentin Metsys the Younger', 1500, 'Candelabrum', 'A candle', 'European', 'Late Middle Age', 'other', 'borrowed', 'Medieval style'),
('T2022_006', NULL, 1544, 'Field Armor of King Henry VIII of England', 'This impressive armor was made for Henry VIII (reigned 1509 to 47) toward the end of his life, when he was overweight and crippled with gout.', 'Italian', 'Medieval', 'other', 'permanent', 'Italian');

-- ART OBJECT COLLECTION TYPES --

-- PERMANENT_COLLECTION
DROP TABLE IF EXISTS PERMANENT_COLLECTION;
CREATE TABLE PERMANENT_COLLECTION (
    art_Id_no           varchar(10)     not null,
    Date_aquired        date            not null,
    PC_status           varchar(10)      not null,

	PRIMARY KEY (art_Id_no),
    FOREIGN KEY (art_Id_no) REFERENCES ART_OBJECT (Id_no)
);
INSERT INTO PERMANENT_COLLECTION(art_Id_no, Date_aquired, PC_status)
VALUES
('T2022_001', '2019-01-01', 'On display'),
('T2022_003', '2020-02-03', 'On loan'),
('T2022_006', '2022-01-02', 'Stored');

-- BORROWED_COLLECTION
DROP TABLE IF EXISTS BORROWED_COLLECTION;
CREATE TABLE BORROWED_COLLECTION (
    art_Id_no           varchar(10)     not null,
    Collection_name     varchar(50)     not null,
    Date_borrowed       date            not null,
    Date_returned       date,
    PC_status           varchar(10)      not null,

	PRIMARY KEY (art_Id_no),
    FOREIGN KEY (art_Id_no) REFERENCES ART_OBJECT (Id_no),
    FOREIGN KEY (Collection_name) REFERENCES COLLECTIONS (C_name),
    CHECK(Date_returned >= Date_borrowed)
);

INSERT INTO BORROWED_COLLECTION(art_Id_no, Collection_name, Date_borrowed, Date_returned, PC_status)
VALUES
('T2022_002', 'Special', '2018-05-01', NULL, 'On display'),
('T2022_004', 'Nice antiquity', '2019-04-03', '2020-01-01', 'On display'),
('T2022_005', 'Out of the Ordinary', '2019-04-04', NULL, 'Stored');

-- ART OBJECT TYPES --

-- PAINTING
DROP TABLE IF EXISTS PAINTING;
CREATE TABLE PAINTING (
    art_Id_no           varchar(10)     not null,
    Paint_type          varchar(20)     not null,
    Drawn_on            varchar(20)     not null,

	PRIMARY KEY (art_Id_no),
    FOREIGN KEY (art_Id_no) REFERENCES ART_OBJECT (Id_no)
);

INSERT INTO PAINTING(art_Id_no, Paint_type, Drawn_on)
VALUES
('T2022_001', 'Oil', 'Canvas'),
('T2022_002', 'Oil', 'Paper');

-- SCULPTURE
DROP TABLE IF EXISTS SCULPTURE;
CREATE TABLE SCULPTURE (
	art_Id_no           varchar(10)     not null,
    Sculpture_material  varchar(20)     not null,
    Sculpture_weight    real            not null,
    Sculpture_height    real            not null,

	PRIMARY KEY (art_Id_no),
    FOREIGN KEY (art_Id_no) REFERENCES ART_OBJECT (Id_no)
);

INSERT INTO SCULPTURE (art_Id_no, Sculpture_material, Sculpture_weight, Sculpture_height)
VALUES
('T2022_003', 'Bronze', 15, 40);

-- STATUE
DROP TABLE IF EXISTS STATUE;
CREATE TABLE STATUE (
	art_Id_no           varchar(10)     not null,
    Statue_material     varchar(20)     not null,
    Statue_weight       real            not null,
    Statue_height       real            not null,

	PRIMARY KEY (art_Id_no),
    FOREIGN KEY (art_Id_no) REFERENCES ART_OBJECT  (Id_no)
);

INSERT INTO SCULPTURE (art_Id_no, Sculpture_material, Sculpture_weight, Sculpture_height)
VALUES
('T2022_004', 'Clay', 60, 150);

-- OTHER
DROP TABLE IF EXISTS OTHER;
CREATE TABLE OTHER (
	art_Id_no           varchar(10)     not null,
    Other_type          varchar(20)     not null,

	PRIMARY KEY (art_Id_no),
    FOREIGN KEY (art_Id_no) REFERENCES ART_OBJECT (Id_no)
);

INSERT INTO OTHER (art_Id_no, Other_type)
VALUES
('T2022_005', 'Candle'),
('T2022_006', 'Armour');
-- end art_object

-- DISPLAYED_IN TABLE --
DROP TABLE IF EXISTS DISPLAYED_IN;
CREATE TABLE DISPLAYED_IN (
    art_Id_no           varchar(10)     not null,
    Exhibition_name	    varchar(50)     not null,

	PRIMARY KEY (art_Id_no, Exhibition_name),
    FOREIGN KEY (art_Id_no) REFERENCES ART_OBJECT (Id_no),
    FOREIGN KEY (Exhibition_name) REFERENCES EXHIBITIONS (E_name)
);

INSERT INTO DISPLAYED_IN (art_Id_no, Exhibition_name)
VALUES
('T2022_002', 'King George Memorial'),
('T2022_005', 'Britains Celebration');
-- end displayed_in


-- DELETION TRIGGERS --

-- (if exhibition isn't deleted)
-- 1 - Relationship between art_object and exhibitions
-- After deletion of exhibition in exhibitions, remove all matching exhibitions (with art objects)
-- from relationship displayed_in
DELIMITER //
DROP TRIGGER IF EXISTS remove_art_object_from_deleted_exhibition;
CREATE TRIGGER remove_art_object_from_deleted_exhibition
BEFORE DELETE ON EXHIBITIONS
FOR EACH ROW
BEGIN
    DELETE  FROM DISPLAYED_IN
            WHERE Exhibition_name = OLD.E_name;
END;
//
DELIMITER ;

-- 2 - Relationship between borrowed_collection and collections
-- after deletion of collection from collections, delete entire borrowed collection
DELIMITER //
DROP TRIGGER IF EXISTS delete_borrowed_collection_on_collection_delete;
CREATE TRIGGER delete_borrowed_collection_on_collection_delete
AFTER DELETE ON COLLECTIONS
FOR EACH ROW
BEGIN
    DELETE  FROM BORROWED_COLLECTION
            WHERE Collection_name = OLD.C_name;
    UPDATE ART_OBJECT
    SET Collection_type = 'not_known'
    WHERE Collection_type = OLD.C_name;
END;
//
DELIMITER ;

-- (if exhibition is deleted)
-- 3 - Relationship between art_object and exhibitions
-- after deletion of art object, remove matching art object from exhibition from displayed_in
DELIMITER //
DROP TRIGGER IF EXISTS remove_art_object_from_exhibition_when_deleted;
CREATE TRIGGER remove_art_object_from_exhibition_when_deleted
AFTER DELETE ON ART_OBJECT
FOR EACH ROW
BEGIN
    DELETE  FROM DISPLAYED_IN
            WHERE art_Id_no = OLD.Id_no;
END;
//
DELIMITER ;

-- 4 - art_object specializations
-- after delete of art object, remove all occurances of tuples matching art object id from
-- permanent_collection, borrowed_collection, painting, sculpture, statue, other relations
DELIMITER //
DROP TRIGGER IF EXISTS delete_art_object_specializations;
CREATE TRIGGER delete_art_object_specializations
AFTER DELETE ON ART_OBJECT
FOR EACH ROW
BEGIN
    DELETE FROM PERMANENT_COLLECTION WHERE art_Id_no = OLD.Id_no;
    DELETE FROM BORROWED_COLLECTION WHERE art_Id_no = OLD.Id_no;
    DELETE FROM PAINTING WHERE art_Id_no = OLD.Id_no;
    DELETE FROM SCULPTURE WHERE art_Id_no = OLD.Id_no;
    DELETE FROM STATUE WHERE art_Id_no = OLD.Id_no;
    DELETE FROM OTHER WHERE art_Id_no = OLD.Id_no;
END;
//
DELIMITER ;

-- CREATING USERS AND ROLES --

-- ROLES
DROP ROLE IF EXISTS db_admin@localhost, employee@localhost, guest_usr@localhost;
CREATE ROLE db_admin@localhost, employee@localhost, guest_usr@localhost;

-- ROLE PRIVILEGES
-- Admin
GRANT ALL PRIVILEGES ON MUSEUM.* TO db_admin@localhost;

-- Employee
GRANT SELECT ON MUSEUM.* TO employee@localhost;
GRANT INSERT ON MUSEUM.* TO employee@localhost;
GRANT UPDATE ON MUSEUM.* TO employee@localhost;
GRANT DELETE ON MUSEUM.* TO employee@localhost;

-- Guest
GRANT SELECT ON MUSEUM.* TO guest_usr@localhost;


-- DEFAULT USERS
-- Admin
DROP USER IF EXISTS museum_admin@localhost;
CREATE USER museum_admin@localhost IDENTIFIED WITH mysql_native_password BY 'password';
GRANT db_admin@localhost TO museum_admin@localhost;
SET DEFAULT ROLE ALL TO museum_admin@localhost;

-- Employee
DROP USER IF EXISTS john@localhost;
CREATE USER john@localhost IDENTIFIED WITH mysql_native_password BY 'john';
GRANT employee@localhost TO john@localhost;
SET DEFAULT ROLE ALL TO john@localhost;

-- Guest
DROP USER IF EXISTS guest@localhost;
CREATE USER guest@localhost;
GRANT guest_usr@localhost TO guest@localhost;
SET DEFAULT ROLE ALL TO guest@localhost;


-- USERS --
CREATE TABLE USERS (
    Username VARCHAR(50) PRIMARY KEY,
    Usr_password VARCHAR(255),
    Usr_status ENUM('active', 'blocked', 'suspended') DEFAULT 'active'
);

INSERT INTO USERS (Username, Usr_password, Usr_status)
VALUES
('museum_admin', 'password', 'active'),
('john', 'john', 'active'),
('guest', NULL, 'active');
-- end users

