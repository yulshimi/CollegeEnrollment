<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*, java.io.*, java.util.Enumeration, java.util.Date, java.util.Calendar" %>
           
            <%-- -------- Open Connection Code -------- --%>
            <%!
                public void sayHello()
                {
                    System.out.println("Hello");
                }
            %>
            <%

                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql:cse132";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    System.out.println("Start");
                    //java.util.SimpleDateFormat formatter = new java.util.SimpleDateFormat("yyyy-MM-dd");
                    if(action != null && action.equals("Submit")) 
                    {
                        Date date = null;
                        java.util.Calendar myCalendar = new java.util.GregorianCalendar(2018, 5, 23); 
                        //Thu is one. Wed is 7.
                        int dayOfWeek = myCalendar.get(Calendar.DAY_OF_WEEK);
                        System.out.println("Day is " + dayOfWeek);
                        sayHello();
                    }
            %>

			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    System.out.println("I am here");
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM STUDENT");
            %>
                <table border="1">
                <table border="1">
                <tr>
                    <form action="PRACTICE.jsp" method="get">
                        Start_Date:<br>
                        <input type="text" name="start_date" value=""><br>
                        END_DATE:<br>
                        <input type="text" name="end_date" value=""><br>
                        SECTION_NUMBER:<br>
                        <input type="text" name="section_number" value=""><br>
                        <input type="submit" value="Submit" name="action">
                    </form>
                </tr>
            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>