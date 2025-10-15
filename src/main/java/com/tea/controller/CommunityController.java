package com.tea.controller;

import java.io.IOException;
import java.util.List;

import com.tea.dao.PostDAO;
import com.tea.dto.PostDTO;
import com.tea.dto.Pagination;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/community")
public class CommunityController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mainTag = request.getParameter("tag_main");
        String teaTag = request.getParameter("tag_tea");
        String regionTag = request.getParameter("tag_region");
        String titleQuery = request.getParameter("title_query");
        String pageStr = request.getParameter("page");
        String limitStr = request.getParameter("limit");
        
        int currentPage = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
        int postsPerPage = (limitStr == null || limitStr.isEmpty()) ? 10 : Integer.parseInt(limitStr);
        int pagesPerBlock = 5; // [수정] 한 번에 표시할 페이지 번호를 5개로 변경

        PostDAO dao = PostDAO.getInstance();
        
        int totalPosts = dao.getTotalPostCount(mainTag, teaTag, regionTag, titleQuery);
        Pagination pagination = new Pagination(currentPage, totalPosts, postsPerPage, pagesPerBlock);
        
        List<PostDTO> postList = dao.searchPosts(mainTag, teaTag, regionTag, titleQuery, currentPage, postsPerPage);
        
        String source = request.getParameter("source");

        if (source == null && mainTag != null && !mainTag.isEmpty()) {
            request.setAttribute("pageTitle", mainTag);
            request.setAttribute("showCategoryFilter", false);
        } else {
            request.setAttribute("pageTitle", "커뮤니티");
            request.setAttribute("showCategoryFilter", true);
        }

        request.setAttribute("postList", postList);
        request.setAttribute("pagination", pagination);
        request.setAttribute("limit", postsPerPage);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/community_list.jsp");
        dispatcher.forward(request, response);
    }
}

