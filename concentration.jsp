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
                            "INSERT INTO concentration VALUES(?, ?, ?)");

                        pstmt.setString(1, request.getParameter("NAME"));
                        pstmt.setString(2, request.getParameter("DEGREE_NAME"));
			pstmt.setInt(3, Integer.parseInt(request.getParameter("COURSE_NO")));
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
                        ("SELECT * FROM CONCENTRATION");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Degree</th>
                        <th>Name</th>
                        <th>Course</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="concentration.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="DEGREE_NAME" size="30"></th>
                            <th><input value="" name="NAME" size="30"></th>
                            <th><input value="" name="COURSE_NO" size="5"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="concentration.jsp" method="get">
                            <td>
                                <input value="<%= rs.getString("DEGREE_NAME") %>" 
                                    name="DEGREE_NAME" size="30">
                            </td>
                            <td>
                                <input value="<%= rs.getString("NAME") %>" 
                                    name="NAME" size="30">
                            </td>
                            <td>
                                <input value="<%= rs.getInt("COURSE_NO") %>" 
                                    name="COURSE_NO" size="5">
                            </td>
    
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
