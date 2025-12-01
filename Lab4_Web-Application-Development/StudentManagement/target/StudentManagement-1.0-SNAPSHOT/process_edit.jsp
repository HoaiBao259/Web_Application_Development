<%@ page import="com.mycompany.studentmanagement.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String idStr = request.getParameter("id");
String student_code = request.getParameter("student_code");
String full_name = request.getParameter("full_name");
String email = request.getParameter("email");
String major = request.getParameter("major");

if(idStr == null || idStr.isEmpty()){
    response.sendRedirect("list_students.jsp?error=Invalid student ID");
    return;
}

int id = Integer.parseInt(idStr);

// 1. Validate student code
if(student_code == null || !student_code.matches("[A-Z]{2}[0-9]{3,}")) {
    response.sendRedirect("edit_student.jsp?id="+id+"&error=Invalid student code format (e.g. SV001)");
    return;
}

// 2. Validate email if provided
if(email != null && !email.isEmpty()) {
    if(!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
        response.sendRedirect("edit_student.jsp?id="+id+"&error=Invalid email format");
        return;
    }
}

// 3. Update student in DB
Connection conn = null;
PreparedStatement ps = null;
try {
    conn = DBConnection.getConnection();
    ps = conn.prepareStatement(
        "UPDATE students SET student_code=?, full_name=?, email=?, major=? WHERE id=?"
    );
    ps.setString(1, student_code);
    ps.setString(2, full_name);
    ps.setString(3, email);
    ps.setString(4, major);
    ps.setInt(5, id);
    ps.executeUpdate();
    response.sendRedirect("list_students.jsp?success=Student updated successfully");
} catch(Exception e) {
    response.sendRedirect("edit_student.jsp?id="+id+"&error=Error: " + e.getMessage());
} finally {
    try { if(ps != null) ps.close(); } catch(Exception e){}
    try { if(conn != null) conn.close(); } catch(Exception e){}
}
%>
