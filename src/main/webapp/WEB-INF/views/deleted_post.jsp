<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>알림 - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style> body { font-family: 'Noto Sans KR', sans-serif; } </style>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <div class="w-full max-w-[2100px] mx-auto px-6 mt-8 flex-grow">
        <div class="flex justify-center gap-6">
            <jsp:include page="/WEB-INF/views/include/menu.jsp" />

            <main class="min-w-0 lg:flex-1">
                <div class="bg-white p-8 rounded-lg shadow-md text-center">
                    <div class="py-16">
                        <h1 class="text-2xl font-bold text-gray-700">삭제된 게시글입니다.</h1>
                        <p class="text-gray-500 mt-2">요청하신 게시글은 삭제되었거나 찾을 수 없습니다.</p>
                        <div class="mt-8">
                            <a href="${pageContext.request.contextPath}/community" class="bg-green-700 text-white px-6 py-2 rounded-md text-sm hover:bg-green-800">목록으로 돌아가기</a>
                        </div>
                    </div>
                </div>
            </main>

            <div class="hidden lg:block w-44 flex-shrink-0"></div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
