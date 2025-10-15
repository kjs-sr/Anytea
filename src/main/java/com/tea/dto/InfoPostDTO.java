package com.tea.dto;

public class InfoPostDTO {

    private int infoNo;         // 글 번호 (PK)
    private String division;    // 구분 (INTRO, INFO)
    private String tagTea;      // 차 태그
    private String tagRegion;   // 지역 태그
    private String title;       // 제목
    private String contents;    // 내용
    private String imageAddr;   // 이미지 주소

    // Getters and Setters
    public int getInfoNo() {
        return infoNo;
    }

    public void setInfoNo(int infoNo) {
        this.infoNo = infoNo;
    }

    public String getDivision() {
        return division;
    }

    public void setDivision(String division) {
        this.division = division;
    }

    public String getTagTea() {
        return tagTea;
    }

    public void setTagTea(String tagTea) {
        this.tagTea = tagTea;
    }

    public String getTagRegion() {
        return tagRegion;
    }

    public void setTagRegion(String tagRegion) {
        this.tagRegion = tagRegion;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContents() {
        return contents;
    }

    public void setContents(String contents) {
        this.contents = contents;
    }

    public String getImageAddr() {
        return imageAddr;
    }

    public void setImageAddr(String imageAddr) {
        this.imageAddr = imageAddr;
    }
}

