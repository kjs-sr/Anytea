package com.tea.controller;

import java.io.IOException;
import com.tea.dto.UserDTO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/edit-profile")
public class EditProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public EditProfileController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	// 1. 현재 세션을 가져옵니다. (없으면 새로 생성하지 않음)
        HttpSession session = request.getSession(false);

        // 2. 세션이 없거나, 세션에 로그인 정보가 없는 경우 로그인 페이지로 리다이렉트합니다.
        if (session == null || session.getAttribute("loginUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // 3. 세션에서 로그인된 사용자 정보를 가져옵니다.
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        
        // 4. JSP에서 사용할 수 있도록 request에 사용자 정보를 "user"라는 이름으로 담습니다.
        request.setAttribute("user", loginUser);

        // 5. 회원 정보 수정 페이지로 포워딩합니다.

        String viewPath = "/WEB-INF/views/edit_profile.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
        dispatcher.forward(request, response);
    }
}
