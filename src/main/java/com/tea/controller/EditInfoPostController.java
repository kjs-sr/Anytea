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

@WebServlet("/editInfoPost")
public class EditInfoPostController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        InfoPostDAO dao = InfoPostDAO.getInstance();

        if ("form".equals(action)) {
            // 수정 폼을 보여주는 로직
            int infoNo = Integer.parseInt(request.getParameter("no"));
            InfoPostDTO post = dao.getPostByInfoNo(infoNo);
            request.setAttribute("post", post);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/editInfoPost.jsp");
            dispatcher.forward(request, response);
        } else {
            // 기본 동작: 글 목록을 보여줌
            List<InfoPostDTO> postList = dao.getAllPostsForAdmin();
            request.setAttribute("postList", postList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/infoPostList_admin.jsp");
            dispatcher.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        InfoPostDAO dao = InfoPostDAO.getInstance();

        // 폼 데이터 가져오기
        int infoNo = Integer.parseInt(request.getParameter("info_no"));
        String division = request.getParameter("division");
        String tagTea = request.getParameter("tag_tea");
        String tagRegion = request.getParameter("tag_region");
        if (tagRegion != null && tagRegion.isEmpty()) {
            tagRegion = null;
        }
        String title = request.getParameter("title");
        String contents = request.getParameter("contents");
        String imageAddr = request.getParameter("image_addr");

        // DTO 객체 생성
        InfoPostDTO post = new InfoPostDTO();
        post.setInfoNo(infoNo);
        post.setDivision(division);
        post.setTagTea(tagTea);
        post.setTagRegion(tagRegion);
        post.setTitle(title);
        post.setContents(contents);
        post.setImageAddr(imageAddr);
        
        // DB 업데이트
        int result = dao.updatePost(post);

        // 결과에 따라 메시지와 함께 목록 페이지로 리다이렉트
        if (result > 0) {
            request.getSession().setAttribute("message", "게시글이 성공적으로 수정되었습니다.");
        } else {
            request.getSession().setAttribute("message", "게시글 수정에 실패했습니다.");
        }
        response.sendRedirect(request.getContextPath() + "/editInfoPost");
    }
}
