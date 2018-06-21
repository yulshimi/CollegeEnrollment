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
                            "INSERT INTO probation(ID, PROBATION_START, PROBATION_END, REASON) VALUES(?, ?, ?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        pstmt.setString(2, request.getParameter("PROBATION_START"));
                        pstmt.setString(3, request.getParameter("PROBATION_END"));
                        pstmt.setString(4, request.getParameter("REASON"));

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
                        ("SELECT * FROM probation");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>ID</th>
                        <th>Probation start date</th>
                        <th>Probation end date</th>
                        <th>Reason</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="ID" size="10"></th>
                            <th><input value="" name="PROBATION_START" size="20"></th>
                            <th><input value="" name="PROBATION_END" size="20"></th>
                            <th><input value="" name="REASON" size="50"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="probation.jsp" method="get">
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getInt("ID") %>" 
                                    name="ID" size="10">
                            </td>
    
                            <%-- Get the PROBATION start date --%>
                            <td>
                                <input value="<%= rs.getString("PROBATION_START") %>" 
                                    name="PROBATION_START" size="20">
                            </td>


                            <%-- Get the PROBATION end date --%>
                            <td>
                                <input value="<%= rs.getString("PROBATION_END") %>" 
                                    name="PROBATION_START" size="20">
                            </td>
                            <td>
                                <input value="<%= rs.getString("REASON") %>" 
                                    name="REASON" size="50">
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
