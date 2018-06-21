<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <jsp:include page="menu.html" />
            </td>
            <td>
            <%@ page language="java" import="java.sql.*" %>
    
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
                        Statement stmt_a = conn.createStatement();
                        stmt_a.executeUpdate("CREATE TABLE CANNOTTAKE (SECTION_ID VARCHAR(10), COURSE_NO VARCHAR(20))");
                        PreparedStatement p_stmt = conn.prepareStatement("INSERT INTO CANNOTTAKE VALUES (?, ?)");
                        System.out.println("Hello");
                        PreparedStatement stmt;
                        PreparedStatement stmt_1;
                        stmt = conn.prepareStatement("SELECT*FROM TAKE JOIN SECTION ON TAKE.ID = ? AND TAKE.SECTION_ID = SECTION.SECTION_ID", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        stmt_1 = conn.prepareStatement("SELECT*FROM SECTION", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        stmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                        ResultSet RS = stmt.executeQuery();
                        ResultSet RS_1 = stmt_1.executeQuery();
                        while(RS.next())
                        {
                            String Day_1 = "";
                            String start_1 = "";
                            String end_1 = "";
                            Boolean startBool_1 = true;
                            int Start_1;
                            int End_1;
                            String currStr_1 = RS.getString("WEEKLY_MEETING");
                            for(int i=0; i < currStr_1.length(); ++i)
                            {
                                if(i < 3)
                                {
                                    Day_1 += currStr_1.charAt(i);
                                }
                                else
                                {
                                    if(currStr_1.charAt(i) == '-')
                                    {
                                        startBool_1 = false;
                                    }
                                    else
                                    {
                                        if(currStr_1.charAt(i) != ' ' && currStr_1.charAt(i) != ':')
                                        {
                                            if(startBool_1)
                                            {
                                                start_1 += currStr_1.charAt(i);
                                            }
                                            else
                                            {
                                                end_1 += currStr_1.charAt(i);
                                            }
                                        }
                                    }
                                }
                            }
                            Start_1 = Integer.parseInt(start_1);
                            End_1 = Integer.parseInt(end_1);
                            System.out.println("HERE");
                            RS_1.first();
                            while(RS_1.next())
                            {
                                Boolean overlap = false;
                                String Day = "";
                                String start = "";
                                String end = "";
                                Boolean startBool = true;
                                int Start;
                                int End;
                                String currStr = RS_1.getString("WEEKLY_MEETING");
                                for(int i=0; i < currStr.length(); ++i)
                                {
                                    if(i < 3)
                                    {
                                        Day += currStr.charAt(i);
                                    }
                                    else
                                    {
                                        if(currStr.charAt(i) == '-')
                                        {
                                            startBool = false;
                                        }
                                        else
                                        {
                                            if(currStr.charAt(i) != ' ' && currStr.charAt(i) != ':')
                                            {
                                                if(startBool)
                                                {
                                                    start += currStr.charAt(i);
                                                }
                                                else
                                                {
                                                    end += currStr.charAt(i);
                                                }
                                            }
                                        }
                                    }
                                }
                                Start = Integer.parseInt(start);
                                End = Integer.parseInt(end);
                                if(Day.equals(Day_1))
                                {
                                    System.out.println("START" + Start_1 + "   " + Start);
                                    if(Start_1 == Start)
                                    {
                                        overlap = true;
                                    }
                                }
                                if(overlap)
                                {
                                    System.out.println("OVERLAPPED");
                                    if(!RS.getString("SECTION_ID").equals(RS_1.getString("SECTION_ID")))
                                    {
                                        System.out.println("cannottake section: " + RS_1.getString("SECTION_ID"));
                                        p_stmt.setString(1, RS_1.getString("SECTION_ID"));
                                        p_stmt.setString(2, RS_1.getString("COURSE_NO"));
                                        p_stmt.executeUpdate();
                                    }
                                }
                            }
                        }
                        stmt_a.executeUpdate("CREATE VIEW CANTAKE AS SELECT*FROM SECTION WHERE SECTION.SECTION_ID NOT IN (SELECT SECTION_ID FROM CANNOTTAKE)");
                        p_stmt = conn.prepareStatement("SELECT DISTINCT SECTION.COURSE_NO FROM SECTION WHERE SECTION.COURSE_NO NOT IN (SELECT COURSE_NO FROM CANTAKE)");
                        ResultSet finalSet = p_stmt.executeQuery();   
                        while(finalSet.next())
                        {
            %>
                            <tr><td><%= finalSet.getString("COURSE_NO") %></td></tr>
            <%
                        } 
                        stmt_a.executeUpdate("DROP VIEW CANTAKE");
                        stmt_a.executeUpdate("DROP TABLE CANNOTTAKE");
                    }
            %>

			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    System.out.println("I am here");
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM STUDENT");
            %>
                <table border="1">
                <form action="Report2a.jsp" method="get">
                    <select name="id">


            <%
                    while ( rs.next() ) 
                    {
            %>

                         <option value="<%= Integer.toString(rs.getInt("ID")) %>"> 
                            <%= Integer.toString(rs.getInt("ID")) %> 
                            <%= rs.getString("FIRSTNAME") %>
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