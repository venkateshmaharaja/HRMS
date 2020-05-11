<%-- 
    Document   : emp_details_insert
    Created on : Mar 26, 2020, 4:29:15 PM
    Author     : VENKATESH
--%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="db.db_connection"%>
<%@page import="java.io.FileInputStream"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>emp_details_insert</title>
    </head>
    <body>
        <%


            try {
                String username = (String) session.getAttribute("username");
                String user_access = (String) session.getAttribute("user_access");

                session.setAttribute("username", username);
                session.setAttribute("user_access", user_access);
                //out.print(username);
                //out.print(user_access);
                if ((!username.equals("") && (!user_access.equals("")))) {


                    db_connection obj = new db_connection();
                    Connection con = obj.getConnection();
                    Statement st = con.createStatement();

                    DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                    DateFormat df1 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                    Date dateobj = new Date();
                    String currDate = df.format(dateobj);
                    // String currDate = df.format("2020-04-01");



                    int ans = 0;
                    String sal_month_year = "";
                    String sal_month = request.getParameter("sal_month");
                    String sal_year = request.getParameter("sal_year");
                    String no_working_day_in_month = request.getParameter("no_working_day_in_month");
                    String no_sundays = request.getParameter("no_sundays");
                    String no_spl_days = request.getParameter("no_spl_days");



                    SimpleDateFormat monthParse = new SimpleDateFormat("MM");
                    SimpleDateFormat monthDisplay = new SimpleDateFormat("MMM");
                    // out.print(monthDisplay.format(monthParse.parse(sal_month)));
                    sal_month_year = monthDisplay.format(monthParse.parse(sal_month));


                    if ((!sal_month.equals("")) && (!sal_year.equals("")) && (!no_working_day_in_month.equals("")) && (!no_sundays.equals("")) && (!no_spl_days.equals(""))) {

                        // ***START***         check the all emp data insert

                        ArrayList al_active_emp_no = new ArrayList();
                        //String start_date = sal_year + "-" + sal_month + "-01";
                        String start_date = sal_year + "-" + sal_month + "-01";

                        // String end_date = sal_year + "-" + sal_month + "-31";
                        String end_date = sal_year + "-" + sal_month + "-31";

                        out.print(start_date);
                        out.print(end_date);

                        ResultSet rs_get_active_emp_no = st.executeQuery("select emp_id from emp_details where emp_status='ACTIVE'");
                        while (rs_get_active_emp_no.next()) {
                            al_active_emp_no.add(rs_get_active_emp_no.getString(1));
                        }
                        for (int i = 0; i < al_active_emp_no.size(); i++) {

                            ResultSet rs_check_allemp_data_enter = st.executeQuery("SELECT count(*) from time_sheet where emp_id='" + al_active_emp_no.get(i) + "' and intime between '" + start_date + "' and '" + end_date + "' and  NOT attendance_status='SUN_PRESENT' and NOT attendance_status='SPL_PRESENT'");
                            while (rs_check_allemp_data_enter.next()) {
                                if (Integer.parseInt(no_working_day_in_month) <= Integer.parseInt(rs_check_allemp_data_enter.getString(1))) {


                                    out.println("<script type=\"text/javascript\">");
                                    out.println("alert('Daily Time Sheet All Data Inserted on " + al_active_emp_no.get(i) + "');");
                                    //out.write("setTimeout(function(){window.location.href='../dashboard.jsp'},1);");
                                    out.println("</script>");
                                    out.print(rs_check_allemp_data_enter.getString(1));
                                } else {
                                    out.println("<script type=\"text/javascript\">");
                                    out.println("alert('Emp no " + al_active_emp_no.get(i) + " Please Fill all data');");
                                    //out.write("setTimeout(function(){window.location.href='../dashboard.jsp'},1);");
                                    out.print(rs_check_allemp_data_enter.getString(1));
                                    out.println("</script>");
                                }
                            }
                        }

                        // ***START***         check the all emp data insert



                    } else {
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('Dont Put any Empty Data...');");
                        out.write("setTimeout(function(){window.location.href='../dashboard.jsp'},1);");
                        out.println("</script>");
                    }

                }
            } catch (Exception ex) {
                out.print(ex.toString());
            }
        %>
    </body>
</html>
