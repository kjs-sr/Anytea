package com.tea.controller;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/verifyAuthCode")
public class VerifyAuthCodeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public VerifyAuthCodeController() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userAuthCode = request.getParameter("authCode");
		
		HttpSession session = request.getSession();
		String sessionAuthCode = (String) session.getAttribute("authCode");
		
		response.setContentType("text/plain");
		PrintWriter out = response.getWriter();
		
		if (sessionAuthCode != null && sessionAuthCode.equals(userAuthCode)) {
			session.setAttribute("isEmailVerified", true); // 인증 완료 상태 저장
			out.print("success");
		} else {
			out.print("fail");
		}
		out.flush();
	}
}

