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

@WebServlet("/infodetail")
public class InfoDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 요청 파라미터(게시글 번호) 가져오기
        String infoNoStr = request.getParameter("no");
        
        // 파라미터가 없거나 비어있으면 홈으로 리다이렉트
        if(infoNoStr == null || infoNoStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            int infoNo = Integer.parseInt(infoNoStr);

            // 2. DAO를 통해 해당 게시글 정보 조회
            InfoPostDAO dao = InfoPostDAO.getInstance();
            InfoPostDTO post = dao.getPostByInfoNo(infoNo);

            // 3. 조회된 데이터를 request 객체에 저장
            request.setAttribute("post", post);

            // 4. JSP 페이지로 포워딩
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/info_detail.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            // 게시글 번호가 숫자가 아니면 홈으로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
