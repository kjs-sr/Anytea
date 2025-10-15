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

@WebServlet("/regiontype")
public class RegionTypeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 요청 파라미터(지역) 가져오기
        String region = request.getParameter("region");

        // 2. DAO를 통해 해당 지역의 게시글 목록 조회
        InfoPostDAO dao = InfoPostDAO.getInstance();
        List<InfoPostDTO> postList = dao.getPostsByRegion(region);

        // 3. 조회된 데이터를 request 객체에 저장
        request.setAttribute("postList", postList);
        request.setAttribute("regionName", region); // 페이지 제목으로 사용할 지역 이름

        // 4. JSP 페이지로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/region_type.jsp");
        dispatcher.forward(request, response);
    }
}
