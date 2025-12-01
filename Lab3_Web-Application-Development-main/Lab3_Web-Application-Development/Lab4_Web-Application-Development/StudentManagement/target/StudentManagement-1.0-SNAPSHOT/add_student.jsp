<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Student</title>
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
<h2>Add New Student</h2>

<% String error = request.getParameter("error"); 
   String success = request.getParameter("success");
   if(error != null){ %>
       <div class="message error">✗ <%= error %></div>
<% } else if(success != null){ %>
       <div class="message success">✓ <%= success %></div>
<% } %>

<form action="process_add.jsp" method="POST" onsubmit="return submitForm(this);">
    <div class="form-group">
        <label>Student Code:</label>
        <input type="text" name="student_code" required placeholder="e.g. SV001">
    </div>
    <div class="form-group">
        <label>Full Name:</label>
        <input type="text" name="full_name" required>
    </div>
    <div class="form-group">
        <label>Email:</label>
        <input type="text" name="email" placeholder="optional">
    </div>
    <div class="form-group">
        <label>Major:</label>
        <input type="text" name="major">
    </div>
    <button type="submit">Add Student</button>
    <a href="list_students.jsp" style="margin-left:10px;">Cancel</a>
</form>
</body>
</html>
