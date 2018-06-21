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
            <%@ page import="java.util.HashMap" %>
    
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
                        PreparedStatement stmt, stmt2, stmt3, stmt5, stmt6;
                        stmt = conn.prepareStatement("SELECT s.ID, s.FIRSTNAME, s.LASTNAME, s.MIDDLENAME, d.NAME, d.GRAD_UNIT FROM STUDENT s, DEGREES d WHERE s.ID = ? AND s.DEGREE = d.NAME");
                        stmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        ResultSet RS = stmt.executeQuery();
                        
                        //all classes this guy has taken
                        stmt2 = conn.prepareStatement("select distinct name as completed from concentration where name in (SELECt ct.name from concentration ct, take t, student s, class c, grade_conversion gc where s.id = t.id and s.id = ? and c.course_no = ct.course_no and ct.degree_name = s.degree and t.class_id = c.class_id and t.grade != 'IC' group by ct.name,ct.min_units having sum(t.unit) >= ct.min_units) and name in (SELECt ct.name from concentration ct, take t, student s, class c, grade_conversion gc where s.id = t.id and s.id = ? and c.course_no = ct.course_no and ct.degree_name = s.degree and t.class_id = c.class_id and t.grade != 'IC' and gc.letter_grade = t.grade and t.grade_option != 'S/U' group by ct.name,ct.min_gpa having avg(gc.number_grade*t.unit)/sum(t.unit) > ct.min_gpa);");
                        stmt2.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        stmt2.setInt(2, Integer.parseInt(request.getParameter("ID")));
                        ResultSet rs2 = stmt2.executeQuery();
                        
                        stmt3 = conn.prepareStatement("Select c.course_no, cls.quarter from concentration c, class cls where c.course_no not in (SELECt ct.course_no from concentration ct, take t, student s, class c where s.id = t.id      and s.id = ? and c.course_no = ct.course_no and ct.degree_name = s.degree and t.class_id = c.class_id and t.grade != 'IC') and cls.instructor is NULL and cls.course_no = c.course_no"
                        );
                        stmt3.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        ResultSet rs3 = stmt3.executeQuery();
                        
                        stmt5 = conn.prepareStatement("select c.course_no, t.unit from student s, take t, class c where s.id = 17 and t.id = s.id and t.class_id = c.class_id and c.section_id = t.section_id"); 
                        ResultSet rs5 = stmt5.executeQuery();

                        stmt6 = conn.prepareStatement("select d.grad_unit from student s, degrees d where d.name = s.degree and s.id = ?"); 
                        stmt6.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        ResultSet rs6 = stmt6.executeQuery();
                        
                        int remainingUnits  = 0;
                        if(rs6.next())
                            remainingUnits = rs6.getInt("grad_unit");
                        while(rs5.next()){
                            String course_no = rs5.getString("course_no");
                            int num = 0;
                            for(char c : course_no.toCharArray()){
                                if(Character.isDigit(c)){
                                    num = num*10 + (c-'0');
                                }
                            }
                            if(num >= 200) remainingUnits -= rs5.getInt("unit");
                        }

                    while (RS.next()) 
                    {
            %>
                            <tr>
                                <th>ID</th>
                                <th>Firstname</th>
                                <th>Middle Name</th>
                                <th>lastname</th>
                                <th>Degree</th>
                                <th>remaining units</th>
                                <th>Completed</th>
                            </tr>
                            <tr>
                                <td><%= RS.getString("ID") %></td>
                                <td><%= RS.getString("FIRSTNAME") %></td>
                                <td><%= RS.getString("MIDDLENAME") %></td>
                                <td><%= RS.getString("LASTNAME") %></td>
                                <td><%= RS.getString("NAME") %></td>
                                <td><%= Integer.toString(remainingUnits) %></td>
                <%
                        while (rs2.next()) 
                        {
                %>
                                    <td><%= rs2.getString("completed") %></td>
                <%
                        }
                %>
                            </tr>
            <%
                    }
            %>

            <%
                    while (rs3.next()) 
                    {
            %>

                            <tr>
                                <td><%= rs3.getString("course_no") %></td>
                                <td><%= rs3.getString("quarter") %></td>
                            </tr>
            <%
                    }
                }
            %>
            
			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM STUDENT s, MS bs WHERE s.ID = bs.ID AND s.enrollment = true");
            %>
                <table border="1">
                <form action="Report1e.jsp" method="get">
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
                            <%= rs.getString("DEGREE") %>
                         </option>
            <%
                    }
            %>
                    </select>
                    <input type="submit" value="Submit" name="action">
                </form>

                


            <%
                    Statement statement2 = conn.createStatement();
                    ResultSet rs4 = statement2.executeQuery("SELECT * FROM STUDENT s, MS bs WHERE s.ID = bs.ID");
            %>
                <table border="1">
                    
                <form action="Report1e.jsp" method="get">
                    <select name="ID">

            <%
                    while (rs4.next()) 
                    {
            %>

                         <option value="<%= Integer.toString(rs4.getInt("ID")) %>"> 
                            <%= Integer.toString(rs4.getInt("ID")) %> 
                            <%= rs4.getString("FIRSTNAME") %>
                            <%= rs4.getString("MIDDLENAME") %>
                            <%= rs4.getString("LASTNAME") %>
                            <%= rs4.getString("DEGREE") %>
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
