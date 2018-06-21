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
                        conn.setAutoCommit(false);
                        PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Student VALUES (?, ?, ?, ?, ?, ?, ?)");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("SSN")));
                        pstmt.setString(3, request.getParameter("FIRSTNAME"));
                        pstmt.setString(4, request.getParameter("MIDDLENAME"));
                        pstmt.setString(5, request.getParameter("LASTNAME"));
                        pstmt.setBoolean(6, Boolean.parseBoolean(request.getParameter("ENROLLMENT")));
			            if(request.getParameter("DEGREE").equals("BS"))
                        {
                        	pstmt.setString(7, "BS");
                        }
			            else if(request.getParameter("DEGREE").equals("MS"))
                        {
                        	pstmt.setString(7, "MS");
                        }
			            else if(request.getParameter("DEGREE").equals("BSMS"))
                        {
                        	pstmt.setString(7, "BSMS");
                        }
			            else if(request.getParameter("DEGREE").equals("Phd"))
                        {
                        	pstmt.setString(7, "Phd");
                        }
			            else throw new Exception("invalid degree");

                        int rowCount = pstmt.executeUpdate();
                        if(request.getParameter("DEGREE").equals("MS"))
                        {
			                 
                             PreparedStatement pstmt2 = conn.prepareStatement("INSERT INTO MS VALUES (?)");
                             pstmt2.setInt(1, Integer.parseInt(request.getParameter("ID")));
                             int RowCount = pstmt2.executeUpdate();
                        } 
                        else if(request.getParameter("DEGREE").equals("BS"))
                        {
			     //bs
                             PreparedStatement pstmt2 = conn.prepareStatement("INSERT INTO BS VALUES (?, ?)");
                             pstmt2.setInt(1, Integer.parseInt(request.getParameter("ID")));
                             pstmt2.setString(2, request.getParameter("COLLEGE"));
                             int RowCount = pstmt2.executeUpdate();
			            } 
                        else if(request.getParameter("DEGREE").equals("Phd"))
                        {
			     //phd
                             PreparedStatement pstmt2 = conn.prepareStatement("INSERT INTO BS VALUES (?, ?)");
                             pstmt2.setInt(1, Integer.parseInt(request.getParameter("ID")));
                             pstmt2.setString(2, request.getParameter("ADVISOR"));
                             int RowCount = pstmt2.executeUpdate();
			            }

			//grad
                        if(request.getParameter("DEGREE").equals("MS") || request.getParameter("DEGREE").equals("Phd"))
                        {
                             PreparedStatement pstmt3 = conn.prepareStatement("INSERT INTO grad (ID, DEPARTMENT) VALUES (?, ?)");
                             pstmt3.setInt(1, Integer.parseInt(request.getParameter("ID")));
                             pstmt3.setString(2, request.getParameter("DEPARTMENT"));
                             
                             int RowCount = pstmt3.executeUpdate();
                        } 
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>
			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT s.ID, s.SSN, s.FIRSTNAME, s.MIDDLENAME, s.LASTNAME, s.ENROLLMENT, s.DEGREE, b.COLLEGE, g.DEPARTMENT, p.ADVISOR FROM Student s LEFT JOIN PHD p ON s.ID = p.ID LEFT JOIN GRAD g ON g.ID = s.ID LEFT JOIN BS b ON s.ID = b.ID");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>ID</th>
                        <th>SSN</th>
                        <th>First</th>
			            <th>Middle</th>
                        <th>Last</th>
                        <th>Enrollment</th>
                        <th>Degree</th>
                        <th>College</th>
                        <th>Department</th>
                        <th>Advisor</th>
                    </tr>
                    <tr>
                        <form action="StudentEntry.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="ID" size="20"></th>
                            <th><input value="" name="SSN" size="20"></th>
                            <th><input value="" name="FIRSTNAME" size="20"></th>
			                <th><input value="" name="MIDDLENAME" size="20"></th>
                            <th><input value="" name="LASTNAME" size="20"></th>
                            <th><input value="" name="ENROLLMENT" size="20"></th>
                             <th><input value="" name="DEGREE" size="20"></th>
                             <th><input value="" name="COLLEGE" size="20"></th>
                             <th><input value="" name="DEPARTMENT" size="20"></th>
                             <th><input value="" name="ADVISOR" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>

                            <td> <%= Integer.toString(rs.getInt("ID")) %> </td>
    						<td> <%= Integer.toString(rs.getInt("SSN")) %> </td>
    
                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <%= rs.getString("FIRSTNAME") %>
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                               <%= rs.getString("MIDDLENAME") %>
                            </td>
    
			    <%-- Get the LASTNAME --%>
                            <td>
                                <%= rs.getString("LASTNAME") %>
                            </td>

                            <%-- Get the COLLEGE --%>
                            <td>
                                <%= Boolean.toString(rs.getBoolean("ENROLLMENT")) %>
                            </td>
                            <td>
                                <%= rs.getString("DEGREE") %>
                            </td>
                            <td>
                                <%= rs.getString("COLLEGE") %>
                            </td>
                            <td>
                                <%= rs.getString("DEPARTMENT") %>
                            </td>
                            <td>
                                <%= rs.getString("ADVISOR") %>
                            </td>

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
