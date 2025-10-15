<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디/비밀번호 찾기 - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .modal-hidden { display: none; }
        .modal-visible { display: flex; }
        input:disabled, button:disabled { background-color: #f3f4f6; color: #9ca3af; cursor: not-allowed; }
    </style>
</head>
<body class="bg-gray-100 text-gray-800 flex flex-col min-h-screen">

    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <main class="w-full max-w-md mx-auto px-6 mt-8 flex-grow flex items-center">
        <div class="bg-white p-8 rounded-lg shadow-md w-full">
            
            <div class="mb-8 border-b border-gray-200">
                <nav class="-mb-px flex space-x-6" aria-label="Tabs">
                    <button id="tab-find-id" class="whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm border-green-500 text-green-600">
                        아이디 찾기
                    </button>
                    <button id="tab-find-pw" class="whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300">
                        비밀번호 찾기
                    </button>
                </nav>
            </div>

            <!-- 아이디 찾기 폼 -->
            <div id="form-find-id">
                <div class="space-y-4">
                    <p class="text-sm text-gray-600 text-center">가입 시 사용한 이메일을 입력해주세요.</p>
                    <div>
                        <label for="findIdEmail" class="sr-only">이메일</label>
                        <input type="email" id="findIdEmail" required placeholder="이메일" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm sm:text-sm">
                    </div>
                    <div class="pt-2">
                        <button type="button" id="openIdAuthModalBtn" class="w-full flex justify-center py-2 px-4 border rounded-md shadow-sm text-sm font-medium text-white bg-green-700 hover:bg-green-800">
                            아이디 찾기
                        </button>
                    </div>
                </div>
            </div>

            <!-- 비밀번호 찾기 폼 -->
            <div id="form-find-pw" class="hidden">
                 <div class="space-y-4">
                    <p class="text-sm text-gray-600 text-center">가입 시 사용한 아이디와 이메일을 입력해주세요.</p>
                    <div>
                        <label for="findPwUserId" class="sr-only">아이디</label>
                        <input type="text" id="findPwUserId" required placeholder="아이디" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm sm:text-sm">
                    </div>
                    <div>
                        <label for="findPwEmail" class="sr-only">이메일</label>
                        <input type="email" id="findPwEmail" required placeholder="이메일" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm sm:text-sm">
                    </div>
                    <div class="pt-2">
                        <button type="button" id="openPwAuthModalBtn" class="w-full flex justify-center py-2 px-4 border rounded-md shadow-sm text-sm font-medium text-white bg-green-700 hover:bg-green-800">
                            비밀번호 찾기
                        </button>
                    </div>
                </div>
            </div>
            
            <p id="mainResultMessage" class="mt-4 text-center text-sm text-red-500 h-5"></p>
            
            <div class="mt-6 text-center text-sm">
                <a href="<%= request.getContextPath() %>/login" class="font-medium text-green-600 hover:text-green-500">로그인 페이지로 돌아가기</a>
            </div>
        </div>
    </main>

    <!-- 범용 인증 모달 -->
    <div id="authModal" class="modal-hidden fixed inset-0 bg-gray-600 bg-opacity-50 h-full w-full items-center justify-center z-50">
        <div class="p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3 text-center">
                <h3 id="authModalTitle" class="text-lg leading-6 font-medium text-gray-900">이메일 인증</h3>
                <div class="mt-4 px-7 py-3 space-y-3">
                    <div class="flex rounded-md shadow-sm">
                        <input type="text" id="authCodeInput" placeholder="인증번호" class="flex-1 block w-full px-3 py-2 border border-gray-300 rounded-none rounded-l-md sm:text-sm">
                        <button type="button" id="sendAuthCodeInModalBtn" class="inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-xs hover:bg-gray-100">인증번호 전송</button>
                    </div>
                    <p id="authModalMessage" class="text-xs h-4"></p>
                    <button id="confirmInModalBtn" class="w-full mt-2 flex justify-center py-2 px-4 border rounded-md shadow-sm text-sm font-medium text-white bg-green-700 hover:bg-green-800">
                        확인
                    </button>
                </div>
                <div class="items-center px-4 py-3">
                    <button id="closeAuthModalBtn" class="text-sm text-gray-500 hover:text-gray-700">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 범용 결과 모달 -->
    <div id="resultModal" class="modal-hidden fixed inset-0 bg-gray-600 bg-opacity-50 h-full w-full items-center justify-center z-50">
        <div class="p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3 text-center">
                <h3 id="resultModalTitle" class="text-lg leading-6 font-medium text-gray-900">결과</h3>
                <div class="mt-2 px-7 py-3">
                    <p id="resultModalText" class="text-sm text-gray-500"></p>
                </div>
                <div class="items-center px-4 py-3">
                    <button id="closeResultModalBtn" class="px-4 py-2 bg-green-700 text-white text-base font-medium rounded-md w-full shadow-sm hover:bg-green-800">
                        확인
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/include/footer.jsp" />
    
    <script>
        let findMode = 'id'; 

        const mainResultMessage = document.getElementById('mainResultMessage');
        const authModal = document.getElementById('authModal');
        const resultModal = document.getElementById('resultModal');
        const closeAuthModalBtn = document.getElementById('closeAuthModalBtn');
        const closeResultModalBtn = document.getElementById('closeResultModalBtn');
        
        const tabFindId = document.getElementById('tab-find-id');
        const tabFindPw = document.getElementById('tab-find-pw');
        const formFindId = document.getElementById('form-find-id');
        const formFindPw = document.getElementById('form-find-pw');

        const findIdEmailInput = document.getElementById('findIdEmail');
        const openIdAuthModalBtn = document.getElementById('openIdAuthModalBtn');

        const findPwUserIdInput = document.getElementById('findPwUserId');
        const findPwEmailInput = document.getElementById('findPwEmail');
        const openPwAuthModalBtn = document.getElementById('openPwAuthModalBtn');

        const authModalTitle = document.getElementById('authModalTitle');
        const authCodeInput = document.getElementById('authCodeInput');
        const sendAuthCodeInModalBtn = document.getElementById('sendAuthCodeInModalBtn');
        const authModalMessage = document.getElementById('authModalMessage');
        const confirmInModalBtn = document.getElementById('confirmInModalBtn');

        const resultModalTitle = document.getElementById('resultModalTitle');
        const resultModalText = document.getElementById('resultModalText');

        function switchTab(target) {
            mainResultMessage.textContent = '';
            if (target === 'id') {
                findMode = 'id';
                formFindId.classList.remove('hidden');
                formFindPw.classList.add('hidden');
                tabFindId.classList.add('border-green-500', 'text-green-600');
                tabFindPw.classList.remove('border-green-500', 'text-green-600');
            } else {
                findMode = 'pw';
                formFindPw.classList.remove('hidden');
                formFindId.classList.add('hidden');
                tabFindPw.classList.add('border-green-500', 'text-green-600');
                tabFindId.classList.remove('border-green-500', 'text-green-600');
            }
        }
        tabFindId.addEventListener('click', () => switchTab('id'));
        tabFindPw.addEventListener('click', () => switchTab('pw'));

        function openAuthModal() {
            mainResultMessage.textContent = '';
            authModalMessage.textContent = '';
            authCodeInput.value = '';
            
            if (findMode === 'id') {
                authModalTitle.textContent = '아이디 찾기 인증';
                confirmInModalBtn.textContent = '아이디 찾기';
            } else {
                authModalTitle.textContent = '비밀번호 찾기 인증';
                confirmInModalBtn.textContent = '비밀번호 찾기';
            }
            authModal.classList.remove('modal-hidden');
            authModal.classList.add('modal-visible');
        }
        
        function closeAuthModal() {
            authModal.classList.add('modal-hidden');
            authModal.classList.remove('modal-visible');
            sendAuthCodeInModalBtn.disabled = false;
            sendAuthCodeInModalBtn.textContent = '인증번호 전송';
        }
        closeAuthModalBtn.addEventListener('click', closeAuthModal);

        function openResultModal(title, text) {
            resultModalTitle.textContent = title;
            resultModalText.innerHTML = text;
            resultModal.classList.remove('modal-hidden');
            resultModal.classList.add('modal-visible');
        }
        closeResultModalBtn.addEventListener('click', () => {
            resultModal.classList.add('modal-hidden');
            resultModal.classList.remove('modal-visible');
        });

        openIdAuthModalBtn.addEventListener('click', () => {
            if (!findIdEmailInput.value) {
                mainResultMessage.textContent = '이메일을 입력해주세요.';
                return;
            }
            openAuthModal();
        });

        openPwAuthModalBtn.addEventListener('click', () => {
            if (!findPwUserIdInput.value || !findPwEmailInput.value) {
                mainResultMessage.textContent = '아이디와 이메일을 모두 입력해주세요.';
                return;
            }
            openAuthModal();
        });

        sendAuthCodeInModalBtn.addEventListener('click', function() {
            this.disabled = true;
            this.textContent = '전송중...';
            authModalMessage.textContent = '';

            let url, body;
            if (findMode === 'id') {
                url = '<%= request.getContextPath() %>/sendFindIdAuthCode';
                body = 'email=' + encodeURIComponent(findIdEmailInput.value);
            } else {
                url = '<%= request.getContextPath() %>/sendFindPwAuthCode';
                body = 'userId=' + encodeURIComponent(findPwUserIdInput.value) + '&email=' + encodeURIComponent(findPwEmailInput.value);
            }

            fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body
            })
            .then(response => response.text())
            .then(data => {
                const result = data.trim();
                if (result === 'success') {
                    authModalMessage.style.color = 'green';
                    authModalMessage.textContent = '인증번호가 발송되었습니다.';
                    this.textContent = '재전송';
                } else if (result === 'not_found') {
                    authModalMessage.style.color = 'red';
                    authModalMessage.textContent = findMode === 'id' ? '가입되지 않은 이메일입니다.' : '일치하는 사용자 정보가 없습니다.';
                    this.textContent = '인증번호 전송';
                } else {
                    authModalMessage.style.color = 'red';
                    authModalMessage.textContent = '오류가 발생했습니다. 다시 시도해주세요.';
                    this.textContent = '인증번호 전송';
                }
            }).finally(() => {
                this.disabled = false;
            });
        });

        confirmInModalBtn.addEventListener('click', function() {
            const authCode = authCodeInput.value;
            if (!authCode) {
                authModalMessage.style.color = 'red';
                authModalMessage.textContent = '인증번호를 입력해주세요.';
                return;
            }
            this.disabled = true;
            this.textContent = '확인중...';

            let url, successHandler;
            if (findMode === 'id') {
                url = '<%= request.getContextPath() %>/findId';
                successHandler = (data) => {
                    const foundId = data.substring(6);
                    closeAuthModal();
                    openResultModal('아이디 찾기 결과', `회원님의 아이디는 <strong class="text-green-600">${foundId}</strong> 입니다.`);
                };
            } else {
                url = '<%= request.getContextPath() %>/findPassword';
                successHandler = () => {
                    closeAuthModal();
                    // [수정] 결과 메시지에 줄 바꿈(<br>) 태그를 추가합니다.
                    openResultModal('비밀번호 재설정 완료', '이메일로 임시 비밀번호가 발송되었습니다.<br>로그인 후 비밀번호를 변경해주세요.');
                };
            }
            
            fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'authCode=' + encodeURIComponent(authCode)
            })
            .then(response => response.text())
            .then(data => {
                const result = data.trim();
                if (result.startsWith('found:') || result === 'success') {
                    successHandler(result);
                } else if (result === 'verification_failed') {
                    authModalMessage.style.color = 'red';
                    authModalMessage.textContent = '인증번호가 일치하지 않습니다.';
                } else {
                    authModalMessage.style.color = 'red';
                    authModalMessage.textContent = '오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
                }
            }).finally(() => {
                this.disabled = false;
                this.textContent = findMode === 'id' ? '아이디 찾기' : '비밀번호 찾기';
            });
        });
    </script>
</body>
</html>

