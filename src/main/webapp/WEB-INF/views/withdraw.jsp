<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 탈퇴 - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style> body { font-family: 'Noto Sans KR', sans-serif; } </style>
</head>
<body class="bg-gray-100 text-gray-800 flex flex-col min-h-screen">
    <jsp:include page="/WEB-INF/views/include/header.jsp" />
    <main class="w-full max-w-sm mx-auto px-6 mt-8 flex-grow flex items-center">
        <div class="bg-white p-8 rounded-lg shadow-md w-full">
            <h1 class="text-2xl font-bold text-center mb-6">회원 탈퇴</h1>
            <p class="text-center text-sm text-gray-600 mb-6">
                정말로 회원 탈퇴를 진행하시겠습니까?<br>
                탈퇴 시 모든 정보는 복구할 수 없습니다.
            </p>
            <form action="<%= request.getContextPath() %>/withdraw" method="post">
                <p class="text-center text-sm text-gray-700 mb-4">
                    본인 확인을 위해<br>비밀번호를 한번 더 입력해주세요.
                </p>
                
                <input type="password" name="password" required placeholder="비밀번호" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm sm:text-sm">
                
                <c:if test="${not empty errorMessage}">
                    <p class="mt-2 text-xs text-red-500">${errorMessage}</p>
                </c:if>
                
                <div class="pt-6 flex gap-x-3">
                    <button type="button" onclick="location.href='<%= request.getContextPath() %>/'" class="w-full flex justify-center py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                        아니요
                    </button>
                    <button type="submit" class="w-full flex justify-center py-2 px-4 border rounded-md shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700">
                        예, 탈퇴합니다.
                    </button>
                </div>
            </form>
        </div>
    </main>
    <jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
