package com.tea.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tea.dao.UserDAO;
import com.tea.dto.UserDTO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public RegisterController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String viewPath = "/WEB-INF/views/register.jsp";
		RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 요청 인코딩 설정
		request.setCharacterEncoding("UTF-8");
		
		// 2. 세션에서 이메일 인증 완료 여부 확인
		HttpSession session = request.getSession();
		Boolean isEmailVerified = (Boolean) session.getAttribute("isEmailVerified");
		
		// 3. 이메일 인증이 완료되지 않았다면 회원가입 페이지로 돌려보냄
		if (isEmailVerified == null || !isEmailVerified) {
			request.setAttribute("errorMessage", "이메일 인증이 필요합니다.");
			doGet(request, response);
			return;
		}
		
		// 4. 폼에서 전송된 데이터 받기
		String userId = request.getParameter("userId");
		String password = request.getParameter("password");
		String passwordConfirm = request.getParameter("passwordConfirm");
		String nickname = request.getParameter("nickname");
		
		// 비활성화된 폼에서 값을 가져오는 대신, 세션에 저장된 안전한 이메일 값을 가져옵니다.
		String email = (String) session.getAttribute("authCodeEmail");
		
		// 5. 서버 측 최종 유효성 검사 (Validation)
		// 5-1. 세션에 이메일 정보가 없는 예외적인 경우 처리
		if (email == null) {
			request.setAttribute("errorMessage", "이메일 인증 정보가 만료되었습니다. 다시 시도해주세요.");
			doGet(request, response);
			return;
		}
        // 아이디 유효성 검사 규칙
		String idRegex = "^[a-zA-Z0-9]{5,15}$";
        if (userId == null || !userId.matches(idRegex)) {
            request.setAttribute("errorMessage", "아이디는 5~15자의 영문, 숫자만 사용 가능합니다.");
            doGet(request, response);
            return;
        }

        // 비밀번호 유효성 검사 규칙
        String pwRegex = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*])[a-zA-Z\\d!@#$%^&*]{8,24}$";
        if (password == null || !password.matches(pwRegex)) {
            request.setAttribute("errorMessage", "비밀번호는 8~24자의 영문, 숫자, 특수문자(!@#$%^&*)를 포함해야 합니다.");
            doGet(request, response);
            return;
        }
		// 5-2. 비밀번호와 비밀번호 확인이 일치하는지 확인
		if (password == null || passwordConfirm == null || !password.equals(passwordConfirm)) {
			request.setAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
			doGet(request, response);
			return; 
		}
		
		// 5-3. 서버 측에서 다시 한번 중복 검사 수행 (보안 강화)
		UserDAO dao = UserDAO.getInstance();
		if (dao.isDuplicate("userId", userId)) {
			request.setAttribute("errorMessage", "이미 사용 중인 아이디입니다.");
			doGet(request, response);
			return;
		}
		if (dao.isDuplicate("nickname", nickname)) {
			request.setAttribute("errorMessage", "이미 사용 중인 닉네임입니다.");
			doGet(request, response);
			return;
		}
        if (dao.isDuplicate("email", email)) {
			request.setAttribute("errorMessage", "이미 가입된 이메일입니다.");
			doGet(request, response);
			return;
		}

		// 6. 비밀번호 암호화 (BCrypt 사용)
		String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
		
		// 7. DTO 객체 생성 및 데이터 저장
		UserDTO user = new UserDTO();
		user.setUserId(userId.toLowerCase());
		user.setPassword(hashedPassword); // 암호화된 비밀번호 저장
		user.setNickname(nickname);
		user.setEmail(email);
		
		// 8. DAO를 통해 데이터베이스에 회원 정보 저장
		int result = dao.insertUser(user);
		
		// 9. 결과에 따라 페이지 이동
		if (result == 1) {
			// 회원가입 성공 시, 인증에 사용된 세션 정보들을 깨끗하게 정리
			session.removeAttribute("authCode");
			session.removeAttribute("authCodeEmail");
			session.removeAttribute("isEmailVerified");
			
			// 성공 메시지와 함께 로그인 페이지로 리다이렉트
			response.sendRedirect(request.getContextPath() + "/login");
		} else {
			// 회원가입 실패 시, 에러 메시지와 함께 다시 회원가입 페이지로
			request.setAttribute("errorMessage", "회원가입 중 오류가 발생했습니다. 다시 시도해주세요.");
			doGet(request, response);
		}
	}
}

