package com.tea.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;
import com.tea.dao.UserDAO;
import com.tea.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/sendFindPwAuthCode")
public class SendFindPwAuthController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SendFindPwAuthController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String email = request.getParameter("email");

        if (userId != null) userId = userId.trim();
        if (email != null) email = email.trim();

        response.setContentType("text/plain; charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (userId == null || userId.isEmpty() || email == null || email.isEmpty()) {
            out.print("invalid_input");
            out.flush();
            return;
        }

        UserDAO dao = UserDAO.getInstance();
        if (dao.findUserByIdAndEmail(userId, email)) {
            int num = new Random().nextInt(888888) + 111111;
            String authCode = String.valueOf(num);

            boolean isSuccess = EmailUtil.sendEmail(email, EmailUtil.EmailType.PASSWORD_RESET_AUTH, authCode);

            if (isSuccess) {
                HttpSession session = request.getSession();
                session.setAttribute("findPwAuthCode", authCode);
                session.setAttribute("findPwUserId", userId);
                out.print("success");
            } else {
                out.print("fail");
            }
        } else {
            out.print("not_found");
        }
        out.flush();
    }
}
