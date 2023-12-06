CREATE FUNCTION insert_registrations() RETURNS trigger AS $insert_registrations$
    DECLARE cap INT;
    DECLARE reg INT;
    DECLARE num_waiting INT;
    BEGIN

        SELECT COUNT(*) INTO reg
             FROM Registered
             WHERE course = NEW.course;

        IF (EXISTS 
                (SELECT unlocking FROM Prerequisites WHERE (unlocked = NEW.course) 
                AND 
                unlocking NOT IN (SELECT course FROM PassedCourses WHERE (student = NEW.student))))
        THEN
            RAISE EXCEPTION 'Course prerequisites not met';
        END IF;

        IF (EXISTS (SELECT course FROM PassedCourses WHERE (course= NEW.course AND student = New.student) ))
        THEN
            RAISE EXCEPTION 'Student has already passed course';
        END IF;

        IF (NOT EXISTS (SELECT * FROM Registrations WHERE course=NEW.course AND student = New.student)) 
        THEN 

            IF (NOT EXISTS ( SELECT * FROM LimitedCourses WHERE code = NEW.course))
            THEN
                INSERT INTO Registered VALUES (New.student, New.course);

            ELSE
                SELECT capacity INTO cap FROM LimitedCourses WHERE code = NEW.course;

                IF (cap > reg)
                THEN
                    INSERT INTO Registered VALUES (New.student, New.course);

                ELSE
                    SELECT COUNT(*) INTO num_waiting FROM WaitingList WHERE course = NEW.course;
                    INSERT INTO WaitingList VALUES (New.student, New.course, num_waiting + 1);

                END IF;   
            END IF;
        ELSE
            RAISE EXCEPTION 'Student already registered or on waitinglist';
        
        END IF;

        RETURN NEW;
    END;
$insert_registrations$ LANGUAGE plpgsql;

CREATE TRIGGER insert_registrations 
    INSTEAD OF INSERT ON Registrations
    FOR EACH ROW EXECUTE PROCEDURE insert_registrations();






CREATE FUNCTION delete_registrations() RETURNS trigger AS $delete_registrations$
    DECLARE cap INT;
    DECLARE reg INT;
    DECLARE pos INT;
    DECLARE stat TEXT;
    BEGIN
        
        SELECT COUNT(*) INTO reg
             FROM Registered
             WHERE course = OLD.course;
        
        IF (EXISTS (SELECT * FROM Registrations WHERE course=OLD.course AND student = OLD.student)) 
        THEN 

            SELECT status INTO stat FROM Registrations WHERE student = OLD.student AND course = OLD.course;
            
            IF (stat = 'registered')
            THEN

                IF (NOT EXISTS (SELECT * FROM LimitedCourses WHERE code = OLD.course))
                    THEN

                    DELETE FROM Registered WHERE student = OLD.student AND course = OLD.course;
                    
                ELSE

                    DELETE FROM Registered WHERE student = OLD.student AND course = OLD.course;
                    SELECT capacity INTO cap FROM LimitedCourses WHERE code = OLD.course;

                    IF (cap > reg - 1)
                        THEN

                        INSERT INTO Registered SELECT student, course FROM WaitingList WHERE position = 1;
                        DELETE FROM WaitingList WHERE position = 1;
                        UPDATE WaitingList SET position = position-1 WHERE course = OLD.course AND position > 1;
                        
                    END IF;
                END IF;

            ELSE

                SELECT position INTO pos
                    FROM WaitingList
                    WHERE course = OLD.course AND student = OLD.student;

                DELETE FROM WaitingList WHERE student = OLD.student AND course = OLD.course;
                UPDATE WaitingList SET position = position-1 WHERE course = OLD.course AND position > pos;     
            
            END IF;
        
        ELSE
            RAISE EXCEPTION 'Not on waitinglist or registered';

        END IF;
        RETURN OLD;
    END;
$delete_registrations$ LANGUAGE plpgsql;

CREATE TRIGGER delete_registrations 
    INSTEAD OF DELETE ON Registrations
    FOR EACH ROW EXECUTE PROCEDURE delete_registrations();
