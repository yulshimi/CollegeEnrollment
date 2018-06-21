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
                    if(action != null && action.equals("insert")) 
                    {
                        conn.setAutoCommit(false);
                        PreparedStatement msmt = conn.prepareStatement("SELECT CURR_ENROLL FROM CLASSSUPPORT WHERE SECTION_ID=?");
                        msmt.setString(1, request.getParameter("SECTION_ID"));
                        ResultSet m_rs = msmt.executeQuery();
                        m_rs.next();
                        int seat = m_rs.getInt("CURR_ENROLL");
                        ++seat;
                        PreparedStatement pstmt = conn.prepareStatement("UPDATE CLASSSUPPORT SET CURR_ENROLL=? WHERE SECTION_ID=?");
                        pstmt.setInt(1, seat);
                        pstmt.setString(2, request.getParameter("SECTION_ID"));
                        int rowCount = pstmt.executeUpdate();
                        PreparedStatement sstmt = conn.prepareStatement("INSERT INTO ENROLLSUPPORT VALUES (?, ?, ?, ?)");
                     
                        sstmt.setString(1, request.getParameter("NAME"));
                        sstmt.setString(2, request.getParameter("SECTION_ID"));
                        sstmt.setString(3, request.getParameter("GRADE_OPTION"));
                        sstmt.setString(4, request.getParameter("UNIT"));
                        sstmt.executeUpdate();
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM ENROLLSUPPORT");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>NAME</th>
                        <th>SECTION_ID</th>
                        <th>GRADE_OPTION</th>
			            <th>UNIT</th>
                    </tr>
                    <tr>
                        <form action="Constraint2.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="NAME" size="20"></th>
                            <th><input value="" name="SECTION_ID" size="20"></th>
                            <th><input value="" name="GRADE_OPTION" size="20"></th>
			                <th><input value="" name="UNIT" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <td><%= rs.getString("NAME") %></td>
                        <td><%= rs.getString("SECTION_ID") %></td>
                        <td><%= rs.getString("GRADE_OPTION") %></td>
                        <td><%= rs.getString("UNIT") %></td>
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