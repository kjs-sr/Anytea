package com.tea.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tea.dao.UserDAO;
import com.tea.dto.UserDTO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public LoginController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String viewPath = "/WEB-INF/views/login.jsp";
		RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		String userId = request.getParameter("userId");
		String password = request.getParameter("password");
		
		UserDAO dao = UserDAO.getInstance();
		UserDTO user = dao.findUserById(userId);
		
		String errorMessage = null;
		
		// DB에서 가져온 user 객체나 비밀번호가 null인 경우, 또는 비밀번호가 일치하지 않는 경우를 한번에 처리합니다.
		if (user == null || user.getPassword() == null || !BCrypt.checkpw(password, user.getPassword())) {
			errorMessage = "아이디 또는 비밀번호가 일치하지 않습니다.";
		} 
		// 회원의 상태가 'ACTIVE'가 아닌 경우
		else if (!"ACTIVE".equals(user.getUserStatus())) {
			errorMessage = "탈퇴했거나 이용이 정지된 계정입니다.";
		}
		
		if (errorMessage == null) {
			// 로그인 성공
			HttpSession session = request.getSession();
			session.setAttribute("loginUser", user);
			response.sendRedirect(request.getContextPath() + "/");
		} else {
			// 로그인 실패
			request.setAttribute("errorMessage", errorMessage);
			doGet(request, response);
		}
	}
}

