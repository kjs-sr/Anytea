package com.tea.controller;

import java.io.IOException;

import com.tea.dao.PostDAO;
import com.tea.dao.PostLikeDAO;
import com.tea.dto.UserDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/likePost")
public class LikeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        // 1. 로그인 상태 확인
        if (loginUser == null) {
            response.sendRedirect("login");
            return;
        }

        String postNoStr = request.getParameter("no");
        if (postNoStr == null) {
            response.sendRedirect("community");
            return;
        }
        int postNo = Integer.parseInt(postNoStr);
        int userNo = loginUser.getUserNo();

        PostLikeDAO likeDAO = PostLikeDAO.getInstance();

        // 2. 이미 좋아요를 눌렀는지 확인
        if (likeDAO.checkIfLiked(userNo, postNo)) {
            // 이미 눌렀다면 알림 메시지를 세션에 저장하고 리다이렉트
            session.setAttribute("likeMessage", "이미 좋아요를 누른 게시글입니다.");
        } else {
            // 3. 좋아요 처리
            PostDAO postDAO = PostDAO.getInstance();
            likeDAO.addLike(userNo, postNo);
            postDAO.incrementLikes(postNo);
        }

        // 4. 원래 보던 게시글 페이지로 리다이렉트
        response.sendRedirect("postdetail?no=" + postNo);
    }
}
