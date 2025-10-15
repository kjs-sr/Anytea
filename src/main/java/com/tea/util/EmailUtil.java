package com.tea.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    // [추가] 이메일의 목적을 구분하기 위한 열거형(Enum)을 정의합니다.
	public enum EmailType {
        REGISTRATION,
        FIND_ID,
        PASSWORD_RESET_AUTH, // 비밀번호 찾기 '인증'용
        FIND_PASSWORD,        // 임시 비밀번호 '발급'용
        CHANGE_EMAIL_AUTH    // 이메일 변경 '인증'용
    }

    /**
     * [개선] 다양한 목적의 이메일을 발송하는 통합 메소드
     * @param to 받는 사람 이메일 주소
     * @param type 이메일 종류 (EmailType 열거형 사용)
     * @param code 이메일에 포함될 인증번호 또는 임시 비밀번호
     * @return 발송 성공 여부
     */
    public static boolean sendEmail(String to, EmailType type, String code) {
    	final String username = "anytea.project.sender@gmail.com"; 
        final String password = "aupc gcyi tdte eypp"; 

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username, "여차저차 관리자"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));

            String subject = "";
            String htmlContent = "";
            String sentDate = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());

            switch (type) {
                case REGISTRATION:
                    subject = "[여차저차] 회원가입 이메일 인증번호입니다.";
                    htmlContent = getRegistrationTemplate(code, sentDate);
                    break;
                case FIND_ID:
                    subject = "[여차저차] 아이디 찾기 인증번호입니다.";
                    htmlContent = getFindIdTemplate(code, sentDate);
                    break;
                case PASSWORD_RESET_AUTH:
                    subject = "[여차저차] 비밀번호 찾기 인증번호입니다.";
                    htmlContent = getPasswordResetAuthTemplate(code, sentDate);
                    break;
                case FIND_PASSWORD:
                    subject = "[여차저차] 임시 비밀번호가 발급되었습니다.";
                    htmlContent = getFindPasswordTemplate(code, sentDate);
                    break;
                case CHANGE_EMAIL_AUTH:
                    subject = "[여차저차] 이메일 변경 인증번호입니다.";
                    htmlContent = getChangeEmailAuthTemplate(code, sentDate);
                    break;
            }

            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private static String getRegistrationTemplate(String authCode, String sentDate) {
        return "<h1>[여차저차] 이메일 인증</h1>"
             + "<p>안녕하세요! 여차저차에 가입해주셔서 감사합니다.</p>"
             + "<p>아래 인증번호를 회원가입 창에 입력해주세요.</p>"
             + "<br><h2>" + authCode + "</h2><br>"
             + "<p>발송 시각: " + sentDate + "</p>"
             + "<p>본인이 요청하지 않은 경우 이 메일을 무시해주세요.</p>";
    }

    private static String getFindIdTemplate(String authCode, String sentDate) {
        return "<h1>[여차저차] 아이디 찾기 인증</h1>"
             + "<p>안녕하세요! 아이디 찾기를 위해 요청하신 인증번호입니다.</p>"
             + "<p>아래 인증번호를 아이디 찾기 창에 입력해주세요.</p>"
             + "<br><h2>" + authCode + "</h2><br>"
             + "<p>발송 시각: " + sentDate + "</p>"
             + "<p>본인이 요청하지 않은 경우 이 메일을 무시해주세요.</p>";
    }

    // [추가] 비밀번호 찾기 '인증' 템플릿
    private static String getPasswordResetAuthTemplate(String authCode, String sentDate) {
        return "<h1>[여차저차] 비밀번호 찾기 인증</h1>"
             + "<p>안녕하세요! 비밀번호 찾기를 위해 요청하신 인증번호입니다.</p>"
             + "<p>아래 인증번호를 인증번호 입력창에 입력해주세요.</p>"
             + "<br><h2>" + authCode + "</h2><br>"
             + "<p>발송 시각: " + sentDate + "</p>"
             + "<p>본인이 요청하지 않은 경우 이 메일을 무시해주세요.</p>";
    }
    
    private static String getFindPasswordTemplate(String tempPassword, String sentDate) {
        return "<h1>[여차저차] 임시 비밀번호 발급</h1>"
             + "<p>안녕하세요! 요청하신 임시 비밀번호입니다.</p>"
             + "<p>아래 임시 비밀번호로 로그인 후, 반드시 비밀번호를 변경해주세요.</p>"
             + "<br><h2>" + tempPassword + "</h2><br>"
             + "<p>발송 시각: " + sentDate + "</p>"
             + "<p>본인이 요청하지 않은 경우 이 메일을 무시해주세요.</p>";
    }
    
    private static String getChangeEmailAuthTemplate(String authCode, String sentDate) {
        return "<h1>[여차저차] 이메일 변경 인증</h1>"
             + "<p>안녕하세요! 회원 정보 수정을 위해 요청하신 이메일 변경 인증번호입니다.</p>"
             + "<p>아래 인증번호를 입력하여 이메일 변경을 완료해주세요.</p>"
             + "<br><h2>" + authCode + "</h2><br>"
             + "<p>발송 시각: " + sentDate + "</p>"
             + "<p>본인이 요청하지 않은 경우 이 메일을 무시해주세요.</p>";
    }
}