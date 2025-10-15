package com.tea.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public LogoutController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 현재 세션을 가져온다. (없으면 null 반환)
		HttpSession session = request.getSession(false);
		
		// 2. 세션이 존재하면, 세션을 무효화시킨다.
		if (session != null) {
			session.invalidate();
		}
		
		// 3. 홈페이지로 리다이렉트
		response.sendRedirect(request.getContextPath() + "/");
	}
}
