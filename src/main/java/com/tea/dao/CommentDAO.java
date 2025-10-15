package com.tea.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.tea.dto.CommentDTO;

public class CommentDAO {
    private DataSource dataSource;
    private static CommentDAO instance = new CommentDAO();

    private CommentDAO() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/OracleDB");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static CommentDAO getInstance() {
        return instance;
    }

    public int addComment(CommentDTO comment) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        String sql = "INSERT INTO comments (Cmt_no, User_no, Post_no, Parent_cmt_no, Contents, POST_DATE, Cmt_status) "
                   + "VALUES (comments_seq.nextval, ?, ?, ?, ?, SYSDATE, 'active')";
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, comment.getUserNo());
            pstmt.setInt(2, comment.getPostNo());
            
            if (comment.getParentCmtNo() != null) {
                pstmt.setInt(3, comment.getParentCmtNo());
            } else {
                pstmt.setNull(3, Types.INTEGER);
            }
            
            pstmt.setString(4, comment.getContents());
            
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, null);
        }
        return result;
    }

    // [수정] 댓글 내용을 수정하고, 수정 날짜도 함께 업데이트하는 메소드
    public int updateComment(int cmtNo, String contents) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        String sql = "UPDATE comments SET Contents = ?, POST_DATE = SYSDATE WHERE Cmt_no = ?";
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, contents);
            pstmt.setInt(2, cmtNo);
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, null);
        }
        return result;
    }

    // [수정] 댓글 상태를 'deleted'로 변경하고, 내용을 변경하는 메소드
    public int deleteComment(int cmtNo) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        String sql = "UPDATE comments SET Cmt_status = 'deleted', Contents = '삭제된 댓글입니다.' WHERE Cmt_no = ?";
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cmtNo);
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, null);
        }
        return result;
    }

    public List<CommentDTO> getCommentsByPostNo(int postNo) {
        List<CommentDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        // [수정] 삭제된 댓글도 포함하여 조회하도록 WHERE 조건 변경
        String sql = "SELECT LEVEL, c.Cmt_no, c.User_no, c.Post_no, c.Parent_cmt_no, c.Contents, c.POST_DATE, u.Nickname, c.Cmt_status "
                   + "FROM comments c LEFT JOIN users u ON c.User_no = u.User_no "
                   + "WHERE c.Post_no = ? "
                   + "START WITH c.Parent_cmt_no IS NULL "
                   + "CONNECT BY PRIOR c.Cmt_no = c.Parent_cmt_no "
                   + "ORDER SIBLINGS BY c.Cmt_no ASC";
        
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postNo);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                CommentDTO c = new CommentDTO();
                c.setLevel(rs.getInt(1));
                c.setCmtNo(rs.getInt(2));
                c.setUserNo(rs.getInt(3));
                c.setPostNo(rs.getInt(4));
                
                int parentCmtNoInt = rs.getInt(5);
                if (rs.wasNull()) {
                    c.setParentCmtNo(null);
                } else {
                    c.setParentCmtNo(parentCmtNoInt);
                }
                
                c.setContents(rs.getString(6));
                c.setDate(rs.getTimestamp(7));
                c.setNickname(rs.getString(8) == null ? "알 수 없는 사용자" : rs.getString(8));
                c.setCmtStatus(rs.getString(9)); // 상태 정보 추가
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return list;
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

