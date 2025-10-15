<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>여차저차 - 차 정보 공유 게시판</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; }
        .accordion-content { display: grid; grid-template-rows: 0fr; transition: grid-template-rows 0.5s ease-in-out; }
        .accordion-content.is-open { grid-template-rows: 1fr; }
        .aspect-square { aspect-ratio: 1 / 1; }
    </style>
</head>
<body class="bg-gray-100 text-gray-800 flex flex-col min-h-screen">

    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <div class="w-full max-w-[2100px] mx-auto px-6 mt-8 flex-grow">
        <div class="flex justify-center gap-6">
            <jsp:include page="/WEB-INF/views/include/menu.jsp" />

            <main class="min-w-0 lg:flex-1">
                <div class="bg-white p-8 rounded-lg shadow-md">
                    
                    <div class="space-y-8">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                            <!-- [수정] 인기글 구역 -->
                            <div class="bg-gray-50 p-6 rounded-lg flex flex-col">
                                <div class="flex justify-between items-center border-b-2 border-green-700 pb-2 mb-4">
                                    <h2 class="text-xl font-bold text-gray-800">인기글</h2>
                                </div>
                                <div class="space-y-2 flex-grow">
                                    <c:forEach var="post" items="${popularPosts}">
                                        <a href="${pageContext.request.contextPath}/postdetail?no=${post.postNo}" class="flex items-center justify-between p-3 border rounded-md bg-white text-gray-700 text-sm hover:bg-gray-50">
                                            <div class="flex items-center gap-2 min-w-0">
                                                <span class="text-xs font-semibold py-1 px-2 uppercase rounded-full text-blue-600 bg-blue-200 flex-shrink-0">${post.tagMain}</span>
                                                <c:if test="${not empty post.tagTea}"><span class="text-xs font-semibold py-1 px-2 uppercase rounded-full text-green-600 bg-green-200 flex-shrink-0">${post.tagTea}</span></c:if>
                                                <c:if test="${not empty post.tagRegion}"><span class="text-xs font-semibold py-1 px-2 uppercase rounded-full text-purple-600 bg-purple-200 flex-shrink-0">${post.tagRegion}</span></c:if>
                                                <span class="truncate ml-2">${post.title}</span>
                                            </div>
                                            <div class="flex items-center text-red-500 flex-shrink-0 ml-4">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" /></svg>
                                                <span class="ml-1 font-semibold">${post.likes}</span>
                                            </div>
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                            <!-- [수정] 최신글 구역 -->
                            <div class="bg-gray-50 p-6 rounded-lg flex flex-col">
                                <div class="flex justify-between items-center border-b-2 border-green-700 pb-2 mb-4">
                                    <h2 class="text-xl font-bold text-gray-800">최신글</h2>
                                    <a href="${pageContext.request.contextPath}/community" class="text-sm text-gray-500 hover:text-green-700">(더보기)</a>
                                </div>
                                <div class="space-y-2 flex-grow">
                                     <c:forEach var="post" items="${latestPosts}">
                                        <a href="${pageContext.request.contextPath}/postdetail?no=${post.postNo}" class="flex items-center p-3 border rounded-md bg-white text-gray-700 text-sm hover:bg-gray-50">
                                            <div class="flex items-center gap-2 min-w-0">
                                                <span class="text-xs font-semibold py-1 px-2 uppercase rounded-full text-blue-600 bg-blue-200 flex-shrink-0">${post.tagMain}</span>
                                                <c:if test="${not empty post.tagTea}"><span class="text-xs font-semibold py-1 px-2 uppercase rounded-full text-green-600 bg-green-200 flex-shrink-0">${post.tagTea}</span></c:if>
                                                <c:if test="${not empty post.tagRegion}"><span class="text-xs font-semibold py-1 px-2 uppercase rounded-full text-purple-600 bg-purple-200 flex-shrink-0">${post.tagRegion}</span></c:if>
                                                <span class="truncate ml-2">${post.title}</span>
                                            </div>
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- 차 소개 섹션 (이전과 동일) -->
                        <div class="bg-gray-50 p-6 rounded-lg">
                            <div class="border-b-2 border-green-700 pb-2 mb-4">
                                <h2 class="text-xl font-bold text-gray-800">차 소개</h2>
                            </div>
                            <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-6">
                                <a href="${pageContext.request.contextPath}/teatype?category=녹차" class="group block text-center">
                                    <div class="overflow-hidden rounded-full shadow-md mb-2 aspect-square bg-white p-1">
                                        <img src="${pageContext.request.contextPath}/resources/images/녹차.jpg" alt="녹차 이미지" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300 rounded-full">
                                    </div>
                                    <span class="font-semibold text-gray-700">녹차</span>
                                </a>
                                 <a href="${pageContext.request.contextPath}/teatype?category=청차" class="group block text-center">
                                    <div class="overflow-hidden rounded-full shadow-md mb-2 aspect-square bg-white p-1">
                                        <img src="${pageContext.request.contextPath}/resources/images/청차.jpg" alt="청차 이미지" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300 rounded-full">
                                    </div>
                                    <span class="font-semibold text-gray-700">청차</span>
                                </a>
                                 <a href="${pageContext.request.contextPath}/teatype?category=홍차" class="group block text-center">
                                    <div class="overflow-hidden rounded-full shadow-md mb-2 aspect-square bg-white p-1">
                                        <img src="${pageContext.request.contextPath}/resources/images/홍차.jpg" alt="홍차 이미지" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300 rounded-full">
                                    </div>
                                    <span class="font-semibold text-gray-700">홍차</span>
                                </a>
                                 <a href="${pageContext.request.contextPath}/teatype?category=흑차" class="group block text-center">
                                    <div class="overflow-hidden rounded-full shadow-md mb-2 aspect-square bg-white p-1">
                                        <img src="${pageContext.request.contextPath}/resources/images/흑차.jpg" alt="흑차 이미지" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300 rounded-full">
                                    </div>
                                    <span class="font-semibold text-gray-700">흑차</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/teatype?category=백차" class="group block text-center">
                                    <div class="overflow-hidden rounded-full shadow-md mb-2 aspect-square bg-white p-1">
                                        <img src="${pageContext.request.contextPath}/resources/images/백차.jpg" alt="백차 이미지" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300 rounded-full">
                                    </div>
                                    <span class="font-semibold text-gray-700">백차</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/teatype?category=대용차" class="group block text-center">
                                    <div class="overflow-hidden rounded-full shadow-md mb-2 aspect-square bg-white p-1">
                                        <img src="${pageContext.request.contextPath}/resources/images/대용차.jpg" alt="대용차 이미지" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300 rounded-full">
                                    </div>
                                    <span class="font-semibold text-gray-700">대용차</span>
                                </a>
                            </div>
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

