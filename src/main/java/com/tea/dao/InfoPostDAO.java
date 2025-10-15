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

import com.tea.dto.InfoPostDTO;

public class InfoPostDAO {

    private DataSource dataSource;
    private static InfoPostDAO instance = new InfoPostDAO();

    private InfoPostDAO() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/OracleDB");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static InfoPostDAO getInstance() {
        return instance;
    }

    public int addPost(InfoPostDTO post) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        
        // [수정] 시퀀스 이름을 DB에 있는 대문자 이름으로 변경
        String sql = "INSERT INTO INFO_POSTS (Info_no, Division, Tag_tea, Tag_region, Title, Contents, Image_addr) VALUES (INFO_POSTS_SEQ.nextval, ?, ?, ?, ?, ?, ?)";
        
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, post.getDivision());
            pstmt.setString(2, post.getTagTea());
            pstmt.setString(3, post.getTagRegion());
            pstmt.setString(4, post.getTitle());
            pstmt.setString(5, post.getContents());
            pstmt.setString(6, post.getImageAddr());
            
            result = pstmt.executeUpdate(); // 실행 결과를 result 변수에 저장
            
        } catch (Exception e) {
            System.err.println("데이터 저장 중 오류 발생!");
            e.printStackTrace();
        } finally {
            close(conn, pstmt, null);
        }
        return result; // 결과를 컨트롤러에 반환
    }
    
    public List<InfoPostDTO> getPostsByCategory(String category) {
        List<InfoPostDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // SELECT 구문의 컬럼 순서: 1. Info_no, 2. Title, 3. Image_addr
        String sql = "SELECT Info_no, Title, Image_addr FROM Info_posts WHERE Tag_tea = ? AND Division = 'INFO' ORDER BY Info_no DESC";

        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                InfoPostDTO post = new InfoPostDTO();
                post.setInfoNo(rs.getInt(1));
                post.setTitle(rs.getString(2));
                post.setImageAddr(rs.getString(3));
                list.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return list;
    }
    
    public List<InfoPostDTO> getPostsByRegion(String region) {
        List<InfoPostDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // Tag_region을 기준으로 Division이 'INFO'인 게시글만 조회
        String sql = "SELECT Info_no, Title, Image_addr FROM Info_posts WHERE Tag_region = ? AND Division = 'INFO' ORDER BY Info_no DESC";

        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, region);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                InfoPostDTO post = new InfoPostDTO();
                post.setInfoNo(rs.getInt(1));
                post.setTitle(rs.getString(2));
                post.setImageAddr(rs.getString(3));
                list.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return list;
    }
    
    /**
     * 특정 차 종류(카테고리)의 소개(INTRO) 게시글 정보를 조회하는 메소드
     * @param category 조회할 차 종류 (예: "녹차")
     * @return 소개 게시글 DTO 객체. 없으면 null.
     */
    public InfoPostDTO getIntroPostByCategory(String category) {
        InfoPostDTO post = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        // SELECT 구문의 컬럼 순서: 1. Info_no, 2. Image_addr
        String sql = "SELECT Info_no, Title, Image_addr FROM Info_posts WHERE Tag_tea = ? AND Division = 'INTRO'";

        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                post = new InfoPostDTO();
                post.setInfoNo(rs.getInt(1));
                post.setTitle(rs.getString(2));
                post.setImageAddr(rs.getString(3));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return post;
    }
    
    public InfoPostDTO getPostByInfoNo(int infoNo) {
        InfoPostDTO post = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // SELECT 구문의 컬럼 순서: 1.Info_no, 2.Division, 3.Tag_tea, 4.Tag_region, 5.Title, 6.Contents, 7.Image_addr
        String sql = "SELECT Info_no, Division, Tag_tea, Tag_region, Title, Contents, Image_addr FROM INFO_POSTS WHERE Info_no = ?";
        
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, infoNo);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                post = new InfoPostDTO();
                post.setInfoNo(rs.getInt(1));
                post.setDivision(rs.getString(2));
                post.setTagTea(rs.getString(3));
                post.setTagRegion(rs.getString(4));
                post.setTitle(rs.getString(5));
                post.setContents(rs.getString(6));
                post.setImageAddr(rs.getString(7));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return post;
    }
    
    public List<InfoPostDTO> getAllPostsForAdmin() {
        List<InfoPostDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        // SELECT 구문의 컬럼 순서: 1.Info_no, 2.Title, 3.Tag_tea, 4.Division
        String sql = "SELECT Info_no, Title, Tag_tea, Division FROM INFO_POSTS ORDER BY Info_no DESC";
        
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                InfoPostDTO post = new InfoPostDTO();
                // [수정] 컬럼 이름 대신 순번(index)을 사용하여 데이터를 조회합니다.
                post.setInfoNo(rs.getInt(1));
                post.setTitle(rs.getString(2));
                post.setTagTea(rs.getString(3));
                post.setDivision(rs.getString(4));
                list.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return list;
    }

    public int updatePost(InfoPostDTO post) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        String sql = "UPDATE INFO_POSTS SET Division=?, Tag_tea=?, Tag_region=?, Title=?, Contents=?, Image_addr=? WHERE Info_no=?";
        
        try {
            conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, post.getDivision());
            pstmt.setString(2, post.getTagTea());
            pstmt.setString(3, post.getTagRegion());
            pstmt.setString(4, post.getTitle());
            pstmt.setString(5, post.getContents());
            pstmt.setString(6, post.getImageAddr());
            pstmt.setInt(7, post.getInfoNo());
            
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

