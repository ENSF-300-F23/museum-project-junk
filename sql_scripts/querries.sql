USE MUSEUM;

-- UPDATE TRIGGER --
DROP TRIGGER IF EXISTS track_art_object_changes;

-- HISTORY_OF_ART_OBJECT_CHANGES table --
DROP TABLE IF EXISTS HISTORY_OF_ART_OBJECT_CHANGES;
CREATE TABLE HISTORY_OF_ART_OBJECT_CHANGES (
    change_id INT AUTO_INCREMENT PRIMARY KEY,
    art_Id_no VARCHAR(10) NOT NULL,
    old_title VARCHAR(50),
    new_title VARCHAR(50),
    old_description VARCHAR(150),
    new_description VARCHAR(150),
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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