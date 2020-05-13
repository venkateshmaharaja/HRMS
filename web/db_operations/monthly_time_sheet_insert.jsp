<%-- 
    Document   : emp_details_insert
    Created on : Mar 26, 2020, 4:29:15 PM
    Author     : VENKATESH
--%>
<%@page import="java.text.DecimalFormat"%>
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
                    Statement st1 = con.createStatement();
                    Statement st2 = con.createStatement();
                    Statement st3 = con.createStatement();
                    Statement st4 = con.createStatement();
                    Statement st5 = con.createStatement();
                    Statement st6 = con.createStatement();

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
                            int no_of_worked_days = 0;
                            int no_of_worked_sundays = 0;
                            int no_of_worked_spldays = 0;
                            int no_of_presented_days = 0;
                            int no_of_absented_days = 0;
                            int total_normal_ot_hours = 0;
                        //    String total_normal_ot_hours_decimal = "";
                            ResultSet rs_check_allemp_data_enter = st.executeQuery("SELECT count(*) from time_sheet where emp_id='" + al_active_emp_no.get(i) + "' and intime between '" + start_date + "' and '" + end_date + "' and  NOT attendance_status='SUN_PRESENT' and NOT attendance_status='SPL_PRESENT'");
                            while (rs_check_allemp_data_enter.next()) {
                                if (Integer.parseInt(no_working_day_in_month) <= Integer.parseInt(rs_check_allemp_data_enter.getString(1))) {


                                    ResultSet rs_no_of_worked_days = st1.executeQuery("select count(*) from time_sheet where emp_id='" + al_active_emp_no.get(i) + "' and attendance_status='PRESENT' and intime between '" + start_date + "' and '" + end_date + "'");
                                    while (rs_no_of_worked_days.next()) {
                                        no_of_worked_days = Integer.parseInt(rs_no_of_worked_days.getString(1));
                                    }


                                    ResultSet rs_no_of_worked_sunday = st2.executeQuery("select count(*) from time_sheet where emp_id='" + al_active_emp_no.get(i) + "' and attendance_status='SUN_PRESENT' and intime between '" + start_date + "' and '" + end_date + "'");
                                    while (rs_no_of_worked_sunday.next()) {
                                        no_of_worked_sundays = Integer.parseInt(rs_no_of_worked_sunday.getString(1));
                                    }

                                    ResultSet rs_no_of_worked_splday = st3.executeQuery("select count(*) from time_sheet where emp_id='" + al_active_emp_no.get(i) + "' and attendance_status='SPL_PRESENT' and intime between '" + start_date + "' and '" + end_date + "'");
                                    while (rs_no_of_worked_splday.next()) {
                                        no_of_worked_spldays = Integer.parseInt(rs_no_of_worked_splday.getString(1));
                                    }
                                    no_of_presented_days = no_of_worked_days + no_of_worked_sundays + no_of_worked_spldays;



                                    ResultSet rs_no_of_absented_day = st4.executeQuery("select count(*) from time_sheet where emp_id='" + al_active_emp_no.get(i) + "' and attendance_status='ABSENT' and intime between '" + start_date + "' and '" + end_date + "'");
                                    while (rs_no_of_absented_day.next()) {
                                        no_of_absented_days = Integer.parseInt(rs_no_of_absented_day.getString(1));
                                    }

                                    ResultSet rs_total_normal_ot_hours = st5.executeQuery("select sum(ot_hours) from time_sheet where emp_id='" + al_active_emp_no.get(i) + "' and attendance_status='PRESENT' and intime between '" + start_date + "' and '" + end_date + "'");
                                    while (rs_total_normal_ot_hours.next()) {
                                        total_normal_ot_hours = Integer.parseInt(rs_total_normal_ot_hours.getString(1));
                                    }
                           /*         DecimalFormat decimal_fmt = new DecimalFormat("#.#");
                                    total_normal_ot_hours_decimal = decimal_fmt.format(total_normal_ot_hours); */

                                    DecimalFormat decimal_fmt = new DecimalFormat("#.#");
                                    double total_normal_ot_hours_decimal = Double.valueOf(decimal_fmt.format(total_normal_ot_hours));

                                    out.println("<script type=\"text/javascript\">");
                                    out.println("alert('Daily Time Sheet All Data Inserted on " + al_active_emp_no.get(i) + "');");
                                    out.println("alert('Presented days " + no_of_worked_days + "');");
                                    out.println("alert('Presented Sundays " + no_of_worked_sundays + "');");
                                    out.println("alert('Presented Spldays " + no_of_worked_spldays + "');");
                                    out.println("alert('Total Presented days " + no_of_presented_days + "');");
                                    out.println("alert('Absented days " + no_of_absented_days + "');");
                                    out.println("alert('Total Normal OT Hours " + total_normal_ot_hours_decimal + "');");
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
