package com.tea.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class PostLikeDAO {
    private DataSource dataSource;
    private static PostLikeDAO instance = new PostLikeDAO();

    private PostLikeDAO() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/OracleDB");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static PostLikeDAO getInstance() {
        return instance;
    }

    // 특정 사용자가 특정 글에 좋아요를 눌렀는지 확인하는 메소드
    public boolean checkIfLiked(int userNo, int postNo) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) FROM post_like WHERE User_no = ? AND Post_no = ?";
        boolean hasLiked = false;
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNo);
            pstmt.setInt(2, postNo);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                if (rs.getInt(1) > 0) {
                    hasLiked = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return hasLiked;
    }

    // 좋아요 기록을 추가하는 메소드
    public int addLike(int userNo, int postNo) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO post_like (User_no, Post_no) VALUES (?, ?)";
        int result = 0;
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNo);
            pstmt.setInt(2, postNo);
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            // 기본 키 중복 오류(이미 좋아요 누름)는 무시
            if (!e.getMessage().contains("PK_POST_LIKE")) {
                 e.printStackTrace();
            }
        } finally {
            close(conn, pstmt, null);
        }
        return result;
    }

    private void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
