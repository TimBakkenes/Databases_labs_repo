public class TestPortal {

   // enable this to make pretty printing a bit more compact
   private static final boolean COMPACT_OBJECTS = false;

   // This class creates a portal connection and runs a few operation

   public static void main(String[] args) {
      try{
         PortalConnection c = new PortalConnection();

         // Write your tests here. Add/remove calls to pause() as desired. 
         // Use println instead of prettyPrint to get more compact output (if your raw JSON is already readable)


         prettyPrint(c.getInfo("2222222222")); 
         pause();
   
         System.out.println(c.register("2222222222", "CCC555")); 
         prettyPrint(c.getInfo("2222222222"));
         pause();

         System.out.println(c.register("2222222222", "CCC555"));
         pause();

         System.out.println(c.unregister("2222222222", "CCC555"));

         prettyPrint(c.getInfo("2222222222"));
         pause();
         System.out.println(c.unregister("2222222222", "CCC555"));
         pause();

         System.out.println(c.register("1111111111", "CCC444")); 
         pause();

         // Registering students to excecute test 6
         System.out.println(c.register("1111111111", "CCC333")); 
         System.out.println(c.register("2222222222", "CCC333")); 
         System.out.println(c.register("3333333333", "CCC333")); 
         pause();


         // Test 6
         System.out.println(c.unregister("1111111111", "CCC333")); 
         System.out.println(c.register("1111111111", "CCC333")); 
         // Want to check the position of the waitinglist
         prettyPrint(c.getInfo("1111111111"));
         pause();

         // Unregister and re-register the same student for the same restricted course. I am assuming 1111111111 is on the waitinglist
         System.out.println(c.unregister("1111111111", "CCC333")); 
         System.out.println(c.register("1111111111", "CCC333")); 
         prettyPrint(c.getInfo("1111111111"));
         pause();

         // Unregister a student from an overfull course, first we add a student to that course that will end up on the waitinglist
         System.out.println(c.register("5555555555", "CCC222")); 

         // Then we unregister one of the students registered to the overfull course
         System.out.println(c.unregister("1111111111", "CCC222")); 
         prettyPrint(c.getInfo("1111111111"));
         pause();

         // To check if the test functions properly wee run the query: SELECT * FROM Registrations; and can then see that no new student is registered.
         // It seems to work as intended.
         // We could also check for the other students that are registered or waitlisted on the course: 5555555555 and 2222222222 with these lines:
         /*
          
         prettyPrint(c.getInfo("2222222222"));
         prettyPrint(c.getInfo("5555555555"));

         */

         // Unregistering with SQL Injection
         System.out.println(c.unregister("2222222222", "x' OR 'databases'='databases")); 
         prettyPrint(c.getInfo("1111111111"));
         prettyPrint(c.getInfo("2222222222"));
         prettyPrint(c.getInfo("3333333333"));
         prettyPrint(c.getInfo("4444444444"));
         prettyPrint(c.getInfo("5555555555"));
         prettyPrint(c.getInfo("6666666666"));
         pause();
         
      
         System.out.println("End of tests");

      } catch (ClassNotFoundException e) {
         System.err.println("ERROR!\nYou do not have the Postgres JDBC driver (e.g. postgresql-42.5.1.jar) in your runtime classpath!");
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   
   
   
   public static void pause() throws Exception{
     System.out.println("PRESS ENTER");
     while(System.in.read() != '\n');
   }
   
   // This is a truly horrible and bug-riddled hack for printing JSON. 
   // It is used only to avoid relying on additional libraries.
   // If you are a student, please avert your eyes.
   public static void prettyPrint(String json){
      System.out.print("Raw JSON:");
      System.out.println(json);
      System.out.println("Pretty-printed (possibly broken):");
      
      int indent = 0;
      json = json.replaceAll("\\r?\\n", " ");
      json = json.replaceAll(" +", " "); // This might change JSON string values :(
      json = json.replaceAll(" *, *", ","); // So can this
      
      for(char c : json.toCharArray()){
        if (c == '}' || c == ']') {
          indent -= 2;
          breakline(indent); // This will break string values with } and ]
        }
        
        System.out.print(c);
        
        if (c == '[' || c == '{') {
          indent += 2;
          breakline(indent);
        } else if (c == ',' && !COMPACT_OBJECTS) 
           breakline(indent);
      }
      
      System.out.println();
   }
   
   public static void breakline(int indent){
     System.out.println();
     for(int i = 0; i < indent; i++)
       System.out.print(" ");
   }   
}
