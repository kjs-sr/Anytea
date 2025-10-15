package com.tea.controller;

import java.io.IOException;
import org.mindrot.jbcrypt.BCrypt;
import com.tea.dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkPassword")
public class CheckPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CheckPasswordController() {
        super();
    }

    // 비밀번호 확인 페이지를 보여주는 GET 방식 요청
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/check_password.jsp").forward(request, response);
    }
    
    // 입력된 비밀번호를 검증하는 POST 방식 요청
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String inputPassword = request.getParameter("password");
        String nextAction = request.getParameter("nextAction");
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        // BCrypt를 사용하여 비밀번호 일치 여부 확인
        if (inputPassword != null && BCrypt.checkpw(inputPassword, loginUser.getPassword())) {
            // 비밀번호가 일치하면, 원래 하려던 작업(nextAction)으로 보냅니다.
            if ("editProfile".equals(nextAction)) {
                response.sendRedirect(request.getContextPath() + "/edit-profile");
            } else if ("withdraw".equals(nextAction)) {
                // [중요] 탈퇴 페이지로 이동하기 전, '허가증'을 발급합니다.
                session.setAttribute("isPasswordCheckedForWithdraw", true);
                response.sendRedirect(request.getContextPath() + "/withdraw");
            } else {
                response.sendRedirect(request.getContextPath() + "/"); // 기본값은 홈으로
            }
        } else {
            // 비밀번호가 일치하지 않으면, 에러 메시지와 함께 다시 확인 페이지를 보여줍니다.
            request.setAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            request.getRequestDispatcher("/WEB-INF/views/check_password.jsp").forward(request, response);
        }
    }
}

