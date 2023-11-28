CREATE FUNCTION course_filled() RETURNS trigger AS $course_filled$
   DECLARE cnt INT;
   BEGIN
       SELECT COUNT(*) INTO cnt
           FROM Registered
           WHERE course = NEW.course;
       -- Check that course and student are given
       IF NEW.course IS NULL THEN
           RAISE EXCEPTION 'course cannot be null';
       END IF;
       IF NEW.student IS NULL THEN
           RAISE EXCEPTION 'studet cannot be null';
       END IF;


       -- Who works for us when they must pay for it?
       IF cnt < 0 THEN
           RAISE EXCEPTION '% cannot have a negative salary', NEW.empname;
       END IF;


       -- Remember who changed the payroll when
       NEW.last_date := current_timestamp;
       NEW.last_user := current_user;
       RETURN NEW;
   END;
$course_filled$ LANGUAGE plpgsql;


CREATE TRIGGER course_filled BEFORE INSERT OR UPDATE ON Registered
   FOR EACH ROW EXECUTE FUNCTION course_filled();
