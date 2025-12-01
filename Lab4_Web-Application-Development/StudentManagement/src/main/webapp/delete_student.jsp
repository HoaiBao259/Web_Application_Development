<%@ page import="com.mycompany.studentmanagement.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
int id = Integer.parseInt(request.getParameter("id"));
try {
    Connection conn = DBConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement("DELETE FROM students WHERE id=?");
    ps.setInt(1, id);
    ps.executeUpdate();
    conn.close();
    response.sendRedirect("list_students.jsp");
} catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>
