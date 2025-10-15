package com.tea.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.tea.dao.PostDAO;
import com.tea.dto.PostDTO;

@WebServlet("/")
public class HomeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public HomeController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// [수정] DAO를 통해 인기글과 최신글 목록을 조회합니다.
		PostDAO dao = PostDAO.getInstance();
		List<PostDTO> popularPosts = dao.getPopularPosts();
		List<PostDTO> latestPosts = dao.getLatestPosts();
		
		// [수정] 조회된 데이터를 request 객체에 담아 JSP로 전달합니다.
		request.setAttribute("popularPosts", popularPosts);
		request.setAttribute("latestPosts", latestPosts);
		
		String viewPath = "/WEB-INF/views/home.jsp";
		RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}

