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
                            "INSERT INTO degrees VALUES(?, ?, ?)");

                        pstmt.setString(1, request.getParameter("NAME"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("lower")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("upper")));
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
                        ("SELECT * FROM DEGREES");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Degree</th>
                        <th>Lower Division Unit</th>
                        <th>Upper Division Unit</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="degree.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="NAME" size="30"></th>
                            <th><input value="" name="lower" size="5"></th>
                            <th><input value="" name="upper" size="5"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="degree.jsp" method="get">
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("NAME") %>" 
                                    name="NAME" size="30">
                            </td>
    
                            <%-- Get the lower requirement --%>
                            <td>
                                <input value="<%= rs.getInt("LOWER_DIV_UNIT") %>" 
                                    name="lower" size="4">
                            </td>


                            <%-- Get the PROBATION end date --%>
                            <td>
                                <input value="<%= rs.getInt("LOWER_DIV_UNIT") %>" 
                                    name="upper" size="4">
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
