package com.tea.dto;

import java.sql.Timestamp;

public class CommentDTO {
    private int cmtNo;
    private int userNo;
    private int postNo;
    private Integer parentCmtNo;
    private String contents;
    private Timestamp date;
    private String cmtStatus;
    
    private String nickname;
    private int level; // [추가] 댓글의 계층 깊이를 저장할 필드

    // Getters and Setters
    public int getCmtNo() { return cmtNo; }
    public void setCmtNo(int cmtNo) { this.cmtNo = cmtNo; }
    public int getUserNo() { return userNo; }
    public void setUserNo(int userNo) { this.userNo = userNo; }
    public int getPostNo() { return postNo; }
    public void setPostNo(int postNo) { this.postNo = postNo; }
    public Integer getParentCmtNo() { return parentCmtNo; }
    public void setParentCmtNo(Integer parentCmtNo) { this.parentCmtNo = parentCmtNo; }
    public String getContents() { return contents; }
    public void setContents(String contents) { this.contents = contents; }
    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }
    public String getCmtStatus() { return cmtStatus; }
    public void setCmtStatus(String cmtStatus) { this.cmtStatus = cmtStatus; }
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    
    // [추가] level getter/setter
    public int getLevel() { return level; }
    public void setLevel(int level) { this.level = level; }
}

