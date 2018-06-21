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
            <%@ page language="java" import="java.sql.*, java.io.*, java.util.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%!
                public int howManyDays(String start, String end)
                {
                    String dayStr_1="";
                    String dayStr_2="";
                    dayStr_1 += start.charAt(start.length()-2);
                    dayStr_1 += start.charAt(start.length()-1);
                    dayStr_2 += end.charAt(end.length()-2);
                    dayStr_2 += end.charAt(end.length()-1);
                    System.out.println("DayStr: " + dayStr_1 + " " + dayStr_2);
                    return Integer.parseInt(dayStr_2) - Integer.parseInt(dayStr_1) + 1;
                }

                public String whatIsDay(int num)
                {
                    while(7 < num)
                    {
                        num -= 7;
                    }
                    switch(num)
                    {
                        case 1:
                            return "THU";
                        case 2:
                            return "FRI";
                        case 3:
                            return "SAT";
                        case 4:
                            return "SUN";
                        case 5:
                            return "MON";
                        case 6:
                            return "TUE";
                        case 7:
                            return "WED";
                        default:
                            return "";
                    }
                }

                public void splice(String input, Vector<Integer> myVector)
                {
                    String currStr="";
                    for(int i=0; i < input.length(); ++i)
                    {
                        if(input.charAt(i) != '-')
                        {
                            currStr += input.charAt(i);
                        }
                        else
                        {
                            myVector.addElement(Integer.parseInt(currStr));
                            currStr = "";
                        }
                    }
                    myVector.addElement(Integer.parseInt(currStr));
                }

                public String incrementDay(String input)
                {
                    String retStr="";
                    String currStr="";
                    currStr = currStr + input.charAt(input.length()-2) + input.charAt(input.length()-1);
                    int counter = Integer.parseInt(currStr);
                    ++counter;
                    String countStr = Integer.toString(counter);
                    if(counter < 10)
                    {
                        countStr = '0' + countStr;
                    }
                    for(int i=0; i < input.length()-2; ++i)
                    {
                        retStr = retStr + input.charAt(i);
                    }
                    retStr = retStr + countStr;
                    return retStr;
                }
            %>
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
                        String[] timeTable = new String[12];
                        timeTable[0] = "08:00-09:00";
                        timeTable[1] = "09:00-10:00";
                        timeTable[2] = "10:00-11:00";
                        timeTable[3] = "11:00-12:00";
                        timeTable[4] = "12:00-13:00";
                        timeTable[5] = "13:00-14:00";
                        timeTable[6] = "14:00-15:00";
                        timeTable[7] = "15:00-16:00";
                        timeTable[8] = "16:00-17:00";
                        timeTable[9] = "17:00-18:00";
                        timeTable[10] = "18:00-19:00";
                        timeTable[11] = "19:00-20:00";
                        HashMap<String, Integer> map = new HashMap<>();
                        System.out.println("Hello");
                        PreparedStatement stmt;
                        stmt = conn.prepareStatement("SELECT ID, SECTION_ID FROM TAKE WHERE SEASON='sp2018' AND ID IN (SELECT B.ID FROM TAKE B WHERE B.SECTION_ID = ? AND B.SEASON = 'sp2018') ", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        stmt.setString(1, request.getParameter("section_number"));
                        ResultSet RS = stmt.executeQuery();
                        while(RS.next())
                        {
                            System.out.println("RS SECTION ID: " + RS.getString("SECTION_ID"));
                            PreparedStatement stmt_1;
                            stmt_1 = conn.prepareStatement("SELECT * FROM SECTION WHERE SECTION_ID = ? ");
                            stmt_1.setString(1, RS.getString("SECTION_ID"));  
                            ResultSet myRS = stmt_1.executeQuery();
                            while(myRS.next())
                            {
                                System.out.println("In the sky");
                                if(!map.containsKey(myRS.getString("WEEKLY_MEETING")))
                                {
                                    System.out.println("Hash: " + myRS.getString("WEEKLY_MEETING"));
                                    map.put(myRS.getString("WEEKLY_MEETING"), 0);
                                }
                            }  
                        }
                        int days = howManyDays(request.getParameter("start_date"), request.getParameter("end_date"));
                        Vector<Integer> myVec = new Vector<Integer>(3);
                        splice(request.getParameter("start_date"), myVec);
                        java.util.Calendar myCalendar = new java.util.GregorianCalendar(myVec.get(0), myVec.get(1), myVec.get(2));
                        int dayOfWeek = myCalendar.get(Calendar.DAY_OF_WEEK);
                        Vector<String> finalList = new Vector<String>();
                        String finalDay = request.getParameter("start_date");
                        for(int i=0; i < days; ++i)
                        {
                            for(int j=0; j < 12; ++j)
                            {
                                String currDay = whatIsDay(dayOfWeek);
                                currDay = currDay + " " + timeTable[j];
                                if(!map.containsKey(currDay))
                                {
                                    currDay = finalDay + " " + currDay;
                                    finalList.addElement(currDay);
                                }
                            }
                            ++dayOfWeek;
                            finalDay = incrementDay(finalDay);
                        }
                        for(int i=0; i < finalList.size(); ++i)
                        {
            %>
                            <tr><td><%= finalList.get(i) %></td></tr>
            <%
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
                <tr>
                    <form action="Report2b.jsp" method="get">
                        START_DATE:<br>
                        <input type="text" name="start_date" value=""><br>
                        END_DATE:<br>
                        <input type="text" name="end_date" value=""><br>
                        SECTION_NUMBER:<br>
                        <input type="text" name="section_number" value=""><br>
                        <input type="submit" value="Submit" name="action">
                    </form>
                </tr>
            <%-- -------- Close Connection Code -------- --%>
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