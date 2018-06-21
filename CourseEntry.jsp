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
                        PreparedStatement pstmt = conn.prepareStatement("INSERT INTO COURSES VALUES (?, ?, ?, ?, ?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_NO")));
                        pstmt.setString(2, request.getParameter("DEPARTMENT"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("UNIT")));
                        pstmt.setBoolean(4, Boolean.parseBoolean(request.getParameter("LAB_WORK_REQUIRED")));
                        pstmt.setBoolean(5, Boolean.parseBoolean(request.getParameter("UNIT_FLEXIBILITY")));
                        pstmt.setString(6, request.getParameter("GRADE_OPTION"));
                        int RowCount = pstmt.executeUpdate();
                        if(!request.getParameter("PREREQ").equals(""))
                        {
                            PreparedStatement pstmt2 = conn.prepareStatement("INSERT INTO PREREQUISITES VALUES (?, ?)");
                            pstmt2.setInt(1, Integer.parseInt(request.getParameter("COURSE_NO")));
                            pstmt2.setInt(2, Integer.parseInt(request.getParameter("PREREQ")));
                            int rowCount = pstmt2.executeUpdate();
                        }
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
                    ResultSet rs = statement.executeQuery("SELECT * FROM COURSES");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>COURSE_NO</th>
                        <th>DEPARTMENT</th>
                        <th>UNIT</th>
			            <th>LABWORK</th>
                        <th>UNIT_FLEXIBILITY</th>
                        <th>GRADE_OPTION</th>
                        <th>PreReq</th>
                    </tr>
                    <tr>
                        <form action="CourseEntry.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="COURSE_NO" size="20"></th>
                            <th><input value="" name="DEPARTMENT" size="20"></th>
                            <th><input value="" name="UNIT" size="20"></th>
			                <th><input value="" name="LAB_WORK_REQUIRED" size="20"></th>
                            <th><input value="" name="UNIT_FLEXIBILITY" size="20"></th>
                            <th><input value="" name="GRADE_OPTION" size="20"></th>
                            <th><input value="" name="PREREQ" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <%= Integer.toString(rs.getInt("COURSE_NO")) %>
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                               <%= rs.getString("DEPARTMENT") %>
                            </td>
    
                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <%= Integer.toString(rs.getInt("UNIT")) %>
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <%= Boolean.toString(rs.getBoolean("LAB_WORK_REQUIRED")) %>
                            </td>
                            <td>
                                <%= Boolean.toString(rs.getBoolean("FLEXIBLE_UNIT")) %>
                            </td>
                            <td>
                                <%= rs.getString("GRADE_OPTION") %>
                            </td>
                            
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
