package com.tea.controller;

import java.io.IOException;
import java.io.PrintWriter;
import org.mindrot.jbcrypt.BCrypt;
import com.tea.dao.UserDAO;
import com.tea.dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/withdraw")
public class WithdrawController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public WithdrawController() {
        super();
    }

    // 회원 탈퇴 확인 페이지를 보여주는 메소드
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // 1. 로그인 상태인지 먼저 확인
        if (session == null || session.getAttribute("loginUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // 2. CheckPasswordController가 발급한 '허가증'이 있는지 확인
        Object ticket = session.getAttribute("isPasswordCheckedForWithdraw");

        if (ticket != null && ticket.equals(true)) {
            // 3. '허가증'을 확인했으면 즉시 제거하여 재사용을 방지합니다.
            session.removeAttribute("isPasswordCheckedForWithdraw");
            
            // 모든 확인이 끝났으므로, 안전하게 탈퇴 페이지로 보냅니다.
            request.getRequestDispatcher("/WEB-INF/views/withdraw.jsp").forward(request, response);
        } else {
            // '허가증'이 없으면 비정상적인 접근으로 간주하고, 다시 비밀번호 확인 절차를 밟도록 보냅니다.
            response.sendRedirect(request.getContextPath() + "/checkPassword?action=withdraw");
        }
    }

    // 최종적으로 회원 탈퇴를 처리하는 메소드
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String password = request.getParameter("password");
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        // 최종 비밀번호 확인
        if (password != null && BCrypt.checkpw(password, loginUser.getPassword())) {
            // 비밀번호 일치: 회원 탈퇴 처리
            UserDAO dao = UserDAO.getInstance();
            dao.processWithdrawal(loginUser.getUserNo());

            session.invalidate(); // 세션 무효화

            // 알림창을 띄우고 홈으로 리다이렉트
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('회원 탈퇴가 정상적으로 처리되었습니다.'); location.href='" + request.getContextPath() + "/';</script>");
            out.flush();
        } else {
            // 비밀번호 불일치: 에러 메시지와 함께 다시 탈퇴 페이지로
            request.setAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            request.getRequestDispatcher("/WEB-INF/views/withdraw.jsp").forward(request, response);
        }
    }
}

