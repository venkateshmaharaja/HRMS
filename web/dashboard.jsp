

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="db.db_connection"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" type="image/png" href="images/icons/favicon.ico"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="bootstrap files/3.4.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="bootstrap files/3.4.1/css/bootstrap.min.css.map">
        <script src="bootstrap files/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="bootstrap files/3.4.1/js/bootstrap.min.js"></script>
        <title>Dashboard</title>
        <style>
            body{
                background-color: #fff;
                background-image: url("images/hrms_3.jpg");
                background-repeat: no-repeat;
                /*                background-size: 100%;*/
                background-size: cover;

            }
        </style>

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
        %>
        <%@include file="menu.jsp"%>
        <%@include file="master_input.jsp"%>
        <%}
            } catch (Exception ex) {
                out.print(ex.toString());
                response.sendRedirect("index.jsp");
            }
        %>

    </body>
    <footer style="margin-top: 535px;">
        <center>
            Copyrights © 2020 All Rights Reserved. Powered by SVA.
        </center>
    </footer>
</html>
