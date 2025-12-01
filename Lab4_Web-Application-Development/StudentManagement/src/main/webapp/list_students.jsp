<%@ page import="com.mycompany.studentmanagement.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student List</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        h2 { margin-bottom: 10px; }
        a.btn { 
            display: inline-block; padding: 6px 12px; margin: 2px; 
            background-color: #007bff; color: white; text-decoration: none; border-radius: 4px; 
        }
        a.btn:hover { background-color: #0056b3; }
        table { border-collapse: collapse; width: 100%; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .message { padding: 10px; margin-bottom: 10px; border-radius: 4px; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
        .pagination a, .pagination strong { margin: 0 2px; padding: 4px 8px; text-decoration: none; border: 1px solid #ddd; border-radius: 4px; }
        .pagination strong { background-color: #007bff; color: white; border-color: #007bff; }
        .table-responsive { overflow-x: auto; }
        @media (max-width: 768px) {
            table { font-size: 12px; }
            th, td { padding: 5px; }
        }
    </style>
    <script>
        setTimeout(function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) { msg.style.display = 'none'; });
        }, 3000);

        function submitForm(form) {
            var btn = form.querySelector('button[type="submit"]');
            btn.disabled = true;
            btn.textContent = 'Processing...';
            return true;
        }
    </script>
</head>
<body>
<h2>Student List</h2>
<a href="add_student.jsp" class="btn">Add New Student</a>

<form action="list_students.jsp" method="GET" style="margin: 10px 0;" onsubmit="return submitForm(this)">
    <input type="text" name="keyword" placeholder="Search by name or code..." 
           value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
    <button type="submit" class="btn">Search</button>
    <a href="list_students.jsp" class="btn" style="background-color:#6c757d;">Clear</a>
</form>

<%
int recordsPerPage = 10;
int currentPage = 1;
String keyword = request.getParameter("keyword");
if(request.getParameter("page") != null){
    try { currentPage = Integer.parseInt(request.getParameter("page")); } catch(Exception e){ currentPage=1; }
}
int offset = (currentPage - 1) * recordsPerPage;

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
int totalRecords = 0;
int totalPages = 0;

try{
    conn = DBConnection.getConnection();

    // Count total records
    String countSql = "SELECT COUNT(*) FROM students";
    if(keyword != null && !keyword.trim().isEmpty()){
        countSql += " WHERE full_name LIKE ? OR student_code LIKE ?";
    }
    pstmt = conn.prepareStatement(countSql);
    if(keyword != null && !keyword.trim().isEmpty()){
        String pattern = "%" + keyword + "%";
        pstmt.setString(1, pattern);
        pstmt.setString(2, pattern);
    }
    rs = pstmt.executeQuery();
    if(rs.next()) totalRecords = rs.getInt(1);
    rs.close();
    pstmt.close();

    totalPages = (int)Math.ceil((double)totalRecords / recordsPerPage);

    // Fetch student records
    String sql = "SELECT * FROM students";
    if(keyword != null && !keyword.trim().isEmpty()){
        sql += " WHERE full_name LIKE ? OR student_code LIKE ?";
    }
    sql += " ORDER BY id ASC LIMIT ? OFFSET ?";
    pstmt = conn.prepareStatement(sql);

    int paramIndex = 1;
    if(keyword != null && !keyword.trim().isEmpty()){
        String pattern = "%" + keyword + "%";
        pstmt.setString(paramIndex++, pattern);
        pstmt.setString(paramIndex++, pattern);
    }
    pstmt.setInt(paramIndex++, recordsPerPage);
    pstmt.setInt(paramIndex, offset);

    rs = pstmt.executeQuery();
%>

<div class="table-responsive">
<table>
    <tr>
        <th>ID</th>
        <th>Student Code</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Major</th>
        <th>Created At</th>
        <th>Action</th>
    </tr>
<%
    while(rs.next()){
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("student_code") %></td>
        <td><%= rs.getString("full_name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("major") %></td>
        <td><%= rs.getTimestamp("created_at") %></td>
        <td>
            <a href="edit_student.jsp?id=<%= rs.getInt("id") %>" class="btn" style="background-color:#ffc107;">Edit</a>
            <a href="delete_student.jsp?id=<%= rs.getInt("id") %>" 
               onclick="return confirm('Are you sure you want to delete this student?')"
               class="btn" style="background-color:#dc3545;">Delete</a>
        </td>
    </tr>
<%
    }
%>
</table>
</div>

<% 
} catch(Exception e){ %>
<div class="message error">Error: <%= e.getMessage() %></div>
<% 
} finally {
    try{ if(rs!=null) rs.close(); } catch(Exception e){}
    try{ if(pstmt!=null) pstmt.close(); } catch(Exception e){}
    try{ if(conn!=null) conn.close(); } catch(Exception e){}
} 
%>

<% if(totalPages > 1){ %>
<div class="pagination">
<% for(int i=1; i<=totalPages; i++){
       if(i==currentPage){ %>
           <strong><%= i %></strong>
       <% } else { %>
           <a href="list_students.jsp?page=<%= i %><%= (keyword!=null && !keyword.isEmpty()) ? "&keyword="+keyword : "" %>"><%= i %></a>
<% } } %>
</div>
<% } %>

<%-- Show success/error messages from URL --%>
<%
String successMsg = request.getParameter("success");
String errorMsg = request.getParameter("error");
if(successMsg != null){ %>
    <div class="message success">✓ <%= successMsg %></div>
<% } 
if(errorMsg != null){ %>
    <div class="message error">✗ <%= errorMsg %></div>
<% } %>

</body>
</html>
