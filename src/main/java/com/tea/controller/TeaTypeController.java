package com.tea.controller;

import java.io.IOException;
import java.util.List;

import com.tea.dao.InfoPostDAO;
import com.tea.dto.InfoPostDTO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/teatype")
public class TeaTypeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String category = request.getParameter("category");
        if (category == null || category.isEmpty()) {
            // 카테고리 파라미터가 없는 경우 기본 페이지로 리다이렉트 또는 에러 처리
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        InfoPostDAO infoPostDAO = InfoPostDAO.getInstance();

        // 1. INFO 게시글 목록 가져오기
        List<InfoPostDTO> postList = infoPostDAO.getPostsByCategory(category);
        
        // 2. INTRO 게시글 정보 가져오기 (대표 이미지 및 링크용)
        InfoPostDTO introPost = infoPostDAO.getIntroPostByCategory(category);

        // 3. JSP로 데이터 전달
        request.setAttribute("category", category);
        request.setAttribute("postList", postList);
        request.setAttribute("introPost", introPost); // introPost 객체 전체를 전달

        // 4. JSP로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/tea_type.jsp");
        dispatcher.forward(request, response);
    }
}

