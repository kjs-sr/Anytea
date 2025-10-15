package com.tea.controller;

import java.io.IOException;
import java.io.PrintWriter;

import com.tea.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 아이디, 닉네임, 이메일 중복 확인을 처리하는 서블릿
 */
@WebServlet("/checkDuplicate")
public class CheckDuplicateController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public CheckDuplicateController() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String field = request.getParameter("field"); // "userId", "nickname" 등
		String value = request.getParameter("value");
		
		UserDAO dao = UserDAO.getInstance();
		boolean isDuplicate = dao.isDuplicate(field, value);
		
		response.setContentType("text/plain");
		PrintWriter out = response.getWriter();
		
		if (isDuplicate) {
			out.print("duplicate"); // 중복일 경우
		} else {
			out.print("available"); // 사용 가능할 경우
		}
		out.flush();
	}
}

