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
                        PreparedStatement stmt_1;
                        PreparedStatement stmt_2;
                        stmt = conn.prepareStatement("SELECT*FROM TAKESUPPORT JOIN CLASS ON ID = ? AND TAKESUPPORT.SEASON=CLASS.QUARTER AND TAKESUPPORT.COURSE_NO = CLASS.COURSE_NO ORDER BY SEASON", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        stmt_1 = conn.prepareStatement("SELECT SEASON, (SUM(UNIT*NUMBER_GRADE))/SUM(UNIT) as OVERALL FROM TAKESUPPORT JOIN GRADE_CONVERSION ON ID = ? AND TAKESUPPORT.GRADE=GRADE_CONVERSION.LETTER_GRADE GROUP BY SEASON");
                        stmt_2 = conn.prepareStatement("SELECT ID, (SUM(UNIT*NUMBER_GRADE))/SUM(UNIT) as OVERALL FROM TAKESUPPORT JOIN GRADE_CONVERSION ON ID = ? AND TAKESUPPORT.GRADE=GRADE_CONVERSION.LETTER_GRADE GROUP BY (ID)");
                        stmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        stmt_1.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        stmt_2.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        System.out.println("RESULT CLOSED");
                        ResultSet RS = stmt.executeQuery();
                        ResultSet RS_1 = stmt_1.executeQuery();
                        ResultSet RS_2 = stmt_2.executeQuery();
                        //System.out.println("RESULTRESULT");
                        while(RS.next())
                        {
                            System.out.println("RESULTRESULT");
            %>
                            <tr>
                                <td><%= Integer.toString(RS.getInt("ID")) %></td>
                                <td><%= RS.getString("GRADE") %></td>
                                <td><%= RS.getString("COURSE_NO") %></td>
                                <td><%= RS.getString("TITLE") %></td>
                                <td><%= RS.getString("QUARTER") %></td>
                                <td><%= RS.getString("CLASS_ID") %></td>
                                <td><%= RS.getString("SECTION_ID") %></td>
                                <td><%= Integer.toString(RS.getInt("NUMBER_OF_SEATS")) %></td>
                              
                            </tr>
            <%
                        System.out.println("HOHO");    
                        }
                        //RS.close();
                        //stmt.close();
                        while(RS_1.next())
                        {
                            System.out.println("RESULTRESULT");
            %>
                              <td><%= RS_1.getString("SEASON") %></td>
                              <td><%= Double.toString(RS_1.getDouble("OVERALL")) %></td>
            <%                
                        }
                        //RS_1.close();
                        //stmt_1.close();
                        if(RS_2.next())
                        {
                            System.out.println("RESULTRESULT");
            %>
                            <td><%= Integer.toString(RS_2.getInt("ID")) %></td>
                            <td><%= Double.toString(RS_2.getDouble("OVERALL")) %></td>
            <%
                        }
                        //RS_2.close();
                        //stmt_2.close();
                    }
            %>

			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    System.out.println("I am here");
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT DISTINCT TAKE.ID, FIRSTNAME, MIDDLENAME, LASTNAME FROM TAKE JOIN STUDENT ON TAKE.ID = STUDENT.ID");
            %>
                <table border="1">
                <form action="Report1c.jsp" method="get">
                    <select name="ID">


            <%
                    while ( rs.next() ) 
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