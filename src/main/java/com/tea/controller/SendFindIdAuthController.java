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

@WebServlet("/sendFindIdAuthCode")
public class SendFindIdAuthController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public SendFindIdAuthController() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		
		if (email != null) {
			email = email.trim();
		}
		
		response.setContentType("text/plain; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		if (email == null || email.isEmpty()) {
			out.print("invalid_email");
			out.flush();
			return;
		}
		
		UserDAO dao = UserDAO.getInstance();
		if (dao.isDuplicate("email", email)) {
	        int num = new Random().nextInt(888888) + 111111;
	        String authCode = String.valueOf(num);
			
	        // [수정] EmailUtil의 새로운 메소드를 사용하여 아이디 찾기용 이메일을 발송합니다.
	        boolean isSuccess = EmailUtil.sendEmail(email, EmailUtil.EmailType.FIND_ID, authCode);

			if(isSuccess) {
				HttpSession session = request.getSession();
				session.setAttribute("findIdAuthCode", authCode);
				session.setAttribute("findIdEmail", email);
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

