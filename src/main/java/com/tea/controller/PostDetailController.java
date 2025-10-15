package com.tea.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.tea.dao.CommentDAO;
import com.tea.dao.PostDAO;
import com.tea.dao.PostLikeDAO;
import com.tea.dto.CommentDTO;
import com.tea.dto.PostDTO;
import com.tea.dto.UserDTO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/postdetail")
public class PostDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String postNoStr = request.getParameter("no");

        if (postNoStr == null || postNoStr.isEmpty()) {
            response.sendRedirect("community");
            return;
        }

        try {
            int postNo = Integer.parseInt(postNoStr);
            PostDAO postDAO = PostDAO.getInstance();
            
            PostDTO post = postDAO.getPostByNo(postNo);

            // [추가] 게시글 상태 확인 로직
            if (post == null || "deleted".equals(post.getPostStatus())) {
                // 게시글이 없거나 'deleted' 상태이면 전용 페이지로 이동
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/deleted_post.jsp");
                dispatcher.forward(request, response);
                return; // 이후 로직 실행 중단
            }

            // --- 아래는 게시글이 'active' 상태일 경우에만 실행되는 기존 로직 ---

            CommentDAO commentDAO = CommentDAO.getInstance();
            PostLikeDAO likeDAO = PostLikeDAO.getInstance();
            
            HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            List<Integer> viewedPosts = (List<Integer>) session.getAttribute("viewedPosts");

            if (viewedPosts == null) {
                viewedPosts = new ArrayList<>();
            }

            if (!viewedPosts.contains(postNo)) {
                postDAO.incrementViews(postNo);
                viewedPosts.add(postNo);
                session.setAttribute("viewedPosts", viewedPosts);
            }
            
            List<CommentDTO> commentList = commentDAO.getCommentsByPostNo(postNo);
            
            UserDTO loginUser = (UserDTO) request.getSession().getAttribute("loginUser");
            boolean userHasLiked = false;
            if (loginUser != null) {
                userHasLiked = likeDAO.checkIfLiked(loginUser.getUserNo(), postNo);
            }
            
            request.setAttribute("post", post);
            request.setAttribute("commentList", commentList);
            request.setAttribute("userHasLiked", userHasLiked);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/community_detail.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("community");
        }
    }
}
