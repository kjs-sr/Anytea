package com.tea.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.tea.dto.UserDTO;
import com.tea.util.DBManager;

public class UserDAO {
    
    private static UserDAO instance = new UserDAO();
    private UserDAO() {}
    public static UserDAO getInstance() {
        return instance;
    }

    public boolean isDuplicate(String field, String value) {
    	String columnName;
        if ("userId".equalsIgnoreCase(field)) {
            columnName = "USER_ID";
        } else if ("nickname".equalsIgnoreCase(field)) {
            columnName = "NICKNAME";
        } else if ("email".equalsIgnoreCase(field)) {
            columnName = "EMAIL";
        } else {
            return false; 
        }

        String sql = "SELECT COUNT(*) FROM USERS WHERE UPPER(" + columnName + ") = UPPER(?)";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, value);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    return count > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public int insertUser(UserDTO user) {
        String sql = "INSERT INTO USERS (USER_NO, USER_ID, PASSWORD, NICKNAME, EMAIL) VALUES (USERS_SEQ.NEXTVAL, ?, ?, ?, ?)";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getUserId());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getNickname());
            pstmt.setString(4, user.getEmail());
            
            return pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int updateUser(UserDTO user) {
        String sql = "UPDATE USERS SET PASSWORD = ?, NICKNAME = ?, EMAIL = ? WHERE USER_NO = ?";
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getPassword());
            pstmt.setString(2, user.getNickname());
            pstmt.setString(3, user.getEmail());
            pstmt.setInt(4, user.getUserNo());
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public int processWithdrawal(int userNo) {
        String uniqueId = "withdrawn_" + userNo + "_" + System.currentTimeMillis();
        
        String updateUserSql = "UPDATE USERS SET USER_ID = ?, PASSWORD = ?, NICKNAME = '탈퇴한 회원', EMAIL = ?, USER_STATUS = 'WITHDRAWN' WHERE USER_NO = ?";
        String updatePostsSql = "UPDATE posts SET post_status = 'deleted' WHERE User_no = ?";
        String updateCommentsSql = "UPDATE comments SET Cmt_status = 'deleted', Contents = '삭제된 댓글입니다.' WHERE Cmt_no = ?";
        
        Connection conn = null;
        PreparedStatement pstmtUser = null;
        PreparedStatement pstmtPosts = null;
        PreparedStatement pstmtComments = null;

        try {
            conn = DBManager.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Update USERS table
            pstmtUser = conn.prepareStatement(updateUserSql);
            pstmtUser.setString(1, uniqueId);
            pstmtUser.setString(2, "INVALID_PASSWORD_FOR_WITHDRAWN_USER");
            pstmtUser.setString(3, uniqueId + "@withdrawn.com");
            pstmtUser.setInt(4, userNo);
            pstmtUser.executeUpdate();

            // 2. Update POSTS table
            pstmtPosts = conn.prepareStatement(updatePostsSql);
            pstmtPosts.setInt(1, userNo);
            pstmtPosts.executeUpdate();
            
            // 3. Update COMMENTS table
            pstmtComments = conn.prepareStatement(updateCommentsSql);
            pstmtComments.setInt(1, userNo);
            pstmtComments.executeUpdate();

            conn.commit(); // Commit transaction if all updates are successful
            return 1; // Success
            
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            // Close resources
            try {
                if (pstmtUser != null) pstmtUser.close();
                if (pstmtPosts != null) pstmtPosts.close();
                if (pstmtComments != null) pstmtComments.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return 0; // Failure
    }
    
    public UserDTO findUserByEmail(String email) {
    	String sql = "SELECT USER_NO, USER_ID, PASSWORD, NICKNAME, EMAIL, USER_STATUS FROM USERS WHERE UPPER(EMAIL) = UPPER(?)";
        UserDTO user = null;
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new UserDTO();
                    user.setUserNo(rs.getInt(1));
                    user.setUserId(rs.getString(2));
                    user.setPassword(rs.getString(3));
                    user.setNickname(rs.getString(4));
                    user.setEmail(rs.getString(5));
                    user.setUserStatus(rs.getString(6));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public UserDTO findUserById(String userId) {
        String sql = "SELECT User_no, User_id, Password, Nickname, Email, User_status FROM USERS WHERE UPPER(User_id) = UPPER(?)";
        UserDTO user = null;
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new UserDTO();
                    user.setUserNo(rs.getInt(1));
                    user.setUserId(rs.getString(2));
                    user.setPassword(rs.getString(3));
                    user.setNickname(rs.getString(4));
                    user.setEmail(rs.getString(5));
                    user.setUserStatus(rs.getString(6));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
    
    /**
     * [추가] 아이디와 이메일로 사용자가 존재하는지 확인하는 메소드
     */
    public boolean findUserByIdAndEmail(String userId, String email) {
        String sql = "SELECT COUNT(*) FROM USERS WHERE UPPER(USER_ID) = UPPER(?) AND UPPER(EMAIL) = UPPER(?)";
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int updatePassword(String userId, String hashedPassword) {
        String sql = "UPDATE USERS SET PASSWORD = ? WHERE UPPER(USER_ID) = UPPER(?)";
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, hashedPassword);
            pstmt.setString(2, userId);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}

