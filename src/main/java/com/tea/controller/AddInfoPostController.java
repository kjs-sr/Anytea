package com.tea.controller;

import java.io.IOException;

import com.tea.dao.InfoPostDAO;
import com.tea.dto.InfoPostDTO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/addInfoPost")
public class AddInfoPostController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/addInfoPost.jsp");
        dispatcher.forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String division = request.getParameter("division");
        String tagTea = request.getParameter("tag_tea");
        String tagRegion = request.getParameter("tag_region");
        String title = request.getParameter("title");
        String contents = request.getParameter("contents");
        String imageAddr = request.getParameter("image_addr");
        
        if (tagRegion != null && tagRegion.isEmpty()) {
            tagRegion = null;
        }
        
        InfoPostDTO post = new InfoPostDTO();
        post.setDivision(division);
        post.setTagTea(tagTea);
        post.setTagRegion(tagRegion);
        post.setTitle(title);
        post.setContents(contents);
        post.setImageAddr(imageAddr);

        // 4. DAO를 통해 데이터베이스에 저장하고 결과(성공:1, 실패:0)를 받음
        InfoPostDAO dao = InfoPostDAO.getInstance();
        int result = dao.addPost(post);
        
        // 5. 처리 결과에 따라 다른 메시지를 설정
        if (result > 0) {
            System.out.println("게시글이 성공적으로 등록되었습니다: " + title);
            request.setAttribute("message", "게시글이 성공적으로 등록되었습니다.");
        } else {
            System.err.println("게시글 등록에 실패했습니다: " + title);
            request.setAttribute("message", "게시글 등록에 실패했습니다. 서버 로그(콘솔)를 확인해주세요.");
        }
        
        doGet(request, response);
    }
}

