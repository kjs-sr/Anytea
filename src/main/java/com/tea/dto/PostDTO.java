package com.tea.dto;

import java.sql.Timestamp;

public class PostDTO {
    private int postNo;
    private int userNo;
    private String tagMain;
    private String tagTea;
    private String tagRegion;
    private String title;
    private String contents;
    private Timestamp date;
    private Timestamp modifyDate; // [추가] 수정일 필드
    private int views;
    private int likes;
    private String postStatus;
    
    private String nickname;
    private int commentCount;

    // Getters and Setters
    public int getPostNo() { return postNo; }
    public void setPostNo(int postNo) { this.postNo = postNo; }
    public int getUserNo() { return userNo; }
    public void setUserNo(int userNo) { this.userNo = userNo; }
    public String getTagMain() { return tagMain; }
    public void setTagMain(String tagMain) { this.tagMain = tagMain; }
    public String getTagTea() { return tagTea; }
    public void setTagTea(String tagTea) { this.tagTea = tagTea; }
    public String getTagRegion() { return tagRegion; }
    public void setTagRegion(String tagRegion) { this.tagRegion = tagRegion; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContents() { return contents; }
    public void setContents(String contents) { this.contents = contents; }
    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }
    
    // [추가] 수정일 getter/setter
    public Timestamp getModifyDate() { return modifyDate; }
    public void setModifyDate(Timestamp modifyDate) { this.modifyDate = modifyDate; }

    public int getViews() { return views; }
    public void setViews(int views) { this.views = views; }
    public int getLikes() { return likes; }
    public void setLikes(int likes) { this.likes = likes; }
    public String getPostStatus() { return postStatus; }
    public void setPostStatus(String postStatus) { this.postStatus = postStatus; }
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }
}

