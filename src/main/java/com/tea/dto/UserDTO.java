package com.tea.dto;

/*
 * USERS 테이블의 한 행(Row)의 데이터를 담기 위한 클래스입니다.
 * DTO(Data Transfer Object) 또는 VO(Value Object)라고 부릅니다.
 */
public class UserDTO {

    // 테이블의 컬럼과 1:1로 매칭되는 필드(멤버 변수)를 선언합니다.
    private int userNo;
    private String userId;
    private String password;
    private String nickname;
    private String email;
    private String userStatus; // 회원 상태
    
    public int getUserNo() {
        return userNo;
    }
    public void setUserNo(int userNo) {
        this.userNo = userNo;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getNickname() {
        return nickname;
    }
    public void setNickname(String nickname) {
        this.nickname = nickname;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getUserStatus() {
        return userStatus;
    }
    public void setUserStatus(String userStatus) {
        this.userStatus = userStatus;
    }
}

