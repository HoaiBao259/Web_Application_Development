<%@ page import="com.mycompany.studentmanagement.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
int id = Integer.parseInt(request.getParameter("id"));
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
String student_code="", full_name="", email="", major="";

try {
    conn = DBConnection.getConnection();
    ps = conn.prepareStatement("SELECT * FROM students WHERE id=?");
    ps.setInt(1, id);
    rs = ps.executeQuery();
    if(rs.next()){
        student_code = rs.getString("student_code");
        full_name = rs.getString("full_name");
        email = rs.getString("email");
        major = rs.getString("major");
    } else {
        response.sendRedirect("list_students.jsp?error=Student not found");
        return;
    }
} catch(Exception e){
    response.sendRedirect("list_students.jsp?error=Error: "+e.getMessage());
} finally {
    try{ if(rs!=null) rs.close(); }catch(Exception e){}
    try{ if(ps!=null) ps.close(); }catch(Exception e){}
    try{ if(conn!=null) conn.close(); }catch(Exception e){}
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Student</title>
    <style>
        body { font-family: Arial, sans-serif; margin:20px; }
        .form-group { margin-bottom:15px; }
        label { display:block; margin-bottom:5px; }
        input { width: 300px; padding:5px; }
        button { padding:6px 12px; }
        .message { padding:10px; margin-bottom:15px; border-radius:4px; }
        .success { background-color:#d4edda; color:#155724; }
        .error { background-color:#f8d7da; color:#721c24; }
    </style>
    <script>
        setTimeout(function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) {
                msg.style.display = 'none';
            });
        }, 3000);

        function submitForm(form){
            var btn = form.querySelector('button[type="submit"]');
            btn.disabled = true;
            btn.textContent = 'Processing...';
            return true;
        }
    </script>
</head>
<body>
<h2>Edit Student</h2>

<% String error = request.getParameter("error"); 
   String success = request.getParameter("success");
   if(error != null){ %>
       <div class="message error">✗ <%= error %></div>
<% } else if(success != null){ %>
       <div class="message success">✓ <%= success %></div>
<% } %>

<form action="process_edit.jsp" method="POST" onsubmit="return submitForm(this);">
    <input type="hidden" name="id" value="<%= id %>">
    <div class="form-group">
        <label>Student Code:</label>
        <input type="text" name="student_code" required value="<%= student_code %>">
    </div>
    <div class="form-group">
        <label>Full Name:</label>
        <input type="text" name="full_name" required value="<%= full_name %>">
    </div>
    <div class="form-group">
        <label>Email:</label>
        <input type="text" name="email" value="<%= email %>">
    </div>
    <div class="form-group">
        <label>Major:</label>
        <input type="text" name="major" value="<%= major %>">
    </div>
    <button type="submit">Update Student</button>
    <a href="list_students.jsp" style="margin-left:10px;">Cancel</a>
</form>
</body>
</html>
