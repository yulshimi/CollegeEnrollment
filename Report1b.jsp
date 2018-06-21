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
                    if(action != null && action.equals("Submit")) 
                    {
                        PreparedStatement stmt;
                        stmt = conn.prepareStatement("SELECT*FROM CLASS JOIN TAKE ON CLASS.TITLE=? AND CLASS.QUARTER = 'sp2018' AND CLASS.CLASS_ID = TAKE.CLASS_ID AND CLASS.SECTION_ID = TAKE.SECTION_ID", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        stmt.setString(1, request.getParameter("TITLE"));
                        ResultSet RS = stmt.executeQuery();
                        while(RS.next())
                        {
                            PreparedStatement m_stmt = conn.prepareStatement("SELECT*FROM STUDENT WHERE ID = ?");
                            m_stmt.setInt(1, RS.getInt("ID"));
                            ResultSet m_RS = m_stmt.executeQuery();
                            if(m_RS.next())
                            {
            %>
                                <tr>
                                    <td>ID <%= Integer.toString(m_RS.getInt("ID")) %></td>
                                    <td>SSN <%= Integer.toString(m_RS.getInt("SSN")) %></td>
                                    <td>FIRSTNAME<%= m_RS.getString("FIRSTNAME") %></td>
                                    <td>MIDDLENAME <%= m_RS.getString("MIDDLENAME") %></td>
                                    <td>LASTNAME <%= m_RS.getString("LASTNAME") %></td>
                                    <td>ENROLLMENT <%= Boolean.toString(m_RS.getBoolean("ENROLLMENT")) %></td>
                                    <td>DEGREE <%= m_RS.getString("DEGREE") %></td>
                                    <td>UNIT <%= Integer.toString(RS.getInt("UNIT")) %></td>
                                    <td>CLASS_ID <%= RS.getString("CLASS_ID") %></td>
                                    <td>SECTION_ID <%= RS.getString("SECTION_ID") %></td>
                                    <td>GRADE_OPTION <%= RS.getString("GRADE_OPTION") %></td>
                                </tr>
            <%
                            }
                            m_RS.close();
                            m_stmt.close();    
                        }
                        System.out.println("GET OUT");
                    }
            %>
            <%
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM CLASS WHERE QUARTER = 'sp2018' ");
            %>
                <table border="1">
                <form action="Report1b.jsp" method="get">
                    <select name="TITLE">


            <%
                    while (rs.next()) 
                    {
            %>
                        <option value="<%= rs.getString("TITLE") %>"> 
                            <%= rs.getString("COURSE_NO") %> 
                            <%= rs.getString("QUARTER") %> 
                        </option>
            <%
                    }
            %>
                    </select>
                    <input type="submit" value="Submit" name="action">
                </form>
            <%
                    rs.close();
                    statement.close();
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