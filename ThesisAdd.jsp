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
                        int counter = 0;
                        conn.setAutoCommit(false);
                        PreparedStatement pstmt2 = conn.prepareStatement("SELECT * FROM THESIS_COMMITTEE WHERE NAME LIKE ?");
                        pstmt2.setString(1, request.getParameter("NAME"));
                        ResultSet RS = pstmt2.executeQuery();
                        while(RS.next())
                        {
                            ++counter;
                        }
                        if(counter < 3)
                        {
                            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO THESIS_COMMITTEE VALUES (?, ?, ?)");

                            pstmt.setString(1, request.getParameter("NAME"));
                            pstmt.setString(2, request.getParameter("FACULTY"));
                            pstmt.setString(3, request.getParameter("DEPARTMENT"));
                            int rowCount = pstmt.executeUpdate();
                        }
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM THESIS_COMMITTEE");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>NAME</th>
                        <th>FACULTY_MEMBER</th>
                         <th>DEPARTMENT</th>
                    </tr>
                    <tr>
                        <form action="ThesisAdd.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="NAME" size="30"></th>
                            <th><input value="" name="FACULTY" size="20"></th>
                            <th><input value="" name="DEPARTMENT" size="20"></th>
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
                        <td><%= rs.getString("FACULTY") %></td>
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