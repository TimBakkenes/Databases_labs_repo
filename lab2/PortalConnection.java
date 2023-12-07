
import java.sql.*; // JDBC stuff.
import java.util.Properties;

public class PortalConnection {

    // Set this to e.g. "portal" if you have created a database named portal
    // Leave it blank to use the default database of your database user
    static final String DBNAME = "";
    // For connecting to the portal database on your local machine
    static final String DATABASE = "jdbc:postgresql://localhost/"+DBNAME;
    static final String USERNAME = "postgres";
    static final String PASSWORD = "postgres";

    // For connecting to the chalmers database server (from inside chalmers)
    // static final String DATABASE = "jdbc:postgresql://brage.ita.chalmers.se/";
    // static final String USERNAME = "tda357_nnn";
    // static final String PASSWORD = "yourPasswordGoesHere";


    // This is the JDBC connection object you will be using in your methods.
    private Connection conn;

    public PortalConnection() throws SQLException, ClassNotFoundException {
        this(DATABASE, USERNAME, PASSWORD);  
    }

    // Initializes the connection, no need to change anything here
    public PortalConnection(String db, String user, String pwd) throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        Properties props = new Properties();
        props.setProperty("user", user);
        props.setProperty("password", pwd);
        conn = DriverManager.getConnection(db, props);
    }


    // Register a student on a course, returns a tiny JSON document (as a String)
    public String register(String student, String courseCode){

        try (PreparedStatement prst = conn.prepareStatement("INSERT INTO Registrations VALUES(?, ?);")){
            String stu = student;
            String code = courseCode;

            prst.setString(1,stu);
            prst.setString(2,code);
            prst.executeUpdate();
            
            return "{'success':true}";

            
      
      // Here's a bit of useful code, use it or delete it 
          } catch (SQLException e) {
              return "{\"success\":false, \"error\":\""+getError(e)+"\"}";
          }     
        }

    // Unregister a student from a course, returns a tiny JSON document (as a String)
    public String unregister(String student, String courseCode){
        
        String query = "DELETE FROM Registrations WHERE student = '" + student + "' AND course = '" + courseCode + "';";
        try (Statement s = conn.createStatement();){

            int rs = s.executeUpdate(query);
            if(rs > 0){
              return "{'success':true}";
            } else{
              return "{\"success\":false, \"error\":\""+"No rows to delete, student is not registered or on waitinglist"+"\"}";
            }
                
        } catch (SQLException e) {
              return "{\"success\":false, \"error\":\""+getError(e)+"\"}";
          }     
        }
      
      
        
        

    // Return a JSON document containing lots of information about a student, it should validate against the schema found in information_schema.json
    public String getInfo(String student) throws SQLException{
        
        try(PreparedStatement st = conn.prepareStatement(
            // replace this with something more useful
            "SELECT jsonb_build_object(\n" + //
                    "    'student', idnr,\n" + //
                    "    'name', name,\n" + //
                    "    'login', login,\n" + //
                    "    'program', program,\n" + //
                    "    'branch', branch,\n" + //
                    "    'finished', (SELECT COALESCE(jsonb_agg(jsonb_build_object(\n" + //
                    "        'course', name,\n" + //
                    "        'code', course,\n" + //
                    "        'credits', credits,\n" + //
                    "        'grade', grade)), '[]') FROM Taken, Courses WHERE (Taken.student = BasicInformation.idnr AND Taken.course = Courses.code)),\n" + //
                    "    \n" + //
                    "    'registered', (SELECT COALESCE(jsonb_agg(jsonb_build_object(\n" + //
                    "        'course', name,\n" + //
                    "        'code', ExtendedRegistrations.course,\n" + //
                    "        'status', status,\n" + //
                    "        'position', position)), '[]') FROM ExtendedRegistrations, Courses WHERE (ExtendedRegistrations.student = BasicInformation.idnr AND ExtendedRegistrations.course = Courses.code)),\n" + //
                    "\n" + //
                    "    'seminarCourses', (SELECT seminarCourses FROM PathToGraduation WHERE (student = BasicInformation.idnr)),\n" + //
                    "    'mathCredits', (SELECT mathCredits FROM PathToGraduation WHERE (student = BasicInformation.idnr)),\n" + //
                    "    'totalCredits', (SELECT totalCredits FROM PathToGraduation WHERE (student = BasicInformation.idnr)),\n" + //
                    "    'canGraduate', (SELECT qualified FROM PathToGraduation WHERE (student = BasicInformation.idnr))\n" + //
                    "    \n" + //
                    "    ) AS jsondata FROM BasicInformation WHERE idnr=?;"
            );){
            
            st.setString(1, student);
            
            ResultSet rs = st.executeQuery();
            
            if(rs.next())
              return rs.getString("jsondata");
            else
              return "{\"student\":\"does not exist :(\"}"; 
            
        } 
    }

    // This is a hack to turn an SQLException into a JSON string error message. No need to change.
    public static String getError(SQLException e){
       String message = e.getMessage();
       int ix = message.indexOf('\n');
       if (ix > 0) message = message.substring(0, ix);
       message = message.replace("\"","\\\"");
       return message;
    }
}