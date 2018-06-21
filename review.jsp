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
                            "INSERT INTO review_session(CLASS_ID, DATE, TIME, PLACE) VALUES(?, ?, ?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("CLASS_ID")));
                        pstmt.setDate(2, java.sql.Date.valueOf(request.getParameter("DATE")));
                        pstmt.setString(3, request.getParameter("TIME"));
                        pstmt.setString(4, request.getParameter("PLACE"));
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
                        ("SELECT * FROM review_session");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Class ID</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Location</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="review.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="CLASS_ID" size="10"></th>
                            <th><input value="" name="DATE" size="20"></th>
                            <th><input value="" name="TIME" size="20"></th>
                            <th><input value="" name="PLACE" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="review.jsp" method="get">
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getInt("CLASS_ID") %>" 
                                    name="CLASS_ID" size="10">
                            </td>
    
                            <%-- Get the review start date --%>
                            <td>
                                <input value="<%= rs.getDate("DATE") %>" 
                                    name="DATE" size="20">
                            </td>


                            <%-- Get the PROBATION end date --%>
                            <td>
                                <input value="<%= rs.getString("TIME") %>" 
                                    name="TIME" size="20">
                            </td>
                            <td>
                                <input value="<%= rs.getString("PLACE") %>" 
                                    name="PLACE" size="20">
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
