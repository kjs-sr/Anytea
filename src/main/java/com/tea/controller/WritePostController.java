package com.tea.controller;

import java.io.IOException;

import com.tea.dao.PostDAO;
import com.tea.dto.PostDTO;
import com.tea.dto.UserDTO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/writePost")
public class WritePostController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        // 로그인 상태가 아니면 로그인 페이지로 리다이렉트
        if (loginUser == null) {
            session.setAttribute("message", "로그인이 필요한 기능입니다.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // 글 작성 페이지로 이동
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/write_post.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            session.setAttribute("message", "세션이 만료되었거나 잘못된 접근입니다.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String tagMain = request.getParameter("tag_main");
        String tagTea = request.getParameter("tag_tea");
        String tagRegion = request.getParameter("tag_region");
        String title = request.getParameter("title");
        String contents = request.getParameter("contents");
        
        if (tagTea != null && tagTea.isEmpty()) tagTea = null;
        if (tagRegion != null && tagRegion.isEmpty()) tagRegion = null;

        PostDTO post = new PostDTO();
        post.setUserNo(loginUser.getUserNo());
        post.setTagMain(tagMain);
        post.setTagTea(tagTea);
        post.setTagRegion(tagRegion);
        post.setTitle(title);
        post.setContents(contents);

        PostDAO dao = PostDAO.getInstance();
        int result = dao.addPost(post);

        if (result > 0) {
            // 글 작성 성공 시 커뮤니티 목록으로 이동
            response.sendRedirect(request.getContextPath() + "/community");
        } else {
            // 실패 시 에러 메시지와 함께 다시 작성 페이지로
            request.setAttribute("errorMessage", "글 등록에 실패했습니다. 다시 시도해주세요.");
            doGet(request, response);
        }
    }
}
