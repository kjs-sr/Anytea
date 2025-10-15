package com.tea.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.tea.dto.PostDTO;

public class PostDAO {
    private DataSource dataSource;
    private static PostDAO instance = new PostDAO();

    private PostDAO() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/OracleDB");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static PostDAO getInstance() {
        return instance;
    }

    public List<PostDTO> getPopularPosts() {
        List<PostDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        // SELECT 절의 컬럼 순서: 1.Post_no, 2.Tag_main, 3.Tag_tea, 4.Tag_region, 5.Title, 6.Likes
        String sql = "SELECT * FROM ("
                   + "  SELECT Post_no, Tag_main, Tag_tea, Tag_region, Title, Likes "
                   + "  FROM posts "
                   + "  WHERE Post_status = 'active' AND Likes > 0 "
                   + "  ORDER BY Likes DESC, Post_no DESC"
                   + ") WHERE ROWNUM <= 5";
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                PostDTO post = new PostDTO();
                post.setPostNo(rs.getInt(1));
                post.setTagMain(rs.getString(2));
                post.setTagTea(rs.getString(3));
                post.setTagRegion(rs.getString(4));
                post.setTitle(rs.getString(5));
                post.setLikes(rs.getInt(6));
                list.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return list;
    }
    
    // [수정] 홈 화면용 최신글 목록 조회 (Tag_region 컬럼 추가)
    public List<PostDTO> getLatestPosts() {
        List<PostDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        // SELECT 절의 컬럼 순서: 1.Post_no, 2.Tag_main, 3.Tag_tea, 4.Tag_region, 5.Title
        String sql = "SELECT * FROM ("
                   + "  SELECT Post_no, Tag_main, Tag_tea, Tag_region, Title "
                   + "  FROM posts "
                   + "  WHERE Post_status = 'active' "
                   + "  ORDER BY Post_no DESC"
                   + ") WHERE ROWNUM <= 5";
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                PostDTO post = new PostDTO();
                post.setPostNo(rs.getInt(1));
                post.setTagMain(rs.getString(2));
                post.setTagTea(rs.getString(3));
                post.setTagRegion(rs.getString(4));
                post.setTitle(rs.getString(5));
                list.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return list;
    }
    
    public int addPost(PostDTO post) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        // [수정] modify_date 컬럼에 SYSDATE를 함께 INSERT 하도록 수정
        String sql = "INSERT INTO posts (Post_no, User_no, Tag_main, Tag_tea, Tag_region, Title, Contents, create_date, modify_date, Likes, view_count, Post_status) "
                   + "VALUES (posts_seq.nextval, ?, ?, ?, ?, ?, ?, SYSDATE, SYSDATE, 0, 0, 'active')";
        //posts_seq.nextval
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, post.getUserNo());
            pstmt.setString(2, post.getTagMain());
            pstmt.setString(3, post.getTagTea());
            pstmt.setString(4, post.getTagRegion());
            pstmt.setString(5, post.getTitle());
            pstmt.setString(6, post.getContents());
            
            result = pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, null);
        }
        return result;
    }

    // 검색 조건에 맞는 전체 게시글 수를 계산하는 메소드
    public int getTotalPostCount(String mainTag, String teaTag, String regionTag, String titleQuery) {
        int count = 0;
        List<String> params = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM posts p WHERE p.Post_status = 'active' ");

        if (mainTag != null && !mainTag.isEmpty()) {
            sql.append("AND p.Tag_main = ? ");
            params.add(mainTag);
        }
        if (teaTag != null && !teaTag.isEmpty()) {
            sql.append("AND p.Tag_tea = ? ");
            params.add(teaTag);
        }
        if (regionTag != null && !regionTag.isEmpty()) {
            sql.append("AND p.Tag_region = ? ");
            params.add(regionTag);
        }
        if (titleQuery != null && !titleQuery.isEmpty()) {
            sql.append("AND p.Title LIKE ? ");
            params.add("%" + titleQuery + "%");
        }

        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setString(i + 1, params.get(i));
            }
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return count;
    }

    // [Modified Method] 페이징 처리를 위해 page, limit 파라미터 추가
    public List<PostDTO> searchPosts(String mainTag, String teaTag, String regionTag, String titleQuery, int page, int limit) {
        List<PostDTO> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        int startRow = (page - 1) * limit + 1;
        int endRow = page * limit;

        StringBuilder sql = new StringBuilder("SELECT * FROM (")
                .append("SELECT ROWNUM AS rnum, a.* FROM (")
                .append("SELECT p.Post_no, p.Tag_main, p.Tag_tea, p.Tag_region, p.Title, u.Nickname, p.create_date, p.Likes, p.view_count, (SELECT COUNT(*) FROM comments c WHERE c.Post_no = p.Post_no) as comment_count ")
                .append("FROM posts p JOIN users u ON p.User_no = u.User_no ")
                .append("WHERE p.Post_status = 'active' ");

        if (mainTag != null && !mainTag.isEmpty()) {
            sql.append("AND p.Tag_main = ? ");
            params.add(mainTag);
        }
        if (teaTag != null && !teaTag.isEmpty()) {
            sql.append("AND p.Tag_tea = ? ");
            params.add(teaTag);
        }
        if (regionTag != null && !regionTag.isEmpty()) {
            sql.append("AND p.Tag_region = ? ");
            params.add(regionTag);
        }
        if (titleQuery != null && !titleQuery.isEmpty()) {
            sql.append("AND p.Title LIKE ? ");
            params.add("%" + titleQuery + "%");
        }
        
        sql.append("ORDER BY p.Post_no DESC) a ")
           .append(") WHERE rnum BETWEEN ? AND ?");

        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            for (Object param : params) {
                pstmt.setObject(paramIndex++, param);
            }
            pstmt.setInt(paramIndex++, startRow);
            pstmt.setInt(paramIndex, endRow);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO post = new PostDTO();
                post.setPostNo(rs.getInt(2));        // rnum이 1번
                post.setTagMain(rs.getString(3));
                post.setTagTea(rs.getString(4));
                post.setTagRegion(rs.getString(5));
                post.setTitle(rs.getString(6));
                post.setNickname(rs.getString(7));
                post.setDate(rs.getTimestamp(8));
                post.setLikes(rs.getInt(9));
                post.setViews(rs.getInt(10));
                post.setCommentCount(rs.getInt(11));
                list.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return list;
    }

    public void incrementViews(int postNo) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE posts SET view_count = view_count + 1 WHERE Post_no = ?";
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postNo);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, null);
        }
    }

    public PostDTO getPostByNo(int postNo) {
        PostDTO post = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        // [수정] Post_status를 함께 조회하고, 'active' 조건은 제거
        String sql = "SELECT p.Post_no, p.User_no, p.Tag_main, p.Tag_tea, p.Tag_region, p.Title, p.Contents, p.create_date, p.modify_date, p.Likes, p.view_count, u.Nickname, p.Post_status "
                   + "FROM posts p JOIN users u ON p.User_no = u.User_no "
                   + "WHERE p.Post_no = ?";
        
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postNo);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                post = new PostDTO();
                post.setPostNo(rs.getInt(1));
                post.setUserNo(rs.getInt(2));
                post.setTagMain(rs.getString(3));
                post.setTagTea(rs.getString(4));
                post.setTagRegion(rs.getString(5));
                post.setTitle(rs.getString(6));
                post.setContents(rs.getString(7));
                post.setDate(rs.getTimestamp(8));
                post.setModifyDate(rs.getTimestamp(9));
                post.setLikes(rs.getInt(10));
                post.setViews(rs.getInt(11));
                post.setNickname(rs.getString(12));
                post.setPostStatus(rs.getString(13)); // [추가] 게시글 상태 설정
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return post;
    }
    
    public void incrementLikes(int postNo) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE posts SET Likes = Likes + 1 WHERE Post_no = ?";
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postNo);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, null);
        }
    }
    
    // 게시글 정보를 업데이트하는 메소드
    public int updatePost(PostDTO post) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        String sql = "UPDATE posts SET Tag_main=?, Tag_tea=?, Tag_region=?, Title=?, Contents=?, modify_date=SYSDATE WHERE Post_no=?";
        
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, post.getTagMain());
            pstmt.setString(2, post.getTagTea());
            pstmt.setString(3, post.getTagRegion());
            pstmt.setString(4, post.getTitle());
            pstmt.setString(5, post.getContents());
            pstmt.setInt(6, post.getPostNo());
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, null);
        }
        return result;
    }

    // 게시글 상태를 'deleted'로 변경하는 메소드 (논리적 삭제)
    public int deletePost(int postNo) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        String sql = "UPDATE posts SET Post_status = 'deleted' WHERE Post_no = ?";
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postNo);
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
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

