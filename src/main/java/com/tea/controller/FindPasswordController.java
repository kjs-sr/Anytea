package com.tea.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.UUID;

// [추가] BCrypt 라이브러리를 임포트합니다.
import org.mindrot.jbcrypt.BCrypt;

import com.tea.dao.UserDAO;
import com.tea.dto.UserDTO;
import com.tea.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/findPassword")
public class FindPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public FindPasswordController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userAuthCode = request.getParameter("authCode");

        HttpSession session = request.getSession();
        String sessionAuthCode = (String) session.getAttribute("findPwAuthCode");
        String userId = (String) session.getAttribute("findPwUserId");

        response.setContentType("text/plain; charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (sessionAuthCode != null && userId != null && sessionAuthCode.equals(userAuthCode)) {
            // 8자리의 임시 비밀번호 생성 (평문)
            String tempPassword = UUID.randomUUID().toString().substring(0, 8);
            
            // [수정] 임시 비밀번호를 BCrypt로 해싱하여 저장할 준비를 합니다.
            String hashedPassword = BCrypt.hashpw(tempPassword, BCrypt.gensalt());

            UserDAO dao = UserDAO.getInstance();
            UserDTO user = dao.findUserById(userId); 
            
            if (user != null) {
                // [수정] DB의 비밀번호를 '해싱된' 임시 비밀번호로 업데이트합니다.
                int updateResult = dao.updatePassword(userId, hashedPassword);

                if (updateResult > 0) {
                    // [수정] 사용자에게는 해싱되지 않은 '평문' 임시 비밀번호를 이메일로 발송합니다.
                    boolean emailSent = EmailUtil.sendEmail(user.getEmail(), EmailUtil.EmailType.FIND_PASSWORD, tempPassword);
                    if (emailSent) {
                        session.removeAttribute("findPwAuthCode");
                        session.removeAttribute("findPwUserId");
                        out.print("success");
                    } else {
                        out.print("email_fail");
                    }
                } else {
                    out.print("update_fail");
                }
            } else {
                 out.print("user_not_found_after_verification");
            }
        } else {
            out.print("verification_failed");
        }
        out.flush();
    }
}

