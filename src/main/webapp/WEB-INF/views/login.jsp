<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .fade-out {
            opacity: 0;
            transition: opacity 0.5s ease-out;
        }
    </style>
</head>
<body class="bg-gray-100 text-gray-800 flex flex-col min-h-screen">

    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <main class="w-full max-w-md mx-auto px-6 mt-8 flex-grow flex items-center">
        <div class="bg-white p-8 rounded-lg shadow-md w-full">
            <h1 class="text-3xl font-bold text-center mb-8">로그인</h1>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div id="errorMessage" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-6 text-sm" role="alert">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/login" method="post" class="space-y-4">
                <div>
                    <input type="text" id="userId" name="userId" required placeholder="아이디"
                        class="block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm">
                </div>
                <div>
                    <input type="password" id="password" name="password" required placeholder="비밀번호"
                        class="block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm">
                </div>
                <div class="pt-2">
                    <button type="submit"
                        class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-green-700 hover:bg-green-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                        로그인
                    </button>
                </div>
            </form>

            <div class="mt-6 text-center text-sm">
                <a href="<%= request.getContextPath() %>/register" class="font-medium text-green-600 hover:text-green-500">회원가입</a>
                <span class="mx-2 text-gray-300">|</span>
                <a href="<%= request.getContextPath() %>/find-account" class="font-medium text-green-600 hover:text-green-500">아이디/비밀번호 찾기</a>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/include/footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const errorMessage = document.getElementById('errorMessage');
            if (errorMessage) {
                setTimeout(() => {
                    errorMessage.classList.add('fade-out');
                    setTimeout(() => {
                        errorMessage.remove();
                    }, 500);
                }, 3000); 
            }
        });
    </script>
</body>
</html>

