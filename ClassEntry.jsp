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
                    if (action != null && action.equals("insert")) 
                    {
                        conn.setAutoCommit(false);
                        PreparedStatement pstmt = conn.prepareStatement("INSERT INTO CLASS VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_NO")));
                        pstmt.setString(2, request.getParameter("CLASS_ID"));
                        pstmt.setString(3, request.getParameter("SECTION_ID"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("NUMBER_OF_SEATS")));
                        pstmt.setString(5, request.getParameter("TITLE"));
                        pstmt.setString(6, request.getParameter("INSTRUCTOR"));
                        pstmt.setString(7, request.getParameter("TYPE"));
                        pstmt.setString(8, request.getParameter("QUARTER"));
                        pstmt.setString(9, request.getParameter("WEEKLY_MEETING"));
                        pstmt.setString(10, request.getParameter("ROOM"));
                        int rowCount = pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM CLASS");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>COURSE_NO</th>
                        <th>CLASS_ID</th>
                        <th>SECTION_ID</th>
			            <th>NUMBER_OF_SEATS</th>
                        <th>TITLE</th>
                        <th>INSTRUCTOR</th>
                        <th>TYPE</th>
                        <th>QUARTER</th>
                        <th>WEEKLY_MEETING</th>
                        <th>ROOM</th>
                    </tr>
                    <tr>
                        <form action="ClassEntry.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="COURSE_NO" size="20"></th>
                            <th><input value="" name="CLASS_ID" size="20"></th>
                            <th><input value="" name="SECTION_ID" size="20"></th>
			                <th><input value="" name="NUMBER_OF_SEATS" size="20"></th>
                            <th><input value="" name="TITLE" size="20"></th>
                            <th><input value="" name="INSTRUCTOR" size="20"></th>
                            <th><input value="" name="TYPE" size="20"></th>
                            <th><input value="" name="QUARTER" size="20"></th>
                            <th><input value="" name="WEEKLY_MEETING" size="20"></th>
                            <th><input value="" name="ROOM" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <td><%= Integer.toString(rs.getInt("COURSE_NO")) %></td>
                        <td><%= rs.getString("CLASS_ID") %></td>
                        <td><%= rs.getString("SECTION_ID") %></td>
                        <td><%= Integer.toString(rs.getInt("NUMBER_OF_SEATS")) %></td>
                        <td><%= rs.getString("TITLE") %></td>
                        <td><%= rs.getString("INSTRUCTOR") %></td>
                        <td><%= rs.getString("TYPE") %></td>
                        <td><%= rs.getString("QUARTER") %></td>
                        <td><%= rs.getString("WEEKLY_MEETING") %></td>
                        <td><%= rs.getString("ROOM") %></td>
                        <td><%= rs.getString("CLASS_ID") %></td>
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