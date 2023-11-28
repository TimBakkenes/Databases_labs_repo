CREATE FUNCTION course_filled() RETURNS trigger AS $course_filled$
    BEGIN

        IF (EXISTS (SELECT * FROM Registered WHERE course=NEW.course AND )) 
        THEN 
            RAISE EXCEPTION 'test2';
        END IF;
        RETURN NEW;
    END;
$course_filled$ LANGUAGE plpgsql;

CREATE TRIGGER course_filled  
    INSTEAD OF INSERT ON Registrations
    FOR EACH ROW EXECUTE PROCEDURE course_filled();

