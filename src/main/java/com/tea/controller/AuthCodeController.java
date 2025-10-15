package com.tea.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

import com.tea.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/sendAuthCode")
public class AuthCodeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public AuthCodeController() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		
		Random random = new Random();
        int num = random.nextInt(888888) + 111111;
        String authCode = String.valueOf(num);
		
        // [수정] EmailUtil의 새로운 메소드를 사용하여 회원가입용 이메일을 발송합니다.
        boolean isSuccess = EmailUtil.sendEmail(email, EmailUtil.EmailType.REGISTRATION, authCode);
        
        response.setContentType("text/plain");
		PrintWriter out = response.getWriter();

		if(isSuccess) {
			HttpSession session = request.getSession();
			session.setAttribute("authCode", authCode);
			session.setAttribute("authCodeEmail", email);
			
			out.print("success");
		} else {
			out.print("fail");
		}
		out.flush();
	}
}
