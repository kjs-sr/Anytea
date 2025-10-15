<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 수정 - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.css" rel="stylesheet">
    <style> body { font-family: 'Noto Sans KR', sans-serif; } </style>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">
    
    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <%-- [수정] 메뉴가 없는 중앙 정렬 레이아웃으로 변경 --%>
    <div class="w-full max-w-[2100px] mx-auto px-6 mt-8 flex-grow">
        <div class="flex justify-center gap-6">
            <%-- 왼쪽 여백 --%>
            <div class="hidden lg:block w-44 flex-shrink-0"></div>

            <main class="min-w-0 lg:flex-1">
                <div class="bg-white p-8 rounded-lg shadow-md">
                    <h1 class="text-3xl font-bold mb-6 border-b pb-4">게시글 수정</h1>
                
                    <form action="${pageContext.request.contextPath}/postAction" method="post" class="space-y-6">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="postNo" value="${post.postNo}">

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div>
                                <label for="tag_main" class="block text-sm font-medium text-gray-700">카테고리</label>
                                <select id="tag_main" name="tag_main" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm">
                                    <option value="정보" ${post.tagMain == '정보' ? 'selected' : ''}>정보</option>
                                    <option value="추천" ${post.tagMain == '추천' ? 'selected' : ''}>추천</option>
                                    <option value="리뷰" ${post.tagMain == '리뷰' ? 'selected' : ''}>리뷰</option>
                                </select>
                            </div>
                             <div>
                                <label for="tag_tea" class="block text-sm font-medium text-gray-700">차 종류</label>
                                <select id="tag_tea" name="tag_tea" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm">
                                    <option value="">-- 선택 안함 --</option>
                                    <option value="녹차" ${post.tagTea == '녹차' ? 'selected' : ''}>녹차</option>
                                    <option value="청차" ${post.tagTea == '청차' ? 'selected' : ''}>청차</option>
                                    <option value="홍차" ${post.tagTea == '홍차' ? 'selected' : ''}>홍차</option>
                                    <option value="흑차" ${post.tagTea == '흑차' ? 'selected' : ''}>흑차</option>
                                    <option value="백차" ${post.tagTea == '백차' ? 'selected' : ''}>백차</option>
                                    <option value="대용차" ${post.tagTea == '대용차' ? 'selected' : ''}>대용차</option>
                                </select>
                            </div>
                            <div>
                                <label for="tag_region" class="block text-sm font-medium text-gray-700">지역</label>
                                <select id="tag_region" name="tag_region" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm">
                                    <option value="">-- 선택 안함 --</option>
                                    <option value="아시아" ${post.tagRegion == '아시아' ? 'selected' : ''}>아시아</option>
                                    <option value="유럽" ${post.tagRegion == '유럽' ? 'selected' : ''}>유럽</option>
                                    <option value="아메리카" ${post.tagRegion == '아메리카' ? 'selected' : ''}>아메리카</option>
                                    <option value="아프리카" ${post.tagRegion == '아프리카' ? 'selected' : ''}>아프리카</option>
                                </select>
                            </div>
                        </div>

                        <div>
                            <label for="title" class="block text-sm font-medium text-gray-700">제목</label>
                            <input type="text" id="title" name="title" value="${post.title}" class="mt-1 block w-full py-2 px-3 border border-gray-300 rounded-md shadow-sm" required>
                        </div>

                        <div>
                            <label for="contents" class="block text-sm font-medium text-gray-700">내용</label>
                            <textarea id="summernote" name="contents">${post.contents}</textarea>
                        </div>

                        <div class="flex justify-end space-x-4">
                             <a href="javascript:history.back()" class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded">취소</a>
                            <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded">수정 완료</button>
                        </div>
                    </form>
                </div>
            </main>
            
            <%-- 오른쪽 여백 --%>
            <div class="hidden lg:block w-44 flex-shrink-0"></div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/include/footer.jsp" />
    
    <script>
        $(document).ready(function() {
            $('#summernote').summernote({ height: 400, lang: "ko-KR" });
        });
    </script>
</body>
</html>

