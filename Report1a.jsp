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
                    System.out.println("Start");
                    if(action != null && action.equals("Submit")) 
                    {
                        System.out.println("Hello");
                        PreparedStatement stmt;
                        stmt = conn.prepareStatement("SELECT*FROM TAKE JOIN CLASS ON TAKE.ID = ? AND TAKE.SEASON = 'sp2018' AND TAKE.CLASS_ID = CLASS.CLASS_ID AND TAKE.SECTION_ID = CLASS.SECTION_ID", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        stmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        ResultSet RS = stmt.executeQuery();
                        while(RS.next())
                        {
                            System.out.println("HERE");
            %>
                            <tr>
                                <td>COURSE_NO <%= RS.getString("COURSE_NO") %></td>
                                <td>CLASS_ID <%= RS.getString("CLASS_ID") %></td>
                                <td>SECTION_ID <%= RS.getString("SECTION_ID") %></td>
                                <td>TITLE <%= RS.getString("TITLE") %></td>
                                <td>INSTRUCTOR <%= RS.getString("INSTRUCTOR") %></td>
                                <td>TYPE <%= RS.getString("TYPE") %></td>
                                <td>QUARTER <%= RS.getString("QUARTER") %></td>
                                <td>WEEKLY_MEETING <%= RS.getString("WEEKLY_MEETING") %></td>
                                <td>ROOM<%= RS.getString("ROOM") %></td>
                                <td>NUMOFSEATS <%= Integer.toString(RS.getInt("NUMBER_OF_SEATS")) %></td>
                                <td>UNIT <%= Integer.toString(RS.getInt("UNIT")) %></td>
                            </tr>
            <%
                        System.out.println("HOHO");    
                        }
                    }
            %>

			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    System.out.println("I am here");
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM STUDENT");
            %>
                <table border="1">
                <form action="Report1a.jsp" method="get">
                    <select name="ID">


            <%
                    while (rs.next()) 
                    {
            %>

                         <option value="<%= Integer.toString(rs.getInt("ID")) %>"> 
                            <%= Integer.toString(rs.getInt("ID")) %> 
                            <%= rs.getString("FIRSTNAME") %>
                            <%= rs.getString("MIDDLENAME") %>
                            <%= rs.getString("LASTNAME") %>
                         </option>
            <%
                    }
            %>
                    </select>
                    <input type="submit" value="Submit" name="action">
                </form>
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