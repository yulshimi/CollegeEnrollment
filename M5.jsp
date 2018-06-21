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
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql:cse132";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "insert into take values(?, ?, ?, 4, ?, 'A01', true, 'Letter Grade', ?, ?)");
                        String quarter = request.getParameter("SEASON");
                        String class_id = request.getParameter("COURSE_NO") + "-" + quarter.substring(0,2)+"-"+quarter.substring(2,6);
                        pstmt.setString(1, request.getParameter("INSTRUCTOR"));
                        pstmt.setString(2, request.getParameter("COURSE_NO"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("ID")));
                        pstmt.setString(4, class_id);
                        pstmt.setString(5, request.getParameter("SEASON"));
                        pstmt.setString(6, request.getParameter("GRADE"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement("update take set grade = ? where instructor = ? and course_no = ? and season = ? and id = ?");

                        pstmt.setString(1, request.getParameter("GRADE"));
                        pstmt.setString(2, request.getParameter("INSTRUCTOR"));
                        pstmt.setString(3, request.getParameter("COURSE_NO"));
                        pstmt.setString(4, request.getParameter("SEASON"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("ID")));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>


            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Take");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Instructor</th>
                        <th>Course number</th>
                        <th>Quarter</th>
                        <th>Grade</th>
                        <th>Id</th>
                    </tr>
                    <tr>
                        <form action="M5.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="INSTRUCTOR" size="30"></th>
                            <th><input value="" name="COURSE_NO" size="30"></th>
                            <th><input value="" name="SEASON" size="20"></th>
			                <th><input value="" name="GRADE" size="15"></th>
                            <th><input value="" name="ID" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <tr>
                        <th>Instructor</th>
                        <th>Course number</th>
                        <th>Quarter</th>
                        <th>Grade</th>
                        <th>Id</th>
                    </tr>
                    <tr>
                        <form action="M5.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="" name="INSTRUCTOR" size="30"></th>
                            <th><input value="" name="COURSE_NO" size="30"></th>
                            <th><input value="" name="SEASON" size="20"></th>
                            <th><input value="" name="GRADE" size="15"></th>
                            <th><input value="" name="ID" size="15"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="M5.jsp" method="get">
                            <input type="hidden" value="update" name="action">

    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="M5.jsp" method="get">
                            <input type="hidden" 
                                value="<%= rs.getInt("SSN") %>" name="SSN">
                            <%-- Button --%>
                        </form>
                    </tr>
            <%
                    }
            %>

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
/html>
