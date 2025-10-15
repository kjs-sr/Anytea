<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>정보글 수정 목록</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">
    <div class="max-w-4xl mx-auto bg-white p-8 rounded-lg shadow-md">
        <h1 class="text-3xl font-bold mb-6 border-b pb-4">정보글 수정 목록</h1>
        
        <c:if test="${not empty sessionScope.message}">
            <div class="bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded relative mb-4" role="alert">
                <span class="block sm:inline">${sessionScope.message}</span>
            </div>
            <% session.removeAttribute("message"); %>
        </c:if>

        <div class="space-y-4">
            <c:choose>
                <c:when test="${not empty postList}">
                    <table class="min-w-full bg-white">
                        <thead class="bg-gray-200">
                            <tr>
                                <th class="w-1/6 py-3 px-4 uppercase font-semibold text-sm text-left">글 번호</th>
                                <th class="w-3/6 py-3 px-4 uppercase font-semibold text-sm text-left">제목</th>
                                <th class="w-1/6 py-3 px-4 uppercase font-semibold text-sm text-center">태그</th>
                                <th class="w-1/6 py-3 px-4 uppercase font-semibold text-sm text-center">수정</th>
                            </tr>
                        </thead>
                        <tbody class="text-gray-700">
                            <c:forEach var="post" items="${postList}">
                                <tr class="border-b">
                                    <td class="py-3 px-4">${post.infoNo}</td>
                                    <td class="py-3 px-4">${post.title}</td>
                                    <td class="py-3 px-4 text-center">
                                        <span class="text-xs px-2 py-1 rounded-full ${post.division == 'INTRO' ? 'bg-purple-200 text-purple-800' : 'bg-green-200 text-green-800'}">${post.division}</span>
                                        <span class="text-xs bg-gray-200 text-gray-800 px-2 py-1 rounded-full">${post.tagTea}</span>
                                    </td>
                                    <td class="py-3 px-4 text-center">
                                        <a href="${pageContext.request.contextPath}/editInfoPost?action=form&no=${post.infoNo}" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                                            수정
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p class="text-center text-gray-500">등록된 정보글이 없습니다.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
