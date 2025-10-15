<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${introPost.title} - 여차저차</title>
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
                <div class="bg-white p-6 sm:p-8 rounded-lg shadow-md">
                    
                    <c:choose>
                        <c:when test="${not empty introPost}">
                            <!-- 대표(INTRO) 이미지 및 제목 -->
                            <div class="text-center mb-12">
                                <a href="${pageContext.request.contextPath}/infodetail?no=${introPost.infoNo}" class="inline-block group">
                                    <img src="${pageContext.request.contextPath}/resources/images/${introPost.imageAddr}" alt="${introPost.title}" class="w-48 h-48 rounded-full shadow-lg object-cover mx-auto border-4 border-white transition-transform duration-300 group-hover:scale-105">
                                    <h1 class="text-3xl sm:text-4xl font-bold text-gray-800 mt-4">${introPost.title}</h1>
                                </a>
                                <div class="w-20 h-1 bg-green-600 mx-auto mt-4"></div>
                            </div>

                            <!-- 게시글(INFO) 목록 -->
                            <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4 sm:gap-6">
                                <c:forEach var="post" items="${postList}">
                                    <a href="${pageContext.request.contextPath}/infodetail?no=${post.infoNo}" class="group block">
                                        <div class="relative overflow-hidden rounded-lg shadow-lg aspect-square">
                                            <img src="${pageContext.request.contextPath}/resources/images/${post.imageAddr}" alt="${post.title}" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300 ease-in-out">
                                            <div class="absolute inset-0 bg-black bg-opacity-40 flex items-end p-4 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                                                <h3 class="text-white text-base font-bold truncate">${post.title}</h3>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                             <div class="text-center py-16">
                                <p class="text-gray-500">해당 카테고리에 등록된 게시글이 없습니다.</p>
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

