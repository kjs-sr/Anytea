package com.tea.controller;

import java.io.IOException;
import java.io.PrintWriter;

import com.tea.dao.UserDAO;
import com.tea.dto.UserDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/findId")
public class FindIdController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public FindIdController() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userAuthCode = request.getParameter("authCode");
		
		HttpSession session = request.getSession();
		String sessionAuthCode = (String) session.getAttribute("findIdAuthCode");
		String email = (String) session.getAttribute("findIdEmail");

		response.setContentType("text/plain; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		if (sessionAuthCode != null && email != null && sessionAuthCode.equals(userAuthCode)) {
			UserDAO dao = UserDAO.getInstance();
			UserDTO user = dao.findUserByEmail(email);
			
			if (user != null && user.getUserId() != null) {
				String userId = user.getUserId();
				int halfLength = userId.length() / 2;
				String maskedId = userId.substring(0, halfLength) + "*".repeat(userId.length() - halfLength);
				
				session.removeAttribute("findIdAuthCode");
				session.removeAttribute("findIdEmail");
				
				out.print("found:" + maskedId);
			} else {
				out.print("not_found_after_verification");
			}
		} else {
			out.print("verification_failed");
		}
		out.flush();
	}
}

