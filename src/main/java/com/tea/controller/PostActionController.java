package com.tea.controller;

import java.io.IOException;

import com.tea.dao.PostDAO;
import com.tea.dto.PostDTO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/postAction")
public class PostActionController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int postNo = Integer.parseInt(request.getParameter("no"));
        PostDAO dao = PostDAO.getInstance();

        if ("edit".equals(action)) {
            // 수정 폼 보여주기
            PostDTO post = dao.getPostByNo(postNo);
            request.setAttribute("post", post);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/edit_post.jsp");
            dispatcher.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        PostDAO dao = PostDAO.getInstance();
        
        if ("update".equals(action)) {
            // 게시글 업데이트 처리
            int postNo = Integer.parseInt(request.getParameter("postNo"));
            PostDTO post = new PostDTO();
            post.setPostNo(postNo);
            post.setTagMain(request.getParameter("tag_main"));
            post.setTagTea(request.getParameter("tag_tea"));
            post.setTagRegion(request.getParameter("tag_region"));
            post.setTitle(request.getParameter("title"));
            post.setContents(request.getParameter("contents"));
            
            dao.updatePost(post);
            response.sendRedirect("postdetail?no=" + postNo);

        } else if ("delete".equals(action)) {
            // 게시글 삭제 처리
            int postNo = Integer.parseInt(request.getParameter("no"));
            dao.deletePost(postNo);
            response.sendRedirect("community");
        }
    }
}
