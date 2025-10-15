package com.tea.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/verifyNewEmail")
public class VerifyNewEmailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public VerifyNewEmailController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userAuthCode = request.getParameter("authCode");
        
        HttpSession session = request.getSession();
        // sendAuthCode 서블릿이 세션에 저장한 인증번호와 이메일을 가져옵니다.
        String sessionAuthCode = (String) session.getAttribute("authCode");
        String newEmailToVerify = (String) session.getAttribute("authCodeEmail");
        
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        
        if (sessionAuthCode != null && newEmailToVerify != null && sessionAuthCode.equals(userAuthCode)) {
            // 인증 성공 시, 정보 수정을 위해 새로운 세션 속성에 저장합니다.
            session.setAttribute("isNewEmailVerified", true); 
            session.setAttribute("newEmail", newEmailToVerify);
            
            // 기존 인증번호 관련 세션은 정리합니다.
            session.removeAttribute("authCode");
            session.removeAttribute("authCodeEmail");
            
            out.print("success");
        } else {
            out.print("fail");
        }
        out.flush();
    }
}
