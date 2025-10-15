<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 확인 - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style> body { font-family: 'Noto Sans KR', sans-serif; } </style>
</head>
<body class="bg-gray-100 text-gray-800 flex flex-col min-h-screen">
    <jsp:include page="/WEB-INF/views/include/header.jsp" />
    <main class="w-full max-w-sm mx-auto px-6 mt-8 flex-grow flex items-center">
        <div class="bg-white p-8 rounded-lg shadow-md w-full">
            <h1 class="text-2xl font-bold text-center mb-6">비밀번호 확인</h1>
            <p class="text-center text-sm text-gray-600 mb-6">
                회원님의 정보를 안전하게 보호하기 위해<br>비밀번호를 다시 한번 입력해주세요.
            </p>
            <form action="<%= request.getContextPath() %>/checkPassword" method="post">
                <input type="hidden" name="nextAction" value="${param.action}">
                <input type="password" name="password" required placeholder="비밀번호" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm sm:text-sm">
                
                <c:if test="${not empty errorMessage}">
                    <p class="mt-2 text-xs text-red-500">${errorMessage}</p>
                </c:if>
                
                <div class="pt-4">
                    <button type="submit" class="w-full flex justify-center py-2 px-4 border rounded-md shadow-sm text-sm font-medium text-white bg-green-700 hover:bg-green-800">
                        확인
                    </button>
                </div>
                <div class="text-center mt-4">
                    <a href="<%= request.getContextPath() %>/" class="text-sm text-gray-600 hover:underline">초기 화면으로</a>
                </div>
            </form>
        </div>
    </main>
    <jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>

