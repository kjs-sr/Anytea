<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tea.dto.UserDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원정보 수정 - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .form-section { border-top: 1px solid #e5e7eb; padding-top: 1.5rem; margin-top: 1.5rem; }
        .section-title { font-size: 1.125rem; font-weight: 600; margin-bottom: 1rem; }
        .msg-success { color: green; }
        .msg-error { color: red; }
    </style>
</head>
<body class="bg-gray-100 text-gray-800 flex flex-col min-h-screen">

    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <main class="w-full max-w-lg mx-auto px-6 my-8 flex-grow">
        <div class="bg-white p-8 rounded-lg shadow-md w-full">
            <h1 class="text-3xl font-bold text-center mb-8">회원정보 수정</h1>
            
            <form id="editProfileForm" action="<%= request.getContextPath() %>/updateProfile" method="post" onsubmit="return validateForm()">
                
                <!-- ... (아이디, 비밀번호, 닉네임, 이메일 폼은 이전과 동일) ... -->
                <div>
                    <h2 class="section-title">아이디</h2>
                    <input type="text" id="userId" name="userId" value="${user.userId}" readonly class="block w-full px-3 py-2 bg-gray-100 border border-gray-300 rounded-md shadow-sm sm:text-sm cursor-not-allowed">
                </div>
                <div class="form-section">
                    <h2 class="section-title">비밀번호 변경</h2>
                    <div class="space-y-3">
                        <input type="password" id="currentPassword" name="currentPassword" placeholder="현재 비밀번호" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm sm:text-sm">
                        <input type="password" id="newPassword" name="newPassword" placeholder="새로운 비밀번호" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm sm:text-sm">
                        <input type="password" id="newPasswordConfirm" name="newPasswordConfirm" placeholder="새로운 비밀번호 확인" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm sm:text-sm">
                    </div>
                </div>
                <div class="form-section">
                    <h2 class="section-title">닉네임 변경</h2>
                    <div class="flex rounded-md shadow-sm">
                        <input type="text" id="nickname" name="nickname" value="${user.nickname}" required class="flex-1 block w-full px-3 py-2 border border-gray-300 rounded-none rounded-l-md sm:text-sm">
                        <button type="button" id="checkNicknameBtn" class="inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-xs hover:bg-gray-100">중복 확인</button>
                    </div>
                    <p id="nicknameMessage" class="mt-1 text-xs h-4"></p>
                </div>
                <div class="form-section">
                    <h2 class="section-title">이메일 변경</h2>
                    <div class="space-y-2">
                        <div class="flex rounded-md shadow-sm">
                            <input type="email" id="email" name="email" value="${user.email}" readonly class="flex-1 block w-full px-3 py-2 bg-gray-100 border border-gray-300 rounded-none rounded-l-md sm:text-sm cursor-not-allowed">
                            <button type="button" id="changeEmailBtn" class="inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-xs hover:bg-gray-100">변경</button>
                        </div>
                        <div id="newEmailSection" class="hidden space-y-2">
                             <div class="flex rounded-md shadow-sm">
                                <input type="email" id="newEmail" name="newEmailInput" placeholder="새로운 이메일" class="flex-1 block w-full px-3 py-2 border border-gray-300 rounded-none rounded-l-md sm:text-sm">
                                <button type="button" id="sendAuthCodeBtn" class="inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-xs hover:bg-gray-100">인증 발송</button>
                            </div>
                            <div class="flex rounded-md shadow-sm">
                                <input type="text" id="authCode" name="authCode" placeholder="인증번호" class="flex-1 block w-full px-3 py-2 border border-gray-300 rounded-none rounded-l-md sm:text-sm">
                                <button type="button" id="verifyAuthCodeBtn" class="inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-xs hover:bg-gray-100">인증 확인</button>
                            </div>
                        </div>
                        <p id="emailMessage" class="mt-1 text-xs h-4"></p>
                    </div>
                </div>

                <div class="form-section">
                    <button type="submit" class="w-full flex justify-center py-2 px-4 border rounded-md shadow-sm text-sm font-medium text-white bg-green-700 hover:bg-green-800">
                       수정하기
                   </button>
                   <div class="mt-4 flex justify-between items-center">
                        <a href="<%= request.getContextPath() %>/" class="text-sm text-gray-600 hover:underline">초기 화면으로</a>
                        <a href="<%= request.getContextPath() %>/checkPassword?action=withdraw" class="text-xs text-red-600 hover:text-red-800 hover:underline">회원 탈퇴</a>
                   </div>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/include/footer.jsp" />
    
    <script>
        // 초기 상태 변수
        const originalNickname = "${user.nickname}";
        let isNicknameChecked = true; // 페이지 로드 시에는 현재 닉네임을 사용 가능한 상태로 간주
        let isNewEmailVerified = false;

        // --- DOM 요소 ---
        const nicknameInput = document.getElementById('nickname');
        const nicknameMessage = document.getElementById('nicknameMessage');
        const changeEmailBtn = document.getElementById('changeEmailBtn');
        const newEmailSection = document.getElementById('newEmailSection');
        const newEmailInput = document.getElementById('newEmail');
        const emailMessage = document.getElementById('emailMessage');

        // --- 이벤트 리스너 ---

        // 닉네임 입력 변경 시 중복 확인 다시 필요
        nicknameInput.addEventListener('input', () => {
            if (nicknameInput.value !== originalNickname) {
                isNicknameChecked = false;
                nicknameMessage.textContent = '닉네임 중복 확인이 필요합니다.';
                nicknameMessage.className = 'mt-1 text-xs h-4 msg-error';
            } else {
                isNicknameChecked = true;
                nicknameMessage.textContent = '';
            }
        });

        // 닉네임 중복 확인 버튼
        document.getElementById('checkNicknameBtn').addEventListener('click', async () => {
            const nickname = nicknameInput.value;
            if (nickname === originalNickname) {
                isNicknameChecked = true;
                nicknameMessage.textContent = '현재 사용 중인 닉네임입니다.';
                nicknameMessage.className = 'mt-1 text-xs h-4 msg-success';
                return;
            }
            const isDuplicate = await checkDuplicate('nickname', nickname, nicknameMessage);
            isNicknameChecked = !isDuplicate;
        });
        
        // 이메일 변경 버튼
        changeEmailBtn.addEventListener('click', () => {
            newEmailSection.classList.toggle('hidden');
            isNewEmailVerified = false; // 이메일 변경 섹션을 열 때마다 인증 상태 초기화
            emailMessage.textContent = '';
            if (!newEmailSection.classList.contains('hidden')) {
                changeEmailBtn.textContent = '취소';
            } else {
                changeEmailBtn.textContent = '변경';
            }
        });

        // 이메일 인증번호 발송 버튼
        document.getElementById('sendAuthCodeBtn').addEventListener('click', async function() {
            const newEmail = newEmailInput.value;
            const isDuplicate = await checkDuplicate('email', newEmail, emailMessage);
            if(isDuplicate) return;

            this.disabled = true;
            this.textContent = '전송중...';
            // 이메일 변경 전용 서블릿 호출로 변경
            fetch('<%= request.getContextPath() %>/sendChangeEmailAuthCode', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'email=' + encodeURIComponent(newEmail)
            }).then(res => res.text()).then(data => {
                if(data === 'success') {
                    emailMessage.textContent = '인증번호가 발송되었습니다.';
                    emailMessage.className = 'mt-1 text-xs h-4 msg-success';
                } else {
                    emailMessage.textContent = '인증번호 발송에 실패했습니다.';
                    emailMessage.className = 'mt-1 text-xs h-4 msg-error';
                }
            }).finally(() => { this.disabled = false; this.textContent = '인증 발송'; });
        });

        // 이메일 인증번호 확인 버튼
        document.getElementById('verifyAuthCodeBtn').addEventListener('click', function() {
            const authCode = document.getElementById('authCode').value;
            fetch('<%= request.getContextPath() %>/verifyNewEmail', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'authCode=' + encodeURIComponent(authCode)
            }).then(res => res.text()).then(data => {
                if(data === 'success'){
                    isNewEmailVerified = true;
                    emailMessage.textContent = '이메일 인증이 완료되었습니다.';
                    emailMessage.className = 'mt-1 text-xs h-4 msg-success';
                    newEmailInput.disabled = true;
                    this.disabled = true;
                } else {
                    isNewEmailVerified = false;
                    emailMessage.textContent = '인증번호가 일치하지 않습니다.';
                    emailMessage.className = 'mt-1 text-xs h-4 msg-error';
                }
            });
        });
        
        // --- 함수 ---

        // 중복 확인 fetch 함수
        async function checkDuplicate(field, value, messageEl) {
            if (!value) {
                messageEl.textContent = '값을 입력해주세요.';
                messageEl.className = 'mt-1 text-xs h-4 msg-error';
                return true;
            }
            const response = await fetch('<%= request.getContextPath() %>/checkDuplicate', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'field=' + field + '&value=' + encodeURIComponent(value)
            });
            const data = await response.text();
            if (data === 'duplicate') {
                messageEl.textContent = '이미 사용 중인 ' + (field === 'nickname' ? '닉네임' : '이메일') + '입니다.';
                messageEl.className = 'mt-1 text-xs h-4 msg-error';
                return true;
            } else {
                messageEl.textContent = '사용 가능한 ' + (field === 'nickname' ? '닉네임' : '이메일') + '입니다.';
                messageEl.className = 'mt-1 text-xs h-4 msg-success';
                return false;
            }
        }
        
        // 폼 제출 전 유효성 검사
        function validateForm() {
            if (!isNicknameChecked) {
                alert('닉네임 중복 확인을 해주세요.');
                return false;
            }
            if (!newEmailSection.classList.contains('hidden') && !isNewEmailVerified) {
                alert('새로운 이메일 인증을 완료해주세요.');
                return false;
            }
            // 비밀번호 유효성 검사 추가 (새 비밀번호 입력 시 현재 비밀번호 필수 등)
            // ...
            
            return true;
        }

    </script>
</body>
</html>

