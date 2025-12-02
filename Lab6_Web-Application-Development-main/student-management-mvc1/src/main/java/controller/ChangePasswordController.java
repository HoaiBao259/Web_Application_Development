package controller;

import dao.UserDAO;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị form change-password.jsp
        request.getRequestDispatcher("/views/change-password.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String message;

        // 1. Validate current password
        if (!BCrypt.checkpw(currentPassword, currentUser.getPassword())) {
            message = "Current password is incorrect!";
        }
        // 2. Validate new password length
        else if (newPassword == null || newPassword.length() < 8) {
            message = "New password must be at least 8 characters!";
        }
        // 3. Validate confirm password
        else if (!newPassword.equals(confirmPassword)) {
            message = "New password and confirm password do not match!";
        } else {
            // Hash new password
            String hashedNew = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            boolean updated = userDAO.updatePassword(currentUser.getId(), hashedNew);
            if (updated) {
                message = "Password changed successfully!";
                // Update session user password
                currentUser.setPassword(hashedNew);
                session.setAttribute("user", currentUser);
            } else {
                message = "Failed to update password!";
            }
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("/views/change-password.jsp")
               .forward(request, response);
    }
}
