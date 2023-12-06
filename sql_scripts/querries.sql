USE MUSEUM;

-- UPDATE TRIGGER --

-- Track history of changes to the title and description of art_object
DELIMITER //
CREATE TRIGGER track_art_object_changes
BEFORE UPDATE ON ART_OBJECT
FOR EACH ROW
BEGIN
    IF OLD.Title <> NEW.Title OR OLD.Art_descr <> NEW.Art_descr THEN
        INSERT INTO HISTORY_OF_ART_OBJECT_CHANGES (art_Id_no, old_title, new_title, old_description, new_description, change_timestamp)
        VALUES (NEW.Id_no, OLD.Title, NEW.Title, OLD.Art_descr, NEW.Art_descr, NOW());
    END IF;
END;
//
DELIMITER ;

-- DELETION TRIGGERS --

-- (if exhibition isn't deleted)
-- 1 - Relationship between art_object and exhibitions
-- After deletion of exhibition in exhibitions, remove all matching exhibitions (with art objects)
-- from relationship displayed_in
DELIMITER //
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
CREATE TRIGGER delete_borrowed_collection_on_collection_delete
AFTER DELETE ON COLLECTIONS
FOR EACH ROW
BEGIN
    DELETE  FROM BORROWED_COLLECTION
            WHERE Collection_name = OLD.C_name;
END;
//
DELIMITER ;

-- (if exhibition is deleted)
-- 3 - Relationship between art_object and exhibitions
-- after deletion of art object, remove matching art object from exhibition from displayed_in
DELIMITER //
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

-- Describe tables and relationships
DESCRIBE ARTIST;
DESCRIBE COLLECTIONS;
DESCRIBE EXHIBITIONS;
DESCRIBE ART_OBJECT;
DESCRIBE PERMANENT_COLLECTION;
DESCRIBE BORROWED_COLLECTION;
DESCRIBE PAINTING;
DESCRIBE SCULPTURE;
DESCRIBE STATUE;
DESCRIBE OTHER;
DESCRIBE DISPLAYED_IN;

-- Show foreign key relationships
SHOW CREATE TABLE ART_OBJECT; -- This will display the foreign key relationships of ART_OBJECT table

-- Basic retrieval query
SELECT * FROM ART_OBJECT;

-- Retrieval query with ordered results
SELECT * FROM ART_OBJECT ORDER BY Year_created DESC;

-- Nested retrieval query
SELECT * FROM ARTIST WHERE A_name IN (SELECT Artist_name FROM ART_OBJECT);

-- Retrieval query using joined tables
SELECT ART_OBJECT.Id_no, ART_OBJECT.Title, ARTIST.A_name
FROM ART_OBJECT
LEFT JOIN ARTIST ON ART_OBJECT.Artist_name = ARTIST.A_name;

-- Update operation with necessary trigger
UPDATE ART_OBJECT
SET Title = 'New Title'
WHERE Id_no = 'T2022_001';
-- Trigger track_art_object_changes will be activated by this update

-- Deletion operation with necessary trigger
DELETE FROM EXHIBITIONS
WHERE E_name = 'King George Memorial';
-- Triggers remove_art_object_from_deleted_exhibition and remove_art_object_from_exhibition_when_deleted will be activated by this delete