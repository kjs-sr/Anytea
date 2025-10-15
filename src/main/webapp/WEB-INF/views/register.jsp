<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        input:disabled, button:disabled { background-color: #f3f4f6; color: #9ca3af; cursor: not-allowed; }
    </style>
</head>
<body class="bg-gray-100 text-gray-800 flex flex-col min-h-screen">

    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <main class="w-full max-w-md mx-auto px-6 mt-8 flex-grow flex items-center">
        <div class="bg-white p-8 rounded-lg shadow-md w-full">
            <h1 class="text-3xl font-bold text-center mb-8">회원가입</h1>
            
            <form id="registerForm" action="<%= request.getContextPath() %>/register" method="post" onsubmit="return checkForm()">
                
                <div>
                    <div class="flex rounded-md shadow-sm">
                        <input type="text" id="userId" name="userId" required placeholder="아이디" class="flex-1 block w-full px-3 py-2 border border-gray-300 rounded-none rounded-l-md focus:ring-green-500 focus:border-green-500 sm:text-sm">
                        <button type="button" id="checkIdBtn" class="inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-xs hover:bg-gray-100">중복 확인</button>
                    </div>
                    <p id="userIdMessage" class="mt-1 text-xs h-4"></p>
                </div>

                <div class="pt-2">
                    <input type="password" id="password" name="password" required placeholder="비밀번호" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-green-500 focus:border-green-500 sm:text-sm">
                    <input type="password" id="passwordConfirm" name="passwordConfirm" required placeholder="비밀번호 확인" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-green-500 focus:border-green-500 sm:text-sm">
                    <p id="passwordMessage" class="mt-1 text-xs text-red-600 h-4"></p>
                </div>
                
                <div class="pt-2">
                     <div class="flex rounded-md shadow-sm">
                        <input type="text" id="nickname" name="nickname" required placeholder="닉네임" class="flex-1 block w-full px-3 py-2 border border-gray-300 rounded-none rounded-l-md focus:ring-green-500 focus:border-green-500 sm:text-sm">
                        <button type="button" id="checkNicknameBtn" class="inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-xs hover:bg-gray-100">중복 확인</button>
                    </div>
                    <p id="nicknameMessage" class="mt-1 text-xs h-4"></p>
                </div>

                <div class="pt-2">
                    <div class="flex rounded-md shadow-sm">
                        <input type="email" id="email" name="email" required placeholder="Email@example.com" class="flex-1 block w-full px-3 py-2 border border-gray-300 rounded-none rounded-l-md focus:ring-green-500 focus:border-green-500 sm:text-sm">
                        <button type="button" id="sendAuthCodeBtn" class="inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-xs hover:bg-gray-100">인증 발송</button>
                    </div>
                    <div class="mt-1 flex rounded-md shadow-sm">
                        <input type="text" id="authCode" name="authCode" required placeholder="인증번호" class="flex-1 block w-full px-3 py-2 border border-gray-300 rounded-none rounded-l-md focus:ring-green-500 focus:border-green-500 sm:text-sm">
                        <button type="button" id="verifyAuthCodeBtn" class="inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-xs hover:bg-gray-100">인증 확인</button>
                    </div>
                    <p id="authMessage" class="mt-1 text-xs h-4"></p>
                </div>

                <div class="pt-4">
                    <button type="submit" id="registerBtn" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-green-700 hover:bg-green-800">
                        가입하기
                    </button>
                </div>
            </form>
             <div class="mt-6 text-center text-sm">
                <a href="<%= request.getContextPath() %>/login" class="font-medium text-green-600 hover:text-green-500">이미 계정이 있으신가요? 로그인</a>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/include/footer.jsp" />
    
    <script>
        let isEmailVerified = false;
        let isIdChecked = false;
        let isNicknameChecked = false;

        const emailInput = document.getElementById('email');
        const sendAuthCodeBtn = document.getElementById('sendAuthCodeBtn');
        const authCodeInput = document.getElementById('authCode');
        const verifyAuthCodeBtn = document.getElementById('verifyAuthCodeBtn');
        const registerBtn = document.getElementById('registerBtn');
        const authMessage = document.getElementById('authMessage');
        
        function checkDuplicate(field, value, messageElement) {
            if (!value) {
                messageElement.style.color = 'red';
                messageElement.textContent = (field === 'userId' ? '아이디를' : (field === 'nickname' ? '닉네임을' : '이메일을')) + ' 입력해주세요.';
                return Promise.resolve(true);
            }
            return fetch('<%= request.getContextPath() %>/checkDuplicate', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'field=' + field + '&value=' + encodeURIComponent(value)
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'duplicate') {
                    messageElement.style.color = 'red';
                    messageElement.textContent = '이미 사용 중인 ' + (field === 'userId' ? '아이디' : (field === 'nickname' ? '닉네임' : '이메일')) + '입니다.';
                    return true;
                } else {
                    // 이메일 중복 검사는 성공 시 메시지를 보여주지 않고, 인증 발송 로직으로 바로 넘어갑니다.
                    if (field !== 'email') { 
                        messageElement.style.color = 'green';
                        messageElement.textContent = '사용 가능한 ' + (field === 'userId' ? '아이디' : '닉네임') + '입니다.';
                    }
                    return false;
                }
            });
        }

        document.getElementById('checkIdBtn').addEventListener('click', async () => {
            const userId = document.getElementById('userId').value;
            const messageEl = document.getElementById('userIdMessage');
            const isDuplicate = await checkDuplicate('userId', userId, messageEl);
            isIdChecked = !isDuplicate;
        });

        document.getElementById('checkNicknameBtn').addEventListener('click', async () => {
            const nickname = document.getElementById('nickname').value;
            const messageEl = document.getElementById('nicknameMessage');
            const isDuplicate = await checkDuplicate('nickname', nickname, messageEl);
            isNicknameChecked = !isDuplicate;
        });
        
        sendAuthCodeBtn.addEventListener('click', async function() {
            if (this.textContent === '이메일 변경') {
                isEmailVerified = false;
                emailInput.disabled = false;
                authCodeInput.disabled = false;
                authCodeInput.value = '';
                verifyAuthCodeBtn.disabled = false;
                registerBtn.disabled = true;
                authMessage.textContent = '';
                this.textContent = '인증 발송';
                return;
            }

            const email = emailInput.value;
            // 인증 메일 발송 전에 DB에 이메일이 중복되는지 먼저 확인합니다.
            const isDuplicate = await checkDuplicate('email', email, authMessage);

            if (isDuplicate) {
                return; // 중복이면 여기서 중단
            }
            
            this.disabled = true;
            this.textContent = '전송중...';
            
            fetch('<%= request.getContextPath() %>/sendAuthCode', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'email=' + encodeURIComponent(email)
            }).then(response => response.text()).then(data => {
                if (data === 'success') {
                    authMessage.style.color = 'green';
                    authMessage.textContent = '인증번호가 발송되었습니다.';
                    this.textContent = '재전송';
                } else {
                    authMessage.style.color = 'red';
                    authMessage.textContent = '인증번호 발송에 실패했습니다.';
                    this.textContent = '인증 발송';
                }
            }).finally(() => {
                this.disabled = false;
            });
        });

        verifyAuthCodeBtn.addEventListener('click', function() {
            const authCode = authCodeInput.value;
            if (!authCode) {
                authMessage.textContent = '인증번호를 입력해주세요.';
                return;
            }
            
            fetch('<%= request.getContextPath() %>/verifyAuthCode', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'authCode=' + encodeURIComponent(authCode)
            }).then(response => response.text()).then(data => {
                if (data === 'success') {
                    isEmailVerified = true;
                    authMessage.style.color = 'green';
                    authMessage.textContent = '이메일 인증이 완료되었습니다.';
                    emailInput.disabled = true;
                    authCodeInput.disabled = true;
                    this.disabled = true;
                    sendAuthCodeBtn.textContent = '이메일 변경';
                    registerBtn.disabled = false;
                } else {
                    isEmailVerified = false;
                    authMessage.style.color = 'red';
                    authMessage.textContent = '인증번호가 일치하지 않습니다.';
                    registerBtn.disabled = true;
                }
            });
        });
        
        function checkForm() {
            if (!isIdChecked) {
                alert('아이디 중복 확인을 완료해주세요.');
                return false;
            }
             if (!isNicknameChecked) {
                alert('닉네임 중복 확인을 완료해주세요.');
                return false;
            }
            if (!isEmailVerified) {
                alert('이메일 인증을 완료해주세요.');
                return false;
            }
            const password = document.getElementById('password').value;
            const passwordConfirm = document.getElementById('passwordConfirm').value;
            if (password !== passwordConfirm) {
                document.getElementById('passwordMessage').textContent = '비밀번호가 일치하지 않습니다.';
                return false;
            }
            return true;
        }
        
        document.addEventListener('DOMContentLoaded', () => {
            registerBtn.disabled = true;
        });
    </script>
</body>
</html>

