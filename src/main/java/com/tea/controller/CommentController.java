package com.tea.controller;

import java.io.IOException;

import com.tea.dao.CommentDAO;
import com.tea.dto.CommentDTO;
import com.tea.dto.UserDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/commentAction")
public class CommentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        UserDTO loginUser = (UserDTO) request.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        String postNoStr = request.getParameter("postNo");
        if (postNoStr == null || postNoStr.isEmpty()) {
            response.sendRedirect("community");
            return;
        }
        int postNo = Integer.parseInt(postNoStr);
        String action = request.getParameter("action");
        CommentDAO dao = CommentDAO.getInstance();

        if ("add".equals(action)) {
            String contents = request.getParameter("contents");
            if (contents != null && !contents.trim().isEmpty()) {
                String parentCmtNoStr = request.getParameter("parentCmtNo");
                CommentDTO comment = new CommentDTO();
                comment.setPostNo(postNo);
                comment.setUserNo(loginUser.getUserNo());
                comment.setContents(contents);
                
                if (parentCmtNoStr != null && !parentCmtNoStr.isEmpty()) {
                    comment.setParentCmtNo(Integer.parseInt(parentCmtNoStr));
                }
                dao.addComment(comment);
            }
            response.sendRedirect("postdetail?no=" + postNo);

        } else if ("edit".equals(action)) {
            int cmtNo = Integer.parseInt(request.getParameter("cmtNo"));
            String contents = request.getParameter("contents");
            dao.updateComment(cmtNo, contents);
            response.sendRedirect("postdetail?no=" + postNo);
            
        } else if ("delete".equals(action)) {
            int cmtNo = Integer.parseInt(request.getParameter("cmtNo"));
            dao.deleteComment(cmtNo);
            response.sendRedirect("postdetail?no=" + postNo);
        }
    }
}

