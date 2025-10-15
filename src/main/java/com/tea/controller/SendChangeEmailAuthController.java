package com.tea.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

import com.tea.util.EmailUtil;
import com.tea.util.EmailUtil.EmailType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/sendChangeEmailAuthCode")
public class SendChangeEmailAuthController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SendChangeEmailAuthController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
        Random random = new Random();
        int num = random.nextInt(888888) + 111111;
        String authCode = String.valueOf(num);
        
        // EmailUtil을 호출하여 '이메일 변경 인증' 타입의 메일을 발송합니다.
        boolean isSuccess = EmailUtil.sendEmail(email, EmailType.CHANGE_EMAIL_AUTH, authCode);
        
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        if(isSuccess) {
            HttpSession session = request.getSession();
            // VerifyNewEmailController가 사용할 수 있도록 세션에 인증정보를 저장합니다.
            session.setAttribute("authCode", authCode);
            session.setAttribute("authCodeEmail", email);
            
            out.print("success");
        } else {
            out.print("fail");
        }
        out.flush();
    }
}
