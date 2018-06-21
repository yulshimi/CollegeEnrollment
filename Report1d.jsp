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
            <%@ page import="java.util.HashSet" %>
    
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
                        PreparedStatement stmt, stmt2, stmt3;
                        stmt = conn.prepareStatement("SELECT s.ID, s.FIRSTNAME, s.LASTNAME, s.MIDDLENAME, d.NAME, d.LOWER_DIV_UNIT, d.UPPER_DIV_UNIT, d.TECH_ELECTIVE_UNIT FROM STUDENT s, DEGREES d WHERE s.ID = ? AND s.DEGREE = d.NAME");
                        stmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        ResultSet RS = stmt.executeQuery();
                        
                        //all classes this guy has taken
                        stmt2 = conn.prepareStatement("SELECT * FROM TAKE t, CLASS c WHERE t.ID = ? AND c.CLASS_ID = t.CLASS_ID AND t.SECTION_ID = c.SECTION_ID and t.grade != 'N/A' ");
                        stmt2.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        ResultSet rs2 = stmt2.executeQuery();
                        
                        //all technicall electives this guys has taken
                        stmt3 = conn.prepareStatement("SELECT te.course_no FROM STUDENT s, TECHNICAL_ELECTIVES te where s.id = ?");
                        stmt3.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        ResultSet rs3 = stmt3.executeQuery();

                        HashSet<String> set = new HashSet<>();
                        while(rs3.next()){
                            set.add(rs3.getString("COURSE_NO"));
                        }

                        if(RS.next()){

                        int LDU = RS.getInt("LOWER_DIV_UNIT");
                        int UDU = RS.getInt("UPPER_DIV_UNIT");
                        int TEU = RS.getInt("TECH_ELECTIVE_UNIT");
                        int total = LDU + UDU + TEU;

                        while(rs2.next()){
                            String course_no = rs2.getString("COURSE_NO");
                            int num = 0;
                            for(char c : course_no.toCharArray()){
                                if(Character.isDigit(c)){
                                    num = num*10 + (c-'0');
                                }
                            }
                            int unit = rs2.getInt("UNIT");
                            total -= unit;
                            if(num < 100) LDU -= unit;
                            else UDU -= unit;
                            if(set.contains(course_no)) TEU -= unit;
                        }
                        
            %>
                            <tr>
                                <th>ID</th>
                                <th>Firstname</th>
                                <th>Middle Name</th>
                                <th>lastname</th>
                                <th>Degree</th>
                                <th>Lower division units</th>
                                <th>upper division units</th>
                                <th>technical electives unit</th>
                                <th>total</th>
                            </tr>
                            <tr>
                                <td><%= RS.getString("ID") %></td>
                                <td><%= RS.getString("FIRSTNAME") %></td>
                                <td><%= RS.getString("MIDDLENAME") %></td>
                                <td><%= RS.getString("LASTNAME") %></td>
                                <td><%= RS.getString("NAME") %></td>
                                <td><%= Integer.toString(LDU) %></td>
                                <td><%= Integer.toString(UDU) %></td>
                                <td><%= Integer.toString(TEU) %></td>
                                <td><%= Integer.toString(LDU+UDU+TEU) %></td>
                            </tr>
            <%
                        }
                    }
            %>
            
			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM STUDENT s, BS bs WHERE s.ID = bs.ID AND s.enrollment = true");
            %>
                <table border="1">
                <form action="Report1d.jsp" method="get">
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
                    ResultSet rs4 = statement2.executeQuery("SELECT * FROM STUDENT s, BS bs WHERE s.ID = bs.ID");
            %>
                <table border="1">
                    
                <form action="Report1d.jsp" method="get">
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
