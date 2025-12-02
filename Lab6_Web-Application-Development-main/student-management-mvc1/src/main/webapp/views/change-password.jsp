<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Change Password</title>
</head>
<body>
<h2>Change Password</h2>

<c:if test="${not empty message}">
    <p style="color:red">${message}</p>
</c:if>

<form action="change-password" method="post">
    <input type="password" name="currentPassword" placeholder="Current Password" required><br><br>
    <input type="password" name="newPassword" placeholder="New Password" required><br><br>
    <input type="password" name="confirmPassword" placeholder="Confirm Password" required><br><br>
    <button type="submit">Change Password</button>
</form>

<p><a href="dashboard">Back to Dashboard</a></p>
</body>
</html>
