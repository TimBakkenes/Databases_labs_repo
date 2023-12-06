CREATE FUNCTION course_filled() RETURNS trigger AS $course_filled$
   DECLARE cap INT;
   DECLARE reg INT;
   BEGIN
        SELECT COUNT(*)

       IF (EXISTS (SELECT * FROM Registrations WHERE course=NEW.course AND student = New.student))
       THEN
           RAISE EXCEPTION 'test2';
       ELSE
       INSERT INTO Registered VALUES (New.student, New.course);
       END IF;
       

       IF (EXISTS (SELECT unlocking FROM Prerequisites WHERE (unlocked = NEW.course) AND unlocking NOT IN (SELECT course FROM TAKEN WHERE (student = NEW.student))))
       THEN
            RAISE EXCEPTION 'error1';
        
        RETURN NEW;
   END;
$course_filled$ LANGUAGE plpgsql;

CREATE TRIGGER course_filled 
   INSTEAD OF INSERT ON Registrations
   FOR EACH ROW EXECUTE PROCEDURE course_filled();
