package com.tea.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.regex.Pattern;
import org.mindrot.jbcrypt.BCrypt;
import com.tea.dao.UserDAO;
import com.tea.dto.UserDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateProfile")
public class UpdateProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 회원가입과 동일한 비밀번호 정규식
    private static final String PASSWORD_REGEX = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*])[a-zA-Z\\d!@#$%^&*]{8,24}$";

    public UpdateProfileController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loginUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        UserDAO dao = UserDAO.getInstance();
        boolean isUpdated = false;

        // 파라미터 받기
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String newPasswordConfirm = request.getParameter("newPasswordConfirm");
        String nickname = request.getParameter("nickname");

        // 이메일 변경은 인증 완료 후 세션에서 값을 가져옵니다.
        Boolean isNewEmailVerified = (Boolean) session.getAttribute("isNewEmailVerified");
        String newEmail = (String) session.getAttribute("newEmail");

        try {
            // 1. 비밀번호 변경 처리
            if (newPassword != null && !newPassword.isEmpty()) {
                if (currentPassword == null || currentPassword.isEmpty() || !BCrypt.checkpw(currentPassword, loginUser.getPassword())) {
                    sendAlert(response, "현재 비밀번호가 일치하지 않습니다.");
                    return;
                }
                if (!newPassword.equals(newPasswordConfirm)) {
                    sendAlert(response, "새로운 비밀번호가 일치하지 않습니다.");
                    return;
                }
                // 새로운 비밀번호 유효성 검사
                if (!Pattern.matches(PASSWORD_REGEX, newPassword)) {
                    sendAlert(response, "비밀번호는 8~24자의 영문, 숫자, 특수문자(!@#$%^&*)를 포함해야 합니다.");
                    return;
                }
                String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                loginUser.setPassword(hashedNewPassword);
                isUpdated = true;
            }

            // 2. 닉네임 변경 처리
            if (nickname != null && !nickname.equals(loginUser.getNickname())) {
                if(dao.isDuplicate("nickname", nickname)){
                    sendAlert(response, "이미 사용 중인 닉네임입니다.");
                    return;
                }
                loginUser.setNickname(nickname);
                isUpdated = true;
            }

            // 3. 이메일 변경 처리 (인증이 완료된 경우에만)
            if (isNewEmailVerified != null && isNewEmailVerified && newEmail != null) {
                if(dao.isDuplicate("email", newEmail)){
                    sendAlert(response, "이미 가입된 이메일입니다.");
                } else {
                    loginUser.setEmail(newEmail);
                    isUpdated = true;
                }
                // 인증 관련 세션은 성공/실패와 관계없이 정리
                session.removeAttribute("newEmail");
                session.removeAttribute("isNewEmailVerified");
            }

            // 4. 변경 사항이 있으면 DB에 업데이트
            if (isUpdated) {
                dao.updateUser(loginUser);
                session.setAttribute("loginUser", loginUser); // 세션 정보도 최신화
                sendAlertAndRedirect(response, "회원 정보가 성공적으로 수정되었습니다.", request.getContextPath() + "/edit-profile");
            } else {
                 sendAlert(response, "변경할 정보가 없거나, 이미 사용 중인 정보입니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendAlert(response, "정보 수정 중 오류가 발생했습니다.");
        }
    }
    
    private void sendAlert(HttpServletResponse response, String message) throws IOException {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>alert('" + message + "'); history.back();</script>");
        out.flush();
    }
    
    private void sendAlertAndRedirect(HttpServletResponse response, String message, String url) throws IOException {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>alert('" + message + "'); location.href='" + url + "';</script>");
        out.flush();
    }
}

