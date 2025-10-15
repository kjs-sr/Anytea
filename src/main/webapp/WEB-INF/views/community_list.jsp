<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style> body { font-family: 'Noto Sans KR', sans-serif; } </style>
</head>
<body class="bg-gray-100 text-gray-800 flex flex-col min-h-screen">

    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <div class="w-full max-w-[2100px] mx-auto px-6 mt-8 flex-grow">
        <div class="flex justify-center gap-6">
            <jsp:include page="/WEB-INF/views/include/menu.jsp" />

            <main class="min-w-0 lg:flex-1">
                <div class="bg-white p-6 sm:p-8 rounded-lg shadow-md">
                    <h1 class="text-3xl font-bold text-gray-800 mb-6">${pageTitle}</h1>
                    
                    <form id="searchForm" action="${pageContext.request.contextPath}/community" method="get">
                        <div class="bg-gray-50 p-4 rounded-lg mb-4 flex flex-wrap items-center gap-4">
                            <c:if test="${!showCategoryFilter}">
                                <input type="hidden" name="tag_main" value="${pageTitle}">
                            </c:if>
                            
                            <c:if test="${showCategoryFilter}">
                                <input type="hidden" name="source" value="search_form">
                                <select name="tag_main" class="border border-gray-300 rounded-md px-3 py-2 text-sm">
                                    <option value="">카테고리</option>
                                    <option value="정보" ${param.tag_main == '정보' ? 'selected' : ''}>정보</option>
                                    <option value="추천" ${param.tag_main == '추천' ? 'selected' : ''}>추천</option>
                                    <option value="리뷰" ${param.tag_main == '리뷰' ? 'selected' : ''}>리뷰</option>
                                </select>
                            </c:if>
                            
                            <select name="tag_tea" class="border border-gray-300 rounded-md px-3 py-2 text-sm">
                                <option value="">차 종류</option>
                                <option value="녹차" ${param.tag_tea == '녹차' ? 'selected' : ''}>녹차</option>
                                <option value="청차" ${param.tag_tea == '청차' ? 'selected' : ''}>청차</option>
                                <option value="홍차" ${param.tag_tea == '홍차' ? 'selected' : ''}>홍차</option>
                                <option value="흑차" ${param.tag_tea == '흑차' ? 'selected' : ''}>흑차</option>
                                <option value="백차" ${param.tag_tea == '백차' ? 'selected' : ''}>백차</option>
                                <option value="대용차" ${param.tag_tea == '대용차' ? 'selected' : ''}>대용차</option>
                            </select>
                            
                            <select name="tag_region" class="border border-gray-300 rounded-md px-3 py-2 text-sm">
                                <option value="">지역 별</option>
                                <option value="아시아" ${param.tag_region == '아시아' ? 'selected' : ''}>아시아</option>
                                <option value="유럽" ${param.tag_region == '유럽' ? 'selected' : ''}>유럽</option>
                                <option value="아메리카" ${param.tag_region == '아메리카' ? 'selected' : ''}>아메리카</option>
                                <option value="아프리카" ${param.tag_region == '아프리카' ? 'selected' : ''}>아프리카</option>
                            </select>
                            
                            <input type="text" name="title_query" placeholder="제목 검색" value="${param.title_query}" class="border border-gray-300 rounded-md px-3 py-2 text-sm flex-grow">
                            <button type="submit" class="bg-green-700 text-white px-4 py-2 rounded-md text-sm hover:bg-green-800">검색</button>
                        </div>
                        
                        <div class="flex justify-end mb-4">
                            <select name="limit" onchange="this.form.submit()" class="border border-gray-300 rounded-md px-3 py-1 text-sm">
                                <option value="1" ${limit == 1 ? 'selected' : ''}>1줄씩 보기</option>
                                <option value="3" ${limit == 3 ? 'selected' : ''}>3줄씩 보기</option>
                                <option value="5" ${limit == 5 ? 'selected' : ''}>5줄씩 보기</option>
                                <option value="10" ${limit == 10 ? 'selected' : ''}>10줄씩 보기</option>
                                <option value="15" ${limit == 15 ? 'selected' : ''}>15줄씩 보기</option>
                            </select>
                        </div>
                    </form>
                    
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm text-left text-gray-500">
                            <thead class="text-xs text-gray-700 uppercase bg-gray-100">
                                <tr>
                                    <th scope="col" class="w-16 px-6 py-3 text-center whitespace-nowrap">번호</th>
                                    <th scope="col" class="w-56 px-6 py-3 whitespace-nowrap">태그</th>
                                    <th scope="col" class="px-6 py-3 whitespace-nowrap">제목</th>
                                    <th scope="col" class="w-32 px-6 py-3 text-center whitespace-nowrap">작성자</th>
                                    <th scope="col" class="w-28 px-6 py-3 text-center whitespace-nowrap">작성일</th>
                                    <th scope="col" class="w-20 px-6 py-3 text-center whitespace-nowrap">좋아요</th>
                                    <th scope="col" class="w-20 px-6 py-3 text-center whitespace-nowrap">조회수</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="post" items="${postList}">
                                    <tr class="bg-white border-b hover:bg-gray-50">
                                        <td class="px-6 py-4 text-center">${post.postNo}</td>
                                        <td class="px-6 py-4">
                                            <div class="flex items-center gap-2 flex-wrap">
                                                <span class="text-xs font-semibold inline-block py-1 px-2 uppercase rounded-full text-blue-600 bg-blue-200">${post.tagMain}</span>
                                                <c:if test="${not empty post.tagTea}"><span class="text-xs font-semibold inline-block py-1 px-2 uppercase rounded-full text-green-600 bg-green-200">${post.tagTea}</span></c:if>
                                                <c:if test="${not empty post.tagRegion}"><span class="text-xs font-semibold inline-block py-1 px-2 uppercase rounded-full text-purple-600 bg-purple-200">${post.tagRegion}</span></c:if>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 font-medium text-gray-900">
                                            <div class="flex items-baseline">
                                                <a href="${pageContext.request.contextPath}/postdetail?no=${post.postNo}" class="hover:underline truncate">${post.title}</a>
                                                <c:if test="${post.commentCount > 0}">
                                                    <span class="ml-2 text-gray-500 font-normal flex-shrink-0">[${post.commentCount}]</span>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 text-center truncate">${post.nickname}</td>
                                        <td class="px-6 py-4 text-center"><fmt:formatDate value="${post.date}" pattern="yyyy.MM.dd"/></td>
                                        <td class="px-6 py-4 text-center">${post.likes}</td>
                                        <td class="px-6 py-4 text-center">${post.views}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-6 flex justify-between items-center">
                        <div class="w-24"></div> 
                        <nav class="flex justify-center flex-grow">
                            <ul class="flex items-center -space-x-px h-8 text-sm">
                                <%-- [수정] << 버튼 표시 조건 추가 --%>
                                <c:if test="${!pagination.first}">
                                    <c:url var="firstUrl" value="/community">
                                        <c:param name="page" value="1" />
                                        <c:param name="limit" value="${limit}" />
                                        <c:if test="${not empty param.tag_main}"><c:param name="tag_main" value="${param.tag_main}" /></c:if>
                                        <c:if test="${not empty param.tag_tea}"><c:param name="tag_tea" value="${param.tag_tea}" /></c:if>
                                        <c:if test="${not empty param.tag_region}"><c:param name="tag_region" value="${param.tag_region}" /></c:if>
                                        <c:if test="${not empty param.title_query}"><c:param name="title_query" value="${param.title_query}" /></c:if>
                                        <c:if test="${not empty param.source}"><c:param name="source" value="${param.source}" /></c:if>
                                    </c:url>
                                    <li><a href="${firstUrl}" class="flex items-center justify-center px-3 h-8 ms-0 leading-tight text-gray-500 bg-white border border-e-0 border-gray-300 rounded-s-lg hover:bg-gray-100 hover:text-gray-700">&lt;&lt;</a></li>
                                </c:if>
                                
                                <c:if test="${pagination.prev}">
                                    <c:url var="prevUrl" value="/community">
                                        <c:param name="page" value="${pagination.startPage - 1}" />
                                        <c:param name="limit" value="${limit}" />
                                        <c:if test="${not empty param.tag_main}"><c:param name="tag_main" value="${param.tag_main}" /></c:if>
                                        <c:if test="${not empty param.tag_tea}"><c:param name="tag_tea" value="${param.tag_tea}" /></c:if>
                                        <c:if test="${not empty param.tag_region}"><c:param name="tag_region" value="${param.tag_region}" /></c:if>
                                        <c:if test="${not empty param.title_query}"><c:param name="title_query" value="${param.title_query}" /></c:if>
                                        <c:if test="${not empty param.source}"><c:param name="source" value="${param.source}" /></c:if>
                                    </c:url>
                                    <li><a href="${prevUrl}" class="flex items-center justify-center px-3 h-8 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700">&lt;</a></li>
                                </c:if>
                                
                                <c:forEach var="pageNum" begin="${pagination.startPage}" end="${pagination.endPage}">
                                    <c:url var="pageUrl" value="/community">
                                        <c:param name="page" value="${pageNum}" />
                                        <c:param name="limit" value="${limit}" />
                                        <c:if test="${not empty param.tag_main}"><c:param name="tag_main" value="${param.tag_main}" /></c:if>
                                        <c:if test="${not empty param.tag_tea}"><c:param name="tag_tea" value="${param.tag_tea}" /></c:if>
                                        <c:if test="${not empty param.tag_region}"><c:param name="tag_region" value="${param.tag_region}" /></c:if>
                                        <c:if test="${not empty param.title_query}"><c:param name="title_query" value="${param.title_query}" /></c:if>
                                        <c:if test="${not empty param.source}"><c:param name="source" value="${param.source}" /></c:if>
                                    </c:url>
                                    <li>
                                        <a href="${pageUrl}" class="flex items-center justify-center px-3 h-8 leading-tight ${pagination.currentPage == pageNum ? 'text-blue-600 border border-blue-300 bg-blue-50' : 'text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700'}">
                                            ${pageNum}
                                        </a>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${pagination.next}">
                                     <c:url var="nextUrl" value="/community">
                                        <c:param name="page" value="${pagination.endPage + 1}" />
                                        <c:param name="limit" value="${limit}" />
                                        <c:if test="${not empty param.tag_main}"><c:param name="tag_main" value="${param.tag_main}" /></c:if>
                                        <c:if test="${not empty param.tag_tea}"><c:param name="tag_tea" value="${param.tag_tea}" /></c:if>
                                        <c:if test="${not empty param.tag_region}"><c:param name="tag_region" value="${param.tag_region}" /></c:if>
                                        <c:if test="${not empty param.title_query}"><c:param name="title_query" value="${param.title_query}" /></c:if>
                                        <c:if test="${not empty param.source}"><c:param name="source" value="${param.source}" /></c:if>
                                    </c:url>
                                    <li><a href="${nextUrl}" class="flex items-center justify-center px-3 h-8 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700">&gt;</a></li>
                                </c:if>

                                <%-- [수정] >> 버튼 표시 조건 추가 --%>
                                <c:if test="${!pagination.last}">
                                    <c:url var="lastUrl" value="/community">
                                        <c:param name="page" value="${pagination.totalPages}" />
                                        <c:param name="limit" value="${limit}" />
                                        <c:if test="${not empty param.tag_main}"><c:param name="tag_main" value="${param.tag_main}" /></c:if>
                                        <c:if test="${not empty param.tag_tea}"><c:param name="tag_tea" value="${param.tag_tea}" /></c:if>
                                        <c:if test="${not empty param.tag_region}"><c:param name="tag_region" value="${param.tag_region}" /></c:if>
                                        <c:if test="${not empty param.title_query}"><c:param name="title_query" value="${param.title_query}" /></c:if>
                                        <c:if test="${not empty param.source}"><c:param name="source" value="${param.source}" /></c:if>
                                    </c:url>
                                    <li><a href="${lastUrl}" class="flex items-center justify-center px-3 h-8 leading-tight text-gray-500 bg-white border border-gray-300 rounded-e-lg hover:bg-gray-100 hover:text-gray-700">&gt;&gt;</a></li>
                                </c:if>
                            </ul>
                        </nav>
                        
                        <div class="w-24 text-right">
	                        <c:if test="${not empty sessionScope.loginUser}">
	                            <a href="${pageContext.request.contextPath}/writePost" class="bg-green-700 text-white px-4 py-2 rounded-md text-sm hover:bg-green-800 flex-shrink-0">글 작성</a>
	                        </c:if>
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

