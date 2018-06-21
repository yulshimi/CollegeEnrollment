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
                    ResultSet rs;
                    String action = request.getParameter("action");
                    if(action != null && action.equals("insert")) 
                    {
                        conn.setAutoCommit(false);
                        pstmt = conn.prepareStatement("INSERT INTO TOOK VALUES (?, ?, ?, ?, ?)");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_NO")));
                        pstmt.setString(3, request.getParameter("SECTION_ID"));
                        pstmt.setString(4, request.getParameter("SEASON"));
                        pstmt.setString(5, request.getParameter("GRADE"));
                        int rowCount = pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);

                        statement = conn.createStatement();
                        rs = statement.executeQuery("SELECT * FROM TOOK");
                    }
                    else if(action != null && action.equals("check"))
                    {   
                        pstmt = conn.prepareStatement("SELECT COURSE_NO, SECTION_ID FROM CLASS WHERE COURSE_NO = ? ");   
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_NO")));
                        rs = pstmt.executeQuery();   
                    }
                    else
                    {
                        statement = conn.createStatement();
                        rs = statement.executeQuery("SELECT * FROM TOOK");
                    }
            %>

            <!-- Add an HTML table header row to format the results -->
            <%  if(action != null && action.equals("check"))
                {
            %>
                    <table border="1">
                        <tr>
                            <th>ID</th>
                            <th>COURSE_NO</th>
                            <th>SECTION_ID</th>
                            <th>SEASON</th>
                            <th>GRADE</th>
                        </tr>
                        <tr>
                            <form action="TakenEntry.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="ID" size="20"></th>
                                <th><input value="" name="COURSE_NO" size="20"></th>
                                <th><input value="" name="SECTION_ID" size="20"></th>
                                <th><input value="" name="SEASON" size="20"></th>
                                <th><input value="" name="GRADE" size="20"></th>
                                <th><input type="submit" value="Insert"></th>
                           </form>
                        </tr>
            <%
                }
                else
                {
            %>
                    <table border="1">
                    <tr>
                        <th>COURSE_NO</th>
                    </tr>
                    <tr>
                        <form action="TakenEntry.jsp" method="get">
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
