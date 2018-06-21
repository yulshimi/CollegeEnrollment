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
                        PreparedStatement pstmt = conn.prepareStatement("INSERT INTO CLASSSUPPORT VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? , ?)");

                        pstmt.setString(1, request.getParameter("COURSE_NO"));
                        pstmt.setString(2, request.getParameter("SECTION_ID"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("ENROLL_LIMIT")));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("CURR_ENROLL")));
                        pstmt.setString(5, request.getParameter("INSTRUCTOR"));
                        pstmt.setString(6, request.getParameter("QUARTER"));
                        pstmt.setString(7, request.getParameter("LEC1"));
                        pstmt.setString(8, request.getParameter("LEC2"));
                        pstmt.setString(9, request.getParameter("LEC3"));
                        pstmt.setString(10, request.getParameter("DIS1"));
                        pstmt.setString(11, request.getParameter("DIS2"));
                        pstmt.setString(12, request.getParameter("LAB1"));
                        pstmt.setString(13, request.getParameter("LAB2"));

                        int rowCount = pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    if (action != null && action.equals("update")) 
                    {
                        conn.setAutoCommit(false);
                        PreparedStatement pstmt = conn.prepareStatement("UPDATE CLASSSUPPORT SET LEC1 = ?, LEC2 = ?, LEC3 = ?, DIS1 = ?, DIS2 = ?, LAB1 = ?, LAB2 = ? WHERE COURSE_NO = ? AND SECTION_ID = ?");

                        pstmt.setString(1, request.getParameter("LEC1"));
                        pstmt.setString(2, request.getParameter("LEC2"));
                        pstmt.setString(3, request.getParameter("LEC3"));
                        pstmt.setString(4, request.getParameter("DIS1"));
                        pstmt.setString(5, request.getParameter("DIS2"));
                        pstmt.setString(6, request.getParameter("LAB1"));
                        pstmt.setString(7, request.getParameter("LAB2"));
                        pstmt.setString(8, request.getParameter("COURSE_NO"));
                        pstmt.setString(9, request.getParameter("SECTION_ID"));
                        int rowCount = pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM CLASSSUPPORT");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>COURSE_NO</th>
                        <th>SECTION_ID</th>
                        <th>ENROLL_LIMIT</th>
			            <th>CURR_ENROLL</th>
                        <th>INSTRUCTOR</th>
                        <th>QUARTER</th>
                        <th>LEC1</th>
                        <th>LEC2</th>
                        <th>LEC3</th>
                        <th>DIS1</th>
                        <th>DIS2</th>
                        <th>LAB1</th>
                        <th>LAB2</th>
                    </tr>
                    <tr>
                        <form action="Constraint1.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="COURSE_NO" size="20"></th>
                            <th><input value="" name="SECTION_ID" size="20"></th>
                            <th><input value="" name="ENROLL_LIMIT" size="20"></th>
			                <th><input value="" name="CURR_ENROLL" size="20"></th>
                            <th><input value="" name="INSTRUCTOR" size="20"></th>
                            <th><input value="" name="QUARTER" size="20"></th>
                            <th><input value="" name="LEC1" size="20"></th>
                            <th><input value="" name="LEC2" size="20"></th>
                            <th><input value="" name="LEC3" size="20"></th>
                            <th><input value="" name="DIS1" size="20"></th>
                            <th><input value="" name="DIS2" size="20"></th>
                            <th><input value="" name="LAB1" size="20"></th>
                            <th><input value="" name="LAB2" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <tr>
                        <th>COURSE_NO</th>
                        <th>SECTION_ID</th>
                        <th>ENROLL_LIMIT</th>
                        <th>CURR_ENROLL</th>
                        <th>INSTRUCTOR</th>
                        <th>QUARTER</th>
                        <th>LEC1</th>
                        <th>LEC2</th>
                        <th>LEC3</th>
                        <th>DIS1</th>
                        <th>DIS2</th>
                        <th>LAB1</th>
                        <th>LAB2</th>
                    </tr>
                    <tr>
                        <form action="Constraint1.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="" name="COURSE_NO" size="20"></th>
                            <th><input value="" name="SECTION_ID" size="20"></th>
                            <th><input value="" name="ENROLL_LIMIT" size="20"></th>
                            <th><input value="" name="CURR_ENROLL" size="20"></th>
                            <th><input value="" name="INSTRUCTOR" size="20"></th>
                            <th><input value="" name="QUARTER" size="20"></th>
                            <th><input value="" name="LEC1" size="20"></th>
                            <th><input value="" name="LEC2" size="20"></th>
                            <th><input value="" name="LEC3" size="20"></th>
                            <th><input value="" name="DIS1" size="20"></th>
                            <th><input value="" name="DIS2" size="20"></th>
                            <th><input value="" name="LAB1" size="20"></th>
                            <th><input value="" name="LAB2" size="20"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <td><%= rs.getString("COURSE_NO") %></td>
                        <td><%= rs.getString("SECTION_ID") %></td>
                        <td><%= Integer.toString(rs.getInt("ENROLL_LIMIT")) %></td>
                        <td><%= Integer.toString(rs.getInt("CURR_ENROLL")) %></td>
                        <td><%= rs.getString("INSTRUCTOR") %></td>
                        <td><%= rs.getString("QUARTER") %></td>
                        <td><%= rs.getString("LEC1") %></td>
                        <td><%= rs.getString("LEC2") %></td>
                        <td><%= rs.getString("LEC3") %></td>
                        <td><%= rs.getString("DIS1") %></td>
                        <td><%= rs.getString("DIS2") %></td>
                        <td><%= rs.getString("LAB1") %></td>
                        <td><%= rs.getString("LAB2") %></td>
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