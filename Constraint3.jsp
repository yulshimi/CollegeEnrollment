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
            <%@ page language="java" import="java.sql.*, java.util.*" %>
    
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
                    if(action != null && action.equals("update")) 
                    {
                        conn.setAutoCommit(false);
                        PreparedStatement mstmt = conn.prepareStatement("SELECT*FROM CLASSSUPPORT2 WHERE INSTRUCTOR = ? AND SECTION_ID != ?");
                        mstmt.setString(1, request.getParameter("INSTRUCTOR"));
                        mstmt.setString(2, request.getParameter("SECTION_ID"));
                        ResultSet RS = mstmt.executeQuery();
                        RS.next();
                        String course_no = RS.getString("COURSE_NO");
                        String section_id = RS.getString("SECTION_ID");
                        int enroll_limit = RS.getInt("ENROLL_LIMIT");
                        int curr_enroll = RS.getInt("CURR_ENROLL");
                        String instructor = RS.getString("INSTRUCTOR");
                        String quarter = RS.getString("QUARTER");
                        String lec1 = RS.getString("LEC1");
                        String lec2 = RS.getString("LEC2");
                        String lec3 = RS.getString("LEC3");
                        String dis1 = RS.getString("DIS1");
                        String dis2 = RS.getString("DIS2");
                        String lab1 = RS.getString("LAB1");
                        String lab2 = RS.getString("LAB2");

                        PreparedStatement pstmt = conn.prepareStatement("UPDATE CLASSSUPPORT2 SET LEC1 = ?, LEC2 = ?, LEC3 = ?, DIS1 = ?, DIS2 = ?, LAB1 = ?, LAB2 = ? WHERE INSTRUCTOR = ? AND SECTION_ID != ?"); //Check duplicate values
                        pstmt.setString(1, request.getParameter("LEC1"));
                        pstmt.setString(2, request.getParameter("LEC2"));
                        pstmt.setString(3, request.getParameter("LEC3"));
                        pstmt.setString(4, request.getParameter("DIS1"));
                        pstmt.setString(5, request.getParameter("DIS2"));
                        pstmt.setString(6, request.getParameter("LAB1"));
                        pstmt.setString(7, request.getParameter("LAB2"));
                        pstmt.setString(8, request.getParameter("INSTRUCTOR"));
                        pstmt.setString(9, request.getParameter("SECTION_ID"));
                        int rowCount = pstmt.executeUpdate();

                        PreparedStatement dstmt = conn.prepareStatement("DELETE FROM CLASSSUPPORT2 WHERE SECTION_ID = ?");
                        dstmt.setString(1, request.getParameter("SECTION_ID"));
                        dstmt.executeUpdate();


                        PreparedStatement dstmt2 = conn.prepareStatement("DELETE FROM CLASSSUPPORT2 WHERE SECTION_ID = ?");
                        dstmt2.setString(1, section_id);
                        dstmt2.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement("INSERT INTO CLASSSUPPORT2 VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)");
                        pstmt2.setString(1, request.getParameter("COURSE_NO"));
                        pstmt2.setString(2, request.getParameter("SECTION_ID"));
                        pstmt2.setInt(3, Integer.parseInt(request.getParameter("ENROLL_LIMIT")));
                        pstmt2.setInt(4, Integer.parseInt(request.getParameter("CURR_ENROLL")));
                        pstmt2.setString(5, request.getParameter("INSTRUCTOR"));
                        pstmt2.setString(6, request.getParameter("QUARTER"));
                        if(request.getParameter("LEC1").equals("X"))
                        {
                            pstmt2.setString(7, "LEC1");
                        }
                        else
                        {
                            pstmt2.setString(7, request.getParameter("LEC1"));
                        }

                        if(request.getParameter("LEC2").equals("X"))
                        {
                            pstmt2.setString(8, "LEC2");
                        }
                        else
                        {
                            pstmt2.setString(8, request.getParameter("LEC2"));
                        }

                        if(request.getParameter("LEC3").equals("X"))
                        {
                            pstmt2.setString(9, "LEC3");
                        }
                        else
                        {
                            pstmt2.setString(9, request.getParameter("LEC3"));
                        }

                        if(request.getParameter("DIS1").equals("X"))
                        {
                            pstmt2.setString(10, "DIS1");
                        }
                        else
                        {
                            pstmt2.setString(10, request.getParameter("DIS1"));
                        }

                        if(request.getParameter("DIS2").equals("X"))
                        {
                            pstmt2.setString(11, "DIS2");
                        }
                        else
                        {
                            pstmt2.setString(11, request.getParameter("DIS2"));
                        }

                        if(request.getParameter("LAB1").equals("X"))
                        {
                            pstmt2.setString(12, "LAB1");
                        }
                        else
                        {
                            pstmt2.setString(12, request.getParameter("LAB1"));
                        }

                        if(request.getParameter("LAB2").equals("X"))
                        {
                            pstmt2.setString(13, "LAB2");
                        }
                        else
                        {
                            pstmt2.setString(13, request.getParameter("LAB2"));
                        }
                        int lrowCount = pstmt2.executeUpdate();

                        PreparedStatement pstmt3 = conn.prepareStatement("INSERT INTO CLASSSUPPORT2 VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)");
                        pstmt3.setString(1, course_no);
                        pstmt3.setString(2, section_id);
                        pstmt3.setInt(3, enroll_limit);
                        pstmt3.setInt(4, curr_enroll);
                        pstmt3.setString(5, instructor);
                        pstmt3.setString(6, quarter);
                        pstmt3.setString(7, lec1);
                        pstmt3.setString(8, lec2);
                        pstmt3.setString(9, lec3);
                        pstmt3.setString(10, dis1);
                        pstmt3.setString(11, dis2);
                        pstmt3.setString(12, lab1);
                        pstmt3.setString(13, lab2);
                        int mrowCount = pstmt3.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    if(action != null && action.equals("insert")) 
                    {
                        int count = 0;
                        Vector<String> course_no = new Vector<String>();
                        Vector<String> section_id = new Vector<String>();
                        Vector<Integer> enroll_limit = new Vector<Integer>();
                        Vector<Integer> curr_enroll = new Vector<Integer>();
                        Vector<String> instructor = new Vector<String>();
                        Vector<String> quarter = new Vector<String>();
                        Vector<String> lec1 = new Vector<String>();
                        Vector<String> lec2 = new Vector<String>();
                        Vector<String> lec3 = new Vector<String>();
                        Vector<String> dis1 = new Vector<String>(); 
                        Vector<String> dis2 = new Vector<String>();
                        Vector<String> lab1 = new Vector<String>();
                        Vector<String> lab2 = new Vector<String>();   
                        PreparedStatement imstmt = conn.prepareStatement("SELECT*FROM CLASSSUPPORT2 WHERE INSTRUCTOR = ? AND SECTION_ID != ?");
                        imstmt.setString(1, request.getParameter("INSTRUCTOR"));
                        imstmt.setString(2, request.getParameter("SECTION_ID"));
                        ResultSet iRS = imstmt.executeQuery();
                        while(iRS.next())
                        {
                            ++count;
                            course_no.add(iRS.getString("COURSE_NO"));
                            section_id.add(iRS.getString("SECTION_ID"));
                            enroll_limit.add(iRS.getInt("ENROLL_LIMIT"));
                            curr_enroll.add(iRS.getInt("CURR_ENROLL"));
                            instructor.add(iRS.getString("INSTRUCTOR"));
                            quarter.add(iRS.getString("QUARTER"));
                            lec1.add(iRS.getString("LEC1"));
                            lec2.add(iRS.getString("LEC2"));
                            lec3.add(iRS.getString("LEC3"));
                            dis1.add(iRS.getString("DIS1"));
                            dis2.add(iRS.getString("DIS2"));
                            lab1.add(iRS.getString("LAB1"));
                            lab2.add(iRS.getString("LAB2"));
                        } // All old values are saved!

                        PreparedStatement ipstmt = conn.prepareStatement("UPDATE CLASSSUPPORT2 SET LEC1 = ?, LEC2 = ?, LEC3 = ?, DIS1 = ?, DIS2 = ?, LAB1 = ?, LAB2 = ? WHERE INSTRUCTOR = ? AND SECTION_ID != ?"); //Check duplicate values
                        ipstmt.setString(1, request.getParameter("LEC1"));
                        ipstmt.setString(2, request.getParameter("LEC2"));
                        ipstmt.setString(3, request.getParameter("LEC3"));
                        ipstmt.setString(4, request.getParameter("DIS1"));
                        ipstmt.setString(5, request.getParameter("DIS2"));
                        ipstmt.setString(6, request.getParameter("LAB1"));
                        ipstmt.setString(7, request.getParameter("LAB2"));
                        ipstmt.setString(8, request.getParameter("INSTRUCTOR"));
                        ipstmt.setString(9, request.getParameter("SECTION_ID"));
                        int rowCount = ipstmt.executeUpdate(); // Check duplicates

                        for(int i=0; i < count; ++i)
                        {
                            PreparedStatement idstmt = conn.prepareStatement("DELETE FROM CLASSSUPPORT2 WHERE SECTION_ID = ?");
                            idstmt.setString(1, section_id.get(i));
                            idstmt.executeUpdate();
                        }

                        for(int i=0; i < count; ++i)
                        {
                            PreparedStatement ipstmt3 = conn.prepareStatement("INSERT INTO CLASSSUPPORT2 VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)");
                            ipstmt3.setString(1, course_no.get(i));
                            ipstmt3.setString(2, section_id.get(i));
                            ipstmt3.setInt(3, enroll_limit.get(i));
                            ipstmt3.setInt(4, curr_enroll.get(i));
                            ipstmt3.setString(5, instructor.get(i));
                            ipstmt3.setString(6, quarter.get(i));
                            ipstmt3.setString(7, lec1.get(i));
                            ipstmt3.setString(8, lec2.get(i));
                            ipstmt3.setString(9, lec3.get(i));
                            ipstmt3.setString(10, dis1.get(i));
                            ipstmt3.setString(11, dis2.get(i));
                            ipstmt3.setString(12, lab1.get(i));
                            ipstmt3.setString(13, lab2.get(i));
                            int mrowCount = ipstmt3.executeUpdate();
                        }

                        PreparedStatement ipstmt2 = conn.prepareStatement("INSERT INTO CLASSSUPPORT2 VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)");
                        ipstmt2.setString(1, request.getParameter("COURSE_NO"));
                        ipstmt2.setString(2, request.getParameter("SECTION_ID"));
                        ipstmt2.setInt(3, Integer.parseInt(request.getParameter("ENROLL_LIMIT")));
                        ipstmt2.setInt(4, Integer.parseInt(request.getParameter("CURR_ENROLL")));
                        ipstmt2.setString(5, request.getParameter("INSTRUCTOR"));
                        ipstmt2.setString(6, request.getParameter("QUARTER"));
                        if(request.getParameter("LEC1").equals("X"))
                        {
                            ipstmt2.setString(7, "LEC1");
                        }
                        else
                        {
                            ipstmt2.setString(7, request.getParameter("LEC1"));
                        }

                        if(request.getParameter("LEC2").equals("X"))
                        {
                            ipstmt2.setString(8, "LEC2");
                        }
                        else
                        {
                            ipstmt2.setString(8, request.getParameter("LEC2"));
                        }

                        if(request.getParameter("LEC3").equals("X"))
                        {
                            ipstmt2.setString(9, "LEC3");
                        }
                        else
                        {
                            ipstmt2.setString(9, request.getParameter("LEC3"));
                        }

                        if(request.getParameter("DIS1").equals("X"))
                        {
                            ipstmt2.setString(10, "DIS1");
                        }
                        else
                        {
                            ipstmt2.setString(10, request.getParameter("DIS1"));
                        }

                        if(request.getParameter("DIS2").equals("X"))
                        {
                            ipstmt2.setString(11, "DIS2");
                        }
                        else
                        {
                            ipstmt2.setString(11, request.getParameter("DIS2"));
                        }

                        if(request.getParameter("LAB1").equals("X"))
                        {
                            ipstmt2.setString(12, "LAB1");
                        }
                        else
                        {
                            ipstmt2.setString(12, request.getParameter("LAB1"));
                        }

                        if(request.getParameter("LAB2").equals("X"))
                        {
                            ipstmt2.setString(13, "LAB2");
                        }
                        else
                        {
                            ipstmt2.setString(13, request.getParameter("LAB2"));
                        }
                        int lrowCount = ipstmt2.executeUpdate();

                    }
            %>

			<%-- -------- SELECT Statement Code -------- --%>
            <%
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM CLASSSUPPORT2");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>COURSE_NO</th>
                        <th>SECTION_ID</th>
                        <th>ENROLL_LIMIT</th>
                        <th>CURR_ENROLL</th>
                        <th>INSTRUCTOR</th>
                        <th>QUARTER</th>
                        <th>LEC1</th>
                        <th>LEC2</th>
                        <th>LEC3</th>
                        <th>DIS1</th>
                        <th>DIS2</th>
                        <th>LAB1</th>
                        <th>LAB2</th>
                    </tr>
                    <tr>
                      <form action="Constraint3.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="" name="COURSE_NO" size="20"></th>
                            <th><input value="" name="SECTION_ID" size="20"></th>
                            <th><input value="" name="ENROLL_LIMIT" size="20"></th>
                            <th><input value="" name="CURR_ENROLL" size="20"></th>
                            <th><input value="" name="INSTRUCTOR" size="20"></th>
                            <th><input value="" name="QUARTER" size="20"></th>
                            <th><input value="" name="LEC1" size="20"></th>
                            <th><input value="" name="LEC2" size="20"></th>
                            <th><input value="" name="LEC3" size="20"></th>
                            <th><input value="" name="DIS1" size="20"></th>
                            <th><input value="" name="DIS2" size="20"></th>
                            <th><input value="" name="LAB1" size="20"></th>
                            <th><input value="" name="LAB2" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

                    <tr>
                        <th>COURSE_NO</th>
                        <th>SECTION_ID</th>
                        <th>ENROLL_LIMIT</th>
                        <th>CURR_ENROLL</th>
                        <th>INSTRUCTOR</th>
                        <th>QUARTER</th>
                        <th>LEC1</th>
                        <th>LEC2</th>
                        <th>LEC3</th>
                        <th>DIS1</th>
                        <th>DIS2</th>
                        <th>LAB1</th>
                        <th>LAB2</th>
                    </tr>
                    <tr>
                      <form action="Constraint3.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="COURSE_NO" size="20"></th>
                            <th><input value="" name="SECTION_ID" size="20"></th>
                            <th><input value="" name="ENROLL_LIMIT" size="20"></th>
                            <th><input value="" name="CURR_ENROLL" size="20"></th>
                            <th><input value="" name="INSTRUCTOR" size="20"></th>
                            <th><input value="" name="QUARTER" size="20"></th>
                            <th><input value="" name="LEC1" size="20"></th>
                            <th><input value="" name="LEC2" size="20"></th>
                            <th><input value="" name="LEC3" size="20"></th>
                            <th><input value="" name="DIS1" size="20"></th>
                            <th><input value="" name="DIS2" size="20"></th>
                            <th><input value="" name="LAB1" size="20"></th>
                            <th><input value="" name="LAB2" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>


            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <td><%= rs.getString("COURSE_NO") %></td>
                        <td><%= rs.getString("SECTION_ID") %></td>
                        <td><%= Integer.toString(rs.getInt("ENROLL_LIMIT")) %></td>
                        <td><%= Integer.toString(rs.getInt("CURR_ENROLL")) %></td>
                        <td><%= rs.getString("INSTRUCTOR") %></td>
                        <td><%= rs.getString("QUARTER") %></td>
                        <td><%= rs.getString("LEC1") %></td>
                        <td><%= rs.getString("LEC2") %></td>
                        <td><%= rs.getString("LEC3") %></td>
                        <td><%= rs.getString("DIS1") %></td>
                        <td><%= rs.getString("DIS2") %></td>
                        <td><%= rs.getString("LAB1") %></td>
                        <td><%= rs.getString("LAB2") %></td>
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