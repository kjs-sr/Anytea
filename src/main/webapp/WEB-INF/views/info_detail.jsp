<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${post.title} - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .accordion-content { display: grid; grid-template-rows: 0fr; transition: grid-template-rows 0.5s ease-in-out; }
        .accordion-content.is-open { grid-template-rows: 1fr; }
        /* Summernote 에디터 콘텐츠 스타일 초기화 */
        .note-content p { margin-bottom: 1rem; }
        .note-content h1, .note-content h2, .note-content h3 { font-weight: bold; margin-bottom: 1rem; }
        .note-content img { max-width: 100%; height: auto; border-radius: 0.5rem; margin: 1rem 0; }
    </style>
</head>
<body class="bg-gray-100 text-gray-800 flex flex-col min-h-screen">

    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <div class="w-full max-w-[2100px] mx-auto px-6 mt-8 flex-grow">
        <div class="flex justify-center gap-6">
            <jsp:include page="/WEB-INF/views/include/menu.jsp" />

            <main class="min-w-0 lg:flex-1">
                <div class="bg-white p-6 sm:p-8 rounded-lg shadow-md">
                    
                    <c:choose>
                        <c:when test="${not empty post}">
                            <!-- 글 제목 -->
                            <div class="border-b-2 border-gray-200 pb-6 mb-6 flex items-center gap-6">
                                <!-- 대표 이미지 -->
                                <img src="${pageContext.request.contextPath}/resources/images/${post.imageAddr}" alt="${post.title}" class="w-24 h-24 sm:w-32 sm:h-32 rounded-lg object-cover shadow-md flex-shrink-0">
                                <div class="flex-grow">
                                    <h1 class="text-3xl sm:text-4xl font-bold text-gray-800">${post.title}</h1>
                                    <!-- 태그 정보 -->
                                    <div class="flex items-center space-x-2 mt-3 text-sm text-gray-500">
                                        <span class="bg-green-100 text-green-800 px-2 py-1 rounded-full">${post.tagTea}</span>
                                        <c:if test="${not empty post.tagRegion}">
                                            <span class="bg-blue-100 text-blue-800 px-2 py-1 rounded-full">${post.tagRegion}</span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <!-- 글 내용 -->
                            <div class="prose max-w-none note-content">
                                ${post.contents}
                            </div>

                            <!-- 이전으로 가기 버튼 -->
                            <div class="mt-8 pt-6 border-t-2 border-gray-200 flex justify-center">
                                <button onclick="history.back()" class="px-6 py-2 bg-gray-600 text-white font-semibold rounded-lg shadow-md hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-opacity-75 transition-colors duration-200">
                                    이전으로
                                </button>
                            </div>

                        </c:when>
                        <c:otherwise>
                             <div class="text-center py-16">
                                <p class="text-gray-500">요청하신 게시글을 찾을 수 없습니다.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    
                </div>
            </main>

            <div class="hidden lg:block w-44 flex-shrink-0"></div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/include/footer.jsp" />

</body>
</html>

