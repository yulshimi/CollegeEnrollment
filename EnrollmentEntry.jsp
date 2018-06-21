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
                    Statement statement = null;
                    PreparedStatement pstmt;
                    PreparedStatement BoolStmt;
                    ResultSet rs;
                    ResultSet RS = null;
                    Boolean Flexible = false;
                    String action = request.getParameter("action");
                    if(action != null && action.equals("insert")) 
                    {
                        conn.setAutoCommit(false);
                        pstmt = conn.prepareStatement("INSERT INTO TAKE VALUES (?, ?, ?, ?, ?, ?)");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("UNIT")));
                        pstmt.setString(3, request.getParameter("CLASS_ID"));
                        pstmt.setString(4, request.getParameter("SECTION_ID"));
                        pstmt.setString(5, request.getParameter("ENROLLED_STATUS"));
                        pstmt.setString(6, request.getParameter("GRADE"));
                        int rowCount = pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);

                        statement = conn.createStatement();
                        rs = statement.executeQuery("SELECT * FROM TAKE");
                    }
                    else if(action != null && action.equals("check"))
                    {   
                        //System.out.println("I am here");
                        BoolStmt = conn.prepareStatement("SELECT FLEXIBLE_UNIT FROM COURSES WHERE COURSE_NO = ? ", ResultSet.TYPE_SCROLL_SENSITIVE, 
                                                ResultSet.CONCUR_UPDATABLE);
                        BoolStmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_NO")));
                        RS = BoolStmt.executeQuery();
                        RS.first();
                        if(RS.getBoolean("FLEXIBLE_UNIT"))
                        {
                            System.out.println("Flexible is set to true");
                            Flexible = true;
                        }
                        BoolStmt = conn.prepareStatement("SELECT UNIT FROM COURSES WHERE COURSE_NO = ? ",ResultSet.TYPE_SCROLL_SENSITIVE, 
                                                ResultSet.CONCUR_UPDATABLE);
                        BoolStmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_NO")));
                        RS = BoolStmt.executeQuery();
                        RS.first();
                        
                        pstmt = conn.prepareStatement("SELECT COURSE_NO, SECTION_ID FROM CLASS WHERE COURSE_NO = ? ");   
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_NO")));
                        rs = pstmt.executeQuery();   
                    }
                    else
                    {
                        statement = conn.createStatement();
                        rs = statement.executeQuery("SELECT * FROM TAKE");
                    }
            %>

            <!-- Add an HTML table header row to format the results -->
            <%  if(action != null && action.equals("check"))
                {
                    if(Flexible)
                    {
                        System.out.println("Flexible!!!!");
            %>
                        <table border="1">
                        <tr>
                            <th>ID</th>
                            <th>CLASS_ID</th>
                            <th>SECTION_ID</th>
                            <th>ENROLLED_STATUS</th>
                            <th>GRADE</th>
                            <th>UNIT_IS_FLEXIBLE</th>
                        </tr>
                        <tr>
                            <form action="EnrollmentEntry.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="ID" size="20"></th>
                                <th><input value="" name="CLASS_ID" size="20"></th>
                                <th><input value="" name="SECTION_ID" size="20"></th>
                                <th><input value="" name="ENROLLED_STATUS" size="20"></th>
                                <th><input value="" name="GRADE" size="20"></th>
                                <th><input value="<%= Integer.toString(RS.getInt("UNIT")) %>" name="UNIT" size="20"></th>
                                <th><input type="submit" value="Insert"></th>
                           </form>
                        </tr>
            <%
                    }
                    else
                    {
                        System.out.println("inflexible");
            %>
                        <table border="1">
                        <tr>
                            <th>ID</th>
                            <th>CLASS_ID</th>
                            <th>SECTION_ID</th>
                            <th>ENROLLED_STATUS</th>
                            <th>GRADE</th>
                            <th>UNIT_IS_NOT_FLEXIBLE <%= Integer.toString(RS.getInt("UNIT")) %></th>
                        </tr>
                        <tr>
                            <form action="EnrollmentEntry.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="ID" size="20"></th>
                                <th><input value="" name="CLASS_ID" size="20"></th>
                                <th><input value="" name="SECTION_ID" size="20"></th>
                                <th><input value="" name="ENROLLED_STATUS" size="20"></th>
                                <th><input value="" name="GRADE" size="20"></th>
                                <th><input value="<%= Integer.toString(RS.getInt("UNIT")) %>" name="UNIT" size="20"></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
            <%
                    }
                }
                else
                {
            %>
                    <table border="1">
                    <tr>
                        <th>COURSE_NO</th>
                    </tr>
                    <tr>
                        <form action="EnrollmentEntry.jsp" method="get">
                            <input type="hidden" value="check" name="action">
                            <th><input value="" name="COURSE_NO" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>    
            <%
                }
            %>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
                    if(action != null && action.equals("check"))
                    {
                        while ( rs.next() ) 
                        {
        
            %>

                            <tr>
                                <td><%= "SECTION_ID" %></td>
                                <td><%= rs.getString("SECTION_ID") %></td>
                            </tr>
            <%
                        }
                    }
                    else
                    {
                        while(rs.next())
                        {
            %>
                            <tr>
                                <td><%= Integer.toString(rs.getInt("ID")) %></td>
                                <td><%= rs.getString("SECTION_ID") %></td>
                            </tr>
            <%
                        }
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
