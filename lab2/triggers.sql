CREATE FUNCTION course_filled() RETURNS trigger AS $course_filled$
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
            RAISE EXCEPTION 'test2';
        END IF;

        IF (NOT EXISTS (SELECT * FROM Registrations WHERE course=NEW.course AND student = New.student)) 
        THEN 

            IF (NOT EXISTS ( SELECT * FROM LimitedCourses WHERE code = NEW.course))
            THEN
                INSERT INTO Registered VALUES (New.student, New.course);

            ELSE
                SELECT SUM(capacity) INTO cap FROM LimitedCourses WHERE code = NEW.course;

                IF (cap > reg)
                THEN
                    INSERT INTO Registered VALUES (New.student, New.course);

                ELSE
                    SELECT COUNT(*) INTO num_waiting
                        FROM WaitingList
                        WHERE course = NEW.course;

                    INSERT INTO WaitingList VALUES (New.student, New.course, num_waiting + 1);

                END IF;   
            END IF;
        ELSE
            RAISE EXCEPTION 'test1';
        
        END IF;

        RETURN NEW;
    END;
$course_filled$ LANGUAGE plpgsql;

CREATE TRIGGER course_filled  
    INSTEAD OF INSERT ON Registrations
    FOR EACH ROW EXECUTE PROCEDURE course_filled();

