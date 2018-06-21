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
                        Statement stmt = conn.createStatement();
                        stmt.executeUpdate("CREATE VIEW HELP AS SELECT ID, TAKESUPPORT.COURSE_NO, INSTRUCTOR, QUARTER, GRADE FROM TAKESUPPORT JOIN CLASS ON TAKESUPPORT.COURSE_NO=CLASS.COURSE_NO AND TAKESUPPORT.SEASON=CLASS.QUARTER");
                        Statement stmt_st = conn.createStatement();
                        stmt_st.executeUpdate("CREATE VIEW ANOTHERHELP AS SELECT*FROM HELP JOIN GRADE_CONVERSION ON HELP.GRADE=GRADE_CONVERSION.LETTER_GRADE");
                        System.out.println("HJHJHJHJHJ");
                        PreparedStatement stmt_1;
                        stmt_1 = conn.prepareStatement("SELECT GRADE, COUNT FROM CPQG WHERE INSTRUCTOR=? AND SEASON=? AND COURSE_NO=?", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        stmt_1.setString(1, request.getParameter("INSTRUCTOR"));
                        stmt_1.setString(2, request.getParameter("QUARTER"));
                        stmt_1.setString(3, request.getParameter("COURSE_NO"));
                        ResultSet RS_1 = stmt_1.executeQuery();
                        System.out.println("HJHJHJHJHJ");    
                        PreparedStatement stmt_2;
                        stmt_2 = conn.prepareStatement("SELECT GRADE, COUNT FROM CPG WHERE INSTRUCTOR=? AND COURSE_NO=?", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        stmt_2.setString(1, request.getParameter("INSTRUCTOR"));
                        stmt_2.setString(2, request.getParameter("COURSE_NO"));
                        ResultSet RS_2 = stmt_2.executeQuery();
                        System.out.println("HJHJHJHJHJ");
                        /*
                        PreparedStatement stmt_3;
                        stmt_3 = conn.prepareStatement("SELECT GRADE, COUNT(GRADE) FROM HELP WHERE COURSE_NO=? GROUP BY (GRADE)", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        stmt_3.setString(1, request.getParameter("COURSE_NO"));
                        ResultSet RS_3 = stmt_3.executeQuery();
                        System.out.println("HJHJHJHJHJ");
                        PreparedStatement stmt_4;
                        stmt_4 = conn.prepareStatement("SELECT AVG(NUMBER_GRADE) FROM ANOTHERHELP WHERE INSTRUCTOR=? AND COURSE_NO=? GROUP BY (INSTRUCTOR)", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        stmt_4.setString(1, request.getParameter("INSTRUCTOR"));
                        stmt_4.setString(2, request.getParameter("COURSE_NO"));
                        ResultSet RS_4 = stmt_4.executeQuery();
                        System.out.println("HJHJHJHJHJ"); 
                        */
                        while(RS_1.next())
                        {
                            System.out.println("HERE");
            %>
                            <tr>
                                <td>I</td>
                                <td><%= RS_1.getString("GRADE") %></td>
                                <td><%= RS_1.getInt("COUNT") %></td>
                            </tr>
            <%
                        System.out.println("HOHO");    
                        }
                        while(RS_2.next())
                        {
                            System.out.println("HERE1");
            %>
                            <tr>
                                <td>II</td>
                                <td><%= RS_2.getString("GRADE") %></td>
                                <td><%= RS_2.getInt("COUNT") %></td>
                            </tr>
            <%
                        }
                        /*
                        while(RS_3.next())
                        {
                            System.out.println("HERE2");
            %>
                            <tr>
                                <td>III</td>
                                <td><%= RS_3.getString("GRADE") %></td>
                                <td><%= RS_3.getInt("COUNT") %></td>
                            </tr>                
            <%
                        }
                        while(RS_4.next())
                        {
                            System.out.println("HERE3");
            %>
                            <tr>
                                <td>IV</td>
                                <td>Average Grade</td>
                                <td><%= RS_4.getDouble("AVG") %></td>
                            </tr>                   
            <%
                        }
                        */
                        stmt_st.executeUpdate("DROP VIEW ANOTHERHELP");
                        stmt_st.executeUpdate("DROP VIEW HELP");
                    }
            %>

			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    System.out.println("I am here");
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM TAKESUPPORT");
            %>
                <table border="1">
                <tr>
                    <form action="Report3.jsp" method="get">
                        INSTRUCTOR:<br>
                        <input type="text" name="INSTRUCTOR" value=""><br>
                        QUARTER:<br>
                        <input type="text" name="QUARTER" value=""><br>
                        COURSE_NO:<br>
                        <input type="text" name="COURSE_NO" value=""><br>
                        <input type="submit" value="Submit" name="action">
                    </form>
                </tr>
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
